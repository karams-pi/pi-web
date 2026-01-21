// Pi.Api/Controllers/CategoriasController.cs
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/categorias")]
public class CategoriasController : ControllerBase
{
    private readonly AppDbContext _db;
    public CategoriasController(AppDbContext db) => _db = db;

    public record PagedResult<T>(IReadOnlyList<T> Items, int Total, int Page, int PageSize);

    [HttpGet]
    public async Task<ActionResult<PagedResult<Categoria>>> List(
        [FromQuery] string? search,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 50,
        CancellationToken ct = default)
    {
        page = Math.Max(1, page);
        pageSize = Math.Clamp(pageSize, 1, 200);

        var q = _db.Categorias.AsNoTracking().AsQueryable();

        if (!string.IsNullOrWhiteSpace(search))
        {
            var s = search.Trim().ToLower();
            q = q.Where(x => x.Nome.ToLower().Contains(s));
        }

        var total = await q.CountAsync(ct);
        var items = await q.OrderBy(x => x.Nome)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync(ct);

        return Ok(new PagedResult<Categoria>(items, total, page, pageSize));
    }

    [HttpGet("{id:guid}")]
    public async Task<ActionResult<Categoria>> Get(Guid id, CancellationToken ct)
    {
        var x = await _db.Categorias.AsNoTracking().FirstOrDefaultAsync(c => c.Id == id, ct);
        return x is null ? NotFound() : Ok(x);
    }

    [HttpPost]
    public async Task<ActionResult<Categoria>> Create([FromBody] Categoria input, CancellationToken ct)
    {
        if (string.IsNullOrWhiteSpace(input.Nome)) return BadRequest("Nome é obrigatório.");
        input.Id = Guid.NewGuid();
        _db.Categorias.Add(input);
        await _db.SaveChangesAsync(ct);
        return CreatedAtAction(nameof(Get), new { id = input.Id }, input);
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> Update(Guid id, [FromBody] Categoria input, CancellationToken ct)
    {
        var x = await _db.Categorias.FirstOrDefaultAsync(c => c.Id == id, ct);
        if (x is null) return NotFound();
        if (string.IsNullOrWhiteSpace(input.Nome)) return BadRequest("Nome é obrigatório.");
        x.Nome = input.Nome;
        await _db.SaveChangesAsync(ct);
        return NoContent();
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> Delete(Guid id, CancellationToken ct)
    {
        var x = await _db.Categorias.FirstOrDefaultAsync(c => c.Id == id, ct);
        if (x is null) return NotFound();
        _db.Categorias.Remove(x);
        await _db.SaveChangesAsync(ct);
        return NoContent();
    }
}
