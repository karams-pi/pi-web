using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ModulosTecidosController : ControllerBase
{
    private readonly AppDbContext _db;
    public ModulosTecidosController(AppDbContext db) => _db = db;

    [HttpGet]
    public async Task<ActionResult<IEnumerable<ModuloTecido>>> GetAll()
        => await _db.ModulosTecidos.AsNoTracking().OrderBy(x => x.Id).ToListAsync();

    [HttpGet("{id:long}")]
    public async Task<ActionResult<ModuloTecido>> GetById(long id)
    {
        var item = await _db.ModulosTecidos.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id);
        return item is null ? NotFound() : item;
    }

    [HttpPost]
    public async Task<ActionResult<ModuloTecido>> Create([FromBody] ModuloTecido input)
    {
        _db.ModulosTecidos.Add(input);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = input.Id }, input);
    }

    [HttpPut("{id:long}")]
    public async Task<IActionResult> Update(long id, [FromBody] ModuloTecido input)
    {
        var item = await _db.ModulosTecidos.FirstOrDefaultAsync(x => x.Id == id);
        if (item is null) return NotFound();

        item.IdModulo = input.IdModulo;
        item.IdTecido = input.IdTecido;
        item.ValorTecido = input.ValorTecido;

        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:long}")]
    public async Task<IActionResult> Delete(long id)
    {
        var item = await _db.ModulosTecidos.FirstOrDefaultAsync(x => x.Id == id);
        if (item is null) return NotFound();

        _db.ModulosTecidos.Remove(item);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
