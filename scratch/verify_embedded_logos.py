import openpyxl

def verify_file(filename):
    print(f"\n--- Verifying {filename} ---")
    try:
        wb = openpyxl.load_workbook(filename)
        sheet = wb.active
        print(f"Total images: {len(sheet._images)}")
        for i, img in enumerate(sheet._images):
            anchor = img.anchor
            pos_info = ""
            if hasattr(anchor, '_from'):
                pos_info = f"From col={anchor._from.col}, row={anchor._from.row}"
            else:
                pos_info = f"Position: {anchor}"
            # Try to get drawing name
            name = getattr(img, 'name', 'Unknown')
            # Look at shape/drawing properties if available
            print(f"  Image {i} ({name}): {pos_info} | size={img.width}x{img.height}")
    except Exception as e:
        print(f"  Error: {e}")

verify_file("test_export_Ferguile_15.xlsx")
verify_file("test_export_Koyo_14.xlsx")
verify_file("test_export_Karams_13.xlsx")
