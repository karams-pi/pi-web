using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;

using OfficeOpenXml;

// Configurar licença do EPPlus (v8+)
ExcelPackage.License.SetNonCommercialPersonal("PI Web User");

var builder = WebApplication.CreateBuilder(args);

// Aumentar limite de upload para importações grandes (default 30MB)
builder.WebHost.ConfigureKestrel(options =>
{
    options.Limits.MaxRequestBodySize = 104857600; // 100 MB
});

builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.ReferenceHandler = System.Text.Json.Serialization.ReferenceHandler.IgnoreCycles;
    });

builder.Services.AddDbContext<AppDbContext>(options =>
{
    var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

    // Fix para Render/Railwa (URLs tipo postgres://user:pass@host:port/db)
    if (!string.IsNullOrEmpty(connectionString) && (connectionString.StartsWith("postgres://") || connectionString.StartsWith("postgresql://")))
    {
        var uri = new Uri(connectionString);
        var userInfo = uri.UserInfo.Split(':');
        var username = userInfo[0];
        var password = userInfo.Length > 1 ? userInfo[1] : "";
        var port = uri.Port > 0 ? uri.Port : 5432;

        connectionString = $"Host={uri.Host};Port={port};Database={uri.AbsolutePath.TrimStart('/')};Username={username};Password={password}";
    }

    options.UseNpgsql(connectionString);
});

// Registrar HttpClient e CotacaoService
// Registrar HttpClient e CotacaoService
builder.Services.AddHttpClient<Pi.Api.Services.CotacaoService>()
    .ConfigurePrimaryHttpMessageHandler(() => new HttpClientHandler
    {
        UseProxy = false
    });
builder.Services.AddScoped<Pi.Api.Services.ICalculoService, Pi.Api.Services.CalculoService>();
builder.Services.AddScoped<Pi.Api.Services.ExcelImportService>();
builder.Services.AddScoped<Pi.Api.Services.PiExportService>();
builder.Services.AddScoped<Pi.Api.Services.ModuloExportService>();

builder.Services.AddCors(options =>
{
    options.AddPolicy("dev", p =>
        p.AllowAnyOrigin()
         .AllowAnyHeader()
         .AllowAnyMethod());
});

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// AUTO-MIGRATION: Garante que o banco seja criado/atualizado ao iniciar
using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    try
    {
        dbContext.Database.Migrate();
        Console.WriteLine("Migrations applied successfully.");
    }
    catch (Exception ex)
    {
        // Se falhar a migração, logar, mas tentar continuar (ou falhar de vez se preferir)
        Console.WriteLine($"Erro CRÍTICO ao aplicar Migrations: {ex}");
    }

    // AUTO-VERSION: Registra a versão atual no banco se ainda não existir
    try
    {
        var asm = System.Reflection.Assembly.GetExecutingAssembly();
        var attr = (System.Reflection.AssemblyInformationalVersionAttribute?)
            System.Attribute.GetCustomAttribute(asm, typeof(System.Reflection.AssemblyInformationalVersionAttribute));
        var rawVersion = attr?.InformationalVersion ?? asm.GetName().Version?.ToString() ?? "0.0.0";
        // Strip git hash suffix (e.g. "1.0.0+abc123..." → "1.0.0")
        var currentVersion = rawVersion.Contains('+') ? rawVersion.Split('+')[0] : rawVersion;

        var exists = dbContext.VersoesDoSistema.Any(v => v.Versao == currentVersion);
        if (!exists)
        {
            dbContext.VersoesDoSistema.Add(new Pi.Api.Models.VersaoSistema
            {
                Versao = currentVersion,
                Data = DateTime.UtcNow
            });
            dbContext.SaveChanges();
            Console.WriteLine($"Versão {currentVersion} registrada no banco.");
        }
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Aviso: Erro ao registrar versão: {ex.Message}");
    }

    // SEED-FREIGHT: Garante que os valores de frete globais existam
    try
    {
        SeedFreightData(dbContext);
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Aviso: Erro ao semear fretes: {ex.Message}");
    }
}

// Método auxiliar para garantir integridade dos dados de frete
static void SeedFreightData(AppDbContext db)
{
    // 1. Garantir que o EXW existe (mesmo id do AppDbContext)
    if (!db.Fretes.Any(f => f.Id == 4))
    {
        db.Fretes.Add(new Pi.Api.Models.Frete { Id = 4, Nome = "EXW" });
        db.SaveChanges();
    }

    // 2. Garantir 17 itens globais (id_fornecedor IS NULL)
    // Se não houver nenhum, criamos a base
    var hasGlobalDefaults = db.ConfiguracoesFreteItens.Any(c => c.IdFornecedor == null);
    if (!hasGlobalDefaults)
    {
        for (int i = 1; i <= 17; i++)
        {
            db.ConfiguracoesFreteItens.Add(new Pi.Api.Models.ConfiguracoesFreteItem
            {
                IdFreteItem = i,
                IdFornecedor = null,
                Valor = i == 5 ? 3610.00m : 0.00m,
                FlDesconsidera = false
            });
        }
        db.SaveChanges();
        Console.WriteLine("Configurações globais de frete semeadas.");
    }
    else
    {
        // Se já existem, apenas forçamos o valor correto do frete de fronteira (id 5) se ele for diferente 
        // ou se estiver zerado (comum em restores antigos)
        var frontierFreight = db.ConfiguracoesFreteItens.FirstOrDefault(c => c.IdFreteItem == 5 && c.IdFornecedor == null);
        if (frontierFreight != null && (frontierFreight.Valor == 0 || frontierFreight.Valor == 361.00m))
        {
            frontierFreight.Valor = 3610.00m;
            db.SaveChanges();
            Console.WriteLine("Valor do frete de fronteira (Global) normalizado para 3610.00.");
        }
    }
}

// SEMPRE ativar página de erro detalhada para debugar no Render (temporário)
app.UseDeveloperExceptionPage();

app.UseSwagger();
app.UseSwaggerUI();

app.UseCors("dev");

app.MapControllers();

app.Run();
