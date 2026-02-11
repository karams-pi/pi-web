using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models;

[Table("modulo_tecido")]
public class ModuloTecido
{
    [Key]
    [Column("id")]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public long Id { get; set; }

    [Required]
    [Column("id_modulo")]
    public long IdModulo { get; set; }

    [ForeignKey(nameof(IdModulo))]
    public Modulo? Modulo { get; set; }

    [Required]
    [Column("id_tecido")]
    public long IdTecido { get; set; }

    [ForeignKey(nameof(IdTecido))]
    public Tecido? Tecido { get; set; }

    [Required]
    [Column("valor_tecido", TypeName = "numeric(18,3)")]
    public decimal ValorTecido { get; set; }

    [Column("codigo_modulo_tecido")]
    [StringLength(10)]
    public string? CodigoModuloTecido { get; set; }
}
