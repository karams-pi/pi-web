using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/configuracoesfreteitem")]
public class ConfiguracoesFreteItemController : ControllerBase
{
    private readonly AppDbContext _db;

    public ConfiguracoesFreteItemController(AppDbContext db)
    {
        _db = db;
    }

    [HttpGet]
    public async Task<ActionResult<List<ConfiguracoesFreteItem>>> GetAll()
    {
        return await _db.ConfiguracoesFreteItens
            .Include(x => x.FreteItem)
            .ThenInclude(x => x!.Frete)
            .ToListAsync();
    }

    [HttpGet("by-frete/{idFrete}")]
    public async Task<ActionResult<object>> GetByFrete(long idFrete, [FromQuery] long? fornecedorId = null)
    {
        var query = _db.ConfiguracoesFreteItens
            .Include(x => x.FreteItem)
            .Where(x => x.FreteItem!.IdFrete == idFrete);

        if (fornecedorId.HasValue)
        {
            query = query.Where(x => x.IdFornecedor == fornecedorId.Value);
        }
        else
        {
            query = query.Where(x => x.IdFornecedor == null);
        }

        var items = await query
            .Select(x => new
            {
                x.Id,
                x.IdFreteItem,
                x.Valor,
                x.FlDesconsidera,
                x.IdFornecedor,
                FreteItem = new
                {
                    x.FreteItem!.Id,
                    x.FreteItem.Nome
                }
            })
            .ToListAsync();
        
        return Ok(items);
    }

    [HttpGet("total-frete/{idFrete}")]
    public async Task<ActionResult<decimal>> GetTotalFrete(long idFrete, [FromQuery] long? fornecedorId = null)
    {
        var baseQuery = _db.ConfiguracoesFreteItens
            .Include(x => x.FreteItem)
            .Where(x => x.FreteItem!.IdFrete == idFrete && !x.FlDesconsidera);

        if (fornecedorId.HasValue)
        {
            // Check if there are specific configurations for this supplier
            var hasSpecificConfig = await baseQuery.AnyAsync(x => x.IdFornecedor == fornecedorId.Value);

            if (hasSpecificConfig)
            {
                // Use specific supplier costs
                return await baseQuery
                    .Where(x => x.IdFornecedor == fornecedorId.Value)
                    .SumAsync(x => x.Valor);
            }
        }

        // Fallback or Default: Use Global (IdFornecedor == null)
        return await baseQuery
            .Where(x => x.IdFornecedor == null)
            .SumAsync(x => x.Valor);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<ConfiguracoesFreteItem>> GetById(long id)
    {
        var item = await _db.ConfiguracoesFreteItens
            .Include(x => x.FreteItem)
            .ThenInclude(x => x!.Frete)
            .FirstOrDefaultAsync(x => x.Id == id);
        if (item == null) return NotFound();
        return item;
    }

    [HttpPost]
    public async Task<ActionResult<ConfiguracoesFreteItem>> Create(ConfiguracoesFreteItem item)
    {
        _db.ConfiguracoesFreteItens.Add(item);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = item.Id }, item);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(long id, ConfiguracoesFreteItem item)
    {
        if (id != item.Id) return BadRequest();
        _db.Entry(item).State = EntityState.Modified;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(long id)
    {
        var item = await _db.ConfiguracoesFreteItens.FindAsync(id);
        if (item == null) return NotFound();
        _db.ConfiguracoesFreteItens.Remove(item);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
