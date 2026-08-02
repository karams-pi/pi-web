import psycopg2

def check_brands():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    sheet_brands = [
        "ESTOFADO ANKUR", "ESTOFADO LASSO", "ESTOFADO MIWA", "ESTOFADO MOA", "ESTOFADO NINHO", "ESTOFADO TIBAGI", "ESTOFADO ZENITH",
        "POLTRONA ALENTO", "POLTRONA DENGO", "POLTRONA KENJI", "POLTRONA MUSH", "POLTRONA MUSH (MALHA)", "POLTRONA SEMENTE",
        "BANCO TOAD", "BANCO TORUS", "CAMA KAORI"
    ]
    
    print("Checking sheet brands against pi.marca:")
    print("-" * 50)
    for b in sheet_brands:
        cur.execute("SELECT id, nome FROM pi.marca WHERE nome ILIKE %s;", (b,))
        rows = cur.fetchall()
        if rows:
            print(f"Brand: {b:<25} | Found in DB: {rows}")
        else:
            print(f"Brand: {b:<25} | NOT FOUND IN DB!")
            
    cur.close()
    conn.close()

if __name__ == "__main__":
    check_brands()
