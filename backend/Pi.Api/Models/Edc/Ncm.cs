
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models.Edc;

[Table("ncms", Schema = "edc")]
public class Ncm
{
    [Key]
    public int Id { get; set; }

    [Required]
    [MaxLength(10)]
    public string Codigo { get; set; } = string.Empty;

    [Required]
    [MaxLength(500)]
    public string Descricao { get; set; } = string.Empty;

    [Column(TypeName = "numeric(18,4)")]
    public decimal AliquotaII { get; set; }

    [Column(TypeName = "numeric(18,4)")]
    public decimal AliquotaIPI { get; set; }

    [Column(TypeName = "numeric(18,4)")]
    public decimal AliquotaPis { get; set; }

    [Column(TypeName = "numeric(18,4)")]
    public decimal AliquotaCofins { get; set; }

    [Column(TypeName = "numeric(18,4)")]
    public decimal AliquotaIcmsPadrao { get; set; }

    public bool FlAtivo { get; set; } = true;
}
