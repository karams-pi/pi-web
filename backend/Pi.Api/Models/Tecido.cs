namespace Pi.Api.Models;

using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("tecido")]
public class Tecido
{
    [Column("id")]
    [Key] public Guid Id { get; set; }
    [Column("nome")]
    [Required, MaxLength(16)] public string Nome { get; set; } = default!;
}