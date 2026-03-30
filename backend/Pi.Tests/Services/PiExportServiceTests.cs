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
    [InlineData("Koyo", true)]
    [InlineData("Ferguile", true)]
    public async Task ExportToExcel_ShouldIncludeFreteColumn_ForSpecifiedSuppliers(string supplierName, bool expectedFrete)
    {
        // Arrange
        var supplier = new Fornecedor { Nome = supplierName };
        var client = new Cliente { Nome = "TestClient" };
        var freight = new Frete { Nome = "EXW" };
        var config = new Configuracao { PortoEmbarque = "PORT" };
        
        var pi = new ProformaInvoice
        {
            Id = 1,
            Fornecedor = supplier,
            Cliente = client,
            Frete = freight,
            Configuracoes = config,
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

                if (val?.ToUpper() == "FRETE" || text?.ToUpper() == "FRETE")
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
}
