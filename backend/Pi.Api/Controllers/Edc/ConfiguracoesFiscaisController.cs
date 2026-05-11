
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

    [HttpPost]
    public async Task<ActionResult<ConfiguracaoFiscal>> PostConfiguracao(ConfiguracaoFiscal config)
    {
        _context.ConfiguracoesFiscais.Add(config);
        await _context.SaveChangesAsync();
        return Ok(config);
    }
}
