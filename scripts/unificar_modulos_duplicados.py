"""
Script para detecção e unificação de módulos duplicados no banco de dados pi_db.
Critérios de detecção:
  1. Mesmo fornecedor (id_fornecedor)
  2. Mesma marca/modelo (id_marca)
  3. Mesma largura (ou variação com typo reconhecível)
  4. Mesmos tecidos e preços ativos (ou compatíveis)
  5. Descrições semanticamente equivalentes (desconsiderando quebras de linha \\n,
     espaçamentos múltiplos, prefixo da marca repetido, maiúsculas/minúsculas e acentuação).

Modos de operação:
  --verificar (padrão): apenas lista as duplicidades e propostas de unificação (Dry-Run).
  --executar: executa a unificação no banco de dados em uma transação segura.
  --gerar-sql: gera um arquivo .sql pronto para aplicação local ou em produção (Render).
"""

import os
import sys
import argparse
import re
import unicodedata
from collections import defaultdict
import psycopg2
from psycopg2.extras import DictCursor

def normalizar_texto(texto, marca=""):
    if not texto:
        return ""
    # Se o nome da marca estiver prefixado na descrição (ex: 'BAROLO - '), removemos
    if marca:
        b_clean = re.escape(marca.strip())
        texto = re.sub(r"^" + b_clean + r"\s*[-–—:]*\s*", "", texto, flags=re.IGNORECASE)
    # Remove acentos
    texto = unicodedata.normalize('NFKD', texto).encode('ASCII', 'ignore').decode('ASCII')
    # Substitui quebras de linha e múltiplos espaços por um espaço único
    texto = re.sub(r'[\r\n\t]+', ' ', texto)
    texto = re.sub(r'\s+', ' ', texto)
    return texto.strip().lower()

def compactar_texto(texto, marca=""):
    norm = normalizar_texto(texto, marca)
    return re.sub(r'[^a-z0-9]', '', norm)

def limpar_descricao_legivel(desc):
    """Gera uma descrição limpa, substituindo quebras de linha \n por espaço e removendo espaços duplicados."""
    if not desc:
        return ""
    texto = re.sub(r'[\r\n]+', ' ', desc)
    texto = re.sub(r'\s+', ' ', texto).strip()
    return texto

def conectar_bd():
    # Permite ler variáveis de ambiente ou usar padrão local docker
    host = os.getenv("DB_HOST", "localhost")
    port = os.getenv("DB_PORT", "5432")
    dbname = os.getenv("DB_NAME", "pi_db")
    user = os.getenv("DB_USER", "pi")
    password = os.getenv("DB_PASSWORD", "pi123")
    
    return psycopg2.connect(
        host=host, port=port, dbname=dbname, user=user, password=password
    )

def carregar_dados(cur, filtro_fornecedor=None, filtro_marca=None):
    query_mod = """
        SELECT 
            m.id, 
            m.id_fornecedor, 
            f.nome as fornecedor_nome,
            m.id_marca, 
            ma.nome as marca_nome,
            m.descricao,
            m.largura,
            m.profundidade,
            m.altura,
            m.pa,
            m.m3
        FROM pi.modulo m
        JOIN pi.fornecedor f ON m.id_fornecedor = f.id
        JOIN pi.marca ma ON m.id_marca = ma.id
        WHERE 1=1
    """
    params = []
    if filtro_fornecedor:
        if filtro_fornecedor.isdigit():
            query_mod += " AND m.id_fornecedor = %s"
            params.append(int(filtro_fornecedor))
        else:
            query_mod += " AND f.nome ILIKE %s"
            params.append(f"%{filtro_fornecedor}%")
    if filtro_marca:
        query_mod += " AND ma.nome ILIKE %s"
        params.append(f"%{filtro_marca}%")

    query_mod += " ORDER BY m.id_fornecedor, m.id_marca, m.largura, m.id;"
    cur.execute(query_mod, params)
    modules = cur.fetchall()

    # Preços ativos
    cur.execute("""
        SELECT mt.id, mt.id_modulo, mt.id_tecido, t.nome as tecido_nome, mt.valor_tecido
        FROM pi.modulo_tecido mt
        JOIN pi.tecido t ON mt.id_tecido = t.id
        WHERE mt.fl_ativo = true;
    """)
    active_fabrics = {} # id_modulo -> dict of {tecido_nome: (mt_id, id_tecido, valor)}
    for mt_id, mod_id, tec_id, tec_nome, val in cur.fetchall():
        if mod_id not in active_fabrics:
            active_fabrics[mod_id] = {}
        active_fabrics[mod_id][tec_nome] = {
            "mt_id": mt_id,
            "id_tecido": tec_id,
            "valor": round(float(val), 2)
        }

    # Referências em sub_modulo
    cur.execute("SELECT id_modulo, count(*) FROM pi.sub_modulo GROUP BY id_modulo;")
    sub_refs = dict(cur.fetchall())

    # Referências em pi_item
    cur.execute("""
        SELECT mt.id_modulo, count(pi.id)
        FROM pi.pi_item pi
        JOIN pi.modulo_tecido mt ON pi.id_modulo_tecido = mt.id
        GROUP BY mt.id_modulo;
    """)
    pi_refs = dict(cur.fetchall())

    return modules, active_fabrics, sub_refs, pi_refs

