using OfficeOpenXml;
using OfficeOpenXml.Style;
using Pi.Api.Models;
using System.Drawing;

namespace Pi.Api.Services;

public class ModuloExportService
{
    public byte[] ExportToExcel(List<Modulo> modules, string currency, decimal cotacao, Configuracao? config)
    {
        using var package = new ExcelPackage();
        var ws = package.Workbook.Worksheets.Add("Relatório de Módulos");

        string title = $"Relatório de Módulos - {(currency == "BRL" ? "Valores em Reais (R$)" : "Valores em Dólar (EXW)")}";
        
        // ═══════════════ HEADER ═══════════════
        ws.Cells["A1:Z1"].Merge = true;
        ws.Cells["A1"].Value = title;
        ws.Cells["A1"].Style.Font.Bold = true;
        ws.Cells["A1"].Style.Font.Size = 14;

        ws.Cells["A2"].Value = "Fecha de Emisión:";
        ws.Cells["B2"].Value = DateTime.Now.ToString("dd/MM/yyyy");
        ws.Cells["A3"].Value = "* Esta lista de precios es válida por 30 días a partir de la fecha de emisión.";
        ws.Cells["A3"].Style.Font.Color.SetColor(Color.Red);
        ws.Cells["A3"].Style.Font.Bold = true;

        // ═══════════════ DATA PROCESSING ═══════════════
        // Get all unique fabrics
        var uniqueFabrics = modules
            .SelectMany(m => m.ModulosTecidos)
            .Select(mt => mt.Tecido)
            .Where(t => t != null)
            .GroupBy(t => t!.Id)
            .Select(g => g.First())
            .OrderBy(t => t!.Nome)
            .ToList();

        // ═══════════════ TABLE HEADERS ═══════════════
        int startRow = 5;
        ws.Cells[startRow, 1, startRow + 1, 1].Merge = true; ws.Cells[startRow, 1].Value = "FOTO";
        ws.Cells[startRow, 2, startRow + 1, 2].Merge = true; ws.Cells[startRow, 2].Value = "MODELO";
        ws.Cells[startRow, 3, startRow + 1, 3].Merge = true; ws.Cells[startRow, 3].Value = "MÓDULO";
        ws.Cells[startRow, 4, startRow + 1, 4].Merge = true; ws.Cells[startRow, 4].Value = "LARG";
        ws.Cells[startRow, 5, startRow + 1, 5].Merge = true; ws.Cells[startRow, 5].Value = "PROF";
        ws.Cells[startRow, 6, startRow + 1, 6].Merge = true; ws.Cells[startRow, 6].Value = "ALT";
        ws.Cells[startRow, 7, startRow + 1, 7].Merge = true; ws.Cells[startRow, 7].Value = "M³";

        int fabricStartCol = 8;
        ws.Cells[startRow, fabricStartCol, startRow, fabricStartCol + uniqueFabrics.Count - 1].Merge = true;
        ws.Cells[startRow, fabricStartCol].Value = $"VALOR ({(currency == "BRL" ? "Reais" : "EXW")})";
        ws.Cells[startRow, fabricStartCol].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

        for (int i = 0; i < uniqueFabrics.Count; i++)
        {
            ws.Cells[startRow + 1, fabricStartCol + i].Value = uniqueFabrics[i]!.Nome;
        }

        var headerRange = ws.Cells[startRow, 1, startRow + 1, fabricStartCol + uniqueFabrics.Count - 1];
        headerRange.Style.Font.Bold = true;
        headerRange.Style.Fill.PatternType = ExcelFillStyle.Solid;
        headerRange.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(224, 224, 224));
        headerRange.Style.Border.BorderAround(ExcelBorderStyle.Thin);
        headerRange.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
        headerRange.Style.VerticalAlignment = ExcelVerticalAlignment.Center;

        // ═══════════════ CONTENT ═══════════════
        int currentRow = startRow + 2;
        var groups = modules
            .GroupBy(m => new { 
                Forn = m.Fornecedor?.Nome ?? "N/A", 
                Cat = m.Categoria?.Nome ?? "N/A" 
            })
            .OrderBy(g => g.Key.Forn).ThenBy(g => g.Key.Cat);

        foreach (var group in groups)
        {
            // Group Title Row
            ws.Cells[currentRow, 1, currentRow, fabricStartCol + uniqueFabrics.Count - 1].Merge = true;
            ws.Cells[currentRow, 1].Value = $"{group.Key.Forn} - {group.Key.Cat}";
            ws.Cells[currentRow, 1].Style.Font.Bold = true;
            ws.Cells[currentRow, 1].Style.Fill.PatternType = ExcelFillStyle.Solid;
            ws.Cells[currentRow, 1].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(209, 213, 222));
            ws.Cells[currentRow, 1].Style.Border.BorderAround(ExcelBorderStyle.Thin);
            currentRow++;

