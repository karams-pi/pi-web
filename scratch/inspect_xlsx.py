import openpyxl

def inspect(file_path):
    print(f"\n==========================================")
    print(f"Inspecting: {file_path}")
    print(f"==========================================")
    wb = openpyxl.load_workbook(file_path, data_only=True)
    print("Sheets:", wb.sheetnames)
    for sheet_name in wb.sheetnames:
        sheet = wb[sheet_name]
        print(f"\nSheet: '{sheet_name}' (Rows: {sheet.max_row}, Cols: {sheet.max_column})")
        # Print first 20 rows
        for r in range(1, min(35, sheet.max_row + 1)):
            row_vals = [sheet.cell(row=r, column=c).value for c in range(1, min(15, sheet.max_column + 1))]
            # check if row is empty
            if any(val is not None for val in row_vals):
                row_str = " | ".join(f"[{c}]: {val}" if val is not None else f"[{c}]: None" for c, val in enumerate(row_vals, 1))
                print(f"Row {r:02d}: {row_str}")

if __name__ == "__main__":
    inspect(r"Docs/TABELA FERGUILE_EXPORTAÇÃO_MOVELSUL_2026.xlsx")
    inspect(r"Docs/TABELA LIVINTUS_EXPORTAÇÃO_MOVELSUL_2026.xlsx")
