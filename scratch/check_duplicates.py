import psycopg2

def check_duplicates():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    cur.execute("""
        SELECT id_modulo, id_tecido, count(*) 
        FROM pi.modulo_tecido 
        GROUP BY id_modulo, id_tecido 
        HAVING count(*) > 1 
        LIMIT 10;
    """)
    print("Duplicate (id_modulo, id_tecido) in pi.modulo_tecido:")
    rows = cur.fetchall()
    if rows:
        for r in rows:
            print(r)
    else:
        print("None found!")
        
    cur.close()
    conn.close()

if __name__ == "__main__":
    check_duplicates()
