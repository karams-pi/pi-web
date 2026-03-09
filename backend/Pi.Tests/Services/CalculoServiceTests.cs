using Xunit;
using FluentAssertions;
using Pi.Api.Services;

namespace Pi.Tests.Services;

public class CalculoServiceTests
{
    private readonly CalculoService _service;

    public CalculoServiceTests()
    {
        _service = new CalculoService();
    }

    [Theory]
    [InlineData("Karams", 5.50, 0.10, 5.40)]
    [InlineData("Koyo", 6.00, 0.05, 5.95)]
    [InlineData("Generic", 5.00, 0.20, 4.80)]
    public void CalcularCotacaoRisco_StandardSuppliers_ShouldReducePrice(string supplier, decimal atual, decimal reducao, decimal expected)
    {
        // Act
        var result = _service.CalcularCotacaoRisco(supplier, atual, reducao);

        // Assert
        result.Should().Be(expected);
    }

    [Theory]
    [InlineData("Ferguile", 5.50, 4.90, 4.90)]
    [InlineData("Livintus", 6.00, 5.10, 5.10)]
    public void CalcularCotacaoRisco_FixedQuoteSuppliers_ShouldReturnFixedValue(string supplier, decimal atual, decimal fixo, decimal expected)
    {
        // Act
        var result = _service.CalcularCotacaoRisco(supplier, atual, fixo);

        // Assert
        result.Should().Be(expected);
    }

    [Theory]
    [InlineData(100, 5.00, 10, 5, 23.00)] // (100/5) + 10% + 5% = 20 + 2 + 1 = 23
    [InlineData(50, 5.00, 0, 0, 10.00)]   // (50/5) + 0 + 0 = 10
    public void CalcularEXW_ShouldReturnCorrectValue(decimal valorModulo, decimal cotacao, decimal comissao, decimal gordura, decimal expected)
    {
        // Act
        var result = _service.CalcularEXW(valorModulo, cotacao, comissao, gordura);

        // Assert
        result.Should().Be(expected);
    }
}
