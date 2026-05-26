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

def parse_pdf():
    pdf_path = r'c:\Portifólio\pi-web\pdf_dump.txt'
    with open(pdf_path, 'r', encoding='utf-8') as f:
        content = f.read()
        
    records = []
    lines = content.split('\n')
    
    for line_num, line in enumerate(lines):
        line = line.strip()
        if not line or 'ATIVO' not in line:
            continue
            
        match = re.match(r'^(\d+)\s+ATIVO', line)
        if not match:
            continue
            
        code = match.group(1)
        unit_match = re.search(r'\s+(UN|PC|MT|KG|JG|CJ)\s+(UN|PC|MT|KG|JG|CJ)([A-Z].*)', line, re.IGNORECASE)
        if not unit_match:
            unit_match = re.search(r'\s+(UN|PC|MT|KG|JG|CJ)\s+(UN|PC|MT|KG|JG|CJ)\s+(.*)', line, re.IGNORECASE)
            if not unit_match:
                continue
            
        un_c = unit_match.group(1)
        un_v = unit_match.group(2)
        rest = unit_match.group(3).strip()
        
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
            
        records.append({
            'code': code,
            'line_num': line_num + 1,
            'raw': line,
            'model': normalize(model),
            'width': width,
            'bipartido': bipartido,
            'fabric': normalize(fabric)
        })
    return records

def analyze_matching(records):
    try:
        conn = psycopg2.connect(
            host="localhost",
            port=5432,
            database="pi_db",
            user="pi",
            password="pi123"
        )
        cur = conn.cursor()
        
        # Load all modulos and modulo_tecido for Ferguile (3) AND Livintus (4)
        cur.execute("""
            SELECT mt.id, ma.nome as marca_nome, m.descricao as mod_desc, m.largura as mod_larg, t.nome as tec_nome, m.id_fornecedor
            FROM modulo_tecido mt
            JOIN modulo m ON mt.id_modulo = m.id
            JOIN marca ma ON m.id_marca = ma.id
            JOIN tecido t ON mt.id_tecido = t.id
            WHERE m.id_fornecedor IN (3, 4) AND mt.fl_ativo = true
        """)
        db_rows = cur.fetchall()
        
        db_items = []
        db_models = set()
        for r in db_rows:
            db_items.append({
                'mt_id': r[0],
                'model': normalize(r[1]),
                'desc': normalize(r[2]),
                'width': float(r[3]),
                'fabric': normalize(r[4]),
                'supplier_id': r[5]
            })
            db_models.add(normalize(r[1]))
            
        print(f"Total active ModuloTecido records from DB (Forn 3 & 4): {len(db_items)}")
        print(f"Total unique models in DB: {len(db_models)}")
        
        # Spelling mappings
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
        
        perfect_matches = 0
        unmatched = 0
        matched_mt_ids = set()
        
        for r in records:
            # Map model name spelling if needed
            model_name = r['model']
            if model_name in model_mapping:
                model_name = model_mapping[model_name]
                
            matched = False
            for db in db_items:
                if db['model'] == model_name:
                    # Check width
                    if abs(db['width'] - r['width']) < 0.05:
                        # Check bipartido
                        # Bipartido can be in desc, or if it is '2 MODULOS' it might be bipartido!
                        # Let's see: for ALICANTE, '2 MÓDULOS' or similar is bipartido.
                        # Let's make the bipartido check smart:
                        is_bip_db = 'BIPARTIDO' in db['desc'] or '2 MODULOS' in db['desc'] or '2 MÓDULOS' in db['desc']
                        # Special case: some models are always single piece or bipartido
                        if is_bip_db == r['bipartido'] or db['model'] in ['ALICANTE', 'AMADEO', 'AMBRONE', 'POMEROL']:
                            # Match fabric line
                            pdf_fab = r['fabric']
                            db_fab = db['fabric']
                            
                            fab_matched = False
                            if pdf_fab.startswith(db_fab):
                                fab_matched = True
                            elif pdf_fab.startswith('CR-') and db_fab.startswith('CO-'):
                                pdf_num = re.search(r'\d', pdf_fab)
                                db_num = re.search(r'\d', db_fab)
                                if pdf_num and db_num and pdf_num.group() == db_num.group():
                                    fab_matched = True
                            elif pdf_fab.startswith('ST-') and db_fab.startswith('TC-'):
                                pdf_num = re.search(r'\d+', pdf_fab)
                                db_num = re.search(r'\d+', db_fab)
                                if pdf_num and db_num and pdf_num.group() == db_num.group():
                                    fab_matched = True
                                    
                            if fab_matched:
                                matched = True
                                perfect_matches += 1
                                matched_mt_ids.add(db['mt_id'])
                                break
            if not matched:
                unmatched += 1
                
        print(f"\n=== SMART MATCHING STATISTICS (Forn 3 & 4) ===")
        print(f"Matches successfully made: {perfect_matches}")
        print(f"Unique DB ModuloTecido matched: {len(matched_mt_ids)} out of {len(db_items)}")
        print(f"Unmatched PDF rows: {unmatched}")
        
        cur.close()
        conn.close()
    except Exception as e:
        print("Error during matching:", e)

records = parse_pdf()
analyze_matching(records)
