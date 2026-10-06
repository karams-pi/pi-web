import psycopg2

def main():
    try:
        conn = psycopg2.connect('host=localhost port=5432 dbname=pi_db user=pi password=pi123')
        cur = conn.cursor()
        cur.execute('SELECT count(*) FROM edc.produtos WHERE "FlAtivo" = true')
        print('Active Produtos count:', cur.fetchone()[0])
        cur.execute('SELECT count(*) FROM edc.modelos WHERE "FlAtivo" = true')
        print('Active Modelos count:', cur.fetchone()[0])
        cur.execute('SELECT count(*) FROM edc.ncms WHERE "FlAtivo" = true')
        print('Active Ncms count:', cur.fetchone()[0])
        
        # Check active products without active models
        cur.execute('''
            SELECT p."Id", p."Referencia", p."Descricao", p."FlAtivo", p."IdNcm" 
            FROM edc.produtos p 
            WHERE p."FlAtivo" = true 
              AND NOT EXISTS (
                  SELECT 1 FROM edc.modelos m 
                  WHERE m."IdProduto" = p."Id" AND m."FlAtivo" = true
              )
        ''')
        missing_models = cur.fetchall()
        print('Active Produtos without active modelos count:', len(missing_models))
        for p in missing_models:
            print('  Product without model:', p)
            
        # Check active products without NCM or with inactive NCM
        cur.execute('''
            SELECT p."Id", p."Referencia", p."Descricao", p."IdNcm", n."Codigo", n."FlAtivo"
            FROM edc.produtos p
            LEFT JOIN edc.ncms n ON p."IdNcm" = n."Id"
            WHERE p."FlAtivo" = true AND (n."Id" IS NULL OR n."FlAtivo" = false)
        ''')
        missing_ncms = cur.fetchall()
        print('Active Produtos with missing or inactive NCM count:', len(missing_ncms))
        for p in missing_ncms:
            print('  Product with missing/inactive NCM:', p)

        # Check NCMs list
        cur.execute('SELECT "Id", "Codigo", "Descricao", "FlAtivo" FROM edc.ncms ORDER BY "Codigo"')
        ncms = cur.fetchall()
        print(f'Total NCMs: {len(ncms)}')

        cur.close()
        conn.close()
    except Exception as e:
        print('DB Error:', e)

if __name__ == '__main__':
    main()
