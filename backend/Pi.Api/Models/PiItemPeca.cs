using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models;

[Table("pi_item_peca")]
public class PiItemPeca
{
    [Key]
    [Column("id")]
    public long Id { get; set; }

    [Required]
    [Column("id_pi")]
    public long IdPi { get; set; }

    [Column("descricao")]
    [MaxLength(200)]
    public string? Descricao { get; set; }

    [Required]
    [Column("quantidade")]
    public decimal Quantidade { get; set; }

    // Navigation
    [ForeignKey(nameof(IdPi))]
    public ProformaInvoice? Pi { get; set; }
    
    public ICollection<PiItem> PiItens { get; set; } = new List<PiItem>();
}
