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

    public DbSet<Fornecedor> Fornecedores => Set<Fornecedor>();
    public DbSet<Categoria> Categorias => Set<Categoria>();
    public DbSet<Modelo> Modelos => Set<Modelo>();
    public DbSet<Tecido> Tecidos => Set<Tecido>();

    public DbSet<ListaPreco> ListasPreco => Set<ListaPreco>();

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

        // UNIQUE
        modelBuilder.Entity<Categoria>()
            .HasIndex(x => x.Nome).IsUnique();

        // modelBuilder.Entity<Modelo>()
        //     .HasIndex(x => x.Nome).IsUnique();

        modelBuilder.Entity<Tecido>()
            .HasIndex(x => x.Nome).IsUnique();

        modelBuilder.Entity<Categoria>()
        .Property(x => x.Id)
        .ValueGeneratedOnAdd();

        // SEED (GUIDs fixos para estabilidade)
        // modelBuilder.Entity<Categoria>().HasData(
        //     new Categoria { Id = Guid.Parse("c5e1c1b1-8b2c-4b2f-9f11-000000000001"), Nome = "Estofado" },
        //     new Categoria { Id = Guid.Parse("c5e1c1b1-8b2c-4b2f-9f11-000000000002"), Nome = "Cadeira" },
        //     new Categoria { Id = Guid.Parse("c5e1c1b1-8b2c-4b2f-9f11-000000000003"), Nome = "Chaise" },
        //     new Categoria { Id = Guid.Parse("c5e1c1b1-8b2c-4b2f-9f11-000000000004"), Nome = "Poltrona" },
        //     new Categoria { Id = Guid.Parse("c5e1c1b1-8b2c-4b2f-9f11-000000000005"), Nome = "Cama" },
        //     new Categoria { Id = Guid.Parse("c5e1c1b1-8b2c-4b2f-9f11-000000000006"), Nome = "Almofada" },
        //     new Categoria { Id = Guid.Parse("c5e1c1b1-8b2c-4b2f-9f11-000000000007"), Nome = "Puff" }
        // );

        // modelBuilder.Entity<Modelo>().HasData(
        //     new Modelo { Id = Guid.Parse("d2a2b2c2-1a1b-4c4d-9f22-000000000101"), Nome = "Affair" },
        //     new Modelo { Id = Guid.Parse("d2a2b2c2-1a1b-4c4d-9f22-000000000102"), Nome = "Daybed fixa (144)" },
        //     new Modelo { Id = Guid.Parse("d2a2b2c2-1a1b-4c4d-9f22-000000000103"), Nome = "Daybed giratória (144)" },
        //     new Modelo { Id = Guid.Parse("d2a2b2c2-1a1b-4c4d-9f22-000000000104"), Nome = "Daybed fixa (164)" },
        //     new Modelo { Id = Guid.Parse("d2a2b2c2-1a1b-4c4d-9f22-000000000105"), Nome = "Daybed giratória (164)" }
        // );

        // modelBuilder.Entity<Tecido>().HasData(
        //     new Tecido { Id = Guid.Parse("e3b3c3d3-2b2c-4d4e-9f33-000000000201"), Nome = "G0" },
        //     new Tecido { Id = Guid.Parse("e3b3c3d3-2b2c-4d4e-9f33-000000000202"), Nome = "G1" },
        //     new Tecido { Id = Guid.Parse("e3b3c3d3-2b2c-4d4e-9f33-000000000203"), Nome = "G2" },
        //     new Tecido { Id = Guid.Parse("e3b3c3d3-2b2c-4d4e-9f33-000000000204"), Nome = "G3" },
        //     new Tecido { Id = Guid.Parse("e3b3c3d3-2b2c-4d4e-9f33-000000000205"), Nome = "G4" },
        //     new Tecido { Id = Guid.Parse("e3b3c3d3-2b2c-4d4e-9f33-000000000206"), Nome = "G5" },
        //     new Tecido { Id = Guid.Parse("e3b3c3d3-2b2c-4d4e-9f33-000000000207"), Nome = "G6" },
        //     new Tecido { Id = Guid.Parse("e3b3c3d3-2b2c-4d4e-9f33-000000000208"), Nome = "G7" },
        //     new Tecido { Id = Guid.Parse("e3b3c3d3-2b2c-4d4e-9f33-000000000209"), Nome = "G8" }
        // );

        modelBuilder.Entity<ListaPreco>(e =>
        {
            e.ToTable("lista_preco");
            e.HasKey(x => x.Id);

            e.Property(x => x.Id).HasColumnName("id");
            e.Property(x => x.FornecedorLista).HasColumnName("fornecedor_lista");
            e.Property(x => x.Marca).HasColumnName("marca");
            e.Property(x => x.TipoPreco).HasColumnName("tipo_preco");
            e.Property(x => x.Descricao).HasColumnName("descricao");

            e.Property(x => x.Largura).HasColumnName("largura").HasPrecision(18, 3);
            e.Property(x => x.Profundidade).HasColumnName("profundidade").HasPrecision(18, 3);
            e.Property(x => x.Altura).HasColumnName("altura").HasPrecision(18, 3);
            e.Property(x => x.M3).HasColumnName("m3").HasPrecision(18, 3);

            e.Property(x => x.G0).HasColumnName("g0").HasPrecision(18, 2);
            e.Property(x => x.G1).HasColumnName("g1").HasPrecision(18, 2);
            e.Property(x => x.G2).HasColumnName("g2").HasPrecision(18, 2);
            e.Property(x => x.G3).HasColumnName("g3").HasPrecision(18, 2);
            e.Property(x => x.G4).HasColumnName("g4").HasPrecision(18, 2);
            e.Property(x => x.G5).HasColumnName("g5").HasPrecision(18, 2);
            e.Property(x => x.G6).HasColumnName("g6").HasPrecision(18, 2);
            e.Property(x => x.G7).HasColumnName("g7").HasPrecision(18, 2);
            e.Property(x => x.G8).HasColumnName("g8").HasPrecision(18, 2);

            e.Property(x => x.FlAtivo).HasColumnName("fl_ativo");
        });

        modelBuilder.Entity<Modelo>(entity =>
        {
            // Garante tipos (opcional, mas bom para Postgres)
            entity.Property(x => x.Largura).HasColumnType("numeric(18,2)");
            entity.Property(x => x.Profundidade).HasColumnType("numeric(18,2)");
            entity.Property(x => x.Altura).HasColumnType("numeric(18,2)");

            // m3 como coluna calculada no banco (STORED)
            entity.Property(x => x.M3)
                .HasColumnType("numeric(18,2)")
                .HasComputedColumnSql(
                    "round((largura * profundidade * altura)::numeric, 2)",
                    stored: true
                );
        });

        base.OnModelCreating(modelBuilder);
    }
}
