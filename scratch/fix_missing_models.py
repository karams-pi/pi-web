import psycopg2

def main():
    try:
        conn = psycopg2.connect('host=localhost port=5432 dbname=pi_db user=pi password=pi123')
        cur = conn.cursor()
        
        # Find all active products without an active model
        cur.execute('''
            SELECT p."Id", p."Referencia", p."Descricao"
            FROM edc.produtos p
            WHERE p."FlAtivo" = true
              AND NOT EXISTS (
                  SELECT 1 FROM edc.modelos m 
                  WHERE m."IdProduto" = p."Id" AND m."FlAtivo" = true
              )
        ''')
        missing = cur.fetchall()
        print(f"Active products without active model: {len(missing)}")
        
        for p in missing:
            p_id, ref, desc = p
            cod = ref if ref else f"PROD-{p_id}"
            nome = ref if ref else desc
            descricao_mod = f"Modelo Padrão - {desc}" if desc else f"Modelo Padrão - {ref}"
            cur.execute('''
                INSERT INTO edc.modelos ("IdProduto", "Codigo", "Nome", "Descricao", "FlAtivo")
                VALUES (%s, %s, %s, %s, true)
            ''', (p_id, cod, nome, descricao_mod))
            
        conn.commit()
        print(f"Successfully created default models for {len(missing)} products.")

        # Re-check count
        cur.execute('''
            SELECT count(*)
            FROM edc.produtos p
            WHERE p."FlAtivo" = true
              AND NOT EXISTS (
                  SELECT 1 FROM edc.modelos m 
                  WHERE m."IdProduto" = p."Id" AND m."FlAtivo" = true
              )
        ''')
        print(f"Remaining active products without model: {cur.fetchone()[0]}")

        # Re-check active models count
        cur.execute('SELECT count(*) FROM edc.modelos WHERE "FlAtivo" = true')
        print(f"Total active models now: {cur.fetchone()[0]}")

        cur.close()
        conn.close()
    except Exception as e:
        print('Error:', e)

if __name__ == '__main__':
    main()
