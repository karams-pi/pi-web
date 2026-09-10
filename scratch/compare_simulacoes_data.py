import psycopg2
import json
from decimal import Decimal
from datetime import datetime

class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, Decimal):
            return float(o)
        if isinstance(o, datetime):
            return o.isoformat()
        return super().default(o)

conn = psycopg2.connect('host=localhost port=5432 dbname=pi_db user=pi password=pi123')
cur = conn.cursor()

for sim_id in [63, 64, 65, 66, 67, 68]:
    cur.execute('SELECT * FROM edc.simulacoes WHERE "Id" = %s', (sim_id,))
    cols = [d[0] for d in cur.description]
    row = cur.fetchone()
    sim_data = dict(zip(cols, row))
    
    cur.execute('SELECT * FROM edc.simulacao_itens WHERE "IdSimulacao" = %s', (sim_id,))
    icols = [d[0] for d in cur.description]
    itens = [dict(zip(icols, r)) for r in cur.fetchall()]
    
    cur.execute('SELECT "NomeDespesa", "Valor", "Moeda" FROM edc.simulacao_despesas WHERE "IdSimulacao" = %s ORDER BY "Ordem"', (sim_id,))
    despesas = cur.fetchall()
    
    print(f"=== SIMULACAO {sim_id} ===")
    print(f"Ref: {sim_data['NumeroReferencia']}, Date: {sim_data['DataEstudo']}")
    print(f"Cotacao: {sim_data['CotacaoDolar']}, Spread: {sim_data['SpreadCambio']}, FreteInt: {sim_data['ValorFreteInternacional']}, SeguroInt: {sim_data['ValorSeguroInternacional']}")
    print(f"Comissao: {sim_data['ComissaoPercentual']}, ExibirComissao: {sim_data['FlExibirComissao']}, Subfat: {sim_data['FlSimularSubfaturamento']}")
    print(f"Itens ({len(itens)}): {[(i['IdProduto'], float(i['Quantidade']), float(i['ValorFobUnitario'])) for i in itens]}")
    print(f"Despesas ({len(despesas)}): {despesas[:3]}...")

cur.close()
conn.close()
