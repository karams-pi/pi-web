using Xunit;
using FluentAssertions;
using OfficeOpenXml;
using Pi.Api.Services;
using Pi.Api.Models.Edc;
using Pi.Api.Data;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;
using System;

namespace Pi.Tests.Services;

public class EdcExportServiceTests
{
    private readonly EdcExportService _service;
    private readonly AppDbContext _context;

    public EdcExportServiceTests()
    {
        ExcelPackage.License.SetNonCommercialPersonal("PI Web User");
        
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
        _context = new AppDbContext(options);
        _service = new EdcExportService(_context);
    }

    [Fact]
    public void ExportToExcel_ShouldCreateValidExcelPackage()
    {
        // Arrange
        var importador = new Importador { RazaoSocial = "Test Importador", Cnpj = "123", AliquotaIcmsPadrao = 0.19m };
        var exportador = new Exportador { Nome = "Test Exportador", Pais = "China" };
        var portoOrigem = new Porto { Nome = "Shanghai" };
        var portoDestino = new Porto { Nome = "Paranaguá" };

        var item1 = new SimulacaoEdcItem
        {
            Quantidade = 10,
            ValorFobUnitario = 5.0m,
            Produto = new ProdutoEdc
            {
                Referencia = "REF1",
                Descricao = "Prod 1",
                Ncm = new Ncm
                {
                    Codigo = "87088000",
                    AliquotaII = 0.18m,
                    AliquotaIPI = 0.0306m,
                    AliquotaPis = 0.0312m,
                    AliquotaCofins = 0.1437m,
                    AliquotaIcmsPadrao = 0.19m
                }
            }
        };

        var simulacao = new SimulacaoEdc
        {
            NumeroReferencia = "EDC-TEST-01",
            Importador = importador,
            Exportador = exportador,
            PortoOrigem = portoOrigem,
            PortoDestino = portoDestino,
            CotacaoDolar = 5.20m,
            SpreadCambio = 1.0m,
            TipoFrete = "1x40",
            ValorFreteInternacional = 1000m,
            ValorSeguroInternacional = 50m,
            ComissaoPercentual = 2.0m,
            FlExibirComissao = true,
            FlSimularSubfaturamento = false,
            PercentualSubfaturamento = 0m,
            MetodoCalculoIcms = "CascataReal",
            MetodoCalculoFederais = "CascataReal",
            Itens = new List<SimulacaoEdcItem> { item1 },
            Despesas = new List<SimulacaoEdcDespesa>
            {
                new SimulacaoEdcDespesa { NomeDespesa = "TAXA SISCOMEX", Valor = 200m, Moeda = "BRL", MetodoRateio = "Quantidade" },
                new SimulacaoEdcDespesa { NomeDespesa = "T.H.C|CAPATAZIA", Valor = 1500m, Moeda = "BRL", MetodoRateio = "Quantidade" },
                new SimulacaoEdcDespesa { NomeDespesa = "AFRMM", Valor = 0.08m, Moeda = "BRL", MetodoRateio = "Quantidade" }
            }
        };

        // Act
        var result = _service.ExportToExcel(simulacao);

        // Assert
        result.Should().NotBeNull();
        result.Length.Should().BeGreaterThan(0);

        using var stream = new System.IO.MemoryStream(result);
        using var package = new ExcelPackage(stream);
        package.Workbook.Worksheets.Count.Should().Be(4);
        package.Workbook.Worksheets[0].Name.Should().Be("Resumo 100%");
        package.Workbook.Worksheets[1].Name.Should().Be("LISTA DE COMPRAS");
        package.Workbook.Worksheets[2].Name.Should().Be("Est. Cust. Naci.");
        package.Workbook.Worksheets[3].Name.Should().Be("Rateio Custos Fixos");
    }
}
