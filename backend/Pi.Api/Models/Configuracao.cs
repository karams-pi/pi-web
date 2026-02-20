using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models;

[Table("configuracoes")]
public class Configuracao
{
    [Key]
    [Column("id")]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public long Id { get; set; }

    [Required]
    [Column("data_config")]
    public DateTime DataConfig { get; set; } = DateTime.UtcNow;

    [Required]
    [Column("valor_reducao_dolar", TypeName = "numeric(18,2)")]
    public decimal ValorReducaoDolar { get; set; }

    [Required]
    [Column("valor_perc_imposto", TypeName = "numeric(18,2)")]
    public decimal ValorPercImposto { get; set; }

    [Required]
    [Column("percentual_comissao", TypeName = "numeric(18,2)")]
    public decimal PercentualComissao { get; set; }

    [Required]
    [Column("percentual_gordura", TypeName = "numeric(18,2)")]
    public decimal PercentualGordura { get; set; }

    [Required]
    [Column("valor_FCA_frete_rod_fronteira", TypeName = "numeric(18,2)")]
    public decimal ValorFCAFreteRodFronteira { get; set; } = 0;

    [Required]
    [Column("valor_despesas_FCA", TypeName = "numeric(18,2)")]
    public decimal ValorDespesasFCA { get; set; } = 0;

    [Required]
    [Column("valor_FOB_frete_porto_paranagua", TypeName = "numeric(18,2)")]
    public decimal ValorFOBFretePortoParanagua { get; set; } = 0;

    [Required]
    [Column("valor_FOB_desp_port_reg_doc", TypeName = "numeric(18,2)")]
    public decimal ValorFOBDespPortRegDoc { get; set; } = 0;

    [Required]
    [Column("valor_FOB_desp_despac_aduaneiro", TypeName = "numeric(18,2)")]
    public decimal ValorFOBDespDespacAduaneiro { get; set; } = 0;

    [Required]
    [Column("valor_FOB_desp_courier", TypeName = "numeric(18,2)")]
    public decimal ValorFOBDespCourier { get; set; } = 0;

    [Column("id_fornecedor")]
    public long? IdFornecedor { get; set; }

    [ForeignKey(nameof(IdFornecedor))]
    public Fornecedor? Fornecedor { get; set; }
}
