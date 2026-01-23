using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/piitens")]
public class PiItensController : ControllerBase
{
    private readonly AppDbContext _db;

    public PiItensController(AppDbContext db)
    {
        _db = db;
    }

    [HttpGet]
    public async Task<ActionResult<List<PiItem>>> GetAll()
    {
        return await _db.PiItens
            .Include(x => x.Pi)
            .Include(x => x.ModuloTecido)
            .ToListAsync();
    }

    [HttpGet("by-pi/{idPi}")]
    public async Task<ActionResult<List<PiItem>>> GetByPi(long idPi)
    {
        return await _db.PiItens
            .Where(x => x.IdPi == idPi)
            .Include(x => x.ModuloTecido)
            .ThenInclude(x => x!.Modulo)
            .Include(x => x.ModuloTecido)
            .ThenInclude(x => x!.Tecido)
            .ToListAsync();
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<PiItem>> GetById(long id)
    {
        var item = await _db.PiItens
            .Include(x => x.Pi)
            .Include(x => x.ModuloTecido)
            .FirstOrDefaultAsync(x => x.Id == id);
            
        if (item == null) return NotFound();
        return item;
    }

    [HttpPost]
    public async Task<ActionResult<PiItem>> Create(PiItem item)
    {
        _db.PiItens.Add(item);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = item.Id }, item);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(long id, PiItem item)
    {
        if (id != item.Id) return BadRequest();
        _db.Entry(item).State = EntityState.Modified;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(long id)
    {
        var item = await _db.PiItens.FindAsync(id);
        if (item == null) return NotFound();
        _db.PiItens.Remove(item);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
