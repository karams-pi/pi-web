import psycopg2

conn = psycopg2.connect('host=localhost port=5432 dbname=pi_db user=pi password=pi123')
cur = conn.cursor()
cur.execute('SELECT "Id", "NumeroReferencia", "DataEstudo", "CotacaoDolar", "Status" FROM edc.simulacoes ORDER BY "Id" DESC LIMIT 15')
for row in cur.fetchall():
    print(row)
cur.close()
conn.close()
