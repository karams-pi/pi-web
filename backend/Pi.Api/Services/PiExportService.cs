using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Drawing;
using Pi.Api.Models;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;

namespace Pi.Api.Services;

public class PiExportService
{
    private readonly AppDbContext _context;

    public PiExportService(AppDbContext context)
    {
        _context = context;
    }

    public async Task<byte[]> ExportToExcelAsync(long piId, string currency = "EXW", int validity = 30)
    {
        var pi = await _context.Pis
            .Include(p => p.Cliente)
            .Include(p => p.Fornecedor)
            .Include(p => p.Frete)
            .Include(p => p.Configuracoes)
            .Include(p => p.PiItens)
                .ThenInclude(i => i.ModuloTecido!)
                    .ThenInclude(mt => mt.Modulo!)
                        .ThenInclude(m => m.Marca!)
            .Include(p => p.PiItens)
                .ThenInclude(i => i.ModuloTecido!)
                    .ThenInclude(mt => mt.Modulo!)
                        .ThenInclude(m => m.Fornecedor!)
            .Include(p => p.PiItens)
                .ThenInclude(i => i.ModuloTecido!)
                    .ThenInclude(mt => mt.Modulo!)
                        .ThenInclude(m => m.Categoria!)
            .Include(p => p.PiItens)
                .ThenInclude(i => i.ModuloTecido!)
                    .ThenInclude(mt => mt.Tecido!)
            .FirstOrDefaultAsync(p => p.Id == piId);

        if (pi == null) throw new Exception("PI not found");

        using var package = new ExcelPackage();
        var ws = package.Workbook.Worksheets.Add("Proforma Invoice");

        // Configuração global da planilha
        ws.Cells.Style.Font.Name = "Arial";
        ws.Cells.Style.Font.Size = 10;

        var supplierName = pi.Fornecedor?.Nome ?? "";
        bool isFerguile = supplierName.Contains("Ferguile", StringComparison.OrdinalIgnoreCase) || 
                          supplierName.Contains("Livintus", StringComparison.OrdinalIgnoreCase);

        if (isFerguile)
        {
            BuildFerguileLayout(ws, pi, currency, validity);
        }
        else
        {
            BuildGenericLayout(ws, pi, currency, validity);
        }

        return await package.GetAsByteArrayAsync();
    }

    private void BuildGenericLayout(ExcelWorksheet ws, ProformaInvoice pi, string currency, int validity)
    {
        string piNumber = GetFormattedPiNumber(pi);
        var dateObj = pi.DataPi.DateTime;

        // ═══════════════ TOP BAR ═══════════════
        ws.Cells["A1:O1"].Style.Fill.PatternType = ExcelFillStyle.Solid;
        ws.Cells["A1:O1"].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(0, 51, 102));

