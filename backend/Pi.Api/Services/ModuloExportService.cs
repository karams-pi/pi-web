using OfficeOpenXml;
using OfficeOpenXml.Style;
using Pi.Api.Models;
using System.Drawing;
using System.Text.RegularExpressions;
using System.IO;

namespace Pi.Api.Services;

public class ModuloExportService
{
    public class PriceListItemDto
    {
        public Modulo Modulo { get; set; } = null!;
        public decimal ValorFreteRateadoUSD { get; set; }
        public int Quantidade { get; set; } = 1;
    }

    public byte[] ExportToExcel(List<Modulo> modules, string currency, decimal cotacao, List<Configuracao> configs, int validityDays = 30)
    {
        using var package = new ExcelPackage();
        var ws = package.Workbook.Worksheets.Add("Relatório de Módulos");

        // Global Setup
        ws.Cells.Style.Font.Name = "Segoe UI";
        ws.Cells.Style.Font.Size = 9;

        string title = $"Relatório de Módulos - {(currency == "BRL" ? "Valores em Reais (R$)" : "Valores em Dólar (EXW)")}";
        
        // ═══════════════ HEADER ═══════════════
        ws.Cells["A1"].Value = title;
        ws.Cells["A1"].Style.Font.Bold = true;
        ws.Cells["A1"].Style.Font.Size = 14;

        // Deployment Verification Marker
        ws.Cells["Z1"].Style.Font.Color.SetColor(Color.White);

        // Hidden Quote (White font)
        string hiddenQuoteValue = "";
        if (currency == "EXW" && cotacao > 0)
        {
            var config = configs.FirstOrDefault(); 
            if (config != null)
            {
                var fornName = config.IdFornecedor.HasValue ? modules.FirstOrDefault(m => m.IdFornecedor == config.IdFornecedor)?.Fornecedor?.Nome ?? "" : "";
                bool isFerguile = fornName.ToLower().Contains("ferguile") || fornName.ToLower().Contains("livintus");
                decimal valorQuote = Math.Round(isFerguile ? config.ValorReducaoDolar : (cotacao - config.ValorReducaoDolar), 2);
                hiddenQuoteValue = $"Cotação na exportação: {valorQuote:N2}";
            }
            else
            {
                hiddenQuoteValue = $"Cotação na exportação: {cotacao:N2} (Simples)";
            }

            ws.Cells["A2"].Value = hiddenQuoteValue;
            ws.Cells["A2"].Style.Font.Color.SetColor(Color.White);
            ws.Cells["A2"].Style.Font.Size = 10;
        }

        ws.Cells["B2"].Value = "Fecha de Emisión:";
        ws.Cells["B2"].Style.Font.Bold = true;
        ws.Cells["C2"].Value = DateTime.Now.ToString("dd/MM/yyyy");
        
        ws.Cells["F1:J1"].Merge = true;
        ws.Cells["F1"].Value = $"* Esta lista de precios es válida por {validityDays} días a partir de la fecha de emisión.";
        ws.Cells["F1"].Style.Font.Color.SetColor(Color.FromArgb(217, 83, 79)); // #d9534f
        ws.Cells["F1"].Style.Font.Bold = true;
        ws.Cells["F1"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

        // ═══════════════ DATA PROCESSING ═══════════════
        var uniqueFabrics = modules
            .SelectMany(m => m.ModulosTecidos)
            .Select(mt => mt.Tecido)
            .Where(t => t != null)
            .GroupBy(t => t!.Id)
            .Select(g => g.First())
            .ToList();

        // Natural sort for fabrics (G0, G1, G2...)
        uniqueFabrics = uniqueFabrics
            .OrderBy(t => Regex.Replace(t!.Nome, @"\d+", m => m.Value.PadLeft(5, '0')))
            .ToList();

        int fabricStartCol = 8;
        int maxCols = fabricStartCol + uniqueFabrics.Count - 1;

        // ═══════════════ CONTENT ═══════════════
        int currentRow = 5;
        var groups = modules
            .GroupBy(m => new { 
                Forn = m.Fornecedor?.Nome ?? "N/A", 
                Cat = m.Categoria?.Nome ?? "N/A" 
            })
            .OrderBy(g => g.Key.Forn).ThenBy(g => g.Key.Cat);

        foreach (var group in groups)
        {
            // Supplier - Category Header Row
            ws.Cells[currentRow, 1, currentRow, maxCols].Merge = true;
            ws.Cells[currentRow, 1].Value = $"{group.Key.Forn.ToUpper()} - {group.Key.Cat.ToUpper()}";
            ws.Cells[currentRow, 1].Style.Font.Bold = true;
            ws.Cells[currentRow, 1].Style.Font.Size = 12;
            ws.Cells[currentRow, 1].Style.Fill.PatternType = ExcelFillStyle.Solid;
            ws.Cells[currentRow, 1].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(209, 213, 219)); // #d1d5db
            ws.Cells[currentRow, 1].Style.Border.BorderAround(ExcelBorderStyle.Thin);
            ws.Row(currentRow).Height = 25;
            currentRow++;

            var brandGroups = group.GroupBy(m => m.Marca).OrderBy(b => b.Key?.Nome);
            foreach (var brandGroup in brandGroups)
            {
                var brand = brandGroup.Key;
                var brandItems = brandGroup.OrderBy(m => m.Descricao).ToList();

                // Table Headers (Modelo, Módulo, ... , Valor)
                // Row 1
                ws.Cells[currentRow, 1, currentRow + 1, 1].Merge = true; ws.Cells[currentRow, 1].Value = "Foto";
                ws.Cells[currentRow, 2, currentRow + 1, 2].Merge = true; ws.Cells[currentRow, 2].Value = "Modelo";
                ws.Cells[currentRow, 3, currentRow + 1, 3].Merge = true; ws.Cells[currentRow, 3].Value = "Módulo";
                ws.Cells[currentRow, 4, currentRow + 1, 4].Merge = true; ws.Cells[currentRow, 4].Value = "Larg";
                ws.Cells[currentRow, 5, currentRow + 1, 5].Merge = true; ws.Cells[currentRow, 5].Value = "Prof";
                ws.Cells[currentRow, 6, currentRow + 1, 6].Merge = true; ws.Cells[currentRow, 6].Value = "Alt";
                ws.Cells[currentRow, 7, currentRow + 1, 7].Merge = true; ws.Cells[currentRow, 7].Value = "M³";

                ws.Cells[currentRow, fabricStartCol, currentRow, maxCols].Merge = true;
                ws.Cells[currentRow, fabricStartCol].Value = $"Valor ({(currency == "BRL" ? "Reais" : "EXW")})";

                // Row 2 (Fabrics list)
                for (int i = 0; i < uniqueFabrics.Count; i++)
                {
                    ws.Cells[currentRow + 1, fabricStartCol + i].Value = uniqueFabrics[i]!.Nome;
                }

                // Styling Table Headers
                var hRange = ws.Cells[currentRow, 1, currentRow + 1, maxCols];
                hRange.Style.Font.Bold = true;
                hRange.Style.Font.Size = 8;
                hRange.Style.Fill.PatternType = ExcelFillStyle.Solid;
                hRange.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(224, 224, 224)); // #e0e0e0
                hRange.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                hRange.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                foreach (var cell in hRange) { cell.Style.Border.BorderAround(ExcelBorderStyle.Thin); }

                currentRow += 2;

                // Data Rows
                int brandStartRow = currentRow;
                foreach (var mod in brandItems)
                {
                    ws.Cells[currentRow, 2].Value = mod.Descricao;
                    ws.Cells[currentRow, 3].Value = mod.Pa;
                    ws.Cells[currentRow, 4].Value = mod.Largura;
                    ws.Cells[currentRow, 5].Value = mod.Profundidade;
                    ws.Cells[currentRow, 6].Value = mod.Altura;
                    ws.Cells[currentRow, 7].Value = mod.M3;
                    for (int i = 0; i < uniqueFabrics.Count; i++)
                    {
                        var fid = uniqueFabrics[i]!.Id;
                        var mt = mod.ModulosTecidos.FirstOrDefault(x => x.IdTecido == fid && x.FlAtivo);
                        if (mt != null)
                        {
                            // Find best config (Supplier-specific or Global)
                            var modConfig = configs.FirstOrDefault(c => c.IdFornecedor == mod.IdFornecedor) 
                                            ?? configs.FirstOrDefault(c => c.IdFornecedor == null);

                            decimal val = CalcPrice(mt.ValorTecido, currency, cotacao, modConfig, mod.IdFornecedor, mod.Fornecedor?.Nome);
                            ws.Cells[currentRow, fabricStartCol + i].Value = val;
                        }
                        else
                        {
                            ws.Cells[currentRow, fabricStartCol + i].Value = "-";
                            ws.Cells[currentRow, fabricStartCol + i].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        }
                    }

                    ws.Row(currentRow).Height = 25;
                    currentRow++;
                }

                // Brand Identification (Merged Column 1)
                int brandEndRow = currentRow - 1;
                int totalRows = brandEndRow - brandStartRow + 1;
                if (totalRows == 1)
                {
                    ws.Row(brandStartRow).Height = 85;
                }
                else if (totalRows * 25 < 85)
                {
                    ws.Row(brandStartRow).Height = 85 - (totalRows - 1) * 25;
                }

                ws.Cells[brandStartRow, 1, brandEndRow, 1].Merge = true;
                ws.Cells[brandStartRow, 1].Value = brand?.Nome ?? "Outros";
                ws.Cells[brandStartRow, 1].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                ws.Cells[brandStartRow, 1].Style.VerticalAlignment = ExcelVerticalAlignment.Bottom;
                ws.Cells[brandStartRow, 1].Style.Font.Bold = true;

                if (brand?.Imagem != null)
                {
                    AddCenteredImage(ws, brandStartRow, brandEndRow, brand.Imagem, $"PicB_{brand.Id}_{brandStartRow}", hasText: true);
                }

                // Final Borders and formatting for the brand table
                var tableRange = ws.Cells[brandStartRow, 1, brandEndRow, maxCols];
                foreach (var cell in tableRange) 
                { 
                    cell.Style.Border.BorderAround(ExcelBorderStyle.Thin); 
                }
                tableRange.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                tableRange.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                
                // Keep the brand name text at the bottom of column 1 so it doesn't get covered by the image
                ws.Cells[brandStartRow, 1, brandEndRow, 1].Style.VerticalAlignment = ExcelVerticalAlignment.Bottom;

                currentRow++; // Gap
            }
        }

