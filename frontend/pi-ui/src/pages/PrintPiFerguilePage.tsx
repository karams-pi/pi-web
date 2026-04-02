
import React, { useEffect, useState, useMemo, useCallback } from "react";
import { useParams } from "react-router-dom";
import { getPi } from "../api/pis";
import type { ProformaInvoice, ModuloTecido } from "../api/types";
import { getCliente, type Cliente } from "../api/clientes";
import { getSupplierMetadata } from "../utils/supplierDefaults";


export default function PrintPiFerguilePage() {
  const { id } = useParams();
  const [pi, setPi] = useState<ProformaInvoice | null>(null);
  const [cliente, setCliente] = useState<Cliente | null>(null);
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
        FOTO: "FOTO", REF: "REF", MARCA: "NOME", DESC: "DESCRIÇÃO", LARG: "LARG.", PROF: "PROF.", ALT: "ALT.", PA: "P.A.", 
        QTD: "QTD UNID", QTD_PECA: "QTD SOFÁ", M3: "TOTAL VOLUME M³", 
        TECIDO: "TECIDO", TELA: "TELA N", OBS: "OBS...", PES: "PÉS", ACAB: "ACABAMENTO", EXW: "EXW UNIT", FRETE: "FRETE UNIT", 
        UNIT_FINAL: "PREÇO UNIT. MÓDULO", UNIT: "UNIT DOLAR", TOTAL: "TOTAL USD",
        DATE: "DATA:", ORDER_DATE: "DATA PEDIDO:", SHIPMENT_POINT: "PONTO DE EMBARQUE:", DESTINATION_POINT: "PONTO DE DESTINO:", DELIVERY_TIME: "TEMPO DE ENTREGA:",
        INCOTERM: "INCOTERM:", PAYMENT_CONDITION: "CONDIÇÃO DE PAGAMENTO:", BANK_DETAILS: "DADOS BANCÁRIOS:", PRODUCT_DATA: "DADOS GERAIS DO PRODUTO", VALIDITY_NOTE: "* Esta proforma é válida por {0} dias a partir da data de emissão.",
        ORIGIN: "Hecho en Brasil", BRAND: "Marca", PRODUCT: "Produto", LOADING: "Carregando documento...", NIT: "CNPJ/NIT:", ADDRESS: "ENDEREÇO:", CITY: "CIDADE:", COUNTRY: "PAÍS:", EMAIL: "EMAIL:", IMPORTER: "IMPORTADOR:"
      },
      ES: {
        FOTO: "FOTO", REF: "REF", MARCA: "NOMBRE", DESC: "DESCRIPCIÓN", LARG: "LARG.", PROF: "PROF.", ALT: "ALT.", PA: "P.A.", 
        QTD: "CANT UNID", QTD_PECA: "CANT SOFÁ", M3: "TOTAL VOLUMEN M³", 
        TECIDO: "TELA", TELA: "TELA N", OBS: "OBS...", PES: "PIES", ACAB: "ACABADO", EXW: "EXW UNIT", FRETE: "FLETE UNIT", 
        UNIT_FINAL: "PRECIO UNIT. MODULO", UNIT: "UNIT DOLAR", TOTAL: "TOTAL USD",
        DATE: "FECHA:", ORDER_DATE: "PEDIDO FECHA:", SHIPMENT_POINT: "PUNTO DE EMBARQUE:", DESTINATION_POINT: "PUNTO DE DESTINO:", DELIVERY_TIME: "TIEMPO DE ENTREGA:",
        INCOTERM: "INCOTERM:", PAYMENT_CONDITION: "CONDICIÓN DE PAGO:", BANK_DETAILS: "DETALLES BANCARIOS:", PRODUCT_DATA: "DATOS GENERALES DEL PRODUCTO", VALIDITY_NOTE: "* Esta proforma é válida por {0} dias a partir de la data de emissão.",
        ORIGIN: "Hecho en Brasil", BRAND: "Marca", PRODUCT: "Produto", LOADING: "Cargando documento...", NIT: "NIT:", ADDRESS: "DIRECCIÓN:", CITY: "CIUDAD:", COUNTRY: "PAÍS:", EMAIL: "EMAIL:", IMPORTER: "IMPORTADOR:"
      },
      EN: {
        FOTO: "PHOTO", REF: "REF", MARCA: "NAME", DESC: "DESCRIPTION", LARG: "WIDTH", PROF: "DEPTH", ALT: "HEIGHT", PA: "P.A.", 
        QTD: "UNIT QTY", QTD_PECA: "SOFA QTY", M3: "TOTAL VOLUME M³", 
        TECIDO: "FABRIC", TELA: "FABRIC N", OBS: "OBS...", PES: "FEET", ACAB: "FINISHING", EXW: "EXW UNIT", FRETE: "FREIGHT UNIT", 
        UNIT_FINAL: "UNIT PRICE MODULE", UNIT: "USD UNIT", TOTAL: "TOTAL USD",
        DATE: "DATE:", ORDER_DATE: "ORDER DATE:", SHIPMENT_POINT: "SHIPMENT POINT:", DESTINATION_POINT: "DESTINATION POINT:", DELIVERY_TIME: "DELIVERY TIME:",
        INCOTERM: "INCOTERM:", PAYMENT_CONDITION: "PAYMENT CONDITION:", BANK_DETAILS: "BANKING DETAILS:", PRODUCT_DATA: "GENERAL PRODUCT DATA", VALIDITY_NOTE: "* This proforma is valid for {0} days from the date of issue.",
        ORIGIN: "Made in Brazil", BRAND: "Brand", PRODUCT: "Product", LOADING: "Loading document...", NIT: "TAX ID / VAT:", ADDRESS: "ADDRESS:", CITY: "CITY:", COUNTRY: "COUNTRY:", EMAIL: "EMAIL:", IMPORTER: "IMPORTER:"
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
        if (piData.idCliente) {
            try {
                const clientData = await getCliente(String(piData.idCliente));
                setCliente(clientData);
            } catch (err) {
                console.warn("Falha ao buscar cliente", err);
            }
        }
      } catch (error) {
        console.error("Erro ao carregar PI para impressão:", error);
        alert("Erro ao carregar documento.");
      } finally {
        setLoading(false);
      }
    }
    load();
  }, [id]);

  const fmt = (n: number | undefined, decimals = 2) => (n || 0).toLocaleString("pt-BR", { minimumFractionDigits: decimals, maximumFractionDigits: decimals });
  const fmt3 = (n: number | undefined) => (n || 0).toLocaleString("pt-BR", { minimumFractionDigits: 3, maximumFractionDigits: 3 });

  const safeDate = (dateStr: string | undefined) => { if (!dateStr) return new Date(); const d = new Date(dateStr); return isNaN(d.getTime()) ? new Date() : d; };
  const dateObj = safeDate(pi?.dataPi);
  const displayClient = cliente || (pi as any)?.cliente;
  const incoterm = pi?.frete?.nome || (pi as any)?.Frete?.Nome || "EXW";
  const supplierMetadata = useMemo(() => {
    const sName = (pi?.fornecedor?.nome || (pi as any)?.Fornecedor?.Nome || "ferguile");
    return getSupplierMetadata(sName);
  }, [pi]);

  const processedData = useMemo(() => {
    if (!pi) return { rows: [], brandSpans: [], descSpans: [], pieceTotalUnitUSDCol: [], totalValue: 0, totalM3: 0, totalQty: 0, totalSofaQty: 0, risk: 1 };
    const allItems: any[] = [];
    let totalSofaQty = 0;
    const risk = Number(pi.cotacaoRisco) || 1;

    if (pi.piItensPecas && pi.piItensPecas.length > 0) {
        pi.piItensPecas.forEach((peca: any) => {
            totalSofaQty += (peca.quantidade || 0);
            if (peca.piItens) peca.piItens.forEach((item: any) => allItems.push({ ...item, quantidadePeca: peca.quantidade, idPiItemPeca: peca.id }));
        });
    } else if (pi.piItens) {
        pi.piItens.forEach((i: any) => { allItems.push({ ...i, quantidadePeca: i.quantidadePeca || 1 }); totalSofaQty += (i.quantidadePeca || 1); });
    }

    const rows = allItems.map((item) => {
      const mt = item.moduloTecido || (item as any).ModuloTecido;
      const marca = mt?.modulo?.marca?.nome || "Outros";
      const volM3 = (item.m3 || 0) * (item.quantidade || 0);
      const isBRL = currency === "BRL";
      const lineExwUnitUSD = (Number(item.valorEXW || 0)) + (Number(item.valorFreteRateadoUSD || 0));
      const itemUnitFinalDisp = lineExwUnitUSD * (Number(item.quantidade || 0)) * (isBRL ? risk : 1);

      return {
        item, mt, referencia: marca, descricao: mt?.modulo?.descricao || "",
        quantidade: item.quantidade, quantidadePeca: item.quantidadePeca, volM3,
        fabricName: (mt?.tecido?.nome || "Sem Tecido") + (item.codigoModuloTecido ? ` - ${item.codigoModuloTecido}` : ""), 
        itemUnitFinalDisp
      };
    });

    const brandSpans: number[] = new Array(rows.length).fill(0);
    const descSpans: number[] = new Array(rows.length).fill(0);
    const pieceTotalUnitUSDCol: number[] = new Array(rows.length).fill(0);

    for (let i = 0; i < rows.length; i++) {
      if (brandSpans[i] === -1) continue;
      let span = 1;
      for (let j = i + 1; j < rows.length; j++) { if (rows[j].referencia === rows[i].referencia) { span++; brandSpans[j] = -1; } else break; }
      brandSpans[i] = span;
    }

    for (let i = 0; i < rows.length; i++) {
        if (descSpans[i] === -1) continue;
        let span = 1; let sumLineDisp = rows[i].itemUnitFinalDisp;
        const pieceIdI = rows[i].item.idPiItemPeca || rows[i].item.id;
        for (let j = i + 1; j < rows.length; j++) {
            const pieceIdJ = rows[j].item.idPiItemPeca || rows[j].item.id;
            if (pieceIdJ === pieceIdI) { span++; descSpans[j] = -1; sumLineDisp += rows[j].itemUnitFinalDisp; } else break;
        }
        descSpans[i] = span; pieceTotalUnitUSDCol[i] = sumLineDisp;
    }

    let totalValue = 0; let totalM3 = 0; let totalQty = 0;
    for (let i = 0; i < rows.length; i++) {
        if (descSpans[i] > 0) totalValue += (pieceTotalUnitUSDCol[i] * Number(rows[i].quantidadePeca || 1));
        totalM3 += rows[i].volM3 * (Number(rows[i].quantidadePeca || 1));
        totalQty += rows[i].quantidade * (Number(rows[i].quantidadePeca || 1));
    }

    return { rows, brandSpans, descSpans, pieceTotalUnitUSDCol, totalValue, totalM3, totalQty, totalSofaQty, risk };
  }, [pi, currency]);

  const formattedPiNumber = useMemo(() => {
    if (!pi) return "";
    const base = `${pi.prefixo}-${pi.piSequencia}`;
    const piItensList = pi.piItens || [];
    if (piItensList.length > 0) {
        const item = piItensList[0];
        const mt = (item as any).moduloTecido || (item as any).ModuloTecido;
        if ((mt?.modulo?.fornecedor?.nome || "").toLowerCase().includes("karams")) return `${base}/${String(dateObj.getFullYear()).slice(-2)}`;
    }
    return base;
  }, [pi, dateObj]);

  if (loading) return <div style={{ padding: 20 }}>{t("LOADING")}</div>;
  if (!pi) return <div style={{ padding: 20 }}>Documento não encontrado.</div>;

  const cellStyle: React.CSSProperties = { border: "1px solid #000", padding: "3px 5px", textAlign: "center", verticalAlign: "middle", fontSize: "9px" };
  const thStyle: React.CSSProperties = { ...cellStyle, background: "#2c3e50", color: "#fff", fontWeight: "bold", textTransform: "uppercase" };

  return (
    <div className="print-container" style={{ padding: "20px 30px", fontFamily: "Arial, sans-serif", maxWidth: "1200px", margin: "0 auto" }}>
      <style>{`@media print { @page { margin: 0.4cm; size: landscape; } .no-print { display: none !important; } }`}</style>
      <button className="btn-print no-print" onClick={() => window.print()} style={{ position: "fixed", top: 20, right: 20, padding: "10px 20px", background: "#2563eb", color: "white", border: "none", borderRadius: "8px", cursor: "pointer", zIndex: 1000 }}>🖨️ Imprimir</button>
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", border: "2px solid #000", marginBottom: 10 }}>
        <div style={{ padding: 10, borderRight: "2px solid #000", fontSize: "11px" }}>
          <div style={{ display: "flex", justifyContent: "space-between" }}><div style={{ fontWeight: "bold", fontSize: 13 }}>{supplierMetadata.name}</div><img src={supplierMetadata.logo} alt="Logo" style={{ maxWidth: 80 }} /></div>
          <div>{t("NIT")} {supplierMetadata.cnpj}</div>
          <div>{t("ADDRESS")} {supplierMetadata.address}</div>
          <div style={{ marginTop: 5 }}><strong>{t("DELIVERY_TIME")}</strong> {pi.tempoEntrega || "60 dias"}</div>
          <div><strong>{t("INCOTERM")}</strong> {incoterm}</div>
          <div><strong>{t("PAYMENT_CONDITION")}</strong> {pi.condicaoPagamento || "T/T"}</div>
        </div>
        <div style={{ padding: 10, fontSize: "11px" }}>
          <div style={{ fontWeight: "bold", fontSize: 13 }}>PROFORMA INVOICE: {formattedPiNumber}</div>
          <div>{t("DATE")} {dateObj.toLocaleDateString("pt-BR")}</div>
          <div style={{ marginTop: 6, fontWeight: "bold" }}>{t("IMPORTER")}</div>
          <div style={{ marginLeft: 20 }}><div>{displayClient?.nome || ""}</div><div>{t("NIT")} {displayClient?.nit || ""}</div><div>{t("ADDRESS")} {displayClient?.endereco || ""}</div></div>
        </div>
      </div>
      <table style={{ width: "100%", borderCollapse: "collapse" }}>
        <thead>
          <tr>
            <th style={thStyle}>{t("PHOTO")}</th><th style={thStyle}>{t("REF")}</th><th style={thStyle}>{t("DESC")}</th><th style={thStyle}>{t("QTD")}</th><th style={thStyle}>{t("QTD_PECA")}</th><th style={thStyle}>{t("M3")}</th><th style={thStyle}>{t("TECIDO")}</th><th style={thStyle}>{t("OBS")}</th><th style={thStyle}>{t("UNIT_FINAL")}</th><th style={thStyle}>{t("UNIT")}</th><th style={thStyle}>{t("TOTAL")}</th>
          </tr>
        </thead>
        <tbody>
          {processedData.rows.map((row, index) => {
            const bSpan = processedData.brandSpans[index]; const dSpan = processedData.descSpans[index]; const risk = processedData.risk; const isBR = currency === "BRL";
            return (
              <tr key={index}>
                {bSpan > 0 && <td rowSpan={bSpan} style={cellStyle}>{row.mt?.modulo?.marca?.imagem && <img src={row.mt.modulo.marca.imagem.startsWith("data:") ? row.mt.modulo.marca.imagem : `data:image/png;base64,${row.mt.modulo.marca.imagem}`} style={{ maxWidth: 50 }} />}</td>}
                {bSpan > 0 && <td rowSpan={bSpan} style={{ ...cellStyle, background: "#eff6ff" }}>{row.referencia}</td>}
                {dSpan > 0 && <td rowSpan={dSpan} style={{ ...cellStyle, textAlign: "left" }}>{row.descricao}</td>}
                <td style={cellStyle}>{row.quantidade}</td>
                {dSpan > 0 && <td rowSpan={dSpan} style={{ ...cellStyle, fontWeight: "bold" }}>{row.quantidadePeca}</td>}
                <td style={cellStyle}>{fmt3(row.volM3)}</td>
                <td style={{ ...cellStyle, background: "#f0fdf4" }}>{row.fabricName}</td>
                <td style={{ ...cellStyle, textAlign: "left" }}>{row.item.observacao || ""}</td>
                <td style={{ ...cellStyle, textAlign: "right" }}>{isBR ? "R$" : "$"} {fmt(row.itemUnitFinalDisp)}</td>
                {dSpan > 0 && <td rowSpan={dSpan} style={{ ...cellStyle, textAlign: "right", color: "#2563eb" }}>{isBR ? "R$" : "$"} {fmt(processedData.pieceTotalUnitUSDCol[index])}</td>}
                {dSpan > 0 && <td rowSpan={dSpan} style={{ ...cellStyle, textAlign: "right", fontWeight: "bold" }}>{isBR ? "R$" : "$"} {fmt(processedData.pieceTotalUnitUSDCol[index] * Number(row.quantidadePeca || 1))}</td>}
              </tr>
            );
          })}
        </tbody>
        <tfoot>
          <tr style={{ background: "#f8f9fa", fontWeight: "bold" }}>
            <td colSpan={3} style={{ ...cellStyle, textAlign: "right" }}>{t("TOTAL")}</td><td style={cellStyle}>{processedData.totalQty}</td><td style={cellStyle}>{processedData.totalSofaQty}</td><td style={cellStyle}>{fmt3(processedData.totalM3)}</td><td colSpan={3} style={cellStyle}></td><td colSpan={2} style={{ ...cellStyle, textAlign: "right", background: "#fff1f2" }}>{currency === "BRL" ? "R$" : "$"} {fmt(processedData.totalValue)}</td>
          </tr>
        </tfoot>
      </table>
    </div>
  );
}
