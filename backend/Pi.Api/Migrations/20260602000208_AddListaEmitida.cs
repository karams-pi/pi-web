using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddListaEmitida : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "lista_emitida",
                schema: "pi",
                columns: table => new
                {
                    id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nome_referencia = table.Column<string>(type: "character varying(150)", maxLength: 150, nullable: true),
                    data_emissao = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    moeda = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    cotacao = table.Column<decimal>(type: "numeric(18,4)", nullable: false),
                    valor_frete = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    tipo_rateio = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    validade_dias = table.Column<int>(type: "integer", nullable: false),
                    itens_json = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_lista_emitida", x => x.id);
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "lista_emitida",
                schema: "pi");
        }
    }
}
