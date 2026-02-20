using Microsoft.AspNetCore.Mvc;
using Pi.Api.Data;
using Pi.Api.Services;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[RequestSizeLimit(104857600)] // 100 MB
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
    public async Task<IActionResult> ImportarTabelaPrecos(IFormFile file, [FromForm] long idFornecedor, [FromForm] DateTime? dtRevisao)
    {
        if (file == null || file.Length == 0)
            return BadRequest("Arquivo inválido.");
        
        if (idFornecedor <= 0)
            return BadRequest("Fornecedor inválido.");

        using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            using var stream = file.OpenReadStream();
            await _importService.ImportarTabelaPrecosAsync(stream, idFornecedor, dtRevisao);
            
            await transaction.CommitAsync();
            return Ok(new { message = "Importação concluída com sucesso!" });
        }
        catch (Exception ex)
        {
            await transaction.RollbackAsync();
            return StatusCode(500, new { message = $"Erro na importação: {ex.Message}" });
        }
    }
    [HttpPost("karams")]
    public async Task<IActionResult> ImportarKarams(IFormFile file, [FromForm] long idFornecedor, [FromForm] DateTime? dtRevisao)
    {
        if (file == null || file.Length == 0)
            return BadRequest("Arquivo inválido.");

        if (idFornecedor <= 0)
            return BadRequest("Fornecedor inválido.");

        // Increased timeout for large imports if necessary, but default valid for now.
        // We use explicit transaction for consistency.
        using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            using var stream = file.OpenReadStream();
            await _importService.ImportarKaramsAsync(stream, idFornecedor, dtRevisao);

            await transaction.CommitAsync();
            return Ok(new { message = "Importação Karams concluída com sucesso!" });
        }
        catch (Exception ex)
        {
            await transaction.RollbackAsync();
            
            // Recursively get all messages
            var sb = new System.Text.StringBuilder();
            var current = ex;
            while (current != null)
            {
                sb.Append(current.Message + " | ");
                current = current.InnerException;
            }

            return StatusCode(500, new { message = $"Erro na importação Karams: {sb}" });
        }
    }
    [HttpPost("koyo")]
    public async Task<IActionResult> ImportarKoyo(IFormFile file, [FromForm] long idFornecedor, [FromForm] DateTime? dtRevisao)
    {
        if (file == null || file.Length == 0)
            return BadRequest("Arquivo inválido.");
        if (idFornecedor <= 0)
            return BadRequest("Fornecedor inválido.");

        using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            using var stream = file.OpenReadStream();
            await _importService.ImportarKoyoAsync(stream, idFornecedor, dtRevisao);

            await transaction.CommitAsync();
            return Ok(new { message = "Importação Koyo concluída com sucesso!" });
        }
        catch (Exception ex)
        {
            await transaction.RollbackAsync();
             var sb = new System.Text.StringBuilder();
            var current = ex;
            while (current != null)
            {
                sb.Append(current.Message + " | ");
                current = current.InnerException;
            }
            return StatusCode(500, new { message = $"Erro na importação Koyo: {sb}" });
        }
    }

    [HttpPost("ferguile")]
    public async Task<IActionResult> ImportarFerguile(IFormFile file, [FromForm] long idFornecedor, [FromForm] DateTime? dtRevisao)
    {
        if (file == null || file.Length == 0)
            return BadRequest("Arquivo inválido.");
        if (idFornecedor <= 0)
            return BadRequest("Fornecedor inválido.");

        using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            using var stream = file.OpenReadStream();
            await _importService.ImportarFerguileAsync(stream, idFornecedor, dtRevisao);

            await transaction.CommitAsync();
            return Ok(new { message = "Importação Ferguile concluída com sucesso!" });
        }
        catch (Exception ex)
        {
            await transaction.RollbackAsync();
            var sb = new System.Text.StringBuilder();
            var current = ex;
            while (current != null)
            {
                sb.Append(current.Message + " | ");
                current = current.InnerException;
            }
            return StatusCode(500, new { message = $"Erro na importação Ferguile: {sb}" });
        }
    }

    [HttpPost("livintus")]
    public async Task<IActionResult> ImportarLivintus(IFormFile file, [FromForm] long idFornecedor, [FromForm] DateTime? dtRevisao)
    {
        if (file == null || file.Length == 0)
            return BadRequest("Arquivo inválido.");
        if (idFornecedor <= 0)
            return BadRequest("Fornecedor inválido.");

        using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            using var stream = file.OpenReadStream();
            await _importService.ImportarLivintusAsync(stream, idFornecedor, dtRevisao);

            await transaction.CommitAsync();
            return Ok(new { message = "Importação Livintus concluída com sucesso!" });
        }
        catch (Exception ex)
        {
            await transaction.RollbackAsync();
            var sb = new System.Text.StringBuilder();
            var current = ex;
            while (current != null)
            {
                sb.Append(current.Message + " | ");
                current = current.InnerException;
            }
            return StatusCode(500, new { message = $"Erro na importação Livintus: {sb}" });
        }
    [HttpPost("reset-sequences")]
    public async Task<IActionResult> ResetSequences()
    {
        try
        {
            await _importService.ResetSequencesAsync();
            return Ok(new { message = "Sequências do banco de dados sincronizadas com sucesso!" });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = $"Erro ao sincronizar sequências: {ex.Message}" });
        }
    }
}
