# Relatório de Verificação e Cruzamento de Dados da Importação

**Data da Verificação**: 2026-05-28

Este relatório cruza os dados das tabelas de preços adaptadas no Excel com os dados de fato importados no banco de dados PostgreSQL, assegurando a precisão absoluta da importação.

## 1. Sumário do Cruzamento de Dados

### Fornecedor: Karams
| Métrica | Valor | Status |
| :--- | :--- | :--- |
| Total de Linhas no Excel Adaptado | 1631 | - |
| Módulos Identificados e Cruzados com Sucesso | 1631 | 🟢 Perfeito |
| Linhas não encontradas no Banco | 0 | 🟢 0 |
| Módulos com divergência de preços ou dimensões | 0 | 🟢 0 |

### Fornecedor: Koyo
| Métrica | Valor | Status |
| :--- | :--- | :--- |
| Total de Linhas no Excel Adaptado | 204 | - |
| Módulos Identificados e Cruzados com Sucesso | 204 | 🟢 Perfeito |
| Linhas não encontradas no Banco | 0 | 🟢 0 |
| Módulos com divergência de preços ou dimensões | 0 | 🟢 0 |

---

## 2. Detalhes de Inconsistências (Se houver)

> 🟢 **TUDO 100% CORRETO!** Todos os módulos e preços do Excel adaptado foram importados exatamente como descritos e batem de forma absoluta com os registros ativos do banco de dados (especificações e preços de tecidos).

---

## 3. Modelos (Marcas) Sem Imagem no Banco de Dados

Quando novos módulos de novos modelos são importados, as marcas são criadas no banco de dados com a imagem nula (`imagem = NULL`). A lista a seguir mostra quais modelos estão sem imagem ativa para cada fornecedor.

### Fornecedor: Karams
Foram encontrados **23** modelos de Karams sem imagem:

- `[ ]` ALMOFADAS DECORATIVAS
- `[ ]` ALMOFADAS DE RIM
- `[ ]` CAMA KAZUMI
- `[ ]` CAMA TORINO
- `[ ]` CAMA YUMI
- `[ ]` ESTOFADO ALOHA
- `[ ]` ESTOFADO ALOHA (BASE LAMINADA)
- `[ ]` ESTOFADO ALOHA (BASE TAPEÇADA)
- `[ ]` ESTOFADO CAMPINA
- `[ ]` ESTOFADO CINTIA
- `[ ]` ESTOFADO EQUILÍBRIO (BASE EM TECIDO)
- `[ ]` ESTOFADO EQUILÍBRIO (BASE LAMINADA)
- `[ ]` ESTOFADO LASSO
- `[ ]` ESTOFADO MAYA
- `[ ]` ESTOFADO MOA
- `[ ]` ESTOFADO TOUGE
- `[ ]` ESTOFADO ZENITH
- `[ ]` POLTRONA ALENTO
- `[ ]` POLTRONA BOUZA
- `[ ]` POLTRONA EIXO
- `[ ]` POLTRONA INTERIM
- `[ ]` POLTRONA ÓRBITA
- `[ ]` PUFF RANHURA

### Fornecedor: Koyo
Foram encontrados **2** modelos de Koyo sem imagem:

- `[ ]` GERAL
- `[ ]` POLTRONA HANA


*Relatório gerado automaticamente por Antigravity AI.*