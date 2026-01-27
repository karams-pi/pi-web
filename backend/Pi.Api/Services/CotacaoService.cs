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
        // 1. Tenta API Principal (AwesomeAPI)
        try
        {
            // Documentação: https://docs.awesomeapi.com.br/api-de-moedas
            var url = "https://economia.awesomeapi.com.br/last/USD-BRL";
            
            // Usar User-Agent de navegador para evitar bloqueios
            _httpClient.DefaultRequestHeaders.Clear();
            _httpClient.DefaultRequestHeaders.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36");
            
            var response = await _httpClient.GetAsync(url);
            
            if (response.IsSuccessStatusCode)
            {
                 var content = await response.Content.ReadAsStringAsync();
                 using var json = JsonDocument.Parse(content);
                 
                 if (json.RootElement.TryGetProperty("USDBRL", out var usdElement))
                 {
                     if (usdElement.TryGetProperty("ask", out var askProp))
                     {
                         var valStr = askProp.GetString();
                         if (decimal.TryParse(valStr, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out var valDecimal))
                         {
                             _logger.LogInformation($"Cotação obtida via AwesomeAPI: {valDecimal}");
                             return valDecimal;
                         }
                     }
                 }
            }
            else
            {
                _logger.LogWarning($"AwesomeAPI retornou erro: {response.StatusCode}");
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Erro ao buscar cotação USD (AwesomeAPI): {ex.Message}");
        }

        // 2. Tenta API Backup (Open Exchange Rates / ER-API)
        try 
        {
            // Documentação: https://www.exchangerate-api.com/docs/free
            // Base URL: https://open.er-api.com/v6/latest/USD
            var urlBackup = "https://open.er-api.com/v6/latest/USD";
            var responseBackup = await _httpClient.GetAsync(urlBackup);

            if (responseBackup.IsSuccessStatusCode)
            {
                var content = await responseBackup.Content.ReadAsStringAsync();
                using var json = JsonDocument.Parse(content);
                
                if (json.RootElement.TryGetProperty("rates", out var ratesElement))
                {
                    if (ratesElement.TryGetProperty("BRL", out var brlProp))
                    {
                        var valDecimal = brlProp.GetDecimal();
                        _logger.LogInformation($"Cotação obtida via ER-API (Backup): {valDecimal}");
                        return valDecimal;
                    }
                }
            }
            else 
            {
                _logger.LogWarning($"ER-API retornou erro: {responseBackup.StatusCode}");
            }
        }
        catch (Exception ex)
        {
             _logger.LogError(ex, $"Erro ao buscar cotação USD (Backup ER-API): {ex.Message}");
        }

        // 3. Fallback final
        _logger.LogError("Todas as tentativas de buscar cotação falharam. Usando valor fixo de segurança: 5.50");
        return 5.50m;
    }
}
