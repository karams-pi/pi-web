import psycopg2

def main():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    print("=== Brands with Active Modules and NO Image ===")
    
    # We want to find brands (marca) that are associated with modules of Ferguile (3) or Livintus (4)
    # and have imagem IS NULL. We will also count how many active modules they have.
    cur.execute("""
        SELECT ma.id, ma.nome, 
               COUNT(CASE WHEN m.id_fornecedor = 3 THEN 1 END) as count_ferguile,
               COUNT(CASE WHEN m.id_fornecedor = 4 THEN 1 END) as count_livintus
        FROM pi.marca ma
        JOIN pi.modulo m ON m.id_marca = ma.id
        WHERE ma.imagem IS NULL AND m.id_fornecedor IN (3, 4)
        GROUP BY ma.id, ma.nome
        ORDER BY ma.nome;
    """)
    rows = cur.fetchall()
    
    print(f"{'Marca (Modelo)':<30} | {'ID Marca':<10} | {'Qtd Ferguile':<15} | {'Qtd Livintus':<15}")
    print("-" * 80)
    for r in rows:
        print(f"{r[1]:<30} | {r[0]:<10} | {r[2]:<15} | {r[3]:<15}")
        
    print(f"\nTotal brands without image: {len(rows)}")
    
    cur.close()
    conn.close()

if __name__ == "__main__":
    main()
