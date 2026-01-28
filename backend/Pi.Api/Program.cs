using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;

using OfficeOpenXml;

// Configurar licença do EPPlus (v8+)
ExcelPackage.License.SetNonCommercialPersonal("PI Web User");

var builder = WebApplication.CreateBuilder(args);

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
builder.Services.AddScoped<Pi.Api.Services.ExcelImportService>();

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
    }
    catch (Exception ex)
    {
        // Se falhar a migração, logar, mas tentar continuar (ou falhar de vez se preferir)
        Console.WriteLine($"Erro ao aplicar Migrations: {ex.Message}");
    }
}

// SEMPRE ativar página de erro detalhada para debugar no Render (temporário)
app.UseDeveloperExceptionPage();

app.UseSwagger();
app.UseSwaggerUI();

app.UseCors("dev");

app.MapControllers();

app.Run();
