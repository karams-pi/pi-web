using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ModulosController : ControllerBase
{
    private readonly AppDbContext _db;
    public ModulosController(AppDbContext db) => _db = db;

    private static decimal CalcM3(Modulo m)
        => Math.Round(m.Largura * m.Profundidade * m.Altura, 2);

    [HttpGet]
    public async Task<ActionResult<object>> GetAll(
        [FromQuery] string? search,
        [FromQuery] long? idFornecedor,
        [FromQuery] long? idCategoria,
        [FromQuery] long? idMarca,
        [FromQuery] long? idTecido,
        [FromQuery] string status = "ativos", // ativos, inativos, todos
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 10)
    {
        var query = _db.Modulos
            .AsNoTracking()
            .Include(m => m.ModulosTecidos)
            .ThenInclude(mt => mt.Tecido)
            .Include(m => m.Marca)
            .AsQueryable();

        // 1. Filter Brands (always active)
        query = query.Where(x => x.Marca != null && x.Marca.FlAtivo);

        // 2. Apply Filters
        if (!string.IsNullOrEmpty(search))
        {
            var lower = search.ToLower();
            query = query.Where(x => x.Descricao.ToLower().Contains(lower) || x.Id.ToString().Contains(lower));
        }

        if (idFornecedor.HasValue)
            query = query.Where(x => x.IdFornecedor == idFornecedor.Value);

        if (idCategoria.HasValue)
            query = query.Where(x => x.IdCategoria == idCategoria.Value);

        if (idMarca.HasValue)
            query = query.Where(x => x.IdMarca == idMarca.Value);

        if (idTecido.HasValue)
            query = query.Where(x => x.ModulosTecidos.Any(mt => mt.IdTecido == idTecido.Value));

        // 3. Status Filter (Active/Inactive Fabrics)
        // Logic: 
        // - "ativos": Show modules that have AT LEAST ONE active fabric (or no fabrics? usually no).
        //             AND filter the included collection to show ONLY active fabrics.
        // - "inativos": Show modules that have AT LEAST ONE inactive fabric.
        // - "todos": Show everything.
        
        // IMPORTANT: EF Core Include filtering.
        // We need to filter the PARENT query to only return relevant modules, 
        // AND we need to filter the CHILD collection. 
        // Filtered Include is supported in simpler queries, but combining with parent Where needs care.
        
        if (status == "ativos")
        {
             // Only modules that have at least one active fabric OR have no fabrics at all (maybe? usually user wants to see what is sellable)
             // Let's assume user wants to see modules that are "Active". Since Modulo doesn't have flag, 
             // "Active Module" = "Has Active Fabrics".
             // However, if a module has NO fabrics, should it appear? Yes, probably, to add fabrics.
             // But if I filter "Ativos", I expect to see active stuff.
             // Let's stick to: "Show me modules, and only their active fabrics".
             // Parent filter: Don't restrict parent based on fabric status unless explicitly requested.
             // But if I hide all users fabrics, the row might look empty.
             // Let's just filter the INCLUDE.
             query = query.Include(m => m.ModulosTecidos.Where(mt => mt.FlAtivo));
             // Note: Re-declaring Include overwrites previous Include.
        }
        else if (status == "inativos")
        {
             query = query.Include(m => m.ModulosTecidos.Where(mt => !mt.FlAtivo));
             // Also filter parent to only show modules that HAVE inactive fabrics?
             query = query.Where(m => m.ModulosTecidos.Any(mt => !mt.FlAtivo));
        }
        else // todos
        {
            // Keep original include (all fabrics)
            // But we already defined it above.
            // Be careful not to double include or lose the ThenInclude(Tecido).
            // Actually, the top-level Include at line 30 already includes ALL. 
            // We need to conditionally apply the Include with filter REPLACING the top one if strictly needed,
            // or just rely on the top one for "todos".
        }

        // Redoing Includes to be safe and clean:
        // We must build the query from scratch or reset it because we can't easily "remove" an include.
        // Let's restart the query definition to apply the specific Include strategy.
        
        query = _db.Modulos.AsNoTracking();

        if (status == "ativos")
        {
            query = query.Include(m => m.ModulosTecidos.Where(mt => mt.FlAtivo))
                         .ThenInclude(mt => mt.Tecido);
            query = query.Where(m => m.ModulosTecidos.Any(mt => mt.FlAtivo));
        }
        else if (status == "inativos")
        {
             query = query.Include(m => m.ModulosTecidos.Where(mt => !mt.FlAtivo))
                          .ThenInclude(mt => mt.Tecido);
             query = query.Where(m => m.ModulosTecidos.Any(mt => !mt.FlAtivo)); 
        }
        else 
        {
            query = query.Include(m => m.ModulosTecidos)
                         .ThenInclude(mt => mt.Tecido);
        }

        query = query.Include(m => m.Marca); 

        // Apply same filters as before
        query = query.Where(x => x.Marca != null && x.Marca.FlAtivo);
        
        if (!string.IsNullOrEmpty(search))
        {
            var lower = search.ToLower();
            query = query.Where(x => x.Descricao.ToLower().Contains(lower) || x.Id.ToString().Contains(lower));
        }
        if (idFornecedor.HasValue) query = query.Where(x => x.IdFornecedor == idFornecedor.Value);
        if (idCategoria.HasValue) query = query.Where(x => x.IdCategoria == idCategoria.Value);
        if (idMarca.HasValue) query = query.Where(x => x.IdMarca == idMarca.Value);
        if (idTecido.HasValue) query = query.Where(x => x.ModulosTecidos.Any(mt => mt.IdTecido == idTecido.Value));


        var total = await query.CountAsync();
        
        var items = await query
            .OrderByDescending(x => x.Id)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        return Ok(new 
        { 
            items, 
            total, 
            page, 
            pageSize, 
            totalPages = (int)Math.Ceiling(total / (double)pageSize) 
        });
    }

    [HttpGet("filters")]
    public async Task<ActionResult<object>> GetFilters(
        [FromQuery] long? idFornecedor,
        [FromQuery] long? idCategoria,
        [FromQuery] long? idMarca,
        [FromQuery] long? idTecido)
    {
        // Helper to apply filters EXCEPT the one being loaded (exclusion logic)
        IQueryable<Modulo> ApplyFilters(IQueryable<Modulo> q, string exclude)
        {
             if (exclude != "fornecedor" && idFornecedor.HasValue) q = q.Where(x => x.IdFornecedor == idFornecedor.Value);
             if (exclude != "categoria" && idCategoria.HasValue) q = q.Where(x => x.IdCategoria == idCategoria.Value);
             if (exclude != "marca" && idMarca.HasValue) q = q.Where(x => x.IdMarca == idMarca.Value);
             if (exclude != "tecido" && idTecido.HasValue) q = q.Where(x => x.ModulosTecidos.Any(mt => mt.IdTecido == idTecido.Value));
             return q;
        }

        // Available Fornecedores
        var qForn = _db.Modulos.AsNoTracking();
        qForn = ApplyFilters(qForn, "fornecedor");
        var fornecedores = await qForn
            .Select(x => x.Fornecedor)
            .Where(x => x != null)
            .Distinct()
            .OrderBy(x => x!.Nome)
            .ToListAsync();

        // Available Categorias
        var qCat = _db.Modulos.AsNoTracking();
        qCat = ApplyFilters(qCat, "categoria");
        var categorias = await qCat
            .Select(x => x.Categoria)
            .Where(x => x != null)
            .Distinct()
            .OrderBy(x => x!.Nome)
            .ToListAsync();

        // Available Marcas
        // Use explicitly typed variable to accept both IIncludableQueryable from Include and IQueryable from ApplyFilters
        IQueryable<Modulo> qMarca = _db.Modulos.AsNoTracking().Include(m => m.Marca); 
        qMarca = ApplyFilters(qMarca, "marca");
        var marcas = await qMarca
            .Where(x => x.Marca != null && x.Marca.FlAtivo) // Only Show active brands in filter
            .Select(x => x.Marca)
            .Where(x => x != null)
            .Distinct()
            .OrderBy(x => x!.Nome)
            .ToListAsync();

        // Available Tecidos (via ModuloTecido)
        var qTec = _db.ModulosTecidos.AsNoTracking().Include(mt => mt.Tecido).AsQueryable();
        // Manually apply parent filters to the junction query 
        if (idFornecedor.HasValue) qTec = qTec.Where(mt => mt.Modulo != null && mt.Modulo.IdFornecedor == idFornecedor.Value);
        if (idCategoria.HasValue) qTec = qTec.Where(mt => mt.Modulo != null && mt.Modulo.IdCategoria == idCategoria.Value);
        if (idMarca.HasValue) qTec = qTec.Where(mt => mt.Modulo != null && mt.Modulo.IdMarca == idMarca.Value);
        // exclude "tecido" -> we don't filter by idTecido here, naturally

        var tecidos = await qTec
            .Select(mt => mt.Tecido)
            .Where(x => x != null)
            .Distinct()
            .OrderBy(x => x!.Nome)
            .ToListAsync();

        return Ok(new { fornecedores, categorias, marcas, tecidos });
    }

    [HttpGet("{id:long}")]
    public async Task<ActionResult<Modulo>> GetById(long id)
    {
        var item = await _db.Modulos.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id);
        return item is null ? NotFound() : item;
    }

    [HttpPost]
    public async Task<ActionResult<Modulo>> Create([FromBody] Modulo input)
    {
        input.M3 = CalcM3(input);

        _db.Modulos.Add(input);
        await _db.SaveChangesAsync();

        return CreatedAtAction(nameof(GetById), new { id = input.Id }, input);
    }

    [HttpPut("{id:long}")]
    public async Task<IActionResult> Update(long id, [FromBody] Modulo input)
    {
        var item = await _db.Modulos.FirstOrDefaultAsync(x => x.Id == id);
        if (item is null) return NotFound();

        item.IdFornecedor = input.IdFornecedor;
        item.IdCategoria = input.IdCategoria;
        item.IdMarca = input.IdMarca;
        item.Descricao = input.Descricao;

        item.Largura = input.Largura;
        item.Profundidade = input.Profundidade;
        item.Altura = input.Altura;
        item.Pa = input.Pa;

        item.M3 = CalcM3(item);

        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:long}")]
    public async Task<IActionResult> Delete(long id)
    {
        var item = await _db.Modulos.FirstOrDefaultAsync(x => x.Id == id);
        if (item is null) return NotFound();

        _db.Modulos.Remove(item);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
