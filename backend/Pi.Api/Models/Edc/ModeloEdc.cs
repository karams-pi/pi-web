using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models.Edc;

[Table("modelos", Schema = "edc")]
public class ModeloEdc
{
    [Key]
    public int Id { get; set; }

    [Required]
    [MaxLength(100)]
    public string Codigo { get; set; } = string.Empty;

    [Required]
    [MaxLength(200)]
    public string Nome { get; set; } = string.Empty;

    [MaxLength(500)]
    public string? Descricao { get; set; }

    [Required]
    public int IdProduto { get; set; }

    [ForeignKey(nameof(IdProduto))]
    public ProdutoEdc? Produto { get; set; }

    public bool FlAtivo { get; set; } = true;
}