def detectar_duplicados(modules, active_fabrics, sub_refs, pi_refs, incluir_largura_divergente=False):
    by_forn_marca = defaultdict(list)
    for m in modules:
        by_forn_marca[(m[1], m[3])].append(m)

    duplicados = []

    for (forn_id, marca_id), mlist in by_forn_marca.items():
        if len(mlist) < 2:
            continue
        
        # Comparação em pares
        for i in range(len(mlist)):
            for j in range(i + 1, len(mlist)):
                m1 = mlist[i]
                m2 = mlist[j]

                p1 = active_fabrics.get(m1[0], {})
                p2 = active_fabrics.get(m2[0], {})

                # Ambos devem ter tecidos ativos
                if not p1 or not p2:
                    continue

                # Mesmos tecidos e mesmos valores
                p1_vals = {k: v['valor'] for k, v in p1.items()}
                p2_vals = {k: v['valor'] for k, v in p2.items()}
                if set(p1_vals.keys()) != set(p2_vals.keys()):
                    continue
                if not all(abs(p1_vals[k] - p2_vals[k]) < 0.05 for k in p1_vals):
                    continue

                larg1 = float(m1[6])
                larg2 = float(m2[6])
                mesma_largura = abs(larg1 - larg2) < 0.01

                c1 = compactar_texto(m1[5], m1[4])
                c2 = compactar_texto(m2[5], m2[4])
                mesmo_texto_compacto = (c1 == c2 and len(c1) > 0)

                eh_duplicado = False
                motivo = ""

                if mesma_largura and mesmo_texto_compacto:
                    eh_duplicado = True
                    motivo = "Mesma largura, mesmos preços e descrição idêntica (após normalização)"
                elif mesma_largura and (c1 in c2 or c2 in c1 or "modulo" in c1 or "modulo" in c2):
                    eh_duplicado = True
                    motivo = "Mesma largura, mesmos preços e descrições variantes do mesmo módulo"
                elif incluir_largura_divergente and not mesma_largura:
                    # Caso de typo na largura (ex: 11.08m vs 1.08m ou 10.75m vs 0.75m)
                    if (abs(larg2 - (larg1 + 10.0)) < 0.01 or abs(larg1 - (larg2 + 10.0)) < 0.01):
                        eh_duplicado = True
                        motivo = f"Typo detectado na largura ({larg1:.2f}m vs {larg2:.2f}m) com mesmos preços e marca"

                if eh_duplicado:
                    # Escolha do Canônico (Módulo a MANTER) vs Duplicado (a REMOVER):
                    # Critério 1: Módulo que já possui referências em sub_modulo ou pi_item tem prioridade para evitar alterações
                    sub1 = sub_refs.get(m1[0], 0)
                    sub2 = sub_refs.get(m2[0], 0)
                    pi1 = pi_refs.get(m1[0], 0)
                    pi2 = pi_refs.get(m2[0], 0)
                    refs1 = sub1 + pi1
                    refs2 = sub2 + pi2

                    if refs1 > 0 and refs2 == 0:
                        manter = m1
                        remover = m2
                    elif refs2 > 0 and refs1 == 0:
                        manter = m2
                        remover = m1
                    else:
                        # Se nenhum ou ambos tiverem referências, preferir o que não tem quebra de linha \n na descrição
                        has_nl1 = "\n" in m1[5] or "\r" in m1[5]
                        has_nl2 = "\n" in m2[5] or "\r" in m2[5]
                        if not has_nl1 and has_nl2:
                            manter = m1
                            remover = m2
                        elif not has_nl2 and has_nl1:
                            manter = m2
                            remover = m1
                        else:
                            # Preferir menor ID (mais antigo)
                            manter = m1 if m1[0] < m2[0] else m2
                            remover = m2 if m1[0] < m2[0] else m1

                    # Melhor descrição para o módulo mantido (sem \n e limpa)
                    desc_proposta = manter[5]
                    if "\n" in desc_proposta or "\r" in desc_proposta:
                        # Se o outro módulo tinha uma descrição sem \n, não genérica e com conteúdo equivalente
                        if "\n" not in remover[5] and "\r" not in remover[5] and not remover[5].endswith("- MÓDULOS"):
                            desc_proposta = remover[5]
                        else:
                            desc_proposta = limpar_descricao_legivel(desc_proposta)

                    duplicados.append({
                        "fornecedor": m1[2],
                        "marca": m1[4],
                        "motivo": motivo,
                        "manter_id": manter[0],
                        "manter_desc": manter[5],
                        "manter_larg": float(manter[6]),
                        "manter_prof": float(manter[7]),
                        "manter_alt": float(manter[8]),
                        "manter_m3": float(manter[10]),
                        "manter_refs_sub": sub_refs.get(manter[0], 0),
                        "manter_refs_pi": pi_refs.get(manter[0], 0),
                        "remover_id": remover[0],
                        "remover_desc": remover[5],
                        "remover_larg": float(remover[6]),
                        "remover_prof": float(remover[7]),
                        "remover_alt": float(remover[8]),
                        "remover_m3": float(remover[10]),
                        "remover_refs_sub": sub_refs.get(remover[0], 0),
                        "remover_refs_pi": pi_refs.get(remover[0], 0),
                        "desc_ajustada": desc_proposta,
                        "precos": p1_vals
                    })

    return duplicados

