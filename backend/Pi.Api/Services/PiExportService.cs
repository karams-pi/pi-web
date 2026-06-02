using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Drawing;
using System.IO;
using Pi.Api.Models;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;

namespace Pi.Api.Services;

public class PiExportService
{
    private readonly AppDbContext _context;
    private class SupplierMetadata
    {
        public string Name { get; set; } = "";
        public string Cnpj { get; set; } = "";
        public string Address { get; set; } = "";
        public string City { get; set; } = "";
        public string Zip { get; set; } = "";
        public string State { get; set; } = "";
        public string Country { get; set; } = "BRASIL";
        public string Email { get; set; } = "";
        public string Website { get; set; } = "";
        public string Phone { get; set; } = "";
        public string Brand { get; set; } = "";
        public BankDetails Bank { get; set; } = new();
        public string Origin { get; set; } = "Hecho en Brasil";
    }

    private class BankDetails
    {
        public string? Intermediary { get; set; }
        public string? IntermediaryAddress { get; set; }
        public string? IntermediarySwift { get; set; }
        public string? IntermediaryAccount { get; set; }
        public string Beneficiary { get; set; } = "";
        public string BeneficiaryAddress { get; set; } = "";
        public string BeneficiarySwift { get; set; } = "";
        public string BeneficiaryIban { get; set; } = "";
        public string BeneficiaryAccount { get; set; } = "";
        public string BeneficiaryName { get; set; } = "";
    }

    private SupplierMetadata GetSupplierMetadata(string name)
    {
        var n = name.ToLower();
        if (n.Contains("koyo"))
        {
            return new SupplierMetadata
            {
                Name = "KOYO INDUSTRIA E COMERCIO DE ESTOFADOS LTDA",
                Cnpj = "02.670.170/0001-09",
                Address = "ROD PR 180 - KM 04 - LOTE 11 N8 B1 BAIRRO RURAL",
                City = "TERRA RICA", Zip = "87890-000", State = "PARANÁ",
                Email = "KOYO@KOYO.COM.BR", Website = "https://karams.com.br/", Phone = "(44) 3441-8400",
                Brand = "Koyo",
                Bank = new BankDetails {
                    Intermediary = "BANK OF AMERICA, N.A.", IntermediaryAddress = "NEW YORK - US", IntermediarySwift = "BOFAUS3N", IntermediaryAccount = "6550925836",
                    Beneficiary = "BANCO RENDIMENTO S/A", BeneficiaryAddress = "SÃO PAULO - BR", BeneficiarySwift = "RENDBRSP", BeneficiaryIban = "BR4468900810000010025069901i1", BeneficiaryAccount = "00250699000148", BeneficiaryName = "KOYO INDUSTRIA E COMERCIO DE ESTOFADOS LTDA"
                }
            };
        }
        if (n.Contains("livintus"))
        {
            return new SupplierMetadata
            {
                Name = "LIVINTUS ESTOFADOS LTDA",
                Cnpj = "27.499.537/0001-02",
                Address = "RUA CANÁRIO DO BREJO, 630 - RIBEIRÃO BANDEIRANTE DO NORTE",
                City = "ARAPONGAS", Zip = "86703-797", State = "PARANÁ",
                Email = "comercial@livintus.com.br", Website = "www.livintus.com.br", Phone = "(43) 3252-1234",
                Brand = "Livintus",
                Bank = new BankDetails {
                    Beneficiary = "SICREDI 748", BeneficiarySwift = "BCSIBRRS748", BeneficiaryIban = "BR7001181521007230000003252C1", BeneficiaryAccount = "0723/032524", BeneficiaryName = "LIVINTUS ESTOFADOS LTDA"
                }
            };
        }
        if (n.Contains("ferguile"))
        {
            return new SupplierMetadata
            {
                Name = "FERGUILE ESTOFADOS LTDA",
                Cnpj = "27.499.537/0001-02",
                Address = "RUA CANÁRIO DO BREJO, 630 - RIBEIRÃO BANDEIRANTE DO NORTE",
                City = "ARAPONGAS", Zip = "86703-797", State = "PARANÁ",
                Email = "financeiro@ferguile.com.br", Website = "www.ferguile.com.br", Phone = "(43) 3252-1234",
                Brand = "Ferguile",
                Bank = new BankDetails {
                    Beneficiary = "SICREDI 748", BeneficiarySwift = "BCSIBRRS748", BeneficiaryIban = "BR7001181521007230000003252C1", BeneficiaryAccount = "0723/032524", BeneficiaryName = "FERGUILE ESTOFADOS LTDA"
                }
            };
        }
        return new SupplierMetadata
        {
            Name = "KARAM'S INDUSTRIA E COMERCIO DE ESTOFADOS LTDA",
            Cnpj = "02.670.170/0001-09",
            Address = "ROD PR 180 - KM 04 - LOTE 11 N8 B1 BAIRRO RURAL",
            City = "TERRA RICA", Zip = "87890-000", State = "PARANÁ",
            Email = "KARAMS@KARAMS.COM.BR", Website = "https://karams.com.br/", Phone = "(44) 3441-8400 | (44) 3441-1908",
            Brand = "Karams",
            Bank = new BankDetails {
                Intermediary = "BANK OF AMERICA, N.A.", IntermediaryAddress = "NEW YORK - US", IntermediarySwift = "BOFAUS3N", IntermediaryAccount = "6550925836",
                Beneficiary = "BANCO RENDIMENTO S/A", BeneficiaryAddress = "SÃO PAULO - BR", BeneficiarySwift = "RENDBRSP", BeneficiaryIban = "BR4468900810000010025069901i1", BeneficiaryAccount = "00250699000148", BeneficiaryName = "KARAM'S INDUSTRIA E COMERCIO DE ESTOFADOS LTDA"
            }
        };
    }

