import psycopg2
import json

conn = psycopg2.connect('host=localhost port=5432 dbname=pi_db user=pi password=pi123')
cur = conn.cursor()
cur.execute('SELECT * FROM edc.simulacoes WHERE "Id" IN (63, 64, 65, 66, 67, 68) ORDER BY "Id"')
cols = [desc[0] for desc in cur.description]
rows = cur.fetchall()
for r in rows:
    d = dict(zip(cols, r))
    # Convert non-serializable to string
    for k, v in d.items():
        d[k] = str(v)
    print(f"ID {d['Id']}: DataEstudo={d['DataEstudo']}, Ref={d['NumeroReferencia']}")

cur.execute('SELECT "Id", "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario" FROM edc.simulacao_itens WHERE "IdSimulacao" IN (63, 64, 65, 66, 67, 68) ORDER BY "IdSimulacao", "Id"')
print("ITENS:")
for r in cur.fetchall():
    print(r)

cur.close()
conn.close()