def imprimir_relatorio(duplicados):
    print("\n" + "=" * 90)
    print(f" RELATÓRIO DE DUPLICIDADES ENCONTRADAS: {len(duplicados)} PARES")
    print("=" * 90)

    if not duplicados:
        print("\nNenhum módulo duplicado encontrado com os filtros e critérios especificados.\n")
        return

    for i, dup in enumerate(duplicados, 1):
        print(f"\n[{i:02d}] Fornecedor: {dup['fornecedor']} | Marca: {dup['marca']}")
        print(f"     Motivo: {dup['motivo']}")
        print(f"     Preços: {dup['precos']}")
        print(f"     -> MANTER (ID {dup['manter_id']}): {repr(dup['manter_desc'])}")
        print(f"        Dimensões: {dup['manter_larg']:.2f} x {dup['manter_prof']:.2f} x {dup['manter_alt']:.2f} (M³: {dup['manter_m3']:.2f})")
        print(f"        Vínculos Atuais: {dup['manter_refs_sub']} em sub_modulo | {dup['manter_refs_pi']} em pi_item")
        print(f"     -> REMOVER (ID {dup['remover_id']}): {repr(dup['remover_desc'])}")
        print(f"        Dimensões: {dup['remover_larg']:.2f} x {dup['remover_prof']:.2f} x {dup['remover_alt']:.2f} (M³: {dup['remover_m3']:.2f})")
        print(f"        Vínculos que serão migrados: {dup['remover_refs_sub']} em sub_modulo | {dup['remover_refs_pi']} em pi_item")
        if dup['desc_ajustada'] != dup['manter_desc']:
            print(f"        * Descrição proposta para o mantido: {repr(dup['desc_ajustada'])}")

def gerar_script_sql(duplicados, output_file="Docs/unificar_modulos_duplicados.sql"):
    lines = []
    lines.append("-- ==========================================================================")
    lines.append("-- UNIFICAÇÃO DE MÓDULOS DUPLICADOS NO BANCO DE DADOS (pi_db)")
    lines.append(f"-- Total de módulos a unificar: {len(duplicados)}")
    lines.append("-- ==========================================================================\n")
    lines.append("BEGIN TRANSACTION;\n")

    for i, dup in enumerate(duplicados, 1):
        mid_keep = dup['manter_id']
        mid_rem = dup['remover_id']
        lines.append(f"-- --------------------------------------------------------------------------")
        lines.append(f"-- [{i:02d}] {dup['fornecedor']} - {dup['marca']} | Manter ID {mid_keep} <- Mesclar ID {mid_rem}")
        lines.append(f"-- --------------------------------------------------------------------------")
        
        # 1. Ajuste da descrição do módulo mantido se tiver quebra de linha
        if dup['desc_ajustada'] != dup['manter_desc']:
            desc_escaped = dup['desc_ajustada'].replace("'", "''")
            lines.append(f"UPDATE pi.modulo SET descricao = '{desc_escaped}' WHERE id = {mid_keep};")

        # 2. Migração de sub_modulo
        lines.append(f"UPDATE pi.sub_modulo SET id_modulo = {mid_keep} WHERE id_modulo = {mid_rem};")

        # 3. Migração de pi_item (se algum item de PI apontar para o modulo_tecido que será removido)
        lines.append(f"""UPDATE pi.pi_item p
SET id_modulo_tecido = mt_keep.id
FROM pi.modulo_tecido mt_rem
JOIN pi.modulo_tecido mt_keep 
  ON mt_keep.id_modulo = {mid_keep} 
 AND mt_keep.id_tecido = mt_rem.id_tecido 
 AND mt_keep.fl_ativo = true
WHERE p.id_modulo_tecido = mt_rem.id 
  AND mt_rem.id_modulo = {mid_rem};""")

        # 4. Exclusão dos preços do módulo duplicado
        lines.append(f"DELETE FROM pi.modulo_tecido WHERE id_modulo = {mid_rem};")

        # 5. Exclusão do módulo duplicado
        lines.append(f"DELETE FROM pi.modulo WHERE id = {mid_rem};\n")

    lines.append("COMMIT;")
    
    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("\n".join(lines))
    print(f"\n[OK] Script SQL gerado com sucesso: {output_file}")

