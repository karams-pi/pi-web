import psycopg2

def generate():
    try:
        conn = psycopg2.connect(
            host="localhost",
            port=5432,
            database="pi_db",
            user="pi",
            password="pi123"
        )
        cur = conn.cursor()
        
        # Query all sub_modulo records along with the names of modulo/tecido to make them dynamic
        cur.execute("""
            SELECT 
                ma.nome as marca_nome,
                m.descricao as mod_desc,
                m.largura as mod_larg,
                m.id_fornecedor,
                t.nome as tecido_base_nome,
                sm.codigo,
                sm.descricao_produto,
                sm.tecido_especifico,
                sm.volume_m3
            FROM pi.sub_modulo sm
            JOIN pi.modulo m ON sm.id_modulo = m.id
            JOIN pi.marca ma ON m.id_marca = ma.id
            JOIN pi.tecido t ON sm.id_tecido_base = t.id
            ORDER BY sm.id
        """)
        rows = cur.fetchall()
        print(f"Fetched {len(rows)} sub_modulos from local DB to generate SQL.")
        
        sql_lines = []
        sql_lines.append("-- SCRIPT DE POPULAÇÃO DE SUBMÓDULOS FERGUILE PARA PRODUÇÃO")
        sql_lines.append("-- Gerado dinamicamente para resolver IDs via subqueries (independente de chaves autoincremento)\n")
        sql_lines.append("BEGIN TRANSACTION;\n")
        sql_lines.append("DELETE FROM pi.sub_modulo;\n")
        
        # Cache of already added tecidos to prevent duplicate inserts in same transaction
        tecidos_added = set()
        
        for r in rows:
            marca = r[0].replace("'", "''")
            mod_desc = r[1].replace("'", "''")
            larg = r[2]
            forn_id = r[3]
            tec_base = r[4].replace("'", "''")
            code = r[5].replace("'", "''")
            desc_prod = r[6].replace("'", "''")
            tec_esp = r[7].replace("'", "''")
            vol = r[8]
            
            # Ensure the base fabric line exists in production
            tec_base_norm = tec_base.upper().strip()
            if tec_base_norm not in tecidos_added:
                sql_lines.append(f"INSERT INTO pi.tecido (nome) SELECT '{tec_base}' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = '{tec_base_norm}');")
                tecidos_added.add(tec_base_norm)
            
            # Insert the sub_modulo resolving the id_modulo and id_tecido_base dynamically
            sql_lines.append(
                f"INSERT INTO pi.sub_modulo (id_modulo, id_tecido_base, codigo, descricao_produto, tecido_especifico, volume_m3, fl_ativo) "
                f"SELECT m.id, t.id, '{code}', '{desc_prod}', '{tec_esp}', {vol}, true "
                f"FROM pi.modulo m "
                f"JOIN pi.marca ma ON m.id_marca = ma.id "
                f"CROSS JOIN pi.tecido t "
                f"WHERE ma.nome = '{r[0]}' "
                f"  AND m.descricao = '{r[1]}' "
                f"  AND m.largura = {larg} "
                f"  AND m.id_fornecedor = {forn_id} "
                f"  AND t.nome = '{r[4]}' "
                f"LIMIT 1;"
            )
            
        sql_lines.append("\nCOMMIT;")
        
        with open("seed_sub_modulos_prod.sql", "w", encoding="utf-8") as f:
            f.write("\n".join(sql_lines))
            
        print("Production SQL seed script generated successfully: seed_sub_modulos_prod.sql")
        
        cur.close()
        conn.close()
    except Exception as e:
        print("Error generating production SQL:", e)

if __name__ == "__main__":
    generate()
