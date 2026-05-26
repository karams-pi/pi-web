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
        SELECT m.id, m.descricao, t.nome, mt.valor_tecido, mt.fl_ativo
        FROM modulo_tecido mt
        JOIN modulo m ON mt.id_modulo = m.id
        JOIN marca ma ON m.id_marca = ma.id
        JOIN tecido t ON mt.id_tecido = t.id
        WHERE ma.nome = 'ALICANTE'
        ORDER BY m.id, t.nome
    """)
    rows = cur.fetchall()
    print("Alicante prices in DB:")
    for r in rows:
        print(f"ModID: {r[0]}, Desc: {r[1]}, Tecido: {r[2]}, Valor: {r[3]}, Ativo: {r[4]}")
    cur.close()
    conn.close()
except Exception as e:
    print("Error:", e)