    public PiExportService(AppDbContext context)

    {
        _context = context;
    }

    public async Task<byte[]> ExportToExcelAsync(long piId, string currency = "EXW", int validity = 30, string lang = "PT")
    {
        var pi = await _context.Pis
            .Include(p => p.Cliente)
            .Include(p => p.Fornecedor)
            .Include(p => p.Frete)
            .Include(p => p.Configuracoes)
            .Include(p => p.PiItensPecas)
                .ThenInclude(p => p.PiItens)
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
            .Include(p => p.PiItens)
                .ThenInclude(i => i.SubModulo!)
            .Include(p => p.PiItens)
                .ThenInclude(i => i.PiItemPeca)
            .FirstOrDefaultAsync(p => p.Id == piId);

        if (pi == null) throw new Exception("PI not found");

        using var package = new ExcelPackage();
        var ws = package.Workbook.Worksheets.Add("Proforma Invoice");

        // Configuração global da planilha
        ws.Cells.Style.Font.Name = "Arial";
        ws.Cells.Style.Font.Size = 10;

        var supplierName = pi.Fornecedor?.Nome ?? "";
        var metadata = GetSupplierMetadata(supplierName);
        
        bool isFerguileGroup = supplierName.Contains("Ferguile", StringComparison.OrdinalIgnoreCase) || 
                               supplierName.Contains("Livintus", StringComparison.OrdinalIgnoreCase);

        if (isFerguileGroup)
        {
            BuildFerguileLayout(ws, pi, currency, validity, metadata, lang);
        }
        else
        {
            BuildGenericLayout(ws, pi, currency, validity, metadata, lang);
        }


        return await package.GetAsByteArrayAsync();
    }

