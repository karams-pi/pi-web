
import React, { useEffect, useState, useMemo, useCallback } from "react";
import { useParams } from "react-router-dom";
import { getPi } from "../api/pis";
import type { ProformaInvoice, ModuloTecido } from "../api/types";
import { getCliente, type Cliente } from "../api/clientes";
import { getSupplierMetadata } from "../utils/supplierDefaults";


export default function PrintPiPage() {
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
        IMPORTER: "IMPORTADOR:", ADDRESS: "ENDEREÇO:", CITY: "CIDADE:", COUNTRY: "PAÍS:", NIT: "CNPJ:", PHONE: "TELEFONE:", RESPONSIBLE: "RESPONSÁVEL:", EMAIL: "EMAIL:",
        DATE: "DATA:", ORDER_DATE: "DATA PEDIDO:", SHIPMENT_POINT: "PONTO DE EMBARQUE:", DESTINATION_POINT: "PONTO DE DESTINO:", DELIVERY_TIME: "TEMPO DE ENTREGA:",
        INCOTERM: "INCOTERM:", PAYMENT_CONDITION: "CONDIÇÃO DE PAGAMENTO:", PHOTO: "FOTO", NAME: "NOME", DESCRIPTION: "DESCRIÇÃO", DIMENSIONS: "DIMENSÕES (m)",
        WIDTH: "LARG.", DEPTH: "PROF.", HEIGHT: "ALT.", QTY_UNIT: "QTD UNID", QTY_SOFA: "QTD SOFÁ", TOTAL_VOLUME: "VOL. TOTAL M³", FABRIC: "TECIDO", FEET: "PÉS",
        FINISHING: "ACABAMENTO", OBSERVATION: "OBSERVAÇÃO", UNIT_FINAL: "PREÇO UNIT. MÓDULO", TOTAL: "TOTAL", BANK_DETAILS: "DADOS BANCÁRIOS:", INTERMEDIARY_BANK: "BANCO INTERMEDIÁRIO",
        BENEFICIARY_BANK: "BANCO BENEFICIÁRIO", PRODUCT_DATA: "DADOS GERAIS DO PRODUTO", VALIDITY_NOTE: "* Esta proforma é válida por {0} dias a partir da data de emissão.",
        ORIGIN: "Hecho en Brasil", BRAND: "Marca", PRODUCT: "Produto", LOADING: "Carregando documento...", UNIT: "UNIT DOLAR"
      },
      ES: {
        IMPORTER: "IMPORTADOR:", ADDRESS: "DIRECCIÓN:", CITY: "CIUDAD:", COUNTRY: "PAÍS:", NIT: "NIT:", PHONE: "TELÉFONO:", RESPONSIBLE: "RESPONSABLE:", EMAIL: "EMAIL:",
        DATE: "FECHA:", ORDER_DATE: "PEDIDO FECHA:", SHIPMENT_POINT: "PUNTO DE EMBARQUE:", DESTINATION_POINT: "PUNTO DE DESTINO:", DELIVERY_TIME: "TIEMPO DE ENTREGA:",
        INCOTERM: "INCOTERM:", PAYMENT_CONDITION: "CONDICIÓN DE PAGO:", PHOTO: "FOTO", NAME: "NOMBRE", DESCRIPTION: "DESCRIPCIÓN", DIMENSIONS: "DIMENSIONES (m)",
        WIDTH: "LARG.", DEPTH: "PROF.", HEIGHT: "ALT.", QTY_UNIT: "CANT UNID", QTY_SOFA: "CANT SOFÁ", TOTAL_VOLUME: "TOTAL VOLUMEN M³", FABRIC: "TELA", FEET: "PIES",
        FINISHING: "ACABADO", OBSERVATION: "OBSERVACIÓN", UNIT_FINAL: "PRECIO UNIT. MODULO", TOTAL: "TOTAL", BANK_DETAILS: "DETALLES BANCARIOS:", INTERMEDIARY_BANK: "BANCO INTERMEDIARIO",
        BENEFICIARY_BANK: "BANCO BENEFICIARIO", PRODUCT_DATA: "DATOS GENERALES DEL PRODUCTO", VALIDITY_NOTE: "* Esta proforma é válida por {0} dias a partir de la data de emissão.",
        ORIGIN: "Hecho en Brasil", BRAND: "Marca", PRODUCT: "Produto", LOADING: "Cargando documento...", UNIT: "UNIT DOLAR"
      },
      EN: {
        IMPORTER: "IMPORTER:", ADDRESS: "ADDRESS:", CITY: "CITY:", COUNTRY: "COUNTRY:", NIT: "TAX ID / VAT:", PHONE: "PHONE:", RESPONSIBLE: "RESPONSIBLE:", EMAIL: "EMAIL:",
        DATE: "DATE:", ORDER_DATE: "ORDER DATE:", SHIPMENT_POINT: "SHIPMENT POINT:", DESTINATION_POINT: "DESTINATION POINT:", DELIVERY_TIME: "DELIVERY TIME:",
        INCOTERM: "INCOTERM:", PAYMENT_CONDITION: "PAYMENT CONDITION:", PHOTO: "PHOTO", NAME: "NAME", DESCRIPTION: "DESCRIPTION", DIMENSIONS: "DIMENSIONS (m)",
        WIDTH: "WIDTH", DEPTH: "DEPTH", HEIGHT: "HEIGHT", QTY_UNIT: "UNIT QTY", QTY_SOFA: "SOFA QTY", TOTAL_VOLUME: "TOTAL VOLUME M³", FABRIC: "FABRIC", FEET: "FEET",
        FINISHING: "FINISHING", OBSERVATION: "OBSERVATION", UNIT_FINAL: "UNIT PRICE MODULE", TOTAL: "TOTAL", BANK_DETAILS: "BANKING DETAILS:", INTERMEDIARY_BANK: "INTERMEDIARY BANK",
        BENEFICIARY_BANK: "BANK BENEFICIARY", PRODUCT_DATA: "GENERAL PRODUCT DATA", VALIDITY_NOTE: "* This proforma is valid for {0} days from the date of issue.",
        ORIGIN: "Made in Brazil", BRAND: "Brand", PRODUCT: "Product", LOADING: "Loading document...", UNIT: "UNIT DOLAR"
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
    const sName = (pi?.fornecedor?.nome || (pi as any)?.Fornecedor?.Nome || "karams");
    return getSupplierMetadata(sName);
  }, [pi]);

  const processedData = useMemo(() => {
    if (!pi) return { brandGroups: [], totalSofaQty: 0, totalQty: 0, totalM3: 0, totalValue: 0 };
    const allItems: any[] = [];
    let totalSofaQty = 0;
    const risk = Number(pi.cotacaoRisco) || 1;

    if (pi.piItensPecas && pi.piItensPecas.length > 0) {
        pi.piItensPecas.forEach((peca: any) => {
            totalSofaQty += (peca.quantidade || 0);
            if (peca.piItens) {
                peca.piItens.forEach((item: any) => {
                    allItems.push({ ...item, quantidadePeca: peca.quantidade, idPiItemPeca: peca.id });
                });
            }
        });
    } else if (pi.piItens) {
        pi.piItens.forEach((i: any) => {
            allItems.push({ ...i, quantidadePeca: i.quantidadePeca || 1 });
            totalSofaQty += (i.quantidadePeca || 1);
        });
    }

    if (allItems.length === 0) return { brandGroups: [], totalSofaQty, totalQty: 0, totalM3: 0, totalValue: 0 };

    const itemsByMarca: { [key: string]: { item: any, mt: ModuloTecido | undefined }[] } = {};
    allItems.forEach(i => {
        const item = i;
        const mt = item.moduloTecido || (item as any).ModuloTecido;
        
        // Recover dimensions from master module if blank in line item
        if (!item.largura && mt?.modulo?.largura) item.largura = mt.modulo.largura;
        if (!item.profundidade && mt?.modulo?.profundidade) item.profundidade = mt.modulo.profundidade;
        if (!item.altura && mt?.modulo?.altura) item.altura = mt.modulo.altura;

        // Force volume calculation if missing or 0
        if (!item.m3 || item.m3 === 0) {
            const lVal = Number(String(item.largura || 0).replace(',', '.'));
            const pVal = Number(String(item.profundidade || 0).replace(',', '.'));
            const aVal = Number(String(item.altura || 0).replace(',', '.'));
            const calcM3 = lVal * pVal * aVal;
            // Same unit threshold as in the main page
            if (calcM3 > 500) item.m3 = calcM3 / 1000000;
            else if (calcM3 > 0) item.m3 = calcM3;
        }

        const marca = mt?.modulo?.marca?.nome || "Outros";
        if (!itemsByMarca[marca]) itemsByMarca[marca] = [];
        itemsByMarca[marca].push({ item, mt });
    });

    const brandGroups = Object.entries(itemsByMarca).map(([_, brandItems]) => {
         const sortedItems = [...brandItems].sort((a, b) => {
             const fabKeyA = (a.mt?.tecido?.nome || "ZZBase").toLowerCase();
             const fabKeyB = (b.mt?.tecido?.nome || "ZZBase").toLowerCase();
             if (fabKeyA !== fabKeyB) return fabKeyA.localeCompare(fabKeyB);
             return (a.mt?.modulo?.descricao || "").localeCompare(b.mt?.modulo?.descricao || "");
         });

         const spans: any = { description: new Array(sortedItems.length).fill(0), fabric: new Array(sortedItems.length).fill(0), feet: new Array(sortedItems.length).fill(0), finishing: new Array(sortedItems.length).fill(0), observation: new Array(sortedItems.length).fill(0), qtySofa: new Array(sortedItems.length).fill(0), totalExw: new Array(sortedItems.length).fill(0) };
         const getMergeVal = (idx: number, type: string) => {
             const entry = sortedItems[idx];
             if (type === 'feet') return entry.item.feet || entry.item.Feet || "";
             if (type === 'finishing') return entry.item.finishing || entry.item.Finishing || "";
             if (type === 'observation') return entry.item.observacao || "";
             if (type === 'piece_group') return String(entry.item.idPiItemPeca || entry.item.id || idx);
             return "";
         };

         ['feet', 'finishing', 'observation'].forEach(field => {
             for (let i = 0; i < sortedItems.length; i++) {
                 if (spans[field][i] === -1) continue; 
                 let span = 1;
                 const val = getMergeVal(i, field);
                 for (let j = i + 1; j < sortedItems.length; j++) {
                     if (getMergeVal(j, field) === val) { span++; spans[field][j] = -1; } else { break; }
                 }
                 spans[field][i] = span;
             }
         });
         for (let i = 0; i < sortedItems.length; i++) {
             if (spans['fabric'][i] === -1) continue;
             let span = 1;
             const val = getMergeVal(i, 'piece_group');
             for (let j = i + 1; j < sortedItems.length; j++) {
                 if (getMergeVal(j, 'piece_group') === val) { span++; spans['fabric'][j] = -1; } else { break; }
             }
             spans['fabric'][i] = span; spans['description'][i] = span; spans['qtySofa'][i] = span; spans['totalExw'][i] = span;    
         }
         for (let i = 0; i < sortedItems.length; i++) { if (spans['fabric'][i] === -1) { spans['description'][i] = -1; spans['qtySofa'][i] = -1; spans['totalExw'][i] = -1; } }

         const firstBrandItem = sortedItems[0];
         let photoUrl = firstBrandItem.mt?.modulo?.marca?.imagem || "";
         if (photoUrl && !photoUrl.startsWith("http") && !photoUrl.startsWith("data:")) photoUrl = `data:image/png;base64,${photoUrl}`;
         const brandName = firstBrandItem.mt?.modulo?.marca?.nome || "";
         
         return { sortedItems, spans, totalBrandRows: sortedItems.length, photoUrl, brandName };
    });

    let totalValue = 0;
    let totalM3 = 0;
    let totalQty = 0;

    brandGroups.forEach(bg => {
        let pieceTotalUnitUSD = 0;
        let pieceTotalM3 = 0;
        const qPeca = Number(bg.sortedItems[0].item.quantidadePeca || 1);
        bg.sortedItems.forEach(entry => {
            const item = entry.item;
            const qtyMod = Number(item.quantidade || 0);
            totalQty += (qtyMod * qPeca);
            
            // Round line m3 to 2 decimals as requested
            const lineM3 = (Number(item.m3 || 0)) * qtyMod;
            pieceTotalM3 += Math.round(lineM3 * 100) / 100;
            
            const lineExwUnitUSD = (Number(item.valorEXW || 0)) + (Number(item.valorFreteRateadoUSD || 0));
            const itemUnitFinalUSD = lineExwUnitUSD * qtyMod * (currency === "BRL" ? risk : 1);
            pieceTotalUnitUSD += itemUnitFinalUSD;
        });
        totalM3 += Math.round(pieceTotalM3 * qPeca * 100) / 100;
        totalValue += pieceTotalUnitUSD * qPeca;
    });
    
    totalM3 = Math.round(totalM3 * 100) / 100;

    return { brandGroups, totalSofaQty, totalQty, totalM3, totalValue, risk };
  }, [pi, currency, showFreight]);

  const formattedPiNumber = useMemo(() => {
    if (!pi) return "";
    const base = `${pi.prefixo}-${pi.piSequencia}`;
    if (pi.piItens && pi.piItens[0]) {
        const mt = (pi.piItens[0] as any).moduloTecido || (pi.piItens[0] as any).ModuloTecido;
        const supplierName = (mt?.modulo?.fornecedor?.nome || "").toLowerCase();
        if (supplierName.includes("karams") || supplierName.includes("koyo")) {
            const yearShort = String(dateObj.getFullYear()).slice(-2); return `${base}/${yearShort}`;
        }
    }
    return base;
  }, [pi, dateObj]);

  if (loading) return <div style={{ padding: 20 }}>{t("LOADING")}</div>;
  if (!pi) return <div style={{ padding: 20 }}>Documento não encontrado.</div>;

  return (
    <div className="print-container" style={{ padding: 40, fontFamily: "Arial, sans-serif", color: "#000", background: "#fff", maxWidth: "1200px", margin: "0 auto" }}>
      <style>{`
        @media print {
            @page { margin: 0.5cm; size: landscape; }
            html, body { height: auto !important; overflow: visible !important; background: #fff !important; color: #000 !important; -webkit-print-color-adjust: exact; }
            .topbar, .footer, .no-print { display: none !important; }
            .app, .main, .container { padding: 0 !important; margin: 0 !important; width: 100% !important; max-width: none !important; border: none !important; overflow: visible !important; height: auto !important; display: block !important; }
            .print-container { padding: 0 !important; max-width: none !important; margin: 0 !important; display: block !important; }
        }
        .print-table { width: 100%; border-collapse: collapse; margin-top: 20px; font-size: 10px; }
        .print-table th, .print-table td { border: 1px solid #000; padding: 4px 6px; text-align: left; }
        .print-table th { background: #2c3e50 !important; color: #fff !important; font-weight: bold; text-align: center; -webkit-print-color-adjust: exact; }
        thead { display: table-header-group; }
        tfoot { display: table-footer-group; }
        tr { break-inside: avoid; page-break-inside: avoid; }
        .print-header { display: flex; justify-content: space-between; border-bottom: 2px solid #000; padding-bottom: 20px; margin-bottom: 20px; }
        .print-header-grid { display: grid; grid-template-columns: 1fr 1fr; border-bottom: 2px solid #000; padding-bottom: 20px; margin-bottom: 20px; }
        .btn-print { position: fixed; top: 20px; right: 20px; padding: 10px 20px; background: #2563eb; color: white; border: none; border-radius: 8px; cursor: pointer; font-weight: bold; z-index: 1000; }
      `}</style>
      
      <button className="btn-print no-print" onClick={() => window.print()}>🖨️ Imprimir</button>

      <div style={{ height: "4px", background: "#003366", marginBottom: "10px" }}></div>
      <div className="print-header" style={{ display: "flex", alignItems: "center", borderBottom: "1px solid #000", paddingBottom: "10px" }}>
        <div style={{ width: "150px" }}><img src={supplierMetadata.logo} alt="Logo" style={{ maxWidth: "100%" }} /></div>
        <div style={{ flex: 1, textAlign: "center" }}>
           <h1 style={{ margin: "0 0 2px 0", fontSize: 13, fontWeight: "bold", textTransform: "uppercase" }}>{supplierMetadata.name}</h1>
           <div style={{ fontSize: 10, lineHeight: "1.2em", fontWeight: "bold" }}>
               <div>CNPJ {supplierMetadata.cnpj}</div>
               <div>{supplierMetadata.address} {supplierMetadata.zip} {supplierMetadata.city} - {supplierMetadata.state}</div>
               <div>{supplierMetadata.email} - {supplierMetadata.website} | {supplierMetadata.phone}</div>
           </div>
        </div>
        <div style={{ width: "150px" }}></div>
      </div>

      <div className="print-header-grid" style={{ fontSize: "11px", borderBottom: "1px solid #000", paddingBottom: "10px" }}>
          <div>
              <div style={{ fontWeight: "bold", textTransform: "uppercase", marginBottom: "5px" }}>{t("IMPORTER")}</div>
              <div>{displayClient?.nome || ""}</div>
              <div>{t("ADDRESS")} {displayClient?.endereco || ""}</div>
              <div>{t("NIT")} {displayClient?.nit || ""}</div>
              <div>{t("EMAIL")} {displayClient?.email || ""}</div>
          </div>
          <div style={{ paddingLeft: "10px", borderLeft: "1px solid #000" }}>
               <div style={{ fontWeight: "bold", textTransform: "uppercase" }}>PROFORMA INVOICE: {formattedPiNumber}</div>
               <div>{t("DATE")} {dateObj.toLocaleDateString("pt-BR")}</div>
               <div>{t("SHIPMENT_POINT")} {pi.configuracoes?.portoEmbarque || (pi as any).portoEmbarque || "PARANAGUA"}</div>
               <div>{t("INCOTERM")} {incoterm}</div>
               <div>{t("PAYMENT_CONDITION")} {pi.condicaoPagamento || "T/T"}</div>
          </div>
      </div>

      <table className="print-table">
          <thead>
            <tr>
              <th rowSpan={2} style={{ width: "6%" }}>{t("PHOTO")}</th>
              <th rowSpan={2} style={{ width: "8%" }}>{t("NAME")}</th>
              <th rowSpan={2} style={{ width: "15%" }}>{t("DESCRIPTION")}</th>
              <th colSpan={3} style={{ width: "9%" }}>{t("DIMENSIONS")}</th>
              <th rowSpan={2} style={{ width: "5%" }}>{t("QTY_UNIT")}</th>
              <th rowSpan={2} style={{ width: "5%" }}>{t("QTY_SOFA")}</th>
              <th rowSpan={2} style={{ width: "5%" }}>{t("TOTAL_VOLUME")}</th>
              <th rowSpan={2} style={{ width: "8%" }}>{t("FABRIC")}</th>
              <th rowSpan={2} style={{ width: "6%" }}>{t("FEET")}</th>
              <th rowSpan={2} style={{ width: "6%" }}>{t("FINISHING")}</th>
              <th rowSpan={2} style={{ width: "8%" }}>{t("OBSERVATION")}</th>
              <th rowSpan={2} style={{ width: "8%" }}>{t("UNIT_FINAL")}</th>
              <th rowSpan={2} style={{ width: "8%" }}>{currency === "BRL" ? "UNIT R$" : "UNIT DOLAR"}</th>
              <th rowSpan={2} style={{ width: "8%" }}>{currency === "BRL" ? "TOTAL R$" : "TOTAL USD"}</th>
            </tr>
            <tr>
               <th>{t("WIDTH")}</th><th>{t("DEPTH")}</th><th>{t("HEIGHT")}</th>
            </tr>
          </thead>
          <tbody>
            {processedData.brandGroups.map((bg, bgIdx) => {
                const { sortedItems, spans, totalBrandRows, photoUrl, brandName } = bg;
                return (
                    <React.Fragment key={bgIdx}>
                        {sortedItems.map((entry, index) => {
                            const { item } = entry;
                            const isFirstInBrand = index === 0;
                            const risk = processedData.risk;
                            const isBRL = currency === "BRL";
                            
                            const lineExwUnitUSD = (Number(item?.valorEXW || 0)) + (Number(item?.valorFreteRateadoUSD || 0));
                            const itemUnitFinalDisp = lineExwUnitUSD * (Number(item?.quantidade || 0)) * (isBRL ? risk : 1);

                            let pieceTotalUnitUSD = 0;
                            if (spans['totalExw'][index] > 0) {
                                const span = spans['totalExw'][index];
                                sortedItems.slice(index, index + span).forEach(g => {
                                    const gExw = (Number(g?.item?.valorEXW || 0)) + (Number(g?.item?.valorFreteRateadoUSD || 0));
                                    pieceTotalUnitUSD += gExw * (Number(g?.item?.quantidade || 0)) * (isBRL ? risk : 1);
                                });
                            }

                            const renderMerged = (field: string, content: React.ReactNode, extra: React.CSSProperties = {}) => {
                                const span = spans[field][index]; if (span === -1) return null;
                                return <td rowSpan={span} style={{ border: "1px solid #000", verticalAlign: "middle", ...extra }}>{content}</td>;
                            };
                            
                            let fabricContent = entry.mt?.tecido?.nome || "Sem Tecido";
                            const fSpan = spans['fabric'][index];
                            if (fSpan > 0) {
                                const groupEntries = sortedItems.slice(index, index + fSpan);
                                const codes = Array.from(new Set(groupEntries.map(ge => {
                                    const m = ge.mt;
                                    const it = ge.item;
                                    return (it.tempCodigoModuloTecido || m?.codigoModuloTecido || it.codigoModuloTecido || "").trim();
                                }).filter(c => c !== "")));
                                if (codes.length === 1) fabricContent += ` - ${codes[0]}`;
                            }

                            return (
                                <tr key={item.id || index}>
                                    {isFirstInBrand && (
                                        <>
                                            <td rowSpan={totalBrandRows} style={{ textAlign: "center" }}>{photoUrl && <img src={photoUrl} alt="Marca" style={{ maxWidth: "50px" }} />}</td>
                                            <td rowSpan={totalBrandRows} style={{ fontWeight: "bold", background: "#eff6ff", textAlign: "center" }}>{brandName}</td>
                                        </>
                                    )}
                                    <td style={{ border: "1px solid #000" }}>{item.moduloTecido?.modulo?.descricao || ""}</td>
                                    <td style={{ textAlign: "center" }}>{fmt(item.largura)}</td>
                                    <td style={{ textAlign: "center" }}>{fmt(item.profundidade)}</td>
                                    <td style={{ textAlign: "center" }}>{fmt(item.altura)}</td>
                                    <td style={{ textAlign: "center" }}>{fmt(item.quantidade, 0)}</td>
                                    {renderMerged('qtySofa', fmt(item.quantidadePeca, 0), { textAlign: "center", fontWeight: "bold" })}
                                    <td style={{ textAlign: "center" }}>{fmt((item.m3 || 0) * (item.quantidade || 0))}</td>
                                    {renderMerged('fabric', fabricContent, { textAlign: "center", background: "#f0fdf4", fontWeight: "bold" })}
                                    {renderMerged('feet', item.feet || item.Feet || "", { textAlign: "center" })}
                                    {renderMerged('finishing', item.finishing || item.Finishing || "", { textAlign: "center" })}
                                    {renderMerged('observation', item.observacao || "")}
                                    <td style={{ textAlign: "right" }}>{isBRL ? "R$" : "$"} {fmt(itemUnitFinalDisp)}</td>
                                    {renderMerged('totalExw', `${isBRL ? "R$" : "$"} ${fmt(pieceTotalUnitUSD)}`, { textAlign: "right", color: "#2563eb" })}
                                    {renderMerged('totalExw', `${isBRL ? "R$" : "$"} ${fmt(pieceTotalUnitUSD * (item.quantidadePeca || 1))}`, { textAlign: "right", fontWeight: "bold" })}
                                </tr>
                            );
                        })}
                    </React.Fragment>
                );
            })}
          </tbody>
          <tfoot>
            <tr style={{ fontWeight: "bold", background: "#f8fafc" }}>
              <td colSpan={6} style={{ textAlign: "right", padding: "4px 8px" }}>{t("TOTAL")}</td>
              <td style={{ textAlign: "center" }}>{processedData.totalQty}</td>
              <td style={{ textAlign: "center" }}>{processedData.totalSofaQty}</td>
              <td style={{ textAlign: "center" }}>{fmt(processedData.totalM3)}</td>
              <td colSpan={6} style={{ border: "1px solid #000" }}></td>
              <td style={{ textAlign: "right", background: "#fff1f2", fontWeight: "bold" }}>{currency === "BRL" ? "R$" : "$"} {fmt(processedData.totalValue)}</td>
            </tr>
          </tfoot>
      </table>

      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", border: "1px solid #000", marginTop: 20, fontSize: "11px" }}>
          <div style={{ padding: 10, borderRight: "1px solid #000" }}>
              <h3 style={{ margin: "0 0 5px 0", fontSize: 13 }}>{t("BANK_DETAILS")}</h3>
              <p>NAME: {supplierMetadata.bankDetails.beneficiaryName}</p>
              <p>BANK: {supplierMetadata.bankDetails.beneficiary}</p>
              <p>SWIFT: {supplierMetadata.bankDetails.beneficiarySwift}</p>
              <p>ACCOUNT: {supplierMetadata.bankDetails.beneficiaryAccount}</p>
          </div>
          <div style={{ padding: 10 }}>
              <h3 style={{ margin: "0 0 5px 0", fontSize: 13 }}>{t("PRODUCT_DATA")}</h3>
              <p>BRAND: {supplierMetadata.details.brand}</p>
              <p>NCM: {supplierMetadata.details.ncm || "94016100"}</p>
              <p>VOLUME M³: {fmt(processedData.totalM3)}</p>
              <p style={{ marginTop: 15, fontSize: 10, fontStyle: "italic" }}>{t("VALIDITY_NOTE").replace("{0}", urlParams.get("validity") || "30")}</p>
          </div>
      </div>
    </div>
  );
}
