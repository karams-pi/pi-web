import psycopg2

def check_details():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    cur.execute("""
        SELECT id, id_modulo, id_tecido, valor_tecido, codigo_modulo_tecido, fl_ativo, dt_ultima_revisao
        FROM pi.modulo_tecido
        WHERE id_modulo = 3173 AND id_tecido = 1;
    """)
    for r in cur.fetchall():
        print(r)
        
    cur.close()
    conn.close()

if __name__ == "__main__":
    check_details()
