import openpyxl
import psycopg2
import re
import unicodedata

def normalize(text):
    if not text:
        return ""
    # NFKD normalizes accents, lowercasing, stripping extra spaces
    nfkd_form = unicodedata.normalize('NFKD', str(text))
    text = "".join([c for c in nfkd_form if not unicodedata.combining(c)])
    text = text.upper().strip()
    text = re.sub(r'\s+', ' ', text)
    # Replace some symbols
    text = text.replace('´', "'").replace('’', "'").replace('Ç', 'C').replace('Ã', 'A').replace('Õ', 'O')
    text = text.replace('É', 'E').replace('È', 'E').replace('Á', 'A').replace('À', 'A').replace('Ó', 'O')
    text = text.replace('Í', 'I').replace('Ú', 'U').replace('Â', 'A').replace('Ê', 'E').replace('Ô', 'O')
    return text

def clean_val(val):
    if val is None:
        return 0.0
    val_str = str(val).strip().lower()
    if val_str in ("", "none", "-", "0", "0.0"):
        return 0.0
    matches = re.findall(r'(\d+[\.,]\d+|\d+)', val_str)
    if matches:
        return float(matches[0].replace(',', '.'))
    return 0.0

def extract_width(comp_str):
    if comp_str is None:
        return None
    comp_str = str(comp_str).strip()
    matches = re.findall(r'(\d+[\.,]\d+|\d+)', comp_str)
    if matches:
        return float(matches[-1].replace(',', '.'))
    return None

def parse_depth(prof_str):
    if prof_str is None:
        return None
    prof_str = str(prof_str).strip().replace(',', '.')
    if "f:" in prof_str.lower():
        m = re.search(r'f:\s*([\d.]+)', prof_str.lower())
        if m:
            return float(m.group(1))
    return clean_val(prof_str)

