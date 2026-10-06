import psycopg2

def main():
    try:
        conn = psycopg2.connect('host=localhost port=5432 dbname=pi_db user=pi password=pi123')
        cur = conn.cursor()
        
        # 1. Clean up whitespace/tabs in NCM codes and descriptions
        cur.execute('''
            UPDATE edc.ncms 
            SET "Codigo" = TRIM("Codigo"),
                "Descricao" = TRIM("Descricao")
        ''')
        print("Trimmed whitespace in NCM codes and descriptions.")
        
        # 2. Check inactive NCMs and if any products point to them
        cur.execute('''
            SELECT n."Id", n."Codigo", n."Descricao", n."FlAtivo", count(p."Id") as prod_count
            FROM edc.ncms n
            LEFT JOIN edc.produtos p ON p."IdNcm" = n."Id" AND p."FlAtivo" = true
            GROUP BY n."Id", n."Codigo", n."Descricao", n."FlAtivo"
            HAVING NOT n."FlAtivo" OR count(p."Id") > 0
            ORDER BY n."Codigo"
        ''')
        rows = cur.fetchall()
        print("NCMs status with product counts:")
        for r in rows:
            print(" ", r)

        # 3. Check products with inactive NCMs
        cur.execute('''
            SELECT p."Id", p."Referencia", p."Descricao", p."IdNcm", n."Codigo", n."FlAtivo"
            FROM edc.produtos p
            JOIN edc.ncms n ON p."IdNcm" = n."Id"
            WHERE p."FlAtivo" = true AND n."FlAtivo" = false
        ''')
        prods_with_inactive_ncm = cur.fetchall()
        print("Active products with inactive NCM:", prods_with_inactive_ncm)

        conn.commit()
        cur.close()
        conn.close()
    except Exception as e:
        print('Error:', e)

if __name__ == '__main__':
    main()
