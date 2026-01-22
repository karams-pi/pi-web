using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class TecidosController : ControllerBase
{
    private readonly AppDbContext _db;
    public TecidosController(AppDbContext db) => _db = db;

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Tecido>>> GetAll()
        => await _db.Tecidos.AsNoTracking().OrderBy(x => x.Id).ToListAsync();

    [HttpGet("{id:long}")]
    public async Task<ActionResult<Tecido>> GetById(long id)
    {
        var item = await _db.Tecidos.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id);
        return item is null ? NotFound() : item;
    }

    [HttpPost]
    public async Task<ActionResult<Tecido>> Create([FromBody] Tecido input)
    {
        _db.Tecidos.Add(input);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = input.Id }, input);
    }

    [HttpPut("{id:long}")]
    public async Task<IActionResult> Update(long id, [FromBody] Tecido input)
    {
        var item = await _db.Tecidos.FirstOrDefaultAsync(x => x.Id == id);
        if (item is null) return NotFound();

        item.Nome = input.Nome;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:long}")]
    public async Task<IActionResult> Delete(long id)
    {
        var item = await _db.Tecidos.FirstOrDefaultAsync(x => x.Id == id);
        if (item is null) return NotFound();

        _db.Tecidos.Remove(item);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
