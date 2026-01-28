using System;
using System.Net.Http;
using System.Threading.Tasks;

class Program
{
    static async Task Main(string[] args)
    {
        Console.WriteLine("Iniciando diagnÃ³stico de rede...");

        // 1. Teste padrao
        await TesteConexao("Teste Padrao", new HttpClient());

        // 2. Teste com User-Agent 'Mozilla'
        var clientMozilla = new HttpClient();
        clientMozilla.DefaultRequestHeaders.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36");
        await TesteConexao("User-Agent Mozilla", clientMozilla);

        // 3. Teste ignorando SSL (Simulado)
        var handler = new HttpClientHandler();
        handler.ServerCertificateCustomValidationCallback = (message, cert, chain, errors) => true;
        var clientNoSSL = new HttpClient(handler);
        await TesteConexao("Ignorando SSL", clientNoSSL);

        // 4. Teste com Autenticacao de Proxy
        var handlerProxy = new HttpClientHandler();
        if (handlerProxy.SupportsProxy) {
             Console.WriteLine("Proxy suportado. Configurando credenciais padrao...");
             handlerProxy.DefaultProxyCredentials = System.Net.CredentialCache.DefaultCredentials;
        }
        var clientProxy = new HttpClient(handlerProxy);
        await TesteConexao("Com Proxy Auth", clientProxy);

        // 5. Teste SEM Proxy (Bypass)
        var handlerNoProxy = new HttpClientHandler();
        handlerNoProxy.UseProxy = false;
        var clientNoProxy = new HttpClient(handlerNoProxy);
        await TesteConexao("Sem Proxy (Direct)", clientNoProxy);
    }

    static async Task TesteConexao(string nomeTeste, HttpClient client)
    {
        Console.WriteLine($"\n--- {nomeTeste} ---");
        try
        {
            var url = "https://economia.awesomeapi.com.br/last/USD-BRL";
            Console.WriteLine($"Tentando GET: {url}");
            
            var response = await client.GetAsync(url);
            Console.WriteLine($"Status Code: {response.StatusCode}");
            
            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                Console.WriteLine($"Sucesso! Conteudo (primeiros 50 chars): {content.Substring(0, Math.Min(50, content.Length))}");
            }
            else
            {
                Console.WriteLine("Falha na requisicao.");
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"EXCECAO: {ex.GetType().Name}");
            Console.WriteLine($"Mensagem: {ex.Message}");
            if (ex.InnerException != null)
            {
                Console.WriteLine($"Inner Exception: {ex.InnerException.Message}");
            }
        }
    }
}
