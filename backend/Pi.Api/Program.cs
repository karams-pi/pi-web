using Microsoft.EntityFrameworkCore;
using Pi.Api.Data;
using Pi.Api.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddDbContext<AppDbContext>(opt =>
{
    var cs = builder.Configuration.GetConnectionString("Default");
    opt.UseNpgsql(cs);
});

// HttpClient para FX
builder.Services.AddHttpClient<FxService>();

// CORS (ajuste origem do Vite depois)
builder.Services.AddCors(opt =>
{
    opt.AddPolicy("dev", p =>
        p.AllowAnyHeader()
         .AllowAnyMethod()
         .AllowAnyOrigin());
});

var app = builder.Build();

app.UseCors("dev");

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.MapControllers();

app.Run();
