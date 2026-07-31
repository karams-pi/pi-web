
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models.Edc;

namespace Pi.Api.Controllers.Edc;

[ApiController]
[Route("api/edc/[controller]")]
public class PortosController : ControllerBase
{
    private readonly AppDbContext _context;
    public PortosController(AppDbContext context) => _context = context;

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Porto>>> GetPortos() 
        => await _context.Portos.OrderBy(p => p.Nome).ToListAsync();

    [HttpPost]
    public async Task<ActionResult<Porto>> PostPorto(Porto porto)
    {
        _context.Portos.Add(porto);
        await _context.SaveChangesAsync();
        return Ok(porto);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> PutPorto(int id, Porto porto)
    {
        if (id != porto.Id) return BadRequest();
        _context.Entry(porto).State = EntityState.Modified;
        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (!PortoExists(id)) return NotFound();
            throw;
        }
        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeletePorto(int id)
    {
        var porto = await _context.Portos.FindAsync(id);
        if (porto == null) return NotFound();
        _context.Portos.Remove(porto);
        await _context.SaveChangesAsync();
        return NoContent();
    }

    private bool PortoExists(int id) => _context.Portos.Any(e => e.Id == id);
}
