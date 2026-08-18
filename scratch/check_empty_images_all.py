import psycopg2

def main():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    print("=== Brands with Active Modules and NO Image (All Suppliers) ===")
    
    cur.execute("""
        SELECT ma.id, ma.nome, 
               COUNT(CASE WHEN m.id_fornecedor = 1 THEN 1 END) as count_karams,
               COUNT(CASE WHEN m.id_fornecedor = 2 THEN 1 END) as count_koyo,
               COUNT(CASE WHEN m.id_fornecedor = 3 THEN 1 END) as count_ferguile,
               COUNT(CASE WHEN m.id_fornecedor = 4 THEN 1 END) as count_livintus
        FROM pi.marca ma
        JOIN pi.modulo m ON m.id_marca = ma.id
        WHERE ma.imagem IS NULL
        GROUP BY ma.id, ma.nome
        ORDER BY ma.nome;
    """)
    rows = cur.fetchall()
    
    print(f"{'Marca (Modelo)':<30} | {'ID':<5} | {'Karams':<8} | {'Koyo':<8} | {'Ferguile':<8} | {'Livintus':<8}")
    print("-" * 80)
    for r in rows:
        print(f"{r[1]:<30} | {r[0]:<5} | {r[2]:<8} | {r[3]:<8} | {r[4]:<8} | {r[5]:<8}")
        
    print(f"\nTotal brands without image (all suppliers): {len(rows)}")
    
    cur.close()
    conn.close()

if __name__ == "__main__":
    main()
