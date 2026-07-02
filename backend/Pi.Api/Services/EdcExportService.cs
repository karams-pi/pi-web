using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Drawing;
using System.IO;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Models.Edc;

namespace Pi.Api.Services;

public class EdcExportService
{
    private readonly Data.AppDbContext _context;

    public EdcExportService(Data.AppDbContext context)
    {
        _context = context;
    }

    private string NormalizeKey(string s)
    {
        if (string.IsNullOrEmpty(s)) return "";
        var normalized = new string(s.ToLower().Where(char.IsLetterOrDigit).ToArray());
        // Map common synonyms
        if (normalized.Contains("siscomex")) return "siscomex";
        if (normalized.Contains("liberacao") || normalized.Contains("bl")) return "liberacao";
        if (normalized.Contains("thc") || normalized.Contains("capatazia")) return "thc";
        if (normalized.Contains("isps")) return "isps";
        if (normalized.Contains("damage") || normalized.Contains("protection")) return "damage";
        if (normalized.Contains("desconsolidacao")) return "desconsolidao";
        if (normalized.Contains("devolucao") || normalized.Contains("container")) return "devolucao";
        if (normalized.Contains("trs")) return "trs";
        if (normalized.Contains("afrmm")) return "afrmm";
        if (normalized.Contains("armazenagem")) return "armazenagem";
        if (normalized.Contains("scanner")) return "scanner";
        if (normalized.Contains("handling")) return "handling";
        if (normalized.Contains("pesagem")) return "pesagem";
        if (normalized.Contains("parceiro") || normalized.Contains("paranagua")) return "parceiro";
        if (normalized.Contains("rodoviario") || normalized.Contains("freteterrestr")) return "rodoviario";
        if (normalized.Contains("desembaraco") || normalized.Contains("despachante")) return "desembaraco";
        if (normalized.Contains("frete")) return "frete";
        return normalized;
    }

    public byte[] ExportToExcel(SimulacaoEdc simulacao)
    {
        using var package = new ExcelPackage();
        
        // Define fixed list of expenses in columns E to U of Rateio/Nacionalizacao sheets
        var expenseCols = new[]
        {
            new { Key = "frete", Col = "E", Title = "FRETE" },
            new { Key = "siscomex", Col = "F", Title = "TAXA SISCOMEX" },
            new { Key = "liberacao", Col = "G", Title = "LIBERAÇÃO DE B/L" },
            new { Key = "thc", Col = "H", Title = "T.H.C|  CAPATAZIA" },
            new { Key = "isps", Col = "I", Title = "ISPS" },
            new { Key = "damage", Col = "J", Title = "DAMAGE PROTECTION" },
            new { Key = "desconsolidao", Col = "K", Title = "DESCONSOLIDAÇÃO" },
            new { Key = "devolucao", Col = "L", Title = "DEVOLUÇÃO DE CONTAINER" },
            new { Key = "trs", Col = "M", Title = "TRS" },
            new { Key = "afrmm", Col = "N", Title = "AFRMM" },
            new { Key = "armazenagem", Col = "O", Title = "ARMAZENAGEM TCP" },
            new { Key = "scanner", Col = "P", Title = "SCANNER TCP" },
            new { Key = "handling", Col = "Q", Title = "HANDLING - TCP" },
            new { Key = "pesagem", Col = "R", Title = "PESAGEM TCP" },
            new { Key = "parceiro", Col = "S", Title = "TAXA DO PARCEIRO - PARANAGUÁ" },
            new { Key = "rodoviario", Col = "T", Title = "FRETE RODOVIÁRIO" },
            new { Key = "desembaraco", Col = "U", Title = "DESEMBARAÇO ADUANEIRO" }
        };

        var lastRow = 5 + (simulacao.Itens?.Count ?? 0);

        // 1. Sheet: Resumo 100%
        BuildResumoSheet(package, simulacao, expenseCols, lastRow);

        // 2. Sheet: LISTA DE COMPRAS
        BuildListaComprasSheet(package, simulacao, lastRow);

        // 3. Sheet: Est. Cust. Naci.
        BuildEstCustNaciSheet(package, simulacao, expenseCols, lastRow);

        // 4. Sheet: Rateio Custos Fixos
        BuildRateioCustosFixosSheet(package, simulacao, expenseCols, lastRow);

        return package.GetAsByteArray();
    }

