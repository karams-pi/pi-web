import psycopg2

def inspect_data():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    print("--- SAMPLE MODELS (pi.modelo) FOR FORNECEDOR 1 (Karams) ---")
    cur.execute("SELECT * FROM pi.modelo WHERE id_fornecedor = 1 LIMIT 10;")
    for r in cur.fetchall():
        print(r)
        
    print("\n--- SAMPLE MODULES (pi.modulo) FOR FORNECEDOR 1 (Karams) ---")
    cur.execute("""
        SELECT m.id, m.id_marca, m.descricao, m.largura, m.profundidade, m.altura, m.m3, m."ModeloId"
        FROM pi.modulo m
        WHERE m.id_fornecedor = 1 
        LIMIT 10;
    """)
    for r in cur.fetchall():
        print(r)

    print("\n--- DISTINCT FORNECEDORES IN LISTA_PRECO ---")
    cur.execute("SELECT DISTINCT fornecedor_lista, tipo_preco FROM pi.lista_preco;")
    for r in cur.fetchall():
        print(r)

    print("\n--- COUNT OF ACTIVE RECORDS IN LISTA_PRECO FOR KARAMS ---")
    cur.execute("SELECT count(*), fl_ativo FROM pi.lista_preco WHERE fornecedor_lista ILIKE '%Karam%' GROUP BY fl_ativo;")
    for r in cur.fetchall():
        print(r)

    print("\n--- SAMPLE LISTA_PRECO FOR KARAMS ---")
    cur.execute("SELECT * FROM pi.lista_preco WHERE fornecedor_lista ILIKE '%Karam%' LIMIT 5;")
    for r in cur.fetchall():
        print(r)

    cur.close()
    conn.close()

if __name__ == "__main__":
    inspect_data()
