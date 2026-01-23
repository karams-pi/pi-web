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
    public DbSet<Marca> Marcas => Set<Marca>();
    public DbSet<Tecido> Tecidos => Set<Tecido>();

    // NOVO MODELO (remodelado)
    public DbSet<Modulo> Modulos => Set<Modulo>();
    public DbSet<ModuloTecido> ModulosTecidos => Set<ModuloTecido>();

    public DbSet<ListaPreco> ListasPreco => Set<ListaPreco>();

    public DbSet<Configuracao> Configuracoes => Set<Configuracao>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // ===== Tabelas já existentes =====
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

        // ===== Mapeamento/Índices/Restrições para as novas tabelas =====

        // Fornecedor / Categoria / Tecido / Marca:
        // (Se seus Models já usam [Table("...")] você pode até remover ToTable,
        //  mas deixo explícito aqui para ficar "blindado")
        modelBuilder.Entity<Fornecedor>().ToTable("fornecedor");
        modelBuilder.Entity<Categoria>().ToTable("categoria");
        modelBuilder.Entity<Tecido>().ToTable("tecido");
        modelBuilder.Entity<Marca>().ToTable("marca");

        // UNIQUE (mantive o que você já tinha e adicionei Marca)
        modelBuilder.Entity<Categoria>()
            .HasIndex(x => x.Nome)
            .IsUnique()
            .HasDatabaseName("uq_categoria_nome");

        modelBuilder.Entity<Tecido>()
            .HasIndex(x => x.Nome)
            .IsUnique()
            .HasDatabaseName("uq_tecido_nome");

        modelBuilder.Entity<Marca>()
            .HasIndex(x => x.Nome)
            .IsUnique()
            .HasDatabaseName("uq_marca_nome");

        // (opcional) CNPJ único
        modelBuilder.Entity<Fornecedor>()
            .HasIndex(x => x.Cnpj)
            .IsUnique()
            .HasDatabaseName("uq_fornecedor_cnpj");

        // Modulo
        modelBuilder.Entity<Modulo>(entity =>
        {
            entity.ToTable("modulo");

            entity.HasKey(x => x.Id);

            // índices de FK (performance)
            entity.HasIndex(x => x.IdFornecedor).HasDatabaseName("ix_modulo_id_fornecedor");
            entity.HasIndex(x => x.IdCategoria).HasDatabaseName("ix_modulo_id_categoria");
            entity.HasIndex(x => x.IdMarca).HasDatabaseName("ix_modulo_id_marca");

            // tipos numéricos
            entity.Property(x => x.Largura).HasColumnType("numeric(18,2)");
            entity.Property(x => x.Profundidade).HasColumnType("numeric(18,2)");
            entity.Property(x => x.Altura).HasColumnType("numeric(18,2)");
            entity.Property(x => x.Pa).HasColumnType("numeric(18,2)");

            // m3 como coluna calculada no banco (STORED)
            entity.Property(x => x.M3)
                .HasColumnType("numeric(18,2)")
                .HasComputedColumnSql(
                    "round((largura * profundidade * altura)::numeric, 2)",
                    stored: true
                );

            // relacionamentos
            entity.HasOne(x => x.Fornecedor)
                .WithMany(x => x.Modulos)
                .HasForeignKey(x => x.IdFornecedor)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(x => x.Categoria)
                .WithMany(x => x.Modulos)
                .HasForeignKey(x => x.IdCategoria)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(x => x.Marca)
                .WithMany(x => x.Modulos)
                .HasForeignKey(x => x.IdMarca)
                .OnDelete(DeleteBehavior.Restrict);
        });

        // ModuloTecido (tabela de junção com preço)
        modelBuilder.Entity<ModuloTecido>(entity =>
        {
            entity.ToTable("modulo_tecido");

            entity.HasKey(x => x.Id);

            entity.HasIndex(x => x.IdModulo).HasDatabaseName("ix_modulo_tecido_id_modulo");
            entity.HasIndex(x => x.IdTecido).HasDatabaseName("ix_modulo_tecido_id_tecido");

            // impede duplicar o mesmo tecido no mesmo módulo
            entity.HasIndex(x => new { x.IdModulo, x.IdTecido })
                .IsUnique()
                .HasDatabaseName("uq_modulo_tecido_id_modulo_id_tecido");

            entity.Property(x => x.ValorTecido).HasColumnType("numeric(18,3)");

            entity.HasOne(x => x.Modulo)
                .WithMany(x => x.ModulosTecidos)
                .HasForeignKey(x => x.IdModulo)
                .OnDelete(DeleteBehavior.Cascade);

            entity.HasOne(x => x.Tecido)
                .WithMany(x => x.ModulosTecidos)
                .HasForeignKey(x => x.IdTecido)
                .OnDelete(DeleteBehavior.Restrict);
        });

        // Configuracoes
        modelBuilder.Entity<Configuracao>(entity =>
        {
            entity.ToTable("configuracoes");
            entity.HasKey(x => x.Id);
            entity.Property(x => x.DataConfig).HasColumnName("data_config");
            entity.Property(x => x.ValorReducaoDolar).HasColumnName("valor_reducao_dolar");
            entity.Property(x => x.ValorPercImposto).HasColumnName("valor_perc_imposto");
            entity.Property(x => x.PercentualComissao).HasColumnName("percentual_comissao");
            entity.Property(x => x.PercentualGordura).HasColumnName("percentual_gordura");
            entity.Property(x => x.ValorFCAFreteRodFronteira).HasColumnName("valor_FCA_frete_rod_fronteira");
            entity.Property(x => x.ValorDespesasFCA).HasColumnName("valor_despesas_FCA");
            entity.Property(x => x.ValorFOBFretePortoParanagua).HasColumnName("valor_FOB_frete_porto_paranagua");
            entity.Property(x => x.ValorFOBDespPortRegDoc).HasColumnName("valor_FOB_desp_port_reg_doc");
            entity.Property(x => x.ValorFOBDespDespacAduaneiro).HasColumnName("valor_FOB_desp_despac_aduaneiro");
            entity.Property(x => x.ValorFOBDespCourier).HasColumnName("valor_FOB_desp_courier");
        });

        // ===== IMPORTANTE: removi tudo que era do MODELO ANTIGO =====
        // - DbSet<Modelo> e mapeamentos de Modelo
        // - índices Modulo.IdModelo e Modulo.IdTecido (agora virou ModuloTecido)
        //
        // Se ainda existir a classe Modelo no projeto por outros motivos, ok,
        // mas não deve estar mais no DbContext nem com migrations novas.

        base.OnModelCreating(modelBuilder);
    }
}
