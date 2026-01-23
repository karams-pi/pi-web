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
    public async Task<ActionResult<object>> GetByFrete(long idFrete)
    {
        var items = await _db.ConfiguracoesFreteItens
            .Include(x => x.FreteItem)
            .Where(x => x.FreteItem!.IdFrete == idFrete)
            .Select(x => new
            {
                x.Id,
                x.IdFreteItem,
                x.Valor,
                x.FlDesconsidera,
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
    public async Task<ActionResult<decimal>> GetTotalFrete(long idFrete)
    {
        var total = await _db.ConfiguracoesFreteItens
            .Include(x => x.FreteItem)
            .Where(x => x.FreteItem!.IdFrete == idFrete && !x.FlDesconsidera)
            .SumAsync(x => x.Valor);
        return total;
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
