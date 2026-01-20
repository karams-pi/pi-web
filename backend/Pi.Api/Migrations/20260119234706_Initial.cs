using System;
using Microsoft.EntityFrameworkCore.Migrations;

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
                name: "clientes",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Nome = table.Column<string>(type: "text", nullable: false),
                    Empresa = table.Column<string>(type: "text", nullable: true),
                    Email = table.Column<string>(type: "text", nullable: true),
                    Telefone = table.Column<string>(type: "text", nullable: true),
                    Ativo = table.Column<bool>(type: "boolean", nullable: false),
                    Pais = table.Column<string>(type: "text", nullable: true),
                    Cidade = table.Column<string>(type: "text", nullable: true),
                    Endereco = table.Column<string>(type: "text", nullable: true),
                    Cep = table.Column<string>(type: "text", nullable: true),
                    PessoaContato = table.Column<string>(type: "text", nullable: true),
                    CargoFuncao = table.Column<string>(type: "text", nullable: true),
                    Observacoes = table.Column<string>(type: "text", nullable: true),
                    CriadoEm = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    AtualizadoEm = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_clientes", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "pi_sequencia",
                columns: table => new
                {
                    Prefixo = table.Column<string>(type: "character varying(7)", maxLength: 7, nullable: false),
                    Ano = table.Column<int>(type: "integer", nullable: false),
                    UltimoNumero = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_pi_sequencia", x => new { x.Prefixo, x.Ano });
                });

            migrationBuilder.CreateTable(
                name: "pis",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Numero = table.Column<string>(type: "text", nullable: false),
                    Prefixo = table.Column<string>(type: "character varying(7)", maxLength: 7, nullable: false),
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
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_clientes_Email",
                table: "clientes",
                column: "Email");

            migrationBuilder.CreateIndex(
                name: "IX_clientes_Nome",
                table: "clientes",
                column: "Nome");

            migrationBuilder.CreateIndex(
                name: "IX_pis_ClienteId",
                table: "pis",
                column: "ClienteId");

            migrationBuilder.CreateIndex(
                name: "IX_pis_Numero",
                table: "pis",
                column: "Numero",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "pi_sequencia");

            migrationBuilder.DropTable(
                name: "pis");

            migrationBuilder.DropTable(
                name: "clientes");
        }
    }
}
