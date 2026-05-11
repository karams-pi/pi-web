
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models.Edc;

namespace Pi.Api.Controllers.Edc;

[ApiController]
[Route("api/edc/[controller]")]
public class NcmsController : ControllerBase
{
    private readonly AppDbContext _context;

    public NcmsController(AppDbContext context) => _context = context;

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Ncm>>> GetNcms() 
        => await _context.Ncms.Where(n => n.FlAtivo).OrderBy(n => n.Codigo).ToListAsync();

    [HttpPost]
    public async Task<ActionResult<Ncm>> PostNcm(Ncm ncm)
    {
        _context.Ncms.Add(ncm);
        await _context.SaveChangesAsync();
        return CreatedAtAction(nameof(GetNcms), new { id = ncm.Id }, ncm);
    }
}
