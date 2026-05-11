
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models.Edc;

namespace Pi.Api.Controllers.Edc;

[ApiController]
[Route("api/edc/[controller]")]
public class ImportadoresController : ControllerBase
{
    private readonly AppDbContext _context;

    public ImportadoresController(AppDbContext context) => _context = context;

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Importador>>> GetImportadores() 
        => await _context.Importadores.Where(i => i.FlAtivo).OrderBy(i => i.RazaoSocial).ToListAsync();

    [HttpPost]
    public async Task<ActionResult<Importador>> PostImportador(Importador importador)
    {
        _context.Importadores.Add(importador);
        await _context.SaveChangesAsync();
        return CreatedAtAction(nameof(GetImportadores), new { id = importador.Id }, importador);
    }
}
