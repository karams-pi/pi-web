using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddMoedaValidadeToPi : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "moeda_exibicao",
                table: "pi",
                type: "character varying(10)",
                maxLength: 10,
                nullable: false,
                defaultValue: "USD");

            migrationBuilder.AddColumn<int>(
                name: "validade_dias",
                table: "pi",
                type: "integer",
                nullable: false,
                defaultValue: 30);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "moeda_exibicao",
                table: "pi");

            migrationBuilder.DropColumn(
                name: "validade_dias",
                table: "pi");
        }
    }
}
