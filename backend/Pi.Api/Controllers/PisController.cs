using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models;
using Pi.Api.Services;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/pis")]
public class PisController : ControllerBase
{
    private readonly AppDbContext _db;
    private readonly CotacaoService _cotacaoService;

    public PisController(AppDbContext db, CotacaoService cotacaoService)
    {
        _db = db;
        _cotacaoService = cotacaoService;
    }

    [HttpGet]
    public async Task<ActionResult<List<object>>> GetAll()
    {
        return await _db.Pis
            .AsNoTracking()
            .Select(x => new
            {
                x.Id,
                x.Prefixo,
                x.PiSequencia,
                x.DataPi,
                x.IdCliente,
                x.IdFrete,
                x.ValorTecido,
                x.ValorTotalFreteBRL,
                x.ValorTotalFreteUSD,
                x.CotacaoAtualUSD,
                x.CotacaoRisco,
                Cliente = x.Cliente != null ? new { x.Cliente.Id, x.Cliente.Nome } : null,
                Frete = x.Frete != null ? new { x.Frete.Id, x.Frete.Nome } : null
            })
            .OrderByDescending(x => x.Id)
            .ToListAsync<object>();
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<object>> GetById(long id)
    {
        var pi = await _db.Pis
            .AsNoTracking()
            .Where(x => x.Id == id)
            .Select(x => new
            {
                x.Id,
                x.Prefixo,
                x.PiSequencia,
                x.DataPi,
                x.IdCliente,
                x.IdFrete,
                x.ValorTecido,
                x.ValorTotalFreteBRL,
                x.ValorTotalFreteUSD,
                x.CotacaoAtualUSD,
                x.CotacaoRisco,
                Cliente = x.Cliente != null ? new { x.Cliente.Id, x.Cliente.Nome } : null,
                Frete = x.Frete != null ? new { x.Frete.Id, x.Frete.Nome } : null,
                PiItens = x.PiItens.Select(i => new
                {
                    i.Id,
                    i.IdModuloTecido,
                    i.Quantidade,
                    i.Largura,
                    i.Profundidade,
                    i.Altura,
                    i.Pa,
                    i.M3,
                    i.ValorEXW,
                    i.ValorFreteRateadoBRL,
                    i.ValorFreteRateadoUSD,
                    i.ValorFinalItemBRL,
                    i.ValorFinalItemUSDRisco
                })
            })
            .FirstOrDefaultAsync();
            
        if (pi == null) return NotFound();
        return pi;
    }

    [HttpGet("proxima-sequencia")]
    public async Task<ActionResult<object>> GetProximaSequencia()
    {
        string sequencia = await GenerateNextSequenceString();
        return Ok(new { sequencia });
    }

    private async Task<string> GenerateNextSequenceString()
    {
        var ultimaPi = await _db.Pis
            .OrderByDescending(x => x.Id)
            .FirstOrDefaultAsync();

        if (ultimaPi != null && int.TryParse(ultimaPi.PiSequencia, out int numero))
        {
            return (numero + 1).ToString("00000");
        }

        return "00001";
    }

    [HttpGet("cotacao-usd")]
    public async Task<ActionResult<object>> GetCotacaoUSD()
    {
        var cotacao = await _cotacaoService.GetCotacaoUSD();
        return Ok(new { valor = cotacao });
    }

    [HttpPost]
    public async Task<ActionResult<object>> Create(ProformaInvoice pi)
    {
        // Sempre gera a próxima sequência para garantir integridade em concorrência
        pi.PiSequencia = await GenerateNextSequenceString();

        _db.Pis.Add(pi);
        await _db.SaveChangesAsync();
        
        return CreatedAtAction(nameof(GetById), new { id = pi.Id }, new 
        { 
            pi.Id, 
            pi.Prefixo, 
            pi.PiSequencia,
            pi.IdCliente,
            PiItens = pi.PiItens?.Select(i => new
            {
                i.Id,
                i.IdModuloTecido,
                i.Quantidade,
                i.Largura,
                i.Profundidade,
                i.Altura,
                i.Pa,
                i.M3,
                i.ValorEXW,
                i.ValorFreteRateadoBRL,
                i.ValorFreteRateadoUSD,
                i.ValorFinalItemBRL,
                i.ValorFinalItemUSDRisco
            })
        });
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(long id, ProformaInvoice pi)
    {
        if (id != pi.Id) return BadRequest();
        
        _db.Entry(pi).State = EntityState.Modified;
        await _db.SaveChangesAsync();
        
        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(long id)
    {
        var pi = await _db.Pis.FindAsync(id);
        if (pi == null) return NotFound();
        
        _db.Pis.Remove(pi);
        await _db.SaveChangesAsync();
        
        return NoContent();
    }
}
