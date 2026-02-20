
import React, { useEffect, useState, useMemo } from "react";
import { useParams } from "react-router-dom";
import { getPi } from "../api/pis";
import type { ProformaInvoice, ModuloTecido, PiItem } from "../api/types";
import { listModulosTecidos } from "../api/modulos";
import { getCliente, type Cliente } from "../api/clientes";

export default function PrintPiFerguilePage() {
  const { id } = useParams();
  const [pi, setPi] = useState<ProformaInvoice | null>(null);
  const [cliente, setCliente] = useState<Cliente | null>(null);
  const [modulosTecidos, setModulosTecidos] = useState<ModuloTecido[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function load() {
      if (!id) return;
      try {
        const piData = await getPi(Number(id));
        setPi(piData);

        const promises: Promise<any>[] = [listModulosTecidos()];
        if (piData.idCliente) {
          promises.push(
            getCliente(String(piData.idCliente)).catch((err) => {
              console.warn("Falha ao buscar cliente", err);
              return null;
            })
          );
        }

        const results = await Promise.all(promises);
        setModulosTecidos(results[0]);
        setCliente(results[1] || null);
      } catch (error) {
        console.error("Erro ao carregar PI para impressão:", error);
        alert("Erro ao carregar documento.");
      } finally {
        setLoading(false);
      }
    }
    load();
  }, [id]);

  const fmt = (n: number | undefined, decimals = 2) =>
    (n || 0).toLocaleString("en-US", {
      minimumFractionDigits: decimals,
      maximumFractionDigits: decimals,
    });

  const fmtBR = (n: number | undefined, decimals = 2) =>
    (n || 0).toLocaleString("pt-BR", {
      minimumFractionDigits: decimals,
      maximumFractionDigits: decimals,
    });

  const safeDate = (dateStr: string | undefined) => {
    if (!dateStr) return new Date();
    const d = new Date(dateStr);
    return isNaN(d.getTime()) ? new Date() : d;
  };

  const dateObj = safeDate(pi?.dataPi);
  const displayClient = cliente || (pi as any)?.cliente;
  const incoterm = pi?.frete?.nome || "FCA";


  // Month names in English for the PDF format
  const monthNames = [
    "JAN", "FEB", "MAR", "APR", "MAY", "JUN",
    "JUL", "AUG", "SEP", "OCT", "NOV", "DEC",
  ];

  const formatDateEN = (d: Date) => {
    const day = d.getDate();
    const suffix =
      day === 1 || day === 21 || day === 31
        ? "st"
        : day === 2 || day === 22
        ? "nd"
        : day === 3 || day === 23
        ? "rd"
        : "th";
    return `${monthNames[d.getMonth()]}, ${String(day).padStart(2, "0")}${suffix}, ${d.getFullYear()}`;
  };

  // ─── Process data: group by REFERENCIA (marca) ───
  const processedData = useMemo(() => {
    if (!pi || !pi.piItens) return { rows: [], totalFCA: 0, totalM3: 0, totalQty: 0 };

    type RowData = {
      item: PiItem;
      mt: ModuloTecido | undefined;
      marca: string;
      marcaFornecedor: string; // MARCA column: supplier brand name
      referencia: string; // REFERENCIA: brand name
      descricao: string;
      largura: number;
      altura: number;
      profundidade: number;
      quantidade: number;
      volM3: number;
      fabricName: string;
      telaCode: string;
      observacao: string;
      unitPrice: number;
      totalPrice: number;
    };

    const rows: RowData[] = [];

    pi.piItens.forEach((item) => {
      const mt = modulosTecidos.find((m) => m.id === item.idModuloTecido);
      const marca = mt?.modulo?.marca?.nome || "Outros";
      const marcaFornecedor = mt?.modulo?.fornecedor?.nome || mt?.modulo?.categoria?.nome || "Ferguile";
      const descricao = mt?.modulo?.descricao || "";
      const fabricName = mt?.tecido?.nome || "";
      const telaCode = item.tempCodigoModuloTecido || mt?.codigoModuloTecido || "";
      const volM3 = (item.m3 || 0) * (item.quantidade || 0);
      const unitPrice = item.valorEXW || 0;
      const totalPrice = unitPrice * (item.quantidade || 0);

      rows.push({
        item,
        mt,
        marca,
        marcaFornecedor,
        referencia: marca,
        descricao,
        largura: item.largura,
        altura: item.altura,
        profundidade: item.profundidade,
        quantidade: item.quantidade,
        volM3,
        fabricName,
        telaCode,
        observacao: item.observacao || "",
        unitPrice,
        totalPrice,
      });
    });

    // Sort by referencia (brand), then by description
    rows.sort((a, b) => {
      if (a.referencia !== b.referencia) return a.referencia.localeCompare(b.referencia);
      if (a.descricao !== b.descricao) return a.descricao.localeCompare(b.descricao);
      return a.fabricName.localeCompare(b.fabricName);
    });

    // Calculate brand groups for rowSpan
    const brandSpans: number[] = new Array(rows.length).fill(0);
    for (let i = 0; i < rows.length; i++) {
      if (brandSpans[i] === -1) continue;
      let span = 1;
      for (let j = i + 1; j < rows.length; j++) {
        if (rows[j].referencia === rows[i].referencia) {
          span++;
          brandSpans[j] = -1;
        } else break;
      }
      brandSpans[i] = span;
    }

    // Calculate description spans within same brand group
    const descSpans: number[] = new Array(rows.length).fill(0);
    for (let i = 0; i < rows.length; i++) {
      if (descSpans[i] === -1) continue;
      let span = 1;
      for (let j = i + 1; j < rows.length; j++) {
        if (rows[j].referencia === rows[i].referencia && rows[j].descricao === rows[i].descricao) {
          span++;
          descSpans[j] = -1;
        } else break;
      }
      descSpans[i] = span;
    }

    const totalValue = rows.reduce((s, r) => s + r.totalPrice, 0);
    const totalM3 = rows.reduce((s, r) => s + r.volM3, 0);
    const totalQty = rows.reduce((s, r) => s + r.quantidade, 0);

    return { rows, brandSpans, descSpans, totalValue, totalM3, totalQty };
  }, [pi, modulosTecidos]);

  const formattedPiNumber = useMemo(() => {
    if (!pi) return "";
    const base = `${pi.prefixo}-${pi.piSequencia}`;
    
    // Check if supplier is Karams or Koyo
    const firstItem = pi.piItens?.[0];
    if (firstItem) {
        const mt = modulosTecidos.find(m => m.id === firstItem.idModuloTecido);
        const supplierName = (mt?.modulo?.fornecedor?.nome || "").toLowerCase();
        if (supplierName.includes("karams") || supplierName.includes("koyo")) {
            const year = dateObj.getFullYear();
            const yearShort = String(year).slice(-2);
            return `${base}/${yearShort}`;
        }
    }
    
    return base;
  }, [pi, modulosTecidos, dateObj]);

  if (loading) return <div style={{ padding: 20 }}>Carregando documento...</div>;
  if (!pi) return <div style={{ padding: 20 }}>Documento não encontrado.</div>;

  const cellStyle: React.CSSProperties = {
    border: "1px solid #000",
    padding: "3px 5px",
    textAlign: "center",
    verticalAlign: "middle",
    fontSize: "9px",
  };

  const thStyle: React.CSSProperties = {
    ...cellStyle,
    background: "#2c3e50",
    color: "#fff",
    fontWeight: "bold",
    fontSize: "9px",
    padding: "4px 3px",
    textTransform: "uppercase",
  };

  return (
    <div
      className="print-container"
      style={{
        padding: "20px 30px",
        fontFamily: "Arial, sans-serif",
        color: "#000",
        background: "#fff",
        maxWidth: "1200px",
        margin: "0 auto",
      }}
    >
      <style>{`
        @media print {
          @page { margin: 0.4cm; size: landscape; }
          html, body { height: auto !important; overflow: visible !important; background: #fff !important; color: #000 !important; -webkit-print-color-adjust: exact; }
          .topbar, .footer, .no-print, .btn-print { display: none !important; }
          .app, .main, .container {
            padding: 0 !important; margin: 0 !important; width: 100% !important;
            max-width: none !important; border: none !important; box-shadow: none !important;
            overflow: visible !important; height: auto !important; display: block !important;
          }
          .print-container { padding: 5px !important; max-width: none !important; margin: 0 !important; display: block !important; }
        }
        thead { display: table-header-group; }
        tfoot { display: table-footer-group; }
        tr { break-inside: avoid; page-break-inside: avoid; }
      `}</style>

      <button
        className="btn-print no-print"
        onClick={() => window.print()}
        style={{
          position: "fixed", top: 20, right: 20,
          padding: "10px 20px", background: "#2563eb", color: "white",
          border: "none", borderRadius: "8px", cursor: "pointer",
          fontWeight: "bold", boxShadow: "0 4px 10px rgba(0,0,0,0.2)", zIndex: 1000,
        }}
      >
        🖨️ Imprimir
      </button>

      {/* ═══════════════ HEADER ═══════════════ */}
      <div
        style={{
          display: "grid",
          gridTemplateColumns: "1fr 1fr",
          border: "2px solid #000",
          marginBottom: 0,
        }}
      >
        {/* LEFT: Exporter */}
        <div style={{ padding: "10px 15px", fontSize: "11px", lineHeight: "1.5em", borderRight: "2px solid #000" }}>
          <div style={{ fontWeight: "bold", fontSize: "13px", marginBottom: "4px", textTransform: "uppercase" }}>
            FERGUILE ESTOFADOS LTDA
          </div>
          <div>CNPJ: 27.499.537/0001-02</div>
          <div>ADDRESS: RUA CANÁRIO DO BREJO, 630</div>
          <div>RIBEIRÃO BANDEIRANTE DO NORTE</div>
          <div>ZIP CODE: 86703-797</div>
          <div>ARAPONGAS - PARANÁ</div>
          <div>COUNTRY: BRASIL</div>
          <div style={{ marginTop: 6 }}>
            <strong>DELIVERY TIME:</strong>{" "}
            {pi.configuracoes?.condicoesPagamento ? "60 days" : "60 days"}
          </div>
          <div>
            <strong>INCOTERM:</strong> {incoterm} - ARAPONGAS PR
          </div>
          <div>
            <strong>PAYMENT TERM:</strong> {pi.configuracoes?.condicoesPagamento || "AT SIGHT"}
          </div>
        </div>

        {/* RIGHT: PI Details + Importer */}
        <div style={{ padding: "10px 15px", fontSize: "11px", lineHeight: "1.5em" }}>
          <div style={{ display: "flex", justifyContent: "space-between" }}>
            <span style={{ fontWeight: "bold", fontSize: "13px" }}>
              PROFORMA INVOICE: {formattedPiNumber}
            </span>
          </div>
          <div>
            DATA: {dateObj.toLocaleDateString("pt-BR")}
          </div>
          <div>
            PROFORMA INVOICE: {formattedPiNumber}
          </div>
          <div>
            ORDER DATE: {formatDateEN(dateObj)}
          </div>
          <div style={{ marginTop: 6, fontWeight: "bold" }}>IMPORTER:</div>
          <div style={{ marginLeft: 20 }}>
            <div>{displayClient?.empresa || displayClient?.nome || ""}</div>
            {displayClient?.nit && <div>CUIT: {displayClient.nit}</div>}
            {displayClient?.endereco && <div>ADDRESS: {displayClient.endereco}{displayClient?.cidade ? `, ${displayClient.cidade}` : ""}</div>}
            {displayClient?.cep && <div>CODIGO POSTAL: {displayClient.cep}</div>}
            {displayClient?.pais && <div>COUNTRY: {displayClient.pais}</div>}
            {displayClient?.pessoaContato && <div>RESPONSIBLE PERSON: {displayClient.pessoaContato}</div>}
            {displayClient?.telefone && <div>TEL.: {displayClient.telefone}</div>}
            {displayClient?.email && <div>E-MAIL: {displayClient.email}</div>}
          </div>
        </div>
      </div>

      {/* ═══════════════ TABLE ═══════════════ */}
      <table style={{ width: "100%", borderCollapse: "collapse", border: "1px solid #000", marginTop: 0 }}>
        <thead>
          <tr>
            <th style={{ ...thStyle, width: "6%" }}>FOTO</th>
            <th style={{ ...thStyle, width: "8%" }}>REFERENCIA</th>
            <th style={{ ...thStyle, width: "14%" }}>DESCRIPCIÓN</th>
            <th style={{ ...thStyle, width: "7%" }}>MARCA</th>
            <th style={{ ...thStyle, width: "5%" }}>LARG.</th>
            <th style={{ ...thStyle, width: "5%" }}>ALT.</th>
            <th style={{ ...thStyle, width: "5%" }}>PROF.</th>
            <th style={{ ...thStyle, width: "5%" }}>CANT.<br/>UNIDAD</th>
            <th style={{ ...thStyle, width: "5%" }}>TOTAL<br/>VOL M³</th>
            <th style={{ ...thStyle, width: "7%" }}>FABRIC</th>
            <th style={{ ...thStyle, width: "5%" }}>TELA<br/>N</th>
            <th style={{ ...thStyle, width: "10%" }}>OBSERVACIÓN</th>
            <th style={{ ...thStyle, width: "7%" }}>{incoterm} UNIT<br/>USD</th>
            <th style={{ ...thStyle, width: "8%" }}>TOTAL {incoterm}</th>
          </tr>
        </thead>
        <tbody>
          {processedData.rows?.map((row, index) => {
            const brandSpan = (processedData.brandSpans || [])[index];
            const descSpan = (processedData.descSpans || [])[index];
            const isFirstInBrand = brandSpan > 0;

            // Get photo for brand
            let photoUrl = "";
            if (isFirstInBrand) {
              const brandMt = row.mt;
              photoUrl = brandMt?.modulo?.marca?.imagem || "";
              if (photoUrl && !photoUrl.startsWith("http") && !photoUrl.startsWith("data:")) {
                photoUrl = `data:image/png;base64,${photoUrl}`;
              }
            }

            return (
              <tr key={row.item.id || index} style={{ borderBottom: "1px solid #ccc" }}>
                {/* FOTO - merged by brand */}
                {isFirstInBrand && (
                  <td rowSpan={brandSpan} style={{ ...cellStyle, padding: 4, verticalAlign: "middle" }}>
                    {photoUrl && (
                      <img
                        src={photoUrl}
                        alt={row.referencia}
                        style={{ maxWidth: "60px", maxHeight: "60px" }}
                      />
                    )}
                  </td>
                )}

                {/* REFERENCIA - merged by brand */}
                {isFirstInBrand && (
                  <td
                    rowSpan={brandSpan}
                    style={{
                      ...cellStyle,
                      fontWeight: "bold",
                      fontSize: "10px",
                      background: "#eff6ff",
                    }}
                  >
                    {row.referencia}
                  </td>
                )}

                {/* DESCRIPCIÓN - merged by description within brand */}
                {descSpan > 0 && (
                  <td
                    rowSpan={descSpan}
                    style={{ ...cellStyle, textAlign: "left", fontSize: "9px" }}
                  >
                    {row.descricao}
                  </td>
                )}

                {/* MARCA (fornecedor/categoria) */}
                <td style={{ ...cellStyle, fontSize: "9px" }}>{row.marcaFornecedor}</td>

                {/* LARG. */}
                <td style={cellStyle}>{fmtBR(row.largura)}</td>

                {/* ALT. */}
                <td style={cellStyle}>{fmtBR(row.altura)}</td>

                {/* PROF. */}
                <td style={cellStyle}>{fmtBR(row.profundidade)}</td>

                {/* CANT. UNIDAD */}
                <td style={{ ...cellStyle, fontWeight: "bold" }}>{row.quantidade}</td>

                {/* TOTAL VOL M³ */}
                <td style={cellStyle}>{fmtBR(row.volM3)}</td>

                {/* FABRIC */}
                <td style={{ ...cellStyle, background: "#f0fdf4", color: "#166534", fontWeight: "bold" }}>
                  {row.fabricName}
                </td>

                {/* TELA N */}
                <td style={cellStyle}>{row.telaCode}</td>

                {/* OBSERVACIÓN */}
                <td style={{ ...cellStyle, textAlign: "left", fontSize: "8px" }}>{row.observacao}</td>

                {/* UNIT USD */}
                <td style={{ ...cellStyle, textAlign: "right", background: "#fff1f2" }}>
                  $ {fmt(row.unitPrice)}
                </td>

                {/* TOTAL USD */}
                <td style={{ ...cellStyle, textAlign: "right", fontWeight: "bold", background: "#fff1f2" }}>
                  $ {fmt(row.totalPrice)}
                </td>
              </tr>
            );
          })}
        </tbody>

        {/* TOTALS ROW */}
        <tfoot>
          <tr style={{ fontWeight: "bold", background: "#f8f9fa" }}>
            <td colSpan={7} style={{ ...cellStyle, textAlign: "right", fontSize: "10px" }}>
              TOTAL
            </td>
            <td style={{ ...cellStyle, fontWeight: "bold" }}>
              {processedData.totalQty}
            </td>
            <td style={{ ...cellStyle, fontWeight: "bold" }}>
              {fmtBR(processedData.totalM3)}
            </td>
            <td colSpan={3} style={cellStyle}></td>
            <td style={{ ...cellStyle, textAlign: "right", background: "#fef2f2", fontSize: "10px" }}>
            </td>
            <td style={{ ...cellStyle, textAlign: "right", background: "#fef2f2", fontWeight: "bold", fontSize: "11px" }}>
              $ {fmt(processedData.totalValue)}
            </td>
          </tr>
        </tfoot>
      </table>

      {/* ═══════════════ FOOTER ═══════════════ */}
      <div
        style={{
          display: "grid",
          gridTemplateColumns: "1fr 1fr",
          gap: 0,
          border: "1px solid #000",
          marginTop: 15,
          fontSize: "11px",
        }}
      >
        <div style={{ padding: 10, borderRight: "1px solid #000" }}>
          <h3 style={{ margin: "0 0 5px 0", fontSize: "12px", textTransform: "uppercase" }}>
            ACCOUNTING DETAILS:
          </h3>
          <p style={{ margin: "2px 0" }}><strong>Beneficiary:</strong> FERGUILE ESTOFADOS LTDA</p>
          <p style={{ margin: "2px 0" }}><strong>CNPJ:</strong> 27.499.537/0001-02</p>
          <p style={{ margin: "2px 0" }}><strong>BANK:</strong> SICREDI 748</p>
          <p style={{ margin: "2px 0" }}><strong>BENEFICIARY ACCOUNT:</strong> 0723/032524</p>
          <p style={{ margin: "2px 0" }}><strong>IBAN CODE:</strong> BR7001181521007230000003252C1</p>
          <p style={{ margin: "2px 0" }}><strong>SWIFT CODE:</strong> BCSIBRRS748</p>
        </div>
        <div style={{ padding: 10 }}>
          <p style={{ margin: "2px 0" }}>
            <strong>Volume:</strong> {processedData.totalQty}
          </p>
          <p style={{ margin: "2px 0" }}>
            <strong>NCM:</strong> 94016100
          </p>
          <p style={{ margin: "2px 0" }}>
            <strong>Brand:</strong> Ferguile / Livintus
          </p>
          <p style={{ margin: "2px 0" }}>
            <strong>Factory original products</strong>
          </p>
          <p style={{ margin: "10px 0 2px 0" }}>
            <strong>CBM M³:</strong> {fmtBR(processedData.totalM3, 3)}
          </p>
          <p style={{ margin: "2px 0" }}>
            <strong>P.N. TOTAL (KG):</strong> {fmtBR(processedData.totalM3 * 150, 2)}
          </p>
          <p style={{ margin: "2px 0" }}>
            <strong>P.B. TOTAL (KG):</strong> {fmtBR(processedData.totalM3 * 165, 2)}
          </p>
          <p style={{ margin: "2px 0" }}>
            <strong>Made in Brasil</strong>
          </p>
        </div>
      </div>

      <div
        style={{
          marginTop: 40,
          borderTop: "1px solid #000",
          paddingTop: 10,
          textAlign: "center",
          fontSize: 10,
        }}
        className="no-print"
      >
        Visualização de Impressão - PI Ferguile
      </div>
    </div>
  );
}
