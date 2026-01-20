namespace Pi.Api.Contracts;

public class PiCreateResponse
{
    public Guid Id { get; set; }
    public string Numero { get; set; } = default!;
}
