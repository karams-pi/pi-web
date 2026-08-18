import psycopg2

def main():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    print("--- Suppliers (fornecedor) ---")
    cur.execute("SELECT id, nome FROM pi.fornecedor ORDER BY id;")
    for r in cur.fetchall():
        print(f"ID: {r[0]}, Name: {r[1]}")
        
    print("\n--- Categories (categoria) ---")
    cur.execute("SELECT id, nome FROM pi.categoria ORDER BY id;")
    for r in cur.fetchall():
        print(f"ID: {r[0]}, Name: {r[1]}")
        
    print("\n--- Brands/Marks (marca) ---")
    cur.execute("SELECT id, nome FROM pi.marca ORDER BY id LIMIT 50;")
    for r in cur.fetchall():
        print(f"ID: {r[0]}, Name: {r[1]}")

    print("\n--- Fabrics (tecido) ---")
    cur.execute("SELECT id, nome FROM pi.tecido ORDER BY id LIMIT 50;")
    for r in cur.fetchall():
        print(f"ID: {r[0]}, Name: {r[1]}")
        
    print("\n--- Structure of pi.modulo ---")
    cur.execute("""
        SELECT column_name, data_type, is_nullable
        FROM information_schema.columns
        WHERE table_schema = 'pi' AND table_name = 'modulo';
    """)
    for r in cur.fetchall():
        print(f"Column: {r[0]:<20} | Type: {r[1]:<15} | Nullable: {r[2]}")
        
    print("\n--- Structure of pi.modulo_tecido ---")
    cur.execute("""
        SELECT column_name, data_type, is_nullable
        FROM information_schema.columns
        WHERE table_schema = 'pi' AND table_name = 'modulo_tecido';
    """)
    for r in cur.fetchall():
        print(f"Column: {r[0]:<20} | Type: {r[1]:<15} | Nullable: {r[2]}")

    cur.close()
    conn.close()

if __name__ == "__main__":
    main()
