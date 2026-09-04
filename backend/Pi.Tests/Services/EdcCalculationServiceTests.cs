using Xunit;
using FluentAssertions;
using Pi.Api.Services;
using Pi.Api.Models.Edc;
using System.Collections.Generic;

namespace Pi.Tests.Services;

public class EdcCalculationServiceTests
{
    private readonly EdcCalculationService _service;

    public EdcCalculationServiceTests()
    {
        _service = new EdcCalculationService();
    }

    [Theory]
    [InlineData(1000, 0.18, 219.51)]   // 1000 / (1 - 0.18) * 0.18 = 1219.512... * 0.18 = 219.51
    [InlineData(1000, 0.19, 234.57)]   // 1000 / (1 - 0.19) * 0.19 = 1234.567... * 0.19 = 234.57
    [InlineData(820, 0.18, 180.00)]    // 820 / 0.82 * 0.18 = 1000 * 0.18 = 180.00
    [InlineData(500, 0.00, 0.00)]      // 0% ICMS -> 0
    public void CalcularIcmsPorDentro_ShouldReturnExpectedValue(decimal baseSemIcms, decimal aliquota, decimal expectedIcms)
    {
        // Act
        var result = _service.CalcularIcmsPorDentro(baseSemIcms, aliquota);

        // Assert
        result.Should().Be(expectedIcms);
    }

    [Fact]
    public void CalcularIcmsPorDentro_WhenAliquotaGreaterOrEqualToOne_ShouldReturnZero()
    {
        // Act
        var result = _service.CalcularIcmsPorDentro(1000m, 1.0m);

        // Assert
        result.Should().Be(0m);
    }
}
