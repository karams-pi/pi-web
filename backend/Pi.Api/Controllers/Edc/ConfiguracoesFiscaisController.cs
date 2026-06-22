
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models.Edc;

namespace Pi.Api.Controllers.Edc;

[ApiController]
[Route("api/edc/[controller]")]
public class ConfiguracoesFiscaisController : ControllerBase
{
    private readonly AppDbContext _context;
    public ConfiguracoesFiscaisController(AppDbContext context) => _context = context;

    [HttpGet]
    public async Task<ActionResult<IEnumerable<ConfiguracaoFiscal>>> GetConfiguracoes() 
        => await _context.ConfiguracoesFiscais.OrderBy(c => c.UF).ToListAsync();

    [HttpGet("{id}")]
    public async Task<ActionResult<ConfiguracaoFiscal>> GetConfiguracao(int id)
    {
        var config = await _context.ConfiguracoesFiscais.FindAsync(id);
        if (config == null)
        {
            return NotFound();
        }
        return config;
    }

    [HttpPost]
    public async Task<ActionResult<ConfiguracaoFiscal>> PostConfiguracao(ConfiguracaoFiscal config)
    {
        _context.ConfiguracoesFiscais.Add(config);
        await _context.SaveChangesAsync();
        return CreatedAtAction(nameof(GetConfiguracao), new { id = config.Id }, config);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> PutConfiguracao(int id, ConfiguracaoFiscal config)
    {
        if (id != config.Id)
        {
            return BadRequest();
        }

        _context.Entry(config).State = EntityState.Modified;

        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (!_context.ConfiguracoesFiscais.Any(c => c.Id == id))
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
    public async Task<IActionResult> DeleteConfiguracao(int id)
    {
        var config = await _context.ConfiguracoesFiscais.FindAsync(id);
        if (config == null)
        {
            return NotFound();
        }

        _context.ConfiguracoesFiscais.Remove(config);
        await _context.SaveChangesAsync();

        return NoContent();
    }
}
