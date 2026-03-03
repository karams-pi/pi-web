using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddMissingColumns : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "condicoes_pagamento",
                table: "configuracoes",
                type: "character varying(200)",
                maxLength: 200,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "porto_embarque",
                table: "configuracoes",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "porto_destinatario",
                table: "clientes",
                type: "text",
                nullable: true);

            migrationBuilder.InsertData(
                table: "frete",
                columns: new[] { "id", "nome" },
                values: new object[] { 4L, "EXW" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "frete",
                keyColumn: "id",
                keyValue: 4L);

            migrationBuilder.DropColumn(
                name: "condicoes_pagamento",
                table: "configuracoes");

            migrationBuilder.DropColumn(
                name: "porto_embarque",
                table: "configuracoes");

            migrationBuilder.DropColumn(
                name: "porto_destinatario",
                table: "clientes");
        }
    }
}
