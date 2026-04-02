/**
 * Utilitários de cálculo para o sistema PI-Web.
 * Mantém a paridade com a lógica implementada no backend.
 */

export function calculateCotacaoRisco(
  supplierName: string | undefined,
  cotacaoAtual: number,
  valorReducaoDolar: number
): number {
  if (!supplierName) return Number((cotacaoAtual - valorReducaoDolar).toFixed(2));

  const name = supplierName.toLowerCase();
  if (name.includes("ferguile") || name.includes("livintus")) {
    // Para fornecedores específicos, tratamos o valor como uma cotação fixa
    return Number(valorReducaoDolar.toFixed(2));
  }

  return Number((cotacaoAtual - valorReducaoDolar).toFixed(2));
}

export function calculateEXW(
  valorModuloTecido: number,
  cotacaoRisco: number,
  percentualComissao: number,
  percentualGordura: number
): number {
  if (cotacaoRisco <= 0) return 0;

  const valorBase = valorModuloTecido / cotacaoRisco;
  const vComissao = valorBase * (percentualComissao / 100);
  const vGordura = valorBase * (percentualGordura / 100);

  return Number((valorBase + vComissao + vGordura).toFixed(2));
}

export function calculateFreteRateio(
  totalFrete: number,
  totalM3: number,
  itemM3: number,
  moduleCount: number = 0,
  itemQty: number = 0,
  tipoRateio: string = "IGUAL"
): number {
  if (tipoRateio === "IGUAL") {
    if (moduleCount <= 0 || itemQty <= 0) return 0;
    return (totalFrete / moduleCount) / itemQty;
  } else {
    if (totalM3 <= 0) return 0;
    const custoPorM3 = totalFrete / totalM3;
    return custoPorM3 * itemM3;
  }
}
