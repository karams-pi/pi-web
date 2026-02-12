using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class MarcasController : ControllerBase
{
    private readonly AppDbContext _db;
    public MarcasController(AppDbContext db) => _db = db;

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Marca>>> GetAll()
        => await _db.Marcas.AsNoTracking().OrderBy(x => x.Id).ToListAsync();

    [HttpGet("{id:long}")]
    public async Task<ActionResult<Marca>> GetById(long id)
    {
        var item = await _db.Marcas.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id);
        return item is null ? NotFound() : item;
    }

    [HttpPost]
    public async Task<ActionResult<Marca>> Create([FromBody] Marca input)
    {
        _db.Marcas.Add(input);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = input.Id }, input);
    }

    [HttpPut("{id:long}")]
    public async Task<IActionResult> Update(long id, [FromBody] Marca input)
    {
        var item = await _db.Marcas.FirstOrDefaultAsync(x => x.Id == id);
        if (item is null) return NotFound();

        item.Nome = input.Nome;
        item.UrlImagem = input.UrlImagem;
        item.Observacao = input.Observacao;
        item.FlAtivo = input.FlAtivo;

        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:long}")]
    public async Task<IActionResult> Delete(long id)
    {
        var item = await _db.Marcas.FirstOrDefaultAsync(x => x.Id == id);
        if (item is null) return NotFound();

        _db.Marcas.Remove(item);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
