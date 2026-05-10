using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/pi/[controller]")]
public class CategoriasController : ControllerBase
{
    private readonly AppDbContext _db;
    public CategoriasController(AppDbContext db) => _db = db;

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Categoria>>> GetAll()
        => await _db.Categorias.AsNoTracking().OrderBy(x => x.Id).ToListAsync();

    [HttpGet("{id:long}")]
    public async Task<ActionResult<Categoria>> GetById(long id)
    {
        var item = await _db.Categorias.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id);
        return item is null ? NotFound() : item;
    }

    [HttpPost]
    public async Task<ActionResult<Categoria>> Create([FromBody] Categoria input)
    {
        _db.Categorias.Add(input);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = input.Id }, input);
    }

    [HttpPut("{id:long}")]
    public async Task<IActionResult> Update(long id, [FromBody] Categoria input)
    {
        var item = await _db.Categorias.FirstOrDefaultAsync(x => x.Id == id);
        if (item is null) return NotFound();

        item.Nome = input.Nome;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:long}")]
    public async Task<IActionResult> Delete(long id)
    {
        var item = await _db.Categorias.FirstOrDefaultAsync(x => x.Id == id);
        if (item is null) return NotFound();

        _db.Categorias.Remove(item);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
