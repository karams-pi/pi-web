import psycopg2
import re
import unicodedata
from collections import defaultdict

def normalize_desc(s, brand_name=""):
    if not s:
        return ""
    if brand_name:
        b_clean = re.escape(brand_name.strip())
        s = re.sub(r"^" + b_clean + r"\s*[-–—:]*\s*", "", s, flags=re.IGNORECASE)
    s = unicodedata.normalize('NFKD', s).encode('ASCII', 'ignore').decode('ASCII')
    s = re.sub(r'[\r\n\t]+', ' ', s)
    s = re.sub(r'\s+', ' ', s)
    return s.strip().lower()

def compact_desc(s, brand_name=""):
    norm = normalize_desc(s, brand_name)
    return re.sub(r'[^a-z0-9]', '', norm)

def analyze_duplicates():
    conn = psycopg2.connect('host=localhost port=5432 dbname=pi_db user=pi password=pi123')
    cur = conn.cursor()

    cur.execute("""
        SELECT 
            m.id, 
            m.id_fornecedor, 
            f.nome as fornecedor_nome,
            m.id_marca, 
            ma.nome as marca_nome,
            m.id_categoria,
            c.nome as categoria_nome,
            m.descricao,
            m.largura,
            m.profundidade,
            m.altura,
            m.m3
        FROM pi.modulo m
        JOIN pi.fornecedor f ON m.id_fornecedor = f.id
        JOIN pi.marca ma ON m.id_marca = ma.id
        JOIN pi.categoria c ON m.id_categoria = c.id
        ORDER BY m.id_fornecedor, m.id_marca, m.id;
    """)
    modules = cur.fetchall()

    cur.execute("""
        SELECT 
            mt.id_modulo, 
            t.nome as tecido_nome, 
            mt.valor_tecido
        FROM pi.modulo_tecido mt
        JOIN pi.tecido t ON mt.id_tecido = t.id
        WHERE mt.fl_ativo = true
        ORDER BY mt.id_modulo, t.nome;
    """)
    prices_raw = cur.fetchall()
    active_prices = {}
    for mod_id, tec, val in prices_raw:
        active_prices.setdefault(mod_id, {})[tec] = round(float(val), 2)

    cur.execute("SELECT DISTINCT mt.id_modulo FROM pi.pi_item pi JOIN pi.modulo_tecido mt ON pi.id_modulo_tecido = mt.id;")
    pi_item_mod_ids = set(r[0] for r in cur.fetchall())

    cur.execute("SELECT DISTINCT id_modulo FROM pi.sub_modulo;")
    sub_modulo_mod_ids = set(r[0] for r in cur.fetchall())

    # Group by (id_fornecedor, id_marca)
    by_supplier_brand = defaultdict(list)
    for m in modules:
        by_supplier_brand[(m[1], m[3])].append(m)

    # Categories of duplicates:
    # 1. Exact match on normalized description + same width + same active prices
    # 2. Same active prices + same width, but slightly different descriptions
    # 3. Same normalized description + same width, but different/no prices
    
    exact_duplicates = []
    semantic_duplicates = []

    for (forn_id, marca_id), mod_list in by_supplier_brand.items():
        if len(mod_list) < 2:
            continue
        
        for i in range(len(mod_list)):
            for j in range(i + 1, len(mod_list)):
                m1 = mod_list[i]
                m2 = mod_list[j]

                p1 = active_prices.get(m1[0], {})
                p2 = active_prices.get(m2[0], {})

                same_prices = (len(p1) > 0 and len(p2) > 0 and set(p1.keys()) == set(p2.keys()) and all(abs(p1[k] - p2[k]) < 0.05 for k in p1))

                larg1 = float(m1[8])
                larg2 = float(m2[8])
                same_larg = abs(larg1 - larg2) < 0.01

                c1 = compact_desc(m1[7], m1[4])
                c2 = compact_desc(m2[7], m2[4])
                same_compact_desc = (c1 == c2 and len(c1) > 0)

                item = {
                    "fornecedor": m1[2],
                    "fornecedor_id": forn_id,
                    "marca": m1[4],
                    "marca_id": marca_id,
                    "m1_id": m1[0],
                    "m1_desc": m1[7],
                    "m1_larg": larg1,
                    "m1_prof": float(m1[9]),
                    "m1_alt": float(m1[10]),
                    "m1_m3": float(m1[11]),
                    "m1_prices": p1,
                    "m1_in_pi": m1[0] in pi_item_mod_ids,
                    "m1_in_sub": m1[0] in sub_modulo_mod_ids,
                    "m2_id": m2[0],
                    "m2_desc": m2[7],
                    "m2_larg": larg2,
                    "m2_prof": float(m2[9]),
                    "m2_alt": float(m2[10]),
                    "m2_m3": float(m2[11]),
                    "m2_prices": p2,
                    "m2_in_pi": m2[0] in pi_item_mod_ids,
                    "m2_in_sub": m2[0] in sub_modulo_mod_ids,
                    "same_larg": same_larg,
                    "same_prices": same_prices,
                    "same_desc": same_compact_desc
                }

                if same_larg and same_prices and same_compact_desc:
                    exact_duplicates.append(item)
                elif same_larg and same_prices:
                    semantic_duplicates.append(item)

    print(f"=== Category 1: EXACT MATCH (Same Fornecedor, Marca, Largura, Prices, and Normalized Desc) ===")
    print(f"Total: {len(exact_duplicates)}")
    by_f = defaultdict(int)
    for x in exact_duplicates:
        by_f[x['fornecedor']] += 1
    for k, v in by_f.items():
        print(f"  - {k}: {v}")

    print(f"\n=== Category 2: SAME PRICES & LARGURA, DIFFERENT DESCRIPTION TEXT ===")
    print(f"Total: {len(semantic_duplicates)}")
    by_f2 = defaultdict(int)
    for x in semantic_duplicates:
        by_f2[x['fornecedor']] += 1
    for k, v in by_f2.items():
        print(f"  - {k}: {v}")

    print("\n--- Category 2 Samples ---")
    for x in semantic_duplicates[:10]:
        print(f"[{x['fornecedor']} | {x['marca']}] L:{x['m1_larg']}")
        print(f"   M1 (ID {x['m1_id']}): {repr(x['m1_desc'])}")
        print(f"   M2 (ID {x['m2_id']}): {repr(x['m2_desc'])}")
        print(f"   Prices: {x['m1_prices']}")

    print("\n--- Category 1 Samples ---")
    for x in exact_duplicates[:10]:
        print(f"[{x['fornecedor']} | {x['marca']}] L:{x['m1_larg']}")
        print(f"   M1 (ID {x['m1_id']}): {repr(x['m1_desc'])} (in_pi={x['m1_in_pi']}, in_sub={x['m1_in_sub']})")
        print(f"   M2 (ID {x['m2_id']}): {repr(x['m2_desc'])} (in_pi={x['m2_in_pi']}, in_sub={x['m2_in_sub']})")

if __name__ == '__main__':
    analyze_duplicates()
