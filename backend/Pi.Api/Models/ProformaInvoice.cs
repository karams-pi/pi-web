using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models;

[Table("pi")]
public class ProformaInvoice
{
    [Key]
    [Column("id")]
    public long Id { get; set; }

    [Required]
    [Column("prefixo")]
    [MaxLength(10)]
    public string Prefixo { get; set; } = "SW";

    [Required]
    [Column("pi_sequencia")]
    [MaxLength(5)]
    public string PiSequencia { get; set; } = default!;

    [Required]
    [Column("data_pi")]
    public DateTimeOffset DataPi { get; set; } = DateTimeOffset.UtcNow;

    [Required]
    [Column("id_cliente")]
    public Guid IdCliente { get; set; }

    [Required]
    [Column("id_configuracoes")]
    public long IdConfiguracoes { get; set; }

    [Required]
    [Column("id_frete")]
    public long IdFrete { get; set; }

    [Required]
    [Column("valor_tecido")]
    public decimal ValorTecido { get; set; }

    [Required]
    [Column("valor_total_frete_brl")]
    public decimal ValorTotalFreteBRL { get; set; }

    [Required]
    [Column("valor_total_frete_usd")]
    public decimal ValorTotalFreteUSD { get; set; }

    [Required]
    [Column("cotacao_atual_usd")]
    public decimal CotacaoAtualUSD { get; set; }

    [Required]
    [Column("cotacao_risco")]
    public decimal CotacaoRisco { get; set; }

    // Navigation
    [Column("id_fornecedor")]
    public long? IdFornecedor { get; set; }

    [ForeignKey(nameof(IdFornecedor))]
    public Fornecedor? Fornecedor { get; set; }
    public Cliente? Cliente { get; set; }
    public Configuracao? Configuracoes { get; set; }
    public Frete? Frete { get; set; }
    public ICollection<PiItem> PiItens { get; set; } = new List<PiItem>();
}
