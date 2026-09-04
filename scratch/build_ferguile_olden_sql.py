import psycopg2

def build_sql():
    conn = psycopg2.connect('host=localhost port=5432 dbname=pi_db user=pi password=pi123')
    cur = conn.cursor()

    cur.execute("SELECT nome, encode(imagem, 'hex') FROM pi.marca WHERE nome IN ('OLDEN', 'POLTRONA OLDEN');")
    images = dict(cur.fetchall())
    img_sofa = images.get('OLDEN')
    img_poltrona = images.get('POLTRONA OLDEN')

    lines = []
    lines.append("-- ==========================================================================")
    lines.append("-- INSERÇÃO DE MÓDULOS E PREÇOS FERGUILE: ESTOFADO OLDEN E POLTRONA OLDEN")
    lines.append("-- Itens: SOFÁ OLDEN (1,50m e 1,80m) e POLTRONA OLDEN GIRATÓRIA")
    lines.append("-- Destinado à base de Produção (resolve IDs dinamicamente via subqueries)")
    lines.append("-- ==========================================================================\n")
    lines.append("BEGIN TRANSACTION;\n")

    lines.append("-- --------------------------------------------------------------------------")
    lines.append("-- 1. GARANTIR A EXISTÊNCIA DAS MARCAS")
    lines.append("-- --------------------------------------------------------------------------")
    lines.append("INSERT INTO pi.marca (nome, fl_ativo) SELECT 'OLDEN', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'OLDEN');")
    lines.append("INSERT INTO pi.marca (nome, fl_ativo) SELECT 'POLTRONA OLDEN', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'POLTRONA OLDEN');\n")

    lines.append("-- --------------------------------------------------------------------------")
    lines.append("-- 2. GARANTIR A EXISTÊNCIA DOS TECIDOS")
    lines.append("-- --------------------------------------------------------------------------")
    for tec in ['TC-10', 'TC-12', 'TC-13', 'TC-14', 'TC-16', 'TC-18']:
        lines.append(f"INSERT INTO pi.tecido (nome) SELECT '{tec}' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = '{tec}');")
    lines.append("")

    def build_module_block(marca_nome, desc, larg, prof, alt, m3, prices, label):
        m_lines = []
        m_lines.append("-- ==========================================================================")
        m_lines.append(f"-- {label}")
        m_lines.append(f"-- Medidas: Largura {larg:.2f}m | Profundidade {prof:.2f}m | Altura {alt:.2f}m | M³ {m3:.2f}")
        m_lines.append("-- ==========================================================================")
        
        # Insert modulo if not exists
        m_lines.append(f"""INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)
SELECT 
    (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1),
    (SELECT id FROM pi.categoria WHERE UPPER(nome) = 'FERGUILE' LIMIT 1),
    (SELECT id FROM pi.marca WHERE UPPER(nome) = '{marca_nome.upper()}' LIMIT 1),
    '{desc}',
    {larg:.2f},
    {prof:.2f},
    {alt:.2f},
    0.00
WHERE NOT EXISTS (
    SELECT 1 FROM pi.modulo m
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
      AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = '{marca_nome.upper()}' LIMIT 1)
      AND m.descricao = '{desc}'
      AND m.largura = {larg:.2f}
);""")

        # Update dimensions if already existed
        m_lines.append(f"""UPDATE pi.modulo
SET profundidade = {prof:.2f}, altura = {alt:.2f}, pa = 0.00
WHERE id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
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
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
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
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
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
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
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

    # 1. POLTRONA OLDEN GIRATÓRIA
    lines.append(build_module_block(
        marca_nome='POLTRONA OLDEN',
        desc='POLTRONA GIRATÓRIA',
        larg=0.86,
        prof=0.84,
        alt=0.73,
        m3=0.53,
        prices=[
            ('TC-12', 916.85),
            ('TC-10', 943.49),
            ('TC-13', 960.21),
            ('TC-14', 980.59),
            ('TC-16', 1022.91),
            ('TC-18', 1098.68)
        ],
        label='MÓDULO: POLTRONA OLDEN 0,86M (POLTRONA GIRATÓRIA)'
    ))

    # 2. SOFÁ OLDEN 1,50M
    lines.append(build_module_block(
        marca_nome='OLDEN',
        desc='PEÇA ÚNICA',
        larg=1.50,
        prof=0.84,
        alt=0.73,
        m3=0.92,
        prices=[
            ('TC-12', 1144.98),
            ('TC-10', 1181.99),
            ('TC-13', 1205.22),
            ('TC-14', 1233.52),
            ('TC-16', 1292.30),
            ('TC-18', 1397.52)
        ],
        label='MÓDULO: SOFÁ OLDEN 1,50M (PEÇA ÚNICA)'
    ))

    # 3. SOFÁ OLDEN 1,80M
    lines.append(build_module_block(
        marca_nome='OLDEN',
        desc='PEÇA ÚNICA',
        larg=1.80,
        prof=0.84,
        alt=0.73,
        m3=1.10,
        prices=[
            ('TC-12', 1222.65),
            ('TC-10', 1264.84),
            ('TC-13', 1291.32),
            ('TC-14', 1323.58),
            ('TC-16', 1390.59),
            ('TC-18', 1510.55)
        ],
        label='MÓDULO: SOFÁ OLDEN 1,80M (PEÇA ÚNICA)'
    ))

    lines.append("-- --------------------------------------------------------------------------")
    lines.append("-- 4. ATUALIZAÇÃO / GARANTIA DAS FOTOS DOS MODELOS (BASE LIVINTUS)")
    lines.append("-- --------------------------------------------------------------------------")
    if img_sofa:
        lines.append(f"-- Foto Sofá OLDEN")
        lines.append(f"UPDATE pi.marca SET imagem = decode('{img_sofa}', 'hex') WHERE UPPER(nome) = 'OLDEN';\n")
    if img_poltrona:
        lines.append(f"-- Foto Poltrona OLDEN")
        lines.append(f"UPDATE pi.marca SET imagem = decode('{img_poltrona}', 'hex') WHERE UPPER(nome) = 'POLTRONA OLDEN';\n")

    lines.append("COMMIT;")

    sql_text = "\n".join(lines)
    out_file = 'Docs/insert_olden_ferguile.sql'
    with open(out_file, 'w', encoding='utf-8') as f:
        f.write(sql_text)
    print(f"Generated {out_file} successfully ({len(sql_text)} bytes)")

if __name__ == '__main__':
    build_sql()
