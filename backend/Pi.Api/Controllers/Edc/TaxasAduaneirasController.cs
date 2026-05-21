
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

    [HttpPut("{id}")]
    public async Task<IActionResult> PutTaxa(int id, TaxasAduaneiras taxa)
    {
        if (id != taxa.Id)
        {
            return BadRequest();
        }

        _context.Entry(taxa).State = EntityState.Modified;

        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (!_context.TaxasAduaneiras.Any(t => t.Id == id))
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
    public async Task<IActionResult> DeleteTaxa(int id)
    {
        var taxa = await _context.TaxasAduaneiras.FindAsync(id);
        if (taxa == null)
        {
            return NotFound();
        }

        _context.TaxasAduaneiras.Remove(taxa);
        await _context.SaveChangesAsync();

        return NoContent();
    }
}
