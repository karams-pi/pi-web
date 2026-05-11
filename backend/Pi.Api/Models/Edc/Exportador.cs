
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models.Edc;

[Table("exportadores", Schema = "edc")]
public class Exportador
{
    [Key]
    public int Id { get; set; }

    [Required]
    [MaxLength(200)]
    public string Nome { get; set; } = string.Empty;

    [Required]
    [MaxLength(100)]
    public string Pais { get; set; } = string.Empty;

    [MaxLength(500)]
    public string? Endereco { get; set; }

    [MaxLength(50)]
    public string? TaxId { get; set; } // VAT, EIN, etc.

    [MaxLength(100)]
    public string? Contato { get; set; }

    public bool FlAtivo { get; set; } = true;
}
