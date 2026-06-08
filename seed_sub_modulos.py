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

def extract_fabric(prod, ref):
    combined = f"{prod} {ref}".upper()
    # Pattern matching TC-XXXXX, ST-XXXXX, CR-XXX, COURO XXX
    m = re.search(r'\b(TC-\w+|ST-\w+|CR-\w+|COURO\s*\w+)\b', combined)
    if m:
        return m.group(1).replace(' ', '')
        
    # Fallback to suffix in prod like -10048 or -102
    m_suffix = re.search(r'-(\d{3,5})$', prod.strip())
    if m_suffix:
        num = m_suffix.group(1)
        return f"TC-{num}"
        
    tokens = prod.strip().split()
    if tokens:
        last_token = tokens[-1]
        m_dash = re.search(r'-(\d{3,5})$', last_token)
        if m_dash:
            return f"TC-{m_dash.group(1)}"
            
    return ""

def main():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    # 1. Clear existing sub_modulo records
    print("Clearing existing sub_modulo table...")
    cur.execute("DELETE FROM pi.sub_modulo")
    
    # 2. Cache all modulos
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
            'brand': r[1],
            'brand_norm': normalize(r[1]),
            'desc': r[2],
            'desc_norm': normalize(r[2]),
            'width': float(r[3]),
            'supplier_id': r[4]
        })
    print(f"Loaded {len(db_items)} modules from DB.")
    
    # Unique brands in DB
    db_brands = sorted(list(set(item['brand_norm'] for item in db_items)), key=len, reverse=True)
    
    brand_spelling_map = {
        'ALEGRA': 'ALLEGRA',
        'TRIA': 'TROIA',
        'POLT TROIA': 'TROIA',
        'TROIA': 'TROIA'
    }
    
    # Cache all Tecidos
    cur.execute("SELECT id, nome FROM pi.tecido")
    tecido_rows = cur.fetchall()
    tecidos_map = {normalize(t[1]): t[0] for t in tecido_rows}
    
    pdf_path = r'c:\Portifólio\pi-web\pdf_dump.txt'
    with open(pdf_path, 'r', encoding='utf-8') as f:
        content = f.read()
        
    lines = content.split('\n')
    
    records = []
    
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
            
        rest = unit_match.group(3).strip()
        
        # Separate description starting with ESTOFADO, POLTRONA, etc.
        desc_match = re.search(r'\s+(ESTOFADO\s+.*|ALMOFADA\s+.*|BANQUETA\s+.*|CADEIRA\s+.*|PUFF\s+.*|POLTRONA\s+.*|CHAISE\s+.*|MESA\s+.*|TAPETE\s+.*|AQUISIÇÃO\s+.*)$', rest, re.IGNORECASE)
        desc_original = ""
        produto_original = rest
        if desc_match:
            desc_original = desc_match.group(1).strip()
            produto_original = rest[:desc_match.start()].strip()
            
        # Parse volume
        volume = 0.0
        if line_num + 1 < len(lines):
            next_line = lines[line_num + 1].strip()
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
            'produto_original': produto_original,
            'desc_original': desc_original,
            'volume': volume
        })
        
    print(f"\nParsed {len(records)} records from PDF.")
    
    inserted_count = 0
    unmatched_count = 0
    
    for r in records:
        prod = r['produto_original']
        ref = r['desc_original']
        
        prod_norm = normalize(prod)
        ref_norm = normalize(ref)
        combined_norm = f"{prod_norm} {ref_norm}"
        
        # Word boundary search for brand
        matched_brand = None
        
        # Check spelling maps
        for spelling, target in brand_spelling_map.items():
            if re.search(rf"\b{re.escape(spelling)}\b", combined_norm):
                matched_brand = target
                break
                
        if not matched_brand:
            for b in db_brands:
                if re.search(rf"\b{re.escape(b)}\b", combined_norm):
                    matched_brand = b
                    break
                    
        if not matched_brand:
            unmatched_count += 1
            continue
            
        # Find all decimal numbers in the row
        decimals = []
        for token in combined_norm.split():
            for part in re.split(r'[xX*]', token):
                m_dec = re.search(r'(\d+[\.,]\d+)', part)
                if m_dec:
                    val = float(m_dec.group(1).replace(',', '.'))
                    if val not in decimals:
                        decimals.append(val)
                        
        candidates = [m for m in db_items if m['brand_norm'] == matched_brand]
        if not candidates:
            unmatched_count += 1
            continue
            
        matched_modulo = None
        
        if len(candidates) == 1:
            matched_modulo = candidates[0]
        else:
            # 1. Try direct width match
            width_candidates = []
            for c in candidates:
                for d in decimals:
                    if abs(c['width'] - d) < 0.05:
                        width_candidates.append(c)
                        break
                        
            # 2. Try 2 * width fallback (for modular pieces)
            if not width_candidates:
                for c in candidates:
                    for d in decimals:
                        if abs(c['width'] - 2 * d) < 0.05:
                            width_candidates.append(c)
                            break
                            
            if len(width_candidates) == 1:
                matched_modulo = width_candidates[0]
            elif len(width_candidates) > 1:
                is_bip_pdf = 'BIP' in prod_norm or 'BIP' in ref_norm or 'DIR' in prod_norm or 'ESQ' in prod_norm
                
                bip_matches = []
                for wc in width_candidates:
                    is_bip_db = 'BIPARTIDO' in wc['desc_norm'] or '2 MODULOS' in wc['desc_norm']
                    if is_bip_db == is_bip_pdf:
                        bip_matches.append(wc)
                        
                if len(bip_matches) == 1:
                    matched_modulo = bip_matches[0]
                else:
                    matched_modulo = width_candidates[0]
                    
        if matched_modulo:
            # Extract fabric
            pdf_fab = extract_fabric(prod, ref)
            if not pdf_fab:
                unmatched_count += 1
                continue
                
            base_fab_name = get_tecido_base_name(pdf_fab)
            if not base_fab_name:
                unmatched_count += 1
                continue
                
            base_fab_norm = normalize(base_fab_name)
            id_tecido_base = tecidos_map.get(base_fab_norm)
            if not id_tecido_base:
                # Insert missing fabric base
                cur.execute("INSERT INTO pi.tecido (nome) VALUES (%s) RETURNING id", (base_fab_name,))
                id_tecido_base = cur.fetchone()[0]
                tecidos_map[base_fab_norm] = id_tecido_base
                print(f"Added missing base fabric line: {base_fab_name}")
                
            # Clean up the product description from any parenthesis truncation
            clean_desc = ref.strip() if ref.strip() else prod.strip()
            if clean_desc.count('(') > clean_desc.count(')'):
                clean_desc += ')'
            clean_desc = clean_desc.rstrip('-').strip()
            
            # Insert into database
            cur.execute("""
                INSERT INTO pi.sub_modulo (id_modulo, id_tecido_base, codigo, descricao_produto, tecido_especifico, volume_m3, fl_ativo)
                VALUES (%s, %s, %s, %s, %s, %s, true)
            """, (matched_modulo['id'], id_tecido_base, r['code'], clean_desc, pdf_fab, r['volume']))
            inserted_count += 1
        else:
            unmatched_count += 1
            
    conn.commit()
    print(f"\nSeeding completed!")
    print(f"Inserted sub-modules: {inserted_count}")
    print(f"Unmatched/Skipped records: {unmatched_count}")
    
    cur.close()
    conn.close()

if __name__ == "__main__":
    main()
