import psycopg2

conn = psycopg2.connect('host=localhost port=5432 dbname=pi_db user=pi password=pi123')
cur = conn.cursor()

# Find all duplicate references
cur.execute('''
    SELECT "NumeroReferencia", COUNT(*) as cnt, array_agg("Id" ORDER BY "Id") as ids
    FROM edc.simulacoes
    GROUP BY "NumeroReferencia"
    HAVING COUNT(*) > 1
    ORDER BY cnt DESC
''')

rows = cur.fetchall()
print("DUPLICATE REFERENCES:")
for ref, cnt, ids in rows:
    print(f"Ref: '{ref}' | Count: {cnt} | IDs: {ids}")

cur.close()
conn.close()
