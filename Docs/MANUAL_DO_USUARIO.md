# Manual do Usuário - Sistema Pi Web (Módulo PI)

Este manual de instruções foi elaborado para orientar os analistas e assistentes comerciais no uso completo do módulo de **Proforma Invoice (PI)**. A Proforma Invoice serve como orçamento formal de exportação de estofados e móveis das indústrias parceiras.

---

## 1. Visão Geral e Arquitetura de Dados

O módulo PI centraliza as operações comerciais, unificando dados cadastrais e regras de precificação internacionais para gerar faturas proforma em Dólar (USD) de forma precisa e automatizada.

O sistema integra:
*   **Clientes**: Cadastro de importadores internacionais, incluindo contatos, e-mails e endereços de destino.
*   **Fornecedores**: Indústrias nacionais (Karam's, Koyo, Ferguile, Livintus) com dados bancários internacionais e Incoterms preferenciais.
*   **Módulos e Tecidos**: A combinação estrutural dos produtos que define a precificação de tabela (BRL).
*   **Configurações de Margem e Câmbio**: Parâmetros globais de markups, comissões e cotações.

---

## 2. Cadastro de Fornecedores e Dados Bancários

Os dados bancários das fábricas brasileiras estão pré-configurados no sistema para viabilizar transferências internacionais diretas (Swift / IBAN).

1.  **Fornecedores Integrados**:
    *   **Karam's e Koyo**: Integrados ao Banco Rendimento S/A e Bank of America, N.A. (banco intermediário).
    *   **Ferguile e Livintus**: Integrados ao Sicredi (Banco Cooperativo Sicredi S/A).
2.  **Incoterms Padrão**: As fábricas de estofados operam prioritariamente em condições FOB ou EXW, as quais são associadas automaticamente no momento de criação de um novo estudo comercial.

---

## 3. Configurações Globais e o Conceito de "Dólar Risco"

A flutuação cambial exige proteção financeira para que a indústria mantenha suas margens de lucro durante o ciclo produtivo da exportação.

### 3.1. Cotação do Dólar Comercial
O sistema busca em tempo real a cotação oficial comercial do dia.

### 3.2. Cotação Risco (Dólar Risco)
É o câmbio oficial de conversão de preços de tabela da PI. Ela varia de acordo com as regras operacionais de cada fornecedor:

1.  **Karam's e Koyo (Cálculo Dinâmico)**:
    $$\text{Cotação Risco} = \text{Cotação Comercial Atual} - \text{Valor de Redução}$$
    *   *Exemplo*: Se o dólar comercial está a R$ 5,30 e nas Configurações a redução é R$ 0,30, a Proforma converterá os preços utilizando **R$ 5,00**.
2.  **Ferguile e Livintus (Cotação Fixa)**:
    O campo "Valor de Redução" nas Configurações Globais é interpretado como uma cotação **fixa e final**.
    *   *Exemplo*: Se o "Valor de Redução" estiver cadastrado como R$ 4,80, a cotação risco será travada em **R$ 4,80**, ignorando a flutuação comercial diária.

---

## 4. Geração de Proforma Invoice (Passo a Passo)

### Passo 1: Cabeçalho do Documento
1.  Acesse o módulo comercial e clique em **Nova PI** na tela `ProformaInvoiceV2Page.tsx`.
2.  Preencha as seguintes informações obrigatórias:
    *   **Cliente**: Selecione a empresa compradora.
    *   **Fornecedor (Fábrica)**: Define o padrão de dados bancários e de câmbio (dinâmico ou fixo).
    *   **Tipo de Frete**: Selecione a modalidade logística (Container 40ft, Truck, EXW, etc.). O sistema carregará o custo logístico total associado no banco.
    *   **Moeda de Exibição**: Escolha se a via impressa apresentará valores em USD ou BRL.

### Passo 2: Adicionando Itens
1.  Utilize o seletor premium combinando **Módulo + Tecido**.
2.  Defina a **Quantidade** do produto.
3.  O sistema exibe e permite ajustar pontualmente:
    *   **Dimensões**: Largura, Profundidade e Altura (em centímetros).
    *   **Volume Cubado (m³)**: O volume é calculado automaticamente:
        $$\text{Volume (m³)} = \frac{\text{Largura} \times \text{Profundidade} \times \text{Altura}}{1.000.000}$$
    *   **Peso**: Exibição dinâmica de carga.
    *   **Campos de customização**: Adicione observações sobre os pés do estofado (`Feet`), acabamentos (`Finishing`) ou avisos gerais.

---

## 5. Engine de Cálculo (A Matemática da PI)

A cada alteração na quantidade ou no tipo de item, a engine realiza o seguinte processamento em lote em menos de 100 milissegundos:

### 5.1. Conversão Base para Dólar (USD)
$$\text{Valor Base USD} = \frac{\text{Preço Tabela BRL}}{\text{Cotação Risco}}$$

### 5.2. Preço de Fábrica (EXW Unitário USD)
O preço EXW adiciona os percentuais de comissão e gordura (margem extra) configurados sobre o valor convertido:
$$\text{EXW USD} = \text{Valor Base USD} \times \left(1 + \frac{\text{Comissão \%}}{100} + \frac{\text{Gordura \%}}{100}\right)$$

### 5.3. Rateio do Frete Internacional (m³)
Para evitar que peças pequenas paguem a mesma logística que peças volumosas, o custo total do frete contratado é dividido proporcionalmente ao volume cúbico (m³) individual do produto:
1.  **Fator de Custo por m³**:
    $$\text{Fator por m³} = \frac{\text{Valor Total Frete USD}}{\text{Volume Total m³ da PI}}$$
2.  **Frete Unitário do Item**:
    $$\text{Frete do Item USD} = \text{Fator por m³} \times \text{Volume m³ do Item}$$

### 5.4. Valor Final do Item
$$\text{Preço Final USD} = \text{EXW USD} + \text{Frete do Item USD}$$

---

## 6. Impressão e Exportação

1.  **Impressão de PDF**:
    *   O botão **Imprimir** formata as especificações com layout comercial limpo e otimizado para papel A4, ocultando menus e ferramentas do sistema.
    *   Marcas como a **Ferguile** possuem um template específico (`PrintPiFerguilePage.tsx`) contendo logomarcas próprias e instruções bancárias exclusivas.
2.  **Exportação para Excel (XLSX)**:
    *   Gera uma planilha com a identidade da marca, fórmulas ativas nas linhas de preço, volumes e rateios de frete. Isso permite que eventuais alterações manuais na planilha recalculem os totais de forma coerente.

---

## 7. Resolução de Problemas (FAQ)

### P: Por que os botões "Salvar" ou "Descartar" sumiram da tela de modais?
**R:** Isso ocorria anteriormente em notebooks ou telas menores por limitação de altura da janela de diálogo. Implementamos limites de altura (`max-height`) e barras de rolagem customizadas automáticas na classe `.modal-content` do CSS global do sistema, permitindo visualizar os botões rolando a tela.

### P: Como ajustar a comissão de uma PI específica sem afetar o padrão geral?
**R:** O percentual de comissão pode ser editado individualmente no painel lateral direito da tela de edição da PI, alterando apenas a negociação atual sem modificar as Configurações Globais do sistema.

### P: Por que o frete unitário do produto mudou quando adicionei outro item?
**R:** Como o rateio de frete baseia-se na cubagem total da PI, adicionar ou remover produtos altera o volume cúbico total da carga, o que recalcula a proporção de custo de transporte alocada a cada peça.
