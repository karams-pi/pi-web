import psycopg2

conn = psycopg2.connect('host=localhost port=5432 dbname=pi_db user=pi password=pi123')
cur = conn.cursor()
cur.execute('''
    SELECT "NumeroReferencia", COUNT(*), array_agg("Id" ORDER BY "Id") 
    FROM edc.simulacoes 
    GROUP BY "NumeroReferencia" 
    HAVING COUNT(*) > 1
''')
for row in cur.fetchall():
    print(row)
cur.close()
conn.close()
