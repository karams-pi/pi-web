using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class RemoveUniqueConstraintModuloTecido : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "uq_modulo_tecido_id_modulo_id_tecido",
                table: "modulo_tecido");

            migrationBuilder.CreateIndex(
                name: "ix_modulo_tecido_id_modulo_id_tecido_multi",
                table: "modulo_tecido",
                columns: new[] { "id_modulo", "id_tecido" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "ix_modulo_tecido_id_modulo_id_tecido_multi",
                table: "modulo_tecido");

            migrationBuilder.CreateIndex(
                name: "uq_modulo_tecido_id_modulo_id_tecido",
                table: "modulo_tecido",
                columns: new[] { "id_modulo", "id_tecido" },
                unique: true);
        }
    }
}
