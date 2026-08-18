import psycopg2

def main():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    print("--- Structure of pi.marca ---")
    cur.execute("""
        SELECT column_name, data_type, is_nullable
        FROM information_schema.columns
        WHERE table_schema = 'pi' AND table_name = 'marca';
    """)
    for r in cur.fetchall():
        print(f"Column: {r[0]:<20} | Type: {r[1]:<15} | Nullable: {r[2]}")
        
    cur.close()
    conn.close()

if __name__ == "__main__":
    main()
