using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddIdSubModuloToPiItem : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<long>(
                name: "id_sub_modulo",
                schema: "pi",
                table: "pi_item",
                type: "bigint",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_pi_item_id_sub_modulo",
                schema: "pi",
                table: "pi_item",
                column: "id_sub_modulo");

            migrationBuilder.AddForeignKey(
                name: "FK_pi_item_sub_modulo_id_sub_modulo",
                schema: "pi",
                table: "pi_item",
                column: "id_sub_modulo",
                principalSchema: "pi",
                principalTable: "sub_modulo",
                principalColumn: "id",
                onDelete: ReferentialAction.SetNull);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_pi_item_sub_modulo_id_sub_modulo",
                schema: "pi",
                table: "pi_item");

            migrationBuilder.DropIndex(
                name: "IX_pi_item_id_sub_modulo",
                schema: "pi",
                table: "pi_item");

            migrationBuilder.DropColumn(
                name: "id_sub_modulo",
                schema: "pi",
                table: "pi_item");
        }
    }
}