        // ═══════════════ HEADER ═══════════════
        ws.Cells["A2:O2"].Merge = true;
        ws.Cells["A2"].Value = "KARAM'S INDUSTRIA E COMERCIO DE ESTOFADOS LTDA";
        ws.Cells["A2"].Style.Font.Bold = true;
        ws.Cells["A2"].Style.Font.Size = 13;
        ws.Cells["A2"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

        ws.Cells["A3:O3"].Merge = true;
        ws.Cells["A3"].Value = "CNPJ 02.670.170/0001-09 | ROD PR 180 - KM 04 - LOTE 11 N8 B1 BAIRRO RURAL 87890-000 TERRA RICA - PARANÁ";
        ws.Cells["A3"].Style.Font.Size = 8;
        ws.Cells["A3"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
        
        ws.Cells["A4:O4"].Merge = true;
        ws.Cells["A4"].Value = "KARAMS@KARAMS.COM.BR - https://karams.com.br/ | (44) 3441-8400";
        ws.Cells["A4"].Style.Font.Size = 8;
        ws.Cells["A4"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

        ws.Cells["A5:O5"].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;

        // ═══════════════ IMPORTER & PI DETAILS GRID ═══════════════
        int gridRow = 6;
        // Importer Column (Left)
        ws.Cells[gridRow, 1].Value = "IMPORTADOR:";
        ws.Cells[gridRow, 1].Style.Font.Bold = true;
        ws.Cells[gridRow + 1, 1].Value = pi.Cliente?.Nome;
        ws.Cells[gridRow + 2, 1].Value = "DIRECCIÓN: " + pi.Cliente?.Endereco;
        ws.Cells[gridRow + 3, 1].Value = "CIUDAD: " + pi.Cliente?.Cidade;
        ws.Cells[gridRow + 4, 1].Value = "PAÍS: " + (pi.Cliente?.Pais ?? "BRASIL");
        ws.Cells[gridRow + 5, 1].Value = "NIT: " + pi.Cliente?.Nit;
        ws.Cells[gridRow + 6, 1].Value = "TELÉFONO: " + pi.Cliente?.Telefone;
        ws.Cells[gridRow + 7, 1].Value = "EMAIL: " + pi.Cliente?.Email;

        // PI Details Column (Right)
        int rightCol = 8;
        ws.Cells[gridRow, rightCol].Value = "PROFORMA INVOICE: " + piNumber;
        ws.Cells[gridRow, rightCol].Style.Font.Bold = true;
        ws.Cells[gridRow + 1, rightCol].Value = "FECHA:";
        ws.Cells[gridRow + 1, rightCol + 1].Value = dateObj.ToString("dd/MM/yyyy");
        ws.Cells[gridRow + 2, rightCol].Value = "PEDIDO FECHA:";
        ws.Cells[gridRow + 2, rightCol + 1].Value = pi.DataPi.ToString("dd/MM/yyyy");
        ws.Cells[gridRow + 3, rightCol].Value = "PUNTO DE EMBARQUE:";
        ws.Cells[gridRow + 3, rightCol + 1].Value = (pi.Configuracoes?.ValorFOBFretePortoParanagua > 0) ? "PARANAGUA" : "ARAPONGAS";
        ws.Cells[gridRow + 4, rightCol].Value = "INCOTERM:";
        ws.Cells[gridRow + 4, rightCol + 1].Value = pi.Frete?.Nome;
        ws.Cells[gridRow + 5, rightCol].Value = "PAGO CONDICIONES:";
        ws.Cells[gridRow + 5, rightCol + 1].Value = "T/T";
        ws.Cells[gridRow, 1, gridRow + 7, 15].Style.Font.Size = 9;

        // ═══════════════ TABLE HEADER ═══════════════
        int startRow = 15;
        ws.Cells[startRow, 1, startRow + 1, 1].Merge = true; ws.Cells[startRow, 1].Value = "FOTO";
        ws.Cells[startRow, 2, startRow + 1, 2].Merge = true; ws.Cells[startRow, 2].Value = "NOMBRE";
        ws.Cells[startRow, 3, startRow + 1, 3].Merge = true; ws.Cells[startRow, 3].Value = "DESCRIPCIÓN";
        ws.Cells[startRow, 4, startRow, 6].Merge = true; ws.Cells[startRow, 4].Value = "DIMENSIONES (m)";
        ws.Cells[startRow + 1, 4].Value = "Largo";
        ws.Cells[startRow + 1, 5].Value = "Prof.";
        ws.Cells[startRow + 1, 6].Value = "Alto";
        ws.Cells[startRow, 7, startRow + 1, 7].Merge = true; ws.Cells[startRow, 7].Value = "CANT UNID";
        ws.Cells[startRow, 8, startRow + 1, 8].Merge = true; ws.Cells[startRow, 8].Value = "CANT SOFA";
        ws.Cells[startRow, 9, startRow + 1, 9].Merge = true; ws.Cells[startRow, 9].Value = "TOTAL VOLUMEN M³";
        ws.Cells[startRow, 10, startRow + 1, 10].Merge = true; ws.Cells[startRow, 10].Value = "TELA";
        ws.Cells[startRow, 11, startRow + 1, 11].Merge = true; ws.Cells[startRow, 11].Value = "PIES";
        ws.Cells[startRow, 12, startRow + 1, 12].Merge = true; ws.Cells[startRow, 12].Value = "ACABADO";
        ws.Cells[startRow, 13, startRow + 1, 13].Merge = true; ws.Cells[startRow, 13].Value = "OBSERVACIÓN";

        bool showFreight = new[] { "FOB", "FCA", "CIF" }.Contains(pi.Frete?.Nome?.ToUpper());
        int unitCol = 14;
        int totalCol = 15;

        if (showFreight)
        {
            ws.Cells[startRow, 14, startRow + 1, 14].Merge = true; ws.Cells[startRow, 14].Value = "FRETE";
            unitCol = 15;
            totalCol = 16;
        }

        string unitLabel = currency == "BRL" ? "UNIT R$" : $"UNIT DOLAR {pi.CotacaoAtualUSD:N2}";
        string totalLabel = currency == "BRL" ? "TOTAL R$" : "TOTAL USD";

        ws.Cells[startRow, unitCol, startRow + 1, unitCol].Merge = true; ws.Cells[startRow, unitCol].Value = unitLabel;
        ws.Cells[startRow, totalCol, startRow + 1, totalCol].Merge = true; ws.Cells[startRow, totalCol].Value = totalLabel;

        var headerRange = ws.Cells[startRow, 1, startRow + 1, totalCol];
        headerRange.Style.Font.Bold = true;
        headerRange.Style.Font.Color.SetColor(Color.White);
        headerRange.Style.Fill.PatternType = ExcelFillStyle.Solid;
        headerRange.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(26, 46, 68));
        headerRange.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
        headerRange.Style.VerticalAlignment = ExcelVerticalAlignment.Center;

        // ═══════════════ DATA ROWS ═══════════════
        int currentRow = startRow + 2;
        var itemsByBrand = pi.PiItens
            .GroupBy(i => i.ModuloTecido?.Modulo?.Marca)
            .ToList();

        decimal totalQty = 0;
        decimal totalM3 = 0;
        decimal totalValue = 0;

        foreach (var group in itemsByBrand)
        {
            var brand = group.Key;
            int groupStartRow = currentRow;
            foreach (var item in group)
            {
                var mt = item.ModuloTecido;
                ws.Cells[currentRow, 3].Value = mt?.Modulo?.Descricao;
                ws.Cells[currentRow, 4].Value = item.Largura;
                ws.Cells[currentRow, 5].Value = item.Profundidade;
                ws.Cells[currentRow, 6].Value = item.Altura;
                ws.Cells[currentRow, 7].Value = item.Quantidade;
                ws.Cells[currentRow, 8].Value = item.Quantidade;
                ws.Cells[currentRow, 9].Value = item.M3 * item.Quantidade;
                ws.Cells[currentRow, 10].Value = mt?.Tecido?.Nome;
                ws.Cells[currentRow, 11].Value = item.Feet;
                ws.Cells[currentRow, 12].Value = item.Finishing;
                ws.Cells[currentRow, 13].Value = item.Observacao;

                decimal unitPrice = currency == "BRL" ? item.ValorFinalItemBRL / (item.Quantidade > 0 ? item.Quantidade : 1) : item.ValorEXW;
                decimal totalPrice = currency == "BRL" ? item.ValorFinalItemBRL : (item.ValorEXW * item.Quantidade);

                if (showFreight)
                {
                    ws.Cells[currentRow, 14].Value = currency == "BRL" ? item.ValorFreteRateadoBRL : item.ValorFreteRateadoUSD;
                }

                ws.Cells[currentRow, unitCol].Value = unitPrice;
                ws.Cells[currentRow, totalCol].Value = totalPrice;

                ws.Row(currentRow).Height = 25;
                for (int i = 3; i <= totalCol; i++) ws.Cells[currentRow, i].Style.Border.BorderAround(ExcelBorderStyle.Thin);
                
                totalQty += item.Quantidade;
                totalM3 += (item.M3 * item.Quantidade);
                totalValue += (currency == "BRL" ? item.ValorFinalItemBRL : (item.ValorEXW * item.Quantidade));
                currentRow++;
            }

            // Merge Brand Name & Photo
            ws.Cells[groupStartRow, 2, currentRow - 1, 2].Merge = true;
            ws.Cells[groupStartRow, 2].Value = brand?.Nome ?? "Outros";
            ws.Cells[groupStartRow, 2].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
            ws.Cells[groupStartRow, 2].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
            ws.Cells[groupStartRow, 2].Style.Font.Bold = true;
            ws.Cells[groupStartRow, 2].Style.Fill.PatternType = ExcelFillStyle.Solid;
            ws.Cells[groupStartRow, 2].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(239, 246, 255));
            ws.Cells[groupStartRow, 2].Style.Border.BorderAround(ExcelBorderStyle.Thin);

            ws.Cells[groupStartRow, 1, currentRow - 1, 1].Merge = true;
            ws.Cells[groupStartRow, 1].Style.Border.BorderAround(ExcelBorderStyle.Thin);

            if (brand?.Imagem != null)
            {
                using var ms = new MemoryStream(brand.Imagem);
                var pic = ws.Drawings.AddPicture($"Pic_{brand.Id}", ms);
                pic.SetPosition(groupStartRow - 1, 5, 0, 5);
                pic.SetSize(60, 60);
            }
            // Set row height if merged photo needs space
            if (currentRow - groupStartRow == 1) ws.Row(groupStartRow).Height = 65;
        }

        // Summary Row Generic
        ws.Cells[currentRow, 1, currentRow, 6].Merge = true;
        ws.Cells[currentRow, 1].Value = "TOTAL";
        ws.Cells[currentRow, 1].Style.Font.Bold = true;
        ws.Cells[currentRow, 1].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
        ws.Cells[currentRow, 7].Value = totalQty;
        ws.Cells[currentRow, 8].Value = totalQty;
        ws.Cells[currentRow, 9].Value = totalM3;
        ws.Cells[currentRow, totalCol].Value = totalValue;
        ws.Cells[currentRow, 7, currentRow, totalCol].Style.Font.Bold = true;
        for (int i = 1; i <= totalCol; i++) ws.Cells[currentRow, i].Style.Border.BorderAround(ExcelBorderStyle.Thin);
        ws.Cells[currentRow, 1, currentRow, totalCol].Style.Fill.PatternType = ExcelFillStyle.Solid;
        ws.Cells[currentRow, 1, currentRow, totalCol].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(248, 250, 252));
        currentRow++;

