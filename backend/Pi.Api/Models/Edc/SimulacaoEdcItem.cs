
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models.Edc;

[Table("simulacao_itens", Schema = "edc")]
public class SimulacaoEdcItem
{
    [Key]
    public int Id { get; set; }

    [Required]
    public int IdSimulacao { get; set; }
    [ForeignKey(nameof(IdSimulacao))]
    public SimulacaoEdc? Simulacao { get; set; }

    [Required]
    public int IdProduto { get; set; }
    [ForeignKey(nameof(IdProduto))]
    public ProdutoEdc? Produto { get; set; }

    [Column(TypeName = "numeric(18,4)")]
    public decimal Quantidade { get; set; }

    [Column(TypeName = "numeric(18,2)")]
    public decimal ValorFobUnitario { get; set; }

    // Campos calculados/copiados do produto no momento do estudo para histórico
    [Column(TypeName = "numeric(18,4)")]
    public decimal PesoLiquidoTotal { get; set; }

    [Column(TypeName = "numeric(18,4)")]
    public decimal PesoBrutoTotal { get; set; }

    [Column(TypeName = "numeric(18,4)")]
    public decimal CubagemTotal { get; set; }
}
