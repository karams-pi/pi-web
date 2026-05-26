import psycopg2

try:
    conn = psycopg2.connect(
        host="localhost",
        port=5432,
        database="pi_db",
        user="pi",
        password="pi123"
    )
    cur = conn.cursor()
    cur.execute("""
        SELECT ma.nome as marca_nome, 
               COUNT(CASE WHEN m.id_fornecedor = 3 THEN 1 END) as count_ferguile,
               COUNT(CASE WHEN m.id_fornecedor = 4 THEN 1 END) as count_livintus
        FROM modulo m
        JOIN marca ma ON m.id_marca = ma.id
        GROUP BY ma.nome
        ORDER BY ma.nome
    """)
    rows = cur.fetchall()
    print("Shared Brands/Models in DB:")
    print(f"{'Marca':<15} | {'Ferguile count':<15} | {'Livintus count':<15}")
    print("-" * 50)
    for r in rows:
        if r[1] > 0 or r[2] > 0:
            print(f"{r[0]:<15} | {r[1]:<15} | {r[2]:<15}")
    cur.close()
    conn.close()
except Exception as e:
    print("Error:", e)
