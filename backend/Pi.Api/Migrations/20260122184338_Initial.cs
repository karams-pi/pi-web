using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class Initial : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "categoria",
                columns: table => new
                {
                    id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nome = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_categoria", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "clientes",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    nome = table.Column<string>(type: "text", nullable: false),
                    empresa = table.Column<string>(type: "text", nullable: true),
                    email = table.Column<string>(type: "text", nullable: true),
                    telefone = table.Column<string>(type: "text", nullable: true),
                    ativo = table.Column<bool>(type: "boolean", nullable: false),
                    pais = table.Column<string>(type: "text", nullable: true),
                    cidade = table.Column<string>(type: "text", nullable: true),
                    endereco = table.Column<string>(type: "text", nullable: true),
                    cep = table.Column<string>(type: "text", nullable: true),
                    pessoa_contato = table.Column<string>(type: "text", nullable: true),
                    cargo_funcao = table.Column<string>(type: "text", nullable: true),
                    observacoes = table.Column<string>(type: "text", nullable: true),
                    criado_em = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    atualizado_em = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_clientes", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "fornecedor",
                columns: table => new
                {
                    id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nome = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    cnpj = table.Column<string>(type: "character varying(14)", maxLength: 14, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_fornecedor", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "lista_preco",
                columns: table => new
                {
                    id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    fornecedor_lista = table.Column<string>(type: "text", nullable: false),
                    tipo_preco = table.Column<string>(type: "text", nullable: false),
                    data_lista_preco = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    marca = table.Column<string>(type: "text", nullable: false),
                    descricao = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    largura = table.Column<decimal>(type: "numeric(18,3)", precision: 18, scale: 3, nullable: false),
                    profundidade = table.Column<decimal>(type: "numeric(18,3)", precision: 18, scale: 3, nullable: false),
                    altura = table.Column<decimal>(type: "numeric(18,3)", precision: 18, scale: 3, nullable: false),
                    m3 = table.Column<decimal>(type: "numeric(18,3)", precision: 18, scale: 3, nullable: false),
                    g0 = table.Column<decimal>(type: "numeric(18,2)", precision: 18, scale: 2, nullable: true),
                    g1 = table.Column<decimal>(type: "numeric(18,2)", precision: 18, scale: 2, nullable: true),
                    g2 = table.Column<decimal>(type: "numeric(18,2)", precision: 18, scale: 2, nullable: true),
                    g3 = table.Column<decimal>(type: "numeric(18,2)", precision: 18, scale: 2, nullable: true),
                    g4 = table.Column<decimal>(type: "numeric(18,2)", precision: 18, scale: 2, nullable: true),
                    g5 = table.Column<decimal>(type: "numeric(18,2)", precision: 18, scale: 2, nullable: true),
                    g6 = table.Column<decimal>(type: "numeric(18,2)", precision: 18, scale: 2, nullable: true),
                    g7 = table.Column<decimal>(type: "numeric(18,2)", precision: 18, scale: 2, nullable: true),
                    g8 = table.Column<decimal>(type: "numeric(18,2)", precision: 18, scale: 2, nullable: true),
                    fl_ativo = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_lista_preco", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "marca",
                columns: table => new
                {
                    id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nome = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    url_imagem = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    observacao = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_marca", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "pi_sequencias",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    prefixo = table.Column<string>(type: "text", nullable: false),
                    ano = table.Column<int>(type: "integer", nullable: false),
                    ultimo_numero = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_pi_sequencias", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "tecido",
                columns: table => new
                {
                    id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nome = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_tecido", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "pis",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Numero = table.Column<string>(type: "text", nullable: false),
                    Prefixo = table.Column<string>(type: "text", nullable: false),
                    DataPi = table.Column<DateOnly>(type: "date", nullable: false),
                    Status = table.Column<string>(type: "text", nullable: false),
                    ClienteId = table.Column<Guid>(type: "uuid", nullable: false),
                    TipoPreco = table.Column<string>(type: "text", nullable: false),
                    UsdRate = table.Column<decimal>(type: "numeric", nullable: true),
                    UsdRateFonte = table.Column<string>(type: "text", nullable: true),
                    UsdRateAtualizadoEm = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    TotalUsd = table.Column<decimal>(type: "numeric", nullable: false),
                    TotalBrl = table.Column<decimal>(type: "numeric", nullable: false),
                    CriadoEm = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    AtualizadoEm = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_pis", x => x.Id);
                    table.ForeignKey(
                        name: "FK_pis_clientes_ClienteId",
                        column: x => x.ClienteId,
                        principalTable: "clientes",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "modulo",
                columns: table => new
                {
                    id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_fornecedor = table.Column<long>(type: "bigint", nullable: false),
                    id_categoria = table.Column<long>(type: "bigint", nullable: false),
                    id_marca = table.Column<long>(type: "bigint", nullable: false),
                    descricao = table.Column<string>(type: "character varying(300)", maxLength: 300, nullable: false),
                    largura = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    profundidade = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    altura = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    pa = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    m3 = table.Column<decimal>(type: "numeric(18,2)", nullable: false, computedColumnSql: "round((largura * profundidade * altura)::numeric, 2)", stored: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_modulo", x => x.id);
                    table.ForeignKey(
                        name: "FK_modulo_categoria_id_categoria",
                        column: x => x.id_categoria,
                        principalTable: "categoria",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_modulo_fornecedor_id_fornecedor",
                        column: x => x.id_fornecedor,
                        principalTable: "fornecedor",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_modulo_marca_id_marca",
                        column: x => x.id_marca,
                        principalTable: "marca",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "modulo_tecido",
                columns: table => new
                {
                    id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_modulo = table.Column<long>(type: "bigint", nullable: false),
                    id_tecido = table.Column<long>(type: "bigint", nullable: false),
                    valor_tecido = table.Column<decimal>(type: "numeric(18,3)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_modulo_tecido", x => x.id);
                    table.ForeignKey(
                        name: "FK_modulo_tecido_modulo_id_modulo",
                        column: x => x.id_modulo,
                        principalTable: "modulo",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_modulo_tecido_tecido_id_tecido",
                        column: x => x.id_tecido,
                        principalTable: "tecido",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "uq_categoria_nome",
                table: "categoria",
                column: "nome",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "uq_fornecedor_cnpj",
                table: "fornecedor",
                column: "cnpj",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "uq_marca_nome",
                table: "marca",
                column: "nome",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "ix_modulo_id_categoria",
                table: "modulo",
                column: "id_categoria");

            migrationBuilder.CreateIndex(
                name: "ix_modulo_id_fornecedor",
                table: "modulo",
                column: "id_fornecedor");

            migrationBuilder.CreateIndex(
                name: "ix_modulo_id_marca",
                table: "modulo",
                column: "id_marca");

            migrationBuilder.CreateIndex(
                name: "ix_modulo_tecido_id_modulo",
                table: "modulo_tecido",
                column: "id_modulo");

            migrationBuilder.CreateIndex(
                name: "ix_modulo_tecido_id_tecido",
                table: "modulo_tecido",
                column: "id_tecido");

            migrationBuilder.CreateIndex(
                name: "uq_modulo_tecido_id_modulo_id_tecido",
                table: "modulo_tecido",
                columns: new[] { "id_modulo", "id_tecido" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "uq_pi_sequencias_prefixo_ano",
                table: "pi_sequencias",
                columns: new[] { "prefixo", "ano" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_pis_ClienteId",
                table: "pis",
                column: "ClienteId");

            migrationBuilder.CreateIndex(
                name: "uq_tecido_nome",
                table: "tecido",
                column: "nome",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "lista_preco");

            migrationBuilder.DropTable(
                name: "modulo_tecido");

            migrationBuilder.DropTable(
                name: "pi_sequencias");

            migrationBuilder.DropTable(
                name: "pis");

            migrationBuilder.DropTable(
                name: "modulo");

            migrationBuilder.DropTable(
                name: "tecido");

            migrationBuilder.DropTable(
                name: "clientes");

            migrationBuilder.DropTable(
                name: "categoria");

            migrationBuilder.DropTable(
                name: "fornecedor");

            migrationBuilder.DropTable(
                name: "marca");
        }
    }
}
