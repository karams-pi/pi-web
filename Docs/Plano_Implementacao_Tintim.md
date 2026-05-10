# Prompt de Implementação: Integração Tintim (Webhooks) no IDA

## Objetivo
Implementar a integração de dados via Webhooks do sistema Tintim para alimentar o IDA com informações de campanhas de mídias sociais (orgânicas e pagas) e dados dos leads. **A partir dessa implementação, o cadastro manual de leads no IDA será totalmente descontinuado, passando a ser 100% automatizado via integração.**

## Instruções para a IA (Prompt de Execução)
Quando eu solicitar a execução deste plano, você deverá atuar como um Desenvolvedor Full-Stack (C# .NET Core, EF Core, React, TypeScript) e executar rigorosamente as fases abaixo, confirmando comigo a conclusão de cada etapa antes de avançar para a próxima. O objetivo não é apenas criar o código, mas garantir que toda a arquitetura faça sentido.

---

### Fase 1: Banco de Dados e Modelagem (Backend - EF Core)

**1. Criação das Entidades (Models):**
Criar as seguintes entidades no `[IDA.Backend]/Models` e mapeá-las no `AppDbContext`. Note a presença do `ClienteId` para garantir o vínculo com a base atual:
*   `TintimLead`:
    *   `Id` (Guid, PK)
    *   `ClienteId` (Guid, FK nullable) -> Vínculo com a tabela `Cliente` existente no IDA.
    *   `Name` (string)
    *   `Phone` (string, formato E164)
    *   `LocationCountry` (string)
    *   `LocationState` (string)
    *   `StatusId` (string)
    *   `StatusName` (string)
    *   `SaleAmount` (decimal, nullable)
    *   `SaleDatetime` (DateTime, nullable)
    *   `CreatedAt` (DateTime)
    *   `UpdatedAt` (DateTime)
*   `TintimLeadSourceAd` (Para armazenar dados de Campanhas de Ads / Mensagem Rastreável):
    *   `Id` (Guid, PK)
    *   `LeadId` (Guid, FK)
    *   `AdAccountId` (string)
    *   `CampaignId` (string)
    *   `CampaignName` (string)
    *   `AdsetId` (string)
    *   `AdsetName` (string)
    *   `AdId` (string)
    *   `AdName` (string)
    *   `AmountSpent` (decimal, nullable) -> Valor capturado automaticamente do Tintim referente ao gasto com esse anúncio específico.
*   `TintimLeadSourceOrganic` (Para armazenar dados de Links rastreáveis / UTMs):
    *   `Id` (Guid, PK)
    *   `LeadId` (Guid, FK)
    *   `UtmSource` (string)
    *   `UtmMedium` (string)
    *   `UtmCampaign` (string)
    *   `UtmTerm` (string)
    *   `UtmContent` (string)
    *   `BrowserFamily` (string)
    *   `DeviceType` (string)
    *   `OsFamily` (string)

**2. Relacionamentos no DbContext:**
Configurar as relações `HasOne` / `WithMany` no `AppDbContext` para que `TintimLead` possua relacionamento com `Cliente` (do IDA) e com suas origens de anúncio/orgânico.

**3. Migrations:**
Gerar a migration no EF Core e atualizar o banco de dados.

---

### Fase 2: Backend (Processamento dos Webhooks e Vínculo de Clientes)

**1. DTOs de Recebimento:**
Criar os DTOs em `[IDA.Backend]/DTOs/Tintim` que espelhem exatamente a estrutura hierárquica do JSON (payload) detalhada na documentação do Tintim (incluindo o objeto de `visit`, `ad` e propriedades raiz como `event_type`).

**2. Serviços de Negócio (`TintimWebhookService`):**
Criar `ITintimWebhookService` e `TintimWebhookService` em `[IDA.Backend]/Services`. O fluxo de processamento deve seguir obrigatoriamente estas regras:
*   **Vínculo e Criação Automática do Cliente (B2B):** O sistema não usará o telefone do lead para o cadastro do cliente do IDA. Em vez disso, ele usará o objeto `"account"` (ex: `"code": "123", "name": "BIANCHI MATRIZ"`) vindo do Tintim. O IDA vai buscar na tabela `Cliente` se já existe uma empresa com esse nome/código. **Se não encontrar, o sistema deve OBRIGATORIAMENTE criar um novo registro na tabela `Cliente` usando o nome da conta do Tintim.** Isso garantirá o cadastro automático do lojista/empresa. Em seguida, o `TintimLead` (o consumidor final do WhatsApp) será salvo e vinculado ao `ClienteId` desta empresa.
*   Se `event_type == "lead.create"`, inserir novo `TintimLead`.
*   Se `event_type == "lead.update"`, atualizar o status atual do `TintimLead` (e registrar a venda se `sale_amount` for maior que zero).
*   **Captação de Investimento em Ads:** Verificar no payload: Se o nó `"ad"` estiver preenchido, preencher e salvar `TintimLeadSourceAd`, **garantindo a captura do campo `amount_spent`** para automatizar o rastreio do investimento. Se o nó `"visit"` possuir UTMs, preencher e salvar `TintimLeadSourceOrganic`.

**3. Controller Exposto:**
Criar `TintimWebhookController` em `[IDA.Backend]/Controllers`:
*   Endpoint `POST /api/webhooks/tintim`.
*   Adicionar mecanismo simples de validação (ex: token no Header) para evitar que usuários externos injetem dados falsos.

---

### Fase 3: Backend (Endpoints para Consumo do Frontend IDA)

**1. Política de Zero Impacto nos Relatórios Atuais:**
*   **Garantia Arquitetural:** Os Dashboards e Relatórios que já existem no IDA (como vendas, listagens, métricas) **não devem ser modificados neste primeiro momento**, garantindo que não quebrem. As novas tabelas funcionarão em paralelo.
*   **Evolução Opcional:** Caso o usuário deseje, relatórios de vendas antigos poderão ser atualizados via `JOIN` utilizando o `ClienteId` para cruzar vendas passadas com as origens de marketing captadas agora.

**2. Novos Endpoints de Consulta e Relatórios (Módulo Marketing):**
*   `GET /api/tintim/leads`: Endpoint paginado para listar os contatos cruzando a tabela principal com as tabelas de origem.
*   `GET /api/tintim/dashboard/metrics`: Endpoint para fornecer dados resumidos focados em **Origem/Canais** (ex: Volume de Leads por Origem [Meta, Google, Orgânico, Não Rastreado], e ROI agrupado por Origem cruzando vendas vs o `amount_spent` dos Ads). O backend deduzirá a origem verificando a presença do objeto `ad` (Meta) ou lendo o `utm_source` (Google/Outros).

---

### Fase 4: Frontend (React / TypeScript - Visão do Usuário no IDA)

**1. Descontinuações e Mudanças de Paradigma:**
*   **Fim do Cadastro Manual de Leads:** A tela antiga de cadastro manual de leads/contatos deverá ser desabilitada, pois a captação agora é 100% automática via API.
*   **Fim do Controle por Vendedor:** Como a captação e classificação passa a ser automatizada pelo robô, o controle de qual "Vendedor" (atendente) está tratando o lead cai em desuso neste módulo. O foco do relatório passa a ser estritamente a performance da **Origem** (Meta, Google) e não a performance individual do vendedor.
*   **Atenção aos Investimentos Globais:** O lançamento manual ficará restrito *apenas* a investimentos de marketing globais (orçamentos gerais não atrelados a um anúncio rastreado).

**2. Interface: Gestão de Leads (Leads CRM):**
*   Criar página `TintimLeadsPage.tsx`.
*   Construir uma tabela robusta (Nome, Telefone, Cliente IDA Vinculado, Origem, Nome da Campanha, Status no Funil e Valor de Venda).
*   Implementar filtros visuais no topo para busca rápida.

**3. Interface: Dashboard de Mídias (Analytics) - Padrão Tintim:**
*   Criar página `TintimAnalyticsDashboard.tsx` utilizando os componentes visuais e o padrão de design (UI) atual do IDA.
*   **Filtros Globais no Topo:** Implementar filtros de "Intervalo de Datas" (Date Range Picker) e "Origens" para controlar todos os gráficos da tela simultaneamente.
*   **Visão Geral (Gráfico de Rosca/Donut):** Mostrar o total de conversas ativas, exibindo a proporção percentual entre conversas "Rastreadas" (Meta/Google) e "Não Rastreadas".
*   **Origem das Conversas (Gráfico de Barras Empilhadas):** Exibir a evolução diária (linha do tempo). Cada barra de um dia será dividida internamente pelas cores de Meta, Google, Outras Origens e Não Rastreadas.
*   **Funil da Jornada de Compra:** Criar um gráfico de funil visual mostrando a taxa de quebra/conversão entre as etapas (ex: Fez Contato -> Orçamento -> Venda).
*   **Performance de Vendas:** Cards exibindo "Total de Vendas" e "Faturamento Total (R$)", seguidos de um gráfico na linha do tempo para vendas aprovadas.

**4. Roteamento e Menu:**
*   Criar um menu lateral chamado "Marketing" ou "Leads Integrados" para abrigar esse novo ecossistema.

---

### Fluxo de Trabalho do Usuário (Comportamento Esperado)

1. **Setup Inicial (Única Vez):** A URL do webhook gerada no IDA é colada no painel do Tintim.
2. **Automação 100%:** O usuário não precisa mais digitar leads na mão. Tudo que chegar via anúncio ou orgânico cai no banco do IDA automaticamente.
3. **Vínculo Inteligente:** O IDA automaticamente identifica se aquele telefone já é um Cliente existente e une a ficha de marketing com a ficha de vendas do ERP.
4. **Captura de Investimentos:** O sistema lê sozinho quanto o Facebook cobrou daquele anúncio e já coloca nos custos da campanha.
5. **Acompanhamento no IDA:** O gerente acessa o menu "Marketing", vê o funil em tempo real, os gastos parciais e o faturamento sem precisar abrir nenhuma planilha ou o painel do Facebook Ads. Lançamentos manuais ocorrem apenas para custos de marketing globais extras.
