using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddIdFornecedorToConfiguracoes : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<long>(
                name: "id_fornecedor",
                table: "configuracoes",
                type: "bigint",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_configuracoes_id_fornecedor",
                table: "configuracoes",
                column: "id_fornecedor");

            migrationBuilder.AddForeignKey(
                name: "FK_configuracoes_fornecedor_id_fornecedor",
                table: "configuracoes",
                column: "id_fornecedor",
                principalTable: "fornecedor",
                principalColumn: "id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_configuracoes_fornecedor_id_fornecedor",
                table: "configuracoes");

            migrationBuilder.DropIndex(
                name: "IX_configuracoes_id_fornecedor",
                table: "configuracoes");

            migrationBuilder.DropColumn(
                name: "id_fornecedor",
                table: "configuracoes");
        }
    }
}
