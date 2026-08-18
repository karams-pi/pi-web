import openpyxl
import os

def inspect_file(file_path, out_file):
    out_file.write(f"\n======================================================================\n")
    out_file.write(f"FILE: {os.path.basename(file_path)}\n")
    out_file.write(f"======================================================================\n")
    
    wb = openpyxl.load_workbook(file_path, data_only=True)
    out_file.write(f"Sheets: {wb.sheetnames}\n\n")
    
    for sheet_name in wb.sheetnames:
        sheet = wb[sheet_name]
        out_file.write(f"--- SHEET: {sheet_name} (Rows: {sheet.max_row}, Cols: {sheet.max_column}) ---\n")
        
        # Print first 100 rows of each sheet
        for r in range(1, sheet.max_row + 1):
            row_vals = []
            has_val = False
            for c in range(1, sheet.max_column + 1):
                val = sheet.cell(row=r, column=c).value
                if val is not None:
                    has_val = True
                    # If string and has newlines, replace them
                    if isinstance(val, str):
                        val = val.replace('\n', ' ').replace('\r', ' ')
                    row_vals.append(f"Col {c} ({openpyxl.utils.get_column_letter(c)}): {val}")
                else:
                    row_vals.append(f"Col {c} ({openpyxl.utils.get_column_letter(c)}): None")
            
            if has_val:
                # Truncate some Nones at the end to keep it clean
                while len(row_vals) > 0 and row_vals[-1].endswith(": None"):
                    row_vals.pop()
                out_file.write(f"Row {r:03d}: " + " | ".join(row_vals) + "\n")
        out_file.write("\n")

def main():
    os.makedirs("scratch", exist_ok=True)
    with open("scratch/inspection_results.txt", "w", encoding="utf-8") as f:
        inspect_file(r"Docs/TABELA FERGUILE_EXPORTAÇÃO_MOVELSUL_2026.xlsx", f)
        inspect_file(r"Docs/TABELA LIVINTUS_EXPORTAÇÃO_MOVELSUL_2026.xlsx", f)
    print("Done! Inspection results written to scratch/inspection_results.txt")

if __name__ == "__main__":
    main()
