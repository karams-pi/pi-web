namespace Pi.Api.Services;

public interface ICalculoService
{
    decimal CalcularCotacaoRisco(string supplierName, decimal cotacaoAtual, decimal valorReducaoDolar);
    decimal CalcularEXW(decimal valorModuloTecido, decimal cotacaoRisco, decimal percentualComissao, decimal percentualGordura);
    decimal CalcularBRL(decimal valorModuloTecido, decimal percentualComissao, decimal percentualGordura);
}

public class CalculoService : ICalculoService
{
    public decimal CalcularCotacaoRisco(string supplierName, decimal cotacaoAtual, decimal valorReducaoDolar)
    {
        if (string.IsNullOrEmpty(supplierName)) return cotacaoAtual - valorReducaoDolar;

        var name = supplierName.ToLower();
        if (name.Contains("ferguile") || name.Contains("livintus"))
        {
            // Para Ferguile/Livintus, ValorReducaoDolar é usado como Valor Cotação Fixo
            return valorReducaoDolar;
        }

        return Math.Round(cotacaoAtual - valorReducaoDolar, 2);
    }

    public decimal CalcularEXW(decimal valorModuloTecido, decimal cotacaoRisco, decimal percentualComissao, decimal percentualGordura)
    {
        if (cotacaoRisco <= 0) return 0;

        decimal valorBase = valorModuloTecido / cotacaoRisco;
        decimal vComissao = valorBase * (percentualComissao / 100);
        decimal vGordura = valorBase * (percentualGordura / 100);

        return Math.Round(valorBase + vComissao + vGordura, 2);
    }

    public decimal CalcularBRL(decimal valorModuloTecido, decimal percentualComissao, decimal percentualGordura)
    {
        decimal vComissao = valorModuloTecido * (percentualComissao / 100);
        decimal vGordura = valorModuloTecido * (percentualGordura / 100);

        return Math.Round(valorModuloTecido + vComissao + vGordura, 2);
    }
}
