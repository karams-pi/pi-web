using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddProformaInvoiceTables : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "frete",
                columns: table => new
                {
                    id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nome = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_frete", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "frete_item",
                columns: table => new
                {
                    id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_frete = table.Column<long>(type: "bigint", nullable: false),
                    nome = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_frete_item", x => x.id);
                    table.ForeignKey(
                        name: "FK_frete_item_frete_id_frete",
                        column: x => x.id_frete,
                        principalTable: "frete",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "pi",
                columns: table => new
                {
                    id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    prefixo = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    pi_sequencia = table.Column<string>(type: "character varying(5)", maxLength: 5, nullable: false),
                    data_pi = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    id_cliente = table.Column<Guid>(type: "uuid", nullable: false),
                    id_configuracoes = table.Column<long>(type: "bigint", nullable: false),
                    id_frete = table.Column<long>(type: "bigint", nullable: false),
                    valor_tecido = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    valor_total_frete_brl = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    valor_total_frete_usd = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    cotacao_atual_usd = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    cotacao_risco = table.Column<decimal>(type: "numeric(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_pi", x => x.id);
                    table.ForeignKey(
                        name: "FK_pi_clientes_id_cliente",
                        column: x => x.id_cliente,
                        principalTable: "clientes",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_pi_configuracoes_id_configuracoes",
                        column: x => x.id_configuracoes,
                        principalTable: "configuracoes",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_pi_frete_id_frete",
                        column: x => x.id_frete,
                        principalTable: "frete",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "configuracoes_frete_item",
                columns: table => new
                {
                    id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_frete_item = table.Column<long>(type: "bigint", nullable: false),
                    valor = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    fl_desconsidera = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_configuracoes_frete_item", x => x.id);
                    table.ForeignKey(
                        name: "FK_configuracoes_frete_item_frete_item_id_frete_item",
                        column: x => x.id_frete_item,
                        principalTable: "frete_item",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "pi_item",
                columns: table => new
                {
                    id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_pi = table.Column<long>(type: "bigint", nullable: false),
                    id_modulo_tecido = table.Column<long>(type: "bigint", nullable: false),
                    largura = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    profundidade = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    altura = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    pa = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    m3 = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    rateio_frete = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    quantidade = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    valor_exw = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    valor_frete_rateado_brl = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    valor_frete_rateado_usd = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    valor_final_item_brl = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    valor_final_item_usd_risco = table.Column<decimal>(type: "numeric(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_pi_item", x => x.id);
                    table.ForeignKey(
                        name: "FK_pi_item_modulo_tecido_id_modulo_tecido",
                        column: x => x.id_modulo_tecido,
                        principalTable: "modulo_tecido",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_pi_item_pi_id_pi",
                        column: x => x.id_pi,
                        principalTable: "pi",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "frete",
                columns: new[] { "id", "nome" },
                values: new object[,]
                {
                    { 1L, "FOB" },
                    { 2L, "FCA" },
                    { 3L, "CIF" }
                });

            migrationBuilder.CreateIndex(
                name: "ix_configuracoes_frete_item_id_frete_item",
                table: "configuracoes_frete_item",
                column: "id_frete_item");

            migrationBuilder.CreateIndex(
                name: "ix_frete_item_id_frete",
                table: "frete_item",
                column: "id_frete");

            migrationBuilder.CreateIndex(
                name: "ix_pi_id_cliente",
                table: "pi",
                column: "id_cliente");

            migrationBuilder.CreateIndex(
                name: "ix_pi_id_configuracoes",
                table: "pi",
                column: "id_configuracoes");

            migrationBuilder.CreateIndex(
                name: "ix_pi_id_frete",
                table: "pi",
                column: "id_frete");

            migrationBuilder.CreateIndex(
                name: "ix_pi_sequencia",
                table: "pi",
                column: "pi_sequencia");

            migrationBuilder.CreateIndex(
                name: "ix_pi_item_id_modulo_tecido",
                table: "pi_item",
                column: "id_modulo_tecido");

            migrationBuilder.CreateIndex(
                name: "ix_pi_item_id_pi",
                table: "pi_item",
                column: "id_pi");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "configuracoes_frete_item");

            migrationBuilder.DropTable(
                name: "pi_item");

            migrationBuilder.DropTable(
                name: "frete_item");

            migrationBuilder.DropTable(
                name: "pi");

            migrationBuilder.DropTable(
                name: "frete");
        }
    }
}
