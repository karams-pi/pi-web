import psycopg2

try:
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    cur.execute("""
        SELECT p.id, p.prefixo, p.pi_sequencia, f.nome as fornecedor_nome
        FROM pi.pi p
        JOIN pi.fornecedor f ON p.id_fornecedor = f.id
        ORDER BY p.id DESC
        LIMIT 20
    """)
    rows = cur.fetchall()
    print("Recent PIs in database:")
    for r in rows:
        print(f"PI ID: {r[0]} | Number: {r[1]}-{r[2]} | Supplier: {r[3]}")
        
    cur.close()
    conn.close()
except Exception as e:
    print("Error:", e)
