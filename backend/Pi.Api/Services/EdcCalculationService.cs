
using Pi.Api.Models.Edc;

namespace Pi.Api.Services;

public interface IEdcCalculationService
{
    decimal CalcularValorAduaneiroItem(SimulacaoEdcItem item, decimal cotacaoTotal);
    decimal CalcularII(decimal valorAduaneiro, decimal aliquota);
    decimal CalcularIPI(decimal valorAduaneiro, decimal valorII, decimal aliquota);
    decimal CalcularPisCofins(decimal valorAduaneiro, decimal aliquota);
    decimal CalcularIcmsPorDentro(decimal baseIcmsSemIcms, decimal aliquotaIcms);
    void ProcessarNacionalizacaoCompleta(SimulacaoEdc simulacao);
}

public class EdcCalculationService : IEdcCalculationService
{
    public decimal CalcularValorAduaneiroItem(SimulacaoEdcItem item, decimal cotacaoTotal)
    {
        // Valor Aduaneiro = FOB * Cotação (Simplificado para o item individual no rateio)
        return item.Quantidade * item.ValorFobUnitario * cotacaoTotal;
    }

    public decimal CalcularII(decimal valorAduaneiro, decimal aliquota)
    {
        return Math.Round(valorAduaneiro * aliquota, 2);
    }

    public decimal CalcularIPI(decimal valorAduaneiro, decimal valorII, decimal aliquota)
    {
        // Base IPI = Valor Aduaneiro + II
        return Math.Round((valorAduaneiro + valorII) * aliquota, 2);
    }

    public decimal CalcularPisCofins(decimal valorAduaneiro, decimal aliquota)
    {
        return Math.Round(valorAduaneiro * aliquota, 2);
    }

    public decimal CalcularIcmsPorDentro(decimal baseIcmsSemIcms, decimal aliquotaIcms)
    {
        if (aliquotaIcms >= 1) return 0;
        
        // Base ICMS = (Soma de tudo) / (1 - Aliquota)
        decimal baseCalculo = baseIcmsSemIcms / (1 - aliquotaIcms);
        return Math.Round(baseCalculo * aliquotaIcms, 2);
    }

    public void ProcessarNacionalizacaoCompleta(SimulacaoEdc simulacao)
    {
        decimal cotacaoFinal = simulacao.CotacaoDolar + simulacao.SpreadCambio;
        
        // 1. Calcular Frete e Seguro em BRL
        decimal freteBrl = simulacao.ValorFreteInternacional * cotacaoFinal;
        decimal seguroBrl = simulacao.ValorSeguroInternacional * cotacaoFinal;
        
        // 2. Calcular Valor FOB Total em BRL para rateio
        decimal totalFobBrl = simulacao.Itens.Sum(i => i.Quantidade * i.ValorFobUnitario * cotacaoFinal);

        foreach (var item in simulacao.Itens)
        {
            if (item.Produto?.Ncm == null) continue;

            decimal itemFobBrl = item.Quantidade * item.ValorFobUnitario * cotacaoFinal;
            
            // Rateio proporcional ao valor FOB (Método padrão)
            decimal fatorRateio = totalFobBrl > 0 ? itemFobBrl / totalFobBrl : 0;
            
            decimal itemValorAduaneiro = itemFobBrl + (freteBrl * fatorRateio) + (seguroBrl * fatorRateio);
            
            // Impostos Federais
            decimal ii = CalcularII(itemValorAduaneiro, item.Produto.Ncm.AliquotaII);
            decimal ipi = CalcularIPI(itemValorAduaneiro, ii, item.Produto.Ncm.AliquotaIPI);
            decimal pis = CalcularPisCofins(itemValorAduaneiro, item.Produto.Ncm.AliquotaPis);
            decimal cofins = CalcularPisCofins(itemValorAduaneiro, item.Produto.Ncm.AliquotaCofins);
            
            // Taxas Aduaneiras (Rateio das despesas da simulação)
            decimal taxasItemBrl = simulacao.Despesas
                .Where(d => d.MetodoRateio == "Valor FOB")
                .Sum(d => d.Valor * fatorRateio);

            // Base ICMS "Por Dentro"
            decimal baseIcmsSemIcms = itemValorAduaneiro + ii + ipi + pis + cofins + taxasItemBrl;
            decimal icms = CalcularIcmsPorDentro(baseIcmsSemIcms, item.Produto!.Ncm!.AliquotaIcmsPadrao);
            
            // O valor total nacionalizado do item seria a soma de todos esses componentes
            // (Isso será usado pelos controllers para retornar o DTO de resultado)
        }
    }
}
