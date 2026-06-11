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

# Perform replacement
target = """        ws.Cells[gridRow + 7, rightCol].Value = t("PAYMENT_CONDITION", lang);
        ws.Cells[gridRow + 7, rightCol + 1].Value = !string.IsNullOrWhiteSpace(pi.CondicaoPagamento) ? pi.CondicaoPagamento : (pi.Configuracoes?.CondicoesPagamento ?? "T/T");
        ws.Cells[gridRow, 1, gridRow + 7, 17].Style.Font.Size = 10;gridRow + 7, rightCol + 1].Value = !string.IsNullOrWhiteSpace(pi.CondicaoPagamento) ? pi.CondicaoPagamento : (pi.Configuracoes?.CondicoesPagamento ?? "T/T");
        ws.Cells[gridRow, 1, gridRow + 7, 17].Style.Font.Size = 8;"""

replacement = """        ws.Cells[gridRow + 7, rightCol].Value = t("PAYMENT_CONDITION", lang);
        ws.Cells[gridRow + 7, rightCol + 1].Value = !string.IsNullOrWhiteSpace(pi.CondicaoPagamento) ? pi.CondicaoPagamento : (pi.Configuracoes?.CondicoesPagamento ?? "T/T");
        ws.Cells[gridRow, 1, gridRow + 7, 17].Style.Font.Size = 10;"""

if target in content:
    print("Found target block!")
    new_content = content.replace(target, replacement)
    with open(path, 'w', encoding=chosen_enc) as f:
        f.write(new_content)
    print("Successfully replaced text.")
else:
    print("Target block NOT found!")
    # Let's do a more robust find
    # Check if a substring exists
    if "Style.Font.Size = 10;gridRow + 7" in content:
        print("Found line substring, but exact match failed. Printing snippet:")
        idx = content.find("Style.Font.Size = 10;gridRow + 7")
        print(content[idx-100:idx+200])
