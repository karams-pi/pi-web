
import React, { useEffect, useState, useMemo, useCallback } from "react";
import { useParams } from "react-router-dom";
import { getPi } from "../api/pis";
import type { ProformaInvoice, ModuloTecido, PiItem } from "../api/types";
import { listModulosTecidos } from "../api/modulos";
import { getCliente, type Cliente } from "../api/clientes";
import { getSupplierMetadata } from "../utils/supplierDefaults";


export default function PrintPiFerguilePage() {
  const { id } = useParams();
  const [pi, setPi] = useState<ProformaInvoice | null>(null);
  const [cliente, setCliente] = useState<Cliente | null>(null);
  const [modulosTecidos, setModulosTecidos] = useState<ModuloTecido[]>([]);
  const [loading, setLoading] = useState(true);

  const urlParams = useMemo(() => {
    const hash = window.location.hash;
    const searchPart = hash.includes('?') ? hash.split('?')[1] : '';
    return new URLSearchParams(searchPart || window.location.search);
  }, []);
  const currency = (urlParams.get("currency") as "BRL" | "EXW") || "EXW";
  const lang = (urlParams.get("lang") || "PT").toUpperCase();

  const t = useCallback((key: string) => {
    const dicts: Record<string, Record<string, string>> = {
      PT: {
        IMPORTER: "IMPORTADOR:", ADDRESS: "ENDEREÇO:", CITY: "CIDADE:", COUNTRY: "PAÍS:", NIT: "CNPJ:", PHONE: "TELEFONE:", RESPONSIBLE: "RESPONSÁVEL:", EMAIL: "E-MAIL:",
        DATE: "DATA:", ORDER_DATE: "DATA PEDIDO:", SHIPMENT_POINT: "PONTO DE EMBARQUE:", DESTINATION_POINT: "PONTO DE DESTINO:", DELIVERY_TIME: "TEMPO DE ENTREGA:",
        INCOTERM: "INCOTERM:", PAYMENT_CONDITION: "CONDIÇÃO DE PAGAMENTO:", PHOTO: "FOTO", NAME: "NOME", DESCRIPTION: "DESCRIÇÃO", DIMENSIONS: "DIMENSÕES (m)",
        WIDTH: "LARG.", DEPTH: "PROF.", HEIGHT: "ALT.", QTY_UNIT: "CANT", TOTAL_VOLUME: "TOTAL VOL M³", FABRIC: "TECIDO", TELA: "TELA N", OBSERVATION: "OBSERVAÇÃO", 
        TOTAL: "TOTAL", BANK_DETAILS: "DETALLES BANCARIOS:", PRODUCT_DATA: "DATOS GENERALES DEL PRODUCTO", VALIDITY_NOTE: "* Esta proforma é válida por {0} dias a partir da data de emissão.",
        ORIGIN: "Hecho en Brasil", BRAND: "Marca", PRODUCT: "Produto", LOADING: "Carregando documento...", REFERENCIA: "REFERÊNCIA", MARCA: "MARCA"
      },
      ES: {
        IMPORTER: "IMPORTADOR:", ADDRESS: "DIRECCIÓN:", CITY: "CIUDAD:", COUNTRY: "PAÍS:", NIT: "NIT:", PHONE: "TELÉFONO:", RESPONSIBLE: "RESPONSABLE:", EMAIL: "E-MAIL:",
        DATE: "FECHA:", ORDER_DATE: "PEDIDO FECHA:", SHIPMENT_POINT: "PUNTO DE EMBARQUE:", DESTINATION_POINT: "PUNTO DE DESTINO:", DELIVERY_TIME: "TIEMPO DE ENTREGA:",
        INCOTERM: "INCOTERM:", PAYMENT_CONDITION: "CONDICIÓN DE PAGO:", PHOTO: "FOTO", NAME: "NOMBRE", DESCRIPTION: "DESCRIPCIÓN", DIMENSIONS: "DIMENSIONES (m)",
        WIDTH: "LARG.", DEPTH: "PROF.", HEIGHT: "ALT.", QTY_UNIT: "CANT", TOTAL_VOLUME: "TOTAL VOL M³", FABRIC: "TELA", TELA: "TELA N", OBSERVATION: "OBSERVACIÓN", 
        TOTAL: "TOTAL", BANK_DETAILS: "DETALLES BANCARIOS:", PRODUCT_DATA: "DATOS GENERALES DEL PRODUCTO", VALIDITY_NOTE: "* Esta proforma es válida por {0} días a partir de la fecha de emisión.",
        ORIGIN: "Hecho en Brasil", BRAND: "Marca", PRODUCT: "Producto", LOADING: "Cargando documento...", REFERENCIA: "REFERENCIA", MARCA: "MARCA"
      },
      EN: {
        IMPORTER: "IMPORTER:", ADDRESS: "ADDRESS:", CITY: "CITY:", COUNTRY: "COUNTRY:", NIT: "TAX ID / VAT:", PHONE: "PHONE:", RESPONSIBLE: "RESPONSIBLE:", EMAIL: "E-MAIL:",
        DATE: "DATE:", ORDER_DATE: "ORDER DATE:", SHIPMENT_POINT: "SHIPMENT POINT:", DESTINATION_POINT: "DESTINATION POINT:", DELIVERY_TIME: "DELIVERY TIME:",
        INCOTERM: "INCOTERM:", PAYMENT_CONDITION: "PAYMENT CONDITION:", PHOTO: "PHOTO", NAME: "NAME", DESCRIPTION: "DESCRIPTION", DIMENSIONS: "DIMENSIONS (m)",
        WIDTH: "WIDTH", DEPTH: "DEPTH", HEIGHT: "HEIGHT", QTY_UNIT: "QTY", TOTAL_VOLUME: "TOTAL CBM", FABRIC: "FABRIC", TELA: "FABRIC N", OBSERVATION: "OBSERVATION", 
        TOTAL: "TOTAL", BANK_DETAILS: "BANKING DETAILS:", PRODUCT_DATA: "GENERAL PRODUCT DATA", VALIDITY_NOTE: "* This proforma is valid for {0} days from the date of issue.",
        ORIGIN: "Made in Brazil", BRAND: "Brand", PRODUCT: "Product", LOADING: "Loading document...", REFERENCIA: "REFERENCE", MARCA: "BRAND"
      }
    };
    return dicts[lang]?.[key] || key;
  }, [lang]);

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
  const incoterm = pi?.frete?.nome || (pi as any)?.Frete?.Nome || "EXW";
  const showFreight = ["FOB", "FCA (FRONTEIRA)", "CIF", "FCA (FÁBRICA)"].includes(incoterm.toUpperCase());

  const supplierMetadata = useMemo(() => {
    const sName = (pi?.fornecedor?.nome || (pi as any)?.Fornecedor?.Nome || "ferguile");
    return getSupplierMetadata(sName);
  }, [pi]);




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
      const mt = (item as any).moduloTecido || modulosTecidos.find((m) => m.id === item.idModuloTecido);
      const marca = mt?.modulo?.marca?.nome || "Outros";
      const marcaFornecedor = mt?.modulo?.fornecedor?.nome || mt?.modulo?.categoria?.nome || supplierMetadata.details.brand;
      const descricao = mt?.modulo?.descricao || "";
      const fabricName = mt?.tecido?.nome || "";
      const telaCode = item.tempCodigoModuloTecido || mt?.codigoModuloTecido || "";
      const volM3 = (item.m3 || 0) * (item.quantidade || 0);
      const unitPrice = item.valorEXW || 0;
      const freightUnit = (item.valorFreteRateadoUSD || 0);
      const displayUnitPrice = currency === "BRL" ? (item.valorFinalItemBRL / (item.quantidade || 1)) : (unitPrice + (showFreight ? freightUnit : 0));
      const totalPrice = currency === "BRL" ? item.valorFinalItemBRL : (displayUnitPrice * (item.quantidade || 1));

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
        unitPrice: displayUnitPrice,
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

    const totalValue = rows.reduce((s, r) => {
        const item = r.item as any;
        if (currency === "BRL") return s + (Number(item.valorFinalItemBRL ?? item.ValorFinalItemBRL) || 0);
        const exw = (Number(item.valorEXW ?? item.ValorEXW) || 0) * (Number(item.quantidade ?? item.Quantidade) || 0);
        const freight = (Number(item.valorFreteRateadoUSD ?? item.ValorFreteRateadoUSD) || 0) * (Number(item.quantidade ?? item.Quantidade) || 0);
        return s + exw + (showFreight ? freight : 0);
    }, 0);
    const totalM3 = rows.reduce((s, r) => s + r.volM3, 0);
    const totalQty = rows.reduce((s, r) => s + r.quantidade, 0);

    return { rows, brandSpans, descSpans, totalValue, totalM3, totalQty };
  }, [pi, modulosTecidos, currency, showFreight, supplierMetadata?.details?.brand]);

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

  if (loading) return <div style={{ padding: 20 }}>{t("LOADING")}</div>;
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
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 6 }}>
            <div style={{ fontWeight: "bold", fontSize: "13px", textTransform: "uppercase" }}>
              {supplierMetadata.name}
            </div>
            <img src={supplierMetadata.logo} alt={supplierMetadata.details.brand} style={{ maxWidth: "80px", maxHeight: "40px" }} />
          </div>
          <div>{t("NIT")} {supplierMetadata.cnpj}</div>
          <div>{t("ADDRESS")} {supplierMetadata.address}</div>
          <div>{t("CITY")} Ribeirão Bandeirante do Norte</div>
          <div>CÓDIGO POSTAL / ZIP CODE: {supplierMetadata.zip}</div>
          <div>{supplierMetadata.city} - {supplierMetadata.state}</div>
          <div>{t("COUNTRY")} {supplierMetadata.country}</div>
          <div style={{ marginTop: 6 }}>
            <strong>{t("DELIVERY_TIME")}</strong>{" "}
            {pi.tempoEntrega || (lang === "ES" ? "60 dias" : (lang === "EN" ? "60 days" : "60 dias"))}
          </div>
          <div>
            <strong>{t("INCOTERM")}</strong> {incoterm} - ARAPONGAS PR
          </div>
          <div>
            <strong>{t("PAYMENT_CONDITION")}</strong> {pi.condicaoPagamento || pi.configuracoes?.condicoesPagamento || "A VISTA"}
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
            {t("DATE")} {dateObj.toLocaleDateString("pt-BR")}
          </div>
          <div>
            PROFORMA INVOICE: {formattedPiNumber}
          </div>
          <div>
            {t("ORDER_DATE")} {dateObj.toLocaleDateString("pt-BR")}
          </div>
          <div style={{ marginTop: 6, fontWeight: "bold" }}>{t("IMPORTER")}</div>
          <div style={{ marginLeft: 20 }}>
            <div>{displayClient?.empresa || displayClient?.nome || ""}</div>
            {displayClient?.nit && <div>{t("NIT")} {displayClient.nit}</div>}
            {displayClient?.endereco && <div>{t("ADDRESS")} {displayClient.endereco}{displayClient?.cidade ? `, ${displayClient.cidade}` : ""}</div>}
            {displayClient?.cep && <div>CÓDIGO POSTAL / ZIP CODE: {displayClient.cep}</div>}
            {displayClient?.pais && <div>{t("COUNTRY")} {displayClient.pais}</div>}
            {displayClient?.pessoaContato && <div>{t("RESPONSIBLE")} {displayClient.pessoaContato}</div>}
            {displayClient?.telefone && <div>{t("PHONE")} {displayClient.telefone}</div>}
            {displayClient?.email && <div>{t("EMAIL")} {displayClient.email}</div>}
          </div>
        </div>
      </div>

      {/* ═══════════════ TABLE ═══════════════ */}
      <table style={{ width: "100%", borderCollapse: "collapse", border: "1px solid #000", marginTop: 0 }}>
        <thead>
          <tr>
            <th style={{ ...thStyle, width: "6%" }}>{t("PHOTO")}</th>
            <th style={{ ...thStyle, width: "8%" }}>{t("REFERENCIA")}</th>
            <th style={{ ...thStyle, width: "14%" }}>{t("DESCRIPTION")}</th>
            <th style={{ ...thStyle, width: "7%" }}>{t("MARCA")}</th>
            <th style={{ ...thStyle, width: "5%" }}>{t("WIDTH")}</th>
            <th style={{ ...thStyle, width: "5%" }}>{t("HEIGHT")}</th>
            <th style={{ ...thStyle, width: "5%" }}>{t("DEPTH")}</th>
            <th style={{ ...thStyle, width: "5%" }}>{t("QTY_UNIT")}</th>
            <th style={{ ...thStyle, width: "5%" }}>{t("TOTAL_VOLUME")}</th>
            <th style={{ ...thStyle, width: "7%" }}>{t("FABRIC")}</th>
            <th style={{ ...thStyle, width: "5%" }}>{t("TELA")}</th>
            <th style={{ ...thStyle, width: "10%" }}>{t("OBSERVATION")}</th>
            <th style={{ ...thStyle, width: "7%" }}>{incoterm} UNIT<br/>{currency === "BRL" ? "R$" : "DOLAR"}</th>
            <th style={{ ...thStyle, width: "8%" }}>TOTAL {incoterm}<br/>{currency === "BRL" ? "R$" : "USD"}</th>
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

                {/* Freight: Removido conforme solicitação (mas o valor continua somado no preço unitário) */}

                {/* UNIT PRICE */}
                <td style={{ ...cellStyle, textAlign: "right", background: currency === "BRL" ? "#f0f9ff" : "#fff1f2" }}>
                  {currency === "BRL" ? "R$" : "$"} {currency === "BRL" ? fmtBR(row.unitPrice) : fmt(row.unitPrice)}
                </td>

                {/* TOTAL PRICE */}
                <td style={{ ...cellStyle, textAlign: "right", fontWeight: "bold", background: currency === "BRL" ? "#f0f9ff" : "#fff1f2" }}>
                  {currency === "BRL" ? "R$" : "$"} {currency === "BRL" ? fmtBR(row.totalPrice) : fmt(row.totalPrice)}
                </td>

              </tr>
            );
          })}
        </tbody>

        {/* TOTALS ROW */}
        <tfoot>
          <tr style={{ fontWeight: "bold", background: "#f8f9fa" }}>
            <td colSpan={7} style={{ ...cellStyle, textAlign: "right", fontSize: "10px" }}>
              {t("TOTAL")}
            </td>
            <td style={{ ...cellStyle, fontWeight: "bold", textAlign: "center" }}>
              {processedData.totalQty}
            </td>
            <td style={{ ...cellStyle, fontWeight: "bold", textAlign: "center" }}>
              {fmtBR(processedData.totalM3)}
            </td>
            <td colSpan={4} style={cellStyle}></td>
            <td style={{ ...cellStyle, textAlign: "right", background: "#fef2f2", fontWeight: "bold", fontSize: "11px" }}>
              {currency === "BRL" ? "R$" : "$"} {currency === "BRL" ? fmtBR(processedData.totalValue) : fmt(processedData.totalValue)}
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
            {t("BANK_DETAILS")}
          </h3>
          <p style={{ margin: "2px 0" }}><strong>{t("NAME")}:</strong> {supplierMetadata.bankDetails.beneficiaryName}</p>
          <p style={{ margin: "2px 0" }}><strong>{t("NIT")}</strong> {supplierMetadata.cnpj}</p>
          <p style={{ margin: "2px 0" }}><strong>{lang === "EN" ? "BANK:" : "BANCO:"}</strong> {supplierMetadata.bankDetails.beneficiary}</p>
          <p style={{ margin: "2px 0" }}><strong>{lang === "EN" ? "BENEFICIARY ACCOUNT:" : "CUENTA BENEFICIARIA:"}</strong> {supplierMetadata.bankDetails.beneficiaryAccount}</p>
          {supplierMetadata.bankDetails.beneficiaryIban && <p style={{ margin: "2px 0" }}><strong>IBAN:</strong> {supplierMetadata.bankDetails.beneficiaryIban}</p>}
          <p style={{ margin: "2px 0" }}><strong>SWIFT:</strong> {supplierMetadata.bankDetails.beneficiarySwift}</p>

        </div>
        <div style={{ padding: 10 }}>
          <h3 style={{ borderBottom: "none", marginBottom: 5 }}>{t("PRODUCT_DATA")}</h3>
          <p style={{ margin: "2px 0" }}>
            <strong>{t("BRAND")}:</strong> {supplierMetadata.details.brand}
          </p>
          <p style={{ margin: "2px 0" }}>
            <strong>NCM:</strong> {supplierMetadata.details.ncm || "94016100"}
          </p>
          <p style={{ margin: "2px 0" }}>
            <strong>{t("PRODUCT")}:</strong> {fmt(processedData.totalQty, 0)}
          </p>
          <p style={{ margin: "2px 0" }}>
            <strong>CBM M³:</strong> {fmtBR(processedData.totalM3, 3)}
          </p>
          <p style={{ margin: "2px 0" }}>
            <strong>P.N. TOTAL:</strong>
          </p>
          <p style={{ margin: "2px 0" }}>
            <strong>P.B. TOTAL:</strong>
          </p>
          <p style={{ margin: "2px 0" }}>
            <strong>{lang === "EN" ? "TOTAL VOLUME:" : "VOLUMEN TOTAL:"}</strong> {fmtBR(processedData.totalM3, 3)}
          </p>
          <p style={{ margin: "2px 0" }}>
            <strong>{lang === "PT" ? "Produtos originais de fabrica" : (lang === "EN" ? "Original factory products" : "Productos originales de fabrica")}</strong>
          </p>
          <p style={{ margin: "2px 0" }}>
            <strong>{t("ORIGIN")}</strong>
          </p>
          <p style={{ marginTop: 15, fontSize: "10px", fontStyle: "italic" }}>
            {t("VALIDITY_NOTE").replace("{0}", urlParams.get("validity") || "30")}
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
