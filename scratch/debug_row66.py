import openpyxl
import re

def extract_width(comp_str):
    if comp_str is None:
        return None
    comp_str = str(comp_str).strip()
    matches = re.findall(r'(\d+[\.,]\d+|\d+)', comp_str)
    print(f"DEBUG: comp_str='{comp_str}', matches={matches}")
    if matches:
        return float(matches[-1].replace(',', '.'))
    return None

wb = openpyxl.load_workbook("Docs/TABELA LIVINTUS_EXPORTAÇÃO_MOVELSUL_2026.xlsx", data_only=True)
sheet = wb['LIVINTUS COURO']
val = sheet.cell(row=66, column=3).value
print(f"Cell C66 Type: {type(val)}, Value: {repr(val)}")
w = extract_width(val)
print(f"Extracted width: {w}")
