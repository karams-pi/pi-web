
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models.Edc;

namespace Pi.Api.Controllers.Edc;

[ApiController]
[Route("api/edc/[controller]")]
public class ExportadoresController : ControllerBase
{
    private readonly AppDbContext _context;

    public ExportadoresController(AppDbContext context) => _context = context;

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Exportador>>> GetExportadores() 
        => await _context.Exportadores.Where(e => e.FlAtivo).OrderBy(e => e.Nome).ToListAsync();

    [HttpGet("{id}")]
    public async Task<ActionResult<Exportador>> GetExportador(int id)
    {
        var exportador = await _context.Exportadores.FindAsync(id);
        if (exportador == null)
        {
            return NotFound();
        }
        return exportador;
    }

    [HttpPost]
    public async Task<ActionResult<Exportador>> PostExportador(Exportador exportador)
    {
        _context.Exportadores.Add(exportador);
        await _context.SaveChangesAsync();
        return CreatedAtAction(nameof(GetExportador), new { id = exportador.Id }, exportador);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> PutExportador(int id, Exportador exportador)
    {
        if (id != exportador.Id)
        {
            return BadRequest();
        }

        _context.Entry(exportador).State = EntityState.Modified;

        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (!_context.Exportadores.Any(e => e.Id == id))
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
    public async Task<IActionResult> DeleteExportador(int id)
    {
        var exportador = await _context.Exportadores.FindAsync(id);
        if (exportador == null)
        {
            return NotFound();
        }

        // Soft delete
        exportador.FlAtivo = false;
        await _context.SaveChangesAsync();

        return NoContent();
    }
}
