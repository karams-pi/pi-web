import psycopg2

try:
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    cur.execute("""
        SELECT column_name, data_type 
        FROM information_schema.columns 
        WHERE table_schema = 'pi' AND table_name = 'pi'
    """)
    rows = cur.fetchall()
    print("Columns in pi.pi table:")
    for r in rows:
        print(f"Column: {r[0]} | Type: {r[1]}")
        
    cur.close()
    conn.close()
except Exception as e:
    print("Error:", e)
