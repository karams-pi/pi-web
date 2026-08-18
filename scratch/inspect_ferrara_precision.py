import openpyxl
import re

def extract_width(comp_str):
    if comp_str is None:
        return None
    comp_str = str(comp_str).strip()
    matches = re.findall(r'(\d+[\.,]\d+|\d+)', comp_str)
    if matches:
        return float(matches[-1].replace(',', '.'))
    return None

wb = openpyxl.load_workbook("Docs/TABELA FERGUILE_EXPORTAÇÃO_MOVELSUL_2026.xlsx", data_only=True)
sheet = wb['EXW']
val = sheet.cell(row=157, column=3).value
print(f"Row 157 C157: {repr(val)} -> W={extract_width(val)}")
