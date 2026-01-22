using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pi.Api.Models;

[Table("categoria")]
public class Categoria
{
    [Key]
    [Column("id")]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public long Id { get; set; }

    [Required]
    [Column("nome")]
    [MaxLength(200)]
    public string Nome { get; set; } = string.Empty;

    public ICollection<Modelo> Modelos { get; set; } = new List<Modelo>();
}
