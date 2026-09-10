import psycopg2

conn = psycopg2.connect('host=localhost port=5432 dbname=pi_db user=pi password=pi123')
cur = conn.cursor()
cur.execute('SELECT "Id", "NumeroReferencia", "DataEstudo" FROM edc.simulacoes ORDER BY "Id"')
for r in cur.fetchall():
    print(r)
cur.close()
conn.close()