def executar_unificacao(conn, duplicados):
    if not duplicados:
        print("\nNenhum módulo duplicado para unificar.")
        return

    cur = conn.cursor()
    try:
        cur.execute("BEGIN;")
        print("\nExecutando unificação no banco de dados...")
        
        for i, dup in enumerate(duplicados, 1):
            mid_keep = dup['manter_id']
            mid_rem = dup['remover_id']

            # 1. Atualiza descrição do módulo mantido se necessário
            if dup['desc_ajustada'] != dup['manter_desc']:
                cur.execute(
                    "UPDATE pi.modulo SET descricao = %s WHERE id = %s;",
                    (dup['desc_ajustada'], mid_keep)
                )

            # 2. Migra sub_modulo
            cur.execute(
                "UPDATE pi.sub_modulo SET id_modulo = %s WHERE id_modulo = %s;",
                (mid_keep, mid_rem)
            )

            # 3. Migra pi_item
            cur.execute("""
                UPDATE pi.pi_item p
                SET id_modulo_tecido = mt_keep.id
                FROM pi.modulo_tecido mt_rem
                JOIN pi.modulo_tecido mt_keep 
                  ON mt_keep.id_modulo = %s 
                 AND mt_keep.id_tecido = mt_rem.id_tecido 
                 AND mt_keep.fl_ativo = true
                WHERE p.id_modulo_tecido = mt_rem.id 
                  AND mt_rem.id_modulo = %s;
            """, (mid_keep, mid_rem))

            # 4. Remove modulo_tecido do duplicado
            cur.execute("DELETE FROM pi.modulo_tecido WHERE id_modulo = %s;", (mid_rem,))

            # 5. Remove modulo duplicado
            cur.execute("DELETE FROM pi.modulo WHERE id = %s;", (mid_rem,))

        cur.execute("COMMIT;")
        print(f"[SUCESSO] {len(duplicados)} módulos duplicados unificados e removidos com sucesso!")

    except Exception as e:
        cur.execute("ROLLBACK;")
        print(f"[ERRO] Falha ao executar unificação. Transação revertida (ROLLBACK): {e}")
        raise e

def main():
    parser = argparse.ArgumentParser(description="Verificar e unificar módulos duplicados.")
    parser.add_argument("--verificar", action="store_true", default=True, help="Apenas auditar e listar duplicados (default)")
    parser.add_argument("--executar", action="store_true", help="Executar unificação no banco de dados")
    parser.add_argument("--gerar-sql", action="store_true", help="Gerar arquivo SQL com script de unificação")
    parser.add_argument("--output-sql", default="Docs/unificar_modulos_duplicados.sql", help="Caminho do arquivo SQL a ser gerado")
    parser.add_argument("--fornecedor", help="Filtrar por nome ou ID do fornecedor (ex: Livintus)")
    parser.add_argument("--marca", help="Filtrar por nome da marca (ex: BAROLO)")
    parser.add_argument("--incluir-largura-divergente", action="store_true", help="Incluir casos com typo na largura (ex: 11.08m vs 1.08m)")

    args = parser.parse_args()

    # Se especificou executar ou gerar-sql, desativa o modo apenas verificar
    modo_executar = args.executar
    modo_gerar_sql = args.gerar_sql
    modo_apenas_verificar = not modo_executar and not modo_gerar_sql

    conn = conectar_bd()
    cur = conn.cursor()

    modules, active_fabrics, sub_refs, pi_refs = carregar_dados(cur, args.fornecedor, args.marca)
    duplicados = detectar_duplicados(modules, active_fabrics, sub_refs, pi_refs, args.incluir_largura_divergente)

    imprimir_relatorio(duplicados)

    if modo_gerar_sql or modo_executar:
        gerar_script_sql(duplicados, args.output_sql)

    if modo_executar:
        executar_unificacao(conn, duplicados)

if __name__ == '__main__':
    main()
