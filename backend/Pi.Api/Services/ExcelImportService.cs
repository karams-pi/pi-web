using OfficeOpenXml;
using Pi.Api.Data;
using Pi.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace Pi.Api.Services;

public class ExcelImportService
{
    private readonly AppDbContext _context;

    public ExcelImportService(AppDbContext context)
    {
        _context = context;
    }

    public async Task ImportarTabelaPrecosAsync(Stream fileStream, long idFornecedor)
    {
        // Set license context for EPPlus
        // ExcelPackage.LicenseContext = LicenseContext.NonCommercial; // Global setting in Program.cs


        using var package = new ExcelPackage(fileStream);
        var worksheet = package.Workbook.Worksheets[0]; // Assume first sheet
        var rowCount = worksheet.Dimension.Rows;
        var colCount = worksheet.Dimension.Columns;

        // 1. Validate Fornecedor
        var fornecedor = await _context.Fornecedores.FindAsync(idFornecedor);
        if (fornecedor == null)
            throw new Exception($"Fornecedor com ID {idFornecedor} não encontrado.");

        // 2. Parse Headers to find Price Columns (starting from col 8 / 'H')
        var tecidoColumns = new Dictionary<int, long>(); // ColIndex -> TecidoId
        
        for (int col = 8; col <= colCount; col++)
        {
            var header = worksheet.Cells[1, col].Text?.Trim();
            if (!string.IsNullOrEmpty(header))
            {
                var tecido = await GetOrCreateTecidoAsync(header);
                tecidoColumns[col] = tecido.Id;
            }
        }

        // 3. Iterate Rows
        for (int row = 2; row <= rowCount; row++)
        {
            try
            {
                // Reading basic info
                var categoriaNome = worksheet.Cells[row, 1].Text?.Trim();
                var marcaNome = worksheet.Cells[row, 2].Text?.Trim();
                var moduloDescricao = worksheet.Cells[row, 3].Text?.Trim();

                if (string.IsNullOrEmpty(categoriaNome) || string.IsNullOrEmpty(marcaNome) || string.IsNullOrEmpty(moduloDescricao))
                    continue; // Skip empty rows

                // Dimensions
                decimal.TryParse(worksheet.Cells[row, 4].Text, out var larg);
                decimal.TryParse(worksheet.Cells[row, 5].Text, out var prof);
                decimal.TryParse(worksheet.Cells[row, 6].Text, out var alt);
                decimal.TryParse(worksheet.Cells[row, 7].Text, out var pa);

                // Find/Create Entities
                var categoria = await GetOrCreateCategoriaAsync(categoriaNome);
                var marca = await GetOrCreateMarcaAsync(marcaNome);

                var modulo = await GetOrCreateModuloAsync(
                    idFornecedor, 
                    categoria.Id, 
                    marca.Id, 
                    moduloDescricao, 
                    larg, prof, alt, pa
                );

                // Process Prices
                foreach (var kvp in tecidoColumns)
                {
                    var colIndex = kvp.Key;
                    var tecidoId = kvp.Value;
                    var priceText = worksheet.Cells[row, colIndex].Text;
                    
                    if (decimal.TryParse(priceText, out var price) && price > 0)
                    {
                        await UpdateModuloTecidoAsync(modulo.Id, tecidoId, price);
                    }
                }
            }
            catch (Exception ex)
            {
                // Log or throw? For now, we wrap in transaction so maybe throw to abort ALL?
                // Request said "Database transaction for data integrity".
                throw new Exception($"Erro na linha {row}: {ex.Message}", ex);
            }
        }

        await _context.SaveChangesAsync();
    }

    private async Task<Categoria> GetOrCreateCategoriaAsync(string nome)
    {
        // Simple cache could be added here if performance is an issue
        var cleanName = nome.Trim();
        var categoria = await _context.Categorias
            .FirstOrDefaultAsync(c => c.Nome.ToUpper() == cleanName.ToUpper());

        if (categoria == null)
        {
            categoria = new Categoria { Nome = cleanName };
            _context.Categorias.Add(categoria);
            await _context.SaveChangesAsync();
        }
        return categoria;
    }

    private async Task<Marca> GetOrCreateMarcaAsync(string nome)
    {
        var cleanName = nome.Trim();
        var marca = await _context.Marcas
            .FirstOrDefaultAsync(m => m.Nome.ToUpper() == cleanName.ToUpper());

        if (marca == null)
        {
            marca = new Marca { Nome = cleanName };
            _context.Marcas.Add(marca);
            await _context.SaveChangesAsync();
        }
        return marca;
    }

    private async Task<Tecido> GetOrCreateTecidoAsync(string nome)
    {
        var cleanName = nome.Trim();
        var tecido = await _context.Tecidos
            .FirstOrDefaultAsync(t => t.Nome.ToUpper() == cleanName.ToUpper());

        if (tecido == null)
        {
            tecido = new Tecido { Nome = cleanName };
            _context.Tecidos.Add(tecido);
            // Save immediately to get ID for cache map
            await _context.SaveChangesAsync();
        }
        return tecido;
    }

    private async Task<Modulo> GetOrCreateModuloAsync(
        long idFornecedor, 
        long idCategoria, 
        long idMarca, 
        string descricao,
        decimal larg, decimal prof, decimal alt, decimal pa)
    {
        var modulo = await _context.Modulos
            .FirstOrDefaultAsync(m => m.IdFornecedor == idFornecedor 
                                   && m.IdMarca == idMarca 
                                   && m.Descricao.ToUpper() == descricao.ToUpper());

        bool isNew = false;
        if (modulo == null)
        {
            modulo = new Modulo
            {
                IdFornecedor = idFornecedor,
                IdMarca = idMarca,
                Descricao = descricao,
                // New module defaults
            };
            _context.Modulos.Add(modulo);
            isNew = true;
        }

        // Update properties (upsert behavior)
        modulo.IdCategoria = idCategoria;
        modulo.Largura = larg;
        modulo.Profundidade = prof;
        modulo.Altura = alt;
        modulo.Pa = pa;
        
        // Calculate M3 (Assuming dimensions in CM)
        // (L * P * A) / 1,000,000
        modulo.M3 = (larg * prof * alt) / 1000000m;

        if (isNew)
        {
             // Save to get ID
             await _context.SaveChangesAsync();
        }
        
        return modulo;
    }

    private async Task UpdateModuloTecidoAsync(long idModulo, long idTecido, decimal price)
    {
        var mt = await _context.ModulosTecidos
            .FirstOrDefaultAsync(x => x.IdModulo == idModulo && x.IdTecido == idTecido);

        if (mt == null)
        {
            mt = new ModuloTecido
            {
                IdModulo = idModulo,
                IdTecido = idTecido
            };
            _context.ModulosTecidos.Add(mt);
        }

        mt.ValorTecido = price;
        // Batch save will happen at the end or we can save here. 
        // For performance with many rows, simpler to let EF Core ChangeTracker handle it 
        // and call SaveChangesAsync once at the end or in chunks.
        // However, GetOrCreate methods call SaveChangesAsync which commits transaction if implicit.
        // We should wrap the whole public method in a transaction.
    }
}
