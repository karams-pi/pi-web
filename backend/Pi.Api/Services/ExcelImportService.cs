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
        // First, check Local (tracked) entities to avoid "duplicate key" if we just added it in this transaction context
        var mt = _context.ModulosTecidos.Local
            .FirstOrDefault(x => x.IdModulo == idModulo && x.IdTecido == idTecido);

        if (mt == null)
        {
            // If not in local, check DB
            mt = await _context.ModulosTecidos
                .FirstOrDefaultAsync(x => x.IdModulo == idModulo && x.IdTecido == idTecido);
        }

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
    }
    public async Task ImportarKaramsAsync(Stream fileStream, long idFornecedor)
    {
        using var package = new ExcelPackage(fileStream);

        // 1. Validate Fornecedor
        var fornecedor = await _context.Fornecedores.FindAsync(idFornecedor);
        if (fornecedor == null)
            throw new Exception($"Fornecedor com ID {idFornecedor} não encontrado.");

        // === PRE-LOADING CACHES ===
        // Load all Categories and Marcas to memory to avoid N+1 queries
        var categoriasCache = await _context.Categorias.ToListAsync();
        var marcasCache = await _context.Marcas.ToListAsync();
        var tecidosCache = await _context.Tecidos.ToListAsync();
        
        // Dictionary for fast lookup (Case Insensitive)
        var categoriasMap = new Dictionary<string, Categoria>(StringComparer.OrdinalIgnoreCase);
        foreach (var c in categoriasCache) categoriasMap[c.Nome] = c;

        var marcasMap = new Dictionary<string, Marca>(StringComparer.OrdinalIgnoreCase);
        foreach (var m in marcasCache) marcasMap[m.Nome] = m;
        
        var tecidosMap = new Dictionary<string, Tecido>(StringComparer.OrdinalIgnoreCase);
        foreach (var t in tecidosCache) tecidosMap[t.Nome] = t;

        // Modulos mapping is complex (Descricao + Marca + Fornecedor). 
        // We will query DB + Local for Modulos as needed or try to preload.
        // Preloading all modulos might be heavy. Let's use tracked lookup.

        foreach (var worksheet in package.Workbook.Worksheets)
        {
            var categoriaNome = worksheet.Name.Trim();
            
            // Get/Create Categoria
            if (!categoriasMap.TryGetValue(categoriaNome, out var categoria))
            {
                categoria = new Categoria { Nome = categoriaNome };
                _context.Categorias.Add(categoria);
                categoriasMap[categoriaNome] = categoria; // Cache it
            }

            var rowCount = worksheet.Dimension.Rows;

            var tecidoMappings = new Dictionary<string, int>
            {
                { "G0", 8 }, { "G1", 9 }, { "G2", 10 }, { "G3", 11 }, { "G4", 12 },
                { "G5", 13 }, { "G6", 14 }, { "G7", 15 }, { "G8", 16 }
            };

            // Ensure Tecidos G0-G8 exist in cache
            foreach (var tecidoName in tecidoMappings.Keys)
            {
                if (!tecidosMap.ContainsKey(tecidoName))
                {
                    var newTecido = new Tecido { Nome = tecidoName };
                    _context.Tecidos.Add(newTecido);
                    tecidosMap[tecidoName] = newTecido;
                }
            }

            for (int row = 2; row <= rowCount; row++)
            {
                // === Reads & Validations ===
                var marcaNome = worksheet.Cells[row, 1].Text?.Trim();
                if (string.IsNullOrEmpty(marcaNome) || marcaNome == "Marca") continue;

                var descricao = worksheet.Cells[row, 2].Text?.Trim();
                if (string.IsNullOrEmpty(descricao) || descricao == "Descrição") continue;

                var largText = worksheet.Cells[row, 3].Text?.Trim();
                if (string.IsNullOrEmpty(largText) || largText == "Larg") continue;
                decimal.TryParse(largText, out var larg);

                var profText = worksheet.Cells[row, 4].Text?.Trim();
                if (string.IsNullOrEmpty(profText) || profText == "Prof") continue;
                decimal.TryParse(profText, out var prof);

                decimal pa = 0;

                var altText = worksheet.Cells[row, 6].Text?.Trim();
                if (string.IsNullOrEmpty(altText) || altText == "Altura") continue;
                decimal.TryParse(altText, out var alt);

                // === Get/Create Marca ===
                if (!marcasMap.TryGetValue(marcaNome, out var marca))
                {
                    marca = new Marca { Nome = marcaNome };
                    _context.Marcas.Add(marca);
                    marcasMap[marcaNome] = marca;
                }

                // === Get/Create Modulo ===
                // Check Local then DB
                var modulo = _context.Modulos.Local
                    .FirstOrDefault(m => m.IdFornecedor == idFornecedor 
                                      && m.Marca == marca // Compare object ref if new, or Id if existing? 
                                                          // Mix is tricky. Better compare by Logical Keys.
                                      && m.Descricao.Equals(descricao, StringComparison.OrdinalIgnoreCase));
                
                if (modulo == null)
                {
                    // If not in local, check DB (BUT: We need to use ID for Marca if it exists, or... wait.
                    // If Marca is NEW, it has no ID. We can't query DB for Modulo with MarginId=0.
                    // But if Marca IS new, Modulo MUST be new (referenced marca doesn't exist in DB).
                    // So we only check DB if Marca has ID > 0.
                    
                    if (marca.Id > 0)
                    {
                        modulo = await _context.Modulos
                            .FirstOrDefaultAsync(m => m.IdFornecedor == idFornecedor 
                                                   && m.IdMarca == marca.Id 
                                                   && m.Descricao.ToUpper() == descricao.ToUpper());
                    }
                }

                if (modulo == null)
                {
                    modulo = new Modulo
                    {
                        IdFornecedor = idFornecedor,
                        Marca = marca,   // Link Object
                        Categoria = categoria, // Link Object
                        Descricao = descricao,
                        Largura = larg,
                        Profundidade = prof,
                        Altura = alt,
                        Pa = pa,
                        // M3 is computed
                    };
                    _context.Modulos.Add(modulo);
                }
                else
                {
                    // Update
                    modulo.Categoria = categoria; // Link Object to ensure consistency
                    modulo.Marca = marca;
                    modulo.Largura = larg;
                    modulo.Profundidade = prof;
                    modulo.Altura = alt;
                    modulo.Pa = pa;
                }

                // === Process Tecidos (G0-G8) ===
                foreach (var kvp in tecidoMappings)
                {
                    var tecName = kvp.Key;
                    var colIndex = kvp.Value;
                    var tecido = tecidosMap[tecName]; // Object

                    var priceText = worksheet.Cells[row, colIndex].Text?.Trim();
                    if (string.IsNullOrEmpty(priceText) || priceText == tecName || priceText == "Tecido") 
                        continue;

                    if (decimal.TryParse(priceText, out var price) && price > 0)
                    {
                        // Upsert ModuloTecido (Check Local first!)
                        var mt = _context.ModulosTecidos.Local
                            .FirstOrDefault(x => x.Modulo == modulo && x.Tecido == tecido); // Link Objects

                        if (mt == null)
                        {
                            // Logic: If Modulo OR Tecido is new (Id=0), keys won't match in DB anyway.
                            // Only check DB if both have Ids.
                            if (modulo.Id > 0 && tecido.Id > 0)
                            {
                                mt = await _context.ModulosTecidos
                                    .FirstOrDefaultAsync(x => x.IdModulo == modulo.Id && x.IdTecido == tecido.Id);
                            }
                        }

                        if (mt == null)
                        {
                            mt = new ModuloTecido
                            {
                                Modulo = modulo, // Link Object
                                Tecido = tecido  // Link Object
                            };
                            _context.ModulosTecidos.Add(mt);
                        }

                        mt.ValorTecido = price;
                    }
                }
            }
        }

        // ONE SAVE TO RULE THEM ALL
        await _context.SaveChangesAsync();
    }
}
