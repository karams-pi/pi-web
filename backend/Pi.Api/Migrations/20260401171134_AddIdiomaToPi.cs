using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddIdiomaToPi : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "idioma",
                table: "pi",
                type: "character varying(10)",
                maxLength: 10,
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "frete",
                keyColumn: "id",
                keyValue: 6L);

            migrationBuilder.DropColumn(
                name: "idioma",
                table: "pi");

            migrationBuilder.UpdateData(
                table: "frete",
                keyColumn: "id",
                keyValue: 2L,
                column: "nome",
                value: "FCA");
        }
    }
}
