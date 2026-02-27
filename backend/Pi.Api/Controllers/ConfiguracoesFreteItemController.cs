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
        var itemIds = await _db.FreteItens
            .Where(x => x.IdFrete == idFrete)
            .Select(x => x.Id)
            .ToListAsync();

        var configs = await _db.ConfiguracoesFreteItens
            .Include(x => x.FreteItem)
            .Where(x => itemIds.Contains(x.IdFreteItem) &&
                        (x.IdFornecedor == null || (fornecedorId.HasValue && x.IdFornecedor == fornecedorId.Value)))
            .ToListAsync();

        var result = new List<object>();

        foreach (var itemId in itemIds)
        {
            var config = configs
                .Where(x => x.IdFreteItem == itemId)
                .OrderByDescending(x => x.IdFornecedor.HasValue)
                .FirstOrDefault();

            if (config != null)
            {
                result.Add(new
                {
                    config.Id,
                    config.IdFreteItem,
                    config.Valor,
                    config.FlDesconsidera,
                    config.IdFornecedor,
                    FreteItem = new
                    {
                        config.FreteItem!.Id,
                        config.FreteItem.Nome
                    }
                });
            }
        }
        
        return Ok(result);
    }

    [HttpGet("total-frete/{idFrete}")]
    public async Task<ActionResult<decimal>> GetTotalFrete(long idFrete, [FromQuery] long? fornecedorId = null)
    {
        var itemIds = await _db.FreteItens
            .Where(x => x.IdFrete == idFrete)
            .Select(x => x.Id)
            .ToListAsync();

        if (!itemIds.Any()) return Ok(0m);

        var configs = await _db.ConfiguracoesFreteItens
            .Where(x => itemIds.Contains(x.IdFreteItem) && !x.FlDesconsidera &&
                        (x.IdFornecedor == null || (fornecedorId.HasValue && x.IdFornecedor == fornecedorId.Value)))
            .ToListAsync();

        decimal total = 0;

        foreach (var itemId in itemIds)
        {
            var config = configs
                .Where(x => x.IdFreteItem == itemId)
                .OrderByDescending(x => x.IdFornecedor.HasValue)
                .FirstOrDefault();

            if (config != null)
            {
                total += config.Valor;
            }
        }

        return Ok(total);
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
