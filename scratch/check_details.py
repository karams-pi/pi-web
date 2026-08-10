import psycopg2

def check_details():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    print("=== PI 13 DETAILS ===")
    cur.execute("SELECT column_name FROM information_schema.columns WHERE table_schema = 'pi' AND table_name = 'pi'")
    cols = [r[0] for r in cur.fetchall()]
    cur.execute("SELECT * FROM pi.pi WHERE id = 13")
    for r in cur.fetchall():
        print(dict(zip(cols, r)))
        
    print("\n=== PI 13 ITEMS ===")
    cur.execute("SELECT column_name FROM information_schema.columns WHERE table_schema = 'pi' AND table_name = 'pi_item'")
    cols = [r[0] for r in cur.fetchall()]
    cur.execute("SELECT * FROM pi.pi_item WHERE id_pi = 13")
    for r in cur.fetchall():
        print(dict(zip(cols, r)))

    cur.close()
    conn.close()

if __name__ == "__main__":
    check_details()
