import psycopg2
import re
import unicodedata
from collections import defaultdict

def clean_desc(s, brand=""):
    if not s:
        return ""
    if brand:
        b_clean = re.escape(brand.strip())
        s = re.sub(r"^" + b_clean + r"\s*[-–—:]*\s*", "", s, flags=re.IGNORECASE)
    s = unicodedata.normalize('NFKD', s).encode('ASCII', 'ignore').decode('ASCII')
    s = re.sub(r'[\r\n\t]+', ' ', s)
    s = re.sub(r'\s+', ' ', s)
    return s.strip().lower()

def compact_desc(s, brand=""):
    c = clean_desc(s, brand)
    return re.sub(r'[^a-z0-9]', '', c)

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
        ORDER BY m.id_fornecedor, m.id_marca, m.largura, m.id;
    """)
    modules = cur.fetchall()

    # Active prices
    cur.execute("""
        SELECT mt.id_modulo, t.nome, mt.valor_tecido
        FROM pi.modulo_tecido mt
        JOIN pi.tecido t ON mt.id_tecido = t.id
        WHERE mt.fl_ativo = true;
    """)
    active_prices = {}
    for mid, tname, val in cur.fetchall():
        active_prices.setdefault(mid, {})[tname] = round(float(val), 2)

    # All latest prices (even if fl_ativo = false, latest by dt_ultima_revisao or id)
    cur.execute("""
        SELECT DISTINCT ON (mt.id_modulo, t.nome) mt.id_modulo, t.nome, mt.valor_tecido, mt.fl_ativo
        FROM pi.modulo_tecido mt
        JOIN pi.tecido t ON mt.id_tecido = t.id
        ORDER BY mt.id_modulo, t.nome, mt.fl_ativo DESC, mt.id DESC;
    """)
    latest_prices = {}
    for mid, tname, val, fl in cur.fetchall():
        latest_prices.setdefault(mid, {})[tname] = round(float(val), 2)

    cur.execute("SELECT DISTINCT id_modulo FROM pi.sub_modulo;")
    in_sub = set(r[0] for r in cur.fetchall())

    cur.execute("SELECT DISTINCT mt.id_modulo FROM pi.pi_item p JOIN pi.modulo_tecido mt ON p.id_modulo_tecido = mt.id;")
    in_pi = set(r[0] for r in cur.fetchall())

    by_forn_marca = defaultdict(list)
    for m in modules:
        by_forn_marca[(m[1], m[3])].append(m)

    # Let's find groups of duplicates
    # Case 1: Both have ACTIVE prices, same brand, same width, identical prices
    active_dups = []
    # Case 2: One active, one inactive, same brand, same width, identical prices (either active vs latest or overlapping)
    inactive_dups = []

    for (fid, mid), mlist in by_forn_marca.items():
        if len(mlist) < 2:
            continue
        for i in range(len(mlist)):
            for j in range(i + 1, len(mlist)):
                m1 = mlist[i]
                m2 = mlist[j]

                larg1 = float(m1[6])
                larg2 = float(m2[6])
                if abs(larg1 - larg2) >= 0.01:
                    continue

                c1 = compact_desc(m1[5], m1[4])
                c2 = compact_desc(m2[5], m2[4])

                p1_act = active_prices.get(m1[0], {})
                p2_act = active_prices.get(m2[0], {})

                # Check if active prices match
                if p1_act and p2_act and set(p1_act.keys()) == set(p2_act.keys()) and all(abs(p1_act[k] - p2_act[k]) < 0.05 for k in p1_act):
                    active_dups.append({
                        "fornecedor": m1[2],
                        "marca": m1[4],
                        "m1": m1,
                        "m2": m2,
                        "prices": p1_act,
                        "c1": c1,
                        "c2": c2,
                        "in_sub1": m1[0] in in_sub,
                        "in_sub2": m2[0] in in_sub,
                        "in_pi1": m1[0] in in_pi,
                        "in_pi2": m2[0] in in_pi,
                    })
                elif (p1_act and not p2_act) or (p2_act and not p1_act):
                    # Check if prices ever matched in history
                    p1_all = latest_prices.get(m1[0], {})
                    p2_all = latest_prices.get(m2[0], {})
                    common = set(p1_all.keys()) & set(p2_all.keys())
                    if common and all(abs(p1_all[k] - p2_all[k]) < 0.05 for k in common) and (c1 == c2 or (c1 in c2 or c2 in c1)):
                        inactive_dups.append({
                            "fornecedor": m1[2],
                            "marca": m1[4],
                            "m1": m1,
                            "m2": m2,
                            "active_id": m1[0] if p1_act else m2[0],
                            "inactive_id": m2[0] if p1_act else m1[0],
                            "in_sub1": m1[0] in in_sub,
                            "in_sub2": m2[0] in in_sub,
                            "in_pi1": m1[0] in in_pi,
                            "in_pi2": m2[0] in in_pi,
                        })

    print(f"Active Duplicates (Both have active prices & match): {len(active_dups)}")
    print(f"Historical Duplicates (One active, one inactive, same module): {len(inactive_dups)}")

if __name__ == '__main__':
    run()
