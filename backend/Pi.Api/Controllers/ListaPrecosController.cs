// Pi.Api/Controllers/ListaPrecosController.cs
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/listas-preco")]
public class ListaPrecosController : ControllerBase
{
    private readonly AppDbContext _db;

    public ListaPrecosController(AppDbContext db)
    {
        _db = db;
    }

    // GET: /api/listas-preco
    // Filtros: ?search=...&marca=...&fornecedor=...&tipoPreco=...&ativo=true/false
    // Paginação: ?page=1&pageSize=50 (se pageSize > 0, retorna { items, total, page, pageSize })
    [HttpGet]
    public async Task<IActionResult> GetAll(
        [FromQuery] string? search,
        [FromQuery] string? marca,
        [FromQuery] string? fornecedor,
        [FromQuery] string? tipoPreco,
        [FromQuery] bool? ativo,
        [FromQuery] int page = 0,
        [FromQuery] int pageSize = 0,
        CancellationToken ct = default)
    {
        IQueryable<ListaPreco> q = _db.ListasPreco.AsNoTracking();

        if (!string.IsNullOrWhiteSpace(search))
        {
            var s = search.Trim();
            q = q.Where(x =>
                (x.Descricao != null && EF.Functions.ILike(x.Descricao, $"%{s}%")) ||
                EF.Functions.ILike(x.Marca, $"%{s}%") ||
                EF.Functions.ILike(x.FornecedorLista, $"%{s}%") ||
                EF.Functions.ILike(x.TipoPreco, $"%{s}%"));
        }

        if (!string.IsNullOrWhiteSpace(marca))
            q = q.Where(x => x.Marca == marca);

        if (!string.IsNullOrWhiteSpace(fornecedor))
            q = q.Where(x => x.FornecedorLista == fornecedor);

        if (!string.IsNullOrWhiteSpace(tipoPreco))
            q = q.Where(x => x.TipoPreco == tipoPreco);

        if (ativo.HasValue)
            q = q.Where(x => x.FlAtivo == ativo.Value);

        q = q.OrderBy(x => x.Marca).ThenBy(x => x.Descricao);

        if (pageSize > 0)
        {
            var total = await q.CountAsync(ct);
            var pg = Math.Max(1, page);
            var skip = (pg - 1) * pageSize;

            var items = await q.Skip(skip).Take(pageSize).ToListAsync(ct);

            return Ok(new PagedResult<ListaPreco>(items, total, pg, pageSize));
        }
        else
        {
            var items = await q.ToListAsync(ct);
            return Ok(items);
        }
    }

    // GET: /api/listas-preco/{id}
    [HttpGet("{id:long}")]
    public async Task<ActionResult<ListaPreco>> GetById(long id, CancellationToken ct)
    {
        var entity = await _db.ListasPreco.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id, ct);
        if (entity == null) return NotFound();
        return entity;
    }

    // POST: /api/listas-preco
    [HttpPost]
    public async Task<ActionResult<ListaPreco>> Create([FromBody] ListaPreco input, CancellationToken ct)
    {
        if (!ModelState.IsValid) return ValidationProblem(ModelState);

        // Id é identity; se vier preenchido, zera para evitar conflito
        input.Id = 0;

        _db.ListasPreco.Add(input);
        await _db.SaveChangesAsync(ct);

        return CreatedAtAction(nameof(GetById), new { id = input.Id }, input);
    }

    // PUT: /api/listas-preco/{id}
    [HttpPut("{id:long}")]
    public async Task<IActionResult> Update(long id, [FromBody] ListaPreco input, CancellationToken ct)
    {
        if (id != input.Id)
            return BadRequest("Id do path difere do body.");

        // Anexa e marca como modificado (atualiza todas as propriedades)
        _db.Entry(input).State = EntityState.Modified;

        try
        {
            await _db.SaveChangesAsync(ct);
        }
        catch (DbUpdateConcurrencyException)
        {
            var exists = await _db.ListasPreco.AnyAsync(x => x.Id == id, ct);
            if (!exists) return NotFound();
            throw;
        }

        return NoContent();
    }

    // DELETE: /api/listas-preco/{id}
    [HttpDelete("{id:long}")]
    public async Task<IActionResult> Delete(long id, CancellationToken ct)
    {
        var entity = await _db.ListasPreco.FirstOrDefaultAsync(x => x.Id == id, ct);
        if (entity == null) return NotFound();

        _db.ListasPreco.Remove(entity);
        await _db.SaveChangesAsync(ct);

        return NoContent();
    }

    public record PagedResult<T>(IReadOnlyList<T> Items, int Total, int Page, int PageSize);
}
