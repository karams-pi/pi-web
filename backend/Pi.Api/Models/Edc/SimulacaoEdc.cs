
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models.Edc;

[Table("simulacoes", Schema = "edc")]
public class SimulacaoEdc
{
    [Key]
    public int Id { get; set; }

    [Required]
    [MaxLength(50)]
    public string NumeroReferencia { get; set; } = string.Empty;

    public DateTime DataEstudo { get; set; } = DateTime.UtcNow;

    [Required]
    public int IdImportador { get; set; }
    [ForeignKey(nameof(IdImportador))]
    public Importador? Importador { get; set; }

    [Required]
    public int IdExportador { get; set; }
    [ForeignKey(nameof(IdExportador))]
    public Exportador? Exportador { get; set; }

    public int? IdPortoOrigem { get; set; }
    [ForeignKey(nameof(IdPortoOrigem))]
    public Porto? PortoOrigem { get; set; }

    public int? IdPortoDestino { get; set; }
    [ForeignKey(nameof(IdPortoDestino))]
    public Porto? PortoDestino { get; set; }

    [Column(TypeName = "numeric(18,4)")]
    public decimal CotacaoDolar { get; set; }

    [Column(TypeName = "numeric(18,4)")]
    public decimal SpreadCambio { get; set; }

    [MaxLength(20)]
    public string TipoFrete { get; set; } = "FOB"; // FOB, CIF, CFR

    [MaxLength(50)]
    public string? ModalidadeFrete { get; set; } = "1x40";

    [Column(TypeName = "numeric(18,2)")]
    public decimal ValorFreteInternacional { get; set; }

    [Column(TypeName = "numeric(18,2)")]
    public decimal ValorSeguroInternacional { get; set; }

    [Column(TypeName = "numeric(18,4)")]
    public decimal ComissaoPercentual { get; set; }

    public bool FlExibirComissao { get; set; } = false;

    public bool FlSimularSubfaturamento { get; set; } = false;

    [Column(TypeName = "numeric(18,4)")]
    public decimal PercentualSubfaturamento { get; set; } = 50m;

    [MaxLength(50)]
    public string MetodoCalculoIcms { get; set; } = "SimplificadoExcel";

    [MaxLength(50)]
    public string MetodoCalculoFederais { get; set; } = "SimplificadoExcel";

    [MaxLength(50)]
    public string Status { get; set; } = "Rascunho"; // Rascunho, Aprovado, Arquivado

    public List<SimulacaoEdcItem> Itens { get; set; } = new();
    public List<SimulacaoEdcDespesa> Despesas { get; set; } = new();
}
