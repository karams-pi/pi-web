using System.Collections.Generic;

namespace Pi.Api.Models
{
    public class ImportResult
    {
        public int TotalFilasProcessadas { get; set; }
        public int TotalModulosImportados { get; set; }
        public List<string> Discrepancias { get; set; } = new List<string>();
        public List<ImportedItemDetail> ItensImportados { get; set; } = new List<ImportedItemDetail>();
        public bool Sucesso => Discrepancias.Count == 0;
    }

    public class ImportedItemDetail
    {
        public int Linha { get; set; }
        public long IdModulo { get; set; }
        public long? IdModuloTecido { get; set; }
        public string Descricao { get; set; } = string.Empty;
        
        // Database values
        public decimal Largura { get; set; }
        public decimal Altura { get; set; }
        public decimal Profundidade { get; set; }
        public decimal M3 { get; set; }
        public decimal ValorTecido { get; set; }

        // Excel values (original)
        public decimal LarguraExcel { get; set; }
        public decimal AlturaExcel { get; set; }
        public decimal ProfundidadeExcel { get; set; }
        public decimal ValorExcel { get; set; }
        
        public string Tecido { get; set; } = string.Empty;
        public string Status { get; set; } = "OK"; // OK, Novo, Divergente, Sincronizado, Erro
    }

    public class SyncRequest
    {
        public long IdFornecedor { get; set; }
        public List<SyncItem> Itens { get; set; } = new List<SyncItem>();
    }

    public class SyncItem
    {
        public int Linha { get; set; }
        public long IdModulo { get; set; }
        public long? IdModuloTecido { get; set; }
        public decimal Largura { get; set; }
        public decimal Altura { get; set; }
        public decimal Profundidade { get; set; }
        public string Tecido { get; set; } = string.Empty;
        public decimal Valor { get; set; }
    }
}
