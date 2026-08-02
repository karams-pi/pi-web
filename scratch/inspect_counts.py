import psycopg2

def inspect_counts():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    cur.execute("""
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'pi'
        ORDER BY table_name;
    """)
    tables = [row[0] for row in cur.fetchall()]
    
    for t in tables:
        try:
            cur.execute(f'SELECT count(*) FROM pi."{t}";')
            count = cur.fetchone()[0]
            print(f"pi.{t:<25} : {count} rows")
        except Exception as e:
            print(f"Error querying pi.{t}: {e}")
            conn.rollback()
            
    cur.close()
    conn.close()

if __name__ == "__main__":
    inspect_counts()
