using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models.Edc;

namespace Pi.Api.Controllers.Edc;

[ApiController]
[Route("api/edc/[controller]")]
public class ModelosController : ControllerBase
{
    private readonly AppDbContext _context;

    public ModelosController(AppDbContext context) => _context = context;

    [HttpGet]
    public async Task<ActionResult<IEnumerable<ModeloEdc>>> GetModelos()
    {
        return await _context.ModelosEdc
            .Include(m => m.Produto)
                .ThenInclude(p => p!.Ncm)
            .Where(m => m.FlAtivo)
            .OrderBy(m => m.Nome)
            .ToListAsync();
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<ModeloEdc>> GetModelo(int id)
    {
        var modelo = await _context.ModelosEdc
            .Include(m => m.Produto)
                .ThenInclude(p => p!.Ncm)
            .FirstOrDefaultAsync(m => m.Id == id && m.FlAtivo);

        if (modelo == null) return NotFound();

        return modelo;
    }

    [HttpPost]
    public async Task<ActionResult<ModeloEdc>> PostModelo(ModeloEdc modelo)
    {
        _context.ModelosEdc.Add(modelo);
        await _context.SaveChangesAsync();
        return CreatedAtAction(nameof(GetModelo), new { id = modelo.Id }, modelo);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> PutModelo(int id, ModeloEdc modelo)
    {
        if (id != modelo.Id)
        {
            return BadRequest();
        }

        _context.Entry(modelo).State = EntityState.Modified;

        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (!_context.ModelosEdc.Any(m => m.Id == id))
            {
                return NotFound();
            }
            else
            {
                throw;
            }
        }

        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteModelo(int id)
    {
        var modelo = await _context.ModelosEdc.FindAsync(id);
        if (modelo == null)
        {
            return NotFound();
        }

        // Soft delete
        modelo.FlAtivo = false;
        await _context.SaveChangesAsync();

        return NoContent();
    }
}
