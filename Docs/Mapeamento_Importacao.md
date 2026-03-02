# Mapeamento dos Arquivos de Importação (Excel)

Este documento descreve como o sistema interpreta os arquivos Excel para importar dados dos fornecedores **Karams** e **Koyo**.

---

## 1. Importação Karams

O sistema lê cada aba do arquivo Excel como uma **Categoria** separada.

### Estrutura Geral
*   **Nome da Aba**: Define o nome da **Categoria** (ex: "Estofado", "Mesa").
*   **Linha de Início**: Os dados começam a ser lidos a partir da **Linha 2** (a Linha 1 é ignorada como cabeçalho).
*   **Célula Mesclada**: O sistema suporta células mescladas para as colunas de Marca/Descrição, repetindo o valor para as linhas abrangidas.

### Colunas Mapeadas

| Coluna Excel | Campo no Banco de Dados | Observações |
| :--- | :--- | :--- |
| **A** (1) | **Marca** | Ignora se o valor for "Marca". |
| **B** (2) | **Descrição** (Modelo/Módulo) | Ignora se o valor for "Descrição". Chave única junto com Marca. |
| **C** (3) | **Largura** | Ignora se o valor for "Larg". |
| **D** (4) | **Profundidade** | Ignora se o valor for "Prof". |
| **F** (6) | **Altura** | Ignora se o valor for "Altura". Note que a coluna **E** (5) é pulada. |
| - | **PA** (Preço Acessório) | Definido fixo como **0**. |

### Mapeamento de Tecidos (Preços)

Os preços dos tecidos são lidos das seguintes colunas fixas:

| Tecido (Código) | Coluna Excel |
| :--- | :--- |
| **G0** | **H** (8) |
| **G1** | **I** (9) |
| **G2** | **J** (10) |
| **G3** | **K** (11) |
| **G4** | **L** (12) |
| **G5** | **M** (13) |
| **G6** | **N** (14) |
| **G7** | **O** (15) |
| **G8** | **P** (16) |

---

## 2. Importação Koyo

Assim como na Karams, cada aba representa uma **Categoria**.

### Estrutura Geral
*   **Nome da Aba**: Define o nome da **Categoria**.
*   **Linha de Início**: Os dados são verificados a partir da **Linha 1**.

### Colunas Mapeadas

| Coluna Excel | Campo no Banco de Dados | Observações |
| :--- | :--- | :--- |
| **A** (1) | **Marca** | Se estiver vazio, assume o valor padrão **"GERAL"**. |
| **B** (2) | **Descrição** (Modelo/Módulo) | Ignora se for "Descrição". |
| **C** (3) | **Largura** | Ignora se for "Larg". |
| **D** (4) | **Profundidade** | Ignora se for "Prof". |
| **E** (5) | **Altura** | Ignora se for "Altura". |
| - | **PA** (Preço Acessório) | Definido fixo como **0**. |

### Mapeamento de Tecidos (Preços)

O sistema agora detecta as colunas de tecidos **automaticamente** para a Koyo. Ele procura na **primeira linha** de cada aba por células contendo os códigos **G0, G1, G2, G3, G4, G5, G6, G7, G8, G9** e **G10**. Isso torna a importação flexível caso a fornecedora altere a ordem das colunas no futuro.

---

## Notas Técnicas

*   **Identificação Única**: O sistema tenta identificar se um módulo já existe combinando `Fornecedor + Categoria + Marca + Descrição + Largura`. Se encontrar, atualiza os dados; caso contrário, cria um novo.
*   **Variação de Tamanho**: Para **Karams** e **Koyo**, a `Largura` é usada como critério adicional para diferenciar módulos com a mesma descrição (ex: mesmo sofá com tamanhos diferentes).
*   **Formatação de Células**: O sistema possui uma rotina de limpeza automática que corrige referências de células inválidas (ex: `ref="D1260;D214"` ou intervalos invertidos) antes de processar o arquivo.
