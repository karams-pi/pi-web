using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddImagemToMarca : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "url_imagem",
                table: "marca");

            migrationBuilder.AddColumn<byte[]>(
                name: "imagem",
                table: "marca",
                type: "bytea",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "imagem",
                table: "marca");

            migrationBuilder.AddColumn<string>(
                name: "url_imagem",
                table: "marca",
                type: "character varying(500)",
                maxLength: 500,
                nullable: true);
        }
    }
}
