
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

    [HttpPost]
    public async Task<ActionResult<ProdutoEdc>> PostProduto(ProdutoEdc produto)
    {
        _context.ProdutosEdc.Add(produto);
        await _context.SaveChangesAsync();
        return CreatedAtAction(nameof(GetProdutos), new { id = produto.Id }, produto);
    }
}
