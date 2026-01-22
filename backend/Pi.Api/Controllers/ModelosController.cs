using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/modelos")]
public class ModelosController : ControllerBase
{
    private readonly AppDbContext _db;
    public ModelosController(AppDbContext db) => _db = db;

    [HttpGet]
    public async Task<IActionResult> GetAll(
        [FromQuery] long? fornecedorId,
        [FromQuery] long? categoriaId,
        [FromQuery] long? tecidoId,
        CancellationToken ct)
    {
        IQueryable<Modelo> q = _db.Modelos.AsNoTracking();

        if (fornecedorId.HasValue) q = q.Where(m => m.FornecedorId == fornecedorId.Value);
        if (categoriaId.HasValue) q = q.Where(m => m.CategoriaId == categoriaId.Value);
        if (tecidoId.HasValue) q = q.Where(m => m.TecidoId == tecidoId.Value);

        var items = await q.OrderBy(m => m.Descricao).ToListAsync(ct);
        return Ok(items);
    }

    [HttpGet("{id:long}")]
    public async Task<ActionResult<Modelo>> GetById(long id, CancellationToken ct)
    {
        var entity = await _db.Modelos.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id, ct);
        if (entity is null) return NotFound();
        return entity;
    }

    [HttpPost]
    public async Task<ActionResult<Modelo>> Create([FromBody] Modelo input, CancellationToken ct)
    {
        if (string.IsNullOrWhiteSpace(input.Descricao)) return BadRequest("Descrição é obrigatória.");

        if (!await _db.Fornecedores.AnyAsync(f => f.Id == input.FornecedorId, ct))
            return BadRequest("Fornecedor não encontrado.");

        if (!await _db.Categorias.AnyAsync(c => c.Id == input.CategoriaId, ct))
            return BadRequest("Categoria não encontrada.");

        if (!await _db.Tecidos.AnyAsync(t => t.Id == input.TecidoId, ct))
            return BadRequest("Tecido não encontrado.");

        input.Id = 0;
        _db.Modelos.Add(input);
        await _db.SaveChangesAsync(ct);

        return CreatedAtAction(nameof(GetById), new { id = input.Id }, input);
    }

    [HttpPut("{id:long}")]
    public async Task<IActionResult> Update(long id, [FromBody] Modelo input, CancellationToken ct)
    {
        if (id != input.Id) return BadRequest("Id do path difere do body.");
        if (string.IsNullOrWhiteSpace(input.Descricao)) return BadRequest("Descrição é obrigatória.");

        var entity = await _db.Modelos.FirstOrDefaultAsync(x => x.Id == id, ct);
        if (entity is null) return NotFound();

        // valida FKs se alteradas
        if (entity.FornecedorId != input.FornecedorId &&
            !await _db.Fornecedores.AnyAsync(f => f.Id == input.FornecedorId, ct))
            return BadRequest("Fornecedor não encontrado.");

        if (entity.CategoriaId != input.CategoriaId &&
            !await _db.Categorias.AnyAsync(c => c.Id == input.CategoriaId, ct))
            return BadRequest("Categoria não encontrada.");

        if (entity.TecidoId != input.TecidoId &&
            !await _db.Tecidos.AnyAsync(t => t.Id == input.TecidoId, ct))
            return BadRequest("Tecido não encontrado.");

        entity.FornecedorId = input.FornecedorId;
        entity.CategoriaId = input.CategoriaId;
        entity.TecidoId = input.TecidoId;

        entity.Descricao = input.Descricao;

        entity.Largura = input.Largura;
        entity.Profundidade = input.Profundidade;
        entity.Altura = input.Altura;
        entity.Pa = input.Pa;

        entity.ValorTecido = input.ValorTecido;

        await _db.SaveChangesAsync(ct);
        return NoContent();
    }

    [HttpDelete("{id:long}")]
    public async Task<IActionResult> Delete(long id, CancellationToken ct)
    {
        var entity = await _db.Modelos.FirstOrDefaultAsync(x => x.Id == id, ct);
        if (entity is null) return NotFound();

        _db.Modelos.Remove(entity);
        await _db.SaveChangesAsync(ct);
        return NoContent();
    }
}
