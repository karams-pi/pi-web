import openpyxl

wb = openpyxl.load_workbook("test_export_Ferguile_15.xlsx")
ws = wb.active
print("Merged cell ranges:")
for r in sorted(ws.merged_cells.ranges, key=lambda x: (x.min_col, x.min_row)):
    print(r)
