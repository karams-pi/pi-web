using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ModelosController : ControllerBase
{
    private readonly AppDbContext _db;
    public ModelosController(AppDbContext db) => _db = db;

    [HttpGet]
    public async Task<ActionResult<object>> GetAll(
        [FromQuery] long? idFornecedor,
        [FromQuery] long? idCategoria)
    {
        var query = _db.Modelos
            .AsNoTracking()
            .Include(x => x.Fornecedor)
            .Include(x => x.Categoria)
            .AsQueryable();

        if (idFornecedor.HasValue) query = query.Where(x => x.IdFornecedor == idFornecedor.Value);
        if (idCategoria.HasValue) query = query.Where(x => x.IdCategoria == idCategoria.Value);

        return await query.OrderBy(x => x.Descricao).ToListAsync();
    }

    [HttpGet("{id:long}")]
    public async Task<ActionResult<Modelo>> GetById(long id)
    {
        var item = await _db.Modelos.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id);
        return item is null ? NotFound() : item;
    }

    [HttpPost]
    public async Task<ActionResult<Modelo>> Create([FromBody] Modelo input)
    {
        _db.Modelos.Add(input);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = input.Id }, input);
    }

    [HttpPut("{id:long}")]
    public async Task<IActionResult> Update(long id, [FromBody] Modelo input)
    {
        var item = await _db.Modelos.FirstOrDefaultAsync(x => x.Id == id);
        if (item is null) return NotFound();

        item.IdFornecedor = input.IdFornecedor;
        item.IdCategoria = input.IdCategoria;
        item.Descricao = input.Descricao;
        item.UrlImagem = input.UrlImagem;

        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:long}")]
    public async Task<IActionResult> Delete(long id)
    {
        var item = await _db.Modelos.FindAsync(id);
        if (item is null) return NotFound();

        _db.Modelos.Remove(item);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
