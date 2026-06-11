import psycopg2

try:
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    cur.execute("""
        SELECT pi_item.id, pi_item.id_pi, pi_item.id_pi_item_peca,
               modulo.id as modulo_id, modulo.descricao as modulo_desc,
               marca.id as marca_id, marca.nome as marca_name
        FROM pi.pi_item
        JOIN pi.modulo_tecido ON pi_item.id_modulo_tecido = modulo_tecido.id
        JOIN pi.modulo ON modulo_tecido.id_modulo = modulo.id
        LEFT JOIN pi.marca ON modulo.id_marca = marca.id
        WHERE pi_item.id_pi = 15
        ORDER BY pi_item.id ASC
    """)
    rows = cur.fetchall()
    print("PI 15 items:")
    for r in rows:
        print(f"Item {r[0]} | PieceId {r[2]} | ModuloId {r[3]} | Desc {repr(r[4])} | MarcaId {r[5]} | MarcaName {repr(r[6])}")
    cur.close()
    conn.close()
except Exception as e:
    print("Error:", e)
