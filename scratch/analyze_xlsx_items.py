import openpyxl
import psycopg2
import re
import unicodedata

def normalize(text):
    if not text:
        return ""
    nfkd_form = unicodedata.normalize('NFKD', text)
    text = "".join([c for c in nfkd_form if not unicodedata.combining(c)])
    text = text.upper().strip()
    text = re.sub(r'\s+', ' ', text)
    return text

def clean_val(val):
    if val is None:
        return None
    if isinstance(val, str):
        val = val.strip()
        if val == "" or val.lower() == "none" or val == "-" or val == "0":
            return None
        # Replace comma with dot
        val = val.replace(',', '.')
        try:
            return float(val)
        except ValueError:
            return val
    return float(val)

def extract_width(comp_str):
    if not comp_str:
        return None
    comp_str = str(comp_str).strip()
    # Try to find something like "1,08m" or "0,75m" or "2.1"
    # Match decimal numbers like 1,08 or 1.08 or 2
    match = re.search(r'(\d+[\.,]\d+|\d+)\s*m?', comp_str)
    if match:
        val = match.group(1).replace(',', '.')
        try:
            return float(val)
        except ValueError:
            return None
    return None

def main():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    # 1. Load active brands
    cur.execute("SELECT id, nome FROM pi.marca;")
    brand_map = {normalize(r[1]): r[0] for r in cur.fetchall()}
    
    # 2. Load active fabrics
    cur.execute("SELECT id, nome FROM pi.tecido;")
    tecido_map = {normalize(r[1]): r[0] for r in cur.fetchall()}
    
    # 3. Load existing modules for Ferguile (3)
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
            "descricao_norm": normalize(r[2]),
            "largura": float(r[3]),
            "profundidade": float(r[4]),
            "altura": float(r[5]),
            "m3": float(r[6]),
            "id_marca": r[7]
        })
        
    # 4. Load existing modules for Livintus (4)
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
            "descricao_norm": normalize(r[2]),
            "largura": float(r[3]),
            "profundidade": float(r[4]),
            "altura": float(r[5]),
            "m3": float(r[6]),
            "id_marca": r[7]
        })
        
    print(f"Loaded from DB: {len(db_ferguile)} Ferguile modules, {len(db_livintus)} Livintus modules.")
    
    # Parse Ferguile XLSX
    print("\n=== Parsing Ferguile XLSX ===")
    wb_fer = openpyxl.load_workbook("Docs/TABELA FERGUILE_EXPORTAÇÃO_MOVELSUL_2026.xlsx", data_only=True)
    sheet_fer = wb_fer['EXW']
    
    current_brand = None
    fer_modules = []
    
    for r in range(3, sheet_fer.max_row + 1):
        brand_val = sheet_fer.cell(row=r, column=2).value
        if brand_val and str(brand_val).strip() and str(brand_val).strip() != "-":
            current_brand = str(brand_val).strip()
            
        comp_val = sheet_fer.cell(row=r, column=3).value
        # If Column C is filled, it's the start of a new module description
        if comp_val is not None:
            # New module row
            prof_val = sheet_fer.cell(row=r, column=4).value
            alt_val = sheet_fer.cell(row=r, column=5).value
            m3_val = sheet_fer.cell(row=r, column=9).value # Vol m3 is in Column I
            desc_val = sheet_fer.cell(row=r, column=12).value # Composição in Column L
            
            # Extract width
            width = extract_width(comp_val)
            if width is None:
                # Fallback: maybe description has it or it's a number
                width = clean_val(comp_val)
                
            depth = clean_val(prof_val)
            if isinstance(depth, str):
                # e.g., "F:1,13 A:1,60" -> closed is 1.13
                # Let's see if we can parse it
                m = re.search(r'F:\s*([\d,]+)', depth)
                if m:
                    depth = float(m.group(1).replace(',', '.'))
                else:
                    depth = 0.0
                    
            height = clean_val(alt_val)
            m3 = clean_val(m3_val) or 0.0
            desc = str(desc_val).strip() if desc_val else ""
            
            current_module = {
                "brand": current_brand,
                "comp_raw": comp_val,
                "desc": desc,
                "width": width,
                "depth": depth,
                "height": height,
                "m3": m3,
                "prices": {},
                "rows": [r]
            }
            fer_modules.append(current_module)
        
        # Add price for current row
        linha_val = sheet_fer.cell(row=r, column=13).value # LINHA (M)
        reais_val = sheet_fer.cell(row=r, column=14).value # VALOR EM REAIS (N)
        
        if fer_modules and reais_val is not None and linha_val is not None:
            linha_str = str(linha_val).strip().upper()
            price = clean_val(reais_val)
            if isinstance(price, float) and price > 0:
                fer_modules[-1]["prices"][linha_str] = price
            fer_modules[-1]["rows"].append(r)
            
    print(f"Parsed {len(fer_modules)} modules from Ferguile Excel.")
    
    # Parse Livintus XLSX
    print("\n=== Parsing Livintus XLSX ===")
    wb_liv = openpyxl.load_workbook("Docs/TABELA LIVINTUS_EXPORTAÇÃO_MOVELSUL_2026.xlsx", data_only=True)
    sheet_liv = wb_liv['LIVINTUS COURO']
    
    current_brand = None
    liv_modules = []
    
    for r in range(3, sheet_liv.max_row + 1):
        brand_val = sheet_liv.cell(row=r, column=2).value
        if brand_val and str(brand_val).strip() and str(brand_val).strip() != "-":
            current_brand = str(brand_val).strip()
            
        comp_val = sheet_liv.cell(row=r, column=3).value
        if comp_val is not None:
            alt_val = sheet_liv.cell(row=r, column=4).value # ALTURA (D)
            prof_val = sheet_liv.cell(row=r, column=5).value # PROF (E)
            desc_val = sheet_liv.cell(row=r, column=6).value # COMPOSIÇÃO (F)
            
            width = extract_width(comp_val)
            if width is None:
                width = clean_val(comp_val)
                
            depth = clean_val(prof_val)
            height = clean_val(alt_val)
            desc = str(desc_val).strip() if desc_val else ""
            
            # calculate volume since it's not in sheet: L * P * A (in meters)
            m3 = 0.0
            if isinstance(width, float) and isinstance(depth, float) and isinstance(height, float):
                m3 = round(width * depth * height, 4)
                
            current_module = {
                "brand": current_brand,
                "comp_raw": comp_val,
                "desc": desc,
                "width": width,
                "depth": depth,
                "height": height,
                "m3": m3,
                "prices": {},
                "rows": [r]
            }
            liv_modules.append(current_module)
            
        linha_val = sheet_liv.cell(row=r, column=7).value # LINHA (G)
        reais_val = sheet_liv.cell(row=r, column=8).value # VALOR EM REAIS (H)
        
        if liv_modules and reais_val is not None and linha_val is not None:
            linha_str = str(linha_val).strip().upper()
            price = clean_val(reais_val)
            if isinstance(price, float) and price > 0:
                liv_modules[-1]["prices"][linha_str] = price
            liv_modules[-1]["rows"].append(r)
            
    print(f"Parsed {len(liv_modules)} modules from Livintus Excel.")
    
    cur.close()
    conn.close()

if __name__ == "__main__":
    main()
