using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddSubfaturamentoToEdc : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "FlSimularSubfaturamento",
                schema: "edc",
                table: "simulacoes",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<string>(
                name: "MetodoCalculoFederais",
                schema: "edc",
                table: "simulacoes",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "MetodoCalculoIcms",
                schema: "edc",
                table: "simulacoes",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<decimal>(
                name: "PercentualSubfaturamento",
                schema: "edc",
                table: "simulacoes",
                type: "numeric(18,4)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.AddColumn<decimal>(
                name: "ValorFobSubfaturado",
                schema: "edc",
                table: "simulacao_itens",
                type: "numeric(18,2)",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "FlSimularSubfaturamento",
                schema: "edc",
                table: "simulacoes");

            migrationBuilder.DropColumn(
                name: "MetodoCalculoFederais",
                schema: "edc",
                table: "simulacoes");

            migrationBuilder.DropColumn(
                name: "MetodoCalculoIcms",
                schema: "edc",
                table: "simulacoes");

            migrationBuilder.DropColumn(
                name: "PercentualSubfaturamento",
                schema: "edc",
                table: "simulacoes");

            migrationBuilder.DropColumn(
                name: "ValorFobSubfaturado",
                schema: "edc",
                table: "simulacao_itens");
        }
    }
}
