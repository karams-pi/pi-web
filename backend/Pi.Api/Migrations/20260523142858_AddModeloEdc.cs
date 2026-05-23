using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddModeloEdc : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "IdModelo",
                schema: "edc",
                table: "simulacao_itens",
                type: "integer",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "modelos",
                schema: "edc",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Codigo = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    Nome = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    Descricao = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    IdProduto = table.Column<int>(type: "integer", nullable: false),
                    FlAtivo = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_modelos", x => x.Id);
                    table.ForeignKey(
                        name: "FK_modelos_produtos_IdProduto",
                        column: x => x.IdProduto,
                        principalSchema: "edc",
                        principalTable: "produtos",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_simulacao_itens_IdModelo",
                schema: "edc",
                table: "simulacao_itens",
                column: "IdModelo");

            migrationBuilder.CreateIndex(
                name: "IX_modelos_IdProduto",
                schema: "edc",
                table: "modelos",
                column: "IdProduto");

            migrationBuilder.AddForeignKey(
                name: "FK_simulacao_itens_modelos_IdModelo",
                schema: "edc",
                table: "simulacao_itens",
                column: "IdModelo",
                principalSchema: "edc",
                principalTable: "modelos",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_simulacao_itens_modelos_IdModelo",
                schema: "edc",
                table: "simulacao_itens");

            migrationBuilder.DropTable(
                name: "modelos",
                schema: "edc");

            migrationBuilder.DropIndex(
                name: "IX_simulacao_itens_IdModelo",
                schema: "edc",
                table: "simulacao_itens");

            migrationBuilder.DropColumn(
                name: "IdModelo",
                schema: "edc",
                table: "simulacao_itens");
        }
    }
}
