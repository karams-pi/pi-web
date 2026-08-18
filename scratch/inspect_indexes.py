import psycopg2

def main():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    print("--- Indexes on pi.modulo_tecido ---")
    cur.execute("""
        SELECT indexname, indexdef
        FROM pg_indexes
        WHERE schemaname = 'pi' AND tablename = 'modulo_tecido';
    """)
    for r in cur.fetchall():
        print(f"Index: {r[0]}\nDef: {r[1]}\n")
        
    print("--- Unique Constraints on pi.modulo_tecido ---")
    cur.execute("""
        SELECT conname, pg_get_constraintdef(oid)
        FROM pg_constraint
        WHERE conrelid = 'pi.modulo_tecido'::regclass AND contype = 'u';
    """)
    for r in cur.fetchall():
        print(f"Constraint: {r[0]}\nDef: {r[1]}\n")

    cur.close()
    conn.close()

if __name__ == "__main__":
    main()
