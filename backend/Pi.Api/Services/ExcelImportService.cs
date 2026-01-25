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
                throw new Exception($"Erro na linha {row}: {ex.Message}", ex);
            }
        }

        await _context.SaveChangesAsync();
    }

    public async Task ImportarKoyoAsync(Stream stream, long idFornecedor)
    {
        using var package = new ExcelPackage(stream);

        // Pre-carregar dados para evitar N+1 queries (Cache)
        var categorias = await _context.Categorias.ToDictionaryAsync(x => x.Nome.ToLower().Trim(), x => x.Id);
        var marcas = await _context.Marcas.ToDictionaryAsync(x => x.Nome.ToLower().Trim(), x => x.Id);
        
        // Carregar TODOS módulos deste fornecedor para busca rápida (chave composta: idCategoria + idMarca + descricao)
        var modulosDb = await _context.Modulos
            .Where(x => x.IdFornecedor == idFornecedor)
            .Include(x => x.ModulosTecidos)
            .ToListAsync();
            
        // Dicionário composto para lookup de módulos
        // Chave: "catId|marcaId|descricao" (tudo minúsculo)
        var modulosDict = new Dictionary<string, Modulo>();
        foreach(var m in modulosDb)
        {
            string key = $"{m.IdCategoria}|{m.IdMarca}|{m.Descricao.ToLower().Trim()}";
            if (!modulosDict.ContainsKey(key))
                modulosDict[key] = m;
        }

        // Dicionário de tecidos (nome -> id)
        var tecidos = await _context.Tecidos.ToDictionaryAsync(x => x.Nome.ToLower().Trim(), x => x.Id);

        // --- RESET SEQUENCE IF NEEDED (Fix for PK_tecido unique violation) ---
        // Se houver dados importados manualmente, a sequence pode estar atrasada.
        try
        {
             // Postgres specific: reset sequence to MAX(id) + 1
             await _context.Database.ExecuteSqlRawAsync("SELECT setval('tecido_id_seq', (SELECT COALESCE(MAX(id), 0) + 1 FROM tecido), false);");
        }
        catch (Exception) 
        { 
            // Ignore if sequence name differs or permission denied, try continuing
        }

        // --- PRE-CREATE KOYO FABRICS (G0-G10) ---
        // Nomes usados pela Koyo
        var koyoTecidoNames = new[] { "G0", "G1", "G2", "G3", "G4", "G5", "G6", "G7", "G8", "G9", "G10" };
        bool savedTecidos = false;
        foreach (var tName in koyoTecidoNames)
        {
            if (!tecidos.ContainsKey(tName.ToLower()))
            {
                var novo = new Tecido { Nome = tName };
                _context.Tecidos.Add(novo);
                // Precisamos salvar para gerar ID, pois usamos ID no dicionário e nos relacionamentos subsequentes
                // Se tentarmos agrupar todos, ok, mas para garantir ID vamos salvar um batch se houver novos.
            }
        }
        // Save just once for all new fabrics
        if (_context.ChangeTracker.HasChanges())
        {
             await _context.SaveChangesAsync();
             // Rebuild dict or just update it? Update is efficient.
             // But simple way: reload or just add local.
             // Since we saved, IDs are generated.
             foreach(var tEntry in _context.Tecidos.Local)
             {
                 var key = tEntry.Nome.ToLower().Trim();
                 if(!tecidos.ContainsKey(key))
                    tecidos[key] = tEntry.Id;
             }
        }
        // ----------------------------------------
        
        // Col Mapping: G0->12, G1->13 ... G7->19, G8->8, G9->9, G10->10
        var mapping = new (string Nome, int Col)[] {
            ("G0", 12), ("G1", 13), ("G2", 14), ("G3", 15), ("G4", 16),
            ("G5", 17), ("G6", 18), ("G7", 19), ("G8", 8),  ("G9", 9), ("G10", 10)
        };

        foreach (var worksheet in package.Workbook.Worksheets)
        {
            // Nome da aba = Categoria
            string nomeCategoria = worksheet.Name.Trim();
            // Ignorar abas de sistema ou ocultas se houver
            if (string.IsNullOrEmpty(nomeCategoria)) continue;

            // 1. Garantir Categoria
            if (!categorias.TryGetValue(nomeCategoria.ToLower(), out var idCategoria))
            {
                var novaCat = new Categoria { Nome = nomeCategoria };
                _context.Categorias.Add(novaCat);
                await _context.SaveChangesAsync();
                idCategoria = novaCat.Id;
                categorias[nomeCategoria.ToLower()] = idCategoria;
            }

            int rowCount = worksheet.Dimension.Rows;
            // Koyo começa dados geralmente na linha 2, mas vamos validar linha a linha
            for (int row = 1; row <= rowCount; row++)
            {
                // Lógica para ignorar cabeçalhos repetidos
                // Coluna B: Descrição
                var cellDesc = worksheet.Cells[row, 2].Value?.ToString()?.Trim();
                if (string.IsNullOrEmpty(cellDesc) || cellDesc.Equals("Descrição", StringComparison.OrdinalIgnoreCase))
                    continue;

                // Coluna C: Largura
                var cellLarg = worksheet.Cells[row, 3].Value?.ToString()?.Trim();
                if (cellLarg != null && cellLarg.Equals("Larg", StringComparison.OrdinalIgnoreCase)) continue;

                    // Coluna D: Prof
                var cellProf = worksheet.Cells[row, 4].Value?.ToString()?.Trim();
                if (cellProf != null && cellProf.Equals("Prof", StringComparison.OrdinalIgnoreCase)) continue;
                
                // Coluna E: Altura
                var cellAlt = worksheet.Cells[row, 5].Value?.ToString()?.Trim();
                if (cellAlt != null && cellAlt.Equals("Altura", StringComparison.OrdinalIgnoreCase)) continue;

                // 2. Garantir Marca (Coluna A)
                var nomeMarca = worksheet.Cells[row, 1].Value?.ToString()?.Trim() ?? "GERAL";
                if (!marcas.TryGetValue(nomeMarca.ToLower(), out var idMarca))
                {
                    var novaMarca = new Marca { Nome = nomeMarca };
                    _context.Marcas.Add(novaMarca);
                    await _context.SaveChangesAsync();
                    idMarca = novaMarca.Id;
                    marcas[nomeMarca.ToLower()] = idMarca;
                }

                // 3. Processar Módulo
                // Colunas: B (Desc), C (Larg), D (Prof), E (Alt)
                // PA sempre 0 para Koyo
                string descricao = cellDesc;
                decimal largura = ParseDecimal(worksheet.Cells[row, 3].Value);
                decimal profundidade = ParseDecimal(worksheet.Cells[row, 4].Value);
                decimal altura = ParseDecimal(worksheet.Cells[row, 5].Value);
                decimal pa = 0; // Koyo PA=0 fixo

                string modKey = $"{idCategoria}|{idMarca}|{descricao.ToLower()}";
                Modulo modulo;

                if (modulosDict.TryGetValue(modKey, out var existingMod))
                {
                    modulo = existingMod;
                    // Atualizar dimensões
                    modulo.Largura = largura;
                    modulo.Profundidade = profundidade;
                    modulo.Altura = altura;
                    modulo.Pa = pa;
                    modulo.M3 = Math.Round(largura * profundidade * altura, 2);
                    
                    // _context.Entry(modulo).State = EntityState.Modified; // Attach já cuida disso se estiver tracked
                }
                else
                {
                    modulo = new Modulo
                    {
                        IdFornecedor = idFornecedor,
                        IdCategoria = idCategoria,
                        IdMarca = idMarca,
                        Descricao = descricao,
                        Largura = largura,
                        Profundidade = profundidade,
                        Altura = altura,
                        Pa = pa,
                        M3 = Math.Round(largura * profundidade * altura, 2),
                        ModulosTecidos = new List<ModuloTecido>()
                    };
                    _context.Modulos.Add(modulo);
                    await _context.SaveChangesAsync(); // Save to get ID
                    modulosDict[modKey] = modulo;
                    
                    // Inicializar lista se for null (ef)
                    if(modulo.ModulosTecidos == null) modulo.ModulosTecidos = new List<ModuloTecido>();
                }

                // 4. Processar Tecidos (Colunas mapeadas)
                foreach (var (tecidoNome, colIndex) in mapping)
                {
                    var cellVal = worksheet.Cells[row, colIndex].Value;
                    if (cellVal == null) continue;

                    string valString = cellVal.ToString()!.Trim();
                    // Ignorar cabeçalhos de coluna de tecido (ex: se coluna L tiver "G0" escrito)
                    if (valString.Equals(tecidoNome, StringComparison.OrdinalIgnoreCase)) continue;
                    if (string.IsNullOrEmpty(valString)) continue;

                    decimal valor = ParseDecimal(cellVal);
                    
                    // Retrieve ID - Guaranteed to exist now
                    if (tecidos.TryGetValue(tecidoNome.ToLower(), out var idTecido))
                    {
                        // Upsert ModuloTecido
                         // Check local list first (memory)
                        var modTecido = modulo.ModulosTecidos.FirstOrDefault(mt => mt.IdTecido == idTecido);
                        if (modTecido != null)
                        {
                            modTecido.ValorTecido = valor;
                        }
                        else
                        {
                            var novoModTecido = new ModuloTecido
                            {
                                IdModulo = modulo.Id,
                                IdTecido = idTecido,
                                ValorTecido = valor
                            };
                            _context.ModulosTecidos.Add(novoModTecido);
                            modulo.ModulosTecidos.Add(novoModTecido);
                        }
                    }
                }
            }
        }

        await _context.SaveChangesAsync();
    }

    private decimal ParseDecimal(object? value)
    {
        if (value == null) return 0;
        if (value is double d) return (decimal)d;
        if (value is decimal dec) return dec;
        if (decimal.TryParse(value.ToString(), out var result)) return result;
        return 0;
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
                // Check Local then DB (Use Local cache if possible)
                // For simplified tracked lookup in loop:
                var modulo = await _context.Modulos
                     .FirstOrDefaultAsync(m => m.IdFornecedor == idFornecedor 
                                            && m.IdMarca == marca.Id // Issue: marca.Id might be 0 if new.
                                            && m.Descricao.ToUpper() == descricao.ToUpper());
                                            
                // Logic Fix: if marca is new, modulo must be new.
                if (marca.Id == 0) modulo = null;

                if (modulo == null)
                {
                    modulo = new Modulo
                    {
                        IdFornecedor = idFornecedor,
                        Marca = marca,   // Link Object
                        Categoria = categoria, // Link Object
                        IdMarca = marca.Id, // Might be 0 but EF fixes link
                        IdCategoria = categoria.Id,
                        Descricao = descricao,
                        Largura = larg,
                        Profundidade = prof,
                        Altura = alt,
                        Pa = pa,
                        // M3 computed by trigger or class (not here)
                        M3 = (larg * prof * alt) / 1000000m
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
                    modulo.M3 = (larg * prof * alt) / 1000000m;
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
                        // Upsert ModuloTecido
                        // Check local list first (memory) for new items added in loop
                        // To allow concurrent adds of same tecido to multiple modules
                        
                        // Just Add to context? No, we need to check if exists.
                        // Since modulo might be new or existing.
                        
                        ModuloTecido? mt = null;
                        if (modulo.Id > 0)
                        {
                             mt = await _context.ModulosTecidos
                                .FirstOrDefaultAsync(x => x.IdModulo == modulo.Id && x.IdTecido == tecido.Id);
                        }

                        if (mt == null)
                        {
                            mt = new ModuloTecido
                            {
                                Modulo = modulo, // Link Object
                                Tecido = tecido,  // Link Object
                                ValorTecido = price
                            };
                            _context.ModulosTecidos.Add(mt);
                        }
                        else
                        {
                             mt.ValorTecido = price;
                        }
                    }
                }
            }
        }

        // ONE SAVE TO RULE THEM ALL
        await _context.SaveChangesAsync();
    }
}
