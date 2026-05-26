using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models;

[Table("sub_modulo")]
public class SubModulo
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
    [Column("id_tecido_base")]
    public long IdTecidoBase { get; set; }

    [ForeignKey(nameof(IdTecidoBase))]
    public Tecido? TecidoBase { get; set; }

    [Required]
    [MaxLength(15)]
    [Column("codigo")]
    public string Codigo { get; set; } = string.Empty;

    [Required]
    [MaxLength(255)]
    [Column("descricao_produto")]
    public string DescricaoProduto { get; set; } = string.Empty;

    [Required]
    [MaxLength(50)]
    [Column("tecido_especifico")]
    public string TecidoEspecifico { get; set; } = string.Empty;

    [Required]
    [Column("volume_m3", TypeName = "numeric(18,6)")]
    public decimal VolumeM3 { get; set; }

    [Column("fl_ativo")]
    public bool FlAtivo { get; set; } = true;
}
