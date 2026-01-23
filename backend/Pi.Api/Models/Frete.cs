using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models;

[Table("frete")]
public class Frete
{
    [Key]
    [Column("id")]
    public long Id { get; set; }

    [Required]
    [Column("nome")]
    [MaxLength(50)]
    public string Nome { get; set; } = default!;

    // Navigation
    public ICollection<FreteItem> FreteItens { get; set; } = new List<FreteItem>();
    public ICollection<ProformaInvoice> Pis { get; set; } = new List<ProformaInvoice>();
}
