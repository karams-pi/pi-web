import psycopg2

def main():
    try:
        conn = psycopg2.connect('host=localhost port=5432 dbname=pi_db user=pi password=pi123')
        cur = conn.cursor()
        
        # 1. Clean up NCMs with tabs or weird whitespace
        cur.execute('''
            UPDATE edc.ncms 
            SET "Codigo" = regexp_replace("Codigo", '[\\t\\r\\n]+', '', 'g')
            WHERE "Codigo" ~ '[\\t\\r\\n]';
        ''')
        
        # 2. Activate NCM 113 ('9616.10.00') since products 387 and 388 use it
        cur.execute('''
            UPDATE edc.ncms
            SET "FlAtivo" = true,
                "Descricao" = 'Vaporizadores de toucador, suas armaes e cabeas de armaes; borlas ou esponjas para ps ou para aplicao de outros cosmticos'
            WHERE "Id" = 113;
        ''')
        
        # 3. Fix Product 12 to point to active NCM 9 (8424.90.10)
        cur.execute('''
            UPDATE edc.produtos
            SET "IdNcm" = 9
            WHERE "Id" = 12 AND "IdNcm" = 7;
        ''')
        
        # 4. Check if any active products still have inactive or missing NCMs
        cur.execute('''
            SELECT p."Id", p."Referencia", p."Descricao", p."IdNcm", n."Codigo", n."FlAtivo"
            FROM edc.produtos p
            LEFT JOIN edc.ncms n ON p."IdNcm" = n."Id"
            WHERE p."FlAtivo" = true AND (n."Id" IS NULL OR n."FlAtivo" = false);
        ''')
        remaining_inactive_ncm_prods = cur.fetchall()
        print("Active products with inactive or missing NCM:", remaining_inactive_ncm_prods)

        # 5. Check if any active products still have no active model
        cur.execute('''
            SELECT p."Id", p."Referencia"
            FROM edc.produtos p
            WHERE p."FlAtivo" = true
              AND NOT EXISTS (
                  SELECT 1 FROM edc.modelos m
                  WHERE m."IdProduto" = p."Id" AND m."FlAtivo" = true
              );
        ''')
        remaining_no_model_prods = cur.fetchall()
        print("Active products without active model:", remaining_no_model_prods)

        conn.commit()
        print("Database adjustments committed successfully.")
        
        cur.close()
        conn.close()
    except Exception as e:
        print('Error:', e)

if __name__ == '__main__':
    main()
