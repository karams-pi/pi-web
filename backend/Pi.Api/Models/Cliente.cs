namespace Pi.Api.Models;

using System.ComponentModel.DataAnnotations.Schema;

[Table("clientes")]
public class Cliente
{
    [Column("id")] public Guid Id { get; set; }
    [Column("nome")] public string Nome { get; set; } = "";
    [Column("empresa")] public string? Empresa { get; set; }
    [Column("email")] public string? Email { get; set; }
    [Column("telefone")] public string? Telefone { get; set; }
    [Column("ativo")] public bool Ativo { get; set; }
    [Column("pais")] public string? Pais { get; set; }
    [Column("cidade")] public string? Cidade { get; set; }
    [Column("endereco")] public string? Endereco { get; set; }
    [Column("cep")] public string? Cep { get; set; }
    [Column("pessoa_contato")] public string? PessoaContato { get; set; }
    [Column("cargo_funcao")] public string? CargoFuncao { get; set; }
    [Column("observacoes")] public string? Observacoes { get; set; }
    [Column("criado_em")] public DateTimeOffset CriadoEm { get; set; }
    [Column("atualizado_em")] public DateTimeOffset AtualizadoEm { get; set; }
}
