import psycopg2

conn = psycopg2.connect('host=localhost port=5432 dbname=pi_db user=pi password=pi123')
cur = conn.cursor()

def inspect_group(name, ids):
    print(f"\n--- {name} ---")
    for i in ids:
        cur.execute('SELECT "Id", "DataEstudo", "ValorFreteInternacional", "CotacaoDolar" FROM edc.simulacoes WHERE "Id" = %s', (i,))
        print(cur.fetchone())

inspect_group("CHAPAS - 304 - ALUPLOM", [58, 59, 60, 61])
inspect_group("EDC - BATERIA", [72, 73])
inspect_group("EDC - CHAPAS - FABRICA 1", [17, 18])

cur.close()
conn.close()
