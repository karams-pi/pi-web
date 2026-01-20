using System.Text.Json;

namespace Pi.Api.Services
{
    public class FxService
    {
        private readonly HttpClient _http;
        private readonly IConfiguration _config;

        public FxService(HttpClient http, IConfiguration config)
        {
            _http = http;
            _config = config;
        }

        public record FxQuote(decimal Rate, string Source, DateTimeOffset FetchedAt);

        public async Task<FxQuote> GetUsdBrlAsync(CancellationToken ct)
        {
            var url = _config["Fx:AwesomeApiUrl"];
            if (string.IsNullOrWhiteSpace(url))
                throw new InvalidOperationException("Fx:AwesomeApiUrl não configurado.");

            using var res = await _http.GetAsync(url, ct);
            res.EnsureSuccessStatusCode();

            var json = await res.Content.ReadAsStringAsync(ct);

            using var doc = JsonDocument.Parse(json);
            var usdbrl = doc.RootElement.GetProperty("USDBRL");
            var bidStr = usdbrl.GetProperty("bid").GetString();

            if (!decimal.TryParse(bidStr, System.Globalization.NumberStyles.Any,
                    System.Globalization.CultureInfo.InvariantCulture, out var bid))
                throw new Exception("Não foi possível parsear cotação (bid).");

            return new FxQuote(bid, "AwesomeAPI", DateTimeOffset.UtcNow);
        }
    }
}