        ws.Cells[startRow + 2, 14, currentRow - 1, totalCol].Style.Numberformat.Format = currency == "BRL" ? "_-R$* #,##0.00_-" : "_-$* #,##0.00_-";
        ws.Cells[startRow + 2, 4, currentRow - 1, 9].Style.Numberformat.Format = "#,##0.00";

        // ═══════════════ FOOTER ═══════════════
        currentRow += 1;
        ws.Cells[currentRow, 1, currentRow + 8, 7].Style.Border.BorderAround(ExcelBorderStyle.Thin);
        ws.Cells[currentRow, 1].Value = "DETALLES BANCARIOS: BANCO INTERMEDIARIO";
        ws.Cells[currentRow, 1].Style.Font.Bold = true;
        ws.Cells[currentRow + 1, 1].Value = "BANK OF AMERICA, N.A. | SWIFT: BOFAUS3N";
        ws.Cells[currentRow + 3, 1].Value = "BANCO BENEFICIARIO: BANCO RENDIMENTO S/A";
        ws.Cells[currentRow + 3, 1].Style.Font.Bold = true;
        ws.Cells[currentRow + 4, 1].Value = "SWIFT: RENDBRSP | IBAN: BR4468900810000010025069901i1";
        ws.Cells[currentRow, 1, currentRow + 8, 7].Style.Font.Size = 9;

