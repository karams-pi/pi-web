import psycopg2

def inspect_constraints():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    cur.execute("""
        SELECT conname, pg_get_constraintdef(c.oid)
        FROM pg_constraint c
        JOIN pg_namespace n ON n.oid = c.connamespace
        WHERE n.nspname = 'pi' AND c.conrelid = 'pi.modulo_tecido'::regclass;
    """)
    print("Constraints on pi.modulo_tecido:")
    for r in cur.fetchall():
        print(f"Name: {r[0]} | Def: {r[1]}")
        
    cur.close()
    conn.close()

if __name__ == "__main__":
    inspect_constraints()
