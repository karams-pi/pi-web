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
        modelBuilder.Entity<PiSequencia>(e =>
        {
            e.ToTable("pi_sequencias");

            e.HasKey(x => x.Id);

            e.Property(x => x.Id).HasColumnName("id");
            e.Property(x => x.Prefixo).HasColumnName("prefixo");
            e.Property(x => x.Ano).HasColumnName("ano");
            e.Property(x => x.UltimoNumero).HasColumnName("ultimo_numero");

            e.HasIndex(x => new { x.Prefixo, x.Ano })
             .IsUnique()
             .HasDatabaseName("uq_pi_sequencias_prefixo_ano");
        });

        base.OnModelCreating(modelBuilder);
    }
}
