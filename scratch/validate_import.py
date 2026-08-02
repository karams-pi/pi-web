import psycopg2

def main():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    # 1. Total modules for Karams in DB
    cur.execute("SELECT count(*) FROM pi.modulo WHERE id_fornecedor = 1;")
    total_modulos = cur.fetchone()[0]
    print(f"Total Karams modules in DB: {total_modulos} (Expected: 1806, since 1692 + 114 = 1806)")
    
    # 2. Total active modulo_tecido records for Karams
    cur.execute("""
        SELECT count(*), fl_ativo 
        FROM pi.modulo_tecido mt
        JOIN pi.modulo m ON mt.id_modulo = m.id
        WHERE m.id_fornecedor = 1
        GROUP BY fl_ativo;
    """)
    print("\nKarams modulo_tecido records by fl_ativo:")
    for r in cur.fetchall():
        print(f"  fl_ativo={r[1]} : {r[0]} rows (Expected active: 1312)")
        
    # 3. Verify newly created brands
    new_brands = [
        "ESTOFADO MIWA", "ESTOFADO NINHO", "ESTOFADO TIBAGI", "POLTRONA DENGO", 
        "POLTRONA KENJI", "POLTRONA MUSH (MALHA)", "POLTRONA SEMENTE", "BANCO TORUS", "CAMA KAORI"
    ]
    print("\nEnsured brands status in DB:")
    for b in new_brands:
        cur.execute("SELECT id, nome, fl_ativo FROM pi.marca WHERE nome = %s;", (b,))
        rows = cur.fetchall()
        print(f"  Brand '{b}': {rows}")
        
    cur.close()
    conn.close()

if __name__ == "__main__":
    main()
