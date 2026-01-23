using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/fretes")]
public class FretesController : ControllerBase
{
    private readonly AppDbContext _db;

    public FretesController(AppDbContext db)
    {
        _db = db;
    }

    [HttpGet]
    public async Task<ActionResult<List<Frete>>> GetAll()
    {
        return await _db.Fretes.ToListAsync();
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Frete>> GetById(long id)
    {
        var frete = await _db.Fretes.FindAsync(id);
        if (frete == null) return NotFound();
        return frete;
    }

    [HttpPost]
    public async Task<ActionResult<Frete>> Create(Frete frete)
    {
        _db.Fretes.Add(frete);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = frete.Id }, frete);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(long id, Frete frete)
    {
        if (id != frete.Id) return BadRequest();
        _db.Entry(frete).State = EntityState.Modified;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(long id)
    {
        var frete = await _db.Fretes.FindAsync(id);
        if (frete == null) return NotFound();
        _db.Fretes.Remove(frete);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
