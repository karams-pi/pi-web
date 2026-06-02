import psycopg2

def dump_pi(pi_id):
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    # Query PI items
    cur.execute("""
        SELECT 
            pi.id,
            pi.quantidade,
            pi.largura,
            pi.altura,
            pi.profundidade,
            pi.m3,
            pi.valor_exw,
            pi.observacao,
            pi.id_pi_item_peca,
            peca.descricao as peca_desc,
            sm.id as submod_id,
            sm.codigo as submod_codigo,
            sm.descricao_produto as submod_desc_prod,
            mt.id as modtec_id,
            m.id as mod_id,
            m.descricao as mod_desc,
            t.nome as tec_nome,
            mt.codigo_modulo_tecido as modtec_cod
        FROM pi_item pi
        LEFT JOIN pi_item_peca peca ON pi.id_pi_item_peca = peca.id
        LEFT JOIN sub_modulo sm ON pi.id_sub_modulo = sm.id
        LEFT JOIN modulo_tecido mt ON pi.id_modulo_tecido = mt.id
        LEFT JOIN modulo m ON mt.id_modulo = m.id
        LEFT JOIN tecido t ON mt.id_tecido = t.id
        WHERE pi.id_pi = %s
        ORDER BY peca.id, pi.id
    """, (pi_id,))
    
    rows = cur.fetchall()
    print(f"PI {pi_id} items:")
    for row in rows:
        print(f"Item: ID={row[13]} | PecaDesc={row[9]} | SubmodId={row[10]} | SubmodCod={row[11]} | ModId={row[14]} | ModDesc={row[15]} | TecNome={row[16]} | ModTecCod={row[17]} | Qty={row[1]} | M3={row[5]} | EXW={row[6]} | Obs={row[7]}")
        
    cur.close()
    conn.close()

if __name__ == "__main__":
    dump_pi(15)
