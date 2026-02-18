using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class RevertModeloChanges : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "imagem",
                table: "modelo");

            migrationBuilder.AddColumn<string>(
                name: "url_imagem",
                table: "modelo",
                type: "character varying(500)",
                maxLength: 500,
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "url_imagem",
                table: "modelo");

            migrationBuilder.AddColumn<byte[]>(
                name: "imagem",
                table: "modelo",
                type: "bytea",
                nullable: true);
        }
    }
}
