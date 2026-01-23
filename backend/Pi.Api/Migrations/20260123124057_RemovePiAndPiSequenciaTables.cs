using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class RemovePiAndPiSequenciaTables : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "pi_sequencias");

            migrationBuilder.DropTable(
                name: "pis");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "pi_sequencias",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    ano = table.Column<int>(type: "integer", nullable: false),
                    prefixo = table.Column<string>(type: "text", nullable: false),
                    ultimo_numero = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_pi_sequencias", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "pis",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    ClienteId = table.Column<Guid>(type: "uuid", nullable: false),
                    AtualizadoEm = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    CriadoEm = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    DataPi = table.Column<DateOnly>(type: "date", nullable: false),
                    Numero = table.Column<string>(type: "text", nullable: false),
                    Prefixo = table.Column<string>(type: "text", nullable: false),
                    Status = table.Column<string>(type: "text", nullable: false),
                    TipoPreco = table.Column<string>(type: "text", nullable: false),
                    TotalBrl = table.Column<decimal>(type: "numeric", nullable: false),
                    TotalUsd = table.Column<decimal>(type: "numeric", nullable: false),
                    UsdRate = table.Column<decimal>(type: "numeric", nullable: true),
                    UsdRateAtualizadoEm = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    UsdRateFonte = table.Column<string>(type: "text", nullable: true)
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

            migrationBuilder.CreateIndex(
                name: "uq_pi_sequencias_prefixo_ano",
                table: "pi_sequencias",
                columns: new[] { "prefixo", "ano" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_pis_ClienteId",
                table: "pis",
                column: "ClienteId");
        }
    }
}