    private string t(string key, string lang)
    {
        var dict = new Dictionary<string, Dictionary<string, string>>
        {
            ["PT"] = new Dictionary<string, string> {
                ["IMPORTER"] = "IMPORTADOR:", ["ADDRESS"] = "ENDEREÇO:", ["CITY"] = "CIDADE:", ["COUNTRY"] = "PAÍS:", 
                ["NIT"] = "CNPJ:", ["PHONE"] = "TELEFONE:", ["RESPONSIBLE"] = "RESPONSÁVEL:", ["EMAIL"] = "EMAIL:",
                ["DATE"] = "DATA:", ["ORDER_DATE"] = "DATA PEDIDO:", ["SHIPMENT_POINT"] = "PONTO DE EMBARQUE:", ["DESTINATION_POINT"] = "PONTO DE DESTINO:",
                ["DELIVERY_TIME"] = "TEMPO DE ENTREGA:", ["INCOTERM"] = "INCOTERM:", ["PAYMENT_CONDITION"] = "CONDIÇÃO DE PAGAMENTO:",
                ["PHOTO"] = "FOTO", ["NAME"] = "NOME", ["DESCRIPTION"] = "DESCRIÇÃO", ["DIMENSIONS"] = "DIMENSÕES (m)",
                ["WIDTH"] = "LARG.", ["DEPTH"] = "PROF.", ["HEIGHT"] = "ALT.", ["QTY_UNIT"] = "QTD UNID", ["QTY_SOFA"] = "QTD SOFÁ",
                ["TOTAL_VOLUME"] = "VOL. TOTAL M³", ["FABRIC"] = "TECIDO", ["FEET"] = "PÉS", ["FINISHING"] = "ACABAMENTO", ["OBSERVATION"] = "OBSERVAÇÃO", ["FRETE"] = "FRETE",
                ["TOTAL"] = "TOTAL", ["BANK_DETAILS"] = "DADOS BANCÁRIOS:", ["INTERMEDIARY_BANK"] = "BANCO INTERMEDIÁRIO:", ["BENEFICIARY_BANK"] = "BANCO BENEFICIÁRIO:",
                ["PRODUCT_DATA"] = "DADOS GERAIS DO PRODUTO", ["VALIDITY_NOTE"] = "* Esta proforma é válida por {0} dias a partir da data de emissão.",
                ["ORIGIN"] = "Hecho en Brasil", ["BRAND"] = "MARCA", ["REFERENCIA"] = "REFERÊNCIA", ["UNIT"] = "UNITÁRIO", ["FABRIC_N"] = "TELA N"
            },
            ["ES"] = new Dictionary<string, string> {
                ["IMPORTER"] = "IMPORTADOR:", ["ADDRESS"] = "DIRECCIÓN:", ["CITY"] = "CIUDAD:", ["COUNTRY"] = "PAÍS:", 
                ["NIT"] = "NIT:", ["PHONE"] = "TELÉFONO:", ["RESPONSIBLE"] = "RESPONSABLE:", ["EMAIL"] = "EMAIL:",
                ["DATE"] = "FECHA:", ["ORDER_DATE"] = "PEDIDO FECHA:", ["SHIPMENT_POINT"] = "PUNTO DE EMBARQUE:", ["DESTINATION_POINT"] = "PUNTO DE DESTINO:",
                ["DELIVERY_TIME"] = "TIEMPO DE ENTREGA:", ["INCOTERM"] = "INCOTERM:", ["PAYMENT_CONDITION"] = "CONDICIÓN DE PAGO:",
                ["PHOTO"] = "FOTO", ["NAME"] = "NOMBRE", ["DESCRIPTION"] = "DESCRIPCIÓN", ["DIMENSIONS"] = "DIMENSIONES (m)",
                ["WIDTH"] = "LARG.", ["DEPTH"] = "Prof.", ["HEIGHT"] = "ALT.", ["QTY_UNIT"] = "CANT UNID", ["QTY_SOFA"] = "CANT SOFA",
                ["TOTAL_VOLUME"] = "TOTAL VOLUMEN M³", ["FABRIC"] = "TELA", ["FEET"] = "PIES", ["FINISHING"] = "ACABADO", ["OBSERVATION"] = "OBSERVACIÓN", ["FRETE"] = "FLETE",
                ["TOTAL"] = "TOTAL", ["BANK_DETAILS"] = "DETALLES BANCARIOS:", ["INTERMEDIARY_BANK"] = "BANCO INTERMEDIARIO:", ["BENEFICIARY_BANK"] = "BANCO BENEFICIARIO:",
                ["PRODUCT_DATA"] = "DATOS GENERALES DEL PRODUCTO", ["VALIDITY_NOTE"] = "* Esta proforma es válida por {0} días a partir de la fecha de emisión.",
                ["ORIGIN"] = "Hecho en Brasil", ["BRAND"] = "MARCA", ["REFERENCIA"] = "REFERENCIA", ["UNIT"] = "UNIT", ["FABRIC_N"] = "TELA N"
            },
            ["EN"] = new Dictionary<string, string> {
                ["IMPORTER"] = "IMPORTER:", ["ADDRESS"] = "ADDRESS:", ["CITY"] = "CITY:", ["COUNTRY"] = "COUNTRY:", 
                ["NIT"] = "TAX ID / VAT:", ["PHONE"] = "PHONE:", ["RESPONSIBLE"] = "RESPONSIBLE:", ["EMAIL"] = "EMAIL:",
                ["DATE"] = "DATE:", ["ORDER_DATE"] = "ORDER DATE:", ["SHIPMENT_POINT"] = "SHIPMENT POINT:", ["DESTINATION_POINT"] = "DESTINATION POINT:",
                ["DELIVERY_TIME"] = "DELIVERY TIME:", ["INCOTERM"] = "INCOTERM:", ["PAYMENT_CONDITION"] = "PAYMENT CONDITION:",
                ["PHOTO"] = "PHOTO", ["NAME"] = "NAME", ["DESCRIPTION"] = "DESCRIPTION", ["DIMENSIONS"] = "DIMENSIONS (m)",
                ["WIDTH"] = "WIDTH", ["DEPTH"] = "DEPTH", ["HEIGHT"] = "HEIGHT", ["QTY_UNIT"] = "QTY UNIT", ["QTY_SOFA"] = "QTY PIECE",
                ["TOTAL_VOLUME"] = "TOTAL M³", ["FABRIC"] = "FABRIC", ["FEET"] = "FEET", ["FINISHING"] = "FINISHING", ["OBSERVATION"] = "OBSERVATION", ["FRETE"] = "FREIGHT",
                ["TOTAL"] = "TOTAL", ["BANK_DETAILS"] = "BANKING DETAILS:", ["INTERMEDIARY_BANK"] = "INTERMEDIARY BANK:", ["BENEFICIARY_BANK"] = "BENEFICIARY BANK:",
                ["PRODUCT_DATA"] = "GENERAL PRODUCT DATA", ["VALIDITY_NOTE"] = "* This proforma is valid for {0} days from the date of issue.",
                ["ORIGIN"] = "Made in Brazil", ["BRAND"] = "BRAND", ["REFERENCIA"] = "REFERENCE", ["UNIT"] = "UNIT", ["FABRIC_N"] = "FABRIC N"
            }
        };

        var curLang = lang.ToUpper();
        if (!dict.ContainsKey(curLang)) curLang = "PT";
        
        return dict[curLang].ContainsKey(key) ? dict[curLang][key] : key;
    }

    private void BuildGenericLayout(ExcelWorksheet ws, ProformaInvoice pi, string currency, int validity, SupplierMetadata metadata, string lang)
    {
        string piNumber = GetFormattedPiNumber(pi);
        var dateObj = pi.DataPi.DateTime;

        // ═══════════════ TOP BAR ═══════════════
        ws.Cells["A1:Q1"].Style.Fill.PatternType = ExcelFillStyle.Solid;
        ws.Cells["A1:Q1"].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(0, 51, 102));

