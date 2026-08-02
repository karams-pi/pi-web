import psycopg2

def check_images():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    brands = [
        "ESTOFADO ANKUR", "ESTOFADO LASSO", "ESTOFADO MIWA", "ESTOFADO MOA", 
        "ESTOFADO NINHO", "ESTOFADO TIBAGI", "ESTOFADO ZENITH", "POLTRONA ALENTO", 
        "POLTRONA DENGO", "POLTRONA KENJI", "POLTRONA MUSH", "POLTRONA MUSH (MALHA)", 
        "POLTRONA SEMENTE", "BANCO TOAD", "BANCO TORUS", "CAMA KAORI"
    ]
    
    print("Checking images for Karams brands in DB:")
    print("-" * 65)
    for b in brands:
        cur.execute("SELECT nome, (imagem IS NOT NULL AND length(imagem) > 0) FROM pi.marca WHERE nome = %s;", (b,))
        row = cur.fetchone()
        if row:
            has_image = row[1]
            status = "Has Image" if has_image else "MISSING IMAGE"
            print(f"Brand: {row[0]:<25} | Status: {status}")
        else:
            print(f"Brand: {b:<25} | NOT FOUND IN DB!")
            
    cur.close()
    conn.close()

if __name__ == "__main__":
    check_images()
