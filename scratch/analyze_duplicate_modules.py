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

def main():
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
        ORDER BY m.id_fornecedor, m.id_marca, m.largura, m.id;
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

    by_supplier_brand = defaultdict(list)
    for m in modules:
        by_supplier_brand[(m[1], m[3])].append(m)

    same_price_duplicates = []

    for (forn_id, marca_id), mod_list in by_supplier_brand.items():
        if len(mod_list) < 2:
            continue
        
        for i in range(len(mod_list)):
            for j in range(i + 1, len(mod_list)):
                m1 = mod_list[i]
                m2 = mod_list[j]

                p1 = active_prices.get(m1[0], {})
                p2 = active_prices.get(m2[0], {})

                # If either has no active prices, skip
                if not p1 or not p2:
                    continue

                # Check if prices match
                # They match if the set of fabrics is the same and values are within 0.01
                exact_price_match = (set(p1.keys()) == set(p2.keys()) and all(abs(p1[k] - p2[k]) < 0.05 for k in p1))
                
                # Check subset match: in case one has 3 fabrics and other has 3 fabrics matching
                if not exact_price_match:
                    continue

                larg1 = float(m1[8])
                larg2 = float(m2[8])
                same_larg = abs(larg1 - larg2) < 0.01

                norm1 = normalize_desc(m1[7], m1[4])
                norm2 = normalize_desc(m2[7], m2[4])

                same_price_duplicates.append({
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
                    "m1_has_pi": m1[0] in pi_item_mod_ids,
                    "m1_has_sub": m1[0] in sub_modulo_mod_ids,
                    "m2_id": m2[0],
                    "m2_desc": m2[7],
                    "m2_larg": larg2,
                    "m2_prof": float(m2[9]),
                    "m2_alt": float(m2[10]),
                    "m2_m3": float(m2[11]),
                    "m2_prices": p2,
                    "m2_has_pi": m2[0] in pi_item_mod_ids,
                    "m2_has_sub": m2[0] in sub_modulo_mod_ids,
                    "same_larg": same_larg,
                    "norm1": norm1,
                    "norm2": norm2
                })

    print(f"\n=======================================================")
    print(f"Total pairs with SAME FORNECEDOR, SAME MARCA & SAME PRICES: {len(same_price_duplicates)}")
    print(f"=======================================================\n")
    
    by_supplier_count = defaultdict(int)
    for d in same_price_duplicates:
        by_supplier_count[d['fornecedor']] += 1
    for forn, count in by_supplier_count.items():
        print(f"  - {forn}: {count} duplicate pairs")

    print("\nListing all pairs:")
    for i, d in enumerate(same_price_duplicates):
        print(f"\n--- [{i+1}] {d['fornecedor']} | {d['marca']} | Mesma Largura? {d['same_larg']} ---")
        print(f"  Modulo 1 (ID {d['m1_id']}): {repr(d['m1_desc'])}")
        print(f"    Dim: {d['m1_larg']} x {d['m1_prof']} x {d['m1_alt']} (M3: {d['m1_m3']}) | In PI: {d['m1_has_pi']} | In SubMod: {d['m1_has_sub']}")
        print(f"  Modulo 2 (ID {d['m2_id']}): {repr(d['m2_desc'])}")
        print(f"    Dim: {d['m2_larg']} x {d['m2_prof']} x {d['m2_alt']} (M3: {d['m2_m3']}) | In PI: {d['m2_has_pi']} | In SubMod: {d['m2_has_sub']}")
        print(f"  Preços ({len(d['m1_prices'])} tecidos): {d['m1_prices']}")
        print(f"  Norm1: {repr(d['norm1'])}")
        print(f"  Norm2: {repr(d['norm2'])}")

if __name__ == '__main__':
    main()
