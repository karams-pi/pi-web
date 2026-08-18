import openpyxl
import re
import psycopg2
import unicodedata
import os

def normalize(text):
    if not text:
        return ""
    nfkd_form = unicodedata.normalize('NFKD', str(text))
    text = "".join([c for c in nfkd_form if not unicodedata.combining(c)])
    text = text.upper().strip()
    text = re.sub(r'\s+', ' ', text)
    # Normalize character replacements for comparison
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

def extract_pa(desc):
    if not desc:
        return 0.0
    desc = desc.replace(',', '.')
    m = re.search(r'assentos?\s+s/b[cç]:\s*([\d.]+)', desc.lower())
    if m:
        return float(m.group(1))
    return 0.0

def main():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    # 1. Cache brands
    cur.execute("SELECT id, nome FROM pi.marca;")
    brand_map = {normalize(r[1]): r[0] for r in cur.fetchall()}
    
    # 2. Cache fabrics
    cur.execute("SELECT id, nome FROM pi.tecido;")
    tecido_map = {normalize(r[1]): r[0] for r in cur.fetchall()}
    
    # 3. Cache active prices in modulo_tecido: (id_modulo, id_tecido) -> active_price_id
    cur.execute("SELECT id_modulo, id_tecido, id FROM pi.modulo_tecido WHERE fl_ativo = true;")
    active_prices = {(r[0], r[1]): r[2] for r in cur.fetchall()}
    
    # 4. Load DB modules for Ferguile (3)
    cur.execute("""
        SELECT m.id, ma.nome, m.descricao, m.largura, m.profundidade, m.altura, m.m3, m.id_marca,
               (SELECT EXISTS (SELECT 1 FROM pi.modulo_tecido mt WHERE mt.id_modulo = m.id AND mt.fl_ativo = true)) as has_active
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
            "id_marca": r[7],
            "has_active": r[8]
        })
    # Sort so modules with active prices are checked first
    db_ferguile.sort(key=lambda x: x["has_active"], reverse=True)
        
    # 5. Load DB modules for Livintus (4)
    cur.execute("""
        SELECT m.id, ma.nome, m.descricao, m.largura, m.profundidade, m.altura, m.m3, m.id_marca,
               (SELECT EXISTS (SELECT 1 FROM pi.modulo_tecido mt WHERE mt.id_modulo = m.id AND mt.fl_ativo = true)) as has_active
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
            "id_marca": r[7],
            "has_active": r[8]
        })
    # Sort so modules with active prices are checked first
    db_livintus.sort(key=lambda x: x["has_active"], reverse=True)
    
    print(f"Loaded DB Metadata:")
    print(f"  Brands cached: {len(brand_map)}")
    print(f"  Fabrics cached: {len(tecido_map)}")
    print(f"  Active prices in DB: {len(active_prices)}")
    print(f"  Ferguile modules in DB: {len(db_ferguile)}")
    print(f"  Livintus modules in DB: {len(db_livintus)}")

    # 6. Parse Ferguile XLSX
    print("\nParsing Ferguile XLSX...")
    wb_fer = openpyxl.load_workbook("Docs/TABELA FERGUILE_EXPORTAÇÃO_MOVELSUL_2026.xlsx", data_only=True)
    sheet_fer = wb_fer['EXW']
    current_brand = None
    fer_modules = []
    
    for r in range(3, sheet_fer.max_row + 1):
        brand_val = sheet_fer.cell(row=r, column=2).value
        if brand_val and str(brand_val).strip() and str(brand_val).strip() != "-":
            current_brand = str(brand_val).strip()
            
        comp_val = sheet_fer.cell(row=r, column=3).value
        if comp_val is not None:
            prof_val = sheet_fer.cell(row=r, column=4).value
            alt_val = sheet_fer.cell(row=r, column=5).value
            m3_val = sheet_fer.cell(row=r, column=9).value # Vol m3 is in Column I
            desc_val = sheet_fer.cell(row=r, column=12).value # Composição in Column L
            
            width = extract_width(comp_val)
            depth = parse_depth(prof_val)
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
                "row": r
            }
            fer_modules.append(current_module)
            
        linha_val = sheet_fer.cell(row=r, column=13).value # LINHA (M)
        reais_val = sheet_fer.cell(row=r, column=14).value # VALOR EM REAIS (N)
        
        if fer_modules and reais_val is not None and linha_val is not None:
            linha_str = str(linha_val).strip().upper()
            price = clean_val(reais_val)
            if isinstance(price, float) and price > 0:
                fer_modules[-1]["prices"][linha_str] = price

    print(f"Parsed {len(fer_modules)} modules from Ferguile XLSX.")

    # 7. Parse Livintus XLSX
    print("\nParsing Livintus XLSX...")
    wb_liv = openpyxl.load_workbook("Docs/TABELA LIVINTUS_EXPORTAÇÃO_MOVELSUL_2026.xlsx", data_only=True)
    sheet_liv = wb_liv['LIVINTUS COURO']
    current_brand = None
    liv_modules = []
    
    for r in range(3, sheet_liv.max_row + 1):
        brand_val = sheet_liv.cell(row=r, column=2).value
        if brand_val and str(brand_val).strip():
            brand_str = str(brand_val).strip()
            if brand_str != "-":
                current_brand = brand_str
                
        comp_val = sheet_liv.cell(row=r, column=3).value
        if comp_val is not None:
            alt_val = sheet_liv.cell(row=r, column=4).value # ALTURA (D)
            prof_val = sheet_liv.cell(row=r, column=5).value # PROF (E)
            desc_val = sheet_liv.cell(row=r, column=6).value # COMPOSIÇÃO (F)
            
            width = extract_width(comp_val)
            depth = clean_val(prof_val)
            height = clean_val(alt_val)
            desc = str(desc_val).strip() if desc_val else ""
            
            # calculate volume rounded to 2 decimals
            m3 = 0.0
            if isinstance(width, float) and isinstance(depth, float) and isinstance(height, float):
                m3 = round(width * depth * height, 2)
                
            current_module = {
                "brand": current_brand,
                "comp_raw": comp_val,
                "desc": desc,
                "width": width,
                "depth": depth,
                "height": height,
                "m3": m3,
                "prices": {},
                "row": r
            }
            liv_modules.append(current_module)
            
        linha_val = sheet_liv.cell(row=r, column=7).value # LINHA (G)
        reais_val = sheet_liv.cell(row=r, column=8).value # VALOR EM REAIS (H)
        
        if liv_modules and reais_val is not None and linha_val is not None:
            linha_str = str(linha_val).strip().upper()
            price = clean_val(reais_val)
            if isinstance(price, float) and price > 0:
                liv_modules[-1]["prices"][linha_str] = price

    print(f"Parsed {len(liv_modules)} modules from Livintus XLSX.")

    # 8. Smart Matching and SQL Generation
    def find_match(p, db_list):
        p_brand_norm = normalize(p["brand"])
        p_desc_norm = normalize(p["desc"])
        p_w = p["width"]
        p_d = p["depth"]
        p_h = p["height"]
        
        # 1. Exact match (brand + desc + width + depth) within 2cm
        for db in db_list:
            if db["brand_name"] == p_brand_norm:
                if db["descricao_norm"] == p_desc_norm:
                    if p_w is not None and abs(db["largura"] - p_w) < 0.02 and p_d is not None and abs(db["profundidade"] - p_d) < 0.02:
                        return db, "Exact Match"
                        
        # 2. Dimension match only (brand + width + depth) within 2cm
        for db in db_list:
            if db["brand_name"] == p_brand_norm:
                if p_w is not None and abs(db["largura"] - p_w) < 0.02 and p_d is not None and abs(db["profundidade"] - p_d) < 0.02:
                    return db, "Dimension Match (diff desc)"
                    
        # 3. Swapped dimensions match (brand + width + depth/height swapped) within 2cm
        for db in db_list:
            if db["brand_name"] == p_brand_norm:
                if p_w is not None and abs(db["largura"] - p_w) < 0.02:
                    if p_h is not None and abs(db["profundidade"] - p_h) < 0.02 and p_d is not None and abs(db["altura"] - p_d) < 0.02:
                        return db, "Swapped Dimensions Match"
                        
        # 4. Recliner description match (brand + description + width) within 2cm
        for db in db_list:
            if db["brand_name"] == p_brand_norm:
                if db["descricao_norm"] == p_desc_norm:
                    if p_w is not None and abs(db["largura"] - p_w) < 0.02:
                        return db, "Recliner Match (desc + width)"
                        
        # 5. Insieme width-based match (brand = INSIEME + width) within 2cm
        if p_brand_norm == "INSIEME":
            for db in db_list:
                if db["brand_name"] == "INSIEME":
                    if p_w is not None and abs(db["largura"] - p_w) < 0.02:
                        return db, "Insieme Width Match"
                        
        return None, "No Match"

    sql_lines = []
    sql_lines.append("-- ==========================================================================")
    sql_lines.append("-- IMPORTAÇÃO DE PREÇOS E MÓDULOS DE FEIRAS 2026 (FERGUILE E LIVINTUS)")
    sql_lines.append("-- Gerado automaticamente para incluir novos e atualizar existentes")
    sql_lines.append("-- ==========================================================================\n")
    
    sql_lines.append("BEGIN TRANSACTION;\n")
    
    # Collection of brands and fabrics to ensure in DB
    brands_to_ensure = set()
    fabrics_to_ensure = set()
    
    # First, collect all unique brands and fabrics from parsed data
    for m in fer_modules:
        if m["brand"]:
            brands_to_ensure.add(m["brand"])
        for fab in m["prices"].keys():
            fabrics_to_ensure.add(fab)
            
    for m in liv_modules:
        if m["brand"]:
            brands_to_ensure.add(m["brand"])
        for fab in m["prices"].keys():
            # Let's clean the fabric name if it has slash or spaces
            fabrics_to_ensure.add(fab)

    sql_lines.append("-- 1. Garantir que todas as marcas/modelos existem no banco de dados")
    for b in sorted(list(brands_to_ensure)):
        b_esc = b.replace("'", "''")
        sql_lines.append(f"INSERT INTO pi.marca (nome, fl_ativo) SELECT '{b_esc}', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = '{b.upper()}');")
    sql_lines.append("")
    
    sql_lines.append("-- 2. Garantir que todos os tecidos/couros existem no banco de dados")
    for f in sorted(list(fabrics_to_ensure)):
        f_esc = f.replace("'", "''")
        sql_lines.append(f"INSERT INTO pi.tecido (nome) SELECT '{f_esc}' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = '{f.upper()}');")
    sql_lines.append("")

    # Helper function to generate updates and inserts
    def generate_sql_for_module(m, db_match, match_type, supplier_id, cat_id, stats):
        lines = []
        brand_esc = m["brand"].replace("'", "''")
        desc_esc = m["desc"].replace("'", "''")
        
        # Calculate PA
        pa = extract_pa(m["desc"]) if supplier_id == 3 else 0.0
        
        if db_match:
            # Update existing module
            db_id = db_match["id"]
            lines.append(f"-- Planilha Linha {m['row']} | Marca: {m['brand']} | ID Existente: {db_id} ({match_type})")
            lines.append(
                f"UPDATE pi.modulo "
                f"SET largura = {m['width']:.2f}, profundidade = {m['depth']:.2f}, altura = {m['height']:.2f}, pa = {pa:.2f}, descricao = '{desc_esc}' "
                f"WHERE id = {db_id};"
            )
            stats["updates"] += 1
            
            # Upsert prices
            for fab_name, price in m["prices"].items():
                # We need to map fabric to DB ID (using subquery)
                # First let's check if price was active in DB.
                # In Python script, we don't know the fabric ID dynamically on another DB, so we use a conditional insert/update or just update/insert.
                # Wait, PostgreSQL doesn't have a direct IF EXISTS inside SQL script unless we write PL/pgSQL, but we can write:
                # UPDATE ...; INSERT WHERE NOT EXISTS ...;
                # Let's generate a clean standard update followed by insert-if-not-exists block:
                fab_esc = fab_name.replace("'", "''")
                lines.append(
                    f"UPDATE pi.modulo_tecido "
                    f"SET valor_tecido = {price:.3f}, dt_ultima_revisao = NOW() "
                    f"WHERE id_modulo = {db_id} AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = '{fab_name.upper()}' LIMIT 1) AND fl_ativo = true;"
                )
                lines.append(
                    f"INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) "
                    f"SELECT {db_id}, (SELECT id FROM pi.tecido WHERE UPPER(nome) = '{fab_name.upper()}' LIMIT 1), {price:.3f}, true, NOW() "
                    f"WHERE NOT EXISTS ("
                    f"  SELECT 1 FROM pi.modulo_tecido "
                    f"  WHERE id_modulo = {db_id} AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = '{fab_name.upper()}' LIMIT 1) AND fl_ativo = true"
                    f");"
                )
                stats["prices"] += 1
        else:
            # Insert new module
            lines.append(f"-- Planilha Linha {m['row']} | Marca: {m['brand']} | Novo Módulo")
            lines.append("WITH new_mod AS (")
            lines.append(
                f"  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa) "
                f"  VALUES ({supplier_id}, {cat_id}, (SELECT id FROM pi.marca WHERE UPPER(nome) = '{m['brand'].upper()}' LIMIT 1), '{desc_esc}', {m['width']:.2f}, {m['depth']:.2f}, {m['height']:.2f}, {pa:.2f}) "
                f"  RETURNING id"
            )
            lines.append(")")
            lines.append("INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)")
            lines.append("VALUES")
            
            price_vals = []
            for fab_name, price in m["prices"].items():
                price_vals.append(f"  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = '{fab_name.upper()}' LIMIT 1), {price:.3f}, true, NOW())")
                stats["prices"] += 1
            lines.append(",\n".join(price_vals) + ";")
            stats["inserts"] += 1
            
        lines.append("")
        return lines

    stats_fer = {"updates": 0, "inserts": 0, "prices": 0}
    sql_lines.append("-- 3. IMPORTAÇÃO FERGUILE (Fornecedor 3 | Categoria 26)")
    sql_lines.append("-- ==========================================================================\n")
    for m in fer_modules:
        db_match, match_type = find_match(m, db_ferguile)
        sql_lines.extend(generate_sql_for_module(m, db_match, match_type, 3, 26, stats_fer))
        
    stats_liv = {"updates": 0, "inserts": 0, "prices": 0}
    sql_lines.append("-- 4. IMPORTAÇÃO LIVINTUS (Fornecedor 4 | Categoria 27)")
    sql_lines.append("-- ==========================================================================\n")
    for m in liv_modules:
        db_match, match_type = find_match(m, db_livintus)
        sql_lines.extend(generate_sql_for_module(m, db_match, match_type, 4, 27, stats_liv))
        
    sql_lines.append("COMMIT;")
    
    # Write SQL to file
    sql_content = "\n".join(sql_lines)
    os.makedirs("Docs", exist_ok=True)
    with open("Docs/import_feiras_2026.sql", "w", encoding="utf-8") as f:
        f.write(sql_content)
        
    print(f"\nSQL script written successfully to Docs/import_feiras_2026.sql")
    print(f"Ferguile Stats: Updates={stats_fer['updates']}, Inserts={stats_fer['inserts']}, Prices={stats_fer['prices']}")
    print(f"Livintus Stats: Updates={stats_liv['updates']}, Inserts={stats_liv['inserts']}, Prices={stats_liv['prices']}")
    
    # 9. Verify by running transaction locally (then committing)
    print("\nApplying SQL to local database...")
    try:
        cur.execute(sql_content)
        conn.commit()
        print("Success! SQL script applied successfully to local database.")
    except Exception as e:
        conn.rollback()
        print(f"Error applying SQL: {e}")
        raise e
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    main()
