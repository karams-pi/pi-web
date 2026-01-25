using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ModulosController : ControllerBase
{
    private readonly AppDbContext _db;
    public ModulosController(AppDbContext db) => _db = db;

    private static decimal CalcM3(Modulo m)
        => Math.Round(m.Largura * m.Profundidade * m.Altura, 2);

    [HttpGet]
    public async Task<ActionResult<object>> GetAll(
        [FromQuery] string? search,
        [FromQuery] long? idFornecedor,
        [FromQuery] long? idCategoria,
        [FromQuery] long? idMarca,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 10)
    {
        var query = _db.Modulos
            .AsNoTracking()
            .Include(m => m.ModulosTecidos)
            .ThenInclude(mt => mt.Tecido)
            .AsQueryable();

        if (!string.IsNullOrEmpty(search))
        {
            var lower = search.ToLower();
            // Basic search (case insensitive logic handled by DB usually, explicit ToLower for safety/memory)
            query = query.Where(x => x.Descricao.ToLower().Contains(lower) || x.Id.ToString().Contains(lower));
        }

        if (idFornecedor.HasValue)
            query = query.Where(x => x.IdFornecedor == idFornecedor.Value);

        if (idCategoria.HasValue)
            query = query.Where(x => x.IdCategoria == idCategoria.Value);

        if (idMarca.HasValue)
            query = query.Where(x => x.IdMarca == idMarca.Value);

        var total = await query.CountAsync();
        
        var items = await query
            .OrderByDescending(x => x.Id)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        return Ok(new 
        { 
            items, 
            total, 
            page, 
            pageSize, 
            totalPages = (int)Math.Ceiling(total / (double)pageSize) 
        });
    }

    [HttpGet("{id:long}")]
    public async Task<ActionResult<Modulo>> GetById(long id)
    {
        var item = await _db.Modulos.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id);
        return item is null ? NotFound() : item;
    }

    [HttpPost]
    public async Task<ActionResult<Modulo>> Create([FromBody] Modulo input)
    {
        input.M3 = CalcM3(input);

        _db.Modulos.Add(input);
        await _db.SaveChangesAsync();

        return CreatedAtAction(nameof(GetById), new { id = input.Id }, input);
    }

    [HttpPut("{id:long}")]
    public async Task<IActionResult> Update(long id, [FromBody] Modulo input)
    {
        var item = await _db.Modulos.FirstOrDefaultAsync(x => x.Id == id);
        if (item is null) return NotFound();

        item.IdFornecedor = input.IdFornecedor;
        item.IdCategoria = input.IdCategoria;
        item.IdMarca = input.IdMarca;
        item.Descricao = input.Descricao;

        item.Largura = input.Largura;
        item.Profundidade = input.Profundidade;
        item.Altura = input.Altura;
        item.Pa = input.Pa;

        item.M3 = CalcM3(item);

        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:long}")]
    public async Task<IActionResult> Delete(long id)
    {
        var item = await _db.Modulos.FirstOrDefaultAsync(x => x.Id == id);
        if (item is null) return NotFound();

        _db.Modulos.Remove(item);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
