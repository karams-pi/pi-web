
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
        return item.Quantidade * item.ValorFobUnitario * cotacaoTotal;
    }

    public decimal CalcularII(decimal valorAduaneiro, decimal aliquota)
    {
        return Math.Round(valorAduaneiro * aliquota, 2);
    }

    public decimal CalcularIPI(decimal valorAduaneiro, decimal valorII, decimal aliquota)
    {
        return Math.Round((valorAduaneiro + valorII) * aliquota, 2);
    }

    public decimal CalcularPisCofins(decimal valorAduaneiro, decimal aliquota)
    {
        return Math.Round(valorAduaneiro * aliquota, 2);
    }

    public decimal CalcularIcmsPorDentro(decimal baseIcmsSemIcms, decimal aliquotaIcms)
    {
        if (aliquotaIcms >= 1) return 0;
        decimal baseCalculo = baseIcmsSemIcms / (1 - aliquotaIcms);
        return Math.Round(baseCalculo * aliquotaIcms, 2);
    }

    public void ProcessarNacionalizacaoCompleta(SimulacaoEdc simulacao)
    {
        decimal cotacaoFinal = simulacao.CotacaoDolar;
        
        // 1. Calcular Frete e Seguro em BRL
        decimal ptaxFator = 1 + (simulacao.SpreadCambio / 100m);
        decimal freteBrl = (simulacao.ValorFreteInternacional * ptaxFator) * cotacaoFinal;
        decimal seguroBrl = simulacao.ValorSeguroInternacional * cotacaoFinal;
        
        // 2. Calcular FOB Total em BRL para rateio (baseado no preço cheio)
        decimal totalFobBrl = simulacao.Itens.Sum(i => i.Quantidade * i.ValorFobUnitario * cotacaoFinal);
        decimal totalQuantidade = simulacao.Itens.Sum(i => i.Quantidade);
        
        decimal totalPeso = simulacao.Itens.Sum(i => i.PesoLiquidoTotal > 0 ? i.PesoLiquidoTotal : (i.Produto?.PesoLiquido * i.Quantidade) ?? 0m);
        decimal totalVolume = simulacao.Itens.Sum(i => i.CubagemTotal > 0 ? i.CubagemTotal : (i.Produto?.CubagemM3 * i.Quantidade) ?? 0m);

        foreach (var item in simulacao.Itens)
        {
            if (item.Produto?.Ncm == null) continue;

            decimal itemFobBrl = item.Quantidade * item.ValorFobUnitario * cotacaoFinal;
            
            // Fator de rateio padrão baseado no FOB (utilizado para frete e seguro)
            decimal fatorRateioFob = totalFobBrl > 0 ? itemFobBrl / totalFobBrl : 0;
            
            // Valor Aduaneiro baseado no FOB real (Cheio)
            decimal itemValorAduaneiroCheio = itemFobBrl + (freteBrl * fatorRateioFob) + (seguroBrl * fatorRateioFob);
            
            // Determina o FOB Subfaturado
            decimal valorFobUnitarioSub = item.ValorFobSubfaturado ?? 
                (simulacao.FlSimularSubfaturamento 
                    ? (item.ValorFobUnitario * (simulacao.PercentualSubfaturamento / 100m)) 
                    : item.ValorFobUnitario);
            
            decimal itemFobSubBrl = item.Quantidade * valorFobUnitarioSub * cotacaoFinal;
            
            // Valor Aduaneiro para impostos (Subfaturado ou Cheio)
            decimal baseCalculoAduaneiro = simulacao.FlSimularSubfaturamento 
                ? (itemFobSubBrl + (freteBrl * fatorRateioFob) + (seguroBrl * fatorRateioFob))
                : itemValorAduaneiroCheio;
            
            // 3. Calcular Impostos
            decimal ii = CalcularII(baseCalculoAduaneiro, item.Produto.Ncm.AliquotaII);
            decimal ipi = CalcularIPI(baseCalculoAduaneiro, ii, item.Produto.Ncm.AliquotaIPI);
            
            decimal pis = 0;
            decimal cofins = 0;
            if (simulacao.MetodoCalculoFederais == "SimplificadoExcel")
            {
                // Excel do cliente calcula PIS/COFINS sobre (Aduaneiro + II)
                pis = CalcularPisCofins(baseCalculoAduaneiro + ii, item.Produto.Ncm.AliquotaPis);
                cofins = CalcularPisCofins(baseCalculoAduaneiro + ii, item.Produto.Ncm.AliquotaCofins);
            }
            else
            {
                // Método legal: apenas sobre o valor aduaneiro
                pis = CalcularPisCofins(baseCalculoAduaneiro, item.Produto.Ncm.AliquotaPis);
                cofins = CalcularPisCofins(baseCalculoAduaneiro, item.Produto.Ncm.AliquotaCofins);
            }
            
            // 4. Rateio das Despesas Aduaneiras (Local port taxes)
            decimal taxasItemBrl = 0;
            if (simulacao.Despesas != null)
            {
                foreach (var d in simulacao.Despesas)
                {
                    decimal valorDespesaBrl = 0;
                    if (d.NomeDespesa.ToUpper() == "AFRMM")
                    {
                        decimal percentual = d.Valor > 1 ? d.Valor / 100m : d.Valor;
                        // AFRMM é calculado sobre o frete internacional correspondente
                        valorDespesaBrl = freteBrl * percentual;
                    }
                    else
                    {
                        valorDespesaBrl = d.Moeda == "USD" ? d.Valor * cotacaoFinal : d.Valor;
                    }

                    // Fator de rateio específico para esta despesa
                    decimal fatorDespesa = 0;
                    if (d.MetodoRateio == "Quantidade")
                    {
                        fatorDespesa = totalQuantidade > 0 ? item.Quantidade / totalQuantidade : 0;
                    }
                    else if (d.MetodoRateio == "Peso")
                    {
                        decimal itemPeso = item.PesoLiquidoTotal > 0 ? item.PesoLiquidoTotal : ((item.Produto?.PesoLiquido * item.Quantidade) ?? 0m);
                        fatorDespesa = totalPeso > 0 ? itemPeso / totalPeso : 0;
                    }
                    else if (d.MetodoRateio == "Volume")
                    {
                        decimal itemVolume = item.CubagemTotal > 0 ? item.CubagemTotal : ((item.Produto?.CubagemM3 * item.Quantidade) ?? 0m);
                        fatorDespesa = totalVolume > 0 ? itemVolume / totalVolume : 0;
                    }
                    else // Padrão ou "Valor FOB"
                    {
                        fatorDespesa = fatorRateioFob;
                    }

                    taxasItemBrl += valorDespesaBrl * fatorDespesa;
                }
            }

            // 5. Calcular ICMS
            decimal icms = 0;
            decimal aliquotaIcms = 0.18m; // Default fallback to 18%
            if (item.Produto?.Ncm != null)
            {
                aliquotaIcms = item.Produto.Ncm.AliquotaIcmsPadrao;
            }
            else if (simulacao.Importador != null)
            {
                aliquotaIcms = simulacao.Importador.AliquotaIcmsPadrao;
            }
            
            if (simulacao.MetodoCalculoIcms == "SimplificadoExcel")
            {
                // Planilha do cliente calcula: Valor Aduaneiro * Alíquota ICMS
                icms = Math.Round(baseCalculoAduaneiro * aliquotaIcms, 2);
            }
            else
            {
                // Método Legal: cálculo por dentro
                decimal baseIcmsSemIcms = baseCalculoAduaneiro + ii + ipi + pis + cofins + taxasItemBrl;
                icms = CalcularIcmsPorDentro(baseIcmsSemIcms, aliquotaIcms);
            }
            
            // O valor total nacionalizado do item seria a soma de todos esses componentes
            // (Usado para auditabilidade, visualização no front-end e lógica fiscal)
        }
    }
}
