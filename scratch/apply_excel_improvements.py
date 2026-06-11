import os

path = r"c:\Portifólio\pi-web\backend\Pi.Api\Services\PiExportService.cs"

# Try reading with different encodings
encodings = ['utf-8-sig', 'utf-8', 'latin-1', 'cp1252']
content = None
chosen_enc = None

for enc in encodings:
    try:
        with open(path, 'r', encoding=enc) as f:
            content = f.read()
        chosen_enc = enc
        print(f"Successfully read with {enc}")
        break
    except Exception as e:
        print(f"Failed to read with {enc}: {e}")

if content is None:
    print("Could not read file with any encoding.")
    exit(1)

# Keep track of replacements to apply
replacements = []

# 1. Global Font Size (12 -> 14)
replacements.append((
    'ws.Cells.Style.Font.Size = 12;',
    'ws.Cells.Style.Font.Size = 14;'
))

# 2. BuildGenericLayout header fonts:
replacements.append((
    'ws.Cells["A2"].Style.Font.Size = 15;',
    'ws.Cells["A2"].Style.Font.Size = 17;'
))
replacements.append((
    'ws.Cells["A3"].Style.Font.Size = 10;',
    'ws.Cells["A3"].Style.Font.Size = 12;'
))
replacements.append((
    'ws.Cells["A4"].Style.Font.Size = 10;',
    'ws.Cells["A4"].Style.Font.Size = 12;'
))

# 3. BuildGenericLayout header row heights:
replacements.append((
    """        ws.Row(1).Height = 5;
        ws.Row(2).Height = 40;
        ws.Row(3).Height = 22;
        ws.Row(4).Height = 22;
        ws.Row(5).Height = 12;
        for (int r = 6; r <= 13; r++) ws.Row(r).Height = 24;""",
    """        ws.Row(1).Height = 6;
        ws.Row(2).Height = 45;
        ws.Row(3).Height = 26;
        ws.Row(4).Height = 26;
        ws.Row(5).Height = 14;
        for (int r = 6; r <= 13; r++) ws.Row(r).Height = 28;"""
))

# 4. BuildGenericLayout table header row heights:
replacements.append((
    """        int startRow = 14;
        ws.Row(14).Height = 25;
        ws.Row(15).Height = 25;""",
    """        int startRow = 14;
        ws.Row(14).Height = 30;
        ws.Row(15).Height = 30;"""
))

# 5. BuildGenericLayout data row height (Adding Height setting inside loop):
replacements.append((
    """            for (int i = 0; i < sortedItems.Count; i++)
            {
                var item = sortedItems[i];
                bool isFirstOfGroup = spanFabric[i] > 0;""",
    """            for (int i = 0; i < sortedItems.Count; i++)
            {
                var item = sortedItems[i];
                ws.Row(currentRow).Height = 28;
                bool isFirstOfGroup = spanFabric[i] > 0;"""
))

# 6. BuildGenericLayout summary row height:
replacements.append((
    """        ws.Row(currentRow).Height = 25;
        currentRow++;""",
    """        ws.Row(currentRow).Height = 30;
        currentRow++;"""
))

# 7. BuildGenericLayout footer row heights:
replacements.append((
    """        for (int r = currentRow; r <= currentRow + 11; r++)
        {
            ws.Row(r).Height = 22;
        }""",
    """        for (int r = currentRow; r <= currentRow + 11; r++)
        {
            ws.Row(r).Height = 26;
        }"""
))

# 8. BuildGenericLayout footer font sizes:
replacements.append((
    'ws.Cells[currentRow, 1, currentRow + 10, 7].Style.Font.Size = 10;',
    'ws.Cells[currentRow, 1, currentRow + 10, 7].Style.Font.Size = 12;'
))
replacements.append((
    'ws.Cells[currentRow + 11, 1].Style.Font.Size = 10;',
    'ws.Cells[currentRow + 11, 1].Style.Font.Size = 12;'
))
replacements.append((
    'ws.Cells[currentRow, 8, currentRow + 10, totalCol].Style.Font.Size = 10;',
    'ws.Cells[currentRow, 8, currentRow + 10, totalCol].Style.Font.Size = 12;'
))

# 9. BuildGenericLayout column widths:
replacements.append((
    """        ws.Column(1).Width = 18;  // FOTO
        ws.Column(2).Width = 18;  // BRAND/NAME
        ws.Column(3).Width = 42;  // DESCRIPTION
        ws.Column(4).Width = 9;   // WIDTH
        ws.Column(5).Width = 9;   // DEPTH
        ws.Column(6).Width = 9;   // HEIGHT
        ws.Column(7).Width = 10;  // QTY UNIT
        ws.Column(8).Width = 10;  // QTY SOFA
        ws.Column(9).Width = 14;  // TOTAL VOLUME M3
        ws.Column(10).Width = 24; // FABRIC
        ws.Column(11).Width = 10; // FEET
        ws.Column(12).Width = 12; // FINISHING
        ws.Column(13).Width = 18; // OBSERVATION
        ws.Column(14).Width = 12; // FREIGHT
        ws.Column(15).Width = 12; // EXW
        ws.Column(16).Width = 15; // UNIT
        ws.Column(17).Width = 18; // TOTAL""",
    """        ws.Column(1).Width = 20;  // FOTO
        ws.Column(2).Width = 22;  // BRAND/NAME
        ws.Column(3).Width = 48;  // DESCRIPTION
        ws.Column(4).Width = 11;  // WIDTH
        ws.Column(5).Width = 11;  // DEPTH
        ws.Column(6).Width = 11;  // HEIGHT
        ws.Column(7).Width = 12;  // QTY UNIT
        ws.Column(8).Width = 12;  // QTY SOFA
        ws.Column(9).Width = 16;  // TOTAL VOLUME M3
        ws.Column(10).Width = 28; // FABRIC
        ws.Column(11).Width = 12; // FEET
        ws.Column(12).Width = 14; // FINISHING
        ws.Column(13).Width = 22; // OBSERVATION
        ws.Column(14).Width = 15; // FREIGHT
        ws.Column(15).Width = 15; // EXW
        ws.Column(16).Width = 18; // UNIT
        ws.Column(17).Width = 22; // TOTAL"""
))

