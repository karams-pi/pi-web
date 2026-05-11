
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

    [HttpPost]
    public async Task<ActionResult<Exportador>> PostExportador(Exportador exportador)
    {
        _context.Exportadores.Add(exportador);
        await _context.SaveChangesAsync();
        return CreatedAtAction(nameof(GetExportadores), new { id = exportador.Id }, exportador);
    }
}
