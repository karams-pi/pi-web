import openpyxl
import os

def check_types(file_path):
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        return

    wb = openpyxl.load_workbook(file_path, data_only=True)
    ws = wb.active
    for row in ws.iter_rows(min_row=2, max_row=5):
        for cell in row:
            if cell.value is not None:
                print(f"Cell {cell.coordinate}: Value={cell.value}, Type={type(cell.value)}")

if __name__ == "__main__":
    check_types("e:/teste/pi-web/Docs/TESTE1.xlsx")
