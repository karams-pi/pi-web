using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Pi.Api.Migrations
{
    /// <inheritdoc />
    public partial class ReplicateGlobalConfigToSuppliers : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"
INSERT INTO configuracoes (
    data_config, valor_reducao_dolar, valor_perc_imposto, 
    percentual_comissao, percentual_gordura, 
    ""valor_FCA_frete_rod_fronteira"", ""valor_despesas_FCA"", 
    ""valor_FOB_frete_porto_paranagua"", ""valor_FOB_desp_port_reg_doc"", 
    ""valor_FOB_desp_despac_aduaneiro"", ""valor_FOB_desp_courier"", 
    id_fornecedor
)
SELECT 
    NOW(), c.valor_reducao_dolar, c.valor_perc_imposto, 
    c.percentual_comissao, c.percentual_gordura, 
    c.""valor_FCA_frete_rod_fronteira"", c.""valor_despesas_FCA"", 
    c.""valor_FOB_frete_porto_paranagua"", c.""valor_FOB_desp_port_reg_doc"", 
    c.""valor_FOB_desp_despac_aduaneiro"", c.""valor_FOB_desp_courier"", 
    f.id
FROM fornecedor f
CROSS JOIN (
    SELECT * 
    FROM configuracoes 
    WHERE id_fornecedor IS NULL 
    ORDER BY data_config DESC 
    LIMIT 1
) c
WHERE NOT EXISTS (
    SELECT 1 FROM configuracoes WHERE id_fornecedor = f.id
);
            ");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {

        }
    }
}
