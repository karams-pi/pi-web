using System.Text.Json;

namespace Pi.Api.Services;

public class CotacaoService
{
    private readonly HttpClient _httpClient;
    private readonly ILogger<CotacaoService> _logger;

    public CotacaoService(HttpClient httpClient, ILogger<CotacaoService> logger)
    {
        _httpClient = httpClient;
        _logger = logger;
    }

    public async Task<decimal> GetCotacaoUSD()
    {
        try
        {
            // API do Banco Central do Brasil - Cotação PTAX do dólar
            var dataAtual = DateTime.Now.ToString("MM-dd-yyyy");
            var url = $"https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/CotacaoDolarDia(dataCotacao=@dataCotacao)?@dataCotacao='{dataAtual}'&$top=1&$format=json&$select=cotacaoCompra,cotacaoVenda,dataHoraCotacao";
            
            var response = await _httpClient.GetAsync(url);
            
            if (!response.IsSuccessStatusCode)
            {
                _logger.LogWarning("Falha ao buscar cotação USD. Usando valor padrão.");
                return 5.50m; // Valor padrão caso a API falhe
            }

            var content = await response.Content.ReadAsStringAsync();
            var json = JsonDocument.Parse(content);
            
            if (json.RootElement.TryGetProperty("value", out var valueArray) && valueArray.GetArrayLength() > 0)
            {
                var cotacao = valueArray[0];
                if (cotacao.TryGetProperty("cotacaoVenda", out var cotacaoVenda))
                {
                    return cotacaoVenda.GetDecimal();
                }
            }

            _logger.LogWarning("Cotação USD não encontrada. Usando valor padrão.");
            return 5.50m;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erro ao buscar cotação USD");
            return 5.50m; // Valor padrão em caso de erro
        }
    }
}
