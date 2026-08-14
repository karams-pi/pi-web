using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddOrdemToSimulacaoDespesas : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "Ordem",
                schema: "edc",
                table: "simulacao_despesas",
                type: "integer",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Ordem",
                schema: "edc",
                table: "simulacao_despesas");
        }
    }
}
