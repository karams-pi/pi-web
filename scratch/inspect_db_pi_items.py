import psycopg2

try:
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    cur.execute("""
        SELECT pi_item.id, pi_item.id_pi, pi_item.observacao, pi_item.feet, pi_item.finishing,
               modulo.descricao as mod_desc
        FROM pi.pi_item
        JOIN pi.modulo_tecido ON pi_item.id_modulo_tecido = modulo_tecido.id
        JOIN pi.modulo ON modulo_tecido.id_modulo = modulo.id
        WHERE pi_item.id_pi IN (13, 14, 15)
        ORDER BY pi_item.id_pi DESC, pi_item.id DESC
    """)
    rows = cur.fetchall()
    print("PI Items in database for PIs 13, 14, 15:")
    for r in rows:
        print(f"Item ID: {r[0]} | PI ID: {r[1]} | Obs: {repr(r[2])} | Feet: {repr(r[3])} | Finish: {repr(r[4])} | Module: {r[5]}")
        
    cur.close()
    conn.close()
except Exception as e:
    print("Error:", e)
