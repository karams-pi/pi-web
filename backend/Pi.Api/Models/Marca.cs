using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models;

[Table("marca")]
public class Marca
{
    [Key]
    [Column("id")]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public long Id { get; set; }

    [Required]
    [Column("nome")]
    [MaxLength(200)]
    public string Nome { get; set; } = string.Empty;

    [Column("url_imagem")]
    [MaxLength(500)]
    public string? UrlImagem { get; set; }

    [Column("observacao")]
    [MaxLength(1000)]
    public string? Observacao { get; set; }

    // 1 marca -> N módulos
    public ICollection<Modulo> Modulos { get; set; } = new List<Modulo>();
}
