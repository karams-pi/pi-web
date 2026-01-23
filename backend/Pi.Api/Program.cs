using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

builder.Services.AddDbContext<AppDbContext>(options =>
{
    options
        .UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")); // <-- evita "Id" vs "id"
});

// Registrar HttpClient e CotacaoService
builder.Services.AddHttpClient<Pi.Api.Services.CotacaoService>();

builder.Services.AddCors(options =>
{
    options.AddPolicy("dev", p =>
        p.WithOrigins("http://localhost:5173")
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
