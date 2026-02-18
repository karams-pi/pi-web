using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddImagemToModelo : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<long>(
                name: "ModeloId",
                table: "modulo",
                type: "bigint",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "modelo",
                columns: table => new
                {
                    id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_fornecedor = table.Column<long>(type: "bigint", nullable: false),
                    id_categoria = table.Column<long>(type: "bigint", nullable: false),
                    descricao = table.Column<string>(type: "character varying(300)", maxLength: 300, nullable: false),
                    imagem = table.Column<byte[]>(type: "bytea", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_modelo", x => x.id);
                    table.ForeignKey(
                        name: "FK_modelo_categoria_id_categoria",
                        column: x => x.id_categoria,
                        principalTable: "categoria",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_modelo_fornecedor_id_fornecedor",
                        column: x => x.id_fornecedor,
                        principalTable: "fornecedor",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_modulo_ModeloId",
                table: "modulo",
                column: "ModeloId");

            migrationBuilder.CreateIndex(
                name: "IX_modelo_id_categoria",
                table: "modelo",
                column: "id_categoria");

            migrationBuilder.CreateIndex(
                name: "IX_modelo_id_fornecedor",
                table: "modelo",
                column: "id_fornecedor");

            migrationBuilder.AddForeignKey(
                name: "FK_modulo_modelo_ModeloId",
                table: "modulo",
                column: "ModeloId",
                principalTable: "modelo",
                principalColumn: "id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_modulo_modelo_ModeloId",
                table: "modulo");

            migrationBuilder.DropTable(
                name: "modelo");

            migrationBuilder.DropIndex(
                name: "IX_modulo_ModeloId",
                table: "modulo");

            migrationBuilder.DropColumn(
                name: "ModeloId",
                table: "modulo");
        }
    }
}
