import psycopg2

def check_missing_images():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    # 1. Check all brands (pi.marca) associated with Karams (id_fornecedor = 1) modules
    cur.execute("""
        SELECT DISTINCT ma.id, ma.nome, (ma.imagem IS NOT NULL AND length(ma.imagem) > 0) as has_img
        FROM pi.modulo m
        JOIN pi.marca ma ON m.id_marca = ma.id
        WHERE m.id_fornecedor = 1
        ORDER BY ma.nome;
    """)
    brands = cur.fetchall()
    
    missing_brand_images = []
    print("=== BRAND IMAGES (pi.marca) FOR KARAMS ===")
    for b in brands:
        if not b[2]:
            missing_brand_images.append(b[1])
            print(f"ID={b[0]:4d} | Brand Name: {b[1]:<45} | Missing Image")
        else:
            print(f"ID={b[0]:4d} | Brand Name: {b[1]:<45} | OK")
            
    # 2. Check all models (pi.modelo) associated with Karams
    cur.execute("SELECT count(*) FROM pi.modelo WHERE id_fornecedor = 1;")
    modelo_count = cur.fetchone()[0]
    print(f"\nTotal models in pi.modelo for Karams: {modelo_count}")
    
    if modelo_count > 0:
        cur.execute("""
            SELECT id, descricao, url_imagem 
            FROM pi.modelo 
            WHERE id_fornecedor = 1 AND (url_imagem IS NULL OR url_imagem = '')
            ORDER BY descricao;
        """)
        missing_model_images = cur.fetchall()
        print("\n=== MISSING IMAGES IN pi.modelo FOR KARAMS ===")
        for m in missing_model_images:
            print(f"ID={m[0]:4d} | Model Name: {m[1]:<45} | Missing URL Image")
    else:
        print("Table pi.modelo has 0 rows.")
        
    cur.close()
    conn.close()

if __name__ == "__main__":
    check_missing_images()
