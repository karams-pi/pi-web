
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models.Edc;

[Table("configuracoes_fiscais", Schema = "edc")]
public class ConfiguracaoFiscal
{
    [Key]
    public int Id { get; set; }

    [Required]
    [MaxLength(2)]
    public string UF { get; set; } = string.Empty;

    [Column(TypeName = "numeric(18,4)")]
    public decimal AliquotaIcms { get; set; }

    [Column(TypeName = "numeric(18,4)")]
    public decimal AliquotaFCP { get; set; }

    public bool IsencaoIPI { get; set; } = false;
}
