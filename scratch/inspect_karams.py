import psycopg2

def inspect_karams_modulos():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    cur.execute("""
        SELECT count(*), fl_ativo 
        FROM pi.modulo_tecido mt
        JOIN pi.modulo m ON mt.id_modulo = m.id
        WHERE m.id_fornecedor = 1
        GROUP BY fl_ativo;
    """)
    print("Karams modulo_tecido counts by fl_ativo:")
    for r in cur.fetchall():
        print(r)
        
    cur.execute("""
        SELECT m.id_marca, ma.nome, count(m.id)
        FROM pi.modulo m
        JOIN pi.marca ma ON m.id_marca = ma.id
        WHERE m.id_fornecedor = 1
        GROUP BY m.id_marca, ma.nome
        ORDER BY count(m.id) DESC;
    """)
    print("\nBrands (marca) for Karams modules in DB:")
    for r in cur.fetchall():
        print(r)
        
    cur.close()
    conn.close()

if __name__ == "__main__":
    inspect_karams_modulos()
