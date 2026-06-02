using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models;

[Table("lista_emitida")]
public class ListaEmitida
{
    [Key]
    [Column("id")]
    public long Id { get; set; }

    [Column("nome_referencia")]
    [MaxLength(150)]
    public string? NomeReferencia { get; set; }

    [Column("data_emissao")]
    public DateTimeOffset DataEmissao { get; set; } = DateTimeOffset.UtcNow;

    [Column("moeda")]
    [MaxLength(10)]
    public string Moeda { get; set; } = "EXW";

    [Column("cotacao")]
    public decimal Cotacao { get; set; }

    [Column("valor_frete")]
    public decimal ValorFrete { get; set; }

    [Column("tipo_rateio")]
    [MaxLength(20)]
    public string TipoRateio { get; set; } = "IGUAL";

    [Column("validade_dias")]
    public int ValidadeDias { get; set; } = 30;

    [Column("itens_json")]
    public string ItensJson { get; set; } = "[]";
}
