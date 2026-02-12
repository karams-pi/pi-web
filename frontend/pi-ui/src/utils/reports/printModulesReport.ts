
import type { Modulo, Configuracao } from "../../api/types";

interface PrintModulesReportOptions {
  modules: Modulo[];
  currency: "BRL" | "EXW";
  cotacao: number;
  config: Configuracao | null;
  maps: {
    fornecedor: Map<number, string>;
    categoria: Map<number, string>;
    marca: Map<number, string>;
    tecido: Map<number, string>;
  };
}

export function printModulesReport({
  modules,
  currency,
  cotacao,
  config,
  maps,
}: PrintModulesReportOptions) {
  if (!modules || modules.length === 0) {
    alert("Sem dados para imprimir");
    return;
  }

  const title = `Relatório de Módulos - ${currency === 'BRL' ? 'Valores em Reais (R$)' : 'Valores em Dólar (EXW)'}`;
  const date = new Date().toLocaleDateString("pt-BR") + " " + new Date().toLocaleTimeString("pt-BR");

  function calcPrice(valorTecido: number): number {
    if (currency === "BRL") {
      return valorTecido;
    } else {
        if (!config || !cotacao) return 0;
        const cotacaoRisco = cotacao - config.valorReducaoDolar;
        if (cotacaoRisco <= 0) return 0;
        const valorBase = valorTecido / cotacaoRisco;
        const comissao = valorBase * (config.percentualComissao / 100);
        // New Formula: Gordura on (Base + Comissao)
        const baseComComissao = valorBase + comissao;
        const gordura = baseComComissao * (config.percentualGordura / 100);
        
        return baseComComissao + gordura;
    }
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
          marcaGroup = {
              idMarca: mod.idMarca,
              marcaName: maps.marca.get(mod.idMarca) || String(mod.idMarca),
              items: []
          };
          group.marcas.push(marcaGroup);
      }
      marcaGroup.items.push(mod);
  });

  const sortedGroups = Array.from(groups.values()).sort((a, b) => a.key.localeCompare(b.key));
  sortedGroups.forEach(g => {
      g.marcas.sort((a, b) => a.marcaName.localeCompare(b.marcaName));
      g.marcas.forEach(m => {
          m.items.sort((i1, i2) => i1.descricao.localeCompare(i2.descricao));
      });
  });

  // 3. Prepare Header Rows (reused for each table)
  const standardHeaders = [
      "Modelo", "Módulo", "Larg", "Prof", "Alt", "M³"
  ];

  const colGroup = `
    <colgroup>
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
        ${standardHeaders.map(h => `<th rowspan="2">${h}</th>`).join("")}
        <th colspan="${sortedFabricIds.length}" class="center" style="text-align: center;">
            Valor (${currency === 'BRL' ? 'Reais' : 'EXW'})
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

  // 4. Generate Content (Modules separated by groups)
  let reportContent = "";

  sortedGroups.forEach(group => {
      // Group Title
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
              // Columns
              // Modelo (RowSpan only on first item)
              let colMarca = "";
              if (index === 0) {
                  colMarca = `<td rowspan="${marca.items.length}">${marca.marcaName}</td>`;
              }

              const colDesc = `<td class="desc">${mod.descricao}</td>`;
              const colLarg = `<td class="center">${fmtDim(mod.largura)}</td>`;
              const colProf = `<td class="center">${fmtDim(mod.profundidade)}</td>`;
              const colAlt = `<td class="center">${fmtDim(mod.altura)}</td>`;
              const colM3 = `<td class="center">${fmt(mod.m3)}</td>`;

              // Fabrics
              let fabricCols = "";
              sortedFabricIds.forEach(fid => {
                  const mt = mod.modulosTecidos?.find(x => x.idTecido === fid);
                  if (mt) {
                      const val = calcPrice(mt.valorTecido);
                      const symbol = currency === "BRL" ? "R$" : "$";
                      if (currency === "EXW") {
                           fabricCols += `<td class="right">${symbol} ${fmt(val)}</td>`;
                      } else {
                           fabricCols += `<td class="right">${symbol} ${fmt(val)}</td>`;
                      }
                  } else {
                       fabricCols += `<td class="center">-</td>`;
                  }
              });

              reportContent += `
                  <tr>
                      ${colMarca}
                      ${colDesc}
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
          
          .group-block { margin-bottom: 25px; break-inside: avoid; }
          
          .group-title {
              font-size: 12px;
              font-weight: 800;
              background-color: #d1d5db; /* Gray-300 */
              padding: 4px;
              border: 1px solid #000;
              border-bottom: none; /* Merge with table border visual */
              text-transform: uppercase;
          }

          table { width: 100%; border-collapse: collapse; table-layout: fixed; }
          
          th, td { 
            border: 1px solid #000;
            padding: 2px 2px; 
            vertical-align: middle;
          }
          
          th { 
            background-color: #e0e0e0; 
            font-weight: 700; 
            text-transform: uppercase;
            font-size: 8px;
          }

          tr:nth-child(even) { background-color: #f9f9f9; }
          
          .center { text-align: center; }
          .right { text-align: right; white-space: nowrap; }
          .desc { max-width: 150px; }

          @media print {
            .no-print { display: none; }
            body { margin: 0; padding: 0mm; }
            @page { margin: 5mm; size: landscape; }
            th, .group-title { background-color: #ccc !important; -webkit-print-color-adjust: exact; }
            .group-block { page-break-inside: avoid; }
          }
        </style>
      </head>
      <body>
        <div class="header">
            <h1 style="float: left; margin-right: 20px;">${title}</h1>
            <div class="meta" style="float: left; margin-top: 5px;">${date}</div>
            <div style="clear: both;"></div>
        </div>
        
        ${reportContent}

        <div class="no-print" style="position: fixed; top: 10px; right: 10px; background: white; padding: 10px; border: 1px solid #ccc; box-shadow: 0 4px 6px rgba(0,0,0,0.1); border-radius: 4px;">
             <button onclick="window.print()" style="padding: 8px 16px; background: #000; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;">🖨️ Imprimir</button>
        </div>
      </body>
    </html>
  `;

  const printWindow = window.open("", "_blank");
  if (!printWindow) {
    alert("Permita popups para imprimir");
    return;
  }

  printWindow.document.write(html);
  printWindow.document.close();
}
