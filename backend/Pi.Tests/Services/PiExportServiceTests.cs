using Xunit;
using FluentAssertions;
using OfficeOpenXml;
using Pi.Api.Services;
using Pi.Api.Models;
using Pi.Api.Data;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;
using System;
using System.Linq;

namespace Pi.Tests.Services;

public class PiExportServiceTests
{
    private readonly PiExportService _service;
    private readonly AppDbContext _context;

    public PiExportServiceTests()
    {
        ExcelPackage.License.SetNonCommercialPersonal("PI Web User");
        
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
        _context = new AppDbContext(options);
        _service = new PiExportService(_context);
    }

    [Theory]
    [InlineData("Koyo")]
    [InlineData("Ferguile")]
    public async Task ExportToExcel_ShouldIncludeFreteColumn_ForSpecifiedSuppliers(string supplierName)
    {
        // Arrange
        var supplier = new Fornecedor { Nome = supplierName };
        var client = new Cliente { Nome = "TestClient" };
        var freight = new Frete { Nome = "EXW" };
        var config = new Configuracao { PortoEmbarque = "PORT" };
        
        var pi = new ProformaInvoice
        {
            Id = supplierName == "Koyo" ? 1 : 2,
            Fornecedor = supplier,
            Cliente = client,
            Frete = freight,
            Configuracoes = config,
            PiSequencia = "00001",
            DataPi = DateTimeOffset.Now,
            PiItens = new List<PiItem>
            {
                new PiItem
                {
                    ModuloTecido = new ModuloTecido
                    {
                        Modulo = new Modulo 
                        { 
                            Descricao = "Test Mod", 
                            Marca = new Marca { Nome = "BrandX" },
                            Fornecedor = supplier,
                            Categoria = new Categoria { Nome = "Sofa" }
                        },
                        Tecido = new Tecido { Nome = "G1" }
                    },
                    Quantidade = 1,
                    Largura = 2.0m,
                    Profundidade = 1.0m,
                    Altura = 1.0m,
                    M3 = 2.0m,
                    ValorEXW = 100,
                    ValorFreteRateadoUSD = 10,
                    ValorFreteRateadoBRL = 50,
                    ValorFinalItemBRL = 500,
                    ValorFinalItemUSDRisco = 100,
                    RateioFrete = 10
                }
            }
        };

        _context.Pis.Add(pi);
        await _context.SaveChangesAsync();

        // Act
        var result = await _service.ExportToExcelAsync(pi.Id);

        // Assert
        using var stream = new System.IO.MemoryStream(result);
        using var package = new ExcelPackage(stream);
        var ws = package.Workbook.Worksheets[0];

        // Search for "FRETE" in headers
        bool foundFrete = false;
        var checkedCells = new List<string>();

        // Search the whole header area
        for (int row = 1; row <= 50; row++)
        {
            for (int col = 1; col <= 30; col++)
            {
                var val = ws.Cells[row, col].Value?.ToString();
                var text = ws.Cells[row, col].Text?.Trim();
                
                if (!string.IsNullOrWhiteSpace(val) || !string.IsNullOrWhiteSpace(text))
                {
                    checkedCells.Add($"R{row}C{col}:V={val}|T={text}");
                }

                if (val?.ToUpper() == "FRETE" || text?.ToUpper() == "FRETE" ||
                    (string.Equals(supplierName, "Ferguile", StringComparison.OrdinalIgnoreCase) && 
                     (val?.ToUpper() == "DESPESAS" || text?.ToUpper() == "DESPESAS")))
                {
                    foundFrete = true;
                    break;
                }
            }
            if (foundFrete) break;
        }

        if (!foundFrete)
        {
            var dump = string.Join("\n", checkedCells);
            throw new Exception($"Could not find 'FRETE' column for {supplierName}.\nCells found:\n{dump}");
        }

        foundFrete.Should().BeTrue();
    }

