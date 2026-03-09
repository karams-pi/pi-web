using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading.Tasks;
using System.Collections.Generic;
using Pi.Api.Data;
using Pi.Api.Models;
using Xunit;
using FluentAssertions;

namespace Pi.Tests.Data;

public class PiPersistenceTests
{
    [Fact]
    public async Task SavePi_ShouldWork()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: "TestDb")
            .Options;

        using var context = new AppDbContext(options);
        
        var pi = new ProformaInvoice
        {
            Prefixo = "SW",
            PiSequencia = "00001",
            IdCliente = Guid.NewGuid(),
            IdConfiguracoes = 1,
            IdFrete = 1
        };

        context.Pis.Add(pi);
        await context.SaveChangesAsync();

        context.Pis.Count().Should().Be(1);
    }
}
