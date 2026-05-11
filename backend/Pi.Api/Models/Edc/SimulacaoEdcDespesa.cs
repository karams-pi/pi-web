
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models.Edc;

[Table("simulacao_despesas", Schema = "edc")]
public class SimulacaoEdcDespesa
{
    [Key]
    public int Id { get; set; }

    [Required]
    public int IdSimulacao { get; set; }
    [ForeignKey(nameof(IdSimulacao))]
    public SimulacaoEdc? Simulacao { get; set; }

    [Required]
    [MaxLength(100)]
    public string NomeDespesa { get; set; } = string.Empty;

    [Column(TypeName = "numeric(18,2)")]
    public decimal Valor { get; set; }

    [Required]
    [MaxLength(10)]
    public string Moeda { get; set; } = "BRL";

    [Required]
    [MaxLength(50)]
    public string MetodoRateio { get; set; } = "Valor FOB"; // Valor FOB, Quantidade, Peso, Volume
}
