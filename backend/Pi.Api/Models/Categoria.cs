namespace Pi.Api.Models;

using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("categoria")]
public class Categoria
{
    [Column("id")]
    [Key] public Guid Id { get; set; }
    [Column("nome")]
    [Required, MaxLength(120)] public string Nome { get; set; } = default!;
}