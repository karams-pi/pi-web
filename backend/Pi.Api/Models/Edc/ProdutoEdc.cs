
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models.Edc;

[Table("produtos", Schema = "edc")]
public class ProdutoEdc
{
    [Key]
    public int Id { get; set; }

    [Required]
    [MaxLength(100)]
    public string Referencia { get; set; } = string.Empty;

    [Required]
    [MaxLength(500)]
    public string Descricao { get; set; } = string.Empty;

    [Required]
    public int IdNcm { get; set; }
    
    [ForeignKey(nameof(IdNcm))]
    public Ncm? Ncm { get; set; }

    [Column(TypeName = "numeric(18,4)")]
    public decimal PesoLiquido { get; set; }

    [Column(TypeName = "numeric(18,4)")]
    public decimal PesoBruto { get; set; }

    [Column(TypeName = "numeric(18,4)")]
    public decimal CubagemM3 { get; set; }

    [MaxLength(10)]
    public string UnidadeMedida { get; set; } = "UN";

    [Column(TypeName = "numeric(18,2)")]
    public decimal PrecoFobBase { get; set; }

    public bool FlAtivo { get; set; } = true;
}
