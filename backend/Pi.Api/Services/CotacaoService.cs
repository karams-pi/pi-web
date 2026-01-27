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
            // Tenta buscar cotação em tempo real via AwesomeAPI (Dólar Comercial)
            // Documentação: https://docs.awesomeapi.com.br/api-de-moedas
            var url = "https://economia.awesomeapi.com.br/last/USD-BRL";
            
            // Alguns servidores bloqueiam requisições sem User-Agent
            if (!_httpClient.DefaultRequestHeaders.Contains("User-Agent"))
            {
                _httpClient.DefaultRequestHeaders.Add("User-Agent", "PiWeb/1.0");
            }
            
            var response = await _httpClient.GetAsync(url);
            
            if (response.IsSuccessStatusCode)
            {
                 var content = await response.Content.ReadAsStringAsync();
                 var json = JsonDocument.Parse(content);
                 
                 if (json.RootElement.TryGetProperty("USDBRL", out var usdElement))
                 {
                     if (usdElement.TryGetProperty("ask", out var askProp))
                     {
                         // AwesomeAPI retorna string, ex: "5.2534"
                         var valStr = askProp.GetString();
                         if (decimal.TryParse(valStr, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out var valDecimal))
                         {
                             return valDecimal;
                         }
                     }
                 }
            }
            
            // Fallback para lógica antiga ou valor fixo se a API principal falhar
            _logger.LogWarning($"Falha ao buscar cotação na AwesomeAPI. Status: {response.StatusCode}. Tentando valores padrão.");
            return 5.50m;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Erro ao buscar cotação USD: {ex.Message}");
            return 5.50m; // Valor padrão em caso de erro
        }
    }
}
