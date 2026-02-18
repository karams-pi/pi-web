using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/clientes")]
public class ClientesController : ControllerBase
{
    private readonly AppDbContext _db;

    public ClientesController(AppDbContext db)
    {
        _db = db;
    }

    public record PagedResult<T>(IReadOnlyList<T> Items, int Total, int Page, int PageSize);

    [HttpGet]
    public async Task<ActionResult<PagedResult<Cliente>>> List(
        [FromQuery] string? search,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 10,
        CancellationToken ct = default)
    {
        page = Math.Max(1, page);
        pageSize = Math.Clamp(pageSize, 1, 100);

        var q = _db.Clientes.AsNoTracking().AsQueryable();

        if (!string.IsNullOrWhiteSpace(search))
        {
            var s = search.Trim().ToLower();
            q = q.Where(x =>
                x.Nome.ToLower().Contains(s) ||
                (x.Empresa ?? "").ToLower().Contains(s) ||
                (x.Nit ?? "").ToLower().Contains(s) ||
                (x.Email ?? "").ToLower().Contains(s));
        }

        var total = await q.CountAsync(ct);

        var items = await q.OrderBy(x => x.Nome)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync(ct);

        return Ok(new PagedResult<Cliente>(items, total, page, pageSize));
    }

    [HttpGet("{id:guid}")]
    public async Task<ActionResult<Cliente>> Get(Guid id, CancellationToken ct)
    {
        var c = await _db.Clientes.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id, ct);
        return c is null ? NotFound() : Ok(c);
    }

    [HttpPost]
    public async Task<ActionResult<Cliente>> Create([FromBody] Cliente input, CancellationToken ct)
    {
        input.Id = Guid.NewGuid();
        input.CriadoEm = DateTimeOffset.UtcNow;
        input.AtualizadoEm = DateTimeOffset.UtcNow;

        _db.Clientes.Add(input);
        await _db.SaveChangesAsync(ct);

        return CreatedAtAction(nameof(Get), new { id = input.Id }, input);
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> Update(Guid id, [FromBody] Cliente input, CancellationToken ct)
    {
        var c = await _db.Clientes.FirstOrDefaultAsync(x => x.Id == id, ct);
        if (c is null) return NotFound();

        c.Nome = input.Nome;
        c.Nome = input.Nome;
        c.Empresa = input.Empresa;
        c.Nit = input.Nit;
        c.Email = input.Email;
        c.Telefone = input.Telefone;
        c.Ativo = input.Ativo;
        c.Pais = input.Pais;
        c.Cidade = input.Cidade;
        c.Endereco = input.Endereco;
        c.Cep = input.Cep;
        c.PessoaContato = input.PessoaContato;
        c.CargoFuncao = input.CargoFuncao;
        c.Observacoes = input.Observacoes;
        c.AtualizadoEm = DateTimeOffset.UtcNow;

        await _db.SaveChangesAsync(ct);
        return NoContent();
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> Delete(Guid id, CancellationToken ct)
    {
        var c = await _db.Clientes.FirstOrDefaultAsync(x => x.Id == id, ct);
        if (c is null) return NotFound();

        _db.Clientes.Remove(c);
        await _db.SaveChangesAsync(ct);

        return NoContent();
    }
}
