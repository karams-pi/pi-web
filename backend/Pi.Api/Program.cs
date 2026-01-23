using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;

using OfficeOpenXml;

// Configurar licença do EPPlus (v8+)
ExcelPackage.License.SetNonCommercialPersonal("PI Web User");

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

builder.Services.AddDbContext<AppDbContext>(options =>
{
    options
        .UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")); // <-- evita "Id" vs "id"
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
