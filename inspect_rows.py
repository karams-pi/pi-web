import openpyxl

wb = openpyxl.load_workbook('Docs/TESTE1.xlsx', data_only=True)
ws = wb.active

print(f"Sheet: {ws.title}")
for r in range(1, 21):
    row_data = [ws.cell(row=r, column=c).value for c in range(1, 16)]
    print(f"R{r}: {row_data}")
