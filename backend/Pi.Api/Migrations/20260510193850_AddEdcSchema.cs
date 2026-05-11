using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddEdcSchema : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.EnsureSchema(
                name: "edc");

            migrationBuilder.CreateTable(
                name: "configuracoes_fiscais",
                schema: "edc",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    UF = table.Column<string>(type: "character varying(2)", maxLength: 2, nullable: false),
                    AliquotaIcms = table.Column<decimal>(type: "numeric(18,4)", nullable: false),
                    AliquotaFCP = table.Column<decimal>(type: "numeric(18,4)", nullable: false),
                    IsencaoIPI = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_configuracoes_fiscais", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "exportadores",
                schema: "edc",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Nome = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    Pais = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    Endereco = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    TaxId = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true),
                    Contato = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    FlAtivo = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_exportadores", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "importadores",
                schema: "edc",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    RazaoSocial = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    Cnpj = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    InscricaoEstadual = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: true),
                    UF = table.Column<string>(type: "character varying(2)", maxLength: 2, nullable: false),
                    RegimeTributario = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    AliquotaIcmsPadrao = table.Column<decimal>(type: "numeric(18,4)", nullable: false),
                    FlAtivo = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_importadores", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "ncms",
                schema: "edc",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Codigo = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    Descricao = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false),
                    AliquotaII = table.Column<decimal>(type: "numeric(18,4)", nullable: false),
                    AliquotaIPI = table.Column<decimal>(type: "numeric(18,4)", nullable: false),
                    AliquotaPis = table.Column<decimal>(type: "numeric(18,4)", nullable: false),
                    AliquotaCofins = table.Column<decimal>(type: "numeric(18,4)", nullable: false),
                    AliquotaIcmsPadrao = table.Column<decimal>(type: "numeric(18,4)", nullable: false),
                    FlAtivo = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ncms", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "portos",
                schema: "edc",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Nome = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    Sigla = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    Pais = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    Tipo = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_portos", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "taxas_aduaneiras",
                schema: "edc",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Nome = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    ValorPadrao = table.Column<decimal>(type: "numeric(18,4)", nullable: false),
                    Moeda = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    Tipo = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_taxas_aduaneiras", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "produtos",
                schema: "edc",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Referencia = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    Descricao = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false),
                    IdNcm = table.Column<int>(type: "integer", nullable: false),
                    PesoLiquido = table.Column<decimal>(type: "numeric(18,4)", nullable: false),
                    PesoBruto = table.Column<decimal>(type: "numeric(18,4)", nullable: false),
                    CubagemM3 = table.Column<decimal>(type: "numeric(18,4)", nullable: false),
                    UnidadeMedida = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    PrecoFobBase = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    FlAtivo = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_produtos", x => x.Id);
                    table.ForeignKey(
                        name: "FK_produtos_ncms_IdNcm",
                        column: x => x.IdNcm,
                        principalSchema: "edc",
                        principalTable: "ncms",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "simulacoes",
                schema: "edc",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    NumeroReferencia = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    DataEstudo = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    IdImportador = table.Column<int>(type: "integer", nullable: false),
                    IdExportador = table.Column<int>(type: "integer", nullable: false),
                    IdPortoOrigem = table.Column<int>(type: "integer", nullable: true),
                    IdPortoDestino = table.Column<int>(type: "integer", nullable: true),
                    CotacaoDolar = table.Column<decimal>(type: "numeric(18,4)", nullable: false),
                    SpreadCambio = table.Column<decimal>(type: "numeric(18,4)", nullable: false),
                    TipoFrete = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    ValorFreteInternacional = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    ValorSeguroInternacional = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    Status = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_simulacoes", x => x.Id);
                    table.ForeignKey(
                        name: "FK_simulacoes_exportadores_IdExportador",
                        column: x => x.IdExportador,
                        principalSchema: "edc",
                        principalTable: "exportadores",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_simulacoes_importadores_IdImportador",
                        column: x => x.IdImportador,
                        principalSchema: "edc",
                        principalTable: "importadores",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_simulacoes_portos_IdPortoDestino",
                        column: x => x.IdPortoDestino,
                        principalSchema: "edc",
                        principalTable: "portos",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_simulacoes_portos_IdPortoOrigem",
                        column: x => x.IdPortoOrigem,
                        principalSchema: "edc",
                        principalTable: "portos",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                });

            migrationBuilder.CreateTable(
                name: "simulacao_despesas",
                schema: "edc",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    IdSimulacao = table.Column<int>(type: "integer", nullable: false),
                    NomeDespesa = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    Valor = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    Moeda = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    MetodoRateio = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_simulacao_despesas", x => x.Id);
                    table.ForeignKey(
                        name: "FK_simulacao_despesas_simulacoes_IdSimulacao",
                        column: x => x.IdSimulacao,
                        principalSchema: "edc",
                        principalTable: "simulacoes",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "simulacao_itens",
                schema: "edc",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    IdSimulacao = table.Column<int>(type: "integer", nullable: false),
                    IdProduto = table.Column<int>(type: "integer", nullable: false),
                    Quantidade = table.Column<decimal>(type: "numeric(18,4)", nullable: false),
                    ValorFobUnitario = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    PesoLiquidoTotal = table.Column<decimal>(type: "numeric(18,4)", nullable: false),
                    PesoBrutoTotal = table.Column<decimal>(type: "numeric(18,4)", nullable: false),
                    CubagemTotal = table.Column<decimal>(type: "numeric(18,4)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_simulacao_itens", x => x.Id);
                    table.ForeignKey(
                        name: "FK_simulacao_itens_produtos_IdProduto",
                        column: x => x.IdProduto,
                        principalSchema: "edc",
                        principalTable: "produtos",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_simulacao_itens_simulacoes_IdSimulacao",
                        column: x => x.IdSimulacao,
                        principalSchema: "edc",
                        principalTable: "simulacoes",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_produtos_IdNcm",
                schema: "edc",
                table: "produtos",
                column: "IdNcm");

            migrationBuilder.CreateIndex(
                name: "IX_simulacao_despesas_IdSimulacao",
                schema: "edc",
                table: "simulacao_despesas",
                column: "IdSimulacao");

            migrationBuilder.CreateIndex(
                name: "IX_simulacao_itens_IdProduto",
                schema: "edc",
                table: "simulacao_itens",
                column: "IdProduto");

            migrationBuilder.CreateIndex(
                name: "IX_simulacao_itens_IdSimulacao",
                schema: "edc",
                table: "simulacao_itens",
                column: "IdSimulacao");

            migrationBuilder.CreateIndex(
                name: "IX_simulacoes_IdExportador",
                schema: "edc",
                table: "simulacoes",
                column: "IdExportador");

            migrationBuilder.CreateIndex(
                name: "IX_simulacoes_IdImportador",
                schema: "edc",
                table: "simulacoes",
                column: "IdImportador");

            migrationBuilder.CreateIndex(
                name: "IX_simulacoes_IdPortoDestino",
                schema: "edc",
                table: "simulacoes",
                column: "IdPortoDestino");

            migrationBuilder.CreateIndex(
                name: "IX_simulacoes_IdPortoOrigem",
                schema: "edc",
                table: "simulacoes",
                column: "IdPortoOrigem");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "configuracoes_fiscais",
                schema: "edc");

            migrationBuilder.DropTable(
                name: "simulacao_despesas",
                schema: "edc");

            migrationBuilder.DropTable(
                name: "simulacao_itens",
                schema: "edc");

            migrationBuilder.DropTable(
                name: "taxas_aduaneiras",
                schema: "edc");

            migrationBuilder.DropTable(
                name: "produtos",
                schema: "edc");

            migrationBuilder.DropTable(
                name: "simulacoes",
                schema: "edc");

            migrationBuilder.DropTable(
                name: "ncms",
                schema: "edc");

            migrationBuilder.DropTable(
                name: "exportadores",
                schema: "edc");

            migrationBuilder.DropTable(
                name: "importadores",
                schema: "edc");

            migrationBuilder.DropTable(
                name: "portos",
                schema: "edc");
        }
    }
}
