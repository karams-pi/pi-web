# Manual do Usuário - Sistema Pi Web

## 1. Visão Geral
Bem-vindo ao sistema Pi Web. Este sistema foi desenvolvido para gerenciar Cotações, Proforma Invoices (PI) e Tabelas de Preços para exportação de móveis.
O foco principal é automatizar cálculos complexos de conversão de moeda, comissões e rateio de frete.

---

## 2. Acesso e Menus
Ao acessar o sistema, você encontrará o menu lateral (ou menu hambúrguer em dispositivos móveis) com as seguintes opções:
- **Dashboad/Home**: Visão geral.
- **Cadastros**: Clientes, Fornecedores, Marcas, Tecidos.
- **Produtos**: Módulos e Tabelas de Preços.
- **Comercial**: **Proforma Invoice** (Módulo Principal).
- **Configurações**: Ajustes globais de taxas e cotações.

---

## 3. Cadastros Básicos
Antes de gerar uma PI, certifique-se de que os dados base estão cadastrados:
1.  **Clientes**: Quem está comprando.
2.  **Fornecedores**: As fábricas (ex: Karam's).
3.  **Configurações**: Onde você define a **"Redução Dólar"** e a **"Comissão"** padrão.

---

## 4. Importação de Tabelas (Preços)
Para que o sistema consiga calcular os valores, é necessário importar as tabelas de preços dos fornecedores.
1.  Vá em **Importação**.
2.  Selecione o Fornecedor (ex: Karam's).
3.  Escolha o arquivo Excel (`.xlsm` ou `.xlsx`).
4.  Clique em **Importar**.
    *   *Nota*: O sistema lê automaticamente as abas como "Categorias", ignora cabeçalhos repetidos e mapeia os preços dos tecidos.

---

## 5. Proforma Invoice (PI) - Detalhado
Esta é a tela mais importante do sistema. Aqui explicaremos exatamente como cada valor é calculado.

### 5.1. Cabeçalho da PI
Ao iniciar uma nova PI, você preenche:
*   **Cliente**: Selecione o comprador.
*   **Frete**: Selecione o tipo de frete (Container 40ft, Truck, etc). O sistema puxa o valor total do frete automaticamente.
*   **Data/Prefixo**: Dados de identificação.

### 5.2. Cotações e Moedas
O sistema trabalha com um conceito de **Dólar Risco** para proteger a exportação de flutuações cambiais.

*   **Cotação Atual USD**: O sistema busca automaticamente via API (ex: Banco Central/Economia) o valor do dólar comercial do dia.
*   **Cotação Risco (Cálculo)**:
    > Formula: `Cotação Risco = Cotação Atual - Valor de Redução`
    *   *Exemplo*: Se o Dólar está R$ 5,00 e na tela de Configurações a Redução é R$ 0,20, o sistema usará **R$ 4,80** para converter os preços de tabela. Isso cria uma "gordura" de segurança.

---

### 5.3. Adicionando Itens e Cálculos (EXW)
Ao adicionar um produto (Módulo + Tecido), o sistema faz os seguintes cálculos matemáticos em tempo real:

#### A. Leitura do Preço Base
O sistema busca no banco de dados o preço do Módulo naquele Tecido específico (valor em Reais - BRL/Tabela).

#### B. Conversão para Dólar (Valor Base)
Converte o preço de tabela para Dólar usando a Cotação Risco.
> Formula: `Valor Base USD = Preço Tabela BRL / Cotação Risco`

#### C. Aplicação de Comissão (Valor EXW)
Adiciona a porcentagem de comissão configurada sobre o valor base.
> Formula: `Valor EXW = Valor Base USD + (Valor Base USD * % Comissão)`
*   **O que é EXW?**: *Ex Works*. Significa o preço da mercadoria na fábrica, já em Dólar e com sua comissão, sem contar o frete.

---

### 5.4. Cálculo do Frete e Rateio (Volume m³)
O custo do frete (ex: valor do Container) não é dividido igualmente por "quantidade de itens", mas sim pelo **Volume (m³)** que cada item ocupa. Quem ocupa mais espaço, paga mais frete.

1.  **Cálculo do Volume Total**: Soma-se o m³ de todos os itens da PI.
2.  **Custo por m³**:
    > Formula: `Custo por m³ = Valor Total Frete USD / Volume Total m³ da PI`
3.  **Frete Unitário do Item**:
    > Formula: `Frete Unitário = Custo por m³ * m³ do Item`

---

### 5.5. Valor Final do Item (DDP/CIF Aprox)
O valor final apresentado (em Dólar Risco) é a soma do produto com sua parcela do frete.
> Formula: `Total USD = (Valor EXW + Frete Unitário USD) * Quantidade`

---

### 5.6. Impressão
Ao clicar em **Imprimir**, o sistema gera um layout otimizado para PDF, listando:
*   Foto do produto (se houver).
*   Descrição completa.
*   Dimensões e Volume.
*   Valores unitários e totais em Dólar.

---

## 6. Fluxo de Trabalho Recomendado
1.  Atualize a **Cotação Atual** (automático) e verifique a **Redução** nas Configurações.
2.  Importe a tabela atualizada do fornecedor (se houve mudança de preços).
3.  Crie a PI, selecione o Cliente e Frete.
4.  Lance os itens.
5.  O sistema calculará automaticamente o **EXW** e fará o **Rateio do Frete**.
6.  Imprima ou exporte a PI para enviar ao cliente.
