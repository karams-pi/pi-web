import psycopg2

def main():
    try:
        conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
        cur = conn.cursor()
        
        # Get column names of edc.importadores
        cur.execute("SELECT column_name FROM information_schema.columns WHERE table_schema = 'edc' AND table_name = 'importadores'")
        imp_cols = [r[0] for r in cur.fetchall()]
        print("IMPORTADORES Columns:", imp_cols)
        
        cur.execute("SELECT * FROM edc.importadores")
        rows = cur.fetchall()
        print("--- IMPORTADORES ---")
        for r in rows:
            print(dict(zip(imp_cols, r)))
            
        # Get column names of edc.configuracoes_fiscais
        cur.execute("SELECT column_name FROM information_schema.columns WHERE table_schema = 'edc' AND table_name = 'configuracoes_fiscais'")
        conf_cols = [r[0] for r in cur.fetchall()]
        print("CONFIGURACOES_FISCAIS Columns:", conf_cols)
        
        cur.execute("SELECT * FROM edc.configuracoes_fiscais")
        rows = cur.fetchall()
        print("--- CONFIGURACOES FISCAIS ---")
        for r in rows:
            print(dict(zip(conf_cols, r)))
            
        cur.close()
        conn.close()
    except Exception as e:
        print("ERROR:", e)

if __name__ == "__main__":
    main()
