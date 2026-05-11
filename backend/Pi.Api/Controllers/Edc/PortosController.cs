
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
}
