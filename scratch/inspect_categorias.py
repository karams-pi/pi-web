import psycopg2

def inspect_categorias():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    cur.execute("SELECT id, nome FROM pi.categoria ORDER BY id;")
    print("Categorias in DB:")
    for r in cur.fetchall():
        print(f"ID={r[0]} | Nome={r[1]}")
        
    cur.close()
    conn.close()

if __name__ == "__main__":
    inspect_categorias()
