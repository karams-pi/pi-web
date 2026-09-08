import psycopg2
from collections import defaultdict

def run():
    conn = psycopg2.connect('host=localhost port=5432 dbname=pi_db user=pi password=pi123')
    cur = conn.cursor()

    cur.execute("""
        SELECT 
            m.id, 
            m.id_fornecedor, 
            f.nome as fornecedor_nome,
            m.id_marca, 
            ma.nome as marca_nome,
            m.descricao,
            m.largura,
            m.profundidade,
            m.altura,
            m.m3
        FROM pi.modulo m
        JOIN pi.fornecedor f ON m.id_fornecedor = f.id
        JOIN pi.marca ma ON m.id_marca = ma.id
        ORDER BY m.id_fornecedor, m.id_marca, m.id;
    """)
    modules = cur.fetchall()

    cur.execute("""
        SELECT mt.id_modulo, t.nome, mt.valor_tecido
        FROM pi.modulo_tecido mt
        JOIN pi.tecido t ON mt.id_tecido = t.id
        WHERE mt.fl_ativo = true;
    """)
    active_prices = {}
    for mid, tname, val in cur.fetchall():
        active_prices.setdefault(mid, {})[tname] = round(float(val), 2)

    by_forn_marca = defaultdict(list)
    for m in modules:
        if m[0] in active_prices:
            by_forn_marca[(m[1], m[3])].append(m)

    print("Checking pairs with same fornecedor, same marca, and identical active fabric prices...")
    matches = []
    for (fid, mid), mlist in by_forn_marca.items():
        if len(mlist) < 2:
            continue
        for i in range(len(mlist)):
            for j in range(i + 1, len(mlist)):
                m1 = mlist[i]
                m2 = mlist[j]
                p1 = active_prices[m1[0]]
                p2 = active_prices[m2[0]]

                # Exact same active fabrics and prices
                if set(p1.keys()) == set(p2.keys()) and all(abs(p1[k] - p2[k]) < 0.05 for k in p1):
                    matches.append((m1, m2, p1))

    print(f"Total matching pairs across whole DB: {len(matches)}")
    for m1, m2, prices in matches:
        print(f"[{m1[2]} | {m1[4]}]")
        print(f"   M1 ({m1[0]}): desc='{m1[5]}' L={m1[6]} P={m1[7]} A={m1[8]} M3={m1[9]}")
        print(f"   M2 ({m2[0]}): desc='{m2[5]}' L={m2[6]} P={m2[7]} A={m2[8]} M3={m2[9]}")
        print(f"   Prices ({len(prices)}): {prices}")
        print()

if __name__ == '__main__':
    run()
