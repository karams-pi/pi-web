using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddSubModulo : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "sub_modulo",
                schema: "pi",
                columns: table => new
                {
                    id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_modulo = table.Column<long>(type: "bigint", nullable: false),
                    id_tecido_base = table.Column<long>(type: "bigint", nullable: false),
                    codigo = table.Column<string>(type: "character varying(15)", maxLength: 15, nullable: false),
                    descricao_produto = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    tecido_especifico = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    volume_m3 = table.Column<decimal>(type: "numeric(18,6)", nullable: false),
                    fl_ativo = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_sub_modulo", x => x.id);
                    table.ForeignKey(
                        name: "FK_sub_modulo_modulo_id_modulo",
                        column: x => x.id_modulo,
                        principalSchema: "pi",
                        principalTable: "modulo",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_sub_modulo_tecido_id_tecido_base",
                        column: x => x.id_tecido_base,
                        principalSchema: "pi",
                        principalTable: "tecido",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "ix_sub_modulo_id_modulo",
                schema: "pi",
                table: "sub_modulo",
                column: "id_modulo");

            migrationBuilder.CreateIndex(
                name: "ix_sub_modulo_id_tecido_base",
                schema: "pi",
                table: "sub_modulo",
                column: "id_tecido_base");

            migrationBuilder.CreateIndex(
                name: "ix_sub_modulo_modulo_tecido_especifico",
                schema: "pi",
                table: "sub_modulo",
                columns: new[] { "id_modulo", "tecido_especifico" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "sub_modulo",
                schema: "pi");
        }
    }
}
