
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models.Edc;

[Table("portos", Schema = "edc")]
public class Porto
{
    [Key]
    public int Id { get; set; }

    [Required]
    [MaxLength(100)]
    public string Nome { get; set; } = string.Empty;

    [Required]
    [MaxLength(10)]
    public string Sigla { get; set; } = string.Empty; // ex: SHA, SSZ, PNG

    [Required]
    [MaxLength(100)]
    public string Pais { get; set; } = string.Empty;

    [Required]
    [MaxLength(20)]
    public string Tipo { get; set; } = "Maritimo"; // Maritimo, Aereo, Rodoviario
}
