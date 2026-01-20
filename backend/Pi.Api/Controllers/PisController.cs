using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Contracts;
using Pi.Api.Data;
using Pi.Api.Models;
using PiEntity = global::Pi.Api.Models.PiModel;

namespace Pi.Api.Controllers
{
    [ApiController]
    [Route("api/pis")]
    public class PisController : ControllerBase
    {
        private readonly AppDbContext _db;

        public PisController(AppDbContext db)
        {
            _db = db;
        }

        [HttpPost]
        public async Task<ActionResult<PiCreateResponse>> Create([FromBody] PiCreateRequest req, CancellationToken ct)
        {
            var prefixo = (req.Prefixo ?? "").Trim().ToUpperInvariant();
            if (string.IsNullOrWhiteSpace(prefixo) || prefixo.Length > 7)
                return BadRequest("Prefixo deve ter de 1 a 7 caracteres.");

            var ano = req.DataPi.Year;

            var clienteExists = await _db.Clientes.AnyAsync(x => x.Id == req.ClienteId, ct);
            if (!clienteExists) return BadRequest("ClienteId inválido.");

            await using var tx = await _db.Database.BeginTransactionAsync(ct);

            PiSequencia? seq = await _db.PiSequencias
                .FromSqlInterpolated($@"
                    SELECT * FROM pi_sequencia
                    WHERE prefixo = {prefixo} AND ano = {ano}
                    FOR UPDATE")
                .SingleOrDefaultAsync(ct);

            if (seq is null)
            {
                seq = new PiSequencia { Prefixo = prefixo, Ano = ano, UltimoNumero = 0 };
                _db.PiSequencias.Add(seq);
                await _db.SaveChangesAsync(ct);

                seq = await _db.PiSequencias
                    .FromSqlInterpolated($@"
                        SELECT * FROM pi_sequencia
                        WHERE prefixo = {prefixo} AND ano = {ano}
                        FOR UPDATE")
                    .SingleAsync(ct);
            }

            seq.UltimoNumero += 1;
            await _db.SaveChangesAsync(ct);

            var numero = $"{prefixo}{seq.UltimoNumero:00000}-{ano}";

            var pi = new PiEntity
            {
                Id = Guid.NewGuid(),
                Prefixo = prefixo,
                Numero = numero,
                DataPi = req.DataPi,
                ClienteId = req.ClienteId,
                TipoPreco = req.TipoPreco,
                UsdRate = req.UsdRate,
                UsdRateFonte = req.UsdRateFonte,
                UsdRateAtualizadoEm = req.UsdRate is null ? null : DateTimeOffset.UtcNow,
                Status = "ABERTA",
                CriadoEm = DateTimeOffset.UtcNow,
                AtualizadoEm = DateTimeOffset.UtcNow
            };


            _db.Pis.Add(pi);
            await _db.SaveChangesAsync(ct);

            await tx.CommitAsync(ct);

            return Ok(new PiCreateResponse { Id = pi.Id, Numero = pi.Numero });
        }

        [HttpGet("{id:guid}")]
        public async Task<IActionResult> Get(Guid id, CancellationToken ct)
        {
            var pi = await _db.Pis
                .Include(x => x.Cliente)
                .FirstOrDefaultAsync(x => x.Id == id, ct);

            return pi is null ? NotFound() : Ok(pi);
        }
    }
}
