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
}
