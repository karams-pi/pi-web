using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddIdFornecedorToConfigAndPi : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<long>(
                name: "id_fornecedor",
                table: "pi",
                type: "bigint",
                nullable: true);

            migrationBuilder.AddColumn<long>(
                name: "id_fornecedor",
                table: "configuracoes_frete_item",
                type: "bigint",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_pi_id_fornecedor",
                table: "pi",
                column: "id_fornecedor");

            migrationBuilder.CreateIndex(
                name: "IX_configuracoes_frete_item_id_fornecedor",
                table: "configuracoes_frete_item",
                column: "id_fornecedor");

            migrationBuilder.AddForeignKey(
                name: "FK_configuracoes_frete_item_fornecedor_id_fornecedor",
                table: "configuracoes_frete_item",
                column: "id_fornecedor",
                principalTable: "fornecedor",
                principalColumn: "id");

            migrationBuilder.AddForeignKey(
                name: "FK_pi_fornecedor_id_fornecedor",
                table: "pi",
                column: "id_fornecedor",
                principalTable: "fornecedor",
                principalColumn: "id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_configuracoes_frete_item_fornecedor_id_fornecedor",
                table: "configuracoes_frete_item");

            migrationBuilder.DropForeignKey(
                name: "FK_pi_fornecedor_id_fornecedor",
                table: "pi");

            migrationBuilder.DropIndex(
                name: "IX_pi_id_fornecedor",
                table: "pi");

            migrationBuilder.DropIndex(
                name: "IX_configuracoes_frete_item_id_fornecedor",
                table: "configuracoes_frete_item");

            migrationBuilder.DropColumn(
                name: "id_fornecedor",
                table: "pi");

            migrationBuilder.DropColumn(
                name: "id_fornecedor",
                table: "configuracoes_frete_item");
        }
    }
}
