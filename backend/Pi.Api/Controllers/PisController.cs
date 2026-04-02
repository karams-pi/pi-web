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
    private readonly PiExportService _exportService;

    public PisController(AppDbContext db, CotacaoService cotacaoService, PiExportService exportService)
    {
        _db = db;
        _cotacaoService = cotacaoService;
        _exportService = exportService;
    }

    [HttpGet("{id}/excel")]
    public async Task<IActionResult> ExportExcel(long id, [FromQuery] string currency = "EXW", [FromQuery] int validity = 30, [FromQuery] string lang = "PT")
    {
        try
        {
            var bytes = await _exportService.ExportToExcelAsync(id, currency, validity, lang);
            var pi = await _db.Pis.FindAsync(id);
            string fileName = $"PI_{pi?.Prefixo}-{pi?.PiSequencia}.xlsx";
            return File(bytes, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", fileName);
        }
        catch (Exception ex)
        {
            return BadRequest(ex.Message);
        }
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
                x.IdFornecedor,
                x.ValorTecido,
                x.ValorTotalFreteBRL,
                x.ValorTotalFreteUSD,
                x.CotacaoAtualUSD,
                x.CotacaoRisco,
                x.TempoEntrega,
                x.CondicaoPagamento,
                x.Idioma,
                x.TipoRateio,

                Frete = x.Frete != null ? new { x.Frete.Id, x.Frete.Nome } : null,
                Fornecedor = x.Fornecedor != null ? new { x.Fornecedor.Id, x.Fornecedor.Nome, x.Fornecedor.Cnpj } : null,
                Cliente = x.Cliente != null ? new { x.Cliente.Id, x.Cliente.Nome } : null,
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
                x.IdConfiguracoes,
                x.IdFrete,
                x.ValorTecido,
                x.ValorTotalFreteBRL,
                x.ValorTotalFreteUSD,
                x.CotacaoAtualUSD,
                x.CotacaoRisco,
                x.TempoEntrega,
                x.CondicaoPagamento,
                x.Idioma,
                x.TipoRateio,

                x.IdFornecedor,
                Frete = x.Frete != null ? new { x.Frete.Id, x.Frete.Nome } : null,
                Fornecedor = x.Fornecedor != null ? new { x.Fornecedor.Id, x.Fornecedor.Nome, x.Fornecedor.Cnpj } : null,
                Cliente = x.Cliente != null ? new { x.Cliente.Id, x.Cliente.Nome } : null,
                PiItensPecas = x.PiItensPecas.Select(p => new {
                    p.Id,
                    p.IdPi,
                    p.Descricao,
                    p.Quantidade,
                    PiItens = p.PiItens.Select(i => new {
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
                        i.Observacao,
                        i.Feet,
                        i.Finishing,
                        i.IdPiItemPeca,
                        ModuloTecido = i.ModuloTecido != null ? new {
                            i.ModuloTecido.Id,
                            i.ModuloTecido.CodigoModuloTecido,
                            i.ModuloTecido.ValorTecido,
                            Modulo = i.ModuloTecido.Modulo != null ? new {
                                i.ModuloTecido.Modulo.Id,
                                i.ModuloTecido.Modulo.Descricao,
                                Marca = i.ModuloTecido.Modulo.Marca != null ? new {
                                    i.ModuloTecido.Modulo.Marca.Id,
                                    i.ModuloTecido.Modulo.Marca.Nome,
                                    i.ModuloTecido.Modulo.Marca.Imagem
                                } : null
                            } : null,
                            Tecido = i.ModuloTecido.Tecido != null ? new {
                               i.ModuloTecido.Tecido.Id,
                               i.ModuloTecido.Tecido.Nome
                            } : null
                        } : null
                    })
                }),
                // Keep flat PiItens for backward compatibility or simple access
                PiItens = x.PiItens.Where(i => i.IdPiItemPeca == null).Select(i => new
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
                    i.Observacao,
                    i.Feet,
                    i.Finishing,
                    i.IdPiItemPeca,
                    ModuloTecido = i.ModuloTecido != null ? new {
                        i.ModuloTecido.Id,
                        i.ModuloTecido.CodigoModuloTecido,
                        i.ModuloTecido.ValorTecido,
                        Modulo = i.ModuloTecido.Modulo != null ? new {
                            i.ModuloTecido.Modulo.Id,
                            i.ModuloTecido.Modulo.Descricao,
                            Marca = i.ModuloTecido.Modulo.Marca != null ? new {
                                i.ModuloTecido.Modulo.Marca.Id,
                                i.ModuloTecido.Modulo.Marca.Nome,
                                i.ModuloTecido.Modulo.Marca.Imagem
                            } : null
                        } : null,
                        Tecido = i.ModuloTecido.Tecido != null ? new {
                           i.ModuloTecido.Tecido.Id,
                           i.ModuloTecido.Tecido.Nome
                        } : null
                    } : null
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
        
        // Convert to UTC for PostgreSQL
        pi.DataPi = pi.DataPi.ToUniversalTime();

        _db.Pis.Add(pi);
        
        // Update product codes if provided
        if (pi.PiItens != null)
        {
            foreach (var item in pi.PiItens)
            {
                await UpdateModuleCode(item.IdModuloTecido, item.TempCodigoModuloTecido);
            }
        }

        await _db.SaveChangesAsync();
        
        return CreatedAtAction(nameof(GetById), new { id = pi.Id }, new 
        { 
            pi.Id, 
            pi.Prefixo, 
            pi.PiSequencia,

            pi.IdCliente,
            pi.IdFornecedor,
            pi.TempoEntrega,
            pi.CondicaoPagamento,
            pi.Idioma,
            pi.TipoRateio,
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
                i.Observacao,
                i.Feet,
                i.Finishing
            })
        });
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(long id, ProformaInvoice pi)
    {
        if (id != pi.Id) return BadRequest();
        
        var existingPi = await _db.Pis
            .Include(p => p.PiItensPecas)
                .ThenInclude(p => p.PiItens)
            .Include(p => p.PiItens)
            .FirstOrDefaultAsync(p => p.Id == id);

        if (existingPi == null) return NotFound();

        // Update parent properties
        existingPi.Prefixo = pi.Prefixo;
        existingPi.PiSequencia = pi.PiSequencia;
        existingPi.DataPi = pi.DataPi.ToUniversalTime();
        existingPi.IdCliente = pi.IdCliente;
        existingPi.IdFornecedor = pi.IdFornecedor;
        existingPi.IdConfiguracoes = pi.IdConfiguracoes;
        existingPi.IdFrete = pi.IdFrete;
        existingPi.ValorTecido = pi.ValorTecido;
        existingPi.ValorTotalFreteBRL = pi.ValorTotalFreteBRL;
        existingPi.ValorTotalFreteUSD = pi.ValorTotalFreteUSD;
        existingPi.CotacaoAtualUSD = pi.CotacaoAtualUSD;
        existingPi.CotacaoRisco = pi.CotacaoRisco;
        existingPi.TempoEntrega = pi.TempoEntrega;
        existingPi.CondicaoPagamento = pi.CondicaoPagamento;
        existingPi.Idioma = pi.Idioma;
        existingPi.TipoRateio = pi.TipoRateio;

        // 1. Sync Pieces (metadata only)
        var incomingPieceIds = pi.PiItensPecas.Where(p => p.Id > 0).Select(p => p.Id).ToList();
        var piecesToDelete = existingPi.PiItensPecas.Where(p => !incomingPieceIds.Contains(p.Id)).ToList();
        foreach (var p in piecesToDelete) _db.PiItensPecas.Remove(p);

        foreach (var incomingPiece in pi.PiItensPecas) {
            if (incomingPiece.Id > 0) {
                var existingPiece = existingPi.PiItensPecas.FirstOrDefault(p => p.Id == incomingPiece.Id);
                if (existingPiece != null) {
                    existingPiece.Descricao = incomingPiece.Descricao;
                    existingPiece.Quantidade = incomingPiece.Quantidade;
                }
            } else {
                // IMPORTANT: Create a NEW CLEAN instance to avoid EF walking the JSON graph
                var newPiece = new PiItemPeca {
                    IdPi = id,
                    Descricao = incomingPiece.Descricao,
                    Quantidade = incomingPiece.Quantidade
                };
                existingPi.PiItensPecas.Add(newPiece);
                // Keep the reference for the item mapping in step 3
                incomingPiece.Id = 0; // Ensure it's still 0
                // Use the incomingPiece as a carrier for its items in Step 2, 
                // but it's not being tracked as a piece.
            }
        }

        // 2. Consolidate ALL incoming item data into a flattened list for easier sync
        // We use the 'pi' and 'pi.PiItensPecas' as our "source of truth" to match existing records.
        var flatIncomingItems = new List<(PiItem data, PiItemPeca? parentPiece)>();
        foreach (var p in pi.PiItensPecas) {
            foreach (var item in p.PiItens) flatIncomingItems.Add((item, p));
        }
        foreach (var item in pi.PiItens) flatIncomingItems.Add((item, null));

        // 3. Flat Sync All Items
        var incomingItemIds = flatIncomingItems.Where(x => x.data.Id > 0).Select(x => x.data.Id).ToList();
        var itemsToDelete = existingPi.PiItens.Where(i => !incomingItemIds.Contains(i.Id)).ToList();
        foreach (var i in itemsToDelete) _db.PiItens.Remove(i);

        foreach (var entry in flatIncomingItems) {
            var incomingData = entry.data;
            var incomingParent = entry.parentPiece;

            if (incomingData.Id > 0) {
                var existingItem = existingPi.PiItens.FirstOrDefault(i => i.Id == incomingData.Id);
                if (existingItem != null) {
                    MapItem(existingItem, incomingData);
                    
                    // Update piece association
                    if (incomingParent != null) {
                        var trackedPiece = existingPi.PiItensPecas.FirstOrDefault(p => 
                            (p.Id > 0 && p.Id == incomingParent.Id) || 
                            (p.Id == 0 && p.Descricao == incomingParent.Descricao));
                        existingItem.PiItemPeca = trackedPiece;
                    } else {
                        existingItem.PiItemPeca = null;
                        existingItem.IdPiItemPeca = null;
                    }
                }
            } else {
                // NEW Tracked Item instance
                var newItem = new PiItem { IdPi = id };
                MapItem(newItem, incomingData);
                
                if (incomingParent != null) {
                     var trackedPiece = existingPi.PiItensPecas.FirstOrDefault(p => 
                            (p.Id > 0 && p.Id == incomingParent.Id) || 
                            (p.Id == 0 && p.Descricao == incomingParent.Descricao));
                     newItem.PiItemPeca = trackedPiece;
                }
                existingPi.PiItens.Add(newItem);
            }
            await UpdateModuleCode(incomingData.IdModuloTecido, incomingData.TempCodigoModuloTecido);
        }

        await _db.SaveChangesAsync();
        return Ok(existingPi);
    }

    private void MapItem(PiItem target, PiItem source) {
        target.IdModuloTecido = source.IdModuloTecido;
        target.Quantidade = source.Quantidade;
        target.Largura = source.Largura;
        target.Profundidade = source.Profundidade;
        target.Altura = source.Altura;
        target.Pa = source.Pa;
        target.M3 = source.M3;
        target.ValorEXW = source.ValorEXW;
        target.ValorFreteRateadoBRL = source.ValorFreteRateadoBRL;
        target.ValorFreteRateadoUSD = source.ValorFreteRateadoUSD;
        target.ValorFinalItemBRL = source.ValorFinalItemBRL;
        target.ValorFinalItemUSDRisco = source.ValorFinalItemUSDRisco;
        target.Observacao = source.Observacao;
        target.Feet = source.Feet;
        target.Finishing = source.Finishing;
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
    private async Task UpdateModuleCode(long idModuloTecido, string? codigo)
    {
        if (string.IsNullOrWhiteSpace(codigo)) return;
        
        var moduloTecido = await _db.ModulosTecidos.FirstOrDefaultAsync(x => x.Id == idModuloTecido);
        if (moduloTecido != null)
        {
            moduloTecido.CodigoModuloTecido = codigo.Trim();
            // We don't need to call SaveChanges here if it's called in the parent method, 
            // but for safety in case it's not tracked or we want to be sure:
            // Actually, in Create/Update we call SaveChanges at the end. 
            // Since this context is the same, tracking changes should work.
        }
    }
}
