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

    cur.execute("""
        SELECT mt.id_modulo, t.nome, mt.valor_tecido
        FROM pi.modulo_tecido mt
        JOIN pi.tecido t ON mt.id_tecido = t.id
        WHERE mt.fl_ativo = true;
    """)
    active_prices = {}
    for mid, tname, val in cur.fetchall():
        active_prices.setdefault(mid, {})[tname] = round(float(val), 2)

    cur.execute("SELECT id_modulo, count(*) FROM pi.sub_modulo GROUP BY id_modulo;")
    in_sub = dict(cur.fetchall())

    cur.execute("SELECT mt.id_modulo, count(*) FROM pi.pi_item p JOIN pi.modulo_tecido mt ON p.id_modulo_tecido = mt.id GROUP BY mt.id_modulo;")
    in_pi = dict(cur.fetchall())

    by_forn_marca = defaultdict(list)
    for m in modules:
        by_forn_marca[(m[1], m[3])].append(m)

    active_dups = []

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

                if p1_act and p2_act and set(p1_act.keys()) == set(p2_act.keys()) and all(abs(p1_act[k] - p2_act[k]) < 0.05 for k in p1_act):
                    active_dups.append({
                        "fornecedor": m1[2],
                        "marca": m1[4],
                        "largura": larg1,
                        "m1_id": m1[0],
                        "m1_desc": m1[5],
                        "m1_prof": float(m1[7]),
                        "m1_alt": float(m1[8]),
                        "m1_m3": float(m1[9]),
                        "m1_sub_count": in_sub.get(m1[0], 0),
                        "m1_pi_count": in_pi.get(m1[0], 0),
                        "m2_id": m2[0],
                        "m2_desc": m2[5],
                        "m2_prof": float(m2[7]),
                        "m2_alt": float(m2[8]),
                        "m2_m3": float(m2[9]),
                        "m2_sub_count": in_sub.get(m2[0], 0),
                        "m2_pi_count": in_pi.get(m2[0], 0),
                        "prices": p1_act,
                        "compact_match": (c1 == c2)
                    })

    for i, d in enumerate(active_dups, 1):
        print(f"[{i:02d}] Fornecedor: {d['fornecedor']} | Marca: {d['marca']} | Larg: {d['largura']:.2f}m")
        print(f"     Módulo 1 (ID {d['m1_id']}): {repr(d['m1_desc'])}")
        print(f"       Dims: L={d['largura']:.2f} P={d['m1_prof']:.2f} A={d['m1_alt']:.2f} M3={d['m1_m3']:.2f} | SubModulos: {d['m1_sub_count']} | PiItens: {d['m1_pi_count']}")
        print(f"     Módulo 2 (ID {d['m2_id']}): {repr(d['m2_desc'])}")
        print(f"       Dims: L={d['largura']:.2f} P={d['m2_prof']:.2f} A={d['m2_alt']:.2f} M3={d['m2_m3']:.2f} | SubModulos: {d['m2_sub_count']} | PiItens: {d['m2_pi_count']}")
        print(f"     Tecidos/Preços: {d['prices']}")
        print(f"     Descrições equivalentes? {d['compact_match']}")
        print()

if __name__ == '__main__':
    run()
