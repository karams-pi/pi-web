# Análise Detalhada do Sistema EDC (Estudo de Custos)

Este documento descreve os requisitos técnicos e funcionais para o novo módulo de **Importação (EDC)**, baseado na análise da planilha `EDC - RALLI - 11-03-2026.xlsx`.

## 1. Arquitetura de Dados (Schema `edc`)

Para o EDC ser funcional, o modelo de dados deve ser isolado no schema `edc` e contemplar tanto a inteligência de cálculo quanto a infraestrutura de cadastros.

### A. Cadastros Base (Master Data)
1.  **Importadores**: Diferente dos clientes da PI, aqui cadastramos empresas nacionais com foco em **CNPJ, Inscrição Estadual e UF**. É o ponto de partida para o cálculo de ICMS.
2.  **Exportadores**: Cadastro de fornecedores internacionais. Inclui **Tax ID, País de Origem e Moeda de Negociação**.
3.  **Catálogo de Produtos EDC**: Itens focados em atributos logísticos: **NCM (obrigatório), Peso Líquido, Peso Bruto e M³ (Cubagem)**.
4.  **Tabela de Portos/Aeroportos**: Lista de recintos alfandegados de origem e destino (ex: Shanghai -> Paranaguá).

### B. Inteligência Fiscal e Taxas
1.  **Ncms (Nomenclatura Comum do Mercosul)**: Tabela centralizadora de alíquotas (II, IPI, PIS, COFINS).
2.  **Regras de ICMS**: Tabela por UF (Estado) contendo a alíquota interna e o Fundo de Combate à Pobreza (FCP).
3.  **Dicionário de Taxas Aduaneiras**: Configuração de taxas padrão (Siscomex, BL Release, THC, Scanner) que o sistema sugere automaticamente em cada novo EDC.

### C. Processo de EDC (Estudo de Custos)
1.  **Simulacoes**: Cabeçalho do estudo com dados financeiros (Câmbio, Spread, Tipo de Frete).
2.  **Itens da Simulacao**: Lista de produtos sendo orçados.
3.  **Despesas da Simulacao**: Lista de taxas e fretes aplicados àquela carga específica.

## 2. Menus e Navegação do Módulo EDC

O menu lateral deve ser completamente diferente do PI quando o usuário estiver no módulo de Importação:

- **Dashboard EDC**: Resumo de simulações e indicadores de custo médio por NCM.
- **Simulações (Estudos)**: Listagem e criação de novos estudos de custo.
- **Catálogo de NCMs**: Gestão das alíquotas de importação por código.
- **Tabelas de Taxas**: Configuração de taxas portuárias e honorários de despachante.
- **Configurações Fiscais**: Regras de ICMS por estado e regimes (Simples, Real, Presumido).
- **Calculadora de Câmbio**: Consulta rápida e histórico de paridade USD/BRL.

## 3. Lógica de Cálculo (A Engine Financeira)

O sistema deve replicar a complexidade da planilha, seguindo esta ordem:

### Passo 1: Valor Aduaneiro
`Valor Aduaneiro (BRL) = (Soma FOB USD + Frete USD + Seguro USD) * Taxa de Câmbio`

### Passo 2: Impostos Federais
1.  **II**: `Valor Aduaneiro * %II`
2.  **IPI**: `(Valor Aduaneiro + II) * %IPI`
3.  **PIS**: `Valor Aduaneiro * %PIS`
4.  **COFINS**: `Valor Aduaneiro * %COFINS`

### Passo 3: Taxas e Despesas (Rateio)
O sistema deve suportar os seguintes métodos de rateio para as taxas (ex: Siscomex, THC, Frete):
- **Por Valor**: Proporcional ao valor FOB de cada item.
- **Por Quantidade**: Dividido igualmente pela quantidade de peças.
- **Por Peso/Volume**: (Melhoria sugerida) baseado na ocupação do container.

### Passo 4: ICMS (Cálculo "Por Dentro")
`Base ICMS = (Valor Aduaneiro + II + IPI + PIS + COFINS + Taxas Aduaneiras + Outras Despesas) / (1 - %ICMS)`
`Valor ICMS = Base ICMS * %ICMS`

## 4. Requisitos de Interface (UI/UX)

- **Input de Itens**: Deve permitir a importação de uma lista de itens via Excel (para evitar digitar 50 itens manualmente).
- **Memória de Cálculo**: Cada item na simulação deve ter um botão "Ver Detalhes" que mostra exatamente como cada centavo de imposto foi calculado (transparência total).
- **Comparativo**: Opção de comparar a mesma carga com diferentes taxas de câmbio (Dólar a 5.00 vs 5.50).

## 5. Próximos Passos Técnicos

1.  Criação das Migrations no Entity Framework para o schema `edc`.
2.  Desenvolvimento dos Controllers sob o prefixo `/api/edc/`.
3.  Implementação do componente de cálculo centralizado para garantir precisão decimal (8 casas decimais durante o cálculo, 2 no arredondamento final).
