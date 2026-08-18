import openpyxl

wb = openpyxl.load_workbook("Docs/TABELA LIVINTUS_EXPORTAÇÃO_MOVELSUL_2026.xlsx", data_only=True)
sheet = wb['LIVINTUS COURO']
for r in range(155, 175):
    row_vals = [sheet.cell(row=r, column=c).value for c in range(1, 9)]
    print(f"Row {r:03d}: {row_vals}")
