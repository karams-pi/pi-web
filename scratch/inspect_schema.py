import psycopg2

def main():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    print("--- SCHEMAS ---")
    cur.execute("SELECT nspname FROM pg_namespace WHERE nspname NOT LIKE 'pg_%' AND nspname != 'information_schema';")
    for row in cur.fetchall():
        print(row)
        
    print("\n--- TABLES IN PI SCHEMA ---")
    cur.execute("""
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'pi'
        ORDER BY table_name;
    """)
    for row in cur.fetchall():
        print(row[0])
        
    print("\n--- FORNECEDORES IN PI.FORNECEDOR ---")
    cur.execute("SELECT id, nome FROM pi.fornecendedor" if False else "SELECT * FROM pi.fornecedor;") # let's check table name first
    for row in cur.fetchall():
        print(row)
        
    cur.close()
    conn.close()

if __name__ == "__main__":
    main()
