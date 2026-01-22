using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models;

[Table("fornecedor")]
public class Fornecedor
{
    [Key]
    [Column("id")]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public long Id { get; set; }

    [Required]
    [Column("nome")]
    [MaxLength(200)]
    public string Nome { get; set; } = string.Empty;

    [Required]
    [Column("cnpj")]
    [MaxLength(14)]
    public string Cnpj { get; set; } = string.Empty;

    // 1 fornecedor -> N módulos
    public ICollection<Modulo> Modulos { get; set; } = new List<Modulo>();
}
