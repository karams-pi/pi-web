# Manual do Usuário - Módulo EDC (Estudo de Custos)

Bem-vindo ao módulo **EDC** do sistema PI-Web. Este manual descreve as funcionalidades de inteligência de importação, projetadas para transformar simulações complexas em decisões estratégicas.

---

## 1. Visão Geral
O módulo EDC (Estimativa de Custos) permite realizar a simulação completa da nacionalização de produtos importados. O sistema automatiza o cálculo de impostos federais e estaduais (ICMS), taxas portuárias e despesas logísticas, gerando o custo unitário nacionalizado final.

## 2. Fluxo de Operação (Passo a Passo)

### Passo 1: Manutenção de Tabelas (Dados Mestres)
Antes de criar um estudo, certifique-se de que os dados de apoio estão atualizados no menu **"Tabelas de Apoio"**:
- **Catálogo de NCMs**: Cadastre os códigos NCM (8 dígitos) e suas respectivas alíquotas de II, IPI, PIS e COFINS.
- **Taxas Aduaneiras**: Configure os valores padrão de taxas portuárias (Siscomex, THC, Despacho). Esses valores serão sugeridos em cada nova simulação.
- **Configurações Fiscais**: Defina a alíquota de ICMS para cada estado (UF) de destino da carga.

### Passo 2: Cadastro de Parceiros e Produtos
- **Importadores/Exportadores**: Cadastre as empresas envolvidas. O estado do Importador define a regra de ICMS aplicada.
- **Produtos EDC**: Cadastre os itens com seus atributos logísticos (Peso Líquido, Bruto e Cubagem).

### Passo 3: Criando uma Simulação (Novo Estudo)
1.  Vá em **"Novo Estudo"**.
2.  **Identificação**: Selecione o Importador e Exportador.
3.  **Logística**: Informe a Cotação do Dólar (PTAX), Spread Bancário e Frete Internacional.
4.  **Itens**: Adicione os produtos do catálogo e informe a quantidade e o preço unitário (FOB USD) acordado com o fornecedor.
5.  **Cálculo**: O sistema processará automaticamente os impostos em cascata e o rateio das despesas.

### Passo 4: Análise e Relatório
Ao salvar o estudo, você será redirecionado para o **Relatório de Nacionalização**.
- **Memória de Cálculo**: Veja detalhadamente como o II, IPI e ICMS foram calculados por item.
- **Resumo Financeiro**: Visualize o custo total da operação e o preço unitário nacionalizado (em Reais) de cada peça.

---

## 3. Entendendo a Lógica de Cálculo
O sistema PI-Web segue o rigor aduaneiro brasileiro:
1.  **Valor Aduaneiro**: Base para todos os impostos federais.
2.  **Impostos Federais**: Calculados de forma sequencial (o IPI incide sobre o Valor Aduaneiro + II).
3.  **ICMS**: Calculado pelo método "por dentro", incluindo o próprio imposto na sua base de cálculo, conforme legislação vigente.

## 4. Dicas de Produtividade
- **Câmbio**: O campo de Spread permite ajustar o custo real do dólar praticado pelo seu banco.
- **Status**: Estudos em "Rascunho" podem ser editados posteriormente. Estudos "Finalizados" servem como base histórica.

---
*Manual versão 1.0 - Maio/2026*
