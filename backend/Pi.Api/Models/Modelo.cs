using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models;

[Table("modelo")]
public class Modelo
{
    [Key]
    [Column("id")]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public long Id { get; set; }

    [Required]
    [Column("id_fornecedor")]
    public long IdFornecedor { get; set; }

    [ForeignKey(nameof(IdFornecedor))]
    public Fornecedor? Fornecedor { get; set; }

    [Required]
    [Column("id_categoria")]
    public long IdCategoria { get; set; }

    [ForeignKey(nameof(IdCategoria))]
    public Categoria? Categoria { get; set; }

    [Required]
    [MaxLength(300)]
    [Column("descricao")]
    public string Descricao { get; set; } = string.Empty;

    [Column("url_imagem")]
    [MaxLength(500)]
    public string? UrlImagem { get; set; }

    public ICollection<Modulo> Modulos { get; set; } = new List<Modulo>();
}