        // ═══════════════ HEADER ═══════════════
        ws.Cells["A2:Q2"].Merge = true;
        ws.Cells["A2"].Value = metadata.Name;
        ws.Cells["A2"].Style.Font.Bold = true;
        ws.Cells["A2"].Style.Font.Size = 13;
        ws.Cells["A2"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

        ws.Cells["A3:Q3"].Merge = true;
        ws.Cells["A3"].Value = $"CNPJ {metadata.Cnpj} | {metadata.Address} {metadata.Zip} {metadata.City} - {metadata.State}";
        ws.Cells["A3"].Style.Font.Size = 8;
        ws.Cells["A3"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
        
        ws.Cells["A4:Q4"].Merge = true;
        ws.Cells["A4"].Value = $"{metadata.Email} - {metadata.Website} | {metadata.Phone}";
        ws.Cells["A4"].Style.Font.Size = 8;
        ws.Cells["A4"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;


        ws.Cells["A5:Q5"].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
        
        ws.Row(1).Height = 5;
        ws.Row(2).Height = 25;
        ws.Row(3).Height = 15;
        ws.Row(4).Height = 15;
        ws.Row(5).Height = 10;
        for (int r = 6; r <= 13; r++) ws.Row(r).Height = 18;

        // ═══════════════ IMPORTER & PI DETAILS GRID ═══════════════
        int gridRow = 6;
        // Importer Column (Left)
        ws.Cells[gridRow, 1].Value = t("IMPORTER", lang);
        ws.Cells[gridRow, 1].Style.Font.Bold = true;
        ws.Cells[gridRow + 1, 1].Value = pi.Cliente?.Nome;
        ws.Cells[gridRow + 2, 1].Value = t("ADDRESS", lang) + " " + pi.Cliente?.Endereco;
        ws.Cells[gridRow + 3, 1].Value = t("CITY", lang) + " " + pi.Cliente?.Cidade;
        ws.Cells[gridRow + 4, 1].Value = t("COUNTRY", lang) + " " + (pi.Cliente?.Pais ?? "BRASIL");
        ws.Cells[gridRow + 5, 1].Value = t("NIT", lang) + " " + pi.Cliente?.Nit;
        ws.Cells[gridRow + 6, 1].Value = t("PHONE", lang) + " " + pi.Cliente?.Telefone;
        ws.Cells[gridRow + 7, 1].Value = t("RESPONSIBLE", lang) + " " + (pi.Cliente?.PessoaContato ?? "..") + " | " + t("EMAIL", lang) + " " + pi.Cliente?.Email;

        // PI Details Column (Right)
        int rightCol = 8;
        ws.Cells[gridRow, rightCol].Value = "PROFORMA INVOICE: " + piNumber;
        ws.Cells[gridRow, rightCol].Style.Font.Bold = true;
        ws.Cells[gridRow + 1, rightCol].Value = t("DATE", lang);
        ws.Cells[gridRow + 1, rightCol + 1].Value = dateObj.ToString("dd/MM/yyyy");
        ws.Cells[gridRow + 2, rightCol].Value = t("ORDER_DATE", lang);
        ws.Cells[gridRow + 2, rightCol + 1].Value = pi.DataPi.ToString("dd/MM/yyyy");
        ws.Cells[gridRow + 3, rightCol].Value = t("SHIPMENT_POINT", lang);
        ws.Cells[gridRow + 3, rightCol + 1].Value = pi.Configuracoes?.PortoEmbarque ?? "PARANAGUA";
        ws.Cells[gridRow + 4, rightCol].Value = t("DESTINATION_POINT", lang);
        ws.Cells[gridRow + 4, rightCol + 1].Value = pi.Cliente?.PortoDestino;
        ws.Cells[gridRow + 5, rightCol].Value = t("DELIVERY_TIME", lang);
        ws.Cells[gridRow + 5, rightCol + 1].Value = !string.IsNullOrWhiteSpace(pi.TempoEntrega) ? pi.TempoEntrega : (lang == "ES" ? "50 dias despues del primer pago" : (lang == "EN" ? "50 days after first payment" : "50 dias após o primeiro pagamento"));
        ws.Cells[gridRow + 6, rightCol].Value = t("INCOTERM", lang);
        ws.Cells[gridRow + 6, rightCol + 1].Value = $"{pi.Frete?.Nome} {pi.Configuracoes?.PortoEmbarque ?? ""}";
        ws.Cells[gridRow + 7, rightCol].Value = t("PAYMENT_CONDITION", lang);
        ws.Cells[gridRow + 7, rightCol + 1].Value = !string.IsNullOrWhiteSpace(pi.CondicaoPagamento) ? pi.CondicaoPagamento : (pi.Configuracoes?.CondicoesPagamento ?? "T/T");
        ws.Cells[gridRow, 1, gridRow + 7, 17].Style.Font.Size = 8;

        // ═══════════════ TABLE HEADER ═══════════════
        int startRow = 14;
        ws.Cells[startRow, 1, startRow + 1, 1].Merge = true; ws.Cells[startRow, 1].Value = t("PHOTO", lang);
        ws.Cells[startRow, 2, startRow + 1, 2].Merge = true; ws.Cells[startRow, 2].Value = t("NAME", lang);
        ws.Cells[startRow, 3, startRow + 1, 3].Merge = true; ws.Cells[startRow, 3].Value = t("DESCRIPTION", lang);
        ws.Cells[startRow, 4, startRow, 6].Merge = true; ws.Cells[startRow, 4].Value = t("DIMENSIONS", lang);
        ws.Cells[startRow + 1, 4].Value = t("WIDTH", lang);
        ws.Cells[startRow + 1, 5].Value = t("DEPTH", lang);
        ws.Cells[startRow + 1, 6].Value = t("HEIGHT", lang);
        ws.Cells[startRow, 7, startRow + 1, 7].Merge = true; ws.Cells[startRow, 7].Value = t("QTY_UNIT", lang);
        ws.Cells[startRow, 8, startRow + 1, 8].Merge = true; ws.Cells[startRow, 8].Value = t("QTY_SOFA", lang);
        ws.Cells[startRow, 9, startRow + 1, 9].Merge = true; ws.Cells[startRow, 9].Value = t("TOTAL_VOLUME", lang);
        ws.Cells[startRow, 10, startRow + 1, 10].Merge = true; ws.Cells[startRow, 10].Value = t("FABRIC", lang);
        ws.Cells[startRow, 11, startRow + 1, 11].Merge = true; ws.Cells[startRow, 11].Value = t("FEET", lang);
        ws.Cells[startRow, 12, startRow + 1, 12].Merge = true; ws.Cells[startRow, 12].Value = t("FINISHING", lang);
        ws.Cells[startRow, 13, startRow + 1, 13].Merge = true; ws.Cells[startRow, 13].Value = t("OBSERVATION", lang);

        int colIndividualEXW = 15;
        int colIndividualFreight = 14;
        int colGroupUnit = 16;
        int colGroupTotal = 17;
        int totalCol = colGroupTotal; // For footer compatibility

        ws.Cells[startRow, colIndividualEXW, startRow + 1, colIndividualEXW].Merge = true; 
        ws.Cells[startRow, colIndividualEXW].Value = currency == "BRL" ? "R$" : "USD";
        
        ws.Cells[startRow, colIndividualFreight, startRow + 1, colIndividualFreight].Merge = true; 
        ws.Cells[startRow, colIndividualFreight].Value = t("FRETE", lang);
        
        ws.Cells[startRow, colGroupUnit, startRow + 1, colGroupUnit].Merge = true; 
        ws.Cells[startRow, colGroupUnit].Value = currency == "BRL" ? $"UNIT R$ ({t("UNIT", lang)})" : "USD UNIT";
        
        ws.Cells[startRow, colGroupTotal, startRow + 1, colGroupTotal].Merge = true; 
        ws.Cells[startRow, colGroupTotal].Value = currency == "BRL" ? "TOTAL R$" : "TOTAL USD";

        var headerRange = ws.Cells[startRow, 1, startRow + 1, colGroupTotal];
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
            .OrderBy(g => g.Key?.Nome ?? "Outros")
            .ToList();
        
        var brandItemsMap = new Dictionary<long, List<PiItem>>();
        var brandRenderedItems = new List<PiItem>();

        foreach (var groupEntry in itemsByBrand)
        {
            var brand = groupEntry.Key;
            var sortedItems = groupEntry.OrderBy(i => i.ModuloTecido?.Tecido?.Nome ?? "ZZBase")
                                        .ThenBy(i => i.ModuloTecido?.Modulo?.Descricao ?? "")
                                        .ToList();

            brandRenderedItems.AddRange(sortedItems);
            brandItemsMap[brand?.Id ?? 0L] = sortedItems;
        }

        // ═══════════════ PRE-CALCULATE FREIGHTS & REPAIR VOLUMES ═══════════════
        foreach (var item in brandRenderedItems)
        {
            // Recover dimensions from master module if blank in line item
            if (item.Largura == 0 && item.ModuloTecido?.Modulo?.Largura > 0) item.Largura = item.ModuloTecido.Modulo.Largura;
            if (item.Profundidade == 0 && item.ModuloTecido?.Modulo?.Profundidade > 0) item.Profundidade = item.ModuloTecido.Modulo.Profundidade;
            if (item.Altura == 0 && item.ModuloTecido?.Modulo?.Altura > 0) item.Altura = item.ModuloTecido.Modulo.Altura;

            // Force volume calculation if missing or 0 (Meters vs CM logic)
            if (item.M3 == 0)
            {
                decimal calcM3 = (decimal)item.Largura * (decimal)item.Profundidade * (decimal)item.Altura;
                if (calcM3 > 500) item.M3 = calcM3 / 1000000;
                else if (calcM3 > 0) item.M3 = calcM3;
            }
        }

        decimal piTotalQty = pi.PiItens.Sum(i => (decimal)i.Quantidade);
        decimal piTotalM3 = pi.PiItens.Sum(i => Math.Round(i.M3 * (decimal)i.Quantidade, 2));
        decimal piTotalFreteUSD = pi.ValorTotalFreteUSD;
        decimal piTotalFreteBRL = pi.ValorTotalFreteBRL;

        var itemFreightUSD = new Dictionary<long, decimal>();
        var itemFreightBRL = new Dictionary<long, decimal>();
        decimal currentRemBRL = piTotalFreteBRL;
        decimal currentRemUSD = piTotalFreteUSD;

        for (int i = 0; i < brandRenderedItems.Count; i++)
        {
            var item = brandRenderedItems[i];
            bool isLast = i == brandRenderedItems.Count - 1;
            
            decimal fUnitBRL = 0;
            decimal fUnitUSD = 0;

            if (isLast)
            {
                fUnitBRL = item.Quantidade > 0 ? currentRemBRL / item.Quantidade : 0;
                fUnitUSD = item.Quantidade > 0 ? currentRemUSD / item.Quantidade : 0;
            }
            else
            {
                if (string.Equals(pi.TipoRateio, "IGUAL", System.StringComparison.OrdinalIgnoreCase))
                {
                    decimal rowShareBRL = brandRenderedItems.Count > 0 ? piTotalFreteBRL / brandRenderedItems.Count : 0;
                    decimal rowShareUSD = brandRenderedItems.Count > 0 ? piTotalFreteUSD / brandRenderedItems.Count : 0;
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

        decimal totalQty = 0;
        decimal totalM3 = 0;
        decimal totalValue = 0;

        foreach (var groupEntry in itemsByBrand)
        {
            var brand = groupEntry.Key;
            int groupStartRow = currentRow;
            var sortedItems = brandItemsMap[brand?.Id ?? 0L];

            int[] spanFabric = new int[sortedItems.Count];
            int[] spanFeet = new int[sortedItems.Count];
            int[] spanFinishing = new int[sortedItems.Count];
            int[] spanObservation = new int[sortedItems.Count];

            string GetMergeVal(int idx, string type) {
                var entry = sortedItems[idx];
                if (type == "fabric") return entry.ModuloTecido?.Tecido?.Nome ?? "Sem Tecido";
                if (type == "feet") return entry.Feet ?? "";
                if (type == "finishing") return entry.Finishing ?? "";
                if (type == "observation") return entry.Observacao ?? "";
                return "";
            }

            foreach (var field in new[] { "fabric", "feet", "finishing", "observation" }) {
                var arr = field == "fabric" ? spanFabric : field == "feet" ? spanFeet : field == "finishing" ? spanFinishing : spanObservation;
                
                for (int i = 0; i < sortedItems.Count; i++) {
                    if (arr[i] == -1) continue;
                    int span = 1;
                    string val = GetMergeVal(i, field);
                    for (int j = i + 1; j < sortedItems.Count; j++) {
                        if (GetMergeVal(j, field) == val) {
                            span++;
                            arr[j] = -1;
                        } else { break; }
                    }
                    arr[i] = span;
                }
            }

            for (int i = 0; i < sortedItems.Count; i++)
            {
                var item = sortedItems[i];
                bool isFirstOfGroup = spanFabric[i] > 0;

                if (isFirstOfGroup) {
                    int toRow = currentRow + spanFabric[i] - 1;
                    
                    var groupItems = sortedItems.Skip(i).Take(spanFabric[i]).ToList();
                    var descLines = groupItems.Select(g => (g.Quantidade > 1 ? $"{g.Quantidade} " : "") + (g.ModuloTecido?.Modulo?.Descricao ?? $"Modulo #{g.IdModuloTecido}")).ToList();
                    var rangeDesc = ws.Cells[currentRow, 3, toRow, 3];
                    rangeDesc.Merge = true;
                    rangeDesc.Value = string.Join("\r\n", descLines);
                    rangeDesc.Style.WrapText = true;
                    rangeDesc.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    rangeDesc.Style.Border.BorderAround(ExcelBorderStyle.Thin);

                    var rangeQtySofa = ws.Cells[currentRow, 8, toRow, 8];
                    rangeQtySofa.Merge = true;
                    rangeQtySofa.Value = item.PiItemPeca?.Quantidade ?? 1;
                    rangeQtySofa.Style.Font.Bold = true;
                    rangeQtySofa.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    rangeQtySofa.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    rangeQtySofa.Style.Border.BorderAround(ExcelBorderStyle.Thin);

                    string fName = item.ModuloTecido?.Tecido?.Nome ?? "Sem Tecido";
                    var codesInGroup = groupItems
                        .Select(gi => (gi.TempCodigoModuloTecido ?? gi.ModuloTecido?.CodigoModuloTecido ?? "").Trim())
                        .Where(c => !string.IsNullOrEmpty(c))
                        .Distinct()
                        .ToList();
                    
                    string fText = fName;
                    if (codesInGroup.Count == 1) fText += $" - {codesInGroup[0]}";

                    var rangeFabric = ws.Cells[currentRow, 10, toRow, 10];
                    rangeFabric.Merge = true;
                    rangeFabric.Value = fText;
                    rangeFabric.Style.Font.Color.SetColor(Color.FromArgb(22, 101, 52));
                    rangeFabric.Style.Fill.PatternType = ExcelFillStyle.Solid;
                    rangeFabric.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(240, 253, 244));
                    rangeFabric.Style.Font.Bold = true;
                    rangeFabric.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    rangeFabric.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    rangeFabric.Style.Border.BorderAround(ExcelBorderStyle.Thin);
                }

                // Individual columns
                ws.Cells[currentRow, 4].Value = item.Largura;
                ws.Cells[currentRow, 4].Style.Border.BorderAround(ExcelBorderStyle.Thin);
                ws.Cells[currentRow, 5].Value = item.Profundidade;
                ws.Cells[currentRow, 5].Style.Border.BorderAround(ExcelBorderStyle.Thin);
                ws.Cells[currentRow, 6].Value = item.Altura;
                ws.Cells[currentRow, 6].Style.Border.BorderAround(ExcelBorderStyle.Thin);
                ws.Cells[currentRow, 7].Value = item.Quantidade;
                ws.Cells[currentRow, 7].Style.Border.BorderAround(ExcelBorderStyle.Thin);
                decimal itemRowM3 = Math.Round(item.M3 * (decimal)item.Quantidade, 2);
                ws.Cells[currentRow, 9].Value = itemRowM3;
                ws.Cells[currentRow, 9].Style.Border.BorderAround(ExcelBorderStyle.Thin);

                // Individual Values per row
                decimal freightUnit = (currency == "BRL" ? itemFreightBRL[item.Id] : itemFreightUSD[item.Id]);

                decimal unitPriceBase = item.ValorEXW;
                if (currency == "BRL") unitPriceBase *= (decimal)pi.CotacaoRisco;
                
                decimal rowFreight = freightUnit * item.Quantidade;
                decimal rowUnitEXW = (unitPriceBase + freightUnit) * item.Quantidade;
                
                ws.Cells[currentRow, colIndividualEXW].Value = rowUnitEXW;
                ws.Cells[currentRow, colIndividualEXW].Style.Border.BorderAround(ExcelBorderStyle.Thin);
                ws.Cells[currentRow, colIndividualEXW].Style.Numberformat.Format = "#,##0.00";

                ws.Cells[currentRow, colIndividualFreight].Value = freightUnit * item.Quantidade;
                ws.Cells[currentRow, colIndividualFreight].Style.Border.BorderAround(ExcelBorderStyle.Thin);
                ws.Cells[currentRow, colIndividualFreight].Style.Fill.PatternType = ExcelFillStyle.Solid;
                ws.Cells[currentRow, colIndividualFreight].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(254, 252, 232));
                ws.Cells[currentRow, colIndividualFreight].Style.Numberformat.Format = "#,##0.00";

                // Group-level Values (Unit Sum and Total)
                if (isFirstOfGroup)
                {
                    int endRowGrp = currentRow + spanFabric[i] - 1;
                    decimal fabricGroupUnit = 0;
                    decimal fabricGroupTotalValue = 0;
                    
                    var groupItems = sortedItems.Skip(i).Take(spanFabric[i]).ToList();
                    foreach (var m in groupItems)
                    {
                        decimal mQty = m.Quantidade > 0 ? (decimal)m.Quantidade : 1m;
                        
                        // Use saved freight if available (strictly matching frontend)
                        decimal mFreight = m.ValorFreteRateadoUSD;
                        if (currency == "BRL") mFreight *= (decimal)pi.CotacaoRisco;

                        decimal mUnitEXW = m.ValorEXW;
                        if (currency == "BRL") mUnitEXW *= (decimal)pi.CotacaoRisco;
                        
                        // To match the screen's 'UNIT' column for Karams: (EXW + Freight) * TOTAL PI Modules
                        fabricGroupUnit += (mUnitEXW + mFreight) * mQty;
                    }
                    fabricGroupTotalValue = fabricGroupUnit * (item.PiItemPeca?.Quantidade ?? 1);

                    var rangeGroupUnit = ws.Cells[currentRow, colGroupUnit, endRowGrp, colGroupUnit];
                    rangeGroupUnit.Merge = true;
                    rangeGroupUnit.Value = fabricGroupUnit;
                    rangeGroupUnit.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    rangeGroupUnit.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    rangeGroupUnit.Style.Font.Bold = true;
                    rangeGroupUnit.Style.Border.BorderAround(ExcelBorderStyle.Thin);
                    rangeGroupUnit.Style.Numberformat.Format = "#,##0.00";

                    var rangeGroupTotal = ws.Cells[currentRow, colGroupTotal, endRowGrp, colGroupTotal];
                    rangeGroupTotal.Merge = true;
                    rangeGroupTotal.Value = fabricGroupTotalValue;
                    rangeGroupTotal.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    rangeGroupTotal.Style.Border.BorderAround(ExcelBorderStyle.Thin);
                    rangeGroupTotal.Style.Font.Bold = true;
                    rangeGroupTotal.Style.Numberformat.Format = "#,##0.00";

                    // Align global total with the sum of displayed piece groups to match the screen exactly
                    totalValue += fabricGroupTotalValue;
                }

                totalQty += item.Quantidade;
                totalM3 += itemRowM3;
                if (spanFabric[i] == 0 && item.IdPiItemPeca == null)
                {
                    // Single item fallback
                    decimal unitPriceRaw = item.ValorEXW + (item.ValorFreteRateadoUSD > 0 ? item.ValorFreteRateadoUSD : itemFreightUSD[item.Id]);
                    if (currency == "BRL") unitPriceRaw *= (decimal)pi.CotacaoRisco;
                    totalValue += unitPriceRaw * item.Quantidade;
                }

                if (spanFeet[i] > 0) {
                    int toRow = currentRow + spanFeet[i] - 1;
                    var range = ws.Cells[currentRow, 11, toRow, 11];
                    range.Merge = true; range.Value = item.Feet;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    range.Style.Border.BorderAround(ExcelBorderStyle.Thin);
                }
                if (spanFinishing[i] > 0) {
                    int toRow = currentRow + spanFinishing[i] - 1;
                    var range = ws.Cells[currentRow, 12, toRow, 12];
                    range.Merge = true; range.Value = item.Finishing;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    range.Style.Border.BorderAround(ExcelBorderStyle.Thin);
                }
                if (spanObservation[i] > 0) {
                    int toRow = currentRow + spanObservation[i] - 1;
                    var range = ws.Cells[currentRow, 13, toRow, 13];
                    range.Merge = true; range.Value = item.Observacao;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    range.Style.Border.BorderAround(ExcelBorderStyle.Thin);
                }
                
                ws.Row(currentRow).Height = 25;
                
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
                AddCenteredImage(ws, groupStartRow, currentRow - 1, brand.Imagem, $"Pic_{brand.Id}_{groupStartRow}");
            }
            // Set row height if merged photo needs space
            if (currentRow - groupStartRow == 1) ws.Row(groupStartRow).Height = 65;
        }

        // Summary Row Generic
        ws.Cells[currentRow, 1, currentRow, 6].Merge = true;
        ws.Cells[currentRow, 1].Value = "TOTAL:";
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

        // Centralização do conteúdo (Karams/Koyo)
        var dataRange = ws.Cells[startRow + 2, 1, currentRow - 1, totalCol];
        dataRange.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
        dataRange.Style.VerticalAlignment = ExcelVerticalAlignment.Center;

        // ═══════════════ FOOTER ═══════════════
        currentRow += 1;
        ws.Cells[currentRow, 1, currentRow + 10, 7].Style.Border.BorderAround(ExcelBorderStyle.Thin);
        ws.Cells[currentRow, 1].Value = t("BANK_DETAILS", lang) + " " + (metadata.Bank.Intermediary != null ? t("INTERMEDIARY_BANK", lang) : t("BENEFICIARY_BANK", lang));
        ws.Cells[currentRow, 1].Style.Font.Bold = true;
        
        int offset = 1;
        if (metadata.Bank.Intermediary != null)
        {
            ws.Cells[currentRow + offset, 1].Value = $"{metadata.Bank.Intermediary} | {t("ADDRESS", lang)} {metadata.Bank.IntermediaryAddress} | SWIFT: {metadata.Bank.IntermediarySwift}";
            ws.Cells[currentRow + offset + 1, 1].Value = $"CUENTA/ACCOUNT: {metadata.Bank.IntermediaryAccount}";
            offset += 3;
            ws.Cells[currentRow + offset, 1].Value = t("BENEFICIARY_BANK", lang) + " " + metadata.Bank.Beneficiary;
            ws.Cells[currentRow + offset, 1].Style.Font.Bold = true;
            offset += 1;
        }
        else
        {
            ws.Cells[currentRow + offset, 1].Value = t("BENEFICIARY_BANK", lang) + " " + metadata.Bank.Beneficiary;
            ws.Cells[currentRow + offset, 1].Style.Font.Bold = true;
            offset += 1;
        }
        
        ws.Cells[currentRow + offset, 1].Value = $"{t("ADDRESS", lang)} {metadata.Bank.BeneficiaryAddress} | SWIFT: {metadata.Bank.BeneficiarySwift}";
        ws.Cells[currentRow + offset + 1, 1].Value = $"IBAN: {metadata.Bank.BeneficiaryIban} | CUENTA/ACCOUNT: {metadata.Bank.BeneficiaryAccount}";
        ws.Cells[currentRow + offset + 2, 1].Value = t("NAME", lang) + ": " + metadata.Bank.BeneficiaryName;
        ws.Cells[currentRow, 1, currentRow + 10, 7].Style.Font.Size = 8;

        ws.Cells[currentRow, 8, currentRow + 10, totalCol].Style.Border.BorderAround(ExcelBorderStyle.Thin);
        ws.Cells[currentRow, 8].Value = t("PRODUCT_DATA", lang);
        ws.Cells[currentRow, 8].Style.Font.Bold = true;
        ws.Cells[currentRow + 1, 8].Value = t("BRAND", lang) + ": " + metadata.Brand;
        ws.Cells[currentRow + 2, 8].Value = "NCM: 94016100";
        ws.Cells[currentRow + 3, 8].Value = lang == "EN" ? "Product: " + totalQty : "Producto: " + totalQty;
        ws.Cells[currentRow + 4, 8].Value = "CBM M³: " + totalM3.ToString("N2");
        ws.Cells[currentRow + 5, 8].Value = "P.N. TOTAL:";
        ws.Cells[currentRow + 6, 8].Value = "P.B. TOTAL:";
        ws.Cells[currentRow + 7, 8].Value = lang == "EN" ? "TOTAL VOLUME: " + totalM3.ToString("N2") : "VOLUMEN TOTAL: " + totalM3.ToString("N2");
        ws.Cells[currentRow + 8, 8].Value = lang == "PT" ? "Produtos originais de fabrica" : (lang == "EN" ? "Original factory products" : "Productos originales de fabrica");
        ws.Cells[currentRow + 9, 8].Value = t("ORIGIN", lang);
        
        ws.Cells[currentRow + 11, 1, currentRow + 11, totalCol].Merge = true;
        ws.Cells[currentRow + 11, 1].Value = string.Format(t("VALIDITY_NOTE", lang), validity);
        ws.Cells[currentRow + 11, 1].Style.Font.Italic = true;
        ws.Cells[currentRow + 11, 1].Style.Font.Size = 8;

        ws.Cells[currentRow, 8, currentRow + 10, totalCol].Style.Font.Size = 8;

        ws.Column(1).Width = 15;
        ws.Column(2).Width = 15;
        ws.Column(3).Width = 35;
        ws.Column(10).Width = 20;
    }

    private void BuildFerguileLayout(ExcelWorksheet ws, ProformaInvoice pi, string currency, int validity, SupplierMetadata metadata, string lang)
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
        var colorRef   = Color.FromArgb(0xEF, 0xF6, 0xFF); // B: REFERENCIA - light blue
        var colorCode  = Color.White;                        // C: CODIGO - white
        var colorQty   = Color.FromArgb(0xEC, 0xF9, 0xE7); // J: CANT. - light green
        var colorTotal = Color.FromArgb(0xFF, 0xF3, 0xF3); // Q: TOTAL - light pink

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
                          $"CBM M\u00B3: {totalM3:N3}\n" +
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

    private void AddCenteredImage(ExcelWorksheet ws, int startRow, int endRow, byte[] imageBytes, string pictureName)
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
            float cellWidthPixels = (float)(ws.Column(1).Width > 0 ? ws.Column(1).Width : 10) * 7.5f;

            float availableWidth = cellWidthPixels - 6; // 3px padding on left/right
            float availableHeight = cellHeightPixels - 6; // 3px padding on top/bottom

            float scale = Math.Min(availableWidth / imgWidth, availableHeight / imgHeight);
            
            int newWidth = (int)(imgWidth * scale);
            int newHeight = (int)(imgHeight * scale);

            int leftOffset = (int)((cellWidthPixels - newWidth) / 2);
            int topOffset = (int)((cellHeightPixels - newHeight) / 2);

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
}
