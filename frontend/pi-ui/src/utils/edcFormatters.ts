export interface EdcItemDisplayInfo {
  title: string;
  subtitle: string;
}

/**
 * Formata os dados de identificação comercial de um item de simulação EDC,
 * evitando duplicações como "X - X" e garantindo que o modelo/código comercial
 * seja priorizado de forma clara e limpa.
 */
export function formatEdcItemDisplay(item: any): EdcItemDisplayInfo {
  if (!item) return { title: 'Produto sem identificação', subtitle: '' };

  const prodRef = (item.produto?.referencia || '').trim();
  const prodDesc = (item.produto?.descricao || '').trim();
  const modCod = (item.modelo?.codigo || '').trim();
  const modNome = (item.modelo?.nome || '').trim();
  const modDesc = (item.modelo?.descricao || '').trim();

  let title = '';

  // 1. Determinar o Título Principal
  // Se existir modelo customizado com Código e Nome distintos
  if (modCod && modNome && modCod.toLowerCase() !== modNome.toLowerCase()) {
    title = `${modCod} - ${modNome}`;
  } else if (modCod && prodRef && modCod.toLowerCase() !== prodRef.toLowerCase()) {
    // Se modCod é genérico (ex: "BEVERAGE COOLER") e prodRef é o código comercial específico (ex: "FGB40S")
    title = prodRef;
  } else {
    // Caso padrão: usar a melhor identificação sem duplicar
    title = prodRef || modCod || modNome || prodDesc || 'Produto sem identificação';
  }

  // 2. Determinar o Subtítulo / Descrição Complementar
  const subtitleParts: string[] = [];

  if (
    prodDesc && 
    prodDesc.toLowerCase() !== title.toLowerCase() && 
    prodDesc.toLowerCase() !== prodRef.toLowerCase()
  ) {
    subtitleParts.push(prodDesc);
  } else if (
    modDesc && 
    !modDesc.toLowerCase().startsWith('modelo padrão') && 
    modDesc.toLowerCase() !== title.toLowerCase()
  ) {
    subtitleParts.push(modDesc);
  } else if (
    modCod && 
    modCod.toLowerCase() !== title.toLowerCase() &&
    !title.toLowerCase().includes(modCod.toLowerCase())
  ) {
    subtitleParts.push(modCod);
  }

  if (
    prodRef && 
    prodRef.toLowerCase() !== title.toLowerCase() && 
    !title.toLowerCase().includes(prodRef.toLowerCase()) &&
    !subtitleParts.some(p => p.toLowerCase().includes(prodRef.toLowerCase()))
  ) {
    subtitleParts.unshift(`Ref: ${prodRef}`);
  }

  return {
    title,
    subtitle: subtitleParts.filter(Boolean).join(' - ')
  };
}