    [Theory]
    [InlineData("Koyo")]
    [InlineData("Ferguile")]
    [InlineData("Karams")]
    [InlineData("Livintus")]
    public async Task ExportToExcel_ShouldSetOrientationLandscapeAndProperFontSizes(string supplierName)
    {
        // Arrange
        var supplier = new Fornecedor { Nome = supplierName };
        var client = new Cliente { Nome = "TestClient", Endereco = "Street 1", Nit = "123" };
        var freight = new Frete { Nome = "EXW" };
        var config = new Configuracao { PortoEmbarque = "PORT" };
        
        var pi = new ProformaInvoice
        {
            Fornecedor = supplier,
            Cliente = client,
            Frete = freight,
            Configuracoes = config,
            PiSequencia = "00003",
            DataPi = DateTimeOffset.Now,
            PiItens = new List<PiItem>
            {
                new PiItem
                {
                    ModuloTecido = new ModuloTecido
                    {
                        Modulo = new Modulo 
                        { 
                            Descricao = "Test Modulo", 
                            Marca = new Marca { Nome = "BrandTest" },
                            Fornecedor = supplier,
                            Categoria = new Categoria { Nome = "Sofa" }
                        },
                        Tecido = new Tecido { Nome = "TecidoTest" }
                    },
                    Quantidade = 1,
                    Largura = 2.0m,
                    Profundidade = 1.0m,
                    Altura = 1.0m,
                    M3 = 2.0m,
                    ValorEXW = 100,
                    ValorFreteRateadoUSD = 10
                }
            }
        };

        _context.Pis.Add(pi);
        await _context.SaveChangesAsync();

        // Act
        var result = await _service.ExportToExcelAsync(pi.Id);

        // Assert
        using var stream = new System.IO.MemoryStream(result);
        using var package = new ExcelPackage(stream);
        var ws = package.Workbook.Worksheets[0];

        // 1. Check landscape orientation and page setup
        ws.PrinterSettings.Orientation.Should().Be(eOrientation.Landscape);
        ws.PrinterSettings.PaperSize.Should().Be(ePaperSize.A4);
        ws.PrinterSettings.FitToPage.Should().BeTrue();
        ws.PrinterSettings.FitToWidth.Should().Be(1);

        // 2. Check data rows font size is 48
        if (supplierName == "Ferguile" || supplierName == "Livintus")
        {
            ws.Cells[11, 7].Style.Font.Size.Should().Be(48);
        }
        else
        {
            ws.Cells[16, 4].Style.Font.Size.Should().Be(48);
        }

        // 3. For generic vs ferguile layouts, check header and footer fonts are 72
        if (supplierName == "Ferguile" || supplierName == "Livintus")
        {
            // Supplier block in header
            ws.Cells["A1"].Style.Font.Size.Should().Be(72);
            // Importer block in header
            ws.Cells["J1"].Style.Font.Size.Should().Be(72);
            // Table header
            ws.Cells[10, 1].Style.Font.Size.Should().Be(72);
            // Footer bank block
            int bankRow = 0;
            for (int r = 11; r <= 35; r++)
            {
                if (ws.Cells[r, 1].Text.Contains("BANK", StringComparison.OrdinalIgnoreCase) ||
                    ws.Cells[r, 1].Text.Contains("DADOS BANC", StringComparison.OrdinalIgnoreCase))
                {
                    bankRow = r;
                    break;
                }
            }
            bankRow.Should().BeGreaterThan(0);
            ws.Cells[bankRow, 1].Style.Font.Size.Should().Be(72);
        }
        else
        {
            // Generic layout: Company name, CNPJ, Contact
            ws.Cells["A2"].Style.Font.Size.Should().Be(72);
            ws.Cells["A3"].Style.Font.Size.Should().Be(72);
            ws.Cells["A4"].Style.Font.Size.Should().Be(72);
            // Importer & PI info grid
            ws.Cells[6, 1].Style.Font.Size.Should().Be(72);
            // Table header (row 14)
            ws.Cells[14, 1].Style.Font.Size.Should().Be(72);
            // Footer bank block
            int bankRow = 0;
            for (int r = 16; r <= 40; r++)
            {
                if (ws.Cells[r, 1].Text.Contains("BANK", StringComparison.OrdinalIgnoreCase) ||
                    ws.Cells[r, 1].Text.Contains("DADOS BANC", StringComparison.OrdinalIgnoreCase))
                {
                    bankRow = r;
                    break;
                }
            }
            bankRow.Should().BeGreaterThan(0);
            ws.Cells[bankRow, 1].Style.Font.Size.Should().Be(72);
        }
    }
}
