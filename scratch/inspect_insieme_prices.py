import psycopg2

def main():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    cur.execute("""
        SELECT mt.id_modulo, m.descricao, m.largura, m.profundidade, m.altura, COUNT(*), BOOL_OR(mt.fl_ativo)
        FROM pi.modulo_tecido mt
        JOIN pi.modulo m ON mt.id_modulo = m.id
        WHERE m.id_fornecedor = 4 AND UPPER(m.descricao) LIKE '%INSIEME%' OR m.id_marca IN (SELECT id FROM pi.marca WHERE UPPER(nome) = 'INSIEME')
        GROUP BY mt.id_modulo, m.descricao, m.largura, m.profundidade, m.altura
        ORDER BY m.largura, m.profundidade;
    """)
    print("=== Insieme Active Prices in DB ===")
    for r in cur.fetchall():
        print(f"ModID: {r[0]} | Desc: {r[1]} | L: {r[2]} | P: {r[3]} | A: {r[4]} | Price count: {r[5]} | Has active: {r[6]}")
        
    cur.close()
    conn.close()

if __name__ == "__main__":
    main()
