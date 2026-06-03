using Xunit;
using FluentAssertions;
using OfficeOpenXml;
using Pi.Api.Services;
using Pi.Api.Models;
using System.Collections.Generic;

namespace Pi.Tests.Services;

public class ModuloExportServiceTests
{
    private readonly ModuloExportService _service;

    public ModuloExportServiceTests()
    {
        ExcelPackage.License.SetNonCommercialPersonal("PI Web User");
        _service = new ModuloExportService();
    }

    [Theory]
    // BRL Tests (valor + comissao + gordura)
    [InlineData(100, "BRL", 5.00, 10, 5, "Standard", 115.00)]
    [InlineData(50, "BRL", 5.00, 0, 0, "Standard", 50.00)]
    // EXW Tests - Standard (Karams/Koyo)
    // cotacaoRisco = 5.00 - 0.10 = 4.90
    // valorBase = 100 / 4.90 = 20.408...
    // comissao = 20.408 * 10% = 2.0408
    // gordura = 20.408 * 5% = 1.0204
    // total = 20.408 + 2.0408 + 1.0204 = 23.469 -> Round(23.47)
    [InlineData(100, "EXW", 5.00, 10, 5, "Karams", 23.47)] 
    // EXW Tests - Fixed (Ferguile/Livintus)
    // cotacaoRisco = 0.10 (reducao behavior is different for Ferguile)
    // valorBase = 100 / 0.10 = 1000
    // total = 1000 + 100 + 50 = 1150
    [InlineData(100, "EXW", 5.00, 10, 5, "Ferguile", 1150.00)]
    public void CalcPrice_CalculatesCorrectlyBasedOnCurrencyAndSupplier(
        decimal valorTecido, string currency, decimal cotacao, 
        decimal comissao, decimal gordura, string supplier, decimal expected)
    {
        // Arrange
        var config = new Configuracao
        {
            PercentualComissao = comissao,
            PercentualGordura = gordura,
            ValorReducaoDolar = 0.10m // Standard "reducao"
        };

        // Act
        var result = _service.CalcPrice(valorTecido, currency, cotacao, config, null, supplier);

        // Assert
        result.Should().Be(expected);
    }

    [Fact]
    public void ExportToExcel_ShouldReturnNonEmptyByteArray()
    {
        // Arrange
        var modules = new List<Modulo>
        {
            new Modulo 
            { 
                Id = 1, 
                Descricao = "Teste", 
                Fornecedor = new Fornecedor { Nome = "Karams" },
                Categoria = new Categoria { Nome = "Sofa" },
                Marca = new Marca { Nome = "Brand" },
                ModulosTecidos = new List<ModuloTecido>
                {
                    new ModuloTecido { IdTecido = 1, ValorTecido = 100, Tecido = new Tecido { Id = 1, Nome = "G1" } }
                }
            }
        };
        var configs = new List<Configuracao> { new Configuracao { PercentualComissao = 10, PercentualGordura = 5, ValorReducaoDolar = 0.1m } };

        // Act
        var result = _service.ExportToExcel(modules, "BRL", 5.0m, configs);

        // Assert
        result.Should().NotBeNull();
        result.Length.Should().BeGreaterThan(0);
    }

    [Fact]
    public void ExportPriceListToExcel_ShouldAllowDuplicateModulesAndReturnNonEmptyByteArray()
    {
        // Arrange
        var module = new Modulo 
        { 
            Id = 1, 
            Descricao = "Teste Duplicado", 
            Fornecedor = new Fornecedor { Nome = "Karams" },
            Categoria = new Categoria { Nome = "Sofa" },
            Marca = new Marca { Nome = "Brand" },
            ModulosTecidos = new List<ModuloTecido>
            {
                new ModuloTecido { IdTecido = 1, ValorTecido = 100, Tecido = new Tecido { Id = 1, Nome = "G1" } }
            }
        };

        var items = new List<ModuloExportService.PriceListItemDto>
        {
            new ModuloExportService.PriceListItemDto { Modulo = module, ValorFreteRateadoUSD = 10 },
            new ModuloExportService.PriceListItemDto { Modulo = module, ValorFreteRateadoUSD = 10 }
        };

        var configs = new List<Configuracao> { new Configuracao { PercentualComissao = 10, PercentualGordura = 5, ValorReducaoDolar = 0.1m } };

        // Act
        var result = _service.ExportPriceListToExcel(items, "BRL", 5.0m, configs);

        // Assert
        result.Should().NotBeNull();
        result.Length.Should().BeGreaterThan(0);
    }

    [Fact]
    public void ExportPriceListToExcel_ShouldGroupDuplicatesAndMultiplyPrices()
    {
        // Arrange
        var module = new Modulo 
        { 
            Id = 1, 
            Descricao = "Teste Grouping", 
            Fornecedor = new Fornecedor { Nome = "Karams" },
            Categoria = new Categoria { Nome = "Sofa" },
            Marca = new Marca { Nome = "Brand" },
            ModulosTecidos = new List<ModuloTecido>
            {
                new ModuloTecido { IdTecido = 1, ValorTecido = 100, Tecido = new Tecido { Id = 1, Nome = "G1" } }
            }
        };

        var items = new List<ModuloExportService.PriceListItemDto>
        {
            new ModuloExportService.PriceListItemDto { Modulo = module, ValorFreteRateadoUSD = 10 },
            new ModuloExportService.PriceListItemDto { Modulo = module, ValorFreteRateadoUSD = 10 }
        };

        var configs = new List<Configuracao> { new Configuracao { PercentualComissao = 10, PercentualGordura = 5, ValorReducaoDolar = 0.1m } };

        // Act
        var result = _service.ExportPriceListToExcel(items, "BRL", 5.0m, configs);

        // Assert
        using var stream = new System.IO.MemoryStream(result);
        using var package = new ExcelPackage(stream);
        var ws = package.Workbook.Worksheets[0];

        var qty = ws.Cells[8, 3].Value; // Column 3: Módulo (Quantity)
        var price = ws.Cells[8, 8].Value; // Column 8: G1 Price

        qty.Should().Be(2); // Sum of 2 duplicate selections

        // basePrice = mt.ValorTecido (100) + 10% comissao (10) + 5% gordura (5) = 115.00
        // freightUSD = 10.00 -> BRL freightDisp = 10.00 * 5.0m = 50.00
        // Total single value = 115.00 + 50.00 = 165.00
        // Multiplied by Quantity (2) = 330.00
        price.Should().Be(330.00m);
    }
}
