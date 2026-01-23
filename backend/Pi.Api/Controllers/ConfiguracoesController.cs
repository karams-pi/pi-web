using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ConfiguracoesController : ControllerBase
{
    private readonly AppDbContext _context;

    public ConfiguracoesController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<List<Configuracao>>> GetConfiguracoes()
    {
        // Retorna a lista completa ordenada por data decrescente (mais recente primeiro)
        return await _context.Configuracoes
            .OrderByDescending(c => c.DataConfig)
            .ToListAsync();
    }

    [HttpGet("latest")]
    public async Task<ActionResult<Configuracao>> GetLatestConfiguracao()
    {
        var config = await _context.Configuracoes
            .OrderByDescending(c => c.DataConfig)
            .FirstOrDefaultAsync();

        if (config == null)
        {
            return NotFound("Nenhuma configuração encontrada.");
        }

        return config;
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Configuracao>> GetConfiguracao(long id)
    {
        var config = await _context.Configuracoes.FindAsync(id);

        if (config == null)
        {
            return NotFound();
        }

        return config;
    }

    [HttpPost]
    public async Task<ActionResult<Configuracao>> CreateConfiguracao(Configuracao config)
    {
        // Force ID to 0 to ensure new record
        config.Id = 0;
        config.DataConfig = DateTime.UtcNow; // Always set current time for new config

        _context.Configuracoes.Add(config);
        await _context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetConfiguracao), new { id = config.Id }, config);
    }
    
    // Opcional: Update (PUT)
    // Se a regra é "sempre criar um histórico", talvez não devêssemos ter PUT.
    // Mas para correções rápidas na mesma configuração, pode ser útil.
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateConfiguracao(long id, Configuracao config)
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
            if (!ConfiguracaoExists(id))
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
    public async Task<IActionResult> DeleteConfiguracao(long id)
    {
        var config = await _context.Configuracoes.FindAsync(id);
        if (config == null)
        {
            return NotFound();
        }

        _context.Configuracoes.Remove(config);
        await _context.SaveChangesAsync();

        return NoContent();
    }

    private bool ConfiguracaoExists(long id)
    {
        return (_context.Configuracoes?.Any(e => e.Id == id)).GetValueOrDefault();
    }
}
