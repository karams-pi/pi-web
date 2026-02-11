
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

  const title = `Relatório de Módulos - ${currency}`;
  const date = new Date().toLocaleDateString("pt-BR") + " " + new Date().toLocaleTimeString("pt-BR");

  // Helper to Calculate EXW (duplicated from page, but good for isolation)
  function calcPrice(valorTecido: number): number {
    if (currency === "BRL") {
      return valorTecido; // In BRL, we just show the base fabric value (as per current grid logic g0: R$ X)
    } else {
        // EXW Logic
        if (!config || !cotacao) return 0;
        const cotacaoRisco = cotacao - config.valorReducaoDolar;
        if (cotacaoRisco <= 0) return 0;
        const valorBase = valorTecido / cotacaoRisco;
        const comissao = valorBase * (config.percentualComissao / 100);
        const gordura = valorBase * (config.percentualGordura / 100);
        return valorBase + comissao + gordura;
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

  let tableRows = "";

  modules.forEach((mod) => {
    const tecidos = mod.modulosTecidos || [];
    const rowSpan = tecidos.length > 0 ? tecidos.length : 1;

    // Common columns
    const colId = `<td rowspan="${rowSpan}">${mod.id}</td>`;
    const colForn = `<td rowspan="${rowSpan}">${maps.fornecedor.get(mod.idFornecedor) || mod.idFornecedor}</td>`;
    const colCat = `<td rowspan="${rowSpan}">${maps.categoria.get(mod.idCategoria) || mod.idCategoria}</td>`;
    const colMarca = `<td rowspan="${rowSpan}">${maps.marca.get(mod.idMarca) || mod.idMarca}</td>`;
    const colDesc = `<td rowspan="${rowSpan}" class="desc">${mod.descricao}</td>`;
    const colDim = `<td rowspan="${rowSpan}" class="center">${fmtDim(mod.largura)} x ${fmtDim(mod.profundidade)} x ${fmtDim(mod.altura)}</td>`;
    const colM3 = `<td rowspan="${rowSpan}" class="center">${fmt(mod.m3)}</td>`;

    // First row
    let firstTecidoCols = "";
    if (tecidos.length > 0) {
        const t = tecidos[0];
        const nomeTecido = maps.tecido.get(t.idTecido) || t.idTecido;
        const valor = calcPrice(t.valorTecido);
        const symbol = currency === "BRL" ? "R$" : "$";
        
        firstTecidoCols = `
            <td>${nomeTecido}</td>
            <td class="right">${symbol} ${fmt(valor)}</td>
        `;
    } else {
        firstTecidoCols = `
            <td>-</td>
            <td>-</td>
        `;
    }

    tableRows += `
        <tr>
            ${colId}
            ${colForn}
            ${colCat}
            ${colMarca}
            ${colDesc}
            ${colDim}
            ${colM3}
            ${firstTecidoCols}
        </tr>
    `;

    // Other rows (tecidos only)
    for (let i = 1; i < tecidos.length; i++) {
        const t = tecidos[i];
        const nomeTecido = maps.tecido.get(t.idTecido) || t.idTecido;
        const valor = calcPrice(t.valorTecido);
        const symbol = currency === "BRL" ? "R$" : "$";

        tableRows += `
            <tr>
                <td>${nomeTecido}</td>
                <td class="right">${symbol} ${fmt(valor)}</td>
            </tr>
        `;
    }
  });

  const html = `
    <html>
      <head>
        <title>${title}</title>
        <style>
          body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; font-size: 11px; color: #333; }
          h1 { font-size: 18px; margin-bottom: 5px; color: #1e293b; }
          .meta { font-size: 10px; color: #64748b; margin-bottom: 20px; }
          table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
          th { background-color: #f1f5f9; color: #475569; font-weight: 600; text-align: left; padding: 8px; border-bottom: 2px solid #e2e8f0; font-size: 10px; text-transform: uppercase; }
          td { border-bottom: 1px solid #e2e8f0; padding: 6px 8px; vertical-align: top; }
          tr:nth-child(even) { background-color: #f8fafc; }
          
          .center { text-align: center; }
          .right { text-align: right; font-feature-settings: "tnum"; font-variant-numeric: tabular-nums; }
          .desc { max-width: 250px; }

          @media print {
            .no-print { display: none; }
            body { margin: 0; padding: 10px; }
            th { background-color: #eee !important; -webkit-print-color-adjust: exact; }
          }
        </style>
      </head>
      <body>
        <div class="header">
            <h1>${title}</h1>
            <div class="meta">Gerado em ${date}</div>
        </div>
        
        <table>
          <thead>
            <tr>
              <th style="width: 40px">ID</th>
              <th>Fornecedor</th>
              <th>Categoria</th>
              <th>Modelo</th>
              <th>Descrição</th>
              <th class="center">Dimensões</th>
              <th class="center">M³</th>
              <th>Tecido</th>
              <th class="right">Valor</th>
            </tr>
          </thead>
          <tbody>
            ${tableRows}
          </tbody>
        </table>

        <div class="no-print" style="position: fixed; top: 10px; right: 10px; background: white; padding: 10px; border: 1px solid #ccc; box-shadow: 0 4px 6px rgba(0,0,0,0.1); border-radius: 4px;">
             <button onclick="window.print()" style="padding: 8px 16px; background: #0f172a; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;">🖨️ Imprimir</button>
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
