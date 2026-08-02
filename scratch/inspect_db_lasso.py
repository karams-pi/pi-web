import psycopg2

def inspect_db_lasso():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    cur.execute("""
        SELECT m.id, m.descricao, m.largura, m.profundidade, m.altura, m.pa, m.m3
        FROM pi.modulo m
        WHERE m.id_fornecedor = 1 AND m.id_marca = 440
        ORDER BY m.descricao, m.largura;
    """)
    print("Database modules for ESTOFADO LASSO (ID 440):")
    print("-" * 75)
    for r in cur.fetchall():
        print(f"ID={r[0]:4d} | Desc={r[1]:<40} | W={r[2]:.2f} | D={r[3]:.2f} | H={r[4]:.2f} | PA={r[5]:.2f} | M3={r[6]:.3f}")
        
    cur.close()
    conn.close()

if __name__ == "__main__":
    inspect_db_lasso()
