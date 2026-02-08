
export interface ColumnDefinition<T> {
  header: string;
  accessor: (item: T) => string | number | null | undefined;
}

export function exportToCSV<T>(data: T[], columns: ColumnDefinition<T>[], filename: string) {
  if (!data || !data.length) {
    alert("Sem dados para exportar");
    return;
  }

  const headers = columns.map(c => c.header).join(";");
  const rows = data.map(item => {
    return columns.map(c => {
      const val = c.accessor(item);
      const str = val === null || val === undefined ? "" : String(val);
      // Escape quotes and wrap in quotes if needed, though simple CSV usually works with ; separator in Brazil
      return `"${str.replace(/"/g, '""')}"`; 
    }).join(";");
  }).join("\n");

  const bom = "\uFEFF"; // Byte Order Mark for Excel to read UTF-8
  const csvContent = bom + headers + "\n" + rows;

  const blob = new Blob([csvContent], { type: "text/csv;charset=utf-8;" });
  const url = URL.createObjectURL(blob);
  
  const link = document.createElement("a");
  link.setAttribute("href", url);
  link.setAttribute("download", filename.endsWith(".csv") ? filename : `${filename}.csv`);
  link.style.visibility = "hidden";
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
}

export function printData<T>(data: T[], columns: ColumnDefinition<T>[], title: string) {
  if (!data || !data.length) {
    alert("Sem dados para imprimir");
    return;
  }

  const printWindow = window.open("", "_blank");
  if (!printWindow) {
    alert("Permita popups para imprimir");
    return;
  }

  const headers = columns.map(c => `<th style="border:1px solid #ddd; padding:8px; text-align:left;">${c.header}</th>`).join("");
  const rows = data.map(item => {
    const cells = columns.map(c => {
      const val = c.accessor(item);
      return `<td style="border:1px solid #ddd; padding:8px;">${val === null || val === undefined ? "" : val}</td>`;
    }).join("");
    return `<tr>${cells}</tr>`;
  }).join("");

  const html = `
    <html>
      <head>
        <title>${title}</title>
        <style>
          body { font-family: Arial, sans-serif; font-size: 12px; }
          table { width: 100%; border-collapse: collapse; }
          th { background-color: #f2f2f2; }
          h1 { font-size: 18px; margin-bottom: 20px; }
          @media print {
            .no-print { display: none; }
          }
        </style>
      </head>
      <body>
        <h1>${title}</h1>
        <table>
          <thead><tr>${headers}</tr></thead>
          <tbody>${rows}</tbody>
        </table>
        <div class="no-print" style="margin-top:20px; text-align:right;">
             <button onclick="window.print()" style="padding:10px 20px; cursor:pointer;">Imprimir</button>
        </div>
        <script>
           // Auto print? Maybe annoy user. Let them click button or use browser menu.
           // window.print();
        </script>
      </body>
    </html>
  `;

  printWindow.document.write(html);
  printWindow.document.close();
}
