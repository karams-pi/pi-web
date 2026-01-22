using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/fornecedores")]
public class FornecedoresController : ControllerBase
{
    private readonly AppDbContext _db;
    public FornecedoresController(AppDbContext db) => _db = db;

    [HttpGet]
    public async Task<IActionResult> GetAll(CancellationToken ct)
    {
        var items = await _db.Fornecedores
            .AsNoTracking()
            .OrderBy(x => x.Nome)
            .ToListAsync(ct);

        return Ok(items);
    }

    [HttpGet("{id:long}")]
    public async Task<ActionResult<Fornecedor>> GetById(long id, CancellationToken ct)
    {
        var entity = await _db.Fornecedores.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id, ct);
        if (entity is null) return NotFound();
        return entity;
    }

    [HttpPost]
    public async Task<ActionResult<Fornecedor>> Create([FromBody] Fornecedor input, CancellationToken ct)
    {
        if (string.IsNullOrWhiteSpace(input.Nome)) return BadRequest("Nome é obrigatório.");
        if (string.IsNullOrWhiteSpace(input.Cnpj)) return BadRequest("CNPJ é obrigatório.");

        input.Id = 0;
        _db.Fornecedores.Add(input);
        await _db.SaveChangesAsync(ct);

        return CreatedAtAction(nameof(GetById), new { id = input.Id }, input);
    }

    [HttpPut("{id:long}")]
    public async Task<IActionResult> Update(long id, [FromBody] Fornecedor input, CancellationToken ct)
    {
        if (id != input.Id) return BadRequest("Id do path difere do body.");
        if (string.IsNullOrWhiteSpace(input.Nome)) return BadRequest("Nome é obrigatório.");
        if (string.IsNullOrWhiteSpace(input.Cnpj)) return BadRequest("CNPJ é obrigatório.");

        var entity = await _db.Fornecedores.FirstOrDefaultAsync(x => x.Id == id, ct);
        if (entity is null) return NotFound();

        entity.Nome = input.Nome;
        entity.Cnpj = input.Cnpj;

        await _db.SaveChangesAsync(ct);
        return NoContent();
    }

    [HttpDelete("{id:long}")]
    public async Task<IActionResult> Delete(long id, CancellationToken ct)
    {
        var entity = await _db.Fornecedores.FirstOrDefaultAsync(x => x.Id == id, ct);
        if (entity is null) return NotFound();

        var hasModelos = await _db.Modelos.AnyAsync(m => m.FornecedorId == id, ct);
        if (hasModelos) return Conflict("Não é possível excluir: existem modelos vinculados a este fornecedor.");

        _db.Fornecedores.Remove(entity);
        await _db.SaveChangesAsync(ct);
        return NoContent();
    }
}
