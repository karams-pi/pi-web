import type { Modulo, Configuracao, Marca } from "../../api/types";
import { calculateCotacaoRisco } from "../calculations";

interface PrintPriceListReportOptions {
  modules: Modulo[];
  freightMap: Map<number, number>; // ModuloId -> FreightUSD
  currency: "BRL" | "EXW";
  cotacao: number;
  configsMap: Map<number | null, Configuracao>;
  maps: {
    fornecedor: Map<number, string>;
    categoria: Map<number, string>;
    marca: Map<number, Marca>;
    tecido: Map<number, string>;
  };
  validityDays?: number;
}

export function printPriceListReport({
  modules,
  freightMap,
  currency,
  cotacao,
  configsMap,
  maps,
  validityDays = 30,
}: PrintPriceListReportOptions) {
  if (!modules || modules.length === 0) {
    alert("Sem dados para imprimir");
    return;
  }

  const title = `Lista de Preços - ${currency === 'BRL' ? 'Valores em Reais (R$)' : 'Valores em Dólar (EXW)'}`;
  const getImgUrl = (path?: string | null) => {
    if (!path) return "";
    if (path.startsWith("http") || path.startsWith("data:")) return path;
    
    // Check if it's base64 from binary DB field
    const isLikelyBase64 = path.length > 50 && !/\.(jpg|jpeg|png|gif|webp|svg)$/i.test(path);
    if (isLikelyBase64) {
      return `data:image/png;base64,${path}`;
    }
    return `http://localhost:5000/${path.replace(/^\/+/, "")}`;
  };
  // Note: ideally API_BASE should be passed but I'll hardcode or use a placeholder for now as I can't easily import from another file into this pure utility if it's not set up for it.
  // Actually, I'll use a safer way or pass it in options.

  function getRiskVal(idFornecedor: number): number {
    const config = configsMap.get(idFornecedor) || configsMap.get(null);
    if (!config || !cotacao) return 1;
    const sName = maps.fornecedor.get(idFornecedor);
    return calculateCotacaoRisco(sName, cotacao, config.valorReducaoDolar);
  }

  function calcFinalPrice(valorTecido: number, idFornecedor: number, modId: number): number {
    const risk = getRiskVal(idFornecedor);
    if (risk <= 0) return 0;

    const config = configsMap.get(idFornecedor) || configsMap.get(null);
    const pctComissao = config?.percentualComissao || 0;
    const pctGordura = config?.percentualGordura || 0;

    const valorBase = valorTecido / risk;
    const comissao = valorBase * (pctComissao / 100);
    const gordura = valorBase * (pctGordura / 100);
    
    const exw = valorBase + comissao + gordura;
    const freightUSD = freightMap.get(modId) || 0;
    
    const totalUSD = exw + freightUSD;

    return currency === "BRL" ? totalUSD * risk : totalUSD;
  }

  function fmt(val: number | undefined | null) {
      if (val === undefined || val === null) return "0,00";
      return val.toLocaleString("pt-BR", { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  }

  function fmtDim(val: number | undefined) {
      if (val === undefined) return "0,00";
      return val.toLocaleString("pt-BR", { minimumFractionDigits: 2 });
  }

  // 1. Identify all unique fabrics
  const uniqueFabricIds = new Set<number>();
  modules.forEach(m => {
      if (m.modulosTecidos) {
          m.modulosTecidos.forEach(mt => uniqueFabricIds.add(mt.idTecido));
      }
  });

  const sortedFabricIds = Array.from(uniqueFabricIds).sort((a, b) => {
      const nameA = maps.tecido.get(a) || "";
      const nameB = maps.tecido.get(b) || "";
      return nameA.localeCompare(nameB, undefined, { numeric: true, sensitivity: 'base' });
  });

  // 2. Group Data
  type ModuloGroup = {
      key: string;
      fornName: string;
      catName: string;
      marcas: {
          idMarca: number;
          marcaName: string;
          items: Modulo[];
      }[];
  };

  const groups = new Map<string, ModuloGroup>();

  modules.forEach(mod => {
      const fornName = maps.fornecedor.get(mod.idFornecedor) || String(mod.idFornecedor);
      const catName = maps.categoria.get(mod.idCategoria) || String(mod.idCategoria);
      const groupKey = `${fornName}||${catName}`;

      if (!groups.has(groupKey)) {
          groups.set(groupKey, {
              key: groupKey,
              fornName,
              catName,
              marcas: []
          });
      }
      const group = groups.get(groupKey)!;

      let marcaGroup = group.marcas.find(m => m.idMarca === mod.idMarca);
      if (!marcaGroup) {
          const mObj = maps.marca.get(mod.idMarca);
          marcaGroup = {
              idMarca: mod.idMarca,
              marcaName: mObj?.nome || String(mod.idMarca),
              items: []
          };
          group.marcas.push(marcaGroup);
      }
      marcaGroup.items.push(mod);
  });

  const sortedGroups = Array.from(groups.values()).sort((a, b) => a.key.localeCompare(b.key));

  // 3. Prepare Header Rows
  const standardHeaders = [
      "Modelo", "Módulo", "Larg", "Prof", "Alt", "M³"
  ];

  const colGroup = `
    <colgroup>
        <col style="width: 10%">
        <col style="width: 12%">
        <col style="width: 18%">
        <col style="width: 4%">
        <col style="width: 4%">
        <col style="width: 4%">
        <col style="width: 4%">
    </colgroup>
  `;

  const headerRow1 = `
    <tr>
        <th rowspan="2">Foto</th>
        ${standardHeaders.map(h => `<th rowspan="2">${h}</th>`).join("")}
        <th colspan="${sortedFabricIds.length}" class="center" style="text-align: center;">
            Valor Final (${currency === 'BRL' ? 'Reais' : 'EXW'})
        </th>
    </tr>
  `;

  const headerRow2 = `
    <tr>
        ${sortedFabricIds.map(fid => {
            const name = maps.tecido.get(fid) || fid;
            return `<th class="center">${name}</th>`;
        }).join("")}
    </tr>
  `;

  const tableHead = `
    ${colGroup}
    <thead>
        ${headerRow1}
        ${headerRow2}
    </thead>
  `;

  // 4. Generate Content
  let reportContent = "";

  sortedGroups.forEach(group => {
      reportContent += `
        <div class="group-block">
            <div class="group-title">${group.fornName} - ${group.catName}</div>
      `;

      group.marcas.forEach(marca => {
          reportContent += `
            <table style="margin-top: 10px;">
                ${tableHead}
                <tbody>
          `;

          marca.items.forEach((mod, index) => {
              let colMarca = "";
              if (index === 0) {
                  const mObj = maps.marca.get(mod.idMarca);
                  const imgPath = mObj?.imagem;
                  const img = imgPath ? `<img src="${getImgUrl(imgPath)}" style="width: 60px; height: 60px; object-fit: cover; border: 1px solid #eee; display: block; margin: 0 auto;" />` : `<div style="width: 60px; height: 60px; border: 1px solid #ddd; background: #f9f9f9; display: flex; align-items: center; justify-content: center; font-size: 8px; color: #999; margin: 0 auto;">S/ FOTO</div>`;
                  colMarca = `
                    <td rowspan="${marca.items.length}" class="center">
                        ${img}
                        <div style="margin-top: 5px;"><strong>${marca.marcaName}</strong></div>
                    </td>
                  `;
              }

              const colDesc = `<td class="desc">${mod.descricao}</td>`;
              const colPa = `<td class="center">${fmtDim(mod.pa)}</td>`;
              const colLarg = `<td class="center">${fmtDim(mod.largura)}</td>`;
              const colProf = `<td class="center">${fmtDim(mod.profundidade)}</td>`;
              const colAlt = `<td class="center">${fmtDim(mod.altura)}</td>`;
              const colM3 = `<td class="center">${fmt(mod.m3)}</td>`;
              
              const freightUSD = freightMap.get(mod.id) || 0;
              const risk = getRiskVal(mod.idFornecedor);
              const freightDisp = currency === "BRL" ? freightUSD * risk : freightUSD;

              let fabricCols = "";
              sortedFabricIds.forEach(fid => {
                  const mt = mod.modulosTecidos?.find(x => x.idTecido === fid);
                  if (mt) {
                      const val = calcFinalPrice(mt.valorTecido, mod.idFornecedor, mod.id);
                      const symbol = currency === "BRL" ? "R$" : "$";
                      fabricCols += `<td class="right">${symbol} ${fmt(val)}</td>`;
                  } else {
                       fabricCols += `<td class="center">-</td>`;
                  }
              });

              reportContent += `
                  <tr>
                      ${colMarca}
                      ${colDesc}
                      ${colPa}
                      ${colLarg}
                      ${colProf}
                      ${colAlt}
                      ${colM3}
                      ${fabricCols}
                  </tr>
              `;
          });

          reportContent += `
                </tbody>
            </table>
          `;
      });

      reportContent += `
        </div>
      `;
  });

  const html = `
    <html>
      <head>
        <title>${title}</title>
        <style>
          body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; font-size: 9px; color: #000; }
          h1 { font-size: 14px; margin-bottom: 5px; color: #000; }
          .meta { font-size: 9px; color: #444; margin-bottom: 15px; }
          .group-title {
              font-size: 12px;
              font-weight: 800;
              background-color: #d1d5db;
              padding: 4px;
              border: 1px solid #000;
              text-transform: uppercase;
          }
          table { width: 100%; border-collapse: collapse; table-layout: fixed; }
          th, td { border: 1px solid #000; padding: 2px; vertical-align: middle; }
          th { background-color: #e0e0e0; font-weight: 700; text-transform: uppercase; font-size: 8px; }
          td { font-size: 8px; }
          .center { text-align: center; }
          .right { text-align: right; white-space: nowrap; }
          .desc { max-width: 150px; }
          @media print {
            @page { margin: 5mm; size: landscape; }
            th, .group-title { background-color: #ccc !important; -webkit-print-color-adjust: exact; }
          }
        </style>
      </head>
      <body>
        <div class="header">
            <h1 style="float: left;">${title}</h1>
            <div style="float: right; text-align: right;">
                <div class="meta"><strong>Fecha de Emisión:</strong> ${new Date().toLocaleDateString("pt-BR")}</div>
                <div style="font-size: 11px; color: #d9534f; font-weight: bold;">
                    * Esta lista de precios é válida por ${validityDays} dias a partir da data de emissão.
                </div>
            </div>
            <div style="clear: both;"></div>
        </div>
        ${reportContent}
        <div class="no-print" style="position: fixed; top: 10px; right: 10px;">
             <button onclick="window.print()" style="padding: 10px; background: #000; color: #fff; border: none; cursor: pointer;">🖨️ Imprimir</button>
        </div>
      </body>
    </html>
  `;

  const printWindow = window.open("", "_blank");
  if (printWindow) {
    printWindow.document.write(html);
    printWindow.document.close();
  }
}
