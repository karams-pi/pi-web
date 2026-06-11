import openpyxl

try:
    wb = openpyxl.load_workbook(r"c:\Portifólio\pi-web\Docs\Koyo 2026 (Exportação) - Tabela Integral.xlsm")
    sheet = wb.active
    print(f"Total images: {len(sheet._images)}")
    for i, img in enumerate(sheet._images):
        print(f"Image {i}:")
        anchor = img.anchor
        if hasattr(anchor, '_from'):
            print(f"  From: col={anchor._from.col}, row={anchor._from.row}")
except Exception as e:
    print(f"Error: {e}")
