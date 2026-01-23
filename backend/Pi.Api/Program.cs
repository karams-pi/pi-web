using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;

using OfficeOpenXml;

// Configurar licença do EPPlus (v8+)
ExcelPackage.License.SetNonCommercialPersonal("PI Web User");

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

builder.Services.AddDbContext<AppDbContext>(options =>
{
    var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

    // Fix para Render/Railwa (URLs tipo postgres://user:pass@host:port/db)
    if (!string.IsNullOrEmpty(connectionString) && connectionString.StartsWith("postgres://"))
    {
        var uri = new Uri(connectionString);
        var userInfo = uri.UserInfo.Split(':');
        var username = userInfo[0];
        var password = userInfo.Length > 1 ? userInfo[1] : "";
        
        connectionString = $"Host={uri.Host};Port={uri.Port};Database={uri.AbsolutePath.TrimStart('/')};Username={username};Password={password}";
    }

    options.UseNpgsql(connectionString);
});

// Registrar HttpClient e CotacaoService
// Registrar HttpClient e CotacaoService
builder.Services.AddHttpClient<Pi.Api.Services.CotacaoService>();
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

app.UseSwagger();
app.UseSwaggerUI();

app.UseCors("dev");

app.MapControllers();

app.Run();
