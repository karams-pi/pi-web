import psycopg2

def main():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    cur.execute("""
        SELECT m.id, ma.nome, m.descricao, m.largura, m.profundidade, m.altura, m.m3
        FROM pi.modulo m
        JOIN pi.marca ma ON m.id_marca = ma.id
        WHERE UPPER(ma.nome) = 'CORDERO' AND m.id_fornecedor = 4;
    """)
    print("=== Cordero in DB ===")
    for r in cur.fetchall():
        print(f"ID: {r[0]} | Brand: {r[1]} | Desc: {r[2]} | L: {r[3]} | P: {r[4]} | A: {r[5]}")
        
    cur.close()
    conn.close()

if __name__ == "__main__":
    main()
