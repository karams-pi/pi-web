using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Pi.Api.Data;
using System.Reflection;

namespace Pi.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class VersionController : ControllerBase
{
    private readonly AppDbContext _context;
    private readonly IWebHostEnvironment _env;

    public VersionController(AppDbContext context, IWebHostEnvironment env)
    {
        _context = context;
        _env = env;
    }

    [HttpGet]
    public async Task<IActionResult> GetVersion()
    {
        // App version from assembly
        var assembly = Assembly.GetExecutingAssembly();
        var appVersion = assembly.GetCustomAttribute<AssemblyInformationalVersionAttribute>()?.InformationalVersion
                         ?? assembly.GetName().Version?.ToString()
                         ?? "N/A";

        // DB: Last applied migration
        string lastMigration = "N/A";
        int totalApplied = 0;
        int totalPending = 0;
        try
        {
            var applied = (await _context.Database.GetAppliedMigrationsAsync()).ToList();
            totalApplied = applied.Count;
            lastMigration = applied.LastOrDefault() ?? "Nenhuma";

            var allMigrations = _context.Database.GetMigrations().ToList();
            totalPending = allMigrations.Count - totalApplied;
        }
        catch (Exception ex)
        {
            lastMigration = $"Erro: {ex.Message}";
        }

        // DB provider
        string dbProvider = "N/A";
        try
        {
            dbProvider = _context.Database.ProviderName ?? "N/A";
        }
        catch { /* ignore */ }

        // Version history from DB
        var versionHistory = await _context.VersoesDoSistema
            .OrderByDescending(v => v.Data)
            .Select(v => new { v.Versao, v.Data })
            .ToListAsync();

        return Ok(new
        {
            app = new
            {
                version = appVersion,
                environment = _env.EnvironmentName,
                framework = System.Runtime.InteropServices.RuntimeInformation.FrameworkDescription,
                startedAt = System.Diagnostics.Process.GetCurrentProcess().StartTime.ToUniversalTime().ToString("o")
            },
            database = new
            {
                provider = dbProvider,
                lastMigration,
                totalApplied,
                totalPending
            },
            history = versionHistory
        });
    }
}