# 10. BuildFerguileLayout supplier/importer box fonts and heights:
replacements.append((
    'supplierRange.Style.Font.Size = 11;',
    'supplierRange.Style.Font.Size = 13;'
))
replacements.append((
    'importerRange.Style.Font.Size = 11;',
    'importerRange.Style.Font.Size = 13;'
))

# 11. BuildFerguileLayout table header row height:
replacements.append((
    """        int startRow = 10;
        ws.Row(10).Height = 30;""",
    """        int startRow = 10;
        ws.Row(10).Height = 36;"""
))

# 12. BuildFerguileLayout data row height (inside loop):
# ws.Row(currentRow).Height = 30; -> ws.Row(currentRow).Height = 36;
replacements.append((
    'ws.Row(currentRow).Height = 30;',
    'ws.Row(currentRow).Height = 36;'
))

# 13. BuildFerguileLayout brand single row image height:
replacements.append((
    'if (brandEndRow == brandStartRow) ws.Row(brandStartRow).Height = 80;',
    'if (brandEndRow == brandStartRow) ws.Row(brandStartRow).Height = 90;'
))

# 14. BuildFerguileLayout summary row height:
replacements.append((
    """        ws.Cells[currentRow, 1].Value = "TOTAL";
        ws.Cells[currentRow, 1].Style.Font.Bold = true;""",
    """        ws.Cells[currentRow, 1].Value = "TOTAL";
        ws.Cells[currentRow, 1].Style.Font.Bold = true;"""
))
replacements.append((
    """        for (int i = 1; i <= 17; i++) ws.Cells[currentRow, i].Style.Border.BorderAround(ExcelBorderStyle.Thin);
        ws.Row(currentRow).Height = 25;""",
    """        for (int i = 1; i <= 17; i++) ws.Cells[currentRow, i].Style.Border.BorderAround(ExcelBorderStyle.Thin);
        ws.Row(currentRow).Height = 30;"""
))

# 15. BuildFerguileLayout column widths:
replacements.append((
    """        ws.Column(1).Width = 15; ws.Column(2).Width = 16; ws.Column(3).Width = 14;
        ws.Column(4).Width = 30; ws.Column(5).Width = 18; ws.Column(6).Width = 10;
        ws.Column(7).Width = 9;  ws.Column(8).Width = 9;  ws.Column(9).Width = 9;
        ws.Column(10).Width = 9; ws.Column(11).Width = 14; ws.Column(12).Width = 16;
        ws.Column(13).Width = 12; ws.Column(14).Width = 25; ws.Column(15).Width = 13;
        ws.Column(16).Width = 16; ws.Column(17).Width = 18;""",
    """        ws.Column(1).Width = 18; ws.Column(2).Width = 19; ws.Column(3).Width = 17;
        ws.Column(4).Width = 36; ws.Column(5).Width = 22; ws.Column(6).Width = 12;
        ws.Column(7).Width = 11; ws.Column(8).Width = 11; ws.Column(9).Width = 11;
        ws.Column(10).Width = 11; ws.Column(11).Width = 17; ws.Column(12).Width = 19;
        ws.Column(13).Width = 15; ws.Column(14).Width = 30; ws.Column(15).Width = 16;
        ws.Column(16).Width = 19; ws.Column(17).Width = 22;"""
))

# 16. BuildFerguileLayout footer row heights:
replacements.append((
    """        for (int r = footerStartRow; r <= footerEndRow + 1; r++)
        {
            ws.Row(r).Height = 22;
        }""",
    """        for (int r = footerStartRow; r <= footerEndRow + 1; r++)
        {
            ws.Row(r).Height = 26;
        }"""
))

# 17. BuildFerguileLayout footer fonts:
replacements.append((
    'bankRange.Style.Font.Size = 11;',
    'bankRange.Style.Font.Size = 13;'
))
replacements.append((
    'prodRange.Style.Font.Size = 11;',
    'prodRange.Style.Font.Size = 13;'
))
replacements.append((
    'validityRange.Style.Font.Size = 10;',
    'validityRange.Style.Font.Size = 12;'
))

print("Applying replacements...")
new_content = content
for target, rep in replacements:
    if target in new_content:
        new_content = new_content.replace(target, rep)
        print(f"Replaced: {repr(target[:30])}...")
    else:
        print(f"FAILED to find: {repr(target[:30])}...")

with open(path, 'w', encoding=chosen_enc) as f:
    f.write(new_content)
print("Done!")
