import psycopg2

conn = psycopg2.connect('host=localhost port=5432 dbname=pi_db user=pi password=pi123')
cur = conn.cursor()
for sid in [17, 18]:
    cur.execute('SELECT COUNT(*) FROM edc.simulacao_itens WHERE "IdSimulacao" = %s', (sid,))
    itens = cur.fetchone()[0]
    cur.execute('SELECT COUNT(*) FROM edc.simulacao_despesas WHERE "IdSimulacao" = %s', (sid,))
    desp = cur.fetchone()[0]
    cur.execute('SELECT "DataEstudo", "ValorFreteInternacional" FROM edc.simulacoes WHERE "Id" = %s', (sid,))
    dates = cur.fetchone()
    print(f'ID {sid}: itens={itens}, despesas={desp}, details={dates}')
cur.close()
conn.close()
