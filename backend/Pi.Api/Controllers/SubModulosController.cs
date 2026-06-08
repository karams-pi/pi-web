using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/pi/[controller]")]
public class SubModulosController : ControllerBase
{
    private readonly AppDbContext _db;

    public SubModulosController(AppDbContext db)
    {
        _db = db;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<object>>> GetAll([FromQuery] long? idModulo)
    {
        var query = _db.SubModulos
            .Where(x => x.FlAtivo);

        if (idModulo.HasValue)
        {
            query = query.Where(x => x.IdModulo == idModulo.Value);
        }

        var list = await query
            .AsNoTracking()
            .Select(x => new
            {
                x.Id,
                x.IdModulo,
                x.IdTecidoBase,
                x.Codigo,
                x.DescricaoProduto,
                x.TecidoEspecifico,
                x.VolumeM3,
                TecidoBase = x.TecidoBase != null ? new { x.TecidoBase.Id, x.TecidoBase.Nome } : null
            })
            .OrderBy(x => x.TecidoEspecifico)
            .ToListAsync();

        return Ok(list);
    }

    [HttpGet("modulos")]
    public async Task<ActionResult<IEnumerable<object>>> GetByModulos([FromQuery] string ids)
    {
        if (string.IsNullOrWhiteSpace(ids))
            return Ok(new List<object>());

        var idList = ids.Split(',')
            .Select(x => long.TryParse(x, out var id) ? id : (long?)null)
            .Where(x => x.HasValue)
            .Select(x => x!.Value)
            .ToList();

        var list = await _db.SubModulos
            .Where(x => x.FlAtivo && idList.Contains(x.IdModulo))
            .AsNoTracking()
            .Select(x => new
            {
                x.Id,
                x.IdModulo,
                x.IdTecidoBase,
                x.Codigo,
                x.DescricaoProduto,
                x.TecidoEspecifico,
                x.VolumeM3,
                TecidoBase = x.TecidoBase != null ? new { x.TecidoBase.Id, x.TecidoBase.Nome } : null
            })
            .OrderBy(x => x.TecidoEspecifico)
            .ToListAsync();

        return Ok(list);
    }

    [HttpGet("modulo/{idModulo:long}")]
    public async Task<ActionResult<IEnumerable<object>>> GetByModulo(long idModulo)
    {
        var list = await _db.SubModulos
            .Where(x => x.FlAtivo && x.IdModulo == idModulo)
            .AsNoTracking()
            .Select(x => new
            {
                x.Id,
                x.IdModulo,
                x.IdTecidoBase,
                x.Codigo,
                x.DescricaoProduto,
                x.TecidoEspecifico,
                x.VolumeM3,
                TecidoBase = x.TecidoBase != null ? new { x.TecidoBase.Id, x.TecidoBase.Nome } : null
            })
            .OrderBy(x => x.TecidoEspecifico)
            .ToListAsync();

        return Ok(list);
    }

    [HttpGet("buscar")]
    public async Task<ActionResult<object>> Buscar([FromQuery] long idModulo, [FromQuery] string tecidoEspecifico)
    {
        if (string.IsNullOrWhiteSpace(tecidoEspecifico))
            return BadRequest("O tecido específico deve ser fornecido.");

        var item = await _db.SubModulos
            .Where(x => x.FlAtivo && x.IdModulo == idModulo && x.TecidoEspecifico.ToUpper() == tecidoEspecifico.ToUpper().Trim())
            .AsNoTracking()
            .Select(x => new
            {
                x.Id,
                x.IdModulo,
                x.IdTecidoBase,
                x.Codigo,
                x.DescricaoProduto,
                x.TecidoEspecifico,
                x.VolumeM3,
                TecidoBase = x.TecidoBase != null ? new { x.TecidoBase.Id, x.TecidoBase.Nome } : null
            })
            .FirstOrDefaultAsync();

        if (item == null)
            return NotFound("SubMódulo não encontrado.");

        return Ok(item);
    }

    [HttpGet("{id:long}")]
    public async Task<ActionResult<SubModulo>> GetById(long id)
    {
        var item = await _db.SubModulos
            .AsNoTracking()
            .FirstOrDefaultAsync(x => x.Id == id);

        if (item == null)
            return NotFound();

        return Ok(item);
    }

    [HttpPost]
    public async Task<ActionResult<SubModulo>> Create([FromBody] SubModulo item)
    {
        if (item == null)
            return BadRequest("Dados inválidos.");

        // Limpa referências de navegação para evitar problemas no EF Core
        item.Modulo = null;
        item.TecidoBase = null;

        _db.SubModulos.Add(item);
        await _db.SaveChangesAsync();

        return CreatedAtAction(nameof(GetById), new { id = item.Id }, item);
    }

    [HttpPut("{id:long}")]
    public async Task<IActionResult> Update(long id, [FromBody] SubModulo item)
    {
        if (item == null || item.Id != id)
            return BadRequest("Dados inconsistentes.");

        var existing = await _db.SubModulos.FirstOrDefaultAsync(x => x.Id == id);
        if (existing == null)
            return NotFound("SubMódulo não encontrado.");

        existing.IdModulo = item.IdModulo;
        existing.IdTecidoBase = item.IdTecidoBase;
        existing.Codigo = item.Codigo;
        existing.DescricaoProduto = item.DescricaoProduto;
        existing.TecidoEspecifico = item.TecidoEspecifico;
        existing.VolumeM3 = item.VolumeM3;
        existing.FlAtivo = item.FlAtivo;

        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:long}")]
    public async Task<IActionResult> Delete(long id)
    {
        var existing = await _db.SubModulos.FirstOrDefaultAsync(x => x.Id == id);
        if (existing == null)
            return NotFound("SubMódulo não encontrado.");

        _db.SubModulos.Remove(existing);
        await _db.SaveChangesAsync();

        return NoContent();
    }
}
