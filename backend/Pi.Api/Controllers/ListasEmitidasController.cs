using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/pi/listas-emitidas")]
public class ListasEmitidasController : ControllerBase
{
    private readonly AppDbContext _db;
    public ListasEmitidasController(AppDbContext db) => _db = db;

    [HttpGet]
    public async Task<ActionResult<IEnumerable<ListaEmitida>>> GetAll()
        => await _db.ListasEmitidas.AsNoTracking().OrderByDescending(x => x.DataEmissao).ToListAsync();

    [HttpGet("{id:long}")]
    public async Task<ActionResult<ListaEmitida>> GetById(long id)
    {
        var item = await _db.ListasEmitidas.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id);
        return item is null ? NotFound() : item;
    }

    [HttpPost]
    public async Task<ActionResult<ListaEmitida>> Create([FromBody] ListaEmitida input)
    {
        _db.ListasEmitidas.Add(input);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = input.Id }, input);
    }

    [HttpDelete("{id:long}")]
    public async Task<IActionResult> Delete(long id)
    {
        var item = await _db.ListasEmitidas.FirstOrDefaultAsync(x => x.Id == id);
        if (item is null) return NotFound();

        _db.ListasEmitidas.Remove(item);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
