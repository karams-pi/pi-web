using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ModulosTecidosController : ControllerBase
{
    private readonly AppDbContext _db;
    public ModulosTecidosController(AppDbContext db) => _db = db;

    [HttpGet]
    public async Task<ActionResult<object>> GetAll()
    {
        var list = await _db.ModulosTecidos
            .AsNoTracking()
            .Select(x => new
            {
                x.Id,
                x.IdModulo,
                x.IdTecido,
                x.ValorTecido,
                Modulo = new
                {
                    x.Modulo!.Id,
                    x.Modulo.Descricao,
                    Categoria = new { x.Modulo.Categoria!.Id, x.Modulo.Categoria.Nome },
                    Fornecedor = new { x.Modulo.Fornecedor!.Id, x.Modulo.Fornecedor.Nome },
                    Marca = new { x.Modulo.Marca!.Id, x.Modulo.Marca.Nome },
                    x.Modulo.Largura,
                    x.Modulo.Profundidade,
                    x.Modulo.Altura,
                    x.Modulo.Pa,
                    x.Modulo.M3
                },
                Tecido = new { x.Tecido!.Id, x.Tecido.Nome }
            })
            .OrderBy(x => x.Id)
            .ToListAsync();

        return Ok(list);
    }

    [HttpGet("{id:long}")]
    public async Task<ActionResult<ModuloTecido>> GetById(long id)
    {
        var item = await _db.ModulosTecidos.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id);
        return item is null ? NotFound() : item;
    }

    [HttpPost]
    public async Task<ActionResult<ModuloTecido>> Create([FromBody] ModuloTecido input)
    {
        _db.ModulosTecidos.Add(input);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = input.Id }, input);
    }

    [HttpPut("{id:long}")]
    public async Task<IActionResult> Update(long id, [FromBody] ModuloTecido input)
    {
        var item = await _db.ModulosTecidos.FirstOrDefaultAsync(x => x.Id == id);
        if (item is null) return NotFound();

        item.IdModulo = input.IdModulo;
        item.IdTecido = input.IdTecido;
        item.ValorTecido = input.ValorTecido;

        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:long}")]
    public async Task<IActionResult> Delete(long id)
    {
        var item = await _db.ModulosTecidos.FirstOrDefaultAsync(x => x.Id == id);
        if (item is null) return NotFound();

        _db.ModulosTecidos.Remove(item);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
