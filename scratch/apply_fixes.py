import os

path = r"c:\Portifólio\pi-web\backend\Pi.Api\Services\PiExportService.cs"

# 1. Read the file content safely
with open(path, 'rb') as f:
    raw_data = f.read()

# Decode using utf-8 with ignore to drop the invalid trailing box-drawing byte if any
content = raw_data.decode('utf-8', errors='ignore')

# We will accumulate replacements
replacements = []

# ==================== 1. COMMENT CLEANUP ====================
# Replace any double-line box drawing character '═' with '=' to ensure pure ASCII comments
content = content.replace('═', '=')

# ==================== 2. ALIGNMENT (da coluna REFERENCIA até a coluna OBSERVACIÓN) ====================
# In BuildFerguileLayout, change alignment inside loop for columns 2 to 14.
target_align_loop = """                    ws.Cells[currentRow, 10].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    ws.Cells[currentRow, 11].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    ws.Cells[currentRow, 15].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                    ws.Cells[currentRow, 16].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                    ws.Cells[currentRow, 17].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;"""

replacement_align_loop = """                    for (int c = 2; c <= 14; c++)
                    {
                        ws.Cells[currentRow, c].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        ws.Cells[currentRow, c].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    }
                    ws.Cells[currentRow, 15].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                    ws.Cells[currentRow, 16].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                    ws.Cells[currentRow, 17].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;"""

replacements.append((target_align_loop, replacement_align_loop))

# ==================== 3. UNICODE ENCODING ESCAPES FOR ACCENTED LITERALS ====================
# Replace accented strings with their unicode escape sequences to prevent mojibake under CP1252 compilation

# Metadata
replacements.append(('State = "PARANÁ",', 'State = "PARAN\\u00C1",'))
replacements.append(('BeneficiaryAddress = "SÃO PAULO - BR"', 'BeneficiaryAddress = "S\\u00C3O PAULO - BR"'))
replacements.append((
    'Address = "RUA CANÁRIO DO BREJO, 630 - RIBEIRÃO BANDEIRANTE DO NORTE",',
    'Address = "RUA CAN\\u00C1RIO DO BREJO, 630 - RIBEIR\\u00C3O BANDEIRANTE DO NORTE",'
))

# Comments cleanup
replacements.append(('// Configuração global da planilha', '// Configuracao global da planilha'))
replacements.append(('// Centralização do conteúdo (Karams/Koyo)', '// Centralizacao do conteudo (Karams/Koyo)'))

# PT Translations
replacements.append(('["ADDRESS"] = "ENDEREÇO:",', '["ADDRESS"] = "ENDERE\\u00C7O:",'))
replacements.append(('["COUNTRY"] = "PAÍS:",', '["COUNTRY"] = "PA\\u00CDS:",'))
replacements.append(('["RESPONSIBLE"] = "RESPONSÁVEL:",', '["RESPONSIBLE"] = "RESPONS\\u00C1VEL:",'))
replacements.append(('["PAYMENT_CONDITION"] = "CONDIÇÃO DE PAGAMENTO:",', '["PAYMENT_CONDITION"] = "CONDI\\u00C7\\u00C3O DE PAGAMENTO:",'))
replacements.append(('["DESCRIPTION"] = "DESCRIÇÃO",', '["DESCRIPTION"] = "DESCRI\\u00C7\\u00C3O",'))
replacements.append(('["DIMENSIONS"] = "DIMENSÕES (m)",', '["DIMENSIONS"] = "DIMENS\\u00D5ES (m)",'))
replacements.append(('["QTY_SOFA"] = "QTD SOFÁ",', '["QTY_SOFA"] = "QTD SOF\\u00C1",'))
replacements.append(('["TOTAL_VOLUME"] = "VOL. TOTAL M³",', '["TOTAL_VOLUME"] = "VOL. TOTAL M\\u00B3",'))
replacements.append(('["FEET"] = "PÉS",', '["FEET"] = "P\\u00C9S",'))
replacements.append(('["OBSERVATION"] = "OBSERVAÇÃO",', '["OBSERVATION"] = "OBSERVA\\u00C7\\u00C3O",'))
replacements.append(('["BANK_DETAILS"] = "DADOS BANCÁRIOS:",', '["BANK_DETAILS"] = "DADOS BANC\\u00C1RIOS:",'))
replacements.append(('["INTERMEDIARY_BANK"] = "BANCO INTERMEDIÁRIO:",', '["INTERMEDIARY_BANK"] = "BANCO INTERMEDI\\u00C1RIO:",'))
replacements.append(('["BENEFICIARY_BANK"] = "BANCO BENEFICIÁRIO:",', '["BENEFICIARY_BANK"] = "BANCO BENEFICI\\u00C1RIO:",'))
replacements.append((
    '["VALIDITY_NOTE"] = "* Esta proforma é válida por {0} dias a partir da data de emissão.",',
    '["VALIDITY_NOTE"] = "* Esta proforma \\u00E9 v\\u00E1lida por {0} dias a partir da data de emiss\\u00E3o.",'
))
replacements.append(('["REFERENCIA"] = "REFERÊNCIA",', '["REFERENCIA"] = "REFER\\u00CANCIA",'))
replacements.append(('["UNIT"] = "UNITÁRIO",', '["UNIT"] = "UNIT\\u00C1RIO",'))

