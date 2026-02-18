using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models;

[Table("configuracoes_frete_item")]
public class ConfiguracoesFreteItem
{
    [Key]
    [Column("id")]
    public long Id { get; set; }

    [Required]
    [Column("id_frete_item")]
    public long IdFreteItem { get; set; }

    [Required]
    [Column("valor")]
    public decimal Valor { get; set; } = 0;

    [Required]
    [Column("fl_desconsidera")]
    public bool FlDesconsidera { get; set; } = false;

    [Column("id_fornecedor")]
    public long? IdFornecedor { get; set; }

    [ForeignKey(nameof(IdFornecedor))]
    public Fornecedor? Fornecedor { get; set; }

    // Navigation
    public FreteItem? FreteItem { get; set; }
}
