using Microsoft.AspNetCore.Mvc;
using Pi.Api.Data;
using Pi.Api.Services;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ImportController : ControllerBase
{
    private readonly ExcelImportService _importService;
    private readonly AppDbContext _context;

    public ImportController(ExcelImportService importService, AppDbContext context)
    {
        _importService = importService;
        _context = context;
    }

    [HttpPost("tabela-precos")]
    public async Task<IActionResult> ImportarTabelaPrecos(IFormFile file, [FromForm] long idFornecedor)
    {
        if (file == null || file.Length == 0)
            return BadRequest("Arquivo inválido.");
        
        if (idFornecedor <= 0)
            return BadRequest("Fornecedor inválido.");

        using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            using var stream = file.OpenReadStream();
            await _importService.ImportarTabelaPrecosAsync(stream, idFornecedor);
            
            await transaction.CommitAsync();
            return Ok(new { message = "Importação concluída com sucesso!" });
        }
        catch (Exception ex)
        {
            await transaction.RollbackAsync();
            return StatusCode(500, new { message = $"Erro na importação: {ex.Message}" });
        }
    }
}
