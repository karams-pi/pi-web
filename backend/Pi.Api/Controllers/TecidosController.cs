using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/tecidos")]
public class TecidosController : ControllerBase
{
    private readonly AppDbContext _db;
    public TecidosController(AppDbContext db) => _db = db;

    [HttpGet]
    public async Task<IActionResult> GetAll(CancellationToken ct)
        => Ok(await _db.Tecidos.AsNoTracking().OrderBy(x => x.Nome).ToListAsync(ct));

    [HttpGet("{id:long}")]
    public async Task<ActionResult<Tecido>> GetById(long id, CancellationToken ct)
    {
        var entity = await _db.Tecidos.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id, ct);
        if (entity is null) return NotFound();
        return entity;
    }

    [HttpPost]
    public async Task<ActionResult<Tecido>> Create([FromBody] Tecido input, CancellationToken ct)
    {
        if (string.IsNullOrWhiteSpace(input.Nome)) return BadRequest("Nome é obrigatório.");

        input.Id = 0;
        _db.Tecidos.Add(input);
        await _db.SaveChangesAsync(ct);

        return CreatedAtAction(nameof(GetById), new { id = input.Id }, input);
    }

    [HttpPut("{id:long}")]
    public async Task<IActionResult> Update(long id, [FromBody] Tecido input, CancellationToken ct)
    {
        if (id != input.Id) return BadRequest("Id do path difere do body.");
        if (string.IsNullOrWhiteSpace(input.Nome)) return BadRequest("Nome é obrigatório.");

        var entity = await _db.Tecidos.FirstOrDefaultAsync(x => x.Id == id, ct);
        if (entity is null) return NotFound();

        entity.Nome = input.Nome;

        await _db.SaveChangesAsync(ct);
        return NoContent();
    }

    [HttpDelete("{id:long}")]
    public async Task<IActionResult> Delete(long id, CancellationToken ct)
    {
        var entity = await _db.Tecidos.FirstOrDefaultAsync(x => x.Id == id, ct);
        if (entity is null) return NotFound();

        var hasModelos = await _db.Modelos.AnyAsync(m => m.TecidoId == id, ct);
        if (hasModelos) return Conflict("Não é possível excluir: existem modelos vinculados a este tecido.");

        _db.Tecidos.Remove(entity);
        await _db.SaveChangesAsync(ct);
        return NoContent();
    }
}
