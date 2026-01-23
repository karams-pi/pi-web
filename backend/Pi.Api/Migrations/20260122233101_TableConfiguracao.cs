using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class TableConfiguracao : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "configuracoes",
                columns: table => new
                {
                    id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    data_config = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    valor_reducao_dolar = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    valor_perc_imposto = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    percentual_comissao = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    percentual_gordura = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    valor_FCA_frete_rod_fronteira = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    valor_despesas_FCA = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    valor_FOB_frete_porto_paranagua = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    valor_FOB_desp_port_reg_doc = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    valor_FOB_desp_despac_aduaneiro = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    valor_FOB_desp_courier = table.Column<decimal>(type: "numeric(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_configuracoes", x => x.id);
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "configuracoes");
        }
    }
}
