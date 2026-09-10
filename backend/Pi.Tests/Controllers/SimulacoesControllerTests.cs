using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Controllers.Edc;
using Pi.Api.Data;
using Pi.Api.Models.Edc;
using Pi.Api.Services;
using Xunit;
using FluentAssertions;

namespace Pi.Tests.Controllers;

public class SimulacoesControllerTests
{
    private AppDbContext GetDbContext()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
        return new AppDbContext(options);
    }

    [Fact]
    public async Task PutSimulacao_ShouldUpdateExistingSimulacao_WithoutCreatingNew()
    {
        // Arrange
        using var context = GetDbContext();
        var imp = new Importador { Id = 1, RazaoSocial = "IMP", Cnpj = "1" };
        var exp = new Exportador { Id = 1, Nome = "EXP" };
        context.Importadores.Add(imp);
        context.Exportadores.Add(exp);

        var simulacao = new SimulacaoEdc
        {
            NumeroReferencia = "EDC-TEST",
            IdImportador = 1,
            IdExportador = 1,
            CotacaoDolar = 5.25m,
            Itens = new List<SimulacaoEdcItem>
            {
                new() { IdProduto = 1, Quantidade = 10, ValorFobUnitario = 100 }
            },
            Despesas = new List<SimulacaoEdcDespesa>
            {
                new() { NomeDespesa = "TAXA 1", Valor = 50, Moeda = "BRL" }
            }
        };
        context.SimulacoesEdc.Add(simulacao);
        await context.SaveChangesAsync();

        var initialId = simulacao.Id;
        context.ChangeTracker.Clear();

        var controller = new SimulacoesController(context, null!, null!);

        // Act - Simulate PUT from frontend
        var updatedSimulacao = new SimulacaoEdc
        {
            Id = initialId,
            NumeroReferencia = "EDC-TEST-UPDATED",
            IdImportador = 1,
            IdExportador = 1,
            CotacaoDolar = 5.30m,
            Itens = new List<SimulacaoEdcItem>
            {
                new() { IdProduto = 1, Quantidade = 20, ValorFobUnitario = 100 }
            },
            Despesas = new List<SimulacaoEdcDespesa>
            {
                new() { NomeDespesa = "TAXA 1", Valor = 60, Moeda = "BRL" }
            }
        };

        var result = await controller.PutSimulacao(initialId, updatedSimulacao);

        // Assert
        result.Should().BeOfType<NoContentResult>();

        var totalSimulacoes = await context.SimulacoesEdc.CountAsync();
        totalSimulacoes.Should().Be(1);

        var dbSimulacao = await context.SimulacoesEdc
            .Include(s => s.Itens)
            .Include(s => s.Despesas)
            .FirstAsync();
        dbSimulacao.NumeroReferencia.Should().Be("EDC-TEST-UPDATED");
        dbSimulacao.CotacaoDolar.Should().Be(5.30m);
        dbSimulacao.Itens.Should().HaveCount(1);
        dbSimulacao.Itens.First().Quantidade.Should().Be(20);
    }

    [Fact]
    public async Task PostSimulacao_WhenRapidDuplicateSent_ShouldReturnExistingWithoutCreatingDuplicate()
    {
        // Arrange
        using var context = GetDbContext();
        var imp = new Importador { Id = 1, RazaoSocial = "IMP", Cnpj = "1" };
        var exp = new Exportador { Id = 1, Nome = "EXP" };
        context.Importadores.Add(imp);
        context.Exportadores.Add(exp);
        await context.SaveChangesAsync();

        var controller = new SimulacoesController(context, null!, null!);

        var sim1 = new SimulacaoEdc
        {
            NumeroReferencia = "EDC-TEST-BURST",
            IdImportador = 1,
            IdExportador = 1,
            CotacaoDolar = 5.25m,
            DataEstudo = DateTime.UtcNow
        };

        var simDuplicate = new SimulacaoEdc
        {
            NumeroReferencia = "EDC-TEST-BURST",
            IdImportador = 1,
            IdExportador = 1,
            CotacaoDolar = 5.25m,
            DataEstudo = DateTime.UtcNow
        };

        // Act - 1st click
        var result1 = await controller.PostSimulacao(sim1);

        // Act - 2nd click immediately after (rapid burst)
        var result2 = await controller.PostSimulacao(simDuplicate);

        // Assert
        result1.Result.Should().BeOfType<CreatedAtActionResult>();
        result2.Result.Should().BeOfType<CreatedAtActionResult>();

        var totalSimulacoes = await context.SimulacoesEdc.CountAsync();
        totalSimulacoes.Should().Be(1); // Only 1 record created!
    }
}

