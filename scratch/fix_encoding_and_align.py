import os

path = r"c:\Portifólio\pi-web\backend\Pi.Api\Services\PiExportService.cs"

# Read in latin-1 (windows-1252) to avoid any decode errors
with open(path, 'r', encoding='latin-1') as f:
    content = f.read()

replacements = []

# ==================== 1. VISUAL IMPROVEMENTS ====================
# Default font size 12 -> 14
replacements.append((
    'ws.Cells.Style.Font.Size = 12;',
    'ws.Cells.Style.Font.Size = 14;'
))

# BuildGenericLayout header fonts
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

# BuildGenericLayout header row heights
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

# BuildGenericLayout table header row heights
replacements.append((
    """        int startRow = 14;
        ws.Row(14).Height = 25;
        ws.Row(15).Height = 25;""",
    """        int startRow = 14;
        ws.Row(14).Height = 30;
        ws.Row(15).Height = 30;"""
))

# BuildGenericLayout data row height (Adding Height setting inside loop)
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

# BuildGenericLayout summary row height
replacements.append((
    """        ws.Row(currentRow).Height = 25;
        currentRow++;""",
    """        ws.Row(currentRow).Height = 30;
        currentRow++;"""
))

# BuildGenericLayout footer row heights
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

# BuildGenericLayout footer font sizes
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

# BuildGenericLayout column widths
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

# BuildFerguileLayout supplier/importer box fonts and heights
replacements.append((
    'supplierRange.Style.Font.Size = 11;',
    'supplierRange.Style.Font.Size = 13;'
))
replacements.append((
    'importerRange.Style.Font.Size = 11;',
    'importerRange.Style.Font.Size = 13;'
))

# BuildFerguileLayout table header row height
replacements.append((
    """        int startRow = 10;
        ws.Row(10).Height = 30;""",
    """        int startRow = 10;
        ws.Row(10).Height = 36;"""
))

# BuildFerguileLayout data row height (inside loop)
replacements.append((
    'ws.Row(currentRow).Height = 30;',
    'ws.Row(currentRow).Height = 36;'
))

# BuildFerguileLayout brand single row image height
replacements.append((
    'if (brandEndRow == brandStartRow) ws.Row(brandStartRow).Height = 80;',
    'if (brandEndRow == brandStartRow) ws.Row(brandStartRow).Height = 90;'
))

# BuildFerguileLayout summary row height
replacements.append((
    """        for (int i = 1; i <= 17; i++) ws.Cells[currentRow, i].Style.Border.BorderAround(ExcelBorderStyle.Thin);
        ws.Row(currentRow).Height = 25;""",
    """        for (int i = 1; i <= 17; i++) ws.Cells[currentRow, i].Style.Border.BorderAround(ExcelBorderStyle.Thin);
        ws.Row(currentRow).Height = 30;"""
))

# BuildFerguileLayout column widths
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

# BuildFerguileLayout footer row heights
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

# BuildFerguileLayout footer fonts
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

# ==================== 2. GROUPING BY MARCA.ID ====================
replacements.append((
    """            var modelGroups = brandGroup.Items
                .GroupBy(i => i.ModuloTecido?.Modulo?.Id ?? 0)""",
    """            var modelGroups = brandGroup.Items
                .GroupBy(i => i.ModuloTecido?.Modulo?.Marca?.Id ?? 0L)"""
))

# ==================== 3. FIX SYNTAX ERROR IN GRIDROW FONT SIZE ====================
# Note: we checked out the original file, so this syntax error is back in the string.
# Let's replace the original syntax-error block.
replacements.append((
    """        ws.Cells[gridRow, 1, gridRow + 7, 17].Style.Font.Size = 10;gridRow + 7, rightCol + 1].Value = !string.IsNullOrWhiteSpace(pi.CondicaoPagamento) ? pi.CondicaoPagamento : (pi.Configuracoes?.CondicoesPagamento ?? "T/T");
        ws.Cells[gridRow, 1, gridRow + 7, 17].Style.Font.Size = 8;""",
    """        ws.Cells[gridRow, 1, gridRow + 7, 17].Style.Font.Size = 10;"""
))

# ==================== 4. ALIGN COLUMNS 2 TO 14 TO CENTER (FERGUILE) ====================
# Also change Column 11 alignment inside the loop from Right to Center.
replacements.append((
    'ws.Cells[currentRow, 11].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;',
    'ws.Cells[currentRow, 11].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;'
))

# Add explicit Center alignment for Columns 2 to 14 after data loop in BuildFerguileLayout
replacements.append((
    """        ws.Cells[startRow + 1, 1, currentRow - 1, 17].Style.VerticalAlignment = ExcelVerticalAlignment.Center;

        // ═══════════════ FOOTER ═══════════════""",
    """        ws.Cells[startRow + 1, 1, currentRow - 1, 17].Style.VerticalAlignment = ExcelVerticalAlignment.Center;

        // Centralização horizontal e vertical das colunas REFERENCIA (2) a OBSERVACIÓN (14)
        var dataAlignmentRange = ws.Cells[startRow + 1, 2, currentRow - 1, 14];
        dataAlignmentRange.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
        dataAlignmentRange.Style.VerticalAlignment = ExcelVerticalAlignment.Center;

        // ═══════════════ FOOTER ═══════════════"""
))

