import psycopg2

def main():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    print("=== PA values for Ferguile (3) ===")
    cur.execute("""
        SELECT DISTINCT pa, COUNT(*)
        FROM pi.modulo
        WHERE id_fornecedor = 3
        GROUP BY pa
        ORDER BY pa;
    """)
    for r in cur.fetchall():
        print(f"PA: {r[0]} | Count: {r[1]}")
        
    print("\n=== PA values for Livintus (4) ===")
    cur.execute("""
        SELECT DISTINCT pa, COUNT(*)
        FROM pi.modulo
        WHERE id_fornecedor = 4
        GROUP BY pa
        ORDER BY pa;
    """)
    for r in cur.fetchall():
        print(f"PA: {r[0]} | Count: {r[1]}")

    cur.close()
    conn.close()

if __name__ == "__main__":
    main()
