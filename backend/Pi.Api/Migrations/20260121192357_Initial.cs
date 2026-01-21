using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

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
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    nome = table.Column<string>(type: "character varying(120)", maxLength: 120, nullable: false)
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
                name: "modelo",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    nome = table.Column<string>(type: "character varying(160)", maxLength: 160, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_modelo", x => x.id);
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
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    nome = table.Column<string>(type: "character varying(16)", maxLength: 16, nullable: false)
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

            migrationBuilder.InsertData(
                table: "categoria",
                columns: new[] { "id", "nome" },
                values: new object[,]
                {
                    { new Guid("c5e1c1b1-8b2c-4b2f-9f11-000000000001"), "Estofado" },
                    { new Guid("c5e1c1b1-8b2c-4b2f-9f11-000000000002"), "Cadeira" },
                    { new Guid("c5e1c1b1-8b2c-4b2f-9f11-000000000003"), "Chaise" },
                    { new Guid("c5e1c1b1-8b2c-4b2f-9f11-000000000004"), "Poltrona" },
                    { new Guid("c5e1c1b1-8b2c-4b2f-9f11-000000000005"), "Cama" },
                    { new Guid("c5e1c1b1-8b2c-4b2f-9f11-000000000006"), "Almofada" },
                    { new Guid("c5e1c1b1-8b2c-4b2f-9f11-000000000007"), "Puff" }
                });

            migrationBuilder.InsertData(
                table: "modelo",
                columns: new[] { "id", "nome" },
                values: new object[,]
                {
                    { new Guid("d2a2b2c2-1a1b-4c4d-9f22-000000000101"), "Daybed fixa (144)" },
                    { new Guid("d2a2b2c2-1a1b-4c4d-9f22-000000000102"), "Daybed giratória (144)" },
                    { new Guid("d2a2b2c2-1a1b-4c4d-9f22-000000000103"), "Daybed fixa (164)" },
                    { new Guid("d2a2b2c2-1a1b-4c4d-9f22-000000000104"), "Daybed giratória (164)" }
                });

            migrationBuilder.InsertData(
                table: "tecido",
                columns: new[] { "id", "nome" },
                values: new object[,]
                {
                    { new Guid("e3b3c3d3-2b2c-4d4e-9f33-000000000201"), "G0" },
                    { new Guid("e3b3c3d3-2b2c-4d4e-9f33-000000000202"), "G1" },
                    { new Guid("e3b3c3d3-2b2c-4d4e-9f33-000000000203"), "G2" },
                    { new Guid("e3b3c3d3-2b2c-4d4e-9f33-000000000204"), "G3" },
                    { new Guid("e3b3c3d3-2b2c-4d4e-9f33-000000000205"), "G4" },
                    { new Guid("e3b3c3d3-2b2c-4d4e-9f33-000000000206"), "G5" },
                    { new Guid("e3b3c3d3-2b2c-4d4e-9f33-000000000207"), "G6" },
                    { new Guid("e3b3c3d3-2b2c-4d4e-9f33-000000000208"), "G7" },
                    { new Guid("e3b3c3d3-2b2c-4d4e-9f33-000000000209"), "G8" }
                });

            migrationBuilder.CreateIndex(
                name: "IX_categoria_nome",
                table: "categoria",
                column: "nome",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_modelo_nome",
                table: "modelo",
                column: "nome",
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
                name: "IX_tecido_nome",
                table: "tecido",
                column: "nome",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "categoria");

            migrationBuilder.DropTable(
                name: "lista_preco");

            migrationBuilder.DropTable(
                name: "modelo");

            migrationBuilder.DropTable(
                name: "pi_sequencias");

            migrationBuilder.DropTable(
                name: "pis");

            migrationBuilder.DropTable(
                name: "tecido");

            migrationBuilder.DropTable(
                name: "clientes");
        }
    }
}
