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
                    i.ValorFinalItemUSDRisco,
                    i.Observacao
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
    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
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
                i.ValorFinalItemUSDRisco,
                i.Observacao
            })
        });
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(long id, ProformaInvoice pi)
    {
        if (id != pi.Id) return BadRequest();
        
        var existingPi = await _db.Pis
            .Include(p => p.PiItens)
            .FirstOrDefaultAsync(p => p.Id == id);

        if (existingPi == null) return NotFound();

        // Update parent properties
        existingPi.Prefixo = pi.Prefixo;
        existingPi.PiSequencia = pi.PiSequencia;
        existingPi.DataPi = pi.DataPi;
        existingPi.IdCliente = pi.IdCliente;
        existingPi.IdConfiguracoes = pi.IdConfiguracoes;
        existingPi.IdFrete = pi.IdFrete;
        existingPi.ValorTecido = pi.ValorTecido;
        existingPi.ValorTotalFreteBRL = pi.ValorTotalFreteBRL;
        existingPi.ValorTotalFreteUSD = pi.ValorTotalFreteUSD;
        existingPi.CotacaoAtualUSD = pi.CotacaoAtualUSD;
        existingPi.CotacaoRisco = pi.CotacaoRisco;

        // Handle Items
        // 1. Identification
        var incomingItemIds = pi.PiItens.Where(i => i.Id > 0).Select(i => i.Id).ToList();
        
        // 2. Deletions (items in DB but not in payload)
        var itemsToDelete = existingPi.PiItens.Where(i => !incomingItemIds.Contains(i.Id)).ToList();
        foreach (var item in itemsToDelete)
        {
            _db.PiItens.Remove(item);
        }

        // 3. Updates and Adds
        foreach (var item in pi.PiItens)
        {
            if (item.Id > 0)
            {
                // Update
                var existingItem = existingPi.PiItens.FirstOrDefault(i => i.Id == item.Id);
                if (existingItem != null)
                {
                   existingItem.IdModuloTecido = item.IdModuloTecido;
                   existingItem.Quantidade = item.Quantidade;
                   existingItem.Largura = item.Largura;
                   existingItem.Profundidade = item.Profundidade;
                   existingItem.Altura = item.Altura;
                   existingItem.Pa = item.Pa;
                   existingItem.M3 = item.M3;
                   existingItem.ValorEXW = item.ValorEXW;
                   existingItem.ValorFreteRateadoBRL = item.ValorFreteRateadoBRL;
                   existingItem.ValorFreteRateadoUSD = item.ValorFreteRateadoUSD;
                   existingItem.ValorFinalItemBRL = item.ValorFinalItemBRL;
                   existingItem.ValorFinalItemUSDRisco = item.ValorFinalItemUSDRisco;
                   existingItem.Observacao = item.Observacao;
                }
            }
            else
            {
                // Add (by adding to the collection)
                existingPi.PiItens.Add(item);
            }
        }

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
