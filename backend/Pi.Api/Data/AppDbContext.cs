using Microsoft.EntityFrameworkCore;
using Pi.Api.Models;

namespace Pi.Api.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<Cliente> Clientes => Set<Cliente>();

    public DbSet<Fornecedor> Fornecedores => Set<Fornecedor>();
    public DbSet<Categoria> Categorias => Set<Categoria>();
    public DbSet<Marca> Marcas => Set<Marca>();
    public DbSet<Tecido> Tecidos => Set<Tecido>();

    // NOVO MODELO (remodelado)
    public DbSet<Modulo> Modulos => Set<Modulo>();
    public DbSet<ModuloTecido> ModulosTecidos => Set<ModuloTecido>();

    public DbSet<ListaPreco> ListasPreco => Set<ListaPreco>();

    public DbSet<Configuracao> Configuracoes => Set<Configuracao>();

    // Proforma Invoice
    public DbSet<Frete> Fretes => Set<Frete>();
    public DbSet<FreteItem> FreteItens => Set<FreteItem>();
    public DbSet<ConfiguracoesFreteItem> ConfiguracoesFreteItens => Set<ConfiguracoesFreteItem>();
    public DbSet<ProformaInvoice> Pis => Set<ProformaInvoice>();
    public DbSet<PiItem> PiItens => Set<PiItem>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // ===== Tabelas já existentes =====
        modelBuilder.Entity<Cliente>().ToTable("clientes");

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

        // ===== Proforma Invoice =====
        
        // Frete
        modelBuilder.Entity<Frete>(entity =>
        {
            entity.ToTable("frete");
            entity.HasKey(x => x.Id);
            entity.Property(x => x.Id).HasColumnName("id");
            entity.Property(x => x.Nome).HasColumnName("nome").HasMaxLength(50).IsRequired();
            
            // Seed data
            entity.HasData(
                new Frete { Id = 1, Nome = "FOB" },
                new Frete { Id = 2, Nome = "FCA" },
                new Frete { Id = 3, Nome = "CIF" }
            );
        });

        // FreteItem
        modelBuilder.Entity<FreteItem>(entity =>
        {
            entity.ToTable("frete_item");
            entity.HasKey(x => x.Id);
            entity.Property(x => x.Id).HasColumnName("id");
            entity.Property(x => x.IdFrete).HasColumnName("id_frete").IsRequired();
            entity.Property(x => x.Nome).HasColumnName("nome").HasMaxLength(100).IsRequired();
            
            entity.HasIndex(x => x.IdFrete).HasDatabaseName("ix_frete_item_id_frete");
            
            entity.HasOne(x => x.Frete)
                .WithMany(x => x.FreteItens)
                .HasForeignKey(x => x.IdFrete)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // ConfiguracoesFreteItem
        modelBuilder.Entity<ConfiguracoesFreteItem>(entity =>
        {
            entity.ToTable("configuracoes_frete_item");
            entity.HasKey(x => x.Id);
            entity.Property(x => x.Id).HasColumnName("id");
            entity.Property(x => x.IdFreteItem).HasColumnName("id_frete_item").IsRequired();
            entity.Property(x => x.Valor).HasColumnName("valor").HasColumnType("numeric(18,2)").IsRequired();
            entity.Property(x => x.FlDesconsidera).HasColumnName("fl_desconsidera").IsRequired();
            
            entity.HasIndex(x => x.IdFreteItem).HasDatabaseName("ix_configuracoes_frete_item_id_frete_item");
            
            entity.HasOne(x => x.FreteItem)
                .WithMany(x => x.ConfiguracoesFreteItens)
                .HasForeignKey(x => x.IdFreteItem)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // Pi
        modelBuilder.Entity<ProformaInvoice>(entity =>
        {
            entity.ToTable("pi");
            entity.HasKey(x => x.Id);
            entity.Property(x => x.Id).HasColumnName("id");
            entity.Property(x => x.Prefixo).HasColumnName("prefixo").HasMaxLength(10).IsRequired();
            entity.Property(x => x.PiSequencia).HasColumnName("pi_sequencia").HasMaxLength(5).IsRequired();
            entity.Property(x => x.DataPi).HasColumnName("data_pi").IsRequired();
            entity.Property(x => x.IdCliente).HasColumnName("id_cliente").IsRequired();
            entity.Property(x => x.IdConfiguracoes).HasColumnName("id_configuracoes").IsRequired();
            entity.Property(x => x.IdFrete).HasColumnName("id_frete").IsRequired();
            entity.Property(x => x.ValorTecido).HasColumnName("valor_tecido").HasColumnType("numeric(18,2)").IsRequired();
            entity.Property(x => x.ValorTotalFreteBRL).HasColumnName("valor_total_frete_brl").HasColumnType("numeric(18,2)").IsRequired();
            entity.Property(x => x.ValorTotalFreteUSD).HasColumnName("valor_total_frete_usd").HasColumnType("numeric(18,2)").IsRequired();
            entity.Property(x => x.CotacaoAtualUSD).HasColumnName("cotacao_atual_usd").HasColumnType("numeric(18,2)").IsRequired();
            entity.Property(x => x.CotacaoRisco).HasColumnName("cotacao_risco").HasColumnType("numeric(18,2)").IsRequired();
            
            entity.HasIndex(x => x.IdCliente).HasDatabaseName("ix_pi_id_cliente");
            entity.HasIndex(x => x.IdConfiguracoes).HasDatabaseName("ix_pi_id_configuracoes");
            entity.HasIndex(x => x.IdFrete).HasDatabaseName("ix_pi_id_frete");
            entity.HasIndex(x => x.PiSequencia).HasDatabaseName("ix_pi_sequencia");
            
            entity.HasOne(x => x.Cliente)
                .WithMany()
                .HasForeignKey(x => x.IdCliente)
                .OnDelete(DeleteBehavior.Restrict);
                
            entity.HasOne(x => x.Configuracoes)
                .WithMany()
                .HasForeignKey(x => x.IdConfiguracoes)
                .OnDelete(DeleteBehavior.Restrict);
                
            entity.HasOne(x => x.Frete)
                .WithMany(x => x.Pis)
                .HasForeignKey(x => x.IdFrete)
                .OnDelete(DeleteBehavior.Restrict);
        });

        // PiItem
        modelBuilder.Entity<PiItem>(entity =>
        {
            entity.ToTable("pi_item");
            entity.HasKey(x => x.Id);
            entity.Property(x => x.Id).HasColumnName("id");
            entity.Property(x => x.IdPi).HasColumnName("id_pi").IsRequired();
            entity.Property(x => x.IdModuloTecido).HasColumnName("id_modulo_tecido").IsRequired();
            entity.Property(x => x.Largura).HasColumnName("largura").HasColumnType("numeric(18,2)").IsRequired();
            entity.Property(x => x.Profundidade).HasColumnName("profundidade").HasColumnType("numeric(18,2)").IsRequired();
            entity.Property(x => x.Altura).HasColumnName("altura").HasColumnType("numeric(18,2)").IsRequired();
            entity.Property(x => x.Pa).HasColumnName("pa").HasColumnType("numeric(18,2)").IsRequired();
            entity.Property(x => x.M3).HasColumnName("m3").HasColumnType("numeric(18,2)").IsRequired();
            entity.Property(x => x.RateioFrete).HasColumnName("rateio_frete").HasColumnType("numeric(18,2)").IsRequired();
            entity.Property(x => x.Quantidade).HasColumnName("quantidade").HasColumnType("numeric(18,2)").IsRequired();
            entity.Property(x => x.ValorEXW).HasColumnName("valor_exw").HasColumnType("numeric(18,2)").IsRequired();
            entity.Property(x => x.ValorFreteRateadoBRL).HasColumnName("valor_frete_rateado_brl").HasColumnType("numeric(18,2)").IsRequired();
            entity.Property(x => x.ValorFreteRateadoUSD).HasColumnName("valor_frete_rateado_usd").HasColumnType("numeric(18,2)").IsRequired();
            entity.Property(x => x.ValorFinalItemBRL).HasColumnName("valor_final_item_brl").HasColumnType("numeric(18,2)").IsRequired();
            entity.Property(x => x.ValorFinalItemUSDRisco).HasColumnName("valor_final_item_usd_risco").HasColumnType("numeric(18,2)").IsRequired();
            
            entity.HasIndex(x => x.IdPi).HasDatabaseName("ix_pi_item_id_pi");
            entity.HasIndex(x => x.IdModuloTecido).HasDatabaseName("ix_pi_item_id_modulo_tecido");
            
            entity.HasOne(x => x.Pi)
                .WithMany(x => x.PiItens)
                .HasForeignKey(x => x.IdPi)
                .OnDelete(DeleteBehavior.Cascade);
                
            entity.HasOne(x => x.ModuloTecido)
                .WithMany()
                .HasForeignKey(x => x.IdModuloTecido)
                .OnDelete(DeleteBehavior.Restrict);
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
