using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Pi.Api.Models;

[Table("lista_preco")]
public class ListaPreco
{
    [Key]
    [Column("id")]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public long Id { get; set; }

    [Required]
    [Column("fornecedor_lista")]
    public required string FornecedorLista { get; set; }
    
    [Required]
    [Column("tipo_preco")]
    public required string TipoPreco {get; set;}

    [Column("data_lista_preco")] public DateTimeOffset DataListaPreco { get; set; }

    [Required]
    [Column("marca")]
    public required string Marca { get; set; }

    [Required]
    [MaxLength(200)]
    [Column("descricao")]
    public string Descricao { get; set; } = string.Empty;

    // Medidas (3 casas)
    [Precision(18, 3)]
    [Column("largura")]
    public decimal Largura { get; set; }

    [Precision(18, 3)]
    [Column("profundidade")]
    public decimal Profundidade { get; set; }

    [Precision(18, 3)]
    [Column("altura")]
    public decimal Altura { get; set; }

    [Precision(18, 3)]
    [Column("m3")]
    public decimal M3 { get; set; }

    // Valores (R$)
    [Precision(18, 2)]
    [Column("g0")]
    public decimal ?G0 { get; set; }

    [Precision(18, 2)]
    [Column("g1")]
    public decimal ?G1 { get; set; }

    [Precision(18, 2)]
    [Column("g2")]
    public decimal ?G2 { get; set; }

    [Precision(18, 2)]
    [Column("g3")]
    public decimal ?G3 { get; set; }

    [Precision(18, 2)]
    [Column("g4")]
    public decimal ?G4 { get; set; }

    [Precision(18, 2)]
    [Column("g5")]
    public decimal ?G5 { get; set; }

    [Precision(18, 2)]
    [Column("g6")]
    public decimal ?G6 { get; set; }

    [Precision(18, 2)]
    [Column("g7")]
    public decimal ?G7 { get; set; }

    [Precision(18, 2)]
    [Column("g8")]
    public decimal ?G8 { get; set; }

    [Column("fl_ativo")]
    public bool FlAtivo { get; set; } = true;
}
