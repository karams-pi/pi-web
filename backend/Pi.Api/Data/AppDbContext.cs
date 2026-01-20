using Microsoft.EntityFrameworkCore;
using Pi.Api.Models;

namespace Pi.Api.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<Cliente> Clientes => Set<Cliente>();

    // Para o PisController:
    public DbSet<PiModel> Pis => Set<PiModel>();
    public DbSet<PiSequencia> PiSequencias => Set<PiSequencia>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Cliente>().ToTable("clientes");
        modelBuilder.Entity<PiModel>().ToTable("pis");
        modelBuilder.Entity<PiSequencia>().ToTable("pi_sequencias");

        base.OnModelCreating(modelBuilder);
    }
}
