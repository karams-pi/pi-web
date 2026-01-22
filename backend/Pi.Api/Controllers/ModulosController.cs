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
    public async Task<ActionResult<IEnumerable<Modulo>>> GetAll()
        => await _db.Modulos
            .AsNoTracking()
            .OrderBy(x => x.Id)
            .ToListAsync();

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
