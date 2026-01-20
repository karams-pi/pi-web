using Microsoft.EntityFrameworkCore;
using Pi.Api.Models;
using PiEntity = global::Pi.Api.Models.Pi;

namespace Pi.Api.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Cliente> Clientes => Set<Cliente>();
        public DbSet<PiEntity> Pis => Set<PiEntity>();
        public DbSet<PiSequencia> PiSequencias => Set<PiSequencia>();

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Cliente>(e =>
            {
                e.ToTable("clientes");
                e.HasKey(x => x.Id);
                e.Property(x => x.Nome).IsRequired();
                e.HasIndex(x => x.Nome);
                e.HasIndex(x => x.Email);
            });

            modelBuilder.Entity<PiEntity>(e =>
            {
                e.ToTable("pis");
                e.HasKey(x => x.Id);
                e.Property(x => x.Numero).IsRequired();
                e.HasIndex(x => x.Numero).IsUnique();

                e.Property(x => x.Prefixo).HasMaxLength(7);

                e.HasOne(x => x.Cliente)
                 .WithMany()
                 .HasForeignKey(x => x.ClienteId)
                 .OnDelete(DeleteBehavior.Restrict);
            });

            modelBuilder.Entity<PiSequencia>(e =>
            {
                e.ToTable("pi_sequencia");
                e.HasKey(x => new { x.Prefixo, x.Ano });
                e.Property(x => x.Prefixo).HasMaxLength(7);
            });
        }
    }
}
