using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddCodigoModuloTecido : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "codigo_modulo_tecido",
                table: "modulo_tecido",
                type: "character varying(10)",
                maxLength: 10,
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "codigo_modulo_tecido",
                table: "modulo_tecido");
        }
    }
}
