using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class ChangeSchemaToPi : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.EnsureSchema(
                name: "pi");

            migrationBuilder.RenameTable(
                name: "versao_sistema",
                newName: "versao_sistema",
                newSchema: "pi");

            migrationBuilder.RenameTable(
                name: "tecido",
                newName: "tecido",
                newSchema: "pi");

            migrationBuilder.RenameTable(
                name: "pi_item_peca",
                newName: "pi_item_peca",
                newSchema: "pi");

            migrationBuilder.RenameTable(
                name: "pi_item",
                newName: "pi_item",
                newSchema: "pi");

            migrationBuilder.RenameTable(
                name: "pi",
                newName: "pi",
                newSchema: "pi");

            migrationBuilder.RenameTable(
                name: "modulo_tecido",
                newName: "modulo_tecido",
                newSchema: "pi");

            migrationBuilder.RenameTable(
                name: "modulo",
                newName: "modulo",
                newSchema: "pi");

            migrationBuilder.RenameTable(
                name: "modelo",
                newName: "modelo",
                newSchema: "pi");

            migrationBuilder.RenameTable(
                name: "marca",
                newName: "marca",
                newSchema: "pi");

            migrationBuilder.RenameTable(
                name: "lista_preco",
                newName: "lista_preco",
                newSchema: "pi");

            migrationBuilder.RenameTable(
                name: "frete_item",
                newName: "frete_item",
                newSchema: "pi");

            migrationBuilder.RenameTable(
                name: "frete",
                newName: "frete",
                newSchema: "pi");

            migrationBuilder.RenameTable(
                name: "fornecedor",
                newName: "fornecedor",
                newSchema: "pi");

            migrationBuilder.RenameTable(
                name: "configuracoes_frete_item",
                newName: "configuracoes_frete_item",
                newSchema: "pi");

            migrationBuilder.RenameTable(
                name: "configuracoes",
                newName: "configuracoes",
                newSchema: "pi");

            migrationBuilder.RenameTable(
                name: "clientes",
                newName: "clientes",
                newSchema: "pi");

            migrationBuilder.RenameTable(
                name: "categoria",
                newName: "categoria",
                newSchema: "pi");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameTable(
                name: "versao_sistema",
                schema: "pi",
                newName: "versao_sistema");

            migrationBuilder.RenameTable(
                name: "tecido",
                schema: "pi",
                newName: "tecido");

            migrationBuilder.RenameTable(
                name: "pi_item_peca",
                schema: "pi",
                newName: "pi_item_peca");

            migrationBuilder.RenameTable(
                name: "pi_item",
                schema: "pi",
                newName: "pi_item");

            migrationBuilder.RenameTable(
                name: "pi",
                schema: "pi",
                newName: "pi");

            migrationBuilder.RenameTable(
                name: "modulo_tecido",
                schema: "pi",
                newName: "modulo_tecido");

            migrationBuilder.RenameTable(
                name: "modulo",
                schema: "pi",
                newName: "modulo");

            migrationBuilder.RenameTable(
                name: "modelo",
                schema: "pi",
                newName: "modelo");

            migrationBuilder.RenameTable(
                name: "marca",
                schema: "pi",
                newName: "marca");

            migrationBuilder.RenameTable(
                name: "lista_preco",
                schema: "pi",
                newName: "lista_preco");

            migrationBuilder.RenameTable(
                name: "frete_item",
                schema: "pi",
                newName: "frete_item");

            migrationBuilder.RenameTable(
                name: "frete",
                schema: "pi",
                newName: "frete");

            migrationBuilder.RenameTable(
                name: "fornecedor",
                schema: "pi",
                newName: "fornecedor");

            migrationBuilder.RenameTable(
                name: "configuracoes_frete_item",
                schema: "pi",
                newName: "configuracoes_frete_item");

            migrationBuilder.RenameTable(
                name: "configuracoes",
                schema: "pi",
                newName: "configuracoes");

            migrationBuilder.RenameTable(
                name: "clientes",
                schema: "pi",
                newName: "clientes");

            migrationBuilder.RenameTable(
                name: "categoria",
                schema: "pi",
                newName: "categoria");
        }
    }
}
