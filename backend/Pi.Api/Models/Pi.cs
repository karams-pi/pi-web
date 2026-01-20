namespace Pi.Api.Models;

public class PiModel
{
    public Guid Id { get; set; } = Guid.NewGuid();

    public string Numero { get; set; } = default!; // ex: SW00001-2026
    public string Prefixo { get; set; } = "SW";

    public DateOnly DataPi { get; set; } = DateOnly.FromDateTime(DateTime.UtcNow);

    // Status simplificado pro MVP
    public string Status { get; set; } = "ABERTA";

    public Guid ClienteId { get; set; }
    public Cliente? Cliente { get; set; }

    public string TipoPreco { get; set; } = "EXW"; // EXW/FCA/FOB

    public decimal? UsdRate { get; set; }
    public string? UsdRateFonte { get; set; }
    public DateTimeOffset? UsdRateAtualizadoEm { get; set; }

    public decimal TotalUsd { get; set; } = 0;
    public decimal TotalBrl { get; set; } = 0;

    public DateTimeOffset CriadoEm { get; set; } = DateTimeOffset.UtcNow;
    public DateTimeOffset AtualizadoEm { get; set; } = DateTimeOffset.UtcNow;
}
