# Padronização de PI - Impressão & Exportação Excel

Este documento define os padrões para a apresentação da Proforma Invoice (PI) em diferentes formatos de saída (Impressão Web/PDF e Excel). Estes padrões devem ser seguidos rigorosamente durante qualquer modificação para evitar regressões ou inconsistências.

## 1. Lógica Geral

### Recuperação de Dados (API)
- **Contexto da PI**: Os dados são buscados via `PisController.GetById`.
- **Otimização**: Os itens da PI incluem dados aninhados de `ModuloTecido`, `Modulo`, `Marca` (com `Imagem`) e `Tecido`. 
- **Eficiência**: NUNCA busque a lista completa `listModulosTecidos` (~3000 itens) nas páginas de impressão. Use os dados aninhados fornecidos pelo item da PI.

### Formatação do Número da PI
- **Padrão**: `Prefixo-Sequência` (ex: `PI-123`).
- **Caso Especial (Karams/Koyo)**: Se o fornecedor do primeiro item ou o nome do fornecedor da PI contiver "Karams" ou "Koyo", use `Prefixo-Sequência/AnoCurto` (ex: `PI-123/26`).

---

## 2. Layouts de Impressão Web

### Lógica Comum de Cabeçalho
- **Rótulos de Dimensões**: Devem usar **LARG.**, **ALT.** e **PROF.**
- **Rótulo de Pagamento**: Deve usar **CONDICIÓN DE PAGO:**
- **Moeda**: Alternar entre **BRL** (R$) e **EXW/USD** ($) com base nos parâmetros da URL.
- **Incotems**: Exibir "UNIT [INCOTERM]" (ex: "UNIT FCA DOLAR").

### Modelo A: Padrão (PrintPiPage.tsx)
- **Alvo**: Fornecedores genéricos/Karams.
- **Agrupamento**: Agrupado por Marca (**Marca**).
- **Fotos**: A imagem da marca é exibida no topo de cada seção de marca.
- **Colunas**: Foto, Marca, Descripción, [LARG., PROF., ALT.], Cant. Unidad, Total Vol M³, Fabric, Unit Price, Total Price.

### Modelo B: Ferguile / Livintus (PrintPiFerguilePage.tsx)
- **Alvo**: Fornecedores que contêm "Ferguile" ou "Livintus".
- **Agrupamento**: Agrupado por Marca (**Marca**), depois por **Descrição**.
- **Colunas Especiais**: Inclui "REFERENCIA" (Marca) e "MARCA" (Fornecedor/Categoria).
- **Mesclagem de Linhas**: Fotos e nomes de marcas são mesclados verticalmente por Marca. A descrição é mesclada verticalmente dentro do grupo da marca.

---

## 3. Exportação Excel (PiExportService.cs)

### Padrões Comuns de Excel
- **Fonte**: Arial, tamanho 10 (Global), tamanho 8-9 (grades/rodapés específicos).
- **Fotos**: As imagens são inseridas na primeira coluna, redimensionadas para 60x60 e recebem nomes únicos baseados no ID da Marca e no Índice da Linha (`Pic_{BrandId}_{Row}`).
- **Rótulos de Dimensão**: 
  - `BuildGenericLayout`: **LARG.**, **ALT.**, **Prof.**
  - `BuildFerguileLayout`: **LARG.**, **ALT.**, **PROF.**
- **Formatação de Moeda**: `_-R$* #,##0.00_-` para BRL, `_-$* #,##0.00_-` para USD.

### Layout Genérico (BuildGenericLayout)
- **Cabeçalho**: Branding Karams/Terra Rica (Tema azul #003366).
- **Colunas**: FOTO, NOMBRE, DESCRIPCIÓN, [DIMENSIONES (m): LARG., Prof., ALT.], CANT UNID, CANT SOFA, TOTAL VOLUMEN M³, TELA, PIES, ACABADO, OBSERVACIÓN.

### Layout Ferguile (BuildFerguileLayout)
- **Cabeçalho**: Branding Ferguile Estofados (Bordas espessas).
- **Colunas**: FOTO, REFERENCIA, DESCRIPCIÓN, MARCA, LARG., ALT., PROF., CANT., TOTAL M3, FABRIC, TELA N, OBSERVACIÓN.

---

## 4. Checklist de Revisão para Modificações
Antes de aplicar qualquer alteração na Impressão da PI ou Excel:
1. [ ] Verifique se a alteração se aplica a AMBOS os layouts (Genérico & Ferguile).
2. [ ] Garanta que os rótulos de dimensões sigam o padrão abreviado (**LARG.**, **ALT.**).
3. [ ] Verifique se a lógica de formatação do número da PI para Karams/Koyo foi preservada.
4. [ ] No Frontend: Garanta que não haja regressão para o problema de OOM do "listModulosTecidos" (use dados aninhados).
5. [ ] No Backend: Garanta a unicidade do nome da imagem no Excel para evitar colisões de desenho.
