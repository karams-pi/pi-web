import psycopg2

def inspect_categorias_exact():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    cur.execute("SELECT id, nome, encode(nome::bytea, 'hex') FROM pi.categoria WHERE id BETWEEN 18 AND 21;")
    print("Exact details of categorias in DB:")
    for r in cur.fetchall():
        print(f"ID={r[0]} | Nome={r[1]} | Hex={r[2]}")
        
    cur.close()
    conn.close()

if __name__ == "__main__":
    inspect_categorias_exact()