# ES Translations
replacements.append(('["ADDRESS"] = "DIRECCIÓN:",', '["ADDRESS"] = "DIRECCI\\u00D3N:",'))
replacements.append(('["COUNTRY"] = "PAÍS:",', '["COUNTRY"] = "PA\\u00CDS:",'))
replacements.append(('["PHONE"] = "TELÉFONO:",', '["PHONE"] = "TEL\\u00C9FONO:",'))
replacements.append(('["PAYMENT_CONDITION"] = "CONDICIÓN DE PAGO:",', '["PAYMENT_CONDITION"] = "CONDICI\\u00D3N DE PAGO:",'))
replacements.append(('["DESCRIPTION"] = "DESCRIPCIÓN",', '["DESCRIPTION"] = "DESCRIPCI\\u00D3N",'))
replacements.append(('["TOTAL_VOLUME"] = "TOTAL VOLUMEN M³",', '["TOTAL_VOLUME"] = "TOTAL VOLUMEN M\\u00B3",'))
replacements.append(('["OBSERVATION"] = "OBSERVACIÓN",', '["OBSERVATION"] = "OBSERVACI\\u00D3N",'))
replacements.append((
    '["VALIDITY_NOTE"] = "* Esta proforma es válida por {0} días a partir de la fecha de emisión.",',
    '["VALIDITY_NOTE"] = "* Esta proforma es v\\u00E1lida por {0} d\\u00EDas a partir de la fecha de emisi\\u00F3n.",'
))

# EN Translations
replacements.append(('["TOTAL_VOLUME"] = "TOTAL M³",', '["TOTAL_VOLUME"] = "TOTAL M\\u00B3",'))

# Inline string helper
replacements.append(('após o primeiro pagamento', 'ap\\u00F3s o primeiro pagamento'))

# CBM M3 generic
replacements.append(('"CBM M³: "', '"CBM M\\u00B3: "'))

# BuildFerguileLayout headers
replacements.append((
    '"REFERENCIA", "CÓDIGO", "DESCRIPCIÓN", "DESC/VOL",',
    '"REFERENCIA", "C\\u00D3DIGO", "DESCRIPCI\\u00D3N", "DESC/VOL",'
))
replacements.append((
    '"TOTAL M3", "FABRICACIÓN", "TELA", "OBSERVACIÓN", "DESPESAS",',
    '"TOTAL M3", "FABRICACI\\u00D3N", "TELA", "OBSERVACI\\u00D3N", "DESPESAS",'
))

# ==================== 4. FONT SIZE INCREASES (2px) ====================
# Global Font Size 10 -> 12
replacements.append((
    'ws.Cells.Style.Font.Size = 10;',
    'ws.Cells.Style.Font.Size = 12;'
))

# BuildGenericLayout header fonts
replacements.append((
    'ws.Cells["A2"].Style.Font.Size = 13;',
    'ws.Cells["A2"].Style.Font.Size = 15;'
))
replacements.append((
    'ws.Cells["A3"].Style.Font.Size = 8;',
    'ws.Cells["A3"].Style.Font.Size = 10;'
))
replacements.append((
    'ws.Cells["A4"].Style.Font.Size = 8;',
    'ws.Cells["A4"].Style.Font.Size = 10;'
))

# BuildGenericLayout grid font
replacements.append((
    'ws.Cells[gridRow, 1, gridRow + 7, 17].Style.Font.Size = 8;',
    'ws.Cells[gridRow, 1, gridRow + 7, 17].Style.Font.Size = 10;'
))

# BuildGenericLayout footer fonts
replacements.append((
    'ws.Cells[currentRow, 1, currentRow + 10, 7].Style.Font.Size = 8;',
    'ws.Cells[currentRow, 1, currentRow + 10, 7].Style.Font.Size = 10;'
))
replacements.append((
    'ws.Cells[currentRow + 11, 1].Style.Font.Size = 8;',
    'ws.Cells[currentRow + 11, 1].Style.Font.Size = 10;'
))
replacements.append((
    'ws.Cells[currentRow, 8, currentRow + 10, totalCol].Style.Font.Size = 8;',
    'ws.Cells[currentRow, 8, currentRow + 10, totalCol].Style.Font.Size = 10;'
))

