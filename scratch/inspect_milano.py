import psycopg2

def main():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    cur.execute("SELECT id, nome FROM pi.marca WHERE UPPER(nome) LIKE '%MILANO%';")
    print("=== Milano Brands in DB ===")
    for r in cur.fetchall():
        print(f"ID: {r[0]}, Name: {r[1]}")
        
    cur.execute("""
        SELECT m.id, ma.nome, m.descricao, m.largura, m.profundidade, m.altura, m.m3, m.id_fornecedor
        FROM pi.modulo m
        JOIN pi.marca ma ON m.id_marca = ma.id
        WHERE UPPER(ma.nome) LIKE '%MILANO%';
    """)
    print("\n=== Milano Modules in DB ===")
    for r in cur.fetchall():
        print(f"ID: {r[0]} | Brand: {r[1]} | Desc: {r[2]} | L: {r[3]} | P: {r[4]} | A: {r[5]} | M3: {r[6]} | Forn: {r[7]}")
        
    cur.close()
    conn.close()

if __name__ == "__main__":
    main()
