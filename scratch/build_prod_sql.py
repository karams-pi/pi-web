import openpyxl
import os
import psycopg2

def generate_sql():
    wb = openpyxl.load_workbook('Docs/TABELA LIVINTUS_EXPORTAÇÃO_MOVELSUL_2026.xlsx')
    sheet = wb['LIVINTUS COURO']

    img_sofa = None
    img_olden_polt = None
    img_luna_polt = None

    for img in sheet._images:
        row = img.anchor._from.row + 1
        if row == 148:
            img_sofa = img._data().hex()
        elif row == 162:
            img_olden_polt = img._data().hex()
        elif row == 166:
            img_luna_polt = img._data().hex()

    lines = []
    lines.append("-- ==========================================================================")
    lines.append("-- INSERÇÃO DE PREÇOS E MÓDULOS LIVINTUS (MOVELSUL 2026)")
    lines.append("-- Modelos: SOFÁ OLDEN (1,50m e 1,80m), POLTRONA OLDEN e POLTRONA LUNA")
    lines.append("-- Destinado à base de Produção (resolve IDs dinamicamente via subqueries)")
    lines.append("-- ==========================================================================\n")
    lines.append("BEGIN TRANSACTION;\n")

    lines.append("-- --------------------------------------------------------------------------")
    lines.append("-- 1. LIMPEZA PREVENTIVA DE REGISTROS INCORRETOS")
    lines.append("-- (Remove registros criados erroneamente sob BANDINI ou CONDOR com as medidas")
    lines.append("-- de Olden e Luna, caso o script preliminar tenha sido executado)")
    lines.append("-- --------------------------------------------------------------------------")
    lines.append("""DELETE FROM pi.modulo_tecido 
WHERE id_modulo IN (
    SELECT m.id FROM pi.modulo m
    JOIN pi.marca ma ON m.id_marca = ma.id
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'LIVINTUS' LIMIT 1)
      AND (
          (ma.nome = 'BANDINI' AND m.profundidade = 0.84 AND m.altura = 0.73 AND m.largura IN (1.50, 1.80))
          OR
          (ma.nome = 'CONDOR' AND m.profundidade = 0.84 AND m.largura IN (0.86, 0.80))
      )
);

DELETE FROM pi.modulo 
WHERE id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'LIVINTUS' LIMIT 1)
  AND (
      (id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'BANDINI' LIMIT 1) AND profundidade = 0.84 AND altura = 0.73 AND largura IN (1.50, 1.80))
      OR
      (id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'CONDOR' LIMIT 1) AND profundidade = 0.84 AND largura IN (0.86, 0.80))
  );
""")

    lines.append("-- --------------------------------------------------------------------------")
    lines.append("-- 2. GARANTIR A EXISTÊNCIA DAS MARCAS / MODELOS")
    lines.append("-- --------------------------------------------------------------------------")
    lines.append("INSERT INTO pi.marca (nome, fl_ativo) SELECT 'OLDEN', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'OLDEN');")
    lines.append("INSERT INTO pi.marca (nome, fl_ativo) SELECT 'POLTRONA OLDEN', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'POLTRONA OLDEN');")
    lines.append("INSERT INTO pi.marca (nome, fl_ativo) SELECT 'POLTRONA LUNA', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'POLTRONA LUNA');\n")

    lines.append("-- --------------------------------------------------------------------------")
    lines.append("-- 3. GARANTIR A EXISTÊNCIA DOS TECIDOS / COUROS")
    lines.append("-- --------------------------------------------------------------------------")
    lines.append("INSERT INTO pi.tecido (nome) SELECT 'CO-5' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = 'CO-5');")
    lines.append("INSERT INTO pi.tecido (nome) SELECT 'CO-6' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = 'CO-6');")
    lines.append("INSERT INTO pi.tecido (nome) SELECT 'CO-7' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = 'CO-7');")
    lines.append("INSERT INTO pi.tecido (nome) SELECT 'TC/ST' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = 'TC/ST');\n")

    # Helper function to generate module insert/update and prices
    def build_module_sql(marca_nome, desc, larg, prof, alt, m3, prices, label):
        m_lines = []
        m_lines.append(f"-- ==========================================================================")
        m_lines.append(f"-- {label}")
        m_lines.append(f"-- Medidas: Largura {larg:.2f}m | Profundidade {prof:.2f}m | Altura {alt:.2f}m | M³ {m3:.2f}")
        m_lines.append(f"-- ==========================================================================")
        
        # Insert modulo if not exists
        m_lines.append(f"""INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)
SELECT 
    (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'LIVINTUS' LIMIT 1),
    (SELECT id FROM pi.categoria WHERE UPPER(nome) = 'LIVINTUS' LIMIT 1),
    (SELECT id FROM pi.marca WHERE UPPER(nome) = '{marca_nome.upper()}' LIMIT 1),
    '{desc}',
    {larg:.2f},
    {prof:.2f},
    {alt:.2f},
    0.00
WHERE NOT EXISTS (
    SELECT 1 FROM pi.modulo m
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'LIVINTUS' LIMIT 1)
      AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = '{marca_nome.upper()}' LIMIT 1)
      AND m.descricao = '{desc}'
      AND m.largura = {larg:.2f}
);""")

        # Update dimensions if already existed
        m_lines.append(f"""UPDATE pi.modulo
SET profundidade = {prof:.2f}, altura = {alt:.2f}, pa = 0.00
WHERE id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'LIVINTUS' LIMIT 1)
  AND id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = '{marca_nome.upper()}' LIMIT 1)
  AND descricao = '{desc}'
  AND largura = {larg:.2f};\n""")

        # Upsert prices
        for tec_nome, preco in prices:
            m_lines.append(f"-- Preço {tec_nome}: R$ {preco:.2f}")
            m_lines.append(f"""UPDATE pi.modulo_tecido mt
SET valor_tecido = {preco:.3f}, dt_ultima_revisao = NOW()
WHERE mt.id_modulo = (
    SELECT m.id FROM pi.modulo m
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'LIVINTUS' LIMIT 1)
      AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = '{marca_nome.upper()}' LIMIT 1)
      AND m.descricao = '{desc}'
      AND m.largura = {larg:.2f}
    LIMIT 1
)
AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = '{tec_nome.upper()}' LIMIT 1)
AND mt.fl_ativo = true;

INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
SELECT 
    (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'LIVINTUS' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = '{marca_nome.upper()}' LIMIT 1)
          AND m.descricao = '{desc}'
          AND m.largura = {larg:.2f}
        LIMIT 1
    ),
    (SELECT id FROM pi.tecido WHERE UPPER(nome) = '{tec_nome.upper()}' LIMIT 1),
    {preco:.3f},
    true,
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM pi.modulo_tecido mt
    WHERE mt.id_modulo = (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'LIVINTUS' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = '{marca_nome.upper()}' LIMIT 1)
          AND m.descricao = '{desc}'
          AND m.largura = {larg:.2f}
        LIMIT 1
    )
    AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = '{tec_nome.upper()}' LIMIT 1)
    AND mt.fl_ativo = true
);
""")
        return "\n".join(m_lines)

    # 1. Sofá OLDEN 1.50m
    lines.append(build_module_sql(
        marca_nome='OLDEN',
        desc='PEÇA ÚNICA',
        larg=1.50,
        prof=0.84,
        alt=0.73,
        m3=0.92,
        prices=[
            ('CO-5', 2005.00),
            ('CO-6', 2110.00),
            ('CO-7', 2195.00),
            ('TC/ST', 1350.00)
        ],
        label='MÓDULO: SOFÁ OLDEN 1,50M (PEÇA ÚNICA)'
    ))

    # 2. Sofá OLDEN 1.80m
    lines.append(build_module_sql(
        marca_nome='OLDEN',
        desc='PEÇA ÚNICA',
        larg=1.80,
        prof=0.84,
        alt=0.73,
        m3=1.10,
        prices=[
            ('CO-5', 2280.00),
            ('CO-6', 2405.00),
            ('CO-7', 2505.00),
            ('TC/ST', 1460.00)
        ],
        label='MÓDULO: SOFÁ OLDEN 1,80M (PEÇA ÚNICA)'
    ))

    # 3. Poltrona OLDEN 0.86m
    lines.append(build_module_sql(
        marca_nome='POLTRONA OLDEN',
        desc='POLTRONA GIRATÓRIA',
        larg=0.86,
        prof=0.84,
        alt=0.73,
        m3=0.53,
        prices=[
            ('CO-5', 1480.00),
            ('CO-6', 1550.00),
            ('CO-7', 1605.00)
        ],
        label='MÓDULO: POLTRONA OLDEN 0,86M (POLTRONA GIRATÓRIA)'
    ))

    # 4. Poltrona LUNA 0.80m
    lines.append(build_module_sql(
        marca_nome='POLTRONA LUNA',
        desc='POLTRONA GIRATÓRIA',
        larg=0.80,
        prof=0.84,
        alt=0.77,
        m3=0.52,
        prices=[
            ('CO-5', 1520.00),
            ('CO-6', 1595.00),
            ('CO-7', 1655.00)
        ],
        label='MÓDULO: POLTRONA LUNA 0,80M (POLTRONA GIRATÓRIA)'
    ))

    # 5. Imagens das marcas (opcional mas extremamente recomendado para os relatórios e catálogo)
    lines.append("-- --------------------------------------------------------------------------")
    lines.append("-- 4. ATUALIZAÇÃO DAS FOTOS DOS MODELOS (EXTRAÍDAS DIRETAMENTE DA PLANILHA)")
    lines.append("-- --------------------------------------------------------------------------")
    if img_sofa:
        lines.append(f"-- Foto Sofá OLDEN")
        lines.append(f"UPDATE pi.marca SET imagem = decode('{img_sofa}', 'hex') WHERE UPPER(nome) = 'OLDEN';\n")
    if img_olden_polt:
        lines.append(f"-- Foto Poltrona OLDEN")
        lines.append(f"UPDATE pi.marca SET imagem = decode('{img_olden_polt}', 'hex') WHERE UPPER(nome) = 'POLTRONA OLDEN';\n")
    if img_luna_polt:
        lines.append(f"-- Foto Poltrona LUNA")
        lines.append(f"UPDATE pi.marca SET imagem = decode('{img_luna_polt}', 'hex') WHERE UPPER(nome) = 'POLTRONA LUNA';\n")

    lines.append("COMMIT;")

    sql_text = "\n".join(lines)

    os.makedirs('Docs', exist_ok=True)
    out_file = 'Docs/insert_precos_olden_luna.sql'
    with open(out_file, 'w', encoding='utf-8') as f:
        f.write(sql_text)

    print(f"Generated SQL script successfully: {out_file} (Size: {len(sql_text)} chars)")
    return out_file, sql_text

if __name__ == '__main__':
    generate_sql()
