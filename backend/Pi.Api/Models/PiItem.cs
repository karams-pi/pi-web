using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models;

[Table("pi_item")]
public class PiItem
{
    [Key]
    [Column("id")]
    public long Id { get; set; }

    [Required]
    [Column("id_pi")]
    public long IdPi { get; set; }

    [Required]
    [Column("id_modulo_tecido")]
    public long IdModuloTecido { get; set; }

    [Required]
    [Column("largura")]
    public decimal Largura { get; set; }

    [Required]
    [Column("profundidade")]
    public decimal Profundidade { get; set; }

    [Required]
    [Column("altura")]
    public decimal Altura { get; set; }

    [Required]
    [Column("pa")]
    public decimal Pa { get; set; }

    [Required]
    [Column("m3")]
    public decimal M3 { get; set; }

    [Required]
    [Column("rateio_frete")]
    public decimal RateioFrete { get; set; }

    [Required]
    [Column("quantidade")]
    public decimal Quantidade { get; set; }

    [Required]
    [Column("valor_exw")]
    public decimal ValorEXW { get; set; }

    [Required]
    [Column("valor_frete_rateado_brl")]
    public decimal ValorFreteRateadoBRL { get; set; }

    [Required]
    [Column("valor_frete_rateado_usd")]
    public decimal ValorFreteRateadoUSD { get; set; }

    [Required]
    [Column("valor_final_item_brl")]
    public decimal ValorFinalItemBRL { get; set; }

    [Required]
    [Column("valor_final_item_usd_risco")]
    public decimal ValorFinalItemUSDRisco { get; set; }

    // Navigation
    public ProformaInvoice? Pi { get; set; }
    public ModuloTecido? ModuloTecido { get; set; }
}
