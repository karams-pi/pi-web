import re

def inspect_brands():
    brands = [
        "AREZZO", "ALLEGRA", "FRANÇA", "VENETTO", "BÉRGAMO", "BULGÁRIA", "FRASCATI", "TRÓIA"
    ]
    
    # Normalize clean patterns for searching
    brand_patterns = [r'\b' + b.replace('Ç', 'C').replace('Á', 'A').replace('É', 'E').replace('Ó', 'O').replace('Ú', 'U').upper() + r'\b' for b in brands]
    
    with open(r'c:\Portifólio\pi-web\pdf_dump.txt', 'r', encoding='utf-8') as f:
        lines = f.readlines()
        
    found = {b: [] for b in brands}
    for idx, line in enumerate(lines):
        line_upper = line.upper()
        # strip accents for matching
        line_clean = line_upper.replace('Ç', 'C').replace('Á', 'A').replace('É', 'E').replace('Ó', 'O').replace('Ú', 'U')
        for b, pattern in zip(brands, brand_patterns):
            if re.search(pattern, line_clean) and 'ATIVO' in line_upper:
                found[b].append((idx + 1, line.strip()))
                
    for b in brands:
        print(f"=== {b} (Found {len(found[b])} rows) ===")
        for i, (l_num, text) in enumerate(found[b][:5]):
            print(f"Line {l_num}: {text}")
        if len(found[b]) > 5:
            print("...")

if __name__ == "__main__":
    inspect_brands()
