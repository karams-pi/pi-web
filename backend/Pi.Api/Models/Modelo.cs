using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

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
    public long FornecedorId { get; set; }

    [ForeignKey(nameof(FornecedorId))]
    public Fornecedor Fornecedor { get; set; } = null!;

    [Required]
    [Column("id_categoria")]
    public long CategoriaId { get; set; }

    [ForeignKey(nameof(CategoriaId))]
    public Categoria Categoria { get; set; } = null!;

    [Required]
    [Column("descricao")]
    [MaxLength(400)]
    public string Descricao { get; set; } = string.Empty;

    [Required]
    [Column("largura", TypeName = "numeric(18,2)")]
    public decimal Largura { get; set; }

    [Required]
    [Column("profundidade", TypeName = "numeric(18,2)")]
    public decimal Profundidade { get; set; }

    [Required]
    [Column("altura", TypeName = "numeric(18,2)")]
    public decimal Altura { get; set; }

    [Required]
    [Column("pa", TypeName = "numeric(18,2)")]
    public decimal? Pa { get; set; }

    // Calculado no banco (DbContext). Não aceitar do cliente.
    [Column("m3", TypeName = "numeric(18,2)")]
    [JsonIgnore]
    public decimal M3 { get; private set; }

    [Required]
    [Column("id_tecido")]
    public long TecidoId { get; set; }

    [ForeignKey(nameof(TecidoId))]
    public Tecido Tecido { get; set; } = null!;

    [Required]
    [Column("valor_tecido", TypeName = "numeric(18,3)")]
    public decimal ValorTecido { get; set; }
}
