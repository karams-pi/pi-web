
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models.Edc;

namespace Pi.Api.Controllers.Edc;

[ApiController]
[Route("api/edc/[controller]")]
public class TaxasAduaneirasController : ControllerBase
{
    private readonly AppDbContext _context;
    public TaxasAduaneirasController(AppDbContext context) => _context = context;

    [HttpGet]
    public async Task<ActionResult<IEnumerable<TaxasAduaneiras>>> GetTaxas() 
        => await _context.TaxasAduaneiras.ToListAsync();

    [HttpPost]
    public async Task<ActionResult<TaxasAduaneiras>> PostTaxa(TaxasAduaneiras taxa)
    {
        _context.TaxasAduaneiras.Add(taxa);
        await _context.SaveChangesAsync();
        return Ok(taxa);
    }
}
