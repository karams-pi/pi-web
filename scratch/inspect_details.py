import psycopg2

conn = psycopg2.connect('host=localhost port=5432 dbname=pi_db user=pi password=pi123')
cur = conn.cursor()

ids_to_check = [
    (17, 18),
    (19, 20, 21, 22, 23, 24, 25),
    (29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 53, 54, 55),
    (58, 59, 60, 61),
    (63, 64, 65, 66, 67, 68),
    (72, 73)
]

for group in ids_to_check:
    print(f"\n=== Group IDs: {group} ===")
    cur.execute('''
        SELECT "Id", "NumeroReferencia", "DataEstudo", "ValorFreteInternacional", "CotacaoDolar"
        FROM edc.simulacoes
        WHERE "Id" = ANY(%s)
        ORDER BY "Id"
    ''', (list(group),))
    for row in cur.fetchall():
        print(row)

cur.close()
conn.close()
