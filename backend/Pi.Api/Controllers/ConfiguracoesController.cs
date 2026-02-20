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

    [HttpGet("latest-all")]
    public async Task<ActionResult<IEnumerable<Configuracao>>> GetLatestConfigs()
    {
        // Gets the latest config for EACH supplier (and global)
        var configs = await _context.Configuracoes
            .GroupBy(c => c.IdFornecedor)
            .Select(g => g.OrderByDescending(c => c.DataConfig).First())
            .ToListAsync();
        
        return configs;
    }

    [HttpGet("latest")]
    public async Task<ActionResult<Configuracao>> GetLatestConfiguracao([FromQuery] long? idFornecedor = null)
    {
        var query = _context.Configuracoes.AsQueryable();

        if (idFornecedor.HasValue)
        {
            query = query.Where(c => c.IdFornecedor == idFornecedor.Value);
        }
        else
        {
            query = query.Where(c => c.IdFornecedor == null);
        }

        var config = await query
            .OrderByDescending(c => c.DataConfig)
            .FirstOrDefaultAsync();

        if (config == null)
        {
            // Fallback to global if supplier specific not found
            if (idFornecedor.HasValue)
            {
                return await GetLatestConfiguracao(null);
            }
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

    [HttpPost("fix-sequences")]
    public async Task<IActionResult> FixSequences()
    {
        try 
        {
            var sql1 = "SELECT setval(pg_get_serial_sequence('frete_item', 'id'), COALESCE(max(id),0) + 1, false) FROM frete_item;";
            await _context.Database.ExecuteSqlRawAsync(sql1);
            
            var sql2 = "SELECT setval(pg_get_serial_sequence('configuracoes_frete_item', 'id'), COALESCE(max(id),0) + 1, false) FROM configuracoes_frete_item;";
            await _context.Database.ExecuteSqlRawAsync(sql2);

            var sql3 = "SELECT setval(pg_get_serial_sequence('configuracoes', 'id'), COALESCE(max(id),0) + 1, false) FROM configuracoes;";
            await _context.Database.ExecuteSqlRawAsync(sql3);

            return Ok("Sequences reset successfully");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Error resetting sequences: {ex.Message}");
        }
    }

    [HttpPost("replicate-to-suppliers")]
    public async Task<IActionResult> ReplicateToSuppliers()
    {
        try
        {
            // 1. Get latest global config
            var latestGlobal = await _context.Configuracoes
                .Where(c => c.IdFornecedor == null)
                .OrderByDescending(c => c.DataConfig)
                .FirstOrDefaultAsync();

            if (latestGlobal == null) return BadRequest("Nenhuma configuração global encontrada para replicar.");

            // 2. Get all suppliers
            var suppliers = await _context.Fornecedores.ToListAsync();

            // 3. For each supplier, verify if they already have one. If not, create.
            int count = 0;
            foreach (var supplier in suppliers)
            {
                bool exists = await _context.Configuracoes.AnyAsync(c => c.IdFornecedor == supplier.Id);
                if (!exists)
                {
                    var newConfig = new Configuracao
                    {
                        DataConfig = DateTime.UtcNow,
                        ValorReducaoDolar = latestGlobal.ValorReducaoDolar,
                        ValorPercImposto = latestGlobal.ValorPercImposto,
                        PercentualComissao = latestGlobal.PercentualComissao,
                        PercentualGordura = latestGlobal.PercentualGordura,
                        ValorFCAFreteRodFronteira = latestGlobal.ValorFCAFreteRodFronteira,
                        ValorDespesasFCA = latestGlobal.ValorDespesasFCA,
                        ValorFOBFretePortoParanagua = latestGlobal.ValorFOBFretePortoParanagua,
                        ValorFOBDespPortRegDoc = latestGlobal.ValorFOBDespPortRegDoc,
                        ValorFOBDespDespacAduaneiro = latestGlobal.ValorFOBDespDespacAduaneiro,
                        ValorFOBDespCourier = latestGlobal.ValorFOBDespCourier,
                        IdFornecedor = supplier.Id
                    };
                    _context.Configuracoes.Add(newConfig);
                    count++;
                }
            }

            if (count > 0)
            {
                await _context.SaveChangesAsync();
            }

            return Ok(new { message = $"Configurações replicadas para {count} fornecedores." });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = $"Erro ao replicar configurações: {ex.Message}" });
        }
    }
}
