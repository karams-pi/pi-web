using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddPiItemPecaNormalization : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "quantidade_peca",
                table: "pi_item");

            migrationBuilder.AddColumn<long>(
                name: "id_pi_item_peca",
                table: "pi_item",
                type: "bigint",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "pi_item_peca",
                columns: table => new
                {
                    id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_pi = table.Column<long>(type: "bigint", nullable: false),
                    descricao = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: true),
                    quantidade = table.Column<decimal>(type: "numeric(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_pi_item_peca", x => x.id);
                    table.ForeignKey(
                        name: "FK_pi_item_peca_pi_id_pi",
                        column: x => x.id_pi,
                        principalTable: "pi",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_pi_item_id_pi_item_peca",
                table: "pi_item",
                column: "id_pi_item_peca");

            migrationBuilder.CreateIndex(
                name: "IX_pi_item_peca_id_pi",
                table: "pi_item_peca",
                column: "id_pi");

            migrationBuilder.AddForeignKey(
                name: "FK_pi_item_pi_item_peca_id_pi_item_peca",
                table: "pi_item",
                column: "id_pi_item_peca",
                principalTable: "pi_item_peca",
                principalColumn: "id",
                onDelete: ReferentialAction.SetNull);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_pi_item_pi_item_peca_id_pi_item_peca",
                table: "pi_item");

            migrationBuilder.DropTable(
                name: "pi_item_peca");

            migrationBuilder.DropIndex(
                name: "IX_pi_item_id_pi_item_peca",
                table: "pi_item");

            migrationBuilder.DropColumn(
                name: "id_pi_item_peca",
                table: "pi_item");

            migrationBuilder.AddColumn<decimal>(
                name: "quantidade_peca",
                table: "pi_item",
                type: "numeric(18,2)",
                nullable: false,
                defaultValue: 0m);
        }
    }
}