        ws.Cells[currentRow, 8, currentRow + 8, totalCol].Style.Border.BorderAround(ExcelBorderStyle.Thin);
        ws.Cells[currentRow, 8].Value = "DATOS GENERALES DEL PRODUCTO";
        ws.Cells[currentRow, 8].Style.Font.Bold = true;
        ws.Cells[currentRow + 1, 8].Value = "CANTIDAD TOTAL: " + totalQty;
        ws.Cells[currentRow + 2, 8].Value = "TOTAL M³: " + totalM3.ToString("N3");
        ws.Cells[currentRow + 3, 8].Value = "TOTAL " + (currency == "BRL" ? "R$" : "USD") + ": " + (currency == "BRL" ? totalValue.ToString("N2") : totalValue.ToString("C2"));
        ws.Cells[currentRow + 5, 8].Value = "HECHO EN BRASIL";
        
        ws.Cells[currentRow + 7, 8].Value = $"* Esta proforma es válida por {validity} días a partir de la fecha de emisión.";
        ws.Cells[currentRow + 7, 8].Style.Font.Italic = true;
        ws.Cells[currentRow + 7, 8].Style.Font.Size = 8;

        ws.Cells[currentRow, 8, currentRow + 8, totalCol].Style.Font.Size = 9;

        ws.Column(1).Width = 10;
        ws.Column(2).Width = 15;
        ws.Column(3).Width = 35;
        ws.Column(10).Width = 20;
    }

    private void BuildFerguileLayout(ExcelWorksheet ws, ProformaInvoice pi, string currency, int validity)
    {
        string piNumber = GetFormattedPiNumber(pi);
        var dateObj = pi.DataPi.DateTime;

        // ═══════════════ HEADER ═══════════════
        ws.Cells["A1:G6"].Style.Border.BorderAround(ExcelBorderStyle.Thick);
        ws.Cells["A1:G1"].Merge = true;
        ws.Cells["A1"].Value = "FERGUILE ESTOFADOS LTDA";
        ws.Cells["A1"].Style.Font.Bold = true;
        ws.Cells["A1"].Style.Font.Size = 13;
        
        ws.Cells["A2"].Value = "CNPJ: 27.499.537/0001-02";
        ws.Cells["A3"].Value = "DIRECCIÓN: RUA CANÁRIO DO BREJO, 630";
        ws.Cells["A4"].Value = "CÓDIGO POSTAL: 86703-797 - ARAPONGAS - PR";
        ws.Cells["A5"].Value = "INCOTERM: " + pi.Frete?.Nome + " - ARAPONGAS PR";
        ws.Cells["A6"].Value = "PAGO CONDICIONES: A VISTA";

        ws.Cells["H1:N6"].Style.Border.BorderAround(ExcelBorderStyle.Thick);
        ws.Cells["H1"].Value = "PROFORMA INVOICE: " + piNumber;
        ws.Cells["H1"].Style.Font.Bold = true;
        ws.Cells["H2"].Value = "FECHA: " + dateObj.ToString("dd/MM/yyyy");
        ws.Cells["H3"].Value = "IMPORTADOR:";
        ws.Cells["H3"].Style.Font.Bold = true;
        ws.Cells["H4"].Value = pi.Cliente?.Nome;
        ws.Cells["H5"].Value = "DIRECCIÓN: " + pi.Cliente?.Endereco;
        ws.Cells["H6"].Value = "NIT: " + pi.Cliente?.Nit;
        ws.Cells[1, 1, 6, 14].Style.Font.Size = 9;

        // ═══════════════ TABLE ═══════════════
        int startRow = 8;
        string unitLabel = currency == "BRL" ? "UNIT R$" : $"UNIT DOLAR {pi.CotacaoAtualUSD:N2}";
        string totalLabel = currency == "BRL" ? "TOTAL R$" : "TOTAL USD";
        
        bool showFreight = new[] { "FOB", "FCA", "CIF" }.Contains(pi.Frete?.Nome?.ToUpper());
        int unitCol = showFreight ? 14 : 13;
        int totalCol = showFreight ? 15 : 14;

        List<string> headerList = new List<string> { "FOTO", "REFERENCIA", "DESCRIPCIÓN", "MARCA", "LARG.", "ALT.", "PROF.", "CANT.", "TOTAL M3", "FABRIC", "TELA N", "OBSERVACIÓN" };
        if (showFreight) headerList.Add("FRETE");
        headerList.Add(unitLabel);
        headerList.Add(totalLabel);

        string[] headers = headerList.ToArray();
        for (int i = 0; i < headers.Length; i++)
        {
            var cell = ws.Cells[startRow, i + 1];
            cell.Value = headers[i];
            cell.Style.Font.Bold = true;
            cell.Style.Fill.PatternType = ExcelFillStyle.Solid;
            cell.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(44, 62, 80));
            cell.Style.Font.Color.SetColor(Color.White);
            cell.Style.Border.BorderAround(ExcelBorderStyle.Thin);
            cell.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
        }

        int currentRow = startRow + 1;
        var groups = pi.PiItens.GroupBy(i => i.ModuloTecido?.Modulo?.Marca).ToList();
        decimal totalQty = 0;
        decimal totalM3 = 0;
        decimal totalValue = 0;

        foreach (var group in groups)
        {
            var brand = group.Key;
            int groupStartRow = currentRow;
            foreach (var item in group)
            {
                ws.Cells[currentRow, 2].Value = brand?.Nome;
                ws.Cells[currentRow, 3].Value = item.ModuloTecido?.Modulo?.Descricao;
                ws.Cells[currentRow, 4].Value = brand?.Nome;
                ws.Cells[currentRow, 5].Value = item.Largura;
                ws.Cells[currentRow, 6].Value = item.Altura;
                ws.Cells[currentRow, 7].Value = item.Profundidade;
                ws.Cells[currentRow, 8].Value = item.Quantidade;
                ws.Cells[currentRow, 9].Value = item.M3 * item.Quantidade;
                ws.Cells[currentRow, 10].Value = item.ModuloTecido?.Tecido?.Nome;
                ws.Cells[currentRow, 11].Value = item.ModuloTecido?.CodigoModuloTecido;
                ws.Cells[currentRow, 12].Value = item.Observacao;

                decimal unitPrice = currency == "BRL" ? item.ValorFinalItemBRL / (item.Quantidade > 0 ? item.Quantidade : 1) : item.ValorEXW;
                decimal totalPrice = currency == "BRL" ? item.ValorFinalItemBRL : (item.ValorEXW * item.Quantidade);

                if (showFreight)
                {
                    ws.Cells[currentRow, 13].Value = currency == "BRL" ? item.ValorFreteRateadoBRL : item.ValorFreteRateadoUSD;
                }

                ws.Cells[currentRow, unitCol].Value = unitPrice;
                ws.Cells[currentRow, totalCol].Value = totalPrice;

                totalQty += item.Quantidade;
                totalM3 += (item.M3 * item.Quantidade);
                totalValue += totalPrice;

                ws.Row(currentRow).Height = 25;
                for (int i = 3; i <= totalCol; i++) ws.Cells[currentRow, i].Style.Border.BorderAround(ExcelBorderStyle.Thin);
                currentRow++;
            }
            ws.Cells[groupStartRow, 1, currentRow - 1, 1].Merge = true;
            ws.Cells[groupStartRow, 1].Style.Border.BorderAround(ExcelBorderStyle.Thin);
            ws.Cells[groupStartRow, 2, currentRow - 1, 2].Merge = true;
            ws.Cells[groupStartRow, 2].Style.Border.BorderAround(ExcelBorderStyle.Thin);
            ws.Cells[groupStartRow, 2].Style.Fill.PatternType = ExcelFillStyle.Solid;
            ws.Cells[groupStartRow, 2].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(239, 246, 255));
            ws.Cells[groupStartRow, 2].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
            ws.Cells[groupStartRow, 2].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

            if (brand?.Imagem != null)
            {
                using var ms = new MemoryStream(brand.Imagem);
                var pic = ws.Drawings.AddPicture($"PicF_{brand.Id}", ms);
                pic.SetPosition(groupStartRow - 1, 5, 0, 5);
                pic.SetSize(60, 60);
            }
            if (currentRow - groupStartRow == 1) ws.Row(groupStartRow).Height = 65;
        }

        // Summary Row Ferguile
        ws.Cells[currentRow, 1, currentRow, 7].Merge = true;
        ws.Cells[currentRow, 1].Value = "TOTAL";
        ws.Cells[currentRow, 1].Style.Font.Bold = true;
        ws.Cells[currentRow, 1].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
        ws.Cells[currentRow, 8].Value = totalQty;
        ws.Cells[currentRow, 9].Value = totalM3;
        ws.Cells[currentRow, totalCol].Value = totalValue;
        ws.Cells[currentRow, 8, currentRow, totalCol].Style.Font.Bold = true;
        for (int i = 1; i <= totalCol; i++) ws.Cells[currentRow, i].Style.Border.BorderAround(ExcelBorderStyle.Thin);
        ws.Cells[currentRow, 1, currentRow, totalCol].Style.Fill.PatternType = ExcelFillStyle.Solid;
        ws.Cells[currentRow, 1, currentRow, totalCol].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(248, 250, 252));
        currentRow++;

        ws.Cells[startRow + 1, 13, currentRow - 1, totalCol].Style.Numberformat.Format = currency == "BRL" ? "_-R$* #,##0.00_-" : "_-$* #,##0.00_-";
        ws.Cells[startRow + 1, 5, currentRow - 1, 9].Style.Numberformat.Format = "#,##0.00";

        ws.Column(3).Width = 35;
        ws.Column(10).Width = 20;

        // ═══════════════ FOOTER ═══════════════
        currentRow += 1;
        var footerRange = ws.Cells[currentRow, 1, currentRow + 6, 14];
        footerRange.Style.Border.BorderAround(ExcelBorderStyle.Thin);
        
        // Accounting Details (Left)
        ws.Cells[currentRow, 1].Value = "DETALLES BANCARIOS:";
        ws.Cells[currentRow, 1].Style.Font.Bold = true;
        ws.Cells[currentRow + 1, 1].Value = "Beneficiario: FERGUILE ESTOFADOS LTDA";
        ws.Cells[currentRow + 2, 1].Value = "CNPJ: 27.499.537/0001-02";
        ws.Cells[currentRow + 3, 1].Value = "BANCO: SICREDI 748";
        ws.Cells[currentRow + 4, 1].Value = "CUENTA BENEFICIARIA: 0723/032524";
        ws.Cells[currentRow + 5, 1].Value = "CÓDIGO IBAN: BR7001181521007230000003252C1";
        ws.Cells[currentRow + 6, 1].Value = "CÓDIGO SWIFT: BCSIBRRS748";

        // Product Data (Right)
        int rightCol = 8;

        ws.Cells[currentRow, rightCol].Value = "CBM M³: " + totalM3.ToString("N3");
        ws.Cells[currentRow, rightCol].Style.Font.Bold = true;
        ws.Cells[currentRow + 1, rightCol].Value = "TOTAL " + (currency == "BRL" ? "R$" : "USD") + ": " + (currency == "BRL" ? totalValue.ToString("N2") : totalValue.ToString("C2"));
        ws.Cells[currentRow + 2, rightCol].Value = "NCM: 94016100";
        ws.Cells[currentRow + 3, rightCol].Value = "Marca: Ferguile / Livintus";
        ws.Cells[currentRow + 4, rightCol].Value = "Productos originales de fábrica";
        ws.Cells[currentRow + 5, rightCol].Value = "P.B. TOTAL (KG): " + (totalM3 * 165).ToString("N2");
        ws.Cells[currentRow + 6, rightCol].Value = "Hecho en Brasil";

        ws.Cells[currentRow + 8, 1, currentRow + 8, totalCol].Merge = true;
        ws.Cells[currentRow + 8, 1].Value = $"* Esta proforma es válida por {validity} días a partir de la fecha de emisión.";
        ws.Cells[currentRow + 8, 1].Style.Font.Italic = true;
        ws.Cells[currentRow + 8, 1].Style.Font.Size = 8;
        
        ws.Cells[currentRow, 1, currentRow + 8, totalCol].Style.Font.Size = 9;
    }

    private string GetFormattedPiNumber(ProformaInvoice pi)
    {
        string baseNum = $"{pi.Prefixo}-{pi.PiSequencia}";
        var supplierName = pi.Fornecedor?.Nome?.ToLower() ?? "";
        if (supplierName.Contains("karams") || supplierName.Contains("koyo"))
        {
            DateTime dt = pi.DataPi.DateTime;
            string year = dt.Year.ToString().Substring(2);
            return $"{baseNum}/{year}";
        }
        return baseNum;
    }
}
