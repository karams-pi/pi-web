using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models;

[Table("versao_sistema")]
public class VersaoSistema
{
    [Key]
    [Column("id")]
    public long Id { get; set; }

    [Required]
    [Column("versao")]
    [MaxLength(50)]
    public string Versao { get; set; } = "";

    [Column("data")]
    public DateTime Data { get; set; } = DateTime.UtcNow;
}
