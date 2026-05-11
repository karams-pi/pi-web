
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models.Edc;

[Table("importadores", Schema = "edc")]
public class Importador
{
    [Key]
    public int Id { get; set; }

    [Required]
    [MaxLength(200)]
    public string RazaoSocial { get; set; } = string.Empty;

    [Required]
    [MaxLength(20)]
    public string Cnpj { get; set; } = string.Empty;

    [MaxLength(20)]
    public string? InscricaoEstadual { get; set; }

    [Required]
    [MaxLength(2)]
    public string UF { get; set; } = string.Empty;

    [Required]
    [MaxLength(50)]
    public string RegimeTributario { get; set; } = "Simples Nacional"; // Simples, Real, Presumido

    [Column(TypeName = "numeric(18,4)")]
    public decimal AliquotaIcmsPadrao { get; set; }

    public bool FlAtivo { get; set; } = true;
}
