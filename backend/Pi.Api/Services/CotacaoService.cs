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
        // 1. Tenta API Principal (AwesomeAPI) - Real-time
        try
        {
            var url = "https://economia.awesomeapi.com.br/last/USD-BRL";
            
            // Usar User-Agent de navegador para evitar bloqueios
            _httpClient.DefaultRequestHeaders.Clear();
            _httpClient.DefaultRequestHeaders.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36");
            
            var response = await _httpClient.GetAsync(url);
            
            if (response.IsSuccessStatusCode)
            {
                 var content = await response.Content.ReadAsStringAsync();
                 using var json = JsonDocument.Parse(content);
                 
                 if (json.RootElement.TryGetProperty("USDBRL", out var usdElement) && 
                     usdElement.TryGetProperty("ask", out var askProp))
                 {
                     var valStr = askProp.GetString();
                     if (decimal.TryParse(valStr, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out var valDecimal))
                     {
                         _logger.LogInformation($"Cotação obtida via AwesomeAPI: {valDecimal}");
                         return valDecimal;
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

        // 2. Tenta HG Brasil (Secondary) - Real-time
        try
        {
            var url = "https://api.hgbrasil.com/finance?key=development"; // Key 'development' is public/free with limits
            var response = await _httpClient.GetAsync(url);
            
            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                using var json = JsonDocument.Parse(content);
                
                // Path: results -> currencies -> USD -> buy
                if (json.RootElement.TryGetProperty("results", out var results) &&
                    results.TryGetProperty("currencies", out var currencies) &&
                    currencies.TryGetProperty("USD", out var usd) &&
                    usd.TryGetProperty("buy", out var buyProp) && 
                    buyProp.ValueKind == JsonValueKind.Number)
                {
                     var valDecimal = buyProp.GetDecimal();
                     _logger.LogInformation($"Cotação obtida via HG Brasil: {valDecimal}");
                     return valDecimal;
                }
            }
            else
            {
                _logger.LogWarning($"HG Brasil retornou erro: {response.StatusCode}");
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Erro ao buscar cotação USD (HG Brasil): {ex.Message}");
        }

        // 3. Tenta Frankfurter (Tertiary) - Daily Reference (European Central Bank)
        try
        {
            var url = "https://api.frankfurter.app/latest?from=USD&to=BRL";
            var response = await _httpClient.GetAsync(url);
            
            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                using var json = JsonDocument.Parse(content);
                
                // Path: rates -> BRL
                if (json.RootElement.TryGetProperty("rates", out var rates) &&
                    rates.TryGetProperty("BRL", out var brlProp) &&
                    brlProp.ValueKind == JsonValueKind.Number)
                {
                    var valDecimal = brlProp.GetDecimal();
                    _logger.LogInformation($"Cotação obtida via Frankfurter: {valDecimal}");
                    return valDecimal;
                }
            }
            else
            {
                _logger.LogWarning($"Frankfurter retornou erro: {response.StatusCode}");
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Erro ao buscar cotação USD (Frankfurter): {ex.Message}");
        }

        // 4. Tenta API Backup (Open Exchange Rates / ER-API) - Daily Reference
        try 
        {
            var urlBackup = "https://open.er-api.com/v6/latest/USD";
            var responseBackup = await _httpClient.GetAsync(urlBackup);

            if (responseBackup.IsSuccessStatusCode)
            {
                var content = await responseBackup.Content.ReadAsStringAsync();
                using var json = JsonDocument.Parse(content);
                
                if (json.RootElement.TryGetProperty("rates", out var ratesElement) && 
                    ratesElement.TryGetProperty("BRL", out var brlProp))
                {
                    var valDecimal = brlProp.GetDecimal();
                    _logger.LogInformation($"Cotação obtida via ER-API (Backup): {valDecimal}");
                    return valDecimal;
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

        // 5. Fallback final
        _logger.LogError("Todas as tentativas de buscar cotação falharam. Usando valor fixo de segurança: 5.50");
        return 5.50m;
    }
}
