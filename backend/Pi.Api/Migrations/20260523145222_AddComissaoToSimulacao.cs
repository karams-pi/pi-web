using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddComissaoToSimulacao : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<decimal>(
                name: "ComissaoPercentual",
                schema: "edc",
                table: "simulacoes",
                type: "numeric(18,4)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.AddColumn<bool>(
                name: "FlExibirComissao",
                schema: "edc",
                table: "simulacoes",
                type: "boolean",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ComissaoPercentual",
                schema: "edc",
                table: "simulacoes");

            migrationBuilder.DropColumn(
                name: "FlExibirComissao",
                schema: "edc",
                table: "simulacoes");
        }
    }
}
