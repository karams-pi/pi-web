
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models.Edc;

[Table("taxas_aduaneiras", Schema = "edc")]
public class TaxasAduaneiras
{
    [Key]
    public int Id { get; set; }

    [Required]
    [MaxLength(100)]
    public string Nome { get; set; } = string.Empty;

    [Column(TypeName = "numeric(18,4)")]
    public decimal ValorPadrao { get; set; }

    [Required]
    [MaxLength(10)]
    public string Moeda { get; set; } = "BRL"; // BRL ou USD

    [Required]
    [MaxLength(20)]
    public string Tipo { get; set; } = "Fixo"; // Fixo ou Percentual
}
