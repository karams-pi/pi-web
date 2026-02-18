using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddFeetAndFinishingToPiItem : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "feet",
                table: "pi_item",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "finishing",
                table: "pi_item",
                type: "text",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "feet",
                table: "pi_item");

            migrationBuilder.DropColumn(
                name: "finishing",
                table: "pi_item");
        }
    }
}