# ==================== 5. ENCODING CORRECTIONS (UNICODE ESCAPES) ====================
# Replace comments with ASCII characters
replacements.append(('// Configuração global da planilha', '// Configuracao global da planilha'))
replacements.append(('// Centralização do conteúdo (Karams/Koyo)', '// Centralizacao do conteudo (Karams/Koyo)'))

# Supplier data state/address
replacements.append(('State = "PARANÁ",', 'State = "PARAN\\u00C1",'))
replacements.append(('BeneficiaryAddress = "SÃO PAULO - BR"', 'BeneficiaryAddress = "S\\u00C3O PAULO - BR"'))
replacements.append((
    'Address = "RUA CANÁRIO DO BREJO, 630 - RIBEIRÃO BANDEIRANTE DO NORTE",',
    'Address = "RUA CAN\\u00C1RIO DO BREJO, 630 - RIBEIR\\u00C3O BANDEIRANTE DO NORTE",'
))

# Translate dictionaries
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
replacements.append(
    ('["VALIDITY_NOTE"] = "* Esta proforma é válida por {0} dias a partir da data de emissão.",',
     '["VALIDITY_NOTE"] = "* Esta proforma \\u00E9 v\\u00E1lida por {0} dias a partir da data de emiss\\u00E3o.",')
)
replacements.append(('["REFERENCIA"] = "REFERÊNCIA",', '["REFERENCIA"] = "REFER\\u00CANCIA",'))
replacements.append(('["UNIT"] = "UNITÁRIO",', '["UNIT"] = "UNIT\\u00C1RIO",'))

# Spanish translate
replacements.append(('["ADDRESS"] = "DIRECCIÓN:",', '["ADDRESS"] = "DIRECCI\\u00D3N:",'))
replacements.append(('["PHONE"] = "TELÉFONO:",', '["PHONE"] = "TEL\\u00C9FONO:",'))
replacements.append(('["DESCRIPTION"] = "DESCRIPCIÓN",', '["DESCRIPTION"] = "DESCRIPCI\\u00D3N",'))
replacements.append(('["TOTAL_VOLUME"] = "TOTAL VOLUMEN M³",', '["TOTAL_VOLUME"] = "TOTAL VOLUMEN M\\u00B3",'))
replacements.append(('["OBSERVATION"] = "OBSERVACIÓN",', '["OBSERVATION"] = "OBSERVACI\\u00D3N",'))
replacements.append(
    ('["VALIDITY_NOTE"] = "* Esta proforma es válida por {0} días a partir de la fecha de emisión.",',
     '["VALIDITY_NOTE"] = "* Esta proforma es v\\u00E1lida por {0} d\\u00EDas a partir de la fecha de emisi\\u00F3n.",')
)

# English translate total volume
replacements.append(('["TOTAL_VOLUME"] = "TOTAL M³",', '["TOTAL_VOLUME"] = "TOTAL M\\u00B3",'))

# Inner helper
replacements.append(('(lang == "EN" ? "50 days after first payment" : "50 dias após o primeiro pagamento"));',
                     '(lang == "EN" ? "50 days after first payment" : "50 dias ap\\u00F3s o primeiro pagamento"));'))

# Generic layout footer N2 total volume
replacements.append(('ws.Cells[currentRow + 4, 8].Value = "CBM M³: " + totalM3.ToString("N2");',
                     'ws.Cells[currentRow + 4, 8].Value = "CBM M\\u00B3: " + totalM3.ToString("N2");'))
replacements.append(('ws.Cells[currentRow + 7, 8].Value = lang == "EN" ? "TOTAL VOLUME: " + totalM3.ToString("N2") : "VOLUMEN TOTAL: " + totalM3.ToString("N2");',
                     'ws.Cells[currentRow + 7, 8].Value = lang == "EN" ? "TOTAL VOLUME: " + totalM3.ToString("N2") : "VOLUMEN TOTAL: " + totalM3.ToString("N2");'))

# Ferguile table headers unicode fixes
replacements.append((
    """            "FOTO", "REFERENCIA", "CÓDIGO", "DESCRIPCIÓN", "DESC/VOL",
            "MARCA", "LARG.", "ALT.", "PROF.", "CANT.",
            "TOTAL M3", "FABRICACIÓN", "TELA", "OBSERVACIÓN", "DESPESAS", unitLabel, totalLabel""",
    """            "FOTO", "REFERENCIA", "C\\u00D3DIGO", "DESCRIPCI\\u00D3N", "DESC/VOL",
            "MARCA", "LARG.", "ALT.", "PROF.", "CANT.",
            "TOTAL M3", "FABRICACI\\u00D3N", "TELA", "OBSERVACI\\u00D3N", "DESPESAS", unitLabel, totalLabel"""
))

# Ferguile footer unicode
replacements.append(('CBM M³: {totalM3:N3}', 'CBM M\\u00B3: {totalM3:N3}'))
replacements.append(('TOTAL VOLUME: {totalM3:N3}', 'TOTAL VOLUME: {totalM3:N3}')) # wait, no accents here
replacements.append(('VOLUMEN TOTAL: {totalM3:N3}', 'VOLUMEN TOTAL: {totalM3:N3}')) # no accents here

print("Applying replacements...")
new_content = content
for target, rep in replacements:
    if target in new_content:
        new_content = new_content.replace(target, rep)
        print(f"Replaced successfully: {repr(target[:30])}...")
    else:
        print(f"FAILED to find target: {repr(target[:30])}...")

with open(path, 'w', encoding='latin-1') as f:
    f.write(new_content)
print("Script finished.")
