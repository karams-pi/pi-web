using OfficeOpenXml;
using Pi.Api.Data;
using Pi.Api.Models;
using Microsoft.EntityFrameworkCore;
using System.Globalization;
using System.IO.Compression;
using System.Text.RegularExpressions;

namespace Pi.Api.Services;

public class ExcelImportService
{
    private readonly AppDbContext _context;

    public ExcelImportService(AppDbContext context)
    {
        _context = context;
    }

    public async Task ImportarTabelaPrecosAsync(Stream fileStream, long idFornecedor, DateTime? dtRevisao = null)
    {
        if (dtRevisao.HasValue) 
             dtRevisao = DateTime.SpecifyKind(dtRevisao.Value, DateTimeKind.Utc);

        using var sanitizedStream = SanitizeExcelFile(fileStream);
        using var package = new ExcelPackage(sanitizedStream);
        var worksheet = package.Workbook.Worksheets[0]; // Assume first sheet
        var rowCount = worksheet.Dimension.Rows;
        var colCount = worksheet.Dimension.Columns;

        // 1. Validate Fornecedor
        var fornecedor = await _context.Fornecedores.FindAsync(idFornecedor);
        if (fornecedor == null)
            throw new Exception($"Fornecedor com ID {idFornecedor} não encontrado.");

        var deactivateSql = @"
            UPDATE modulo_tecido 
            SET fl_ativo = false 
            WHERE id_modulo IN (SELECT id FROM modulo WHERE id_fornecedor = {0})";
        await _context.Database.ExecuteSqlRawAsync(deactivateSql, idFornecedor);

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
                        await UpdateModuloTecidoAsync(modulo.Id, tecidoId, price, dtRevisao);
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

    public async Task ImportarKoyoAsync(Stream stream, long idFornecedor, DateTime? dtRevisao = null)
    {
        if (dtRevisao.HasValue) 
             dtRevisao = DateTime.SpecifyKind(dtRevisao.Value, DateTimeKind.Utc);

        await ResetSequencesAsync();

        var originalCulture = CultureInfo.CurrentCulture;
        try
        {
            CultureInfo.CurrentCulture = new CultureInfo("pt-BR");

            using var sanitizedStream = SanitizeExcelFile(stream);
            using var package = new ExcelPackage(sanitizedStream);

            var deactivateSql = @"
                UPDATE modulo_tecido 
                SET fl_ativo = false 
                WHERE id_modulo IN (SELECT id FROM modulo WHERE id_fornecedor = {0})";
            await _context.Database.ExecuteSqlRawAsync(deactivateSql, idFornecedor);

            // Pre-carregar dados para evitar N+1 queries (Cache)
            var categorias = await _context.Categorias.ToDictionaryAsync(x => x.Nome.ToLower().Trim(), x => x.Id);
            var marcas = await _context.Marcas.ToDictionaryAsync(x => x.Nome.ToLower().Trim(), x => x.Id);
            
            var modulosDb = await _context.Modulos
                .Where(x => x.IdFornecedor == idFornecedor)
                .Include(x => x.ModulosTecidos)
                .ToListAsync();
                
            var modulosDict = new Dictionary<string, Modulo>();
            foreach(var m in modulosDb)
            {
                // Chave: catId|marcaId|descricao|largura
                string key = $"{m.IdCategoria}|{m.IdMarca}|{NormalizeString(m.Descricao)}|{m.Largura.ToString("F2", CultureInfo.InvariantCulture)}";
                if (!modulosDict.ContainsKey(key))
                    modulosDict[key] = m;
            }

            var tecidos = await _context.Tecidos.ToDictionaryAsync(x => x.Nome.ToLower().Trim(), x => x.Id);

            // --- PRE-CREATE KOYO FABRICS (G0-G10) ---
            var koyoTecidoNames = new[] { "G0", "G1", "G2", "G3", "G4", "G5", "G6", "G7", "G8", "G9", "G10" };
            foreach (var tName in koyoTecidoNames)
            {
                if (!tecidos.ContainsKey(tName.ToLower()))
                {
                    var novo = new Tecido { Nome = tName };
                    _context.Tecidos.Add(novo);
                }
            }
            if (_context.ChangeTracker.HasChanges())
            {
                 await _context.SaveChangesAsync();
                 foreach(var tEntry in _context.Tecidos.Local)
                 {
                     var key = tEntry.Nome.ToLower().Trim();
                     if(!tecidos.ContainsKey(key))
                        tecidos[key] = tEntry.Id;
                 }
            }
            
            var fabricCodes = new[] { "G0", "G1", "G2", "G3", "G4", "G5", "G6", "G7", "G8", "G9", "G10" };

            foreach (var worksheet in package.Workbook.Worksheets)
            {
                if (worksheet.Dimension == null) continue;
                string nomeCategoria = worksheet.Name.Trim();
                if (string.IsNullOrEmpty(nomeCategoria)) continue;

                if (!categorias.TryGetValue(nomeCategoria.ToLower(), out var idCategoria))
                {
                    var novaCat = new Categoria { Nome = nomeCategoria };
                    _context.Categorias.Add(novaCat);
                    await _context.SaveChangesAsync();
                    idCategoria = novaCat.Id;
                    categorias[nomeCategoria.ToLower()] = idCategoria;
                }

                // --- DYNAMIC HEADER MAPPING ---
                var currentMapping = new Dictionary<string, int>();
                int colCount = worksheet.Dimension.Columns;
                for (int col = 1; col <= colCount; col++)
                {
                    var header = worksheet.Cells[1, col].Text?.Trim().ToUpper();
                    if (string.IsNullOrEmpty(header)) continue;
                    
                    if (fabricCodes.Any(code => code.Equals(header, StringComparison.OrdinalIgnoreCase)))
                    {
                        currentMapping[header.ToUpper()] = col;
                    }
                }

                int rowCount = worksheet.Dimension.Rows;
                // Start from row 2 if row 1 is headers, but Koyo usually has data scatter. 
                // We'll process from row 1 but skip rows that match headers.
                for (int row = 1; row <= rowCount; row++)
                {
                    var cellDesc = worksheet.Cells[row, 2].Text?.Trim();
                    if (string.IsNullOrEmpty(cellDesc) || cellDesc.Equals("Descrição", StringComparison.OrdinalIgnoreCase))
                        continue;

                    var cellLargText = worksheet.Cells[row, 3].Text?.Trim();
                    if (cellLargText != null && cellLargText.Equals("Larg", StringComparison.OrdinalIgnoreCase)) continue;

                    var nomeMarca = worksheet.Cells[row, 1].Text?.Trim();
                    if (string.IsNullOrEmpty(nomeMarca) || nomeMarca.Equals("Marca", StringComparison.OrdinalIgnoreCase))
                        nomeMarca = "GERAL";

                    if (!marcas.TryGetValue(nomeMarca.ToLower(), out var idMarca))
                    {
                        var novaMarca = new Marca { Nome = nomeMarca };
                        _context.Marcas.Add(novaMarca);
                        await _context.SaveChangesAsync();
                        idMarca = novaMarca.Id;
                        marcas[nomeMarca.ToLower()] = idMarca;
                    }

                    string descricao = cellDesc;
                    decimal largura = UniversalParseDecimal(worksheet.Cells[row, 3].Value);
                    decimal profundidade = UniversalParseDecimal(worksheet.Cells[row, 4].Value);
                    decimal altura = UniversalParseDecimal(worksheet.Cells[row, 5].Value);
                    decimal pa = 0; 

                    string largKey = largura.ToString("F2", CultureInfo.InvariantCulture);
                    string modKey = $"{idCategoria}|{idMarca}|{NormalizeString(descricao)}|{largKey}";
                    Modulo modulo;

                    if (modulosDict.TryGetValue(modKey, out var existingMod))
                    {
                        modulo = existingMod;
                        modulo.Largura = largura;
                        modulo.Profundidade = profundidade;
                        modulo.Altura = altura;
                        modulo.Pa = pa;
                        modulo.M3 = (largura * profundidade * altura) / 1000000m;
                    }
                    else
                    {
                        modulo = new Modulo
                        {
                            IdFornecedor = idFornecedor,
                            IdCategoria = idCategoria,
                            IdMarca = idMarca,
                            Descricao = NormalizeString(descricao),
                            Largura = largura,
                            Profundidade = profundidade,
                            Altura = altura,
                            Pa = pa,
                            M3 = (largura * profundidade * altura) / 1000000m,
                            ModulosTecidos = new List<ModuloTecido>()
                        };
                        _context.Modulos.Add(modulo);
                        await _context.SaveChangesAsync(); 
                        modulosDict[modKey] = modulo;
                        if(modulo.ModulosTecidos == null) modulo.ModulosTecidos = new List<ModuloTecido>();
                    }

                    foreach (var kvp in currentMapping)
                    {
                        string tecidoNome = kvp.Key;
                        int colIndex = kvp.Value;
                        
                        var cellVal = worksheet.Cells[row, colIndex].Value;
                        // Skip if value is the header itself
                        if (cellVal == null || cellVal.ToString()!.Trim().Equals(tecidoNome, StringComparison.OrdinalIgnoreCase)) continue;

                        decimal valor = UniversalParseDecimal(cellVal);
                        
                        if (valor > 0 && tecidos.TryGetValue(tecidoNome.ToLower(), out var idTecido))
                        {
                            var novoModTecido = new ModuloTecido
                            {
                                IdModulo = modulo.Id,
                                IdTecido = idTecido,
                                ValorTecido = valor,
                                DtUltimaRevisao = dtRevisao,
                                FlAtivo = true
                            };
                            modulo.ModulosTecidos.Add(novoModTecido);
                            if (modulo.Id > 0) _context.ModulosTecidos.Add(novoModTecido);
                        }
                    }
                }
            }
            await _context.SaveChangesAsync();
        }
        finally
        {
            CultureInfo.CurrentCulture = originalCulture;
        }
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
                                   && m.Descricao.ToUpper() == descricao.ToUpper()
                                   && Math.Abs(m.Largura - larg) < 0.01m);

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

    private Task UpdateModuloTecidoAsync(long idModulo, long idTecido, decimal price, DateTime? dtRevisao = null)
    {
        var mt = new ModuloTecido
        {
            IdModulo = idModulo,
            IdTecido = idTecido,
            FlAtivo = true,
            ValorTecido = price,
            DtUltimaRevisao = dtRevisao
        };
        _context.ModulosTecidos.Add(mt);
        return Task.CompletedTask;
    }
    private Stream SanitizeExcelFile(Stream originalStream)
    {
        var memoryStream = new MemoryStream();
        originalStream.CopyTo(memoryStream);
        memoryStream.Position = 0;

        try
        {
            using (var archive = new ZipArchive(memoryStream, ZipArchiveMode.Update, leaveOpen: true))
            {
                var entriesToUpdate = new List<(string Name, string Content)>();

                foreach (var entry in archive.Entries)
                {
                    if (entry.FullName.StartsWith("xl/worksheets/") && entry.FullName.EndsWith(".xml"))
                    {
                        using var reader = new StreamReader(entry.Open());
                        var content = reader.ReadToEnd();
                        
                        // Fix for semicolon in mergeCell refs (e.g. ref="D1260;D214")
                        // Also handles inverted ranges (e.g. D1260:D214 -> D214:D1260) which cause EPPlus errors
                        if (content.Contains("ref=") && (content.Contains(";") || content.Contains(":")))
                        {
                            var pattern = "ref=\"([A-Za-z0-9;:]+)\"";
                            var newContent = Regex.Replace(content, pattern, match =>
                            {
                                string refsStr = match.Groups[1].Value;
                                if (!refsStr.Contains(';') && !refsStr.Contains(':')) return match.Value;

                                var parts = refsStr.Split(new[] { ';', ':' }, StringSplitOptions.RemoveEmptyEntries);
                                if (parts.Length < 2) return match.Value;

                                int minRow = int.MaxValue;
                                int maxRow = int.MinValue;
                                string minCol = "ZZZ";
                                string maxCol = "A";

                                foreach (var p in parts)
                                {
                                    var m = Regex.Match(p, "^([A-Za-z]+)([0-9]+)$");
                                    if (m.Success)
                                    {
                                        string c = m.Groups[1].Value.ToUpper();
                                        int r = int.Parse(m.Groups[2].Value);
                                        if (r < minRow) minRow = r;
                                        if (r > maxRow) maxRow = r;

                                        if (c.Length < minCol.Length || (c.Length == minCol.Length && string.Compare(c, minCol) < 0)) minCol = c;
                                        if (c.Length > maxCol.Length || (c.Length == maxCol.Length && string.Compare(c, maxCol) > 0)) maxCol = c;
                                    }
                                }

                                if (minRow != int.MaxValue)
                                {
                                    return $"ref=\"{minCol}{minRow}:{maxCol}{maxRow}\"";
                                }
                                return match.Value;
                            });

                            if (content != newContent)
                            {
                                entriesToUpdate.Add((entry.FullName, newContent));
                            }
                        }
                    }
                }

                foreach (var tool in entriesToUpdate)
                {
                    var entry = archive.GetEntry(tool.Name);
                    entry?.Delete();
                    var newEntry = archive.CreateEntry(tool.Name);
                    using var writer = new StreamWriter(newEntry.Open());
                    writer.Write(tool.Content);
                }
            }
        }
        catch (Exception ex)
        {
            // If sanitization fails, ignore and try processing original (rewound)
             Console.WriteLine($"Sanitization Warning: {ex.Message}");
        }

        memoryStream.Position = 0;
        return memoryStream;
    }

    public async Task ResetSequencesAsync()
    {
        try
        {
            // Executamos tudo em um único comando para otimizar e reduzir chance de timeout/queda de conexão
            var sql = @"
                DO $$
                DECLARE
                    r record;
                BEGIN
                    FOR r IN 
                        SELECT table_name, column_name 
                        FROM information_schema.columns 
                        WHERE table_name IN ('fornecedor', 'categoria', 'marca', 'tecido', 'modulo', 'modulo_tecido', 'frete_item', 'configuracoes_frete_item', 'pi', 'pi_item')
                          AND column_name = 'id'
                    LOOP
                        EXECUTE format('SELECT setval(pg_get_serial_sequence(%L, %L), COALESCE((SELECT MAX(id) FROM %I), 0) + 1, false)', 
                            r.table_name, r.column_name, r.table_name);
                    END LOOP;
                END $$;";

            await _context.Database.ExecuteSqlRawAsync(sql);
        }
        catch (Exception ex)
        {
            // Não falhar a importação inteira se apenas o reset de sequências falhar
            Console.WriteLine($"Aviso: Erro ao resetar sequências (pode ser ignorado se não houver conflito de IDs): {ex.Message}");
        }
    }

    public async Task ImportarKaramsAsync(Stream fileStream, long idFornecedor, DateTime? dtRevisao = null)
    {
        if (dtRevisao.HasValue) 
             dtRevisao = DateTime.SpecifyKind(dtRevisao.Value, DateTimeKind.Utc);

        var originalCulture = CultureInfo.CurrentCulture;
        try
        {
            CultureInfo.CurrentCulture = new CultureInfo("pt-BR");

            // Reset sequences inside try
            await ResetSequencesAsync();

            // Sanitize stream to fix "Invalid Address format" (semicolon in merged cells)
            using var sanitizedStream = SanitizeExcelFile(fileStream);
            using var package = new ExcelPackage(sanitizedStream);

            // 1. Validate Fornecedor
            var fornecedor = await _context.Fornecedores.FindAsync(idFornecedor);
            if (fornecedor == null)
                throw new Exception($"Fornecedor com ID {idFornecedor} não encontrado.");

            var deactivateSql = @"
                UPDATE modulo_tecido 
                SET fl_ativo = false 
                WHERE id_modulo IN (SELECT id FROM modulo WHERE id_fornecedor = {0})";
            await _context.Database.ExecuteSqlRawAsync(deactivateSql, idFornecedor);

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
                    // === Reads ===
                    var marcaNome = worksheet.Cells[row, 1].Text?.Trim();
                    var descricaoRaw = worksheet.Cells[row, 2].Text?.Trim();
                    var largText = worksheet.Cells[row, 3].Text?.Trim();
                    var profText = worksheet.Cells[row, 4].Text?.Trim();
                    var altText = worksheet.Cells[row, 6].Text?.Trim();
                    var paText = worksheet.Cells[row, 5].Text?.Trim();

                    if (string.IsNullOrEmpty(marcaNome) || marcaNome == "Marca") continue;
                    if (string.IsNullOrEmpty(descricaoRaw) || descricaoRaw == "Descrição") continue;

                    var descricao = NormalizeString(descricaoRaw);
                    var larg = UniversalParseDecimal(worksheet.Cells[row, 3].Value);
                    var prof = UniversalParseDecimal(worksheet.Cells[row, 4].Value);
                    var alt = UniversalParseDecimal(worksheet.Cells[row, 6].Value);
                    var pa = UniversalParseDecimal(worksheet.Cells[row, 5].Value);

                    // Get/Create Marca
                    var marcaToUse = string.IsNullOrEmpty(marcaNome) ? "GERAL" : marcaNome;
                    if (!marcasMap.TryGetValue(marcaToUse, out var marca))
                    {
                        marca = new Marca { Nome = marcaToUse };
                        _context.Marcas.Add(marca);
                        marcasMap[marcaToUse] = marca;
                    }

                    // Get/Create Modulo
                    Modulo? modulo = null;
                    if (marca.Id > 0)
                    {
                        modulo = await _context.Modulos
                             .Include(m => m.ModulosTecidos)
                             .FirstOrDefaultAsync(m => m.IdFornecedor == idFornecedor
                                                    && m.IdMarca == marca.Id
                                                    && m.Descricao.ToUpper() == descricao
                                                    && Math.Abs(m.Largura - larg) < 0.01m);
                    }

                    if (modulo == null)
                    {
                        modulo = _context.Modulos.Local
                            .FirstOrDefault(m => m.IdFornecedor == idFornecedor
                                              && (m.Marca == marca || (m.IdMarca > 0 && m.IdMarca == marca.Id))
                                              && m.Descricao.ToUpper() == descricao
                                              && Math.Abs(m.Largura - larg) < 0.01m);
                    }

                    if (modulo == null)
                    {
                        modulo = new Modulo
                        {
                            IdFornecedor = idFornecedor,
                            Marca = marca,
                            Categoria = categoria,
                            IdMarca = marca.Id,
                            IdCategoria = categoria.Id,
                            Descricao = descricao,
                            Largura = larg,
                            Profundidade = prof,
                            Altura = alt,
                            Pa = pa,
                            M3 = (larg * prof * alt) / 1000000m,
                            ModulosTecidos = new List<ModuloTecido>()
                        };
                        _context.Modulos.Add(modulo);
                    }
                    else
                    {
                        if (modulo.ModulosTecidos == null) modulo.ModulosTecidos = new List<ModuloTecido>();
                        modulo.Categoria = categoria;
                        modulo.Marca = marca;
                        modulo.Largura = larg;
                        modulo.Profundidade = prof;
                        modulo.Altura = alt;
                        modulo.Pa = pa;
                        modulo.M3 = (larg * prof * alt) / 1000000m;
                    }

                    // Process Tecidos (G0-G8)
                    foreach (var kvp in tecidoMappings)
                    {
                        var tecName = kvp.Key;
                        var colIndex = kvp.Value;
                        var tecido = tecidosMap[tecName];

                        var cellVal = worksheet.Cells[row, colIndex].Value;
                        if (cellVal == null || cellVal.ToString()!.Trim() == tecName || cellVal.ToString()!.Trim() == "Tecido")
                            continue;

                        var price = UniversalParseDecimal(cellVal);
                        if (price > 0)
                        {
                            var mt = new ModuloTecido
                            {
                                Modulo = modulo,
                                Tecido = tecido,
                                IdTecido = tecido.Id,
                                ValorTecido = price,
                                DtUltimaRevisao = dtRevisao,
                                FlAtivo = true
                            };
                            modulo.ModulosTecidos.Add(mt);
                            if (modulo.Id > 0) _context.ModulosTecidos.Add(mt);
                        }
                    }
                }
            }

            // ONE SAVE TO RULE THEM ALL
            await _context.SaveChangesAsync();
        }
        finally
        {
            CultureInfo.CurrentCulture = originalCulture;
        }
    }

    public async Task ImportarFerguileAsync(Stream fileStream, long idFornecedor, DateTime? dtRevisao)
    {
        if (dtRevisao.HasValue)
            dtRevisao = DateTime.SpecifyKind(dtRevisao.Value, DateTimeKind.Utc);

        await ResetSequencesAsync();

        var originalCulture = CultureInfo.CurrentCulture;
        try
        {
            CultureInfo.CurrentCulture = new CultureInfo("pt-BR");

            using var sanitizedStream = SanitizeExcelFile(fileStream);
            using var package = new ExcelPackage(sanitizedStream);

            // Validate Fornecedor
            var fornecedor = await _context.Fornecedores.FindAsync(idFornecedor);
            if (fornecedor == null)
                throw new Exception($"Fornecedor com ID {idFornecedor} não encontrado.");

            var deactivateSql = @"
                UPDATE modulo_tecido 
                SET fl_ativo = false 
                WHERE id_modulo IN (SELECT id FROM modulo WHERE id_fornecedor = {0})";
            await _context.Database.ExecuteSqlRawAsync(deactivateSql, idFornecedor);

            // === CACHES ===
            var categoriasCache = await _context.Categorias.ToListAsync();
            var marcasCache = await _context.Marcas.ToListAsync();
            var tecidosCache = await _context.Tecidos.ToListAsync();

            var categoriasMap = new Dictionary<string, Categoria>(StringComparer.OrdinalIgnoreCase);
            foreach (var c in categoriasCache) categoriasMap[c.Nome] = c;

            var marcasMap = new Dictionary<string, Marca>(StringComparer.OrdinalIgnoreCase);
            foreach (var m in marcasCache) marcasMap[m.Nome] = m;

            var tecidosMap = new Dictionary<string, Tecido>(StringComparer.OrdinalIgnoreCase);
            foreach (var t in tecidosCache) tecidosMap[t.Nome] = t;

            // Load all current modules and their fabrics for this supplier
            var modulosDb = await _context.Modulos
                .Where(m => m.IdFornecedor == idFornecedor)
                .Include(m => m.ModulosTecidos)
                .ToListAsync();

            var modulosCache = modulosDb.ToList();

            // Fixed category: "Ferguile"
            const string categoriaNome = "Ferguile";
            if (!categoriasMap.TryGetValue(categoriaNome, out var categoria))
            {
                categoria = new Categoria { Nome = categoriaNome };
                _context.Categorias.Add(categoria);
                categoriasMap[categoriaNome] = categoria;
            }

            foreach (var worksheet in package.Workbook.Worksheets)
            {
                if (worksheet.Dimension == null) continue;
                var rowCount = worksheet.Dimension.Rows;

                Modulo? lastModulo = null;

                for (int row = 2; row <= rowCount; row++)
                {
                    // === Col B (2): Marca ===
                    var marcaNome = worksheet.Cells[row, 2].Text?.Trim();
                    
                    // === Col L (12): Descrição do Módulo ===
                    var descricaoRaw = worksheet.Cells[row, 12].Text?.Trim();
                    
                    // === Col C (3): Largura ===
                    var largText = worksheet.Cells[row, 3].Text?.Trim();

                    // === Col M (13): Linha/Tecido, Col N (14): Valor
                    var tecidoNome = worksheet.Cells[row, 13].Text?.Trim();
                    var cellValor = worksheet.Cells[row, 14].Value;
                    var valorTecido = UniversalParseDecimal(cellValor);

                    // A row defines a NEW module spec if Marca is present and not a header
                    bool isNewSpec = !string.IsNullOrEmpty(marcaNome) && !marcaNome.Equals("MODELO", StringComparison.OrdinalIgnoreCase);
                    
                    // Specific case: if we have description/dimensions but no brand, it might still be a new spec in some formats,
                    // but for Ferguile, the brand is usually the anchor.
                    // However, TESTE1.xlsx seems to repeat brand on every row.

                    if (isNewSpec && marcaNome != null && descricaoRaw != null)
                    {
                        var descricaoNormalized = NormalizeString(descricaoRaw);
                        if (string.IsNullOrEmpty(descricaoNormalized) || 
                            descricaoNormalized == "-" ||
                            descricaoNormalized.Equals("COMPOSICAO", StringComparison.OrdinalIgnoreCase) ||
                            descricaoNormalized.Equals("COMPOSIÇÃO", StringComparison.OrdinalIgnoreCase))
                        {
                            // Skip header-like or empty description rows but don't reset lastModulo until we find a valid one
                            continue;
                        }

                        if (marcaNome == "-") continue;

                        var larg = UniversalParseDecimal(worksheet.Cells[row, 3].Value);

                        // === Col D (4): Profundidade ===
                        var profCellVal = worksheet.Cells[row, 4].Value;
                        string profTextRaw = profCellVal?.ToString()?.Trim() ?? "";
                        decimal prof = 0;
                        if (!string.IsNullOrEmpty(profTextRaw))
                        {
                            // Optimized depth parsing to handle multi-line "F:1,20\nA:1,80"
                            var fMatch = Regex.Match(profTextRaw, @"F:\s*([0-9,.]+)");
                            if (fMatch.Success)
                            {
                                prof = UniversalParseDecimal(fMatch.Groups[1].Value);
                            }
                            else if (!profTextRaw.Contains("A:", StringComparison.OrdinalIgnoreCase))
                            {
                                prof = UniversalParseDecimal(profCellVal);
                            }
                        }

                        // === Col E (5): Altura ===
                        var alt = UniversalParseDecimal(worksheet.Cells[row, 5].Value);

                        // === Col H (8): PA ===
                        var pa = UniversalParseDecimal(worksheet.Cells[row, 8].Value);

                        // Get/Create Marca
                        if (!marcasMap.TryGetValue(marcaNome, out var marca))
                        {
                            marca = new Marca { Nome = marcaNome };
                            _context.Marcas.Add(marca);
                            _context.SaveChanges(); // Need ID for newly created marca
                            marcasMap[marcaNome] = marca;
                        }

                        // Find Modulo (Smart Matching)
                        // Note: Removed modulosAtualizadosNestaSessao check to allow associating multiple fabrics/prices 
                        // from different rows to the same module spec.
                        Modulo? modulo = modulosCache
                            .Where(m => m.IdMarca == marca.Id 
                                     && NormalizeString(m.Descricao) == descricaoNormalized
                                     && Math.Abs(m.Largura - larg) < 0.01m)
                            .FirstOrDefault();

                        if (modulo == null)
                        {
                            // Check local cache for newly created modules
                            modulo = _context.Modulos.Local
                                .Where(m => m.IdFornecedor == idFornecedor 
                                         && (m.Marca == marca || m.IdMarca == marca.Id)
                                         && NormalizeString(m.Descricao) == descricaoNormalized
                                         && Math.Abs(m.Largura - larg) < 0.01m)
                                .Where(m => m.Id == 0)
                                .FirstOrDefault();
                        }

                        if (modulo == null)
                        {
                            modulo = new Modulo
                            {
                                IdFornecedor = idFornecedor,
                                Marca = marca,
                                Categoria = categoria,
                                Descricao = descricaoNormalized,
                                Largura = larg,
                                Profundidade = prof,
                                Altura = alt,
                                Pa = pa,
                                ModulosTecidos = new List<ModuloTecido>()
                            };
                            _context.Modulos.Add(modulo);
                        }
                        else
                        {
                            // Update existing module metadata
                            modulo.Categoria = categoria;
                            modulo.Marca = marca;
                            modulo.Largura = larg;
                            modulo.Profundidade = prof;
                            modulo.Altura = alt;
                            modulo.Pa = pa;
                        }
                        
                        lastModulo = modulo;
                    }

                    // Process price for the current active modulo
                    if (lastModulo != null && !string.IsNullOrEmpty(tecidoNome) && 
                        !tecidoNome.Equals("LINHA", StringComparison.OrdinalIgnoreCase) && 
                        valorTecido > 0)
                    {
                        if (!tecidosMap.TryGetValue(tecidoNome, out var tecido))
                        {
                            tecido = new Tecido { Nome = tecidoNome };
                            _context.Tecidos.Add(tecido);
                            tecidosMap[tecidoNome] = tecido;
                        }

                        if (lastModulo.ModulosTecidos == null) lastModulo.ModulosTecidos = new List<ModuloTecido>();

                        var mt = new ModuloTecido
                        {
                            Modulo = lastModulo,
                            Tecido = tecido,
                            IdTecido = tecido.Id,
                            ValorTecido = valorTecido,
                            DtUltimaRevisao = dtRevisao,
                            FlAtivo = true
                        };
                        lastModulo.ModulosTecidos.Add(mt);
                        if (lastModulo.Id > 0) _context.ModulosTecidos.Add(mt);
                    }
                }
            }

            await _context.SaveChangesAsync();
        }
        finally
        {
            CultureInfo.CurrentCulture = originalCulture;
        }
    }

    public async Task<ImportResult> ImportarLivintusAsync(Stream fileStream, long idFornecedor, DateTime? dtRevisao, bool dryRun = false)
    {
        if (dtRevisao.HasValue)
            dtRevisao = DateTime.SpecifyKind(dtRevisao.Value, DateTimeKind.Utc);

        var originalCulture = CultureInfo.CurrentCulture;
        try
        {
            CultureInfo.CurrentCulture = new CultureInfo("pt-BR");

            // Reset sequences inside try
            await ResetSequencesAsync();

            using var sanitizedStream = SanitizeExcelFile(fileStream);
            using var package = new ExcelPackage(sanitizedStream);

            // Validate Fornecedor
            var fornecedor = await _context.Fornecedores.FindAsync(idFornecedor);
            if (fornecedor == null)
                throw new Exception($"Fornecedor com ID {idFornecedor} não encontrado.");

            // --- DEACTIVATE ALL EXISTING FABRICS FOR THIS SUPPLIER ---
            // This ensures that only fabrics currently in the excel will remain active.
            // MUST be done before loading entities into context to ensure change tracker works.
            if (!dryRun)
            {
                var deactivateSql = @"
                    UPDATE modulo_tecido 
                    SET fl_ativo = false 
                    WHERE id_modulo IN (SELECT id FROM modulo WHERE id_fornecedor = {0})";
                await _context.Database.ExecuteSqlRawAsync(deactivateSql, idFornecedor);
            }

            // === CACHES ===
            var categoriasCache = await _context.Categorias.ToListAsync();
            var marcasCache = await _context.Marcas.ToListAsync();
            var tecidosCache = await _context.Tecidos.ToListAsync();

            var categoriasMap = new Dictionary<string, Categoria>(StringComparer.OrdinalIgnoreCase);
            foreach (var c in categoriasCache) categoriasMap[c.Nome] = c;

            var marcasMap = new Dictionary<string, Marca>(StringComparer.OrdinalIgnoreCase);
            foreach (var m in marcasCache) marcasMap[m.Nome] = m;

            var tecidosMap = new Dictionary<string, Tecido>(StringComparer.OrdinalIgnoreCase);
            foreach (var t in tecidosCache) tecidosMap[t.Nome] = t;

            // Load all current modules and their fabrics for this supplier to avoid N+1 queries
            var modulosDb = await _context.Modulos
                .Where(m => m.IdFornecedor == idFornecedor)
                .Include(m => m.ModulosTecidos)
                .ToListAsync();

            // Dictionary for fast lookup: "marcaId|descricao|largura" (normalized)
            var modulosDict = new Dictionary<string, Modulo>();
            foreach (var m in modulosDb)
            {
                string key = $"{m.IdMarca}|{NormalizeString(m.Descricao)}|{m.Largura.ToString("F2", CultureInfo.InvariantCulture)}";
                if (!modulosDict.ContainsKey(key))
                    modulosDict[key] = m;
            }

            // Fixed category: "Livintus"
            const string categoriaNome = "Livintus";
            if (!categoriasMap.TryGetValue(categoriaNome, out var categoria))
            {
                categoria = new Categoria { Nome = categoriaNome };
                _context.Categorias.Add(categoria);
                categoriasMap[categoriaNome] = categoria;
            }


            foreach (var worksheet in package.Workbook.Worksheets)
            {
                if (worksheet.Dimension == null) continue;
                var rowCount = worksheet.Dimension.Rows;

                string currentMarca = "";
                string currentBrandFromB = "";
                string currentComposition = "";
                decimal currentLarg = 0;
                decimal currentProf = 0;
                decimal currentAlt = 0;

                for (int row = 2; row <= rowCount; row++) // Skip header row
                {
                    var brandFromA = worksheet.Cells[row, 1].Text?.Trim();
                    var brandFromB = worksheet.Cells[row, 2].Text?.Trim();
                    
                    if (!string.IsNullOrEmpty(brandFromB)) currentBrandFromB = brandFromB;

                    var tempMarca = !string.IsNullOrEmpty(brandFromA) && !brandFromA.Equals("LINHA", StringComparison.OrdinalIgnoreCase) 
                                    ? brandFromA : currentBrandFromB;
                    if (!string.IsNullOrEmpty(tempMarca)) currentMarca = tempMarca;

                    var largRaw = worksheet.Cells[row, 3].Text?.Trim();
                    var profRaw = worksheet.Cells[row, 4].Text?.Trim();
                    var altRaw = worksheet.Cells[row, 5].Text?.Trim();
                    var compositionRaw = worksheet.Cells[row, 6].Text?.Trim();

                    if (!string.IsNullOrEmpty(compositionRaw)) currentComposition = compositionRaw;
                    if (!string.IsNullOrEmpty(largRaw)) currentLarg = UniversalParseDecimal(largRaw);
                    if (!string.IsNullOrEmpty(profRaw)) currentProf = UniversalParseDecimal(profRaw);
                    if (!string.IsNullOrEmpty(altRaw)) currentAlt = UniversalParseDecimal(altRaw);

                    var tecidoNome = worksheet.Cells[row, 7].Text?.Trim();
                    var cellValor = worksheet.Cells[row, 8].Value;
                    var valorTecido = UniversalParseDecimal(cellValor);

                    if (string.IsNullOrEmpty(currentBrandFromB) || currentBrandFromB == "-" || 
                        string.IsNullOrEmpty(currentComposition) || currentComposition == "-" ||
                        string.IsNullOrEmpty(tecidoNome) || valorTecido <= 0)
                        continue;

                    var modelName = currentBrandFromB;
                    var descricaoNormalized = NormalizeString($"{modelName} - {currentComposition}");

                    // Get/Create Marca
                    if (!marcasMap.TryGetValue(currentMarca, out var marca))
                    {
                        marca = new Marca { Nome = currentMarca };
                        _context.Marcas.Add(marca);
                        if (!dryRun) _context.SaveChanges();
                        marcasMap[currentMarca] = marca;
                    }

                    Modulo? modulo = null;
                    string largKey = currentLarg.ToString("F2", CultureInfo.InvariantCulture);
                    if (marca.Id > 0)
                    {
                        string modKey = $"{marca.Id}|{descricaoNormalized}|{largKey}";
                        modulosDict.TryGetValue(modKey, out modulo);
                    }

                    if (modulo == null)
                    {
                        modulo = _context.Modulos.Local
                            .FirstOrDefault(m => m.IdFornecedor == idFornecedor 
                                           && (m.Marca == marca || m.IdMarca == marca.Id)
                                           && NormalizeString(m.Descricao) == descricaoNormalized
                                           && Math.Abs(m.Largura - currentLarg) < 0.01m);
                    }

                    if (modulo == null)
                    {
                        modulo = new Modulo
                        {
                            IdFornecedor = idFornecedor,
                            Marca = marca,
                            Categoria = categoria,
                            IdMarca = marca.Id,
                            IdCategoria = categoria.Id,
                            Descricao = descricaoNormalized,
                            Largura = currentLarg,
                            Profundidade = currentProf,
                            Altura = currentAlt,
                            Pa = 0,
                            M3 = (currentLarg * currentProf * currentAlt),
                            ModulosTecidos = new List<ModuloTecido>()
                        };
                        _context.Modulos.Add(modulo);
                        
                        if (marca.Id > 0)
                        {
                            string modKey = $"{marca.Id}|{descricaoNormalized}|{largKey}";
                            modulosDict[modKey] = modulo;
                        }
                    }
                    else
                    {
                        if (modulo.ModulosTecidos == null) modulo.ModulosTecidos = new List<ModuloTecido>();
                        modulo.Categoria = categoria;
                        modulo.Marca = marca;
                        modulo.Largura = currentLarg;
                        modulo.Profundidade = currentProf;
                        modulo.Altura = currentAlt;
                        modulo.M3 = (currentLarg * currentProf * currentAlt);
                    }

                    if (!tecidoNome.Equals("LINHA", StringComparison.OrdinalIgnoreCase))
                    {
                        if (!tecidosMap.TryGetValue(tecidoNome, out var tecido))
                        {
                            tecido = new Tecido { Nome = tecidoNome };
                            _context.Tecidos.Add(tecido);
                            tecidosMap[tecidoNome] = tecido;
                        }

                        var mt = new ModuloTecido
                        {
                            Modulo = modulo,
                            Tecido = tecido,
                            IdTecido = tecido.Id,
                            ValorTecido = valorTecido,
                            DtUltimaRevisao = dtRevisao,
                            FlAtivo = true
                        };
                        modulo.ModulosTecidos.Add(mt);
                        if (modulo.Id > 0) _context.ModulosTecidos.Add(mt);
                    }
                }
            }

            if (!dryRun) await _context.SaveChangesAsync();

            // === VERIFICATION ===
            var result = new ImportResult();
            fileStream.Position = 0; // Reset stream for re-reading
            using var packageVerify = new ExcelPackage(fileStream);
            
            // Reload modules from DB for comparison
            var modulosFinal = await _context.Modulos
                .Where(m => m.IdFornecedor == idFornecedor)
                .Include(m => m.ModulosTecidos)
                .ThenInclude(mt => mt.Tecido)
                .ToListAsync();

            foreach (var worksheet in packageVerify.Workbook.Worksheets)
            {
                if (worksheet.Dimension == null) continue;
                var rowCount = worksheet.Dimension.Rows;

                for (int row = 2; row <= rowCount; row++)
                {
                    result.TotalFilasProcessadas++;

                    var brandFromA = worksheet.Cells[row, 1].Text?.Trim();
                    var brandFromB = worksheet.Cells[row, 2].Text?.Trim();
                    var marcaNome = !string.IsNullOrEmpty(brandFromA) && !brandFromA.Equals("LINHA", StringComparison.OrdinalIgnoreCase) 
                                    ? brandFromA : brandFromB;
                    
                    var largVal = UniversalParseDecimal(worksheet.Cells[row, 3].Value);
                    var profVal = UniversalParseDecimal(worksheet.Cells[row, 4].Value);
                    var altVal = UniversalParseDecimal(worksheet.Cells[row, 5].Value);
                    var compositionRaw = worksheet.Cells[row, 6].Text?.Trim();
                    var tecidoNome = worksheet.Cells[row, 7].Text?.Trim();
                    var valorTecidoExcel = UniversalParseDecimal(worksheet.Cells[row, 8].Value);

                    if (string.IsNullOrEmpty(brandFromB) || string.IsNullOrEmpty(compositionRaw)) continue;

                    var descricaoExpected = NormalizeString($"{brandFromB} - {compositionRaw}");

                    // Find modulo in DB
                    var dbModulo = modulosFinal.FirstOrDefault(m => 
                        NormalizeString(m.Descricao) == descricaoExpected && 
                        Math.Abs(m.Largura - largVal) < 0.001m);

                    if (dbModulo == null)
                    {
                        result.Discrepancias.Add($"Linha {row}: Módulo '{descricaoExpected}' (L:{largVal}) não encontrado no banco.");
                        continue;
                    }

                    var detail = new ImportedItemDetail
                    {
                        Linha = row,
                        IdModulo = dbModulo.Id,
                        Descricao = dbModulo.Descricao ?? string.Empty,
                        
                        // System values
                        Largura = dbModulo.Largura,
                        Altura = dbModulo.Altura,
                        Profundidade = dbModulo.Profundidade,
                        M3 = dbModulo.M3,
                        
                        // Excel values
                        LarguraExcel = largVal,
                        AlturaExcel = altVal,
                        ProfundidadeExcel = profVal,
                        ValorExcel = valorTecidoExcel,

                        Tecido = tecidoNome ?? string.Empty,
                        Status = (dryRun && (dbModulo.Id == 0)) ? "Novo" : "OK"
                    };

                    // Verify Dimensions
                    if (Math.Abs(dbModulo.Largura - largVal) > 0.001m || 
                        Math.Abs(dbModulo.Profundidade - profVal) > 0.001m || 
                        Math.Abs(dbModulo.Altura - altVal) > 0.001m)
                    {
                        detail.Status = "Divergente";
                        result.Discrepancias.Add($"Linha {row}: Dimensões divergentes.");
                    }

                    // Verify Price
                    if (!string.IsNullOrEmpty(tecidoNome) && !tecidoNome.Equals("LINHA", StringComparison.OrdinalIgnoreCase) && valorTecidoExcel > 0)
                    {
                        var dbTecido = dbModulo.ModulosTecidos?.FirstOrDefault(mt => 
                            mt.Tecido?.Nome?.Trim().Equals(tecidoNome, StringComparison.OrdinalIgnoreCase) == true);

                        if (dbTecido == null)
                        {
                            result.Discrepancias.Add($"Linha {row}: Tecido '{tecidoNome}' não vinculado ao módulo no banco.");
                        }
                        else 
                        {
                            detail.IdModuloTecido = dbTecido.Id;
                            detail.ValorTecido = dbTecido.ValorTecido;
                            if (Math.Abs(dbTecido.ValorTecido - valorTecidoExcel) > 0.001m)
                            {
                                detail.Status = "Divergente";
                                result.Discrepancias.Add($"Linha {row}: Valor do tecido '{tecidoNome}' divergente. Excel: {valorTecidoExcel}, Banco: {dbTecido.ValorTecido}");
                            }
                        }
                    }

                    result.ItensImportados.Add(detail);
                }
            }

            result.TotalModulosImportados = modulosFinal.Count;
            return result;
        }
        finally
        {
            CultureInfo.CurrentCulture = originalCulture;
        }
    }

    private string NormalizeString(string input)
    {
        if (string.IsNullOrEmpty(input)) return string.Empty;
        // Strip everything except letters and numbers, and single space. 
        // Then ToUpper.
        var temp = Regex.Replace(input, @"\s+", " ").Trim();
        return temp.ToUpper();
    }

    private decimal UniversalParseDecimal(object? value)
    {
        if (value == null) return 0;
        if (value is double d) return (decimal)d;
        if (value is decimal dec) return dec;
        if (value is int i) return (decimal)i;
        if (value is long l) return (decimal)l;

        string text = value.ToString()?.Trim() ?? "";
        if (string.IsNullOrEmpty(text)) return 0;

        if (text.Equals("#REF!", StringComparison.OrdinalIgnoreCase)) return 0;

        // Clean up common prefixes and units BEFORE stripping non-numeric
        text = Regex.Replace(text, @"^[A-Z]:\s*", "", RegexOptions.IgnoreCase); // F:, A:, P:
        text = text.Replace("m", "").Trim();

        // Handle multi-value strings like "2.58mx2,15m" or "2.58x2.15"
        if (text.Contains("x", StringComparison.OrdinalIgnoreCase))
        {
            text = text.Split(new[] { 'x', 'X' })[0].Trim();
        }

        // Now strip currency symbols, letters, etc., keeping only digits, dot, and comma
        // BUT we need to be careful with the dot/comma hierarchy
        text = Regex.Replace(text, @"[^\d,.-]", "");

        if (string.IsNullOrEmpty(text)) return 0;

        if (text.Contains(",") && text.Contains("."))
        {
            if (text.LastIndexOf(',') > text.LastIndexOf('.'))
            {
                // Comma is last, so it's the decimal separator (e.g., 1.234,56)
                text = text.Replace(".", "").Replace(",", ".");
            }
            else
            {
                // Dot is last, so it's the decimal separator (e.g., 1,234.56)
                text = text.Replace(",", "");
            }
        }
        else if (text.Contains(","))
        {
            // Only comma exists (e.g., 2,90 or 2,900). 
            // In financial context with multiple digits after comma, it's still likely a decimal separator
            // unless it's clearly a thousand separator (e.g. 1,000). 
            // But usually 2,90 -> 2.90
            text = text.Replace(",", ".");
        }
        else if (text.Contains("."))
        {
            // ONLY DOT exists (e.g. 4.461). 
            // This is the danger zone. In pt-BR Excel, if a cell has "4461" and is formatted with dot,
            // .Text returns "4.461". If we treat dot as decimal, it becomes 4.461.
            
            // Heuristic: If there are exactly 3 digits after the dot AND no other punctuation, 
            // it's highly likely to be a thousand separator in our context (prices > 1000).
            var parts = text.Split('.');
            if (parts.Length == 2 && parts[1].Length == 3)
            {
                // Treat as thousands
                text = text.Replace(".", "");
            }
            else
            {
                // Treat as decimal
                // (No change needed, decimal.TryParse handles single dot with InvariantCulture)
            }
        }

        if (decimal.TryParse(text, NumberStyles.Any, CultureInfo.InvariantCulture, out var result))
        {
            return result;
        }

        return 0;
    }

    public async Task SincronizarItensAsync(SyncRequest request)
    {
        if (request?.Itens == null || request.Itens.Count == 0) return;

        foreach (var item in request.Itens)
        {
            if (item.IdModulo <= 0) continue;

            var dbModulo = await _context.Modulos.FindAsync(item.IdModulo);
            if (dbModulo != null)
            {
                dbModulo.Largura = item.Largura;
                dbModulo.Profundidade = item.Profundidade;
                dbModulo.Altura = item.Altura;
                dbModulo.M3 = (item.Largura * item.Profundidade * item.Altura);
            }

            if (item.IdModuloTecido.HasValue && item.IdModuloTecido.Value > 0)
            {
                var mt = await _context.ModulosTecidos.FindAsync(item.IdModuloTecido.Value);
                if (mt != null)
                {
                    mt.ValorTecido = item.Valor;
                }
            }
        }

        await _context.SaveChangesAsync();
    }
}
