import psycopg2

def main():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    print("=== Brands with ALOHA ===")
    cur.execute("SELECT id, nome, imagem IS NULL, fl_ativo, observacao FROM pi.marca WHERE UPPER(nome) LIKE '%ALOHA%';")
    for r in cur.fetchall():
        print(f"ID: {r[0]} | Name: {r[1]} | Image is NULL: {r[2]} | Active: {r[3]} | Obs: {r[4]}")
        
    print("\n=== Modules for ALOHA ===")
    cur.execute("""
        SELECT m.id, m.id_fornecedor, f.nome, m.descricao, m.largura, m.profundidade, m.altura
        FROM pi.modulo m
        JOIN pi.marca ma ON m.id_marca = ma.id
        JOIN pi.fornecedor f ON m.id_fornecedor = f.id
        WHERE UPPER(ma.nome) LIKE '%ALOHA%';
    """)
    for r in cur.fetchall():
        print(f"ModID: {r[0]} | FornID: {r[1]} ({r[2]}) | Desc: {r[3]} | L: {r[4]} | P: {r[5]} | A: {r[6]}")

    print("\n=== Brand GERAL ===")
    cur.execute("SELECT id, nome, imagem IS NULL, fl_ativo, observacao FROM pi.marca WHERE UPPER(nome) = 'GERAL';")
    for r in cur.fetchall():
        print(f"ID: {r[0]} | Name: {r[1]} | Image is NULL: {r[2]} | Active: {r[3]} | Obs: {r[4]}")
        
    print("\n=== Modules for GERAL ===")
    cur.execute("""
        SELECT m.id, m.id_fornecedor, f.nome, m.descricao, m.largura, m.profundidade, m.altura
        FROM pi.modulo m
        JOIN pi.marca ma ON m.id_marca = ma.id
        JOIN pi.fornecedor f ON m.id_fornecedor = f.id
        WHERE UPPER(ma.nome) = 'GERAL';
    """)
    for r in cur.fetchall():
        print(f"ModID: {r[0]} | FornID: {r[1]} ({r[2]}) | Desc: {r[3]} | L: {r[4]} | P: {r[5]} | A: {r[6]}")

    cur.close()
    conn.close()

if __name__ == "__main__":
    main()
