import psycopg2
import re
import unicodedata
from collections import defaultdict

def clean_str(s, brand=""):
    if not s:
        return ""
    if brand:
        b_clean = re.escape(brand.strip())
        s = re.sub(r"^" + b_clean + r"\s*[-–—:]*\s*", "", s, flags=re.IGNORECASE)
    s = unicodedata.normalize('NFKD', s).encode('ASCII', 'ignore').decode('ASCII')
    s = re.sub(r'[\r\n\t]+', ' ', s)
    s = re.sub(r'\s+', ' ', s)
    return s.strip().lower()

def compact_str(s, brand=""):
    c = clean_str(s, brand)
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

    # All prices (including inactive)
    cur.execute("""
        SELECT mt.id_modulo, t.nome, mt.valor_tecido, mt.fl_ativo
        FROM pi.modulo_tecido mt
        JOIN pi.tecido t ON mt.id_tecido = t.id;
    """)
    all_prices = {}
    for mid, tname, val, fl in cur.fetchall():
        all_prices.setdefault(mid, {})[tname] = round(float(val), 2)

    # Sub_modulo & pi_item
    cur.execute("SELECT DISTINCT id_modulo FROM pi.sub_modulo;")
    in_sub = set(r[0] for r in cur.fetchall())

    cur.execute("SELECT DISTINCT mt.id_modulo FROM pi.pi_item p JOIN pi.modulo_tecido mt ON p.id_modulo_tecido = mt.id;")
    in_pi = set(r[0] for r in cur.fetchall())

    by_forn_marca = defaultdict(list)
    for m in modules:
        by_forn_marca[(m[1], m[3])].append(m)

    print("=== SEARCHING DUPLICATES BY NORMALIZED DESCRIPTION (Spacing / Case / Newline / Brand Prefix) ===")
    desc_dups = []
    for (fid, mid), mlist in by_forn_marca.items():
        if len(mlist) < 2:
            continue
        for i in range(len(mlist)):
            for j in range(i + 1, len(mlist)):
                m1 = mlist[i]
                m2 = mlist[j]
                
                c1 = compact_str(m1[5], m1[4])
                c2 = compact_str(m2[5], m2[4])
                larg1 = float(m1[6])
                larg2 = float(m2[6])
                same_larg = abs(larg1 - larg2) < 0.01

                if c1 == c2 and len(c1) > 0 and same_larg:
                    p1_act = active_prices.get(m1[0], {})
                    p2_act = active_prices.get(m2[0], {})
                    same_active_prices = (len(p1_act) > 0 and len(p2_act) > 0 and p1_act == p2_act)
                    
                    desc_dups.append({
                        "fornecedor": m1[2],
                        "marca": m1[4],
                        "m1": m1,
                        "m2": m2,
                        "p1_act": p1_act,
                        "p2_act": p2_act,
                        "same_active_prices": same_active_prices,
                        "c1": c1
                    })

    print(f"Total pairs matching compact desc & larg: {len(desc_dups)}")
    by_f = defaultdict(int)
    for d in desc_dups:
        by_f[d['fornecedor']] += 1
    for k, v in by_f.items():
        print(f"  - {k}: {v} pairs")

    print("\nBreakdown by active price match:")
    both_active_same = [d for d in desc_dups if d['same_active_prices']]
    print(f"  - Both have identical active prices: {len(both_active_same)}")
    one_or_both_no_active = [d for d in desc_dups if not d['p1_act'] or not d['p2_act']]
    print(f"  - One or both has NO active prices: {len(one_or_both_no_active)}")
    both_active_diff_prices = [d for d in desc_dups if d['p1_act'] and d['p2_act'] and not d['same_active_prices']]
    print(f"  - Both have active prices, but prices DIFFER: {len(both_active_diff_prices)}")

    if both_active_diff_prices:
        print("\nSamples where both have active prices but prices differ:")
        for d in both_active_diff_prices[:5]:
            print(f"[{d['fornecedor']} | {d['marca']}]")
            print(f"  M1 ({d['m1'][0]}): {repr(d['m1'][5])} -> {d['p1_act']}")
            print(f"  M2 ({d['m2'][0]}): {repr(d['m2'][5])} -> {d['p2_act']}")

    if one_or_both_no_active:
        print("\nSamples where one has no active prices:")
        for d in one_or_both_no_active[:5]:
            print(f"[{d['fornecedor']} | {d['marca']}]")
            print(f"  M1 ({d['m1'][0]}): {repr(d['m1'][5])} -> act={bool(d['p1_act'])}")
            print(f"  M2 ({d['m2'][0]}): {repr(d['m2'][5])} -> act={bool(d['p2_act'])}")

if __name__ == '__main__':
    run()