            var brandGroups = group.GroupBy(m => m.Marca).OrderBy(b => b.Key?.Nome);
            foreach (var brandGroup in brandGroups)
            {
                int brandStartRow = currentRow;
                var brand = brandGroup.Key;

                foreach (var mod in brandGroup.OrderBy(m => m.Descricao))
                {
                    ws.Cells[currentRow, 3].Value = mod.Descricao;
                    ws.Cells[currentRow, 4].Value = mod.Largura;
                    ws.Cells[currentRow, 5].Value = mod.Profundidade;
                    ws.Cells[currentRow, 6].Value = mod.Altura;
                    ws.Cells[currentRow, 7].Value = mod.M3;

                    for (int i = 0; i < uniqueFabrics.Count; i++)
                    {
                        var fid = uniqueFabrics[i]!.Id;
                        var mt = mod.ModulosTecidos.FirstOrDefault(x => x.IdTecido == fid);
                        if (mt != null)
                        {
                            decimal val = CalcPrice(mt.ValorTecido, currency, cotacao, config, mod.Fornecedor?.Nome);
                            ws.Cells[currentRow, fabricStartCol + i].Value = val;
                        }
                        else
                        {
                            ws.Cells[currentRow, fabricStartCol + i].Value = "-";
                        }
                    }

                    ws.Row(currentRow).Height = 20;
                    currentRow++;
                }

                // Merge Brand Name & Photo
                ws.Cells[brandStartRow, 2, currentRow - 1, 2].Merge = true;
                ws.Cells[brandStartRow, 2].Value = brand?.Nome ?? "Outros";
                ws.Cells[brandStartRow, 2].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                ws.Cells[brandStartRow, 2].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                ws.Cells[brandStartRow, 2].Style.Font.Bold = true;

                ws.Cells[brandStartRow, 1, currentRow - 1, 1].Merge = true;
                if (brand?.Imagem != null)
                {
                    using var ms = new MemoryStream(brand.Imagem);
                    var pic = ws.Drawings.AddPicture($"PicM_{brand.Id}", ms);
                    pic.SetPosition(brandStartRow - 1, 5, 0, 5);
                    pic.SetSize(60, 60);
                }
                if (currentRow - brandStartRow == 1) ws.Row(brandStartRow).Height = 65;

                // Borders for the whole brand block
                var brandBlock = ws.Cells[brandStartRow, 1, currentRow - 1, fabricStartCol + uniqueFabrics.Count - 1];
                brandBlock.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                brandBlock.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                brandBlock.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                brandBlock.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                
                // Internal borders
                for (int r = brandStartRow; r < currentRow; r++)
                {
                    for (int c = 3; c < fabricStartCol + uniqueFabrics.Count; c++)
                    {
                        ws.Cells[r, c].Style.Border.BorderAround(ExcelBorderStyle.Thin);
                    }
                }
            }
        }

        ws.Cells[startRow + 2, fabricStartCol, currentRow - 1, fabricStartCol + uniqueFabrics.Count - 1].Style.Numberformat.Format = "_-$* #,##0.00_-";
        ws.Cells[startRow + 2, 4, currentRow - 1, 7].Style.Numberformat.Format = "#,##0.00";

        ws.Column(1).Width = 10;
        ws.Column(2).Width = 15;
        ws.Column(3).Width = 30;
        for (int i = 0; i < uniqueFabrics.Count; i++)
        {
            ws.Column(fabricStartCol + i).Width = 14;
        }

        return package.GetAsByteArray();
    }

    private decimal CalcPrice(decimal valorTecido, string currency, decimal cotacao, Configuracao? config, string? fornecedorName)
    {
        if (currency == "BRL") return valorTecido;
        if (config == null || cotacao <= 0) return 0;

        string sName = (fornecedorName ?? "").ToLower();
        bool isFerguile = sName.Contains("ferguile") || sName.Contains("livintus");

        decimal cotacaoRisco = isFerguile ? config.ValorReducaoDolar : (cotacao - config.ValorReducaoDolar);
        if (cotacaoRisco <= 0) return 0;

        decimal valorBase = valorTecido / cotacaoRisco;
        decimal comissao = valorBase * (config.PercentualComissao / 100);
        decimal gordura = valorBase * (config.PercentualGordura / 100);

        return Math.Round(valorBase + comissao + gordura, 2);
    }
}
