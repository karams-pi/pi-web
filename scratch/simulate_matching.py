import psycopg2
import openpyxl
import re
import unicodedata
from parse_excel import parse_sheet

def normalize(text):
    if not text:
        return ""
    nfkd_form = unicodedata.normalize('NFKD', text)
    text = "".join([c for c in nfkd_form if not unicodedata.combining(c)])
    text = text.lower().strip()
    text = re.sub(r'\s+', ' ', text)
    # Replace special quotes or characters
    text = text.replace('´', "'").replace('’', "'")
    return text

def main():
    # 1. Load Excel
    path = r"c:\Portifólio\pi-web\Docs\New\Karams 2026 - Abimad 42 (Exportação).xlsm"
    wb = openpyxl.load_workbook(path, data_only=True)
    
    sheet_modules = []
    for sname in wb.sheetnames:
        if "Karam" in sname:
            sheet = wb[sname]
            mods = parse_sheet(sheet, sname)
            sheet_modules.extend(mods)
            
    # 2. Connect to DB
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    # Cache all Brands (pi.marca)
    cur.execute("SELECT id, nome FROM pi.marca;")
    brand_map = {normalize(row[1]): row[0] for row in cur.fetchall()}
    
    # Cache all categories (pi.categoria)
    cur.execute("SELECT id, nome FROM pi.categoria;")
    cat_map = {normalize(row[1]): row[0] for row in cur.fetchall()}
    
    # Cache all existing DB modules for Karams
    cur.execute("""
        SELECT m.id, m.id_marca, m.descricao, m.largura, m.profundidade, m.altura, m.pa, m.m3, m.id_categoria
        FROM pi.modulo m
        WHERE m.id_fornecedor = 1;
    """)
    db_modules = []
    for row in cur.fetchall():
        db_modules.append({
            "id": row[0],
            "id_marca": row[1],
            "descricao_raw": row[2],
            "descricao_norm": normalize(row[2]),
            "largura": float(row[3]),
            "profundidade": float(row[4]),
            "altura": float(row[5]),
            "pa": float(row[6]),
            "m3": float(row[7]),
            "id_categoria": row[8]
        })
        
    print(f"\nLoaded {len(db_modules)} Karams modules from DB.")
    
    matched_count = 0
    new_count = 0
    matches = []
    unmatched = []
    
    for m in sheet_modules:
        model_norm = normalize(m["model"])
        # Find brand ID
        brand_id = brand_map.get(model_norm)
        if not brand_id:
            # Missing brand, so this is definitely a new module
            unmatched.append((m, "Brand not in DB"))
            new_count += 1
            continue
            
        desc_norm = normalize(m["description"])
        
        # Try to find a match in db_modules
        found = None
        for dbm in db_modules:
            if dbm["id_marca"] == brand_id and dbm["descricao_norm"] == desc_norm:
                # Compare dimensions
                if abs(dbm["largura"] - m["width"]) < 0.02 and abs(dbm["profundidade"] - m["prof"]) < 0.02:
                    found = dbm
                    break
                    
        if found:
            matched_count += 1
            matches.append((m, found))
        else:
            unmatched.append((m, "No dimension or description match"))
            new_count += 1
            
    print(f"\nMatching Results:")
    print(f"  Matched modules: {matched_count}")
    print(f"  New modules: {new_count}")
    
    # Save a report
    with open(r"c:\Portifólio\pi-web\scratch\matching_report.txt", "w", encoding="utf-8") as f:
        f.write("=== MATCHED MODULES ===\n")
        for m, dbm in matches:
            f.write(f"Sheet: Row={m['row']:3d} | Desc={m['description']:<35} | W={m['width']:.2f} | D={m['prof']:.2f}  <--->  DB: ID={dbm['id']:4d} | Desc={dbm['descricao_raw']:<35} | W={dbm['largura']:.2f} | D={dbm['profundidade']:.2f}\n")
            
        f.write("\n=== UNMATCHED (NEW) MODULES ===\n")
        for m, reason in unmatched:
            f.write(f"Sheet: Row={m['row']:3d} | Model={m['model']:<20} | Desc={m['description']:<35} | W={m['width']:.2f} | D={m['prof']:.2f} | Reason={reason}\n")
            
    cur.close()
    conn.close()
    print("\nSaved report to c:\\Portifólio\\pi-web\\scratch\\matching_report.txt")

if __name__ == "__main__":
    main()
