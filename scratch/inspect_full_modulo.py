import psycopg2

def main():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    cur.execute("SELECT * FROM pi.modulo WHERE id = 5154;")
    columns = [desc[0] for desc in cur.description]
    row = cur.fetchone()
    
    print("=== Row 5154 ===")
    for col, val in zip(columns, row):
        print(f"{col}: {val}")
        
    cur.close()
    conn.close()

if __name__ == "__main__":
    main()
