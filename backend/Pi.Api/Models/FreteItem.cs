using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models;

[Table("frete_item")]
public class FreteItem
{
    [Key]
    [Column("id")]
    public long Id { get; set; }

    [Required]
    [Column("id_frete")]
    public long IdFrete { get; set; }

    [Required]
    [Column("nome")]
    [MaxLength(100)]
    public string Nome { get; set; } = default!;

    // Navigation
    public Frete? Frete { get; set; }
    public ICollection<ConfiguracoesFreteItem> ConfiguracoesFreteItens { get; set; } = new List<ConfiguracoesFreteItem>();
}
