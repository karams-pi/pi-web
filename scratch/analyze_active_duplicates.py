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

def main():
    conn = psycopg2.connect('host=localhost port=5432 dbname=pi_db user=pi password=pi123')
    cur = conn.cursor()

    # Modules with AT LEAST ONE ACTIVE FABRIC
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
        WHERE EXISTS (
            SELECT 1 FROM pi.modulo_tecido mt 
            WHERE mt.id_modulo = m.id AND mt.fl_ativo = true
        )
        ORDER BY m.id_fornecedor, m.id_marca, m.largura, m.id;
    """)
    modules = cur.fetchall()
    print(f"Total modules with active fabrics: {len(modules)}")

    # Active prices
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

    by_supplier_brand = defaultdict(list)
    for m in modules:
        by_supplier_brand[(m[1], m[3])].append(m)

    duplicates = []

    for (forn_id, marca_id), mod_list in by_supplier_brand.items():
        if len(mod_list) < 2:
            continue
        
        for i in range(len(mod_list)):
            for j in range(i + 1, len(mod_list)):
                m1 = mod_list[i]
                m2 = mod_list[j]

                larg1 = float(m1[8])
                larg2 = float(m2[8])

                p1 = active_prices.get(m1[0], {})
                p2 = active_prices.get(m2[0], {})

                same_prices = (len(p1) > 0 and len(p2) > 0 and set(p1.keys()) == set(p2.keys()) and all(abs(p1[k] - p2[k]) < 0.05 for k in p1))
                same_larg = abs(larg1 - larg2) < 0.01

                c1 = compact_desc(m1[7], m1[4])
                c2 = compact_desc(m2[7], m2[4])

                # Let's check similarity
                if same_prices and same_larg:
                    duplicates.append({
                        "fornecedor": m1[2],
                        "marca": m1[4],
                        "m1_id": m1[0],
                        "m1_desc": m1[7],
                        "m1_larg": larg1,
                        "m1_m3": float(m1[11]),
                        "m1_in_sub": m1[0] in sub_modulo_mod_ids,
                        "m1_in_pi": m1[0] in pi_item_mod_ids,
                        "m2_id": m2[0],
                        "m2_desc": m2[7],
                        "m2_larg": larg2,
                        "m2_m3": float(m2[11]),
                        "m2_in_sub": m2[0] in sub_modulo_mod_ids,
                        "m2_in_pi": m2[0] in pi_item_mod_ids,
                        "prices": p1,
                        "same_compact_desc": (c1 == c2)
                    })

    print(f"\nTotal duplicate pairs with ACTIVE prices, same width, same prices: {len(duplicates)}")
    by_f = defaultdict(int)
    for d in duplicates:
        by_f[d['fornecedor']] += 1
    for k, v in by_f.items():
        print(f"  - {k}: {v} pairs")

    print("\nDetailed list of all duplicate pairs:")
    for i, d in enumerate(duplicates):
        print(f"[{i+1}] {d['fornecedor']} | {d['marca']} | L: {d['m1_larg']} | Same compact desc: {d['same_compact_desc']}")
        print(f"     M1 ({d['m1_id']}): {repr(d['m1_desc'])} (sub={d['m1_in_sub']}, pi={d['m1_in_pi']})")
        print(f"     M2 ({d['m2_id']}): {repr(d['m2_desc'])} (sub={d['m2_in_sub']}, pi={d['m2_in_pi']})")
        print(f"     Prices: {d['prices']}")

if __name__ == '__main__':
    main()
