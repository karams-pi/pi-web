using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddFlAtivoDtRevisaoToModuloTecido : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "dt_ultima_revisao",
                table: "modulo_tecido",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "fl_ativo",
                table: "modulo_tecido",
                type: "boolean",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "dt_ultima_revisao",
                table: "modulo_tecido");

            migrationBuilder.DropColumn(
                name: "fl_ativo",
                table: "modulo_tecido");
        }
    }
}
