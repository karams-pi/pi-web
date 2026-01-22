using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models;

[Table("modulo")]
public class Modulo
{
    [Key]
    [Column("id")]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public long Id { get; set; }

    [Required]
    [Column("id_fornecedor")]
    public long IdFornecedor { get; set; }

    [ForeignKey(nameof(IdFornecedor))]
    public Fornecedor Fornecedor { get; set; } = null!;

    [Required]
    [Column("id_categoria")]
    public long IdCategoria { get; set; }

    [ForeignKey(nameof(IdCategoria))]
    public Categoria Categoria { get; set; } = null!;

    [Required]
    [Column("id_marca")]
    public long IdMarca { get; set; }

    [ForeignKey(nameof(IdMarca))]
    public Marca Marca { get; set; } = null!;

    [Required]
    [Column("descricao")]
    [MaxLength(300)]
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
    public decimal Pa { get; set; }

    [Required]
    [Column("m3", TypeName = "numeric(18,2)")]
    public decimal M3 { get; set; }

    // 1 módulo -> N registros em modulo_tecido
    public ICollection<ModuloTecido> ModulosTecidos { get; set; } = new List<ModuloTecido>();
}
