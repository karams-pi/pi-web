import psycopg2

def main():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    print("=== Verification of local DB state ===")
    
    # 1. Total brands
    cur.execute("SELECT COUNT(*) FROM pi.marca;")
    print(f"Total brands in DB: {cur.fetchone()[0]}")
    
    # 2. Total fabrics
    cur.execute("SELECT COUNT(*) FROM pi.tecido;")
    print(f"Total fabrics in DB: {cur.fetchone()[0]}")
    
    # 3. Ferguile modules and active prices
    cur.execute("SELECT COUNT(*) FROM pi.modulo WHERE id_fornecedor = 3;")
    fer_modules_count = cur.fetchone()[0]
    cur.execute("""
        SELECT COUNT(*) 
        FROM pi.modulo_tecido mt
        JOIN pi.modulo m ON mt.id_modulo = m.id
        WHERE m.id_fornecedor = 3 AND mt.fl_ativo = true;
    """)
    fer_prices_count = cur.fetchone()[0]
    print(f"Ferguile (supplier 3): Modules={fer_modules_count} (was 314), Active Prices={fer_prices_count}")
    
    # 4. Livintus modules and active prices
    cur.execute("SELECT COUNT(*) FROM pi.modulo WHERE id_fornecedor = 4;")
    liv_modules_count = cur.fetchone()[0]
    cur.execute("""
        SELECT COUNT(*) 
        FROM pi.modulo_tecido mt
        JOIN pi.modulo m ON mt.id_modulo = m.id
        WHERE m.id_fornecedor = 4 AND mt.fl_ativo = true;
    """)
    liv_prices_count = cur.fetchone()[0]
    print(f"Livintus (supplier 4): Modules={liv_modules_count} (was 343), Active Prices={liv_prices_count}")
    
    # 5. Check BALDUZZI for Ferguile (should be newly inserted)
    print("\n--- BALDUZZI (Ferguile - supplier 3) Sample Modules ---")
    cur.execute("""
        SELECT m.id, m.descricao, m.largura, m.profundidade, m.altura, m.m3, COUNT(mt.id)
        FROM pi.modulo m
        LEFT JOIN pi.modulo_tecido mt ON mt.id_modulo = m.id AND mt.fl_ativo = true
        WHERE m.id_fornecedor = 3 AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'BALDUZZI' LIMIT 1)
        GROUP BY m.id, m.descricao, m.largura, m.profundidade, m.altura, m.m3
        LIMIT 5;
    """)
    for r in cur.fetchall():
        print(f"ID: {r[0]} | Desc: {r[1]} | L={r[2]} P={r[3]} H={r[4]} | M3={r[5]} | Active prices count: {r[6]}")
        
    # 6. Check MILANO for Livintus (should be newly inserted)
    print("\n--- MILANO (Livintus - supplier 4) Sample Modules ---")
    cur.execute("""
        SELECT m.id, m.descricao, m.largura, m.profundidade, m.altura, m.m3, COUNT(mt.id)
        FROM pi.modulo m
        LEFT JOIN pi.modulo_tecido mt ON mt.id_modulo = m.id AND mt.fl_ativo = true
        WHERE m.id_fornecedor = 4 AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'MILANO' LIMIT 1)
        GROUP BY m.id, m.descricao, m.largura, m.profundidade, m.altura, m.m3
        LIMIT 5;
    """)
    for r in cur.fetchall():
        print(f"ID: {r[0]} | Desc: {r[1]} | L={r[2]} P={r[3]} H={r[4]} | M3={r[5]} | Active prices count: {r[6]}")
        
    # 7. Check CORDERO for Livintus (should have updated depth/height)
    print("\n--- CORDERO (Livintus - supplier 4) ---")
    cur.execute("""
        SELECT m.id, m.descricao, m.largura, m.profundidade, m.altura, m.m3, t.nome, mt.valor_tecido
        FROM pi.modulo m
        JOIN pi.modulo_tecido mt ON mt.id_modulo = m.id AND mt.fl_ativo = true
        JOIN pi.tecido t ON mt.id_tecido = t.id
        WHERE m.id_fornecedor = 4 AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'CORDERO' LIMIT 1)
        ORDER BY m.largura, t.nome LIMIT 10;
    """)
    for r in cur.fetchall():
        print(f"ID: {r[0]} | Desc: {r[1]} | L={r[2]} P={r[3]} H={r[4]} | M3={r[5]} | Fabric: {r[6]} | Price: {r[7]}")
        
    # 8. Check INSIEME for Livintus (should have active prices matched correctly)
    print("\n--- INSIEME (Livintus - supplier 4) Sample Prices ---")
    cur.execute("""
        SELECT m.id, m.descricao, m.largura, m.profundidade, m.altura, t.nome, mt.valor_tecido
        FROM pi.modulo m
        JOIN pi.modulo_tecido mt ON mt.id_modulo = m.id AND mt.fl_ativo = true
        JOIN pi.tecido t ON mt.id_tecido = t.id
        WHERE m.id_fornecedor = 4 AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'INSIEME' LIMIT 1)
        ORDER BY m.largura, t.nome LIMIT 10;
    """)
    for r in cur.fetchall():
        print(f"ID: {r[0]} | Desc: {r[1]} | L={r[2]} P={r[3]} H={r[4]} | Fabric: {r[5]} | Price: {r[6]}")

    cur.close()
    conn.close()

if __name__ == "__main__":
    main()