def main():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    # Cache brand name mapping
    cur.execute("SELECT id, nome FROM pi.marca;")
    brand_map = {normalize(r[1]): r[0] for r in cur.fetchall()}
    
    # Load existing modules for Ferguile (3)
    cur.execute("""
        SELECT m.id, ma.nome, m.descricao, m.largura, m.profundidade, m.altura, m.m3, m.id_marca
        FROM pi.modulo m
        JOIN pi.marca ma ON m.id_marca = ma.id
        WHERE m.id_fornecedor = 3;
    """)
    db_ferguile = []
    for r in cur.fetchall():
        db_ferguile.append({
            "id": r[0],
            "brand_name": normalize(r[1]),
            "descricao_raw": r[2],
            "descricao_norm": normalize(r[2]),
            "largura": float(r[3]),
            "profundidade": float(r[4]),
            "altura": float(r[5]),
            "m3": float(r[6]),
            "id_marca": r[7]
        })
        
    # Load existing modules for Livintus (4)
    cur.execute("""
        SELECT m.id, ma.nome, m.descricao, m.largura, m.profundidade, m.altura, m.m3, m.id_marca
        FROM pi.modulo m
        JOIN pi.marca ma ON m.id_marca = ma.id
        WHERE m.id_fornecedor = 4;
    """)
    db_livintus = []
    for r in cur.fetchall():
        db_livintus.append({
            "id": r[0],
            "brand_name": normalize(r[1]),
            "descricao_raw": r[2],
            "descricao_norm": normalize(r[2]),
            "largura": float(r[3]),
            "profundidade": float(r[4]),
            "altura": float(r[5]),
            "m3": float(r[6]),
            "id_marca": r[7]
        })

    # Read Ferguile
    wb_fer = openpyxl.load_workbook("Docs/TABELA FERGUILE_EXPORTAÇÃO_MOVELSUL_2026.xlsx", data_only=True)
    sheet_fer = wb_fer['EXW']
    fer_modules = []
    current_brand = None
    for r in range(3, sheet_fer.max_row + 1):
        brand_val = sheet_fer.cell(row=r, column=2).value
        if brand_val and str(brand_val).strip() and str(brand_val).strip() != "-":
            current_brand = str(brand_val).strip()
            
        comp_val = sheet_fer.cell(row=r, column=3).value
        if comp_val is not None:
            prof_val = sheet_fer.cell(row=r, column=4).value
            alt_val = sheet_fer.cell(row=r, column=5).value
            m3_val = sheet_fer.cell(row=r, column=9).value
            desc_val = sheet_fer.cell(row=r, column=12).value
            
            width = extract_width(comp_val)
            depth = parse_depth(prof_val)
            height = clean_val(alt_val)
            m3 = clean_val(m3_val) or 0.0
            desc = str(desc_val).strip() if desc_val else ""
            
            fer_modules.append({
                "brand": current_brand,
                "desc": desc,
                "width": width,
                "depth": depth,
                "height": height,
                "m3": m3,
                "row": r
            })
            
    # Read Livintus
    wb_liv = openpyxl.load_workbook("Docs/TABELA LIVINTUS_EXPORTAÇÃO_MOVELSUL_2026.xlsx", data_only=True)
    sheet_liv = wb_liv['LIVINTUS COURO']
    liv_modules = []
    current_brand = None
    for r in range(3, sheet_liv.max_row + 1):
        brand_val = sheet_liv.cell(row=r, column=2).value
        if brand_val and str(brand_val).strip() and str(brand_val).strip() != "-":
            current_brand = str(brand_val).strip()
            
        comp_val = sheet_liv.cell(row=r, column=3).value
        if comp_val is not None:
            alt_val = sheet_liv.cell(row=r, column=4).value
            prof_val = sheet_liv.cell(row=r, column=5).value
            desc_val = sheet_liv.cell(row=r, column=6).value
            
            width = extract_width(comp_val)
            depth = clean_val(prof_val)
            height = clean_val(alt_val)
            desc = str(desc_val).strip() if desc_val else ""
            
            m3 = 0.0
            if isinstance(width, float) and isinstance(depth, float) and isinstance(height, float):
                m3 = round(width * depth * height, 4)
                
            liv_modules.append({
                "brand": current_brand,
                "desc": desc,
                "width": width,
                "depth": depth,
                "height": height,
                "m3": m3,
                "row": r
            })

    def match_supplier_modules(parsed_list, db_list, supplier_name):
        print(f"\n--- MATCHING RESULTS FOR {supplier_name.upper()} ---")
        exact_matches = 0
        dim_matches_diff_desc = 0
        desc_matches_diff_dim = 0
        no_matches = []
        
        for p in parsed_list:
            p_brand_norm = normalize(p["brand"])
            p_desc_norm = normalize(p["desc"])
            p_w = p["width"]
            p_d = p["depth"]
            p_h = p["height"]
            
            found = False
            # Try to find EXACT match (brand + desc + width + depth + height)
            for db in db_list:
                if db["brand_name"] == p_brand_norm:
                    if db["descricao_norm"] == p_desc_norm:
                        if p_w is not None and abs(db["largura"] - p_w) < 0.02 and p_d is not None and abs(db["profundidade"] - p_d) < 0.02:
                            exact_matches += 1
                            found = True
                            break
            if found:
                continue
                
            # Try to find match on DIMENSIONS only (brand + width + depth + height)
            for db in db_list:
                if db["brand_name"] == p_brand_norm:
                    if p_w is not None and abs(db["largura"] - p_w) < 0.02 and p_d is not None and abs(db["profundidade"] - p_d) < 0.02:
                        dim_matches_diff_desc += 1
                        print(f"Row {p['row']}: Dim-Match only | Brand: {p['brand']} | Sheet Desc: '{p['desc']}' vs DB Desc: '{db['descricao_raw']}' | L={p_w} P={p_d}")
                        found = True
                        break
            if found:
                continue
                
            # Try to find match on DESCRIPTION only (brand + description)
            for db in db_list:
                if db["brand_name"] == p_brand_norm:
                    if db["descricao_norm"] == p_desc_norm:
                        desc_matches_diff_dim += 1
                        print(f"Row {p['row']}: Desc-Match only | Brand: {p['brand']} | Desc: '{p['desc']}' | Sheet L={p_w} P={p_d} vs DB L={db['largura']} P={db['profundidade']}")
                        found = True
                        break
            if found:
                continue
                
            no_matches.append(p)
            
        print(f"Total Parsed: {len(parsed_list)}")
        print(f"Exact Matches: {exact_matches}")
        print(f"Dimension Matches (diff desc): {dim_matches_diff_desc}")
        print(f"Description Matches (diff dim): {desc_matches_diff_dim}")
        print(f"Unmatched: {len(no_matches)}")
        if no_matches:
            print("Unmatched items (first 10):")
            for item in no_matches[:10]:
                print(f"  Row {item['row']} | Brand: {item['brand']} | Desc: '{item['desc']}' | W={item['width']} D={item['depth']} H={item['height']}")

    match_supplier_modules(fer_modules, db_ferguile, "Ferguile")
    match_supplier_modules(liv_modules, db_livintus, "Livintus")
    
    cur.close()
    conn.close()

if __name__ == "__main__":
    main()
