using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class FornecedoresController : ControllerBase
{
    private readonly AppDbContext _db;
    public FornecedoresController(AppDbContext db) => _db = db;

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Fornecedor>>> GetAll()
        => await _db.Fornecedores.AsNoTracking().OrderBy(x => x.Id).ToListAsync();

    [HttpGet("{id:long}")]
    public async Task<ActionResult<Fornecedor>> GetById(long id)
    {
        var item = await _db.Fornecedores.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id);
        return item is null ? NotFound() : item;
    }

    [HttpPost]
    public async Task<ActionResult<Fornecedor>> Create([FromBody] Fornecedor input)
    {
        _db.Fornecedores.Add(input);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = input.Id }, input);
    }

    [HttpPut("{id:long}")]
    public async Task<IActionResult> Update(long id, [FromBody] Fornecedor input)
    {
        var item = await _db.Fornecedores.FirstOrDefaultAsync(x => x.Id == id);
        if (item is null) return NotFound();

        item.Nome = input.Nome;
        item.Cnpj = input.Cnpj;

        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:long}")]
    public async Task<IActionResult> Delete(long id)
    {
        var item = await _db.Fornecedores.FirstOrDefaultAsync(x => x.Id == id);
        if (item is null) return NotFound();

        _db.Fornecedores.Remove(item);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
