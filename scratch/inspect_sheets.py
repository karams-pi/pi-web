import openpyxl

def main():
    path = r"c:\Portifólio\pi-web\Docs\New\Karams 2026 - Abimad 42 (Exportação).xlsm"
    wb = openpyxl.load_workbook(path, read_only=True)
    print("Sheets in workbook:")
    for sheet in wb.sheetnames:
        print(sheet)
        
if __name__ == "__main__":
    main()