    private void BuildResumoSheet(ExcelPackage package, SimulacaoEdc simulacao, dynamic expenseCols, int lastRow)
    {
        var ws = package.Workbook.Worksheets.Add("Resumo 100%");
        ws.Cells.Style.Font.Name = "Segoe UI";
        ws.Cells.Style.Font.Size = 10;
        ws.View.ShowGridLines = true;

        // Title and Logo
        string logoPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Assets", "logo-seawise.png");
        if (!File.Exists(logoPath))
        {
            logoPath = Path.Combine(Directory.GetCurrentDirectory(), "Assets", "logo-seawise.png");
        }

        if (File.Exists(logoPath))
        {
            try
            {
                var fileInfo = new FileInfo(logoPath);
                var picture = ws.Drawings.AddPicture("LogoSeawise", fileInfo);
                picture.SetPosition(2, 0, 1, 0); // Row 3, Column B (B3)
                picture.SetSize(110, 45); // Width 110px, Height 45px
                
                // Move title to column D to prevent overlap
                ws.Cells["D3"].Value = "Estimativa de Custo 100%";
                ws.Cells["D3"].Style.Font.Size = 20;
                ws.Cells["D3"].Style.Font.Bold = true;
                ws.Cells["D3"].Style.Font.Color.SetColor(Color.FromArgb(31, 78, 120)); // Navy #1F4E78
            }
            catch
            {
                // Fallback if picture addition fails (e.g. system drawing driver issues)
                ws.Cells["B3"].Value = "Estimativa de Custo 100%";
                ws.Cells["B3"].Style.Font.Size = 20;
                ws.Cells["B3"].Style.Font.Bold = true;
                ws.Cells["B3"].Style.Font.Color.SetColor(Color.FromArgb(31, 78, 120)); // Navy #1F4E78
            }
        }
        else
        {
            ws.Cells["B3"].Value = "Estimativa de Custo 100%";
            ws.Cells["B3"].Style.Font.Size = 20;
            ws.Cells["B3"].Style.Font.Bold = true;
            ws.Cells["B3"].Style.Font.Color.SetColor(Color.FromArgb(31, 78, 120)); // Navy #1F4E78
        }

        // General Info
        ws.Cells["C8"].Value = $"REGIME TRIBUTÁRIO: {(simulacao.Importador?.RegimeTributario ?? "SIMPLES NACIONAL").ToUpper()}";
        ws.Cells["C8"].Style.Font.Bold = true;
        ws.Cells["E8"].Value = "USO: REVENDA";
        ws.Cells["E8"].Style.Font.Bold = true;
        
        decimal icmsPadrao = 0.18m;
        var firstNcm = simulacao.Itens?.FirstOrDefault()?.Produto?.Ncm;
        if (firstNcm != null && firstNcm.AliquotaIcmsPadrao > 0m)
        {
            icmsPadrao = firstNcm.AliquotaIcmsPadrao;
        }
        else if (simulacao.Importador?.AliquotaIcmsPadrao > 0m)
        {
            icmsPadrao = simulacao.Importador.AliquotaIcmsPadrao;
        }
        ws.Cells["G8"].Value = $"CONSIDERAR ICMS {(icmsPadrao * 100):N0}%";
        ws.Cells["G8"].Style.Font.Bold = true;

        ws.Cells["C9"].Value = $"PRODUTO: {(simulacao.Itens?.FirstOrDefault()?.Produto?.Descricao ?? "AMORTECEDORES").ToUpper()}";
        ws.Cells["C9"].Style.Font.Bold = true;
        ws.Cells["E9"].Value = $"PORTO SAÍDA: {(simulacao.PortoOrigem?.Nome ?? "SHANGHAI").ToUpper()}";
        ws.Cells["E9"].Style.Font.Bold = true;
        ws.Cells["G9"].Value = DateTime.Now;
        ws.Cells["G9"].Style.Numberformat.Format = "dd/MM/yyyy";
        ws.Cells["G9"].Style.Font.Bold = true;

        ws.Cells["C10"].Value = $"FRETE: {(simulacao.TipoFrete ?? "1x40").ToUpper()}";
        ws.Cells["C10"].Style.Font.Bold = true;
        ws.Cells["E10"].Value = $"PORTO ENTRADA: {(simulacao.PortoDestino?.Nome ?? "PARANAGUÁ").ToUpper()}";
        ws.Cells["E10"].Style.Font.Bold = true;
        ws.Cells["G10"].Value = "SIMULAÇÃO 100%";
        ws.Cells["G10"].Style.Font.Bold = true;

        // Calculation Base References
        ws.Cells["B12"].Value = "REFERÊNCIA CÁLCULO BASE ";
        ws.Cells["B12"].Style.Font.Bold = true;
        ws.Cells["B12"].Style.Fill.PatternType = ExcelFillStyle.Solid;
        ws.Cells["B12"].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(242, 242, 242));
        ws.Cells["B12"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
        
        ws.Cells["C12"].Value = "R$/USD:";
        ws.Cells["C12"].Style.Font.Bold = true;
        ws.Cells["C12"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

        ws.Cells["D12"].Value = simulacao.CotacaoDolar;
        ws.Cells["D12"].Style.Font.Bold = true;
        ws.Cells["D12"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
        ws.Cells["D12"].Style.Numberformat.Format = "#,##0.00";

        ws.Cells["E12"].Value = "NCM:";
        ws.Cells["E12"].Style.Font.Bold = true;
        ws.Cells["E12"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

        ws.Cells["F12"].Value = simulacao.Itens?.FirstOrDefault()?.Produto?.Ncm?.Codigo ?? "";
        ws.Cells["F12"].Style.Font.Bold = true;
        ws.Cells["F12"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

        // Section header
        ws.Cells["B13"].Value = "VALORES ADUANEIROS";
        ws.Cells["B13"].Style.Font.Bold = true;
        ws.Cells["B13"].Style.Font.Color.SetColor(Color.FromArgb(31, 78, 120));

        // Column Headers
        string[] headers = { "DISCRIMINAÇÃO", "", "UNIDADE", "PREÇO USD", "PREÇO TOTAL USD", "R$" };
        for (int i = 0; i < headers.Length; i++)
        {
            if (string.IsNullOrEmpty(headers[i])) continue;
            var cell = ws.Cells[14, i + 2];
            cell.Value = headers[i];
            cell.Style.Font.Bold = true;
            cell.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
            cell.Style.Fill.PatternType = ExcelFillStyle.Solid;
            cell.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(180, 198, 231)); // Soft Blue #B4C6E7
            cell.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
        }

        // Row 15: Products Sum
        ws.Cells["B15"].Value = "PRODUTO";
        ws.Cells["D15"].Formula = "='LISTA DE COMPRAS'!J4"; // Total quantity
        ws.Cells["E15"].Formula = "=IF(D15>0,F15/D15,0)"; // Unit price
        ws.Cells["E15"].Style.Numberformat.Format = "$ #,##0.00";
        ws.Cells["F15"].Formula = "='LISTA DE COMPRAS'!M4"; // Total FOB USD
        ws.Cells["G15"].Formula = "=F15*D12";
        ws.Cells["D15:G15"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

        // Row 16: Total FOB
        ws.Cells["B16"].Value = "TOTAL FOB";
        ws.Cells["B16"].Style.Font.Bold = true;
        ws.Cells["E16"].Formula = "=IF(D15>0,F16/D15,0)"; // Unit price
        ws.Cells["E16"].Style.Font.Bold = true;
        ws.Cells["E16"].Style.Numberformat.Format = "$ #,##0.00";
        ws.Cells["E16"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
        ws.Cells["F16"].Formula = "=SUM(F15:F15)";
        ws.Cells["F16"].Style.Font.Bold = true;
        ws.Cells["F16"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
        ws.Cells["G16"].Formula = "=SUM(G15:G15)";
        ws.Cells["G16"].Style.Font.Bold = true;
        ws.Cells["G16"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

        // Row 17: Product + Freight
        ws.Cells["B17"].Value = "PRODUTO + FRETE";
        ws.Cells["G17"].Formula = "=G16+G19";
        ws.Cells["G17"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

        // Row 18: Insurance
        ws.Cells["B18"].Value = "Seguro";
        ws.Cells["F18"].Value = simulacao.ValorSeguroInternacional;
        ws.Cells["G18"].Formula = "=F18*D12";
        ws.Cells["F18:G18"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

        // Row 19: Freight
        ws.Cells["B19"].Value = "Frete";
        ws.Cells["F19"].Formula = "='Rateio Custos Fixos'!G5"; // Freight in USD
        ws.Cells["G19"].Formula = "=F19*D12";
        ws.Cells["F19:G19"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

        // Row 20: Total Valor Aduaneiro
        ws.Cells["B20"].Value = "TOTAL VALOR ADUANEIRO";
        ws.Cells["B20"].Style.Font.Bold = true;
        ws.Cells["B20"].Style.Fill.PatternType = ExcelFillStyle.Solid;
        ws.Cells["B20"].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(180, 198, 231));
        ws.Cells["G20"].Formula = "=G17+G18";
        ws.Cells["G20"].Style.Font.Bold = true;
        ws.Cells["G20"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
        ws.Cells["G20"].Style.Fill.PatternType = ExcelFillStyle.Solid;
        ws.Cells["G20"].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(180, 198, 231));

        // Taxes Section
        ws.Cells["B21"].Value = "IMPOSTOS";
        ws.Cells["B21"].Style.Font.Bold = true;
        ws.Cells["B21"].Style.Font.Color.SetColor(Color.FromArgb(31, 78, 120));

        ws.Cells["B22"].Value = "IMPOSTOS";
        ws.Cells["B22"].Style.Font.Bold = true;
        ws.Cells["B22"].Style.Fill.PatternType = ExcelFillStyle.Solid;
        ws.Cells["B22"].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(180, 198, 231));
        
        ws.Cells["C22"].Value = "PERCENTUAL";
        ws.Cells["C22"].Style.Font.Bold = true;
        ws.Cells["C22"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
        ws.Cells["C22"].Style.Fill.PatternType = ExcelFillStyle.Solid;
        ws.Cells["C22"].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(180, 198, 231));

        ws.Cells["G22"].Value = "VALOR (R$)";
        ws.Cells["G22"].Style.Font.Bold = true;
        ws.Cells["G22"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
        ws.Cells["G22"].Style.Fill.PatternType = ExcelFillStyle.Solid;
        ws.Cells["G22"].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(180, 198, 231));

        var ncm = simulacao.Itens?.FirstOrDefault()?.Produto?.Ncm;
        ws.Cells["B23"].Value = "IMPOSTO. IMPORTAÇÃO";
        ws.Cells["C23"].Value = ncm?.AliquotaII ?? 0.18m;
        ws.Cells["G23"].Formula = $"=SUM('Est. Cust. Naci.'!R6:R{lastRow})";

        ws.Cells["B24"].Value = "IPI";
        ws.Cells["C24"].Value = ncm?.AliquotaIPI ?? 0.0306m;
        ws.Cells["G24"].Formula = $"=SUM('Est. Cust. Naci.'!S6:S{lastRow})";

        ws.Cells["B25"].Value = "PIS";
        ws.Cells["C25"].Value = ncm?.AliquotaPis ?? 0.0312m;
        ws.Cells["G25"].Formula = $"=SUM('Est. Cust. Naci.'!T6:T{lastRow})";

        ws.Cells["B26"].Value = "COFINS";
        ws.Cells["C26"].Value = ncm?.AliquotaCofins ?? 0.1437m;
        ws.Cells["G26"].Formula = $"=SUM('Est. Cust. Naci.'!U6:U{lastRow})";

        ws.Cells["B27"].Value = "ICMS";
        ws.Cells["C27"].Value = icmsPadrao;
        ws.Cells["G27"].Formula = $"=SUM('Est. Cust. Naci.'!V6:V{lastRow})";

        ws.Cells["C23:C27"].Style.Numberformat.Format = "0.00%";
        ws.Cells["C23:C27"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
        ws.Cells["G23:G27"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

        // Total Taxes Row
        ws.Cells["B28"].Value = "TOTAL VALOR IMPOSTOS";
        ws.Cells["B28"].Style.Font.Bold = true;
        ws.Cells["G28"].Formula = "=SUM(G23:G27)";
        ws.Cells["G28"].Style.Font.Bold = true;
        ws.Cells["G28"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

        // Expenses Section
        ws.Cells["B29"].Value = "DESPESAS ADUANEIRAS E LOGÍSTICAS";
        ws.Cells["B29"].Style.Font.Bold = true;
        ws.Cells["B29"].Style.Font.Color.SetColor(Color.FromArgb(31, 78, 120));
        ws.Cells["B29:G29"].Merge = true;
        ws.Cells["B29"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
        ws.Cells["B29"].Style.Fill.PatternType = ExcelFillStyle.Solid;
        ws.Cells["B29"].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(180, 198, 231));

        // List all aduaneiras/logistics expenses
        int startExpRow = 30;
        int expIndex = 0;
        
        // Loop columns F to U of Est. Cust. Naci. (Y to AN)
        foreach (var ec in expenseCols)
        {
            // Skip freight since freight is listed in part 1
            if (ec.Key == "frete") continue;

            int r = startExpRow + expIndex;
            ws.Cells[r, 2].Value = ec.Title;
            ws.Cells[r, 7].Formula = $"=SUM('Est. Cust. Naci.'!{ec.Col}6:{ec.Col}{lastRow})";
            ws.Cells[r, 7].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

            if (ec.Key == "afrmm")
            {
                ws.Cells[r, 2].Style.Fill.PatternType = ExcelFillStyle.Solid;
                ws.Cells[r, 2].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(255, 242, 204)); // soft yellow
                ws.Cells[r, 3].Value = 0.08m;
                ws.Cells[r, 3].Style.Numberformat.Format = "0.00%";
                ws.Cells[r, 3].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                ws.Cells[r, 3].Style.Fill.PatternType = ExcelFillStyle.Solid;
                ws.Cells[r, 3].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(255, 242, 204));
                ws.Cells[r, 7].Style.Fill.PatternType = ExcelFillStyle.Solid;
                ws.Cells[r, 7].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(255, 242, 204));
            }
            expIndex++;
        }

        int totalExpRow = startExpRow + expIndex;
        ws.Cells[totalExpRow, 2].Value = "TOTAL VALOR DESEMBARAÇO ADUANEIRO";
        ws.Cells[totalExpRow, 2].Style.Font.Bold = true;
        ws.Cells[totalExpRow, 7].Formula = $"=SUM(G{startExpRow}:G{totalExpRow - 1})";
        ws.Cells[totalExpRow, 7].Style.Font.Bold = true;
        ws.Cells[totalExpRow, 7].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

        // Grand Total Row
        int grandTotalRow = totalExpRow + 2;
        ws.Cells[grandTotalRow, 2].Value = "TOTAL   (PARTE 1 + PARTE 2 + PARTE 3) ........................................................:";
        ws.Cells[grandTotalRow, 2].Style.Font.Bold = true;
        ws.Cells[grandTotalRow, 2].Style.Font.Size = 11;
        ws.Cells[grandTotalRow, 7].Formula = $"=G20+G28+G{totalExpRow}";
        ws.Cells[grandTotalRow, 7].Style.Font.Bold = true;
        ws.Cells[grandTotalRow, 7].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
        ws.Cells[grandTotalRow, 7].Style.Fill.PatternType = ExcelFillStyle.Solid;
        ws.Cells[grandTotalRow, 7].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(255, 192, 0)); // Yellow accent

        // Sub totals block matching user layout
        int totalBlockRow = grandTotalRow + 3;
        ws.Cells[totalBlockRow, 7].Value = "TOTAL";
        ws.Cells[totalBlockRow, 7].Style.Font.Bold = true;
        ws.Cells[totalBlockRow, 7].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

        ws.Cells[totalBlockRow + 1, 2].Value = simulacao.Itens?.FirstOrDefault()?.Produto?.Descricao ?? "PRODUTOS";
        ws.Cells[totalBlockRow + 1, 2].Style.Font.Bold = true;
        ws.Cells[totalBlockRow + 1, 7].Formula = $"=G{grandTotalRow}";
        ws.Cells[totalBlockRow + 1, 7].Style.Font.Bold = true;
        ws.Cells[totalBlockRow + 1, 7].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

        ws.Cells[totalBlockRow + 4, 2].Value = "PREÇO FOB";
        ws.Cells[totalBlockRow + 4, 2].Style.Font.Bold = true;
        ws.Cells[totalBlockRow + 4, 3].Formula = $"=SUM('Est. Cust. Naci.'!L6:L{lastRow})";
        ws.Cells[totalBlockRow + 4, 3].Style.Font.Bold = true;
        ws.Cells[totalBlockRow + 4, 3].Style.Numberformat.Format = "R$ #,##0.00";

        ws.Cells[totalBlockRow + 5, 2].Value = "DESPESAS";
        ws.Cells[totalBlockRow + 5, 2].Style.Font.Bold = true;
        ws.Cells[totalBlockRow + 5, 3].Formula = $"=C{totalBlockRow + 6}-C{totalBlockRow + 4}";
        ws.Cells[totalBlockRow + 5, 3].Style.Font.Bold = true;
        ws.Cells[totalBlockRow + 5, 3].Style.Numberformat.Format = "R$ #,##0.00";

        ws.Cells[totalBlockRow + 6, 2].Value = "TOTAL";
        ws.Cells[totalBlockRow + 6, 2].Style.Font.Bold = true;
        ws.Cells[totalBlockRow + 6, 3].Formula = $"=G{totalBlockRow + 1}";
        ws.Cells[totalBlockRow + 6, 3].Style.Font.Bold = true;
        ws.Cells[totalBlockRow + 6, 3].Style.Numberformat.Format = "R$ #,##0.00";

        // Legal note
        int noteRow = totalBlockRow + 8;
        ws.Cells[noteRow, 2].Value = "FAVOR NOTAR QUE A ESTIMATIVA DE CUSTOS NÃO CONTEMPLA VALORES DE COMISSÃO, POIS ELES VARIAM CONFORME CONTRATO.";
        ws.Cells[noteRow, 2].Style.Font.Italic = true;
        ws.Cells[noteRow, 2].Style.Font.Size = 8;
        ws.Cells[noteRow, 2].Style.Font.Color.SetColor(Color.FromArgb(192, 0, 0));

        // Number Formatting for currency columns (column G)
        ws.Cells["G15:G20"].Style.Numberformat.Format = "R$ #,##0.00";
        ws.Cells["G23:G28"].Style.Numberformat.Format = "R$ #,##0.00";
        ws.Cells[startExpRow, 7, totalExpRow, 7].Style.Numberformat.Format = "R$ #,##0.00";
        ws.Cells[grandTotalRow, 7].Style.Numberformat.Format = "R$ #,##0.00";
        ws.Cells[totalBlockRow + 1, 7].Style.Numberformat.Format = "R$ #,##0.00";

        // Set column widths
        ws.Column(1).Width = 3;
        ws.Column(2).Width = 35;
        ws.Column(3).Width = 15;
        ws.Column(4).Width = 12;
        ws.Column(5).Width = 12;
        ws.Column(6).Width = 18;
        ws.Column(7).Width = 20;
    }

    private void BuildListaComprasSheet(ExcelPackage package, SimulacaoEdc simulacao, int lastRow)
    {
        var ws = package.Workbook.Worksheets.Add("LISTA DE COMPRAS");
        ws.Cells.Style.Font.Name = "Segoe UI";
        ws.Cells.Style.Font.Size = 10;
        ws.View.ShowGridLines = true;

        // Title
        ws.Cells["A1"].Value = "LISTA DE COMPRA";
        ws.Cells["A1"].Style.Font.Size = 16;
        ws.Cells["A1"].Style.Font.Bold = true;
        ws.Cells["A1"].Style.Font.Color.SetColor(Color.FromArgb(31, 78, 120));

        // Headers (Row 3)
        string[] headers = {
            "Item", "Estimativa de Custo 100%", "Produto", "NCM", "II", "IPI", "PIS", "COFINS", "ICMS",
            "Quantidade ", "Preço Unitário", "Preço Unitário Sub 50%", "Preço total por produto",
            "Preço total por produto (BRL)", "Preço total por produto Sub", "% Rateio Quantidade", "% Rateio Preço",
            "Preço R$ nacionalizado"
        };

        for (int i = 0; i < headers.Length; i++)
        {
            var cell = ws.Cells[3, i + 1];
            cell.Value = headers[i];
            cell.Style.Font.Bold = true;
            cell.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
            cell.Style.Fill.PatternType = ExcelFillStyle.Solid;
            cell.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(224, 224, 224));
            cell.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
        }

        // Row 4: Summary/Totals
        ws.Cells["J4"].Formula = $"=SUM(J5:J{lastRow})";
        ws.Cells["K4"].Formula = $"=SUM(K5:K{lastRow})";
        ws.Cells["M4"].Formula = $"=SUM(M5:M{lastRow})";
        ws.Cells["N4"].Formula = "='Resumo 100%'!$D$12"; // Exchange Rate
        ws.Cells["P4"].Value = 1.0m;
        ws.Cells["Q4"].Value = 1.0m;
        
        ws.Cells["J4:Q4"].Style.Font.Bold = true;
        ws.Cells["J4:Q4"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

        // Data Rows (Row 5 onwards)
        if (simulacao.Itens != null)
        {
            for (int idx = 0; idx < simulacao.Itens.Count; idx++)
            {
                var item = simulacao.Itens[idx];
                int r = 5 + idx;

                ws.Cells[r, 1].Value = idx + 1; // Item
                ws.Cells[r, 2].Value = ""; // Spacer
                ws.Cells[r, 3].Value = item.Modelo?.Codigo ?? item.Produto?.Referencia ?? "";
                ws.Cells[r, 4].Value = item.Produto?.Ncm?.Codigo ?? "";
                ws.Cells[r, 5].Value = item.Produto?.Ncm?.AliquotaII ?? 0m;
                ws.Cells[r, 6].Value = item.Produto?.Ncm?.AliquotaIPI ?? 0m;
                ws.Cells[r, 7].Value = item.Produto?.Ncm?.AliquotaPis ?? 0m;
                ws.Cells[r, 8].Value = item.Produto?.Ncm?.AliquotaCofins ?? 0m;
                decimal itemIcms = item.Produto?.Ncm?.AliquotaIcmsPadrao ?? 0m;
                if (itemIcms <= 0m)
                {
                    itemIcms = simulacao.Importador?.AliquotaIcmsPadrao ?? 0m;
                }
                if (itemIcms <= 0m)
                {
                    itemIcms = 0.18m;
                }
                ws.Cells[r, 9].Value = itemIcms;
                ws.Cells[r, 10].Value = item.Quantidade;
                ws.Cells[r, 11].Value = item.ValorFobUnitario;

                // Formulas
                decimal subfator = (100m - simulacao.PercentualSubfaturamento) / 100m;
                ws.Cells[r, 12].Formula = $"=K{r}*{subfator.ToString("0.0000", System.Globalization.CultureInfo.InvariantCulture)}"; // Preço Unitário Sub
                ws.Cells[r, 13].Formula = $"=K{r}*J{r}"; // Preço total USD
                ws.Cells[r, 14].Formula = $"=M{r}*$N$4"; // Preço total BRL
                ws.Cells[r, 15].Formula = $"=L{r}*J{r}*$N$4"; // Preço total Sub BRL
                ws.Cells[r, 16].Formula = $"=(J{r}*$P$4)/$J$4"; // % Rateio Quantidade
                ws.Cells[r, 17].Formula = $"=(K{r}*$Q$4)/$K$4"; // % Rateio Preço (Unitário)
                ws.Cells[r, 18].Formula = $"='Est. Cust. Naci.'!AS{r + 1}"; // Preço R$ nacionalizado (links to AS row of Est. Cust. Naci., note row index offset of +1 because Est. Cust. Naci. starts at row 6 instead of row 5)

                // Alignments & Number Formats
                ws.Cells[r, 1].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                ws.Cells[r, 3, r, 4].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                ws.Cells[r, 5, r, 9].Style.Numberformat.Format = "0.00%";
                ws.Cells[r, 5, r, 9].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                ws.Cells[r, 10].Style.Numberformat.Format = "#,##0";
                ws.Cells[r, 10].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                
                ws.Cells[r, 11, r, 15].Style.Numberformat.Format = "$ #,##0.00";
                ws.Cells[r, 11, r, 15].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                
                ws.Cells[r, 16, r, 17].Style.Numberformat.Format = "0.0000%";
                ws.Cells[r, 16, r, 17].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                ws.Cells[r, 18].Style.Numberformat.Format = "R$ #,##0.00";
                ws.Cells[r, 18].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
            }
        }

        // Apply borders and set column widths
        var gridRange = ws.Cells[3, 1, lastRow, headers.Length];
        foreach (var cell in gridRange)
        {
            cell.Style.Border.BorderAround(ExcelBorderStyle.Thin);
        }

        ws.Column(1).Width = 6;
        ws.Column(2).Width = 4;
        ws.Column(3).Width = 20;
        ws.Column(4).Width = 14;
        ws.Column(10).Width = 12;
        ws.Column(11).Width = 15;
        ws.Column(12).Width = 20;
        ws.Column(13).Width = 20;
        ws.Column(14).Width = 24;
        ws.Column(15).Width = 24;
        ws.Column(16).Width = 18;
        ws.Column(17).Width = 18;
        ws.Column(18).Width = 22;
    }

    private void BuildEstCustNaciSheet(ExcelPackage package, SimulacaoEdc simulacao, dynamic expenseCols, int lastRow)
    {
        var ws = package.Workbook.Worksheets.Add("Est. Cust. Naci.");
        ws.Cells.Style.Font.Name = "Segoe UI";
        ws.Cells.Style.Font.Size = 10;
        ws.View.ShowGridLines = true;

        // Group headers (Row 2)
        ws.Cells["C2:K2"].Merge = true; ws.Cells["C2"].Value = "DETALHES DO PRODUTO";
        ws.Cells["L2:Q2"].Merge = true; ws.Cells["L2"].Value = "VALOR ADUANEIRO";
        ws.Cells["R2:X2"].Merge = true; ws.Cells["R2"].Value = "IMPOSTOS";
        ws.Cells["Y2:AN2"].Merge = true; ws.Cells["Y2"].Value = "TAXAS PORTUÁRIAS";
        
        ws.Cells["C2,L2,R2,Y2"].Style.Font.Bold = true;
        ws.Cells["C2,L2,R2,Y2"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
        ws.Cells["C2,L2,R2,Y2"].Style.Fill.PatternType = ExcelFillStyle.Solid;
        ws.Cells["C2,L2,R2,Y2"].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(180, 198, 231));

        // Column Headers (Row 3)
        string[] headers = {
            "", "Nº", "ITEM", "Código", "Bitola (mm)", "Embal.", "NCM", "QTD", "% Rateio Preço",
            "Preço unitário Fábrica (USD)", "Preço x QTD (Valor em USD)", "Preço x QTD (valor em BRL)",
            "Preço x QTD (valor em BRL) SUB", "THC (valor em BRL)", "Valor do frete (Valor em BRL)",
            "TOTAL VALOR ADUANEIRO", "TOTAL VALOR ADUANEIRO + II", "IMPOSTO DE IMPORTAÇÃO", "IPI", "PIS", "COFINS", "ICMS",
            "TOTAL IMPOSTOS", "TOTAL IMPOSTOS (SUB)", "TAXA SISCOMEX", "LIBERAÇÃO DE B/L", "T.H.C|  CAPATAZIA", "ISPS",
            "DAMAGE PROTECTION", "DESCONSOLIDAÇÃO", "DEVOLUÇÃO DE CONTAINER", "TRS", "AFRMM", "ARMAZENAGEM TCP",
            "SCANNER TCP", "HANDLING - TCP", "PESAGEM TCP", "TAXA DO PARCEIRO - PARANAGUÁ", "FRETE RODOVIÁRIO",
            "DESEMBARAÇO ADUANEIRO", "TOTAL TAXAS DESEMBARAÇO", "TOTAL", "TOTAL (sub)", "TOTAL (sub) duplicate",
            "MÉTODO ANTIGO ", "MÉTODO ANTIGO (sub)", "MÉTODO DANI ", "MÉTODO DANI (sub)", "MÉTODO JULIANA ",
            "MÉTODO JULIANA (sub)", "", "VALOR UNITÁRIO C/ COMISSÃO SEAWISE"
        };

        for (int i = 0; i < headers.Length; i++)
        {
            if (string.IsNullOrEmpty(headers[i])) continue;
            var cell = ws.Cells[3, i + 1];
            cell.Value = headers[i];
            cell.Style.Font.Bold = true;
            cell.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
            cell.Style.Fill.PatternType = ExcelFillStyle.Solid;
            cell.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(224, 224, 224));
            cell.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
        }

        int estLastRow = lastRow + 1; // Est starts on Row 6 instead of Row 5 (due to double headers)

        // Row 4: Base variables
        ws.Cells["H4"].Formula = $"=SUM(H6:H{estLastRow})";
        ws.Cells["L4"].Formula = "='Resumo 100%'!$D$12";
        ws.Cells["N4"].Value = 0m;
        ws.Cells["O4"].Formula = $"=SUM(O6:O{estLastRow})";
        ws.Cells["H4,L4,N4,O4"].Style.Font.Bold = true;
        ws.Cells["H4,L4,N4,O4"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

        // Row 5: Aliquotas placeholders matching Ralli
        var ncm = simulacao.Itens?.FirstOrDefault()?.Produto?.Ncm;
        ws.Cells["R5"].Value = ncm?.AliquotaII ?? 0.18m;
        ws.Cells["S5"].Value = ncm?.AliquotaIPI ?? 0.0306m;
        ws.Cells["T5"].Value = ncm?.AliquotaPis ?? 0.0312m;
        ws.Cells["U5"].Value = ncm?.AliquotaCofins ?? 0.1437m;
        decimal defaultIcms = 0.18m;
        if (simulacao.Importador?.AliquotaIcmsPadrao > 0m)
        {
            defaultIcms = simulacao.Importador.AliquotaIcmsPadrao;
        }
        ws.Cells["V5"].Value = defaultIcms;
        ws.Cells["R5:V5"].Style.Numberformat.Format = "0.00%";
        ws.Cells["R5:V5"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
        ws.Cells["R5:V5"].Style.Fill.PatternType = ExcelFillStyle.Solid;
        ws.Cells["R5:V5"].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(255, 242, 204));

        if (simulacao.Itens != null)
        {
            for (int idx = 0; idx < simulacao.Itens.Count; idx++)
            {
                var item = simulacao.Itens[idx];
                int r = 6 + idx;
                int incomingListRow = 5 + idx; // LISTA DE COMPRAS starts at row 5

                ws.Cells[r, 1].Value = "AAA";
                ws.Cells[r, 2].Formula = $"='LISTA DE COMPRAS'!A{incomingListRow}";
                ws.Cells[r, 3].Formula = $"='LISTA DE COMPRAS'!C{incomingListRow}";
                ws.Cells[r, 7].Formula = $"='LISTA DE COMPRAS'!D{incomingListRow}";
                ws.Cells[r, 8].Formula = $"='LISTA DE COMPRAS'!J{incomingListRow}";
                ws.Cells[r, 9].Formula = $"='LISTA DE COMPRAS'!P{incomingListRow}";
                ws.Cells[r, 10].Formula = $"='LISTA DE COMPRAS'!K{incomingListRow}";

                ws.Cells[r, 11].Formula = $"=H{r}*J{r}"; // Qty * Price unit USD
                ws.Cells[r, 12].Formula = $"=K{r}*$L$4"; // BRL Total
                decimal subfator = (100m - simulacao.PercentualSubfaturamento) / 100m;
                ws.Cells[r, 13].Formula = $"=L{r}*{subfator.ToString("0.0000", System.Globalization.CultureInfo.InvariantCulture)}"; // BRL sub Total
                ws.Cells[r, 14].Formula = $"=$N$4*I{r}"; // THC BRL
                ws.Cells[r, 15].Formula = $"='Rateio Custos Fixos'!E{r + 6}"; // Frete rateado BRL (links to Rateio row, which starts at row 12, so r=6 links to 6+6=12)

                ws.Cells[r, 16].Formula = $"=SUM(L{r},O{r})"; // TOTAL VALOR ADUANEIRO
                ws.Cells[r, 17].Formula = $"=P{r}+R{r}"; // TOTAL VALOR ADUANEIRO + II

                // Tax calculations depending on settings
                ws.Cells[r, 18].Formula = $"=$P{r}*'LISTA DE COMPRAS'!E{incomingListRow}"; // II

                if (simulacao.MetodoCalculoFederais == "SimplificadoExcel")
                {
                    ws.Cells[r, 19].Formula = $"=$Q{r}*'LISTA DE COMPRAS'!F{incomingListRow}"; // IPI
                    ws.Cells[r, 20].Formula = $"=$Q{r}*'LISTA DE COMPRAS'!G{incomingListRow}"; // PIS
                    ws.Cells[r, 21].Formula = $"=$Q{r}*'LISTA DE COMPRAS'!H{incomingListRow}"; // COFINS
                }
                else
                {
                    ws.Cells[r, 19].Formula = $"=(P{r}+R{r})*'LISTA DE COMPRAS'!F{incomingListRow}"; // IPI
                    ws.Cells[r, 20].Formula = $"=$P{r}*'LISTA DE COMPRAS'!G{incomingListRow}"; // PIS
                    ws.Cells[r, 21].Formula = $"=$P{r}*'LISTA DE COMPRAS'!H{incomingListRow}"; // COFINS
                }

                if (simulacao.MetodoCalculoIcms == "SimplificadoExcel")
                {
                    ws.Cells[r, 22].Formula = $"=$P{r}*'LISTA DE COMPRAS'!I{incomingListRow}"; // ICMS Simplificado
                }
                else
                {
                    ws.Cells[r, 22].Formula = $"=((P{r}+R{r}+S{r}+T{r}+U{r}+AO{r})/(1-'LISTA DE COMPRAS'!I{incomingListRow}))*'LISTA DE COMPRAS'!I{incomingListRow}"; // ICMS por dentro
                }

                ws.Cells[r, 23].Formula = $"=SUM(R{r}:V{r})"; // TOTAL IMPOSTOS
                ws.Cells[r, 24].Formula = $"=SUM(R{r}:V{r})"; // TOTAL IMPOSTOS (SUB) - simplify as same

                // Taxas portuárias Y to AN (column indices 25 to 40)
                int colIdx = 25;
                foreach (var ec in expenseCols)
                {
                    if (ec.Key == "frete") continue;
                    ws.Cells[r, colIdx].Formula = $"='Rateio Custos Fixos'!{ec.Col}{r + 6}";
                    colIdx++;
                }

                ws.Cells[r, 41].Formula = $"=SUM(Y{r}:AN{r})"; // TOTAL TAXAS DESEMBARAÇO
                ws.Cells[r, 42].Formula = $"=AO{r}+W{r}+P{r}"; // TOTAL BRL
                ws.Cells[r, 43].Formula = $"=AO{r}+X{r}+P{r}"; // TOTAL sub BRL
                ws.Cells[r, 44].Formula = $"=AQ{r}"; // Total duplicate (pointing to AQ: TOTAL sub BRL)

                ws.Cells[r, 45].Formula = $"=(AP{r}/H{r})"; // MÉTODO ANTIGO (Custo unitário BRL)
                ws.Cells[r, 46].Formula = $"=AR{r}/H{r}"; // MÉTODO ANTIGO (sub)
                ws.Cells[r, 47].Formula = $"=AP{r}/H{r}"; // MÉTODO DANI
                ws.Cells[r, 48].Formula = $"=AR{r}/H{r}"; // MÉTODO DANI (sub)
                
                // Add Seewise Commission if study has it active
                decimal commMult = 1.0m + (simulacao.FlExibirComissao ? (simulacao.ComissaoPercentual / 100m) : 0m);
                ws.Cells[r, 52].Formula = $"=AS{r}*{commMult.ToString("0.0000", System.Globalization.CultureInfo.InvariantCulture)}"; // VALOR UNITÁRIO C/ COMISSÃO

                // Styles & Number Formatting
                ws.Cells[r, 1, r, 9].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                ws.Cells[r, 10, r, 24].Style.Numberformat.Format = "#,##0.00";
                ws.Cells[r, 25, r, 40].Style.Numberformat.Format = "#,##0.00";
                ws.Cells[r, 41, r, 50].Style.Numberformat.Format = "#,##0.00";
                ws.Cells[r, 52].Style.Numberformat.Format = "#,##0.00";
            }
        }

        // Apply borders and alignments
        var gridRange = ws.Cells[2, 2, estLastRow, headers.Length];
        foreach (var cell in gridRange)
        {
            cell.Style.Border.BorderAround(ExcelBorderStyle.Thin);
        }

        ws.Column(1).Width = 5;
        ws.Column(2).Width = 5;
        ws.Column(3).Width = 20;
        ws.Column(7).Width = 14;
        ws.Column(8).Width = 10;
        ws.Column(9).Width = 14;
        ws.Column(10).Width = 18;
        ws.Column(11).Width = 18;
        ws.Column(12).Width = 18;
        ws.Column(13).Width = 18;
        ws.Column(14).Width = 15;
        ws.Column(15).Width = 18;
        ws.Column(16).Width = 20;
        ws.Column(17).Width = 20;
        ws.Column(18).Width = 18;
        ws.Column(19).Width = 12;
        ws.Column(20).Width = 12;
        ws.Column(21).Width = 12;
        ws.Column(22).Width = 12;
        ws.Column(23).Width = 18;
        ws.Column(24).Width = 18;
        
        // Port expenses columns widths
        for (int c = 25; c <= 40; c++) ws.Column(c).Width = 15;
        ws.Column(41).Width = 22;
        ws.Column(42).Width = 18;
        ws.Column(43).Width = 18;
        ws.Column(45).Width = 18;
        ws.Column(52).Width = 24;
    }

    private void BuildRateioCustosFixosSheet(ExcelPackage package, SimulacaoEdc simulacao, dynamic expenseCols, int lastRow)
    {
        var ws = package.Workbook.Worksheets.Add("Rateio Custos Fixos");
        ws.Cells.Style.Font.Name = "Segoe UI";
        ws.Cells.Style.Font.Size = 10;
        ws.View.ShowGridLines = true;

        // Exchange block (Rows 1 to 5)
        ws.Cells["A1"].Value = "CÂMBIO";
        ws.Cells["A1"].Style.Font.Bold = true;
        ws.Cells["B3"].Formula = "='Resumo 100%'!$D$12"; // Exchange Rate
        ws.Cells["B3"].Style.Font.Bold = true;
        ws.Cells["B3"].Style.Numberformat.Format = "#,##0.00";

        ws.Cells["F1"].Value = "FRETE";
        ws.Cells["F1"].Style.Font.Bold = true;
        ws.Cells["G1"].Value = "R$";
        ws.Cells["G1"].Style.Font.Bold = true;

        ws.Cells["F2"].Value = simulacao.ValorFreteInternacional;
        ws.Cells["F2"].Style.Numberformat.Format = "$ #,##0.00";
        ws.Cells["G2"].Formula = "=F2*B3"; // Frete BRL
        ws.Cells["G2"].Style.Numberformat.Format = "R$ #,##0.00";

        ws.Cells["F3"].Value = simulacao.ValorSeguroInternacional;
        ws.Cells["F3"].Style.Numberformat.Format = "$ #,##0.00";
        ws.Cells["G3"].Formula = "=F3"; // Insurance is in BRL or BRL direct input
        ws.Cells["G3"].Style.Numberformat.Format = "R$ #,##0.00";

        ws.Cells["F4"].Value = "TOTAL";
        ws.Cells["F4"].Style.Font.Bold = true;
        ws.Cells["G4"].Formula = "=SUM(G2:G3)";
        ws.Cells["G4"].Style.Font.Bold = true;
        ws.Cells["G4"].Style.Numberformat.Format = "R$ #,##0.00";

        ws.Cells["G5"].Formula = "=G4/B3"; // TOTAL USD
        ws.Cells["G5"].Style.Numberformat.Format = "$ #,##0.00";

        // Headers (Row 10)
        ws.Cells["A10"].Value = "Produto";
        ws.Cells["B10"].Value = "Quantidade";
        ws.Cells["C10"].Value = "% Rateio Preço";

        int colIdx = 5; // Start in column E (FRETE)
        foreach (var ec in expenseCols)
        {
            ws.Cells[10, colIdx].Value = ec.Title;
            colIdx++;
        }

        var headerRange = ws.Cells[10, 1, 10, colIdx - 1];
        headerRange.Style.Font.Bold = true;
        headerRange.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
        headerRange.Style.Fill.PatternType = ExcelFillStyle.Solid;
        headerRange.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(224, 224, 224));

        int rateioLastRow = lastRow + 7; // Starts on row 12, so idx=0 is row 12

        // Row 11: Totals of expenses
        ws.Cells["B11"].Formula = $"=SUM(B12:B{rateioLastRow})";
        ws.Cells["C11"].Formula = $"=SUM(C12:C{rateioLastRow})";
        ws.Cells["E11"].Formula = "=G4"; // Total freight in BRL

        colIdx = 6; // Column F (SISCOMEX)
        foreach (var ec in expenseCols)
        {
            if (ec.Key == "frete") continue;

            // Find expense total in study
            var matchedExp = simulacao.Despesas?.FirstOrDefault(d => NormalizeKey(d.NomeDespesa) == ec.Key);
            decimal expValue = matchedExp?.Valor ?? 0m;
            
            // Convert to BRL if origin currency is USD
            if (matchedExp != null && matchedExp.Moeda == "USD")
            {
                ws.Cells[11, colIdx].Value = expValue;
                // Add formula or value. In Ralli they are values.
                ws.Cells[11, colIdx].Formula = $"={expValue.ToString(System.Globalization.CultureInfo.InvariantCulture)}*B3";
            }
            else
            {
                ws.Cells[11, colIdx].Value = expValue;
            }

            if (ec.Key == "afrmm")
            {
                ws.Cells[11, colIdx].Value = 0.08m; // AFRMM is 8%
                ws.Cells[11, colIdx].Style.Numberformat.Format = "0.00%";
            }
            else
            {
                ws.Cells[11, colIdx].Style.Numberformat.Format = "R$ #,##0.00";
            }

            colIdx++;
        }

        ws.Cells[11, 2, 11, colIdx - 1].Style.Font.Bold = true;
        ws.Cells[11, 2, 11, colIdx - 1].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

        // Data Rows (Row 12 onwards)
        if (simulacao.Itens != null)
        {
            for (int idx = 0; idx < simulacao.Itens.Count; idx++)
            {
                var item = simulacao.Itens[idx];
                int r = 12 + idx;
                int listRow = 5 + idx;

                ws.Cells[r, 1].Formula = $"='LISTA DE COMPRAS'!C{listRow}";
                ws.Cells[r, 2].Formula = $"='LISTA DE COMPRAS'!J{listRow}";
                ws.Cells[r, 3].Formula = $"='LISTA DE COMPRAS'!Q{listRow}"; // % Rateio Preço

                // FRETE column E
                ws.Cells[r, 5].Formula = $"=E$11*$C{r}";

                // Port expenses F to U (columns 6 to 21)
                colIdx = 6;
                foreach (var ec in expenseCols)
                {
                    if (ec.Key == "frete") continue;

                    if (ec.Key == "afrmm")
                    {
                        ws.Cells[r, colIdx].Formula = $"=$N$11*E{r}"; // 8% * Freight
                    }
                    else
                    {
                        // Check if specific rateio method is selected
                        var matchedExp = simulacao.Despesas?.FirstOrDefault(d => NormalizeKey(d.NomeDespesa) == ec.Key);
                        string rateioCol = "$C"; // Default FOB Price ratio
                        
                        if (matchedExp != null)
                        {
                            if (matchedExp.MetodoRateio == "Quantidade")
                            {
                                // Link to % Rateio Quantidade in LISTA DE COMPRAS column P
                                rateioCol = $"'LISTA DE COMPRAS'!$P${listRow}";
                            }
                            else if (matchedExp.MetodoRateio == "Peso")
                            {
                                // Simulating or linking to weight if present
                                rateioCol = "$C"; 
                            }
                            else if (matchedExp.MetodoRateio == "Volume")
                            {
                                rateioCol = "$C";
                            }
                        }

                        if (rateioCol.StartsWith("'"))
                        {
                            ws.Cells[r, colIdx].Formula = $"={openpyxl_column_letter(colIdx)}$11*{rateioCol}";
                        }
                        else
                        {
                            ws.Cells[r, colIdx].Formula = $"={openpyxl_column_letter(colIdx)}$11*{rateioCol}{r}";
                        }
                    }
                    
                    ws.Cells[r, colIdx].Style.Numberformat.Format = "#,##0.00";
                    ws.Cells[r, colIdx].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    colIdx++;
                }

                ws.Cells[r, 1, r, 3].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                ws.Cells[r, 5].Style.Numberformat.Format = "#,##0.00";
                ws.Cells[r, 5].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
            }
        }

        // Apply borders
        var gridRange = ws.Cells[10, 1, rateioLastRow, colIdx - 1];
        foreach (var cell in gridRange)
        {
            cell.Style.Border.BorderAround(ExcelBorderStyle.Thin);
        }

        ws.Column(1).Width = 20;
        ws.Column(2).Width = 12;
        ws.Column(3).Width = 15;
        for (int c = 5; c < colIdx; c++) ws.Column(c).Width = 15;
    }

    private string openpyxl_column_letter(int col)
    {
        int temp;
        string letter = "";
        while (col > 0)
        {
            temp = (col - 1) % 26;
            letter = (char)(65 + temp) + letter;
            col = (col - temp - 1) / 26;
        }
        return letter;
    }
}
