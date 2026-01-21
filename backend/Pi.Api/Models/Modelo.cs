namespace Pi.Api.Models;

using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("modelo")]
public class Modelo
{
    [Column("id")]
    [Key] public Guid Id { get; set; }
    [Column("nome")]
    [Required, MaxLength(160)] public string Nome { get; set; } = default!;
}