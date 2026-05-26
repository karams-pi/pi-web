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

def get_tecido_base_name(pdf_fab):
    pdf_fab = pdf_fab.upper().strip()
    
    # Check TC 5 digits: TC-10063 -> TC-10
    m = re.match(r'^TC-(\d{2})\d{3}$', pdf_fab)
    if m:
        return f"TC-{m.group(1)}"
        
    # Check TC 3 digits: TC-101 -> TC-14
    m = re.match(r'^TC-\d{3}$', pdf_fab)
    if m:
        return "TC-14"
        
    # Check ST (Suede/Tecido) 5 digits: ST-14055 -> TC-14
    m = re.match(r'^ST-(\d{2})\d{3}$', pdf_fab)
    if m:
        return f"TC-{m.group(1)}"
        
    # Check ST 3 digits
    m = re.match(r'^ST-\d{3}$', pdf_fab)
    if m:
        return "TC-14"
        
    # Check COURO or CR: CR-502 -> CO-5, COURO 702 -> CO-7
    m = re.match(r'^(COURO|CR)-?(\d)\d{2}$', pdf_fab)
    if m:
        return f"CO-{m.group(2)}"
        
    # Standard manual prefix fallbacks
    if pdf_fab.startswith('TC-10'): return 'TC-10'
    if pdf_fab.startswith('TC-12'): return 'TC-12'
    if pdf_fab.startswith('TC-13'): return 'TC-13'
    if pdf_fab.startswith('TC-14'): return 'TC-14'
    if pdf_fab.startswith('TC-16'): return 'TC-16'
    if pdf_fab.startswith('TC-18'): return 'TC-18'
    if pdf_fab.startswith('CR-5') or pdf_fab.startswith('COURO5'): return 'CO-5'
    if pdf_fab.startswith('CR-6') or pdf_fab.startswith('COURO6'): return 'CO-6'
    if pdf_fab.startswith('CR-7') or pdf_fab.startswith('COURO7'): return 'CO-7'
    return None

def parse_pdf():
    pdf_path = r'c:\Portifólio\pi-web\pdf_dump.txt'
    with open(pdf_path, 'r', encoding='utf-8') as f:
        content = f.read()
        
    records = []
    lines = content.split('\n')
    print(f"Total lines in PDF dump: {len(lines)}")
    
    for line_num, line in enumerate(lines):
        line = line.strip()
        if not line or 'ATIVO' not in line:
            continue
            
        match = re.match(r'^(\d+)\s+ATIVO', line)
        if not match:
            continue
            
        code = match.group(1)
        
        # Check units glued to model name
        unit_match = re.search(r'\s+(UN|PC|MT|KG|JG|CJ)\s+(UN|PC|MT|KG|JG|CJ)([A-Z].*)', line, re.IGNORECASE)
        if not unit_match:
            unit_match = re.search(r'\s+(UN|PC|MT|KG|JG|CJ)\s+(UN|PC|MT|KG|JG|CJ)\s+(.*)', line, re.IGNORECASE)
            if not unit_match:
                continue
            
        un_c = unit_match.group(1)
        un_v = unit_match.group(2)
        rest = unit_match.group(3).strip()
        
        # Separate description starting with ESTOFADO, POLTRONA, etc.
        desc_match = re.search(r'\s+(ESTOFADO\s+.*|ALMOFADA\s+.*|BANQUETA\s+.*|CADEIRA\s+.*|PUFF\s+.*|POLTRONA\s+.*|CHAISE\s+.*|MESA\s+.*|TAPETE\s+.*|AQUISIÇÃO\s+.*)$', rest, re.IGNORECASE)
        desc_original = ""
        if desc_match:
            desc_original = desc_match.group(1).strip()
            rest = rest[:desc_match.start()].strip()
            
        tokens = rest.split()
        width = 0.0
        width_idx = -1
        for i, t in enumerate(tokens):
            if re.match(r'^\d+[\.,]\d+$', t):
                width_idx = i
                width = float(t.replace(',', '.'))
                break
                
        if width_idx != -1:
            model = " ".join(tokens[:width_idx])
            remaining_tokens = tokens[width_idx+1:]
            bipartido = False
            if remaining_tokens and remaining_tokens[0].upper() == 'BIP':
                bipartido = True
                remaining_tokens = remaining_tokens[1:]
                
            fabric = ""
            if remaining_tokens:
                fabric = remaining_tokens[0]
                if "NAO" in fabric.upper() or "UTILIZAR" in fabric.upper() or len(fabric) < 2:
                    fabric = ""
        else:
            continue
            
        if not fabric:
            continue
            
        # Get volume and item from the next line if it contains the glue
        volume = 0.0
        if line_num + 1 < len(lines):
            next_line = lines[line_num + 1].strip()
            # Match 2,00790003 -> volume 2.0079
            m_vol = re.match(r'^(\d+[\.,]\d{4,6})\d+$', next_line)
            if m_vol:
                volume = float(m_vol.group(1).replace(',', '.'))
            else:
                m_vol2 = re.match(r'^(\d+[\.,]\d+)$', next_line)
                if m_vol2:
                    volume = float(m_vol2.group(1).replace(',', '.'))
            
        records.append({
            'code': code,
            'line_num': line_num + 1,
            'raw': line,
            'model': normalize(model),
            'width': width,
            'bipartido': bipartido,
            'fabric': fabric.strip(),
            'desc_original': desc_original if desc_original else f"ESTOFADO {model} {width} {fabric}".strip(),
            'volume': volume
        })
    return records

def seed_database(records):
    try:
        conn = psycopg2.connect(
            host="localhost",
            port=5432,
            database="pi_db",
            user="pi",
            password="pi123"
        )
        cur = conn.cursor()
        
        # 1. Clear existing sub_modulo records
        print("Clearing existing sub_modulo table...")
        cur.execute("DELETE FROM pi.sub_modulo")
        
        # 2. Cache all modulos for both suppliers (Ferguile=3, Livintus=4)
        cur.execute("""
            SELECT m.id, ma.nome as marca_nome, m.descricao as mod_desc, m.largura as mod_larg, m.id_fornecedor
            FROM pi.modulo m
            JOIN pi.marca ma ON m.id_marca = ma.id
            WHERE m.id_fornecedor IN (3, 4)
        """)
        db_rows = cur.fetchall()
        
        db_items = []
        for r in db_rows:
            db_items.append({
                'id': r[0],
                'model': normalize(r[1]),
                'desc': normalize(r[2]),
                'width': float(r[3]),
                'supplier_id': r[4]
            })
        print(f"Loaded {len(db_items)} modules from DB.")
        
        # 3. Cache all Tecidos
        cur.execute("SELECT id, nome FROM pi.tecido")
        tecido_rows = cur.fetchall()
        tecidos_map = {normalize(t[1]): t[0] for t in tecido_rows}
        
        # Spelling model mappings
        model_mapping = {
            'ALEGRA': 'ALLEGRA',
            'BERGAMO': 'BÉRGAMO',
            'BULGARIA': 'BULGÁRIA',
            'FRANCA': 'FRANÇA',
            'FRASCATI': 'FRASCATTI',
            'LECCE GIRATORIA': 'LECCE GIRATÓRIA',
            'TRIA': 'TRÓIA',
            'VENETTO': 'VÉNETO'
        }
        
        inserted_count = 0
        unmatched_count = 0
        
        for r in records:
            model_name = r['model']
            if model_name in model_mapping:
                model_name = model_mapping[model_name]
                
            pdf_fab = r['fabric']
            base_fab_name = get_tecido_base_name(pdf_fab)
            if not base_fab_name:
                unmatched_count += 1
                continue
                
            base_fab_norm = normalize(base_fab_name)
            id_tecido_base = tecidos_map.get(base_fab_norm)
            if not id_tecido_base:
                # Let's try to add missing general fabric lines to tessuto if they are missing
                cur.execute("INSERT INTO pi.tecido (nome) VALUES (%s) RETURNING id", (base_fab_name,))
                id_tecido_base = cur.fetchone()[0]
                tecidos_map[base_fab_norm] = id_tecido_base
                print(f"Added missing base fabric line: {base_fab_name}")
                
            # Match module
            matched_modulo_id = None
            for db in db_items:
                if db['model'] == model_name:
                    if abs(db['width'] - r['width']) < 0.05:
                        is_bip_db = 'BIPARTIDO' in db['desc'] or '2 MODULOS' in db['desc'] or '2 MÓDULOS' in db['desc']
                        if is_bip_db == r['bipartido'] or db['model'] in ['ALICANTE', 'AMADEO', 'AMBRONE', 'POMEROL']:
                            matched_modulo_id = db['id']
                            break
                            
            if matched_modulo_id:
                # Insert sub_modulo
                cur.execute("""
                    INSERT INTO pi.sub_modulo (id_modulo, id_tecido_base, codigo, descricao_produto, tecido_especifico, volume_m3, fl_ativo)
                    VALUES (%s, %s, %s, %s, %s, %s, true)
                """, (matched_modulo_id, id_tecido_base, r['code'], r['desc_original'], pdf_fab, r['volume']))
                inserted_count += 1
            else:
                unmatched_count += 1
                
        conn.commit()
        print(f"\nDatabase Seed Summary:")
        print(f"SubMódulos inserted successfully: {inserted_count}")
        print(f"Unmatched PDF records: {unmatched_count}")
        
        cur.close()
        conn.close()
    except Exception as e:
        print("Database Seed Error:", e)

# Run full pipeline
records = parse_pdf()
seed_database(records)
