using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Models.Edc;

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
        options.JsonSerializerOptions.PropertyNameCaseInsensitive = true;
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

    options.UseNpgsql(connectionString, o => o.MigrationsHistoryTable("__EFMigrationsHistory", "public"));
});

// Registrar HttpClient e CotacaoService
builder.Services.AddHttpClient<Pi.Api.Services.CotacaoService>()
    .ConfigurePrimaryHttpMessageHandler(() => new HttpClientHandler
    {
        UseProxy = false
    });
builder.Services.AddScoped<Pi.Api.Services.ICalculoService, Pi.Api.Services.CalculoService>();
builder.Services.AddScoped<Pi.Api.Services.IEdcCalculationService, Pi.Api.Services.EdcCalculationService>();
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
        Console.WriteLine($"Erro CRÍTICO ao aplicar Migrations: {ex}");
    }

    // AUTO-VERSION: Registra a versão atual no banco se ainda não existir
    try
    {
        var asm = System.Reflection.Assembly.GetExecutingAssembly();
        var attr = (System.Reflection.AssemblyInformationalVersionAttribute?)
            System.Attribute.GetCustomAttribute(asm, typeof(System.Reflection.AssemblyInformationalVersionAttribute));
        var rawVersion = attr?.InformationalVersion ?? asm.GetName().Version?.ToString() ?? "0.0.0";
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

    // SEED-EDC: Garante dados iniciais para o módulo de Importação
    try
    {
        SeedEdcData(dbContext);
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Aviso: Erro ao semear dados EDC: {ex.Message}");
    }
}

// Método auxiliar para garantir integridade dos dados de frete
static void SeedFreightData(AppDbContext db)
{
    if (!db.Fretes.Any(f => f.Id == 4))
    {
        db.Fretes.Add(new Pi.Api.Models.Frete { Id = 4, Nome = "EXW" });
        db.SaveChanges();
    }

    if (!db.Fretes.Any(f => f.Id == 6))
    {
        db.Fretes.Add(new Pi.Api.Models.Frete { Id = 6, Nome = "FCA (Fábrica)" });
        db.SaveChanges();
    }

    var fcaOriginal = db.Fretes.FirstOrDefault(f => f.Id == 2);
    if (fcaOriginal != null && fcaOriginal.Nome == "FCA")
    {
        fcaOriginal.Nome = "FCA (Fronteira)";
        db.SaveChanges();
    }

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
    }
    else
    {
        var frontierFreight = db.ConfiguracoesFreteItens.FirstOrDefault(c => c.IdFreteItem == 5 && c.IdFornecedor == null);
        if (frontierFreight != null && (frontierFreight.Valor == 0 || frontierFreight.Valor == 361.00m))
        {
            frontierFreight.Valor = 3610.00m;
            db.SaveChanges();
        }
    }
}

static void SeedEdcData(AppDbContext db)
{
    // 1. NCM Padrão (Amortecedores)
    if (!db.Ncms.Any(n => n.Codigo == "87088000"))
    {
        db.Ncms.Add(new Ncm 
        { 
            Codigo = "87088000", 
            Descricao = "AMORTECEDORES DE SUSPENSÃO",
            AliquotaII = 0.18m,
            AliquotaIPI = 0.0306m,
            AliquotaPis = 0.0312m,
            AliquotaCofins = 0.1437m,
            AliquotaIcmsPadrao = 0.19m
        });
    }

    // 2. Taxas Aduaneiras Padrão
    if (!db.TaxasAduaneiras.Any())
    {
        db.TaxasAduaneiras.AddRange(new List<TaxasAduaneiras> {
            new() { Nome = "TAXA SISCOMEX", ValorPadrao = 214.50m, Moeda = "BRL", Tipo = "Fixo" },
            new() { Nome = "LIBERAÇÃO DE B/L", ValorPadrao = 490.00m, Moeda = "BRL", Tipo = "Fixo" },
            new() { Nome = "T.H.C|CAPATAZIA", ValorPadrao = 1547.00m, Moeda = "BRL", Tipo = "Fixo" },
            new() { Nome = "AFRMM", ValorPadrao = 0.08m, Moeda = "BRL", Tipo = "Percentual" }, 
            new() { Nome = "DESEMBARAÇO ADUANEIRO", ValorPadrao = 2400.00m, Moeda = "BRL", Tipo = "Fixo" }
        });
    }

    // 3. Portos
    if (!db.Portos.Any(p => p.Sigla == "PNG"))
    {
        db.Portos.Add(new Porto { Nome = "PARANAGUÁ", Sigla = "PNG", Pais = "BRASIL", Tipo = "Maritimo" });
    }
    if (!db.Portos.Any(p => p.Sigla == "SHA"))
    {
        db.Portos.Add(new Porto { Nome = "SHANGHAI", Sigla = "SHA", Pais = "CHINA", Tipo = "Maritimo" });
    }

    // 4. Configuração Fiscal PR
    if (!db.ConfiguracoesFiscais.Any(c => c.UF == "PR"))
    {
        db.ConfiguracoesFiscais.Add(new ConfiguracaoFiscal { UF = "PR", AliquotaIcms = 0.19m, AliquotaFCP = 0.00m });
    }

    db.SaveChanges();
}

app.UseDeveloperExceptionPage();
app.UseSwagger();
app.UseSwaggerUI();
app.UseCors("dev");
app.MapControllers();
app.Run();
