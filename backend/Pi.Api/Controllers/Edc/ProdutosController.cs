
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models.Edc;

namespace Pi.Api.Controllers.Edc;

[ApiController]
[Route("api/edc/[controller]")]
public class ProdutosController : ControllerBase
{
    private readonly AppDbContext _context;

    public ProdutosController(AppDbContext context) => _context = context;

    [HttpGet]
    public async Task<ActionResult<IEnumerable<ProdutoEdc>>> GetProdutos() 
        => await _context.ProdutosEdc
            .Include(p => p.Ncm)
            .Where(p => p.FlAtivo)
            .OrderBy(p => p.Referencia)
            .ToListAsync();

    [HttpGet("{id}")]
    public async Task<ActionResult<ProdutoEdc>> GetProduto(int id)
    {
        var produto = await _context.ProdutosEdc
            .Include(p => p.Ncm)
            .FirstOrDefaultAsync(p => p.Id == id);
        if (produto == null)
        {
            return NotFound();
        }
        return produto;
    }

    [HttpPost]
    public async Task<ActionResult<ProdutoEdc>> PostProduto(ProdutoEdc produto)
    {
        _context.ProdutosEdc.Add(produto);
        await _context.SaveChangesAsync();

        // Auto-gera o modelo padrão repetindo a referência e a descrição do produto
        var modeloPadrao = new ModeloEdc
        {
            IdProduto = produto.Id,
            Codigo = produto.Referencia,
            Nome = produto.Referencia,
            Descricao = $"Modelo Padrão - {produto.Descricao}",
            FlAtivo = true
        };
        _context.ModelosEdc.Add(modeloPadrao);
        await _context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetProduto), new { id = produto.Id }, produto);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> PutProduto(int id, ProdutoEdc produto)
    {
        if (id != produto.Id)
        {
            return BadRequest();
        }

        _context.Entry(produto).State = EntityState.Modified;

        try
        {
            // Garantir que exista pelo menos um modelo padrão para o produto
            var temModelo = await _context.ModelosEdc.AnyAsync(m => m.IdProduto == id && m.FlAtivo);
            if (!temModelo)
            {
                var modeloPadrao = new ModeloEdc
                {
                    IdProduto = produto.Id,
                    Codigo = string.IsNullOrWhiteSpace(produto.Referencia) ? $"PROD-{produto.Id}" : produto.Referencia,
                    Nome = string.IsNullOrWhiteSpace(produto.Referencia) ? produto.Descricao : produto.Referencia,
                    Descricao = $"Modelo Padrão - {produto.Descricao}",
                    FlAtivo = true
                };
                _context.ModelosEdc.Add(modeloPadrao);
            }

            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (!_context.ProdutosEdc.Any(p => p.Id == id))
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
    public async Task<IActionResult> DeleteProduto(int id)
    {
        var produto = await _context.ProdutosEdc.FindAsync(id);
        if (produto == null)
        {
            return NotFound();
        }

        // Soft delete produto e modelos associados
        produto.FlAtivo = false;
        var modelos = await _context.ModelosEdc.Where(m => m.IdProduto == id).ToListAsync();
        foreach (var m in modelos)
        {
            m.FlAtivo = false;
        }

        await _context.SaveChangesAsync();

        return NoContent();
    }
}
