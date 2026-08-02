import psycopg2

def inspect_db_modulos():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    cur.execute("""
        SELECT m.id, ma.nome as marca_nome, m.descricao, m.largura, m.profundidade, m.altura, m.pa, m.m3, m.id_categoria
        FROM pi.modulo m
        JOIN pi.marca ma ON m.id_marca = ma.id
        WHERE m.id_fornecedor = 1
        ORDER BY ma.nome, m.descricao, m.largura;
    """)
    rows = cur.fetchall()
    print(f"Total modules in DB for Karams: {len(rows)}")
    
    with open(r"c:\Portifólio\pi-web\scratch\db_modules_summary.txt", "w", encoding="utf-8") as f:
        for r in rows:
            f.write(f"ID={r[0]:4d} | Cat={r[8]} | Marca={r[1]:<25} | Desc={r[2]:<45} | W={r[3]:.2f} | D={r[4]:.2f} | H={r[5]:.2f} | PA={r[6]:.2f} | M3={r[7]:.3f}\n")
            
    cur.close()
    conn.close()

if __name__ == "__main__":
    inspect_db_modulos()
