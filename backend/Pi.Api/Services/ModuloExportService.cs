using OfficeOpenXml;
using OfficeOpenXml.Style;
using Pi.Api.Models;
using System.Drawing;
using System.Text.RegularExpressions;

namespace Pi.Api.Services;

public class ModuloExportService
{
    public byte[] ExportToExcel(List<Modulo> modules, string currency, decimal cotacao, List<Configuracao> configs)
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

        ws.Cells["A2"].Value = "Fecha de Emisión:";
        ws.Cells["A2"].Style.Font.Bold = true;
        ws.Cells["B2"].Value = DateTime.Now.ToString("dd/MM/yyyy");
        
        ws.Cells["F1:J1"].Merge = true;
        ws.Cells["F1"].Value = "* Esta lista de precios es válida por 30 días a partir de la fecha de emisión.";
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

        int fabricStartCol = 7;
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
                ws.Cells[currentRow, 1, currentRow + 1, 1].Merge = true; ws.Cells[currentRow, 1].Value = "Modelo";
                ws.Cells[currentRow, 2, currentRow + 1, 2].Merge = true; ws.Cells[currentRow, 2].Value = "Módulo";
                ws.Cells[currentRow, 3, currentRow + 1, 3].Merge = true; ws.Cells[currentRow, 3].Value = "Larg";
                ws.Cells[currentRow, 4, currentRow + 1, 4].Merge = true; ws.Cells[currentRow, 4].Value = "Prof";
                ws.Cells[currentRow, 5, currentRow + 1, 5].Merge = true; ws.Cells[currentRow, 5].Value = "Alt";
                ws.Cells[currentRow, 6, currentRow + 1, 6].Merge = true; ws.Cells[currentRow, 6].Value = "M³";

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
                    ws.Cells[currentRow, 3].Value = mod.Largura;
                    ws.Cells[currentRow, 4].Value = mod.Profundidade;
                    ws.Cells[currentRow, 5].Value = mod.Altura;
                    ws.Cells[currentRow, 6].Value = mod.M3;
                    for (int i = 0; i < uniqueFabrics.Count; i++)
                    {
                        var fid = uniqueFabrics[i]!.Id;
                        var mt = mod.ModulosTecidos.FirstOrDefault(x => x.IdTecido == fid);
                        if (mt != null)
                        {
                            // Find best config (Supplier-specific or Global)
                            var modConfig = configs.FirstOrDefault(c => c.IdFornecedor == mod.IdFornecedor) 
                                            ?? configs.FirstOrDefault(c => c.IdFornecedor == null);

                            decimal val = CalcPrice(mt.ValorTecido, currency, cotacao, modConfig, mod.Fornecedor?.Nome);
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
                ws.Cells[brandStartRow, 1, brandEndRow, 1].Merge = true;
                ws.Cells[brandStartRow, 1].Value = brand?.Nome ?? "Outros";
                ws.Cells[brandStartRow, 1].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                ws.Cells[brandStartRow, 1].Style.VerticalAlignment = ExcelVerticalAlignment.Bottom;
                ws.Cells[brandStartRow, 1].Style.Font.Bold = true;

                if (brand?.Imagem != null)
                {
                    using var ms = new MemoryStream(brand.Imagem);
                    var pic = ws.Drawings.AddPicture($"PicB_{brand.Id}_{brandStartRow}", ms);
                    pic.SetPosition(brandStartRow - 1, 5, 0, 5); 
                    pic.SetSize(70, 70); 
                    
                    if (brandEndRow == brandStartRow) ws.Row(brandStartRow).Height = 85;
                }

                // Final Borders and formatting for the brand table
                var tableRange = ws.Cells[brandStartRow, 1, brandEndRow, maxCols];
                foreach (var cell in tableRange) { cell.Style.Border.BorderAround(ExcelBorderStyle.Thin); }
                ws.Cells[brandStartRow, 2, brandEndRow, 2].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                ws.Cells[brandStartRow, 3, brandEndRow, 6].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                ws.Cells[brandStartRow, fabricStartCol, brandEndRow, maxCols].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                currentRow++; // Gap
            }
        }

        // Apply global number formats
        string curSymbol = currency == "BRL" ? "R$ " : "$ ";
        ws.Cells[5, fabricStartCol, currentRow, maxCols].Style.Numberformat.Format = $"\"{curSymbol}\"#,##0.00";
        ws.Cells[5, 3, currentRow, 6].Style.Numberformat.Format = "#,##0.00";

        // Column widths
        ws.Column(1).Width = 22; // Modelo
        ws.Column(2).Width = 35; // Módulo
        ws.Column(3).Width = 7;
        ws.Column(4).Width = 7;
        ws.Column(5).Width = 7;
        ws.Column(6).Width = 7;
        for (int i = 0; i < uniqueFabrics.Count; i++) ws.Column(fabricStartCol + i).Width = 12;

        return package.GetAsByteArray();
    }

    private decimal CalcPrice(decimal valorTecido, string currency, decimal cotacao, Configuracao? config, string? fornecedorName)
    {
        if (currency == "BRL") return valorTecido;
        if (config == null || cotacao == 0) return 0;

        bool isFerguile = !string.IsNullOrEmpty(fornecedorName) && 
            (fornecedorName.ToLower().Contains("ferguile") || fornecedorName.ToLower().Contains("livintus"));

        decimal cotacaoRisco = isFerguile ? config.ValorReducaoDolar : (cotacao - config.ValorReducaoDolar);
        if (cotacaoRisco <= 0) return 0;

        decimal valorBase = valorTecido / cotacaoRisco;
        decimal comissao = valorBase * (config.PercentualComissao / 100);
        decimal gordura = valorBase * (config.PercentualGordura / 100);

        return Math.Round(valorBase + comissao + gordura, 2);
    }
}
