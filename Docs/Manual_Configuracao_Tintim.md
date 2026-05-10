# Manual de Operação: Configuração da Integração Tintim x IDA

Este manual descreve o passo a passo de como obter os tokens de segurança na plataforma Tintim e como vinculá-los ao IDA, garantindo que a comunicação entre os dois sistemas funcione perfeitamente para seus números de WhatsApp.

---

## 1. Entendendo os Parâmetros da Integração
Para que o Tintim e o IDA conversem de forma segura e exclusiva, a documentação da API aponta a necessidade de duas chaves principais por "conta":
* **ACCOUNT_CODE:** O código identificador único da sua conta/instância.
* **ACCOUNT_TOKEN:** A chave de segurança (senha) que autentica sua conta para enviar e receber dados.

> **Importante:** No ecossistema do Tintim, cada número de WhatsApp conectado pode representar uma conta/instância separada (ex: um número para Vendas, outro para Suporte).

## 2. Onde e Como Localizar os Tokens no Tintim?
A documentação do Tintim indica que esse processo é feito diretamente no painel deles. Siga os passos abaixo:

1. Faça login no painel web do **Tintim** utilizando um perfil de Administrador.
2. No menu principal, navegue até a seção **INFORMAÇÕES DO CLIENTE**.
3. Nesta tela (ou na aba "Outras Informações"), você encontrará claramente o Código da Conta (`ACCOUNT_CODE`) e o Token de Segurança (`ACCOUNT_TOKEN`).
4. **Múltiplos Números (Dica):** Caso você opere com mais de um número de telefone no Tintim, verifique no painel se as chaves fornecidas mudam quando você alterna a visualização entre os números. Anote o código e token correspondente de cada número que você deseja integrar.

## 3. Configurando a Transmissão de Dados (Webhook no Tintim)
Para que o Tintim saiba para onde enviar os dados automaticamente (o "envio orgânico" que substituirá o trabalho manual):

1. Ainda no painel do Tintim, procure pela opção de **Webhooks** ou **Integrações Personalizadas**.
2. O sistema do Tintim vai solicitar que você insira uma **URL do Webhook**.
3. Você irá colar a URL gerada pelo sistema IDA quando a implementação estiver concluída. 
   *(Exemplo fictício: `https://api.seusistema-ida.com.br/api/webhooks/tintim`)*.
4. Salve as configurações. Caso haja um botão de "Testar Conexão" ou "Enviar Ping", utilize-o para garantir que os sistemas estão se "enxergando".

## 4. Como o IDA vai receber essas chaves? (Ações Pós-Desenvolvimento)
Quando iniciarmos o desenvolvimento, a arquitetura do IDA precisará armazenar essas chaves para poder fazer requisições ativas ao Tintim. Teremos dois caminhos, dependendo da sua operação:

* **Cenário A (Apenas 1 número integrado):**
  Nossa equipe de desenvolvimento armazenará esse `ACCOUNT_CODE` e `ACCOUNT_TOKEN` em um arquivo fechado no servidor (`appsettings.json` ou Variáveis de Ambiente do Azure/AWS). É a forma mais rápida e segura para operações centralizadas em um único WhatsApp.

* **Cenário B (Múltiplos números no Tintim):**
  Se a sua empresa usar 2 ou mais números independentes para captação, criaremos uma tela nova dentro das **Configurações do IDA**. Nessa tela, você poderá cadastrar:
  * O número de telefone (ex: `5511999999999`)
  * O `ACCOUNT_CODE` desse número
  * O `ACCOUNT_TOKEN` desse número
  Dessa forma, o próprio IDA consegue gerenciar inteligentemente qual token usar quando precisar atualizar um lead pertencente a uma filial/número específico.

---

### Resumo do seu Fluxo de Trabalho (Go-Live)
Quando o desenvolvimento for finalizado, seu único trabalho gerencial será a clássica operação de "copiar e colar":
1. **Copiar** o Token no Tintim e **Colar** nas chaves do IDA.
2. **Copiar** a URL do Webhook do IDA e **Colar** na configuração de disparo do Tintim.
3. Ligar a chave. A partir desse segundo, os leads de campanhas começam a brotar automaticamente no CRM do IDA.
