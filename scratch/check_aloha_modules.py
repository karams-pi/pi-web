import psycopg2

def main():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    cur.execute("""
        SELECT m.id, m.id_marca, ma.nome, ma.fl_ativo, ma.imagem IS NULL
        FROM pi.modulo m
        JOIN pi.marca ma ON m.id_marca = ma.id
        WHERE UPPER(ma.nome) LIKE '%ALOHA%';
    """)
    print("=== Aloha Modules and Brand Associations ===")
    for r in cur.fetchall():
        print(f"Module ID: {r[0]} | Brand ID: {r[1]} | Brand Name: {r[2]} | Brand Active: {r[3]} | Brand Image is NULL: {r[4]}")
        
    cur.close()
    conn.close()

if __name__ == "__main__":
    main()
