using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/pi/freteitens")]
public class FreteItensController : ControllerBase
{
    private readonly AppDbContext _db;

    public FreteItensController(AppDbContext db)
    {
        _db = db;
    }

    [HttpGet]
    public async Task<ActionResult<List<FreteItem>>> GetAll()
    {
        return await _db.FreteItens.Include(x => x.Frete).ToListAsync();
    }

    [HttpGet("by-frete/{idFrete}")]
    public async Task<ActionResult<List<FreteItem>>> GetByFrete(long idFrete)
    {
        return await _db.FreteItens
            .Where(x => x.IdFrete == idFrete)
            .Include(x => x.Frete)
            .ToListAsync();
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<FreteItem>> GetById(long id)
    {
        var item = await _db.FreteItens.Include(x => x.Frete).FirstOrDefaultAsync(x => x.Id == id);
        if (item == null) return NotFound();
        return item;
    }

    [HttpPost]
    public async Task<ActionResult<FreteItem>> Create(FreteItem item)
    {
        var trimmed = item.Nome?.Trim() ?? string.Empty;
        var existing = await _db.FreteItens
            .FirstOrDefaultAsync(x => x.IdFrete == item.IdFrete && 
                                      x.Nome.ToLower() == trimmed.ToLower());
        if (existing != null)
        {
            return Ok(existing);
        }

        item.Id = 0; // Force EF to generate ID
        item.Nome = trimmed;
        _db.FreteItens.Add(item);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = item.Id }, item);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(long id, FreteItem item)
    {
        if (id != item.Id) return BadRequest();
        _db.Entry(item).State = EntityState.Modified;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(long id)
    {
        var item = await _db.FreteItens.FindAsync(id);
        if (item == null) return NotFound();
        _db.FreteItens.Remove(item);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
