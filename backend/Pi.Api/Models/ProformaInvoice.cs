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

    [Column("tempo_entrega")]
    [MaxLength(100)]
    public string? TempoEntrega { get; set; }

    [Column("condicao_pagamento")]
    [MaxLength(100)]
    public string? CondicaoPagamento { get; set; }

    [Column("idioma")]
    [MaxLength(10)]
    public string? Idioma { get; set; } = "PT";

    [Column("tipo_rateio")]
    [MaxLength(10)]
    public string TipoRateio { get; set; } = "IGUAL";

    [Column("moeda_exibicao")]
    [MaxLength(10)]
    public string MoedaExibicao { get; set; } = "USD";

    [Column("validade_dias")]
    public int ValidadeDias { get; set; } = 30;

    // Navigation
    [Column("id_fornecedor")]
    public long? IdFornecedor { get; set; }

    [ForeignKey(nameof(IdFornecedor))]
    public Fornecedor? Fornecedor { get; set; }
    public Cliente? Cliente { get; set; }
    public Configuracao? Configuracoes { get; set; }
    public Frete? Frete { get; set; }
    public ICollection<PiItemPeca> PiItensPecas { get; set; } = new List<PiItemPeca>();
    public ICollection<PiItem> PiItens { get; set; } = new List<PiItem>();
}