# BuildFerguileLayout header box fonts
replacements.append((
    'supplierRange.Style.Font.Size = 9;',
    'supplierRange.Style.Font.Size = 11;'
))
replacements.append((
    'importerRange.Style.Font.Size = 9;',
    'importerRange.Style.Font.Size = 11;'
))

# BuildFerguileLayout footer fonts
replacements.append((
    'bankRange.Style.Font.Size = 9;',
    'bankRange.Style.Font.Size = 11;'
))
replacements.append((
    'prodRange.Style.Font.Size = 9;',
    'prodRange.Style.Font.Size = 11;'
))
replacements.append((
    'validityRange.Style.Font.Size = 8;',
    'validityRange.Style.Font.Size = 10;'
))

# ==================== 5. CELL & ROW SIZE ADJUSTMENTS ====================
# BuildGenericLayout header row heights
replacements.append((
    """        ws.Row(1).Height = 5;
        ws.Row(2).Height = 25;
        ws.Row(3).Height = 15;
        ws.Row(4).Height = 15;
        ws.Row(5).Height = 10;
        for (int r = 6; r <= 13; r++) ws.Row(r).Height = 18;""",
    """        ws.Row(1).Height = 6;
        ws.Row(2).Height = 30;
        ws.Row(3).Height = 18;
        ws.Row(4).Height = 18;
        ws.Row(5).Height = 12;
        for (int r = 6; r <= 13; r++) ws.Row(r).Height = 22;"""
))

# BuildGenericLayout data row heights
replacements.append((
    'ws.Row(currentRow).Height = 25;',
    'ws.Row(currentRow).Height = 30;'
))

# BuildGenericLayout column widths
replacements.append((
    """        ws.Column(1).Width = 15;
        ws.Column(2).Width = 15;
        ws.Column(3).Width = 35;
        ws.Column(10).Width = 20;""",
    """        ws.Column(1).Width = 18;
        ws.Column(2).Width = 18;
        ws.Column(3).Width = 40;
        ws.Column(10).Width = 24;"""
))

# BuildFerguileLayout data row height inside loop
replacements.append((
    'ws.Row(currentRow).Height = 25;',
    'ws.Row(currentRow).Height = 30;'
))

# BuildFerguileLayout single-row brand image height
replacements.append((
    'if (brandEndRow == brandStartRow) ws.Row(brandStartRow).Height = 65;',
    'if (brandEndRow == brandStartRow) ws.Row(brandStartRow).Height = 75;'
))

# BuildFerguileLayout summary row height
replacements.append((
    'ws.Row(currentRow).Height = 20;',
    'ws.Row(currentRow).Height = 25;'
))

# BuildFerguileLayout column widths
replacements.append((
    """        ws.Column(1).Width = 12; ws.Column(2).Width = 13; ws.Column(3).Width = 11;
        ws.Column(4).Width = 25; ws.Column(5).Width = 15; ws.Column(6).Width = 8;
        ws.Column(7).Width = 7;  ws.Column(8).Width = 7;  ws.Column(9).Width = 6.5;
        ws.Column(10).Width = 7; ws.Column(11).Width = 11; ws.Column(12).Width = 13;
        ws.Column(13).Width = 10; ws.Column(14).Width = 20; ws.Column(15).Width = 10;
        ws.Column(16).Width = 13; ws.Column(17).Width = 14;""",
    """        ws.Column(1).Width = 15; ws.Column(2).Width = 16; ws.Column(3).Width = 14;
        ws.Column(4).Width = 30; ws.Column(5).Width = 18; ws.Column(6).Width = 10;
        ws.Column(7).Width = 9;  ws.Column(8).Width = 9;  ws.Column(9).Width = 8.5;
        ws.Column(10).Width = 9; ws.Column(11).Width = 14; ws.Column(12).Width = 16;
        ws.Column(13).Width = 12; ws.Column(14).Width = 25; ws.Column(15).Width = 12;
        ws.Column(16).Width = 16; ws.Column(17).Width = 18;"""
))

# BuildFerguileLayout footer row heights
replacements.append((
    """        // ═══════════════ FOOTER ═══════════════
        currentRow += 2;
        int footerStartRow = currentRow;
        int footerEndRow = currentRow + 10;""",
    """        // ================= FOOTER =================
        currentRow += 2;
        int footerStartRow = currentRow;
        int footerEndRow = currentRow + 10;
        for (int r = footerStartRow; r <= footerEndRow + 1; r++)
        {
            ws.Row(r).Height = 26;
        }"""
))

# Apply replacements
print("Applying replacements...")
new_content = content
for target, rep in replacements:
    if target in new_content:
        new_content = new_content.replace(target, rep)
        print(f"Replaced: {repr(target[:40])}...")
    else:
        print(f"WARNING: Target not found: {repr(target[:40])}...")

# Write back the clean content as UTF-8
with open(path, 'w', encoding='utf-8') as f:
    f.write(new_content)

print("Finished applying all modifications.")