        // Apply global number formats
        string curSymbol = currency == "BRL" ? "R$ " : "$ ";
        ws.Cells[5, fabricStartCol, currentRow, maxCols].Style.Numberformat.Format = $"\"{curSymbol}\"#,##0.00";
        ws.Cells[5, 3, currentRow, 7].Style.Numberformat.Format = "#,##0.00";

        // Column widths
        ws.Column(1).Width = 30; // Foto
        ws.Column(2).Width = 35; // Modelo
        ws.Column(3).Width = 10; // Módulo
        ws.Column(4).Width = 7;
        ws.Column(5).Width = 7;
        ws.Column(6).Width = 7;
        ws.Column(7).Width = 7; // M³
        for (int i = 0; i < uniqueFabrics.Count; i++) ws.Column(fabricStartCol + i).Width = 12;

        return package.GetAsByteArray();
    }

    public byte[] ExportPriceListToExcel(List<PriceListItemDto> items, string currency, decimal cotacao, List<Configuracao> configs, int validityDays = 30, string? freightType = null)
    {
        using var package = new ExcelPackage();
        var ws = package.Workbook.Worksheets.Add("Lista de Preços");

        ws.Cells.Style.Font.Name = "Segoe UI";
        ws.Cells.Style.Font.Size = 9;

        // Set column widths first so image scaling calculations are correct
        ws.Column(1).Width = 30; // Foto
        ws.Column(2).Width = 35; // Modelo
        ws.Column(3).Width = 10; // Módulo
        ws.Column(4).Width = 7;
        ws.Column(5).Width = 7;
        ws.Column(6).Width = 7;
        ws.Column(7).Width = 7;

        var groupedItems = items
            .GroupBy(i => i.Modulo.Id)
            .Select(g => new PriceListItemDto
            {
                Modulo = g.First().Modulo,
                ValorFreteRateadoUSD = g.First().ValorFreteRateadoUSD,
                Quantidade = g.Sum(i => i.Quantidade)
            })
            .ToList();

        string typeLabel = string.IsNullOrEmpty(freightType) ? "EXW" : freightType.ToUpper();
        string title = $"Lista de Preços - {(currency == "BRL" ? "Valores em Reais (R$)" : $"Valores em Dólar ({typeLabel})")}";
        ws.Cells["A1"].Value = title;
        ws.Cells["A1"].Style.Font.Bold = true;
        ws.Cells["A1"].Style.Font.Size = 14;

        ws.Cells["B2"].Value = "Fecha de Emisión:";
        ws.Cells["B2"].Style.Font.Bold = true;
        ws.Cells["C2"].Value = DateTime.Now.ToString("dd/MM/yyyy");
        
        ws.Cells["F1:J1"].Merge = true;
        ws.Cells["F1"].Value = $"* Esta lista de precios es válida por {validityDays} días a partir de la fecha de emisión.";
        ws.Cells["F1"].Style.Font.Color.SetColor(Color.FromArgb(217, 83, 79));
        ws.Cells["F1"].Style.Font.Bold = true;
        ws.Cells["F1"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

        var uniqueFabrics = groupedItems
            .SelectMany(i => i.Modulo.ModulosTecidos)
            .Select(mt => mt.Tecido)
            .Where(t => t != null)
            .GroupBy(t => t!.Id)
            .Select(g => g.First())
            .ToList();

        uniqueFabrics = uniqueFabrics
            .OrderBy(t => Regex.Replace(t!.Nome, @"\d+", m => m.Value.PadLeft(5, '0')))
            .ToList();

        int fabricStartCol = 8;
        int maxCols = fabricStartCol + uniqueFabrics.Count - 1;

        int currentRow = 5;
        var groups = groupedItems
            .GroupBy(i => new { 
                Forn = i.Modulo.Fornecedor?.Nome ?? "N/A", 
                Cat = i.Modulo.Categoria?.Nome ?? "N/A" 
            })
            .OrderBy(g => g.Key.Forn).ThenBy(g => g.Key.Cat);

        foreach (var group in groups)
        {
            ws.Cells[currentRow, 1, currentRow, maxCols].Merge = true;
            ws.Cells[currentRow, 1].Value = $"{group.Key.Forn.ToUpper()} - {group.Key.Cat.ToUpper()}";
            ws.Cells[currentRow, 1].Style.Font.Bold = true;
            ws.Cells[currentRow, 1].Style.Font.Size = 12;
            ws.Cells[currentRow, 1].Style.Fill.PatternType = ExcelFillStyle.Solid;
            ws.Cells[currentRow, 1].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(209, 213, 219));
            ws.Cells[currentRow, 1].Style.Border.BorderAround(ExcelBorderStyle.Thin);
            ws.Row(currentRow).Height = 25;
            currentRow++;

            var brandGroups = group.GroupBy(i => i.Modulo.Marca).OrderBy(b => b.Key?.Nome);
            foreach (var brandGroup in brandGroups)
            {
                var brand = brandGroup.Key;
                var brandItems = brandGroup.OrderBy(i => i.Modulo.Descricao).ToList();

                ws.Cells[currentRow, 1, currentRow + 1, 1].Merge = true; ws.Cells[currentRow, 1].Value = "Foto";
                ws.Cells[currentRow, 2, currentRow + 1, 2].Merge = true; ws.Cells[currentRow, 2].Value = "Modelo";
                ws.Cells[currentRow, 3, currentRow + 1, 3].Merge = true; ws.Cells[currentRow, 3].Value = "Módulo";
                ws.Cells[currentRow, 4, currentRow + 1, 4].Merge = true; ws.Cells[currentRow, 4].Value = "Larg";
                ws.Cells[currentRow, 5, currentRow + 1, 5].Merge = true; ws.Cells[currentRow, 5].Value = "Prof";
                ws.Cells[currentRow, 6, currentRow + 1, 6].Merge = true; ws.Cells[currentRow, 6].Value = "Alt";
                ws.Cells[currentRow, 7, currentRow + 1, 7].Merge = true; ws.Cells[currentRow, 7].Value = "M³";

                ws.Cells[currentRow, fabricStartCol, currentRow, maxCols].Merge = true;
                ws.Cells[currentRow, fabricStartCol].Value = $"Valor Final ({(currency == "BRL" ? "Reais" : typeLabel)})";

                for (int i = 0; i < uniqueFabrics.Count; i++)
                {
                    ws.Cells[currentRow + 1, fabricStartCol + i].Value = uniqueFabrics[i]!.Nome;
                }

                var hRange = ws.Cells[currentRow, 1, currentRow + 1, maxCols];
                hRange.Style.Font.Bold = true;
                hRange.Style.Font.Size = 8;
                hRange.Style.Fill.PatternType = ExcelFillStyle.Solid;
                hRange.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(224, 224, 224));
                hRange.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                hRange.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                foreach (var cell in hRange) { cell.Style.Border.BorderAround(ExcelBorderStyle.Thin); }

                currentRow += 2;

                int brandStartRow = currentRow;
                foreach (var item in brandItems)
                {
                    var mod = item.Modulo;
                    ws.Cells[currentRow, 2].Value = mod.Descricao;
                    ws.Cells[currentRow, 3].Value = item.Quantidade;
                    ws.Cells[currentRow, 4].Value = mod.Largura;
                    ws.Cells[currentRow, 5].Value = mod.Profundidade;
                    ws.Cells[currentRow, 6].Value = mod.Altura;
                    ws.Cells[currentRow, 7].Value = mod.M3;

                    decimal freightUSD = item.ValorFreteRateadoUSD;
                    
                    var modConfig = configs.FirstOrDefault(c => c.IdFornecedor == mod.IdFornecedor) 
                                    ?? configs.FirstOrDefault(c => c.IdFornecedor == null);
                    
                    decimal riskVal = cotacao > 0 ? cotacao : 1;

                    decimal freightDisp = currency == "BRL" ? freightUSD * riskVal : freightUSD;

                    for (int i = 0; i < uniqueFabrics.Count; i++)
                    {
                        var fid = uniqueFabrics[i]!.Id;
                        var mt = mod.ModulosTecidos.FirstOrDefault(x => x.IdTecido == fid && x.FlAtivo);
                        if (mt != null)
                        {
                            decimal basePrice;
                            if (modConfig == null)
                            {
                                basePrice = mt.ValorTecido;
                            }
                            else if (currency == "BRL")
                            {
                                decimal vComissao = mt.ValorTecido * (modConfig.PercentualComissao / 100);
                                decimal vGordura = mt.ValorTecido * (modConfig.PercentualGordura / 100);
                                basePrice = Math.Round(mt.ValorTecido + vComissao + vGordura, 2);
                            }
                            else
                            {
                                if (cotacao <= 0)
                                {
                                    basePrice = 0;
                                }
                                else
                                {
                                    decimal valorBase = mt.ValorTecido / cotacao;
                                    decimal comissao = valorBase * (modConfig.PercentualComissao / 100);
                                    decimal gordura = valorBase * (modConfig.PercentualGordura / 100);
                                    basePrice = Math.Round(valorBase + comissao + gordura, 2);
                                }
                            }
                            ws.Cells[currentRow, fabricStartCol + i].Value = (basePrice + freightDisp) * item.Quantidade;
                        }
                        else
                        {
                            ws.Cells[currentRow, fabricStartCol + i].Value = "-";
                            ws.Cells[currentRow, fabricStartCol + i].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        }
                    }

                    ws.Row(currentRow).Height = 25;
                    currentRow++;
                }

                int brandEndRow = currentRow - 1;
                int totalRows = brandEndRow - brandStartRow + 1;
                if (totalRows == 1)
                {
                    ws.Row(brandStartRow).Height = 85;
                }
                else if (totalRows * 25 < 85)
                {
                    ws.Row(brandStartRow).Height = 85 - (totalRows - 1) * 25;
                }

                ws.Cells[brandStartRow, 1, brandEndRow, 1].Merge = true;
                ws.Cells[brandStartRow, 1].Value = brand?.Nome ?? "Outros";
                ws.Cells[brandStartRow, 1].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                ws.Cells[brandStartRow, 1].Style.VerticalAlignment = ExcelVerticalAlignment.Bottom;
                ws.Cells[brandStartRow, 1].Style.Font.Bold = true;

                if (brand?.Imagem != null)
                {
                    AddCenteredImage(ws, brandStartRow, brandEndRow, brand.Imagem, $"PicPL_{brand.Id}_{brandStartRow}", hasText: true);
                }

                var tableRange = ws.Cells[brandStartRow, 1, brandEndRow, maxCols];
                foreach (var cell in tableRange) 
                { 
                    cell.Style.Border.BorderAround(ExcelBorderStyle.Thin); 
                }
                tableRange.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                tableRange.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                
                // Keep the brand name text at the bottom of column 1 so it doesn't get covered by the image
                ws.Cells[brandStartRow, 1, brandEndRow, 1].Style.VerticalAlignment = ExcelVerticalAlignment.Bottom;

                currentRow++;
            }
        }

        string curSymbol = currency == "BRL" ? "R$ " : "$ ";
        ws.Cells[5, fabricStartCol, currentRow, maxCols].Style.Numberformat.Format = $"\"{curSymbol}\"#,##0.00";
        ws.Cells[5, 3, currentRow, 3].Style.Numberformat.Format = "#,##0";
        ws.Cells[5, 4, currentRow, 7].Style.Numberformat.Format = "#,##0.00";

        for (int i = 0; i < uniqueFabrics.Count; i++) ws.Column(fabricStartCol + i).Width = 12;

        return package.GetAsByteArray();
    }

    internal decimal CalcPrice(decimal valorTecido, string currency, decimal cotacao, Configuracao? config, long? idFornecedor, string? fornecedorName)
    {
        if (config == null) return valorTecido;
        
        decimal percentualComissao = config.PercentualComissao;
        decimal percentualGordura = config.PercentualGordura;

        if (currency == "BRL")
        {
            decimal vComissao = valorTecido * (percentualComissao / 100);
            decimal vGordura = valorTecido * (percentualGordura / 100);
            return Math.Round(valorTecido + vComissao + vGordura, 2);
        }

        if (cotacao == 0) return 0;

        // IDs 3=Ferguile, 4=Livintus. Using ID is more robust than Name if Navigation Property is not loaded.
        bool isFerguile = (idFornecedor == 3 || idFornecedor == 4) || (!string.IsNullOrEmpty(fornecedorName) && 
            (fornecedorName.ToLower().Contains("ferguile") || fornecedorName.ToLower().Contains("livintus")));

        decimal cotacaoRisco = Math.Round(isFerguile ? config.ValorReducaoDolar : (cotacao - config.ValorReducaoDolar), 2);
        
        if (cotacaoRisco <= 0) return 0;

        decimal valorBase = valorTecido / cotacaoRisco;
        decimal comissao = valorBase * (config.PercentualComissao / 100);
        decimal gordura = valorBase * (config.PercentualGordura / 100);

        return Math.Round(valorBase + comissao + gordura, 2);
    }

    private static (int width, int height) GetImageDimensions(byte[] bytes)
    {
        try
        {
            if (bytes.Length > 8 && bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47)
            {
                // PNG
                int width = (bytes[16] << 24) | (bytes[17] << 16) | (bytes[18] << 8) | bytes[19];
                int height = (bytes[20] << 24) | (bytes[21] << 16) | (bytes[22] << 8) | bytes[23];
                return (width, height);
            }
            if (bytes.Length > 4 && bytes[0] == 0xFF && bytes[1] == 0xD8)
            {
                // JPEG
                int i = 2;
                while (i < bytes.Length - 4)
                {
                    if (bytes[i] == 0xFF)
                    {
                        byte marker = bytes[i + 1];
                        if (marker == 0xD9 || marker == 0xDA) // EOI or SOS
                            break;

                        int len = (bytes[i + 2] << 8) + bytes[i + 3];
                        if ((marker >= 0xC0 && marker <= 0xC3) || (marker >= 0xC5 && marker <= 0xC7) || (marker >= 0xC9 && marker <= 0xCB) || (marker >= 0xCD && marker <= 0xCF))
                        {
                            int height = (bytes[i + 4] << 8) + bytes[i + 5];
                            int width = (bytes[i + 6] << 8) + bytes[i + 7];
                            return (width, height);
                        }
                        i += len + 2;
                    }
                    else
                    {
                        i++;
                    }
                }
            }
            if (bytes.Length > 10 && bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46)
            {
                // GIF
                int width = bytes[6] | (bytes[7] << 8);
                int height = bytes[8] | (bytes[9] << 8);
                return (width, height);
            }
            if (bytes.Length > 26 && bytes[0] == 0x42 && bytes[1] == 0x4D)
            {
                // BMP
                int width = bytes[18] | (bytes[19] << 8) | (bytes[20] << 16) | (bytes[21] << 24);
                int height = bytes[22] | (bytes[23] << 8) | (bytes[24] << 16) | (bytes[25] << 24);
                return (width, height);
            }
        }
        catch
        {
            // ignore
        }
        return (100, 100); // Default fallback
    }

    private void AddCenteredImage(ExcelWorksheet ws, int startRow, int endRow, byte[] imageBytes, string pictureName, bool hasText = true)
    {
        try
        {
            using var ms = new MemoryStream(imageBytes);
            var (imgWidth, imgHeight) = GetImageDimensions(imageBytes);
            
            float cellHeightPoints = 0;
            for (int r = startRow; r <= endRow; r++)
            {
                cellHeightPoints += (float)(ws.Row(r).Height > 0 ? ws.Row(r).Height : 15);
            }
            float cellHeightPixels = cellHeightPoints * 1.333f;
            float cellWidthPixels = (float)(ws.Column(1).Width > 0 ? ws.Column(1).Width : 22) * 7.5f;

            float availableWidth = cellWidthPixels - 12; // 6px padding on left/right
            float availableHeight = cellHeightPixels - (hasText ? 24 : 8); // margin for text/padding

            float scale = Math.Min(availableWidth / imgWidth, availableHeight / imgHeight);
            
            int newWidth = (int)(imgWidth * scale);
            int newHeight = (int)(imgHeight * scale);

            int leftOffset = (int)((cellWidthPixels - newWidth) / 2);
            int topOffset = (int)((availableHeight - newHeight) / 2) + 2;

            if (leftOffset < 0) leftOffset = 0;
            if (topOffset < 0) topOffset = 0;

            var pic = ws.Drawings.AddPicture(pictureName, ms);
            pic.SetPosition(startRow - 1, topOffset, 0, leftOffset);
            pic.SetSize(newWidth, newHeight);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error adding image: {ex.Message}");
        }
    }

    public byte[] ExportColinhaToExcel(List<PriceListItemDto> items, string currency, decimal cotacao, List<Configuracao> configs, int validityDays = 30, string? freightType = null)
    {
        using var package = new ExcelPackage();
        
        var estofados = items.Where(i => (i.Modulo.Categoria?.Nome ?? "").ToLower().Contains("estofado")).ToList();
        var poltronas = items.Where(i => (i.Modulo.Categoria?.Nome ?? "").ToLower().Contains("poltrona")).ToList();
        var complementos = items.Except(estofados).Except(poltronas).ToList();
        
        var supplierName = items.FirstOrDefault()?.Modulo.Fornecedor?.Nome ?? "KARAMS";
        
        if (estofados.Any())
        {
            var ws = package.Workbook.Worksheets.Add($"Estofados {supplierName.ToUpper()}");
            BuildColinhaSheet(ws, estofados, currency, cotacao, configs, validityDays, freightType, isModular: true);
        }
        if (poltronas.Any())
        {
            var ws = package.Workbook.Worksheets.Add($"POLTRONA {supplierName.ToUpper()}");
            BuildColinhaSheet(ws, poltronas, currency, cotacao, configs, validityDays, freightType, isModular: false);
        }
        if (complementos.Any())
        {
            var ws = package.Workbook.Worksheets.Add("COMPLEMENTOS");
            BuildColinhaSheet(ws, complementos, currency, cotacao, configs, validityDays, freightType, isModular: false);
        }
        
        return package.GetAsByteArray();
    }

    private void BuildColinhaSheet(ExcelWorksheet ws, List<PriceListItemDto> items, string currency, decimal cotacao, List<Configuracao> configs, int validityDays, string? freightType, bool isModular)
    {
        ws.Cells.Style.Font.Name = "Calibri";
        ws.Cells.Style.Font.Size = 9;

        // Column widths
        ws.Column(1).Width = 35; // Model
        ws.Column(2).Width = 45; // Description
        ws.Column(3).Width = 10; // Larg
        ws.Column(4).Width = 10; // Prof
        ws.Column(5).Width = 10; // Alt
        ws.Column(6).Width = 12; // Display Group
        ws.Column(7).Width = 16; // G0
        ws.Column(8).Width = 12; // Display Group (Discounted)
        ws.Column(9).Width = 16; // G0 (Discounted)

        var brandGroups = items
            .GroupBy(i => i.Modulo.Marca)
            .OrderBy(g => g.Key?.Nome ?? "");

        int currentRow = 1;

        foreach (var brandGroup in brandGroups)
        {
            var brand = brandGroup.Key;
            var brandName = brand?.Nome ?? "Outros";
            var brandItems = brandGroup.OrderBy(i => i.Modulo.Descricao).ToList();

            var details = GetColinhaDetails(brandName);
            string displayGroup = details.DisplayGroup;
            
            int startRow = currentRow;

            // Write header
            ws.Cells[currentRow, 1].Value = brandName.ToUpper();
            ws.Cells[currentRow, 2].Value = "Descrição";
            ws.Cells[currentRow, 3].Value = "Larg";
            ws.Cells[currentRow, 4].Value = "Prof";
            ws.Cells[currentRow, 5].Value = "Altura";
            ws.Cells[currentRow, 6].Value = displayGroup;
            ws.Cells[currentRow, 7].Value = "A PARTIR DE: G0";
            ws.Cells[currentRow, 8].Value = displayGroup;
            ws.Cells[currentRow, 9].Value = "A PARTIR DE: G0";

            var hRange = ws.Cells[currentRow, 1, currentRow, 9];
            hRange.Style.Font.Bold = true;
            hRange.Style.Font.Size = 11;
            hRange.Style.Fill.PatternType = ExcelFillStyle.Solid;
            hRange.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(224, 224, 224));
            hRange.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
            hRange.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
            foreach (var cell in hRange) { cell.Style.Border.BorderAround(ExcelBorderStyle.Thin); }

            ws.Row(currentRow).Height = 25;
            currentRow++;

            int modulesStartRow = currentRow;

            foreach (var item in brandItems)
            {
                var mod = item.Modulo;
                ws.Cells[currentRow, 2].Value = mod.Descricao;
                ws.Cells[currentRow, 3].Value = mod.Largura;
                ws.Cells[currentRow, 4].Value = mod.Profundidade;
                ws.Cells[currentRow, 5].Value = mod.Altura;

                decimal freightUSD = item.ValorFreteRateadoUSD;
                var modConfig = configs.FirstOrDefault(c => c.IdFornecedor == mod.IdFornecedor) 
                                ?? configs.FirstOrDefault(c => c.IdFornecedor == null);
                decimal riskVal = cotacao > 0 ? cotacao : 1;
                decimal freightDisp = currency == "BRL" ? freightUSD * riskVal : freightUSD;

                // Calculate display price
                var mtDisplay = mod.ModulosTecidos.FirstOrDefault(x => x.Tecido != null && x.Tecido.Nome.ToUpper() == displayGroup.ToUpper() && x.FlAtivo)
                                ?? mod.ModulosTecidos.FirstOrDefault(x => x.FlAtivo);

                // Calculate starting price (G0)
                var mtG0 = mod.ModulosTecidos.FirstOrDefault(x => x.Tecido != null && x.Tecido.Nome.ToUpper() == "G0" && x.FlAtivo)
                            ?? mod.ModulosTecidos.FirstOrDefault(x => x.FlAtivo);

                decimal priceDisplay = 0;
                if (mtDisplay != null)
                {
                    priceDisplay = CalcPrice(mtDisplay.ValorTecido, currency, cotacao, modConfig, mod.IdFornecedor, mod.Fornecedor?.Nome);
                }
                
                decimal priceG0 = 0;
                if (mtG0 != null)
                {
                    priceG0 = CalcPrice(mtG0.ValorTecido, currency, cotacao, modConfig, mod.IdFornecedor, mod.Fornecedor?.Nome);
                }

                ws.Cells[currentRow, 6].Value = priceDisplay + freightDisp;
                ws.Cells[currentRow, 7].Value = priceG0 + freightDisp;

                ws.Cells[currentRow, 8].Formula = $"=F{currentRow}*0.85";
                ws.Cells[currentRow, 9].Formula = $"=G{currentRow}*0.85";

                var rRange = ws.Cells[currentRow, 2, currentRow, 9];
                rRange.Style.Font.Size = 10;
                rRange.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                foreach (var cell in rRange) { cell.Style.Border.BorderAround(ExcelBorderStyle.Thin); }

                ws.Cells[currentRow, 3, currentRow, 5].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                ws.Cells[currentRow, 6, currentRow, 9].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                ws.Row(currentRow).Height = isModular ? 22 : 90;
                currentRow++;
            }

            int modulesEndRow = currentRow - 1;

            if (isModular)
            {
                currentRow++; // Spacer row

                // Row 1: Fabric / Finish
                ws.Cells[currentRow, 2, currentRow + 1, 2].Merge = true;
                ws.Cells[currentRow, 2].Value = string.IsNullOrEmpty(details.FabricAndFinish) ? "TECIDO: - / ACAB: -" : details.FabricAndFinish;
                ws.Cells[currentRow, 2].Style.Font.Bold = true;
                ws.Cells[currentRow, 2].Style.Font.Size = 14;
                ws.Cells[currentRow, 2].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                ws.Cells[currentRow, 2].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                ws.Cells[currentRow, 2].Style.Border.BorderAround(ExcelBorderStyle.Thin);
                ws.Cells[currentRow + 1, 2].Style.Border.BorderAround(ExcelBorderStyle.Thin);

                ws.Cells[currentRow, 3, currentRow + 1, 5].Merge = true;
                ws.Cells[currentRow, 3].Value = string.IsNullOrEmpty(details.Measure) ? "MEDIDA TOTAL: -" : details.Measure;
                ws.Cells[currentRow, 3].Style.Font.Bold = true;
                ws.Cells[currentRow, 3].Style.Font.Size = 11;
                ws.Cells[currentRow, 3].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                ws.Cells[currentRow, 3].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                ws.Cells[currentRow, 3].Style.Border.BorderAround(ExcelBorderStyle.Thin);
                ws.Cells[currentRow + 1, 3].Style.Border.BorderAround(ExcelBorderStyle.Thin);

                currentRow += 2;

                // Row 2: Feet / Total Conjunto
                ws.Cells[currentRow, 2, currentRow + 1, 2].Merge = true;
                ws.Cells[currentRow, 2].Value = !string.IsNullOrEmpty(details.Capa) ? details.Capa : (string.IsNullOrEmpty(details.Feet) ? "PÉS: -" : details.Feet);
                ws.Cells[currentRow, 2].Style.Font.Bold = true;
                ws.Cells[currentRow, 2].Style.Font.Size = 14;
                ws.Cells[currentRow, 2].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                ws.Cells[currentRow, 2].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                ws.Cells[currentRow, 2].Style.Border.BorderAround(ExcelBorderStyle.Thin);
                ws.Cells[currentRow + 1, 2].Style.Border.BorderAround(ExcelBorderStyle.Thin);

                ws.Cells[currentRow, 3, currentRow + 1, 5].Merge = true;
                ws.Cells[currentRow, 3].Value = "TOTAL CONJUNTO:";
                ws.Cells[currentRow, 3].Style.Font.Bold = true;
                ws.Cells[currentRow, 3].Style.Font.Size = 14;
                ws.Cells[currentRow, 3].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                ws.Cells[currentRow, 3].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                ws.Cells[currentRow, 3].Style.Border.BorderAround(ExcelBorderStyle.Thin);
                ws.Cells[currentRow + 1, 3].Style.Border.BorderAround(ExcelBorderStyle.Thin);

                // Sum Formulas
                for (int col = 6; col <= 9; col++)
                {
                    ws.Cells[currentRow, col, currentRow + 1, col].Merge = true;
                    string colLetter = col == 6 ? "F" : col == 7 ? "G" : col == 8 ? "H" : "I";
                    ws.Cells[currentRow, col].Formula = $"=SUM({colLetter}{modulesStartRow}:{colLetter}{modulesEndRow})";
                    ws.Cells[currentRow, col].Style.Font.Bold = true;
                    ws.Cells[currentRow, col].Style.Font.Size = 14;
                    ws.Cells[currentRow, col].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    ws.Cells[currentRow, col].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    ws.Cells[currentRow, col].Style.Border.BorderAround(ExcelBorderStyle.Thin);
                    ws.Cells[currentRow + 1, col].Style.Border.BorderAround(ExcelBorderStyle.Thin);
                }

                currentRow += 2;
            }

            int endBlockRow = currentRow - 1;

            // Write brand name in the header row A{startRow}
            ws.Cells[startRow, 1].Value = brandName.ToUpper();
            ws.Cells[startRow, 1].Style.Font.Bold = true;
            ws.Cells[startRow, 1].Style.Font.Size = 10;
            ws.Cells[startRow, 1].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
            ws.Cells[startRow, 1].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
            ws.Cells[startRow, 1].Style.Border.BorderAround(ExcelBorderStyle.Thin);

            // Merge Column A for the image starting from row below header to end of block
            if (endBlockRow >= startRow + 1)
            {
                ws.Cells[startRow + 1, 1, endBlockRow, 1].Merge = true;
                for (int r = startRow + 1; r <= endBlockRow; r++)
                {
                    ws.Cells[r, 1].Style.Border.BorderAround(ExcelBorderStyle.Thin);
                }
            }

            if (brand?.Imagem != null && endBlockRow >= startRow + 1)
            {
                AddCenteredImageColinha(ws, startRow + 1, endBlockRow, brand.Imagem, $"PicC_{brand.Id}_{startRow}");
            }

            // Write notes
            if (isModular && details.Notes.Any())
            {
                foreach (var note in details.Notes)
                {
                    ws.Cells[currentRow, 1].Value = note;
                    ws.Cells[currentRow, 1].Style.Font.Bold = true;
                    ws.Cells[currentRow, 1].Style.Font.Size = 10;
                    currentRow++;
                }
            }

            currentRow++;
        }

        string curSymbol = currency == "BRL" ? "R$ " : "$ ";
        ws.Cells[1, 6, currentRow, 9].Style.Numberformat.Format = $"\"{curSymbol}\"#,##0.00";
        ws.Cells[1, 3, currentRow, 5].Style.Numberformat.Format = "#,##0.00";
    }

    private void AddCenteredImageColinha(ExcelWorksheet ws, int startRow, int endRow, byte[] imageBytes, string pictureName)
    {
        try
        {
            using var ms = new MemoryStream(imageBytes);
            var (imgWidth, imgHeight) = GetImageDimensions(imageBytes);
            
            float cellHeightPoints = 0;
            for (int r = startRow; r <= endRow; r++)
            {
                cellHeightPoints += (float)(ws.Row(r).Height > 0 ? ws.Row(r).Height : 15);
            }
            float cellHeightPixels = cellHeightPoints * 1.333f;
            float cellWidthPixels = (float)(ws.Column(1).Width > 0 ? ws.Column(1).Width : 35) * 7.5f;

            float availableWidth = cellWidthPixels - 12;
            float availableHeight = cellHeightPixels - 24;

            float scale = Math.Min(availableWidth / imgWidth, availableHeight / imgHeight);
            
            int newWidth = (int)(imgWidth * scale);
            int newHeight = (int)(imgHeight * scale);

            int leftOffset = (int)((cellWidthPixels - newWidth) / 2);
            int topOffset = (int)((availableHeight - newHeight) / 2) + 2;

            if (leftOffset < 0) leftOffset = 0;
            if (topOffset < 0) topOffset = 0;

            var pic = ws.Drawings.AddPicture(pictureName, ms);
            pic.SetPosition(startRow - 1, topOffset, 0, leftOffset);
            pic.SetSize(newWidth, newHeight);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error adding image in Colinha: {ex.Message}");
        }
    }

    public class ColinhaModelDetails
    {
        public string ModelName { get; set; } = "";
        public string DisplayGroup { get; set; } = "G1";
        public string FabricAndFinish { get; set; } = "";
        public string Measure { get; set; } = "";
        public string Feet { get; set; } = "";
        public string Capa { get; set; } = "";
        public List<string> Notes { get; set; } = new();
    }

    private static readonly Dictionary<string, ColinhaModelDetails> ColinhaDetails = new(StringComparer.OrdinalIgnoreCase)
    {
        { "ESTOFADO ANKUR", new ColinhaModelDetails 
            { 
                ModelName = "ESTOFADO ANKUR", 
                DisplayGroup = "G5", 
                FabricAndFinish = "TECIDO: SK 5129 / ACAB: NOGUEIRA", 
                Measure = "MEDIDA TOTAL: 405 x 188", 
                Feet = "PÉS: CAFÉ",
                Notes = new() { "OBS: PÉ EM METAL PINTADO", "OBS: MESA REVESTIDA EM LÂMINA NATURAL" } 
            } 
        },
        { "ESTOFADO LASSO", new ColinhaModelDetails 
            { 
                ModelName = "ESTOFADO LASSO", 
                DisplayGroup = "G5", 
                FabricAndFinish = "TECIDO: SK1390 / BASE: MEL", 
                Measure = "MEDIDA TOTAL: 480 X 175" 
            } 
        },
        { "ESTOFADO MIWA", new ColinhaModelDetails 
            { 
                ModelName = "ESTOFADO MIWA", 
                DisplayGroup = "G1", 
                FabricAndFinish = "TECIDO: SK1397 /  ACAB:CARVALHO", 
                Measure = "MEDIDA TOTAL: 3,00",
                Capa = "CAPA: SK3195"
            } 
        },
        { "ESTOFADO MOA", new ColinhaModelDetails 
            { 
                ModelName = "ESTOFADO MOA", 
                DisplayGroup = "G1", 
                FabricAndFinish = "TECIDO: SK4184 / ACAB: MEL", 
                Measure = "MEDIDA TOTAL: 2,90" 
            } 
        },
        { "ESTOFADO NINHO", new ColinhaModelDetails 
            { 
                ModelName = "ESTOFADO NINHO", 
                DisplayGroup = "G1", 
                FabricAndFinish = "TECIDO: SK5111 / ACAB: IMBUIA", 
                Measure = "MEDIDA TOTAL: 3,20" 
            } 
        },
        { "ESTOFADO TIBAGI", new ColinhaModelDetails 
            { 
                ModelName = "ESTOFADO TIBAGI", 
                DisplayGroup = "G1", 
                FabricAndFinish = "TECIDO: SK5134 / ACAB: IMBUIA", 
                Measure = "MEDIDA TOTAL: 450" 
            } 
        },
        { "ESTOFADO ZENITH", new ColinhaModelDetails 
            { 
                ModelName = "ESTOFADO ZENITH", 
                DisplayGroup = "G5", 
                FabricAndFinish = "TECIDO: SK 6058", 
                Measure = "MEDIDA TOTAL: 3,34",
                Notes = new() { "OBS: DISPONÍVEL APENAS COM AUTOMAÇÃO", "OBS: PROFUNDIDADE ABERTA: 1,56M" } 
            } 
        },
        { "POLTRONA ALENTO", new ColinhaModelDetails { ModelName = "POLTRONA ALENTO", DisplayGroup = "G5" } },
        { "POLTRONA DENGO", new ColinhaModelDetails { ModelName = "POLTRONA DENGO", DisplayGroup = "G1" } },
        { "POLTRONA KENJI", new ColinhaModelDetails { ModelName = "POLTRONA KENJI", DisplayGroup = "G1" } },
        { "POLTRONA MUSH", new ColinhaModelDetails { ModelName = "POLTRONA MUSH", DisplayGroup = "G1" } },
        { "POLTRONA SEMENTE", new ColinhaModelDetails { ModelName = "POLTRONA SEMENTE", DisplayGroup = "G1" } },
        { "BANCO TORUS", new ColinhaModelDetails { ModelName = "BANCO TORUS", DisplayGroup = "G1" } },
        { "CAMA KAORI", new ColinhaModelDetails { ModelName = "CAMA KAORI", DisplayGroup = "G5" } },
        { "PUFF TOAD", new ColinhaModelDetails { ModelName = "PUFF TOAD", DisplayGroup = "G1" } }
    };

    private static ColinhaModelDetails GetColinhaDetails(string brandName)
    {
        var cleaned = brandName.ToUpper()
            .Replace("ESTOFADO ", "")
            .Replace("POLTRONA ", "")
            .Replace("CAMA ", "")
            .Replace("PUFF ", "")
            .Replace("BANCO ", "")
            .Replace("MESA ", "")
            .Replace("CADEIRA ", "")
            .Replace("CHAISE ", "")
            .Replace("Õ", "O")
            .Trim();

        foreach (var kvp in ColinhaDetails)
        {
            var keyClean = kvp.Key.ToUpper()
                .Replace("ESTOFADO ", "")
                .Replace("POLTRONA ", "")
                .Replace("CAMA ", "")
                .Replace("PUFF ", "")
                .Replace("BANCO ", "")
                .Replace("MESA ", "")
                .Replace("CADEIRA ", "")
                .Replace("CHAISE ", "")
                .Replace("Õ", "O")
                .Trim();

            if (cleaned.Contains(keyClean) || keyClean.Contains(cleaned) || 
                (cleaned == "ONKUR" && keyClean == "ANKUR") ||
                (cleaned == "ANKUR" && keyClean == "ONKUR") ||
                (cleaned == "MOA" && keyClean == "MOA") ||
                (cleaned == "MÕA" && keyClean == "MOA"))
            {
                return kvp.Value;
            }
        }

        return new ColinhaModelDetails { ModelName = brandName, DisplayGroup = "G1" };
    }
}
