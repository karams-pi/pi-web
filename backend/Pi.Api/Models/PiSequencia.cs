namespace Pi.Api.Models;

public class PiSequencia
{
    public Guid Id { get; set; }
    public string Prefixo { get; set; } = default!;
    public int Ano { get; set; }
    public int UltimoNumero { get; set; }
}
