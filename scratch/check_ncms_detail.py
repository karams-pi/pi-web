import psycopg2

def main():
    try:
        conn = psycopg2.connect('host=localhost port=5432 dbname=pi_db user=pi password=pi123')
        cur = conn.cursor()
        
        # Check all NCMs
        cur.execute('SELECT "Id", "Codigo", "Descricao", "FlAtivo" FROM edc.ncms ORDER BY "Codigo"')
        ncms = cur.fetchall()
        print(f"Total NCMs in DB: {len(ncms)}")
        inactive_ncms = [n for n in ncms if not n[3]]
        print(f"Inactive NCMs: {len(inactive_ncms)}")
        for n in inactive_ncms:
            print("  Inactive NCM:", n)
            
        # Check if there are duplicate NCM codes
        cur.execute('SELECT "Codigo", count(*) FROM edc.ncms GROUP BY "Codigo" HAVING count(*) > 1')
        dup_ncms = cur.fetchall()
        print(f"Duplicate NCM codes: {dup_ncms}")
        
        # Check if any products have invalid or missing IdNcm
        cur.execute('''
            SELECT p."Id", p."Referencia", p."Descricao", p."IdNcm", n."Codigo", p."FlAtivo"
            FROM edc.produtos p
            LEFT JOIN edc.ncms n ON p."IdNcm" = n."Id"
            WHERE p."IdNcm" IS NULL OR n."Id" IS NULL
        ''')
        prod_invalid_ncm = cur.fetchall()
        print(f"Products with invalid IdNcm: {prod_invalid_ncm}")

        # Check all products in edc.produtos
        cur.execute('SELECT count(*) FROM edc.produtos')
        print(f"Total produtos: {cur.fetchone()[0]}")
        cur.execute('SELECT count(*) FROM edc.produtos WHERE "FlAtivo" = false')
        print(f"Inactive produtos: {cur.fetchone()[0]}")

        cur.close()
        conn.close()
    except Exception as e:
        print('Error:', e)

if __name__ == '__main__':
    main()
