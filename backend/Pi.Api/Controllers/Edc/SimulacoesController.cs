
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models.Edc;
using Pi.Api.Services;

namespace Pi.Api.Controllers.Edc;

[ApiController]
[Route("api/edc/[controller]")]
public class SimulacoesController : ControllerBase
{
    private readonly AppDbContext _context;
    private readonly IEdcCalculationService _calculationService;

    public SimulacoesController(AppDbContext context, IEdcCalculationService calculationService)
    {
        _context = context;
        _calculationService = calculationService;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<SimulacaoEdc>>> GetSimulacoes()
    {
        return await _context.SimulacoesEdc
            .Include(s => s.Importador)
            .Include(s => s.Exportador)
            .OrderByDescending(s => s.DataEstudo)
            .ToListAsync();
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<SimulacaoEdc>> GetSimulacao(int id)
    {
        var simulacao = await _context.SimulacoesEdc
            .Include(s => s.Importador!)
            .Include(s => s.Exportador!)
            .Include(s => s.PortoOrigem!)
            .Include(s => s.PortoDestino!)
            .Include(s => s.Itens!)
                .ThenInclude(i => i.Produto!)
                    .ThenInclude(p => p.Ncm!)
            .Include(s => s.Despesas!)
            .FirstOrDefaultAsync(s => s.Id == id);

        if (simulacao == null) return NotFound();

        return simulacao;
    }

    [HttpPost("preview")]
    public ActionResult<SimulacaoEdc> Preview(SimulacaoEdc simulacao)
    {
        // Precisamos carregar os NCMs dos produtos para o cálculo
        foreach (var item in simulacao.Itens)
        {
            if (item.IdProduto > 0)
            {
                var produto = _context.ProdutosEdc.Include(p => p.Ncm).FirstOrDefault(p => p.Id == item.IdProduto);
                if (produto != null) item.Produto = produto;
            }
        }

        _calculationService.ProcessarNacionalizacaoCompleta(simulacao);
        return Ok(simulacao);
    }

    [HttpPost]
    public async Task<ActionResult<SimulacaoEdc>> PostSimulacao(SimulacaoEdc simulacao)
    {
        _context.SimulacoesEdc.Add(simulacao);
        await _context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetSimulacao), new { id = simulacao.Id }, simulacao);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> PutSimulacao(int id, SimulacaoEdc simulacao)
    {
        if (id != simulacao.Id)
        {
            return BadRequest();
        }

        var dbSimulacao = await _context.SimulacoesEdc
            .Include(s => s.Itens)
            .Include(s => s.Despesas)
            .FirstOrDefaultAsync(s => s.Id == id);

        if (dbSimulacao == null)
        {
            return NotFound();
        }

        // Atualiza campos do cabeçalho
        dbSimulacao.NumeroReferencia = simulacao.NumeroReferencia;
        dbSimulacao.DataEstudo = simulacao.DataEstudo;
        dbSimulacao.IdImportador = simulacao.IdImportador;
        dbSimulacao.IdExportador = simulacao.IdExportador;
        dbSimulacao.IdPortoOrigem = simulacao.IdPortoOrigem;
        dbSimulacao.IdPortoDestino = simulacao.IdPortoDestino;
        dbSimulacao.CotacaoDolar = simulacao.CotacaoDolar;
        dbSimulacao.SpreadCambio = simulacao.SpreadCambio;
        dbSimulacao.TipoFrete = simulacao.TipoFrete;
        dbSimulacao.ValorFreteInternacional = simulacao.ValorFreteInternacional;
        dbSimulacao.ValorSeguroInternacional = simulacao.ValorSeguroInternacional;
        dbSimulacao.Status = simulacao.Status;

        // Atualiza itens (remova antigos, adicione novos)
        if (dbSimulacao.Itens != null)
        {
            _context.RemoveRange(dbSimulacao.Itens);
        }
        dbSimulacao.Itens = simulacao.Itens?.Select(i => new SimulacaoEdcItem
        {
            IdProduto = i.IdProduto,
            Quantidade = i.Quantidade,
            ValorFobUnitario = i.ValorFobUnitario,
            PesoLiquidoTotal = i.PesoLiquidoTotal,
            PesoBrutoTotal = i.PesoBrutoTotal,
            CubagemTotal = i.CubagemTotal
        }).ToList() ?? new List<SimulacaoEdcItem>();

        // Atualiza despesas (remova antigas, adicione novas)
        if (dbSimulacao.Despesas != null)
        {
            _context.RemoveRange(dbSimulacao.Despesas);
        }
        dbSimulacao.Despesas = simulacao.Despesas?.Select(d => new SimulacaoEdcDespesa
        {
            NomeDespesa = d.NomeDespesa,
            Valor = d.Valor,
            Moeda = d.Moeda,
            MetodoRateio = d.MetodoRateio
        }).ToList() ?? new List<SimulacaoEdcDespesa>();

        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (!_context.SimulacoesEdc.Any(s => s.Id == id))
            {
                return NotFound();
            }
            else
            {
                throw;
            }
        }

        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteSimulacao(int id)
    {
        var simulacao = await _context.SimulacoesEdc.FindAsync(id);
        if (simulacao == null) return NotFound();

        _context.SimulacoesEdc.Remove(simulacao);
        await _context.SaveChangesAsync();

        return NoContent();
    }
}
