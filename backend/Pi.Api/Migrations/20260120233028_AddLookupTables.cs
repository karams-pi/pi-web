using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddLookupTables : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "categoria",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    nome = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_categoria", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "modelo",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    nome = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_modelo", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "tecido",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    nome = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_tecido", x => x.id);
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
                name: "modelo");

            migrationBuilder.DropTable(
                name: "tecido");
        }
    }
}
