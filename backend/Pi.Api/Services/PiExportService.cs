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
                ["TOTAL_VOLUME"] = "VOL. TOTAL M³", ["FABRIC"] = "TECIDO", ["FEET"] = "PÉS", ["FINISHING"] = "ACABAMENTO", ["OBSERVATION"] = "OBSERVAÇÃO",
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
                ["TOTAL_VOLUME"] = "TOTAL VOLUMEN M³", ["FABRIC"] = "TELA", ["FEET"] = "PIES", ["FINISHING"] = "ACABADO", ["OBSERVATION"] = "OBSERVACIÓN",
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
                ["TOTAL_VOLUME"] = "TOTAL M³", ["FABRIC"] = "FABRIC", ["FEET"] = "FEET", ["FINISHING"] = "FINISHING", ["OBSERVATION"] = "OBSERVATION",
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
        ws.Cells["A1:O1"].Style.Fill.PatternType = ExcelFillStyle.Solid;
        ws.Cells["A1:O1"].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(0, 51, 102));

        // ═══════════════ HEADER ═══════════════
        ws.Cells["A2:O2"].Merge = true;
        ws.Cells["A2"].Value = metadata.Name;
        ws.Cells["A2"].Style.Font.Bold = true;
        ws.Cells["A2"].Style.Font.Size = 13;
        ws.Cells["A2"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

        ws.Cells["A3:O3"].Merge = true;
        ws.Cells["A3"].Value = $"CNPJ {metadata.Cnpj} | {metadata.Address} {metadata.Zip} {metadata.City} - {metadata.State}";
        ws.Cells["A3"].Style.Font.Size = 8;
        ws.Cells["A3"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
        
        ws.Cells["A4:O4"].Merge = true;
        ws.Cells["A4"].Value = $"{metadata.Email} - {metadata.Website} | {metadata.Phone}";
        ws.Cells["A4"].Style.Font.Size = 8;
        ws.Cells["A4"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;


        ws.Cells["A5:O5"].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;

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
        ws.Cells[gridRow + 7, 1].Value = t("RESPONSIBLE", lang) + " " + (pi.Cliente?.PessoaContato ?? "..");
        ws.Cells[gridRow + 8, 1].Value = t("EMAIL", lang) + " " + pi.Cliente?.Email;

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
        ws.Cells[gridRow, 1, gridRow + 8, 15].Style.Font.Size = 8;

        // ═══════════════ TABLE HEADER ═══════════════
        int startRow = 15;
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

        int colIndividualEXW = 14;
        int colIndividualFreight = 15;
        int colGroupUnit = 16;
        int colGroupTotal = 17;
        int totalCol = colGroupTotal; // For footer compatibility

        ws.Cells[startRow, colIndividualEXW, startRow + 1, colIndividualEXW].Merge = true; 
        ws.Cells[startRow, colIndividualEXW].Value = currency == "BRL" ? "R$" : "USD";
        
        ws.Cells[startRow, colIndividualFreight, startRow + 1, colIndividualFreight].Merge = true; 
        ws.Cells[startRow, colIndividualFreight].Value = t("FRETE", lang);
        
        ws.Cells[startRow, colGroupUnit, startRow + 1, colGroupUnit].Merge = true; 
        ws.Cells[startRow, colGroupUnit].Value = currency == "BRL" ? $"UNIT R$ ({t("UNIT", lang)})" : $"UNIT DOLAR ({t("UNIT", lang)})";
        
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
            .ToList();

        decimal piTotalM3 = pi.PiItens.Sum(i => i.M3 * i.Quantidade);
        decimal piTotalFreteUSD = pi.ValorTotalFreteUSD;
        decimal piTotalFreteBRL = pi.ValorTotalFreteBRL;

        decimal totalQty = 0;
        decimal totalM3 = 0;
        decimal totalValue = 0;


        foreach (var group in itemsByBrand)
        {
            var brand = group.Key;
            int groupStartRow = currentRow;
            
            var sortedItems = group.OrderBy(i => i.ModuloTecido?.Tecido?.Nome ?? "ZZBase")
                                   .ThenBy(i => i.ModuloTecido?.Modulo?.Descricao ?? "")
                                   .ToList();

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
                    rangeQtySofa.Value = item.Quantidade;
                    rangeQtySofa.Style.Font.Bold = true;
                    rangeQtySofa.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    rangeQtySofa.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    rangeQtySofa.Style.Border.BorderAround(ExcelBorderStyle.Thin);

                    string fName = item.ModuloTecido?.Tecido?.Nome ?? "Sem Tecido";
                    string fCode = item.TempCodigoModuloTecido ?? item.ModuloTecido?.CodigoModuloTecido ?? "";
                    string fText = string.IsNullOrEmpty(fCode) ? fName : $"{fName} - {fCode}";
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
                ws.Cells[currentRow, 9].Value = item.M3 * item.Quantidade;
                ws.Cells[currentRow, 9].Style.Border.BorderAround(ExcelBorderStyle.Thin);

                // Individual Values per row
                decimal rowUnitEXW = item.ValorEXW;
                if (currency == "BRL") rowUnitEXW *= (decimal)pi.CotacaoRisco;
                
                ws.Cells[currentRow, colIndividualEXW].Value = rowUnitEXW;
                ws.Cells[currentRow, colIndividualEXW].Style.Border.BorderAround(ExcelBorderStyle.Thin);
                ws.Cells[currentRow, colIndividualEXW].Style.Numberformat.Format = "#,##0.00";

                decimal freightUnit = piTotalM3 > 0
                    ? (currency == "BRL" ? piTotalFreteBRL : piTotalFreteUSD) / piTotalM3 * item.M3
                    : 0;
                ws.Cells[currentRow, colIndividualFreight].Value = freightUnit;
                ws.Cells[currentRow, colIndividualFreight].Style.Border.BorderAround(ExcelBorderStyle.Thin);
                ws.Cells[currentRow, colIndividualFreight].Style.Fill.PatternType = ExcelFillStyle.Solid;
                ws.Cells[currentRow, colIndividualFreight].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(254, 252, 232));
                ws.Cells[currentRow, colIndividualFreight].Style.Numberformat.Format = "#,##0.00";

                // Group-level Values (Unit Sum and Total)
                if (isFirstOfGroup)
                {
                    int endRowGrp = currentRow + spanFabric[i] - 1;
                    decimal fabricGroupUnit = 0;
                    decimal fabricGroupTotal = 0;
                    
                    var groupItems = sortedItems.Skip(i).Take(spanFabric[i]).ToList();
                    foreach (var g in groupItems)
                    {
                        decimal mQty = g.Quantidade > 0 ? (decimal)g.Quantidade : 1m;
                        decimal mUnitEXW = g.ValorEXW;
                        if (currency == "BRL") mUnitEXW *= (decimal)pi.CotacaoRisco;
                        
                        fabricGroupUnit += mUnitEXW;

                        decimal mFreight = piTotalM3 > 0 
                            ? (currency == "BRL" ? piTotalFreteBRL : piTotalFreteUSD) / piTotalM3 * g.M3 
                            : 0;
                        
                        fabricGroupTotal += (mUnitEXW + mFreight) * mQty;
                    }

                    var rangeGroupUnit = ws.Cells[currentRow, colGroupUnit, endRowGrp, colGroupUnit];
                    rangeGroupUnit.Merge = true;
                    rangeGroupUnit.Value = fabricGroupUnit;
                    rangeGroupUnit.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    rangeGroupUnit.Style.Border.BorderAround(ExcelBorderStyle.Thin);
                    rangeGroupUnit.Style.Numberformat.Format = "#,##0.00";

                    var rangeGroupTotal = ws.Cells[currentRow, colGroupTotal, endRowGrp, colGroupTotal];
                    rangeGroupTotal.Merge = true;
                    rangeGroupTotal.Value = fabricGroupTotal;
                    rangeGroupTotal.Style.Font.Bold = true;
                    rangeGroupTotal.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    rangeGroupTotal.Style.Border.BorderAround(ExcelBorderStyle.Thin);
                    rangeGroupTotal.Style.Numberformat.Format = "#,##0.00";
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
                
                totalQty += item.Quantidade;
                totalM3 += (item.M3 * item.Quantidade);
                // The total value calculates per item in the global scope
                totalValue += (currency == "BRL" ? item.ValorFinalItemBRL : item.ValorFinalItemUSDRisco);
                
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
                var pic = ws.Drawings.AddPicture($"Pic_{brand.Id}_{groupStartRow}", ms);
                pic.SetPosition(groupStartRow - 1, 5, 0, 5);
                pic.SetSize(60, 60);
            }
            // Set row height if merged photo needs space
            if (currentRow - groupStartRow == 1) ws.Row(groupStartRow).Height = 65;
        }

        // Summary Row Generic
        ws.Cells[currentRow, 1, currentRow, 6].Merge = true;
        ws.Cells[currentRow, 1].Value = t("TOTAL", lang);
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
        ws.Cells[currentRow + 4, 8].Value = "CBM M³: " + totalM3.ToString("N3");
        ws.Cells[currentRow + 5, 8].Value = "P.N. TOTAL:";
        ws.Cells[currentRow + 6, 8].Value = "P.B. TOTAL:";
        ws.Cells[currentRow + 7, 8].Value = lang == "EN" ? "TOTAL VOLUME: " + totalM3.ToString("N3") : "VOLUMEN TOTAL: " + totalM3.ToString("N3");
        ws.Cells[currentRow + 8, 8].Value = lang == "PT" ? "Produtos originais de fabrica" : (lang == "EN" ? "Original factory products" : "Productos originales de fabrica");
        ws.Cells[currentRow + 9, 8].Value = t("ORIGIN", lang);
        
        ws.Cells[currentRow + 11, 1, currentRow + 11, totalCol].Merge = true;
        ws.Cells[currentRow + 11, 1].Value = string.Format(t("VALIDITY_NOTE", lang), validity);
        ws.Cells[currentRow + 11, 1].Style.Font.Italic = true;
        ws.Cells[currentRow + 11, 1].Style.Font.Size = 8;

        ws.Cells[currentRow, 8, currentRow + 10, totalCol].Style.Font.Size = 8;

        ws.Column(1).Width = 10;
        ws.Column(2).Width = 15;
        ws.Column(3).Width = 35;
        ws.Column(10).Width = 20;
    }

    private void BuildFerguileLayout(ExcelWorksheet ws, ProformaInvoice pi, string currency, int validity, SupplierMetadata metadata)
    {
        string piNumber = GetFormattedPiNumber(pi);
        var dateObj = pi.DataPi.DateTime;

        // ═══════════════ HEADER ═══════════════
        ws.Cells["A1:G6"].Style.Border.BorderAround(ExcelBorderStyle.Thick);
        ws.Cells["A1:G1"].Merge = true;
        ws.Cells["A1"].Value = metadata.Name;
        ws.Cells["A1"].Style.Font.Bold = true;
        ws.Cells["A1"].Style.Font.Size = 13;
        
        ws.Cells["A2"].Value = t("NIT", lang) + " " + metadata.Cnpj;
        ws.Cells["A3"].Value = t("ADDRESS", lang) + " " + metadata.Address;
        ws.Cells["A5"].Value = (lang == "ES" ? "CÓDIGO POSTAL: " : (lang == "EN" ? "ZIP CODE: " : "CEP: ")) + metadata.Zip + " - " + metadata.City + " - " + metadata.State;
        ws.Cells["A6"].Value = t("COUNTRY", lang) + " " + metadata.Country;
        ws.Cells["A7"].Value = t("DELIVERY_TIME", lang) + " " + (!string.IsNullOrWhiteSpace(pi.TempoEntrega) ? pi.TempoEntrega : "60 dias");
        ws.Cells["A8"].Value = t("INCOTERM", lang) + " " + pi.Frete?.Nome + " - ARAPONGAS PR";
        ws.Cells["A9"].Value = t("PAYMENT_CONDITION", lang) + " " + (!string.IsNullOrWhiteSpace(pi.CondicaoPagamento) ? pi.CondicaoPagamento : (pi.Configuracoes?.CondicoesPagamento ?? "A VISTA"));
        ws.Cells["A10"].Value = "";


        ws.Cells["H1:N9"].Style.Border.BorderAround(ExcelBorderStyle.Thick);
        ws.Cells["H1"].Value = "PROFORMA INVOICE: " + piNumber;
        ws.Cells["H1"].Style.Font.Bold = true;
        ws.Cells["H2"].Value = t("DATE", lang) + " " + dateObj.ToString("dd/MM/yyyy");
        ws.Cells["H3"].Value = t("ORDER_DATE", lang) + " " + dateObj.ToString("dd/MM/yyyy");
        ws.Cells["H4"].Value = t("IMPORTER", lang);
        ws.Cells["H4"].Style.Font.Bold = true;
        ws.Cells["H5"].Value = pi.Cliente?.Nome;
        ws.Cells["H6"].Value = t("ADDRESS", lang) + " " + pi.Cliente?.Endereco + (string.IsNullOrEmpty(pi.Cliente?.Cidade) ? "" : ", " + pi.Cliente.Cidade);
        ws.Cells["H7"].Value = (lang == "ES" ? "CÓDIGO POSTAL: " : (lang == "EN" ? "ZIP CODE: " : "CEP: ")) + pi.Cliente?.Cep;
        ws.Cells["H8"].Value = t("NIT", lang) + " " + pi.Cliente?.Nit;
        ws.Cells["H9"].Value = t("RESPONSIBLE", lang) + " " + (pi.Cliente?.PessoaContato ?? "..");
        ws.Cells[1, 1, 10, 14].Style.Font.Size = 8;

        // ═══════════════ TABLE ═══════════════
        int startRow = 10;
        string currentCurrency = currency?.Trim().ToUpper() ?? "EXW";
        string unitLabel = currentCurrency == "BRL" ? $"UNIT R$ ({t("UNIT", lang)})" : $"UNIT DOLAR ({t("UNIT", lang)})";
        string totalLabel = currentCurrency == "BRL" ? "TOTAL R$" : "TOTAL USD";
        
        bool showFreight = true; // Always show in Excel as requested
        int unitCol = 13;
        int totalCol = 14;

        List<string> headerList = new List<string> { 
            t("PHOTO", lang), t("REFERENCIA", lang), t("DESCRIPTION", lang), t("BRAND", lang), 
            t("WIDTH", lang), t("HEIGHT", lang), t("DEPTH", lang), t("QTY_UNIT", lang).Replace(" UNID", ""), 
            t("TOTAL_VOLUME", lang), t("FABRIC", lang), t("FABRIC_N", lang), t("OBSERVATION", lang) 
        };
        
        if (showFreight)
        {
            headerList.Add(t("FRETE", lang));
            unitCol = 14;
            totalCol = 15;
        }

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

        // Recalculate freight exactly as the screen does
        decimal piTotalM3 = pi.PiItens.Sum(i => i.M3 * i.Quantidade);
        decimal piTotalFreteUSD = pi.ValorTotalFreteUSD;
        decimal piTotalFreteBRL = pi.ValorTotalFreteBRL;

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
                ws.Cells[currentRow, 4].Value = item.ModuloTecido?.Modulo?.Fornecedor?.Nome ?? item.ModuloTecido?.Modulo?.Categoria?.Nome ?? metadata.Brand;
                ws.Cells[currentRow, 5].Value = item.Largura;

                ws.Cells[currentRow, 6].Value = item.Altura;
                ws.Cells[currentRow, 7].Value = item.Profundidade;
                ws.Cells[currentRow, 8].Value = item.Quantidade;
                ws.Cells[currentRow, 9].Value = item.M3 * item.Quantidade;
                ws.Cells[currentRow, 10].Value = item.ModuloTecido?.Tecido?.Nome;
                ws.Cells[currentRow, 11].Value = item.ModuloTecido?.CodigoModuloTecido;
                ws.Cells[currentRow, 12].Value = item.Observacao;

                if (showFreight)
                {
                    // Recalculate like the screen: totalFrete / totalM3 * itemM3
                    decimal freightUnit = piTotalM3 > 0
                        ? (currency == "BRL" ? piTotalFreteBRL : piTotalFreteUSD) / piTotalM3 * item.M3
                        : 0;
                    ws.Cells[currentRow, 13].Value = freightUnit;
                    ws.Cells[currentRow, 13].Style.Border.BorderAround(ExcelBorderStyle.Thin);
                }

                // UNIT = EXW (unit price, same as original working code)
                // TOTAL = (EXW + freight) * qty, to match screen's ValorFinalItemUSDRisco logic
                decimal freightUnitForTotal = piTotalM3 > 0
                    ? (currency == "BRL" ? piTotalFreteBRL : piTotalFreteUSD) / piTotalM3 * item.M3
                    : 0;
                decimal unitPrice = currency == "BRL"
                    ? item.ValorEXW * (decimal)pi.CotacaoRisco
                    : item.ValorEXW;
                decimal totalPrice = currency == "BRL"
                    ? item.ValorFinalItemBRL
                    : (item.ValorEXW + freightUnitForTotal) * item.Quantidade;

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
                var pic = ws.Drawings.AddPicture($"PicF_{brand.Id}_{groupStartRow}", ms);
                pic.SetPosition(groupStartRow - 1, 5, 0, 5);
                pic.SetSize(60, 60);
            }
            if (currentRow - groupStartRow == 1) ws.Row(groupStartRow).Height = 65;
        }

        // Summary Row Ferguile
        ws.Cells[currentRow, 1, currentRow, 7].Merge = true;
        ws.Cells[currentRow, 1].Value = t("TOTAL", lang);
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
        var footerRange = ws.Cells[currentRow, 1, currentRow + 10, totalCol];
        footerRange.Style.Border.BorderAround(ExcelBorderStyle.Thin);
        
        // Accounting Details (Left)
        ws.Cells[currentRow, 1].Value = t("BANK_DETAILS", lang);
        ws.Cells[currentRow, 1].Style.Font.Bold = true;
        ws.Cells[currentRow + 1, 1].Value = t("NAME", lang) + ": " + metadata.Bank.BeneficiaryName;
        ws.Cells[currentRow + 2, 1].Value = t("NIT", lang) + " " + metadata.Cnpj;
        ws.Cells[currentRow + 3, 1].Value = (lang == "EN" ? "BANK: " : "BANCO: ") + metadata.Bank.Beneficiary;
        ws.Cells[currentRow + 4, 1].Value = (lang == "EN" ? "BENEFICIARY ACCOUNT: " : "CUENTA BENEFICIARIA: ") + metadata.Bank.BeneficiaryAccount;
        ws.Cells[currentRow + 5, 1].Value = "IBAN: " + metadata.Bank.BeneficiaryIban;
        ws.Cells[currentRow + 6, 1].Value = "SWIFT: " + metadata.Bank.BeneficiarySwift;


        // Product Data (Right)
        int rightCol = 8;

        ws.Cells[currentRow, rightCol].Value = t("PRODUCT_DATA", lang);
        ws.Cells[currentRow, rightCol].Style.Font.Bold = true;
        ws.Cells[currentRow + 1, rightCol].Value = t("BRAND", lang) + ": " + metadata.Brand;
        ws.Cells[currentRow + 2, rightCol].Value = "NCM: 94016100";
        ws.Cells[currentRow + 3, rightCol].Value = lang == "EN" ? "Product: " + totalQty : "Producto: " + totalQty;
        ws.Cells[currentRow + 4, rightCol].Value = "CBM M³: " + totalM3.ToString("N3");
        ws.Cells[currentRow + 5, rightCol].Value = "P.N. TOTAL:";
        ws.Cells[currentRow + 6, rightCol].Value = "P.B. TOTAL:";
        ws.Cells[currentRow + 7, rightCol].Value = lang == "EN" ? "TOTAL VOLUME: " + totalM3.ToString("N3") : "VOLUMEN TOTAL: " + totalM3.ToString("N3");
        ws.Cells[currentRow + 8, rightCol].Value = lang == "PT" ? "Produtos originais de fabrica" : (lang == "EN" ? "Original factory products" : "Productos originales de fabrica");
        ws.Cells[currentRow + 9, rightCol].Value = t("ORIGIN", lang);

        ws.Cells[currentRow + 11, 1, currentRow + 11, totalCol].Merge = true;
        ws.Cells[currentRow + 11, 1].Value = string.Format(t("VALIDITY_NOTE", lang), validity);
        ws.Cells[currentRow + 11, 1].Style.Font.Italic = true;
        ws.Cells[currentRow + 11, 1].Style.Font.Size = 8;
        
        ws.Cells[currentRow, 1, currentRow + 10, totalCol].Style.Font.Size = 9;
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
