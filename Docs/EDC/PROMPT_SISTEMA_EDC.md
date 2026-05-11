# PROMPT MESTRE: Construção do Módulo EDC (Estimativa de Custos)

Você é um desenvolvedor Senior Fullstack especializado em sistemas de Comércio Exterior (COMEX). Sua tarefa é implementar o módulo **EDC** dentro do ecossistema `pi-web` existente.

## 1. Contexto Técnico
- **Arquitetura**: Monolito Modular.
- **Backend**: .NET 8, EF Core, PostgreSQL.
- **Frontend**: React, TypeScript, Vite.
- **Identificação**: Todas as rotas de API devem usar `/api/edc/` e as rotas de frontend `/edc/`.
- **Banco de Dados**: Usar exclusivamente o schema `edc`.

## 2. Estrutura do Banco de Dados (Schema `edc`)
Crie as seguintes tabelas com Entity Framework Migrations, garantindo isolamento total do schema `pi`:

### A. Cadastros de Apoio (Master Data)
1.  **`Importadores`**: `Id, RazaoSocial, Cnpj, InscricaoEstadual, UF (Estado), RegimeTributario (Simples, Real, Presumido), AliquotaIcmsPadrao, FlAtivo`.
2.  **`Exportadores`**: `Id, Nome, Pais, Endereco, TaxId (VAT), Contato, FlAtivo`.
3.  **`Produtos`**: `Id, Referencia, Descricao, IdNcm (FK), PesoLiquido, PesoBruto, CubagemM3, UnidadeMedida (UN, KG, PC), PreçoFobBase`.
4.  **`Ncms`**: `Id, Codigo (8 dígitos), Descricao, AliquotaII, AliquotaIPI, AliquotaPis, AliquotaCofins, AliquotaIcmsPadrao`.
5.  **`Portos`**: `Id, Nome, Sigla, Pais, Tipo (Maritimo, Aereo, Rodoviario)`.

### B. Configurações e Taxas
6.  **`TaxasAduaneiras`**: `Id, Nome, ValorPadrao, Moeda (USD/BRL), Tipo (Fixo/Percentual)`.
7.  **`ConfiguracoesFiscais`**: `Id, UF, AliquotaIcms, AliquotaFCP, IsencaoIPI (bool)`.

### C. Processo de Estudo de Custos (EDC)
8.  **`Simulacoes`**: 
    - `Id, NumeroReferencia, DataEstudo, IdImportador, IdExportador, IdPortoOrigem, IdPortoDestino`.
    - `CotacaoDolar, SpreadCambio, IdTipoFrete (FOB/CIF), ValorFreteInternacional, ValorSeguro`.
    - `Status (Rascunho, Aprovado, Arquivado)`.
9.  **`SimulacaoItens`**: `Id, IdSimulacao, IdProduto, Quantidade, ValorFobAcordado, PesoTotalCalculado, CubagemTotalCalculada`.
10. **`SimulacaoDespesas`**: `Id, IdSimulacao, NomeDespesa, Valor, Moeda, MetodoRateio (Valor FOB, Quantidade, Peso, Volume)`.

## 3. Menus do Frontend (Sidebar EDC)
Ao entrar no módulo EDC, a Sidebar deve mudar para:
- **Dashboard**: Resumo de custos.
- **Novo Estudo**: Wizard de criação de EDC.
- **Meus Estudos**: Listagem de simulações salvas.
- **Tabelas de Apoio**: Submenu com NCMs, Taxas Portuárias e Configurações Fiscais.

## 4. Engine de Cálculo (Requisito Crítico)
A classe de serviço `EdcCalculationService` deve implementar:

1.  **Valor Aduaneiro**: `(ValorFOB + FreteInternacional + Seguro) * (Cotacao + Spread)`.
2.  **Base de Cálculo Cascata**:
    - `II = ValorAduaneiro * Ncm.AliquotaII`
    - `IPI = (ValorAduaneiro + II) * Ncm.AliquotaIPI`
    - `PIS/COFINS`: Alíquotas aplicadas sobre o Valor Aduaneiro.
3.  **ICMS "Por Dentro"**:
    - `BaseICMS = (ValorAduaneiro + II + IPI + PIS + COFINS + SomaTaxasAduaneiras) / (1 - AliquotaIcms)`.
4.  **Rateio de Despesas**:
    - Implementar métodos para distribuir custos fixos (ex: Honorário Despachante) entre os itens baseando-se no critério escolhido (Valor ou Qtd).

## 5. Funcionalidades de UI Específicas
- **Upload de Itens**: Componente para processar arquivo Excel de itens.
- **Visualizador de Impostos**: Tooltip ou modal que mostra a memória de cálculo de cada item.
- **Relatório de Estudo de Custos**: Geração de PDF premium com o resumo financeiro (Total FOB, Total Impostos, Total Despesas, Preço Unitário Nacionalizado).

## 6. Instruções de Implementação
- Comece criando as pastas `backend/Pi.Api/Controllers/Edc` e `frontend/pi-ui/src/pages/edc`.
- Garanta que a `buildUrl` no frontend suporte o prefixo `/edc/` para chamadas de API.
- Utilize o componente `SearchableSelect` para seleção de NCMs.
- Mantenha o design system "Glassmorphism" já implementado no portal de seleção.
