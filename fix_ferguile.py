"""
Replaces the entire BuildFerguileLayout method in PiExportService.cs
with the correct clean implementation.
"""
import re

cs_path = r"backend\Pi.Api\Services\PiExportService.cs"

with open(cs_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Find the start marker: line with 'private void BuildFerguileLayout('
# Find the end marker: the closing brace that ends the method
# We'll use line-by-line approach to find the method boundaries

lines = content.split('\n')

start_line = None
for i, line in enumerate(lines):
    if 'private void BuildFerguileLayout(' in line:
        start_line = i
        break

if start_line is None:
    print("ERROR: Could not find BuildFerguileLayout method!")
    exit(1)

print(f"Found method start at line {start_line + 1}")

# Now find the closing brace by tracking brace depth
depth = 0
end_line = None
for i in range(start_line, len(lines)):
    depth += lines[i].count('{') - lines[i].count('}')
    if depth == 0 and i > start_line:
        end_line = i
        break

if end_line is None:
    print("ERROR: Could not find method end!")
    exit(1)

print(f"Found method end at line {end_line + 1}")

# The new method to replace with
new_method = r'''    private void BuildFerguileLayout(ExcelWorksheet ws, ProformaInvoice pi, string currency, int validity, SupplierMetadata metadata, string lang)
    {
        string piNumber = GetFormattedPiNumber(pi);
        var dateObj = pi.DataPi.DateTime;

        // ═══════════════ HEADER ═══════════════
        var supplierRange = ws.Cells["A1:I9"];
        supplierRange.Merge = true;
        supplierRange.Style.Border.BorderAround(ExcelBorderStyle.Thin);
        supplierRange.Style.VerticalAlignment = ExcelVerticalAlignment.Top;
        supplierRange.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
        supplierRange.Style.WrapText = true;
        supplierRange.Style.Font.Size = 9;

        string supplierText = $"{metadata.Name}\n" +
                              $"CNPJ: {metadata.Cnpj}\n" +
                              $"ADDRESS: {metadata.Address}\n" +
                              $"{metadata.City} - {metadata.State}\n" +
                              $"ZIP CODE: {metadata.Zip}\n" +
                              $"COUNTRY: {metadata.Country}\n" +
                              $"DELIVERY TIME: {(!string.IsNullOrWhiteSpace(pi.TempoEntrega) ? pi.TempoEntrega : "60 dias")}\n" +
                              $"INCOTERM: {pi.Frete?.Nome} - ARAPONGAS PR\n" +
                              $"PAYMENT TERM: {(!string.IsNullOrWhiteSpace(pi.CondicaoPagamento) ? pi.CondicaoPagamento : (pi.Configuracoes?.CondicoesPagamento ?? "AT SIGHT"))}";
        ws.Cells["A1"].Value = supplierText;

        var importerRange = ws.Cells["J1:Q9"];
        importerRange.Merge = true;
        importerRange.Style.Border.BorderAround(ExcelBorderStyle.Thin);
        importerRange.Style.VerticalAlignment = ExcelVerticalAlignment.Top;
        importerRange.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
        importerRange.Style.WrapText = true;
        importerRange.Style.Font.Size = 9;

        string importerText = $"PROFORMA INVOICE: {piNumber}\n" +
                              $"DATE: {dateObj:dd/MM/yyyy}\n" +
                              $"ORDER DATE: {dateObj:dd/MM/yyyy}\n" +
                              $"IMPORTER:\n" +
                              $"{pi.Cliente?.Nome}\n" +
                              $"{(lang == "ES" ? "NIT/CUIT" : "TAX ID")}: {pi.Cliente?.Nit}\n" +
                              $"ADDRESS: {pi.Cliente?.Endereco}{(string.IsNullOrEmpty(pi.Cliente?.Cidade) ? "" : ", " + pi.Cliente.Cidade)}\n" +
                              $"ZIP CODE: {pi.Cliente?.Cep}\n" +
                              $"COUNTRY: {pi.Cliente?.Pais ?? "Argentina"}\n" +
                              $"RESPONSIBLE PERSON: {pi.Cliente?.PessoaContato ?? ".."}\n" +
                              $"TEL.: {pi.Cliente?.Telefone}\n" +
                              $"E-MAIL: {pi.Cliente?.Email}";
        ws.Cells["J1"].Value = importerText;

        // ═══════════════ TABLE HEADERS ═══════════════
        int startRow = 10;
        bool isBRL = string.Equals(currency, "BRL", StringComparison.OrdinalIgnoreCase);
        string unitLabel = isBRL ? "UNIT REAIS" : "UNIT DOLAR";
        string totalLabel = isBRL ? "TOTAL BRL" : "TOTAL USD";

        string[] headers = {
            "FOTO", "REFERENCIA", "CÓDIGO", "DESCRIPCIÓN", "DESC/VOL",
            "MARCA", "LARG.", "ALT.", "PROF.", "CANT.",
            "TOTAL M3", "FABRICACIÓN", "TELA", "OBSERVACIÓN", "DESPESAS", unitLabel, totalLabel
        };

        for (int i = 0; i < headers.Length; i++)
        {
            var cell = ws.Cells[startRow, i + 1];
            cell.Value = headers[i];
            cell.Style.Font.Bold = true;
            cell.Style.Fill.PatternType = ExcelFillStyle.Solid;
            cell.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(0x2C, 0x3E, 0x50));
            cell.Style.Font.Color.SetColor(Color.White);
            cell.Style.Border.BorderAround(ExcelBorderStyle.Thin);
            cell.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
            cell.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
        }

        // ═══════════════ FREIGHT PRE-CALCULATION ═══════════════
        decimal piTotalM3 = pi.PiItens.Sum(i => i.M3 * i.Quantidade);
        decimal piTotalFreteUSD = pi.ValorTotalFreteUSD;
        decimal piTotalFreteBRL = pi.ValorTotalFreteBRL;
        decimal risk = pi.CotacaoRisco;

        var orderedItems = pi.PiItens
            .OrderBy(i => i.ModuloTecido?.Modulo?.Marca?.Nome ?? "ZZZ")
            .ThenBy(i => i.ModuloTecido?.Modulo?.Descricao ?? "")
            .ThenBy(i => i.ModuloTecido?.CodigoModuloTecido ?? "")
            .ToList();

        foreach (var item in orderedItems)
        {
            if (item.Largura == 0 && item.ModuloTecido?.Modulo?.Largura > 0) item.Largura = item.ModuloTecido.Modulo.Largura;
            if (item.Profundidade == 0 && item.ModuloTecido?.Modulo?.Profundidade > 0) item.Profundidade = item.ModuloTecido.Modulo.Profundidade;
            if (item.Altura == 0 && item.ModuloTecido?.Modulo?.Altura > 0) item.Altura = item.ModuloTecido.Modulo.Altura;
            if (item.M3 == 0)
            {
                decimal calcM3 = (decimal)item.Largura * (decimal)item.Profundidade * (decimal)item.Altura;
                if (calcM3 > 500) item.M3 = calcM3 / 1000000;
                else if (calcM3 > 0) item.M3 = calcM3;
            }
        }

        var itemFreightUSD = new Dictionary<long, decimal>();
        var itemFreightBRL = new Dictionary<long, decimal>();
        decimal currentRemBRL = piTotalFreteBRL;
        decimal currentRemUSD = piTotalFreteUSD;

        for (int i = 0; i < orderedItems.Count; i++)
        {
            var item = orderedItems[i];
            bool isLast = i == orderedItems.Count - 1;
            decimal fUnitBRL = 0, fUnitUSD = 0;

            if (isLast)
            {
                fUnitBRL = item.Quantidade > 0 ? currentRemBRL / item.Quantidade : 0;
                fUnitUSD = item.Quantidade > 0 ? currentRemUSD / item.Quantidade : 0;
            }
            else
            {
                if (string.Equals(pi.TipoRateio, "IGUAL", StringComparison.OrdinalIgnoreCase))
                {
                    decimal rowShareBRL = orderedItems.Count > 0 ? piTotalFreteBRL / orderedItems.Count : 0;
                    decimal rowShareUSD = orderedItems.Count > 0 ? piTotalFreteUSD / orderedItems.Count : 0;
                    fUnitBRL = item.Quantidade > 0 ? rowShareBRL / item.Quantidade : 0;
                    fUnitUSD = item.Quantidade > 0 ? rowShareUSD / item.Quantidade : 0;
                }
                else
                {
                    fUnitBRL = piTotalM3 > 0 ? (piTotalFreteBRL / piTotalM3 * item.M3) : 0;
                    fUnitUSD = piTotalM3 > 0 ? (piTotalFreteUSD / piTotalM3 * item.M3) : 0;
                }
                currentRemBRL -= (fUnitBRL * item.Quantidade);
                currentRemUSD -= (fUnitUSD * item.Quantidade);
            }
            itemFreightBRL[item.Id] = fUnitBRL;
            itemFreightUSD[item.Id] = fUnitUSD;
        }

        // ═══════════════ DATA ROWS ═══════════════
        var colorRef   = Color.FromArgb(0xEF, 0xF6, 0xFF);
        var colorCode  = Color.White;
        var colorQty   = Color.FromArgb(0xEC, 0xF9, 0xE7);
        var colorTotal = Color.FromArgb(0xFF, 0xF3, 0xF3);

        int currentRow = startRow + 1;
        decimal totalQty = 0;
        decimal totalM3 = 0;
        decimal totalFinalPI = 0;

        var brandGroups = orderedItems
            .GroupBy(i => i.ModuloTecido?.Modulo?.Marca?.Id ?? 0)
            .Select(g => new {
                Brand = g.First().ModuloTecido?.Modulo?.Marca,
                Items = g.OrderBy(i => i.ModuloTecido?.Modulo?.Descricao ?? "")
                          .ThenBy(i => i.ModuloTecido?.CodigoModuloTecido ?? "")
                          .ToList()
            })
            .OrderBy(g => g.Brand?.Nome ?? "ZZZ")
            .ToList();

        foreach (var brandGroup in brandGroups)
        {
            var brand = brandGroup.Brand;
            int brandStartRow = currentRow;

            var modelGroups = brandGroup.Items
                .GroupBy(i => i.ModuloTecido?.Modulo?.Id ?? 0)
                .Select(g => new {
                    ModelName = g.First().SubModulo?.DescricaoProduto
                                ?? g.First().PiItemPeca?.Descricao
                                ?? g.First().ModuloTecido?.Modulo?.Descricao
                                ?? "",
                    Items = g.OrderBy(i => i.ModuloTecido?.CodigoModuloTecido ?? "").ToList()
                })
                .ToList();

            foreach (var modelGroup in modelGroups)
            {
                int modelStartRow = currentRow;

                foreach (var item in modelGroup.Items)
                {
                    decimal fUnit = isBRL ? itemFreightBRL[item.Id] : itemFreightUSD[item.Id];
                    decimal exwUnit = item.ValorEXW;
                    if (isBRL) exwUnit *= risk;
                    decimal unitPrice = exwUnit + fUnit;
                    decimal rowTotal = unitPrice * item.Quantidade;
                    decimal itemM3Total = Math.Round(item.M3 * item.Quantidade, 4);

                    totalQty += item.Quantidade;
                    totalM3  += itemM3Total;
                    totalFinalPI += rowTotal;

                    string codigoVal = item.TempCodigoModuloTecido ?? item.ModuloTecido?.CodigoModuloTecido ?? "";
                    string telaCode = codigoVal.Contains("-") ? codigoVal.Split('-')[^1].Trim() : codigoVal;
                    string descVol = item.SubModulo?.Codigo ?? item.PiItemPeca?.Descricao ?? "";
                    string fabricacion = item.ModuloTecido?.Tecido?.Nome ?? "";
                    string descripcion = item.ModuloTecido?.Modulo?.Descricao ?? "";
                    if (!string.IsNullOrEmpty(codigoVal) && !descripcion.Contains(codigoVal))
                        descripcion = (descripcion + " " + codigoVal).Trim();

                    ws.Cells[currentRow, 3].Value = codigoVal;
                    ws.Cells[currentRow, 4].Value = descripcion;
                    ws.Cells[currentRow, 5].Value = descVol;
                    ws.Cells[currentRow, 7].Value = item.Largura;
                    ws.Cells[currentRow, 8].Value = item.Altura;
                    ws.Cells[currentRow, 9].Value = item.Profundidade;
                    ws.Cells[currentRow, 10].Value = item.Quantidade;
                    ws.Cells[currentRow, 11].Value = itemM3Total;
                    ws.Cells[currentRow, 12].Value = fabricacion;
                    ws.Cells[currentRow, 13].Value = telaCode;
                    ws.Cells[currentRow, 14].Value = item.Observacao;
                    ws.Cells[currentRow, 15].Value = fUnit * item.Quantidade;
                    ws.Cells[currentRow, 16].Value = unitPrice;
                    ws.Cells[currentRow, 17].Value = rowTotal;

                    ws.Cells[currentRow, 3].Style.Fill.PatternType = ExcelFillStyle.Solid;
                    ws.Cells[currentRow, 3].Style.Fill.BackgroundColor.SetColor(colorCode);
                    ws.Cells[currentRow, 10].Style.Fill.PatternType = ExcelFillStyle.Solid;
                    ws.Cells[currentRow, 10].Style.Fill.BackgroundColor.SetColor(colorQty);
                    ws.Cells[currentRow, 17].Style.Fill.PatternType = ExcelFillStyle.Solid;
                    ws.Cells[currentRow, 17].Style.Fill.BackgroundColor.SetColor(colorTotal);

                    for (int c = 1; c <= 17; c++) ws.Cells[currentRow, c].Style.Border.BorderAround(ExcelBorderStyle.Thin);

                    ws.Cells[currentRow, 7].Style.Numberformat.Format  = "0.00";
                    ws.Cells[currentRow, 8].Style.Numberformat.Format  = "0.00";
                    ws.Cells[currentRow, 9].Style.Numberformat.Format  = "0.00";
                    ws.Cells[currentRow, 10].Style.Numberformat.Format = "#,##0";
                    ws.Cells[currentRow, 11].Style.Numberformat.Format = "#,##0.00";
                    string moneyFmt = isBRL ? "_-R$* #,##0.00_-" : "_-$* #,##0.00_-";
                    ws.Cells[currentRow, 15].Style.Numberformat.Format = moneyFmt;
                    ws.Cells[currentRow, 16].Style.Numberformat.Format = moneyFmt;
                    ws.Cells[currentRow, 17].Style.Numberformat.Format = moneyFmt;

                    ws.Cells[currentRow, 10].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    ws.Cells[currentRow, 11].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                    ws.Cells[currentRow, 15].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                    ws.Cells[currentRow, 16].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                    ws.Cells[currentRow, 17].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                    ws.Row(currentRow).Height = 25;
                    currentRow++;
                }

                var refRange = ws.Cells[modelStartRow, 2, currentRow - 1, 2];
                refRange.Merge = true;
                refRange.Value = modelGroup.ModelName;
                refRange.Style.Fill.PatternType = ExcelFillStyle.Solid;
                refRange.Style.Fill.BackgroundColor.SetColor(colorRef);
                refRange.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                refRange.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                refRange.Style.Font.Bold = true;
                refRange.Style.Border.BorderAround(ExcelBorderStyle.Thin);
                refRange.Style.WrapText = true;
            }

            int brandEndRow = currentRow - 1;

            var marcaRange = ws.Cells[brandStartRow, 6, brandEndRow, 6];
            marcaRange.Merge = true;
            marcaRange.Value = brandGroup.Items.FirstOrDefault()?.ModuloTecido?.Modulo?.Fornecedor?.Nome ?? brand?.Nome ?? metadata.Brand;
            marcaRange.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
            marcaRange.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
            marcaRange.Style.Font.Bold = true;
            marcaRange.Style.Border.BorderAround(ExcelBorderStyle.Thin);

            ws.Cells[brandStartRow, 1, brandEndRow, 1].Merge = true;
            ws.Cells[brandStartRow, 1].Style.Border.BorderAround(ExcelBorderStyle.Thin);
            if (brand?.Imagem != null) AddCenteredImage(ws, brandStartRow, brandEndRow, brand.Imagem, $"PicF_{brand.Id}_{brandStartRow}");
            if (brandEndRow == brandStartRow) ws.Row(brandStartRow).Height = 65;
        }

        // ═══════════════ SUMMARY ROW ═══════════════
        var totalRowBgColor = Color.FromArgb(0x2C, 0x3E, 0x50);
        ws.Cells[currentRow, 1, currentRow, 9].Merge = true;
        ws.Cells[currentRow, 1].Value = "TOTAL";
        ws.Cells[currentRow, 1].Style.Font.Bold = true;
        ws.Cells[currentRow, 1].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
        ws.Cells[currentRow, 10].Value = totalQty;
        ws.Cells[currentRow, 10].Style.Numberformat.Format = "#,##0";
        ws.Cells[currentRow, 10].Style.Font.Bold = true;
        ws.Cells[currentRow, 11].Value = totalM3;
        ws.Cells[currentRow, 11].Style.Numberformat.Format = "#,##0.00";
        ws.Cells[currentRow, 11].Style.Font.Bold = true;
        ws.Cells[currentRow, 17].Value = totalFinalPI;
        ws.Cells[currentRow, 17].Style.Numberformat.Format = isBRL
            ? "_-[R$-416]* #,##0.00_ ;_-[R$-416]* \\-#,##0.00\\ ;_-[R$-416]* \\-??_ ;_-@_ "
            : "_-[$$ -409]* #,##0.00_ ;_-[$$ -409]* \\-#,##0.00\\ ;_-[$$ -409]* \\-??_ ;_-@_ ";
        ws.Cells[currentRow, 17].Style.Font.Bold = true;
        ws.Cells[currentRow, 1, currentRow, 17].Style.Fill.PatternType = ExcelFillStyle.Solid;
        ws.Cells[currentRow, 1, currentRow, 17].Style.Fill.BackgroundColor.SetColor(totalRowBgColor);
        ws.Cells[currentRow, 1, currentRow, 17].Style.Font.Color.SetColor(Color.White);
        for (int i = 1; i <= 17; i++) ws.Cells[currentRow, i].Style.Border.BorderAround(ExcelBorderStyle.Thin);
        ws.Row(currentRow).Height = 20;
        currentRow++;

        // Column widths
        ws.Column(1).Width = 12; ws.Column(2).Width = 13; ws.Column(3).Width = 11;
        ws.Column(4).Width = 25; ws.Column(5).Width = 15; ws.Column(6).Width = 8;
        ws.Column(7).Width = 7;  ws.Column(8).Width = 7;  ws.Column(9).Width = 6.5;
        ws.Column(10).Width = 7; ws.Column(11).Width = 11; ws.Column(12).Width = 13;
        ws.Column(13).Width = 10; ws.Column(14).Width = 20; ws.Column(15).Width = 10;
        ws.Column(16).Width = 13; ws.Column(17).Width = 14;

        ws.Cells[startRow + 1, 1, currentRow - 1, 17].Style.VerticalAlignment = ExcelVerticalAlignment.Center;

        // ═══════════════ FOOTER ═══════════════
        currentRow += 2;
        int footerStartRow = currentRow;
        int footerEndRow = currentRow + 10;

        var bankRange = ws.Cells[footerStartRow, 1, footerEndRow, 9];
        bankRange.Merge = true;
        bankRange.Style.Border.BorderAround(ExcelBorderStyle.Thin);
        bankRange.Style.VerticalAlignment = ExcelVerticalAlignment.Top;
        bankRange.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
        bankRange.Style.WrapText = true;
        bankRange.Style.Font.Size = 9;
        string bankText = $"{t("BANK_DETAILS", lang)}\n" +
                          $"Beneficiary: {metadata.Bank.BeneficiaryName}\n" +
                          $"CNPJ: {metadata.Cnpj}\n" +
                          $"BANK: {metadata.Bank.Beneficiary}\n" +
                          $"BENEFICIARY ACCOUNT: {metadata.Bank.BeneficiaryAccount}\n" +
                          $"IBAN CODE: {metadata.Bank.BeneficiaryIban}\n" +
                          $"SWIFT CODE: {metadata.Bank.BeneficiarySwift}";
        ws.Cells[footerStartRow, 1].Value = bankText;

        var prodRange = ws.Cells[footerStartRow, 10, footerEndRow, 17];
        prodRange.Merge = true;
        prodRange.Style.Border.BorderAround(ExcelBorderStyle.Thin);
        prodRange.Style.VerticalAlignment = ExcelVerticalAlignment.Top;
        prodRange.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
        prodRange.Style.WrapText = true;
        prodRange.Style.Font.Size = 9;
        string brandDisplay = string.Equals(metadata.Brand, "Ferguile", StringComparison.OrdinalIgnoreCase) ? "Ferguile/Livintus" : metadata.Brand;
        string prodText = $"{t("PRODUCT_DATA", lang)}\n" +
                          $"{t("BRAND", lang)}: {brandDisplay}\n" +
                          $"NCM: 94016100\n" +
                          $"{(lang == "EN" ? "Product: " : "Producto: ")}{totalQty}\n" +
                          $"CBM M³: {totalM3:N3}\n" +
                          $"P.N. TOTAL:\n" +
                          $"P.B. TOTAL:\n" +
                          $"{(lang == "EN" ? "TOTAL VOLUME: " : "VOLUMEN TOTAL: ")}{totalM3:N3}\n" +
                          $"{(lang == "PT" ? "Produtos originais de fabrica" : (lang == "EN" ? "Original factory products" : "Productos originales de fabrica"))}\n" +
                          $"{t("ORIGIN", lang)}";
        ws.Cells[footerStartRow, 10].Value = prodText;

        currentRow = footerEndRow + 1;
        var validityRange = ws.Cells[currentRow, 1, currentRow, 17];
        validityRange.Merge = true;
        validityRange.Value = string.Format(t("VALIDITY_NOTE", lang), validity);
        validityRange.Style.Font.Italic = true;
        validityRange.Style.Font.Size = 8;
        validityRange.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
    }'''

# Rebuild the file
new_lines = lines[:start_line] + new_method.split('\n') + lines[end_line + 1:]
new_content = '\n'.join(new_lines)

with open(cs_path, 'w', encoding='utf-8') as f:
    f.write(new_content)

print(f"SUCCESS: Replaced lines {start_line+1} to {end_line+1} ({end_line - start_line + 1} lines) with {len(new_method.split(chr(10)))} lines of new method")
