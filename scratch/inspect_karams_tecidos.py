import psycopg2

def inspect_karams_tecidos():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    cur.execute("""
        SELECT t.id, t.nome, count(mt.id), count(CASE WHEN mt.fl_ativo THEN 1 END) as active_count
        FROM pi.modulo_tecido mt
        JOIN pi.modulo m ON mt.id_modulo = m.id
        JOIN pi.tecido t ON mt.id_tecido = t.id
        WHERE m.id_fornecedor = 1
        GROUP BY t.id, t.nome
        ORDER BY t.id;
    """)
    print("Karams modulo_tecido count grouped by fabric:")
    for r in cur.fetchall():
        print(f"Tecido ID={r[0]} | Nome={r[1]} | Total={r[2]} | Active={r[3]}")
        
    cur.close()
    conn.close()

if __name__ == "__main__":
    inspect_karams_tecidos()
