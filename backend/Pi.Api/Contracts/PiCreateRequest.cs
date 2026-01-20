namespace Pi.Api.Contracts;

public class PiCreateRequest
{
    public string Prefixo { get; set; } = "SW";
    public DateOnly DataPi { get; set; } = DateOnly.FromDateTime(DateTime.UtcNow);
    public Guid ClienteId { get; set; }
    public string TipoPreco { get; set; } = "EXW";

    public decimal? UsdRate { get; set; }
    public string? UsdRateFonte { get; set; }
}
