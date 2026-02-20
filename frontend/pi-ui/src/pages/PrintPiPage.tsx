
import React, { useEffect, useState, useMemo } from "react";
import { useParams } from "react-router-dom";
import { getPi } from "../api/pis";
import type { ProformaInvoice, ModuloTecido, PiItem } from "../api/types";
import { listModulosTecidos } from "../api/modulos"; 
import { getCliente, type Cliente } from "../api/clientes";

export default function PrintPiPage() {
  const { id } = useParams();
  const [pi, setPi] = useState<ProformaInvoice | null>(null);
  const [cliente, setCliente] = useState<Cliente | null>(null);
  const [modulosTecidos, setModulosTecidos] = useState<ModuloTecido[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function load() {
      if (!id) return;
      try {
        // 1. Fetch PI first
        const piData = await getPi(Number(id));
        setPi(piData);

        // 2. Fetch others in parallel
        const promises: Promise<any>[] = [listModulosTecidos()];
        
        if (piData.idCliente) {
            // Add catch to prevent Promise.all from rejecting entirety if client fetch fails
            promises.push(
                getCliente(String(piData.idCliente))
                    .catch(err => {
                        console.warn("Falha ao buscar cliente", err);
                        return null;
                    })
            );
        }

        const results = await Promise.all(promises);
        const mts = results[0];
        const clientData = results[1] || null;

        setModulosTecidos(mts);
        setCliente(clientData); // Use explicit client data
        
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
  const fmt3 = (n: number) => (n || 0).toLocaleString("pt-BR", { minimumFractionDigits: 3, maximumFractionDigits: 3 });
  
  // Safe Date Handling
  const safeDate = (dateStr: string | undefined) => {
      if (!dateStr) return new Date();
      const d = new Date(dateStr);
      return isNaN(d.getTime()) ? new Date() : d;
  };
  const dateObj = safeDate(pi?.dataPi);

  // Fallback if explicit fetch fails but PI has nested client (legacy check)
  const displayClient = cliente || (pi as any)?.cliente;
  console.log("PI Date:", dateObj); 

  const processedData = useMemo(() => {
    if (!pi || !pi.piItens) return { brandGroups: [], totalSofaQty: 0 };

    const itemsByMarca: { [key: string]: { item: PiItem, mt: ModuloTecido | undefined }[] } = {};
    pi.piItens.forEach(item => {
        const mt = modulosTecidos.find(m => m.id === item.idModuloTecido);
        const marca = mt?.modulo?.marca?.nome || "Outros";
        if (!itemsByMarca[marca]) itemsByMarca[marca] = [];
        itemsByMarca[marca].push({ item, mt });
    });

    let totalSofaQty = 0;
    
    // Process each brand group
    const brandGroups = Object.entries(itemsByMarca).map(([_, brandItems]) => {
         // Sort Logic
         const sortedItems = [...brandItems].sort((a, b) => {
             const fabKeyA = (a.mt?.tecido?.nome || "ZZBase").toLowerCase();
             const fabKeyB = (b.mt?.tecido?.nome || "ZZBase").toLowerCase();
             if (fabKeyA !== fabKeyB) return fabKeyA.localeCompare(fabKeyB);
             
             const descA = a.mt?.modulo?.descricao || "";
             const descB = b.mt?.modulo?.descricao || "";
             return descA.localeCompare(descB);
         });

         // Calculate Spans
         const spans: any = {
             description: new Array(sortedItems.length).fill(0),
             fabric: new Array(sortedItems.length).fill(0),
             feet: new Array(sortedItems.length).fill(0),
             finishing: new Array(sortedItems.length).fill(0),
             observation: new Array(sortedItems.length).fill(0),
             qtySofa: new Array(sortedItems.length).fill(0),
             totalExw: new Array(sortedItems.length).fill(0)
         };

         const getMergeVal = (idx: number, type: string) => {
             const entry = sortedItems[idx];
             if (type === 'fabric_group') { 
                  return entry.mt?.tecido?.nome || "Sem Tecido";
             }
             if (type === 'feet') return entry.item.feet || (entry.item as any).Feet || "";
             if (type === 'finishing') return entry.item.finishing || (entry.item as any).Finishing || "";
             if (type === 'observation') return entry.item.observacao || "";
             return "";
         };

         // Calculate spans
         ['feet', 'finishing', 'observation'].forEach(field => {
             for (let i = 0; i < sortedItems.length; i++) {
                 if (spans[field][i] === -1) continue; 
                 let span = 1;
                 const val = getMergeVal(i, field);
                 for (let j = i + 1; j < sortedItems.length; j++) {
                     if (getMergeVal(j, field) === val) {
                         span++;
                         spans[field][j] = -1;
                     } else { break; }
                 }
                 spans[field][i] = span;
             }
         });
         
         // Fabric & Description & Qty Sofa & Total EXW (Group by Fabric Name)
         for (let i = 0; i < sortedItems.length; i++) {
             if (spans['fabric'][i] === -1) continue;
             
             let span = 1;
             const val = getMergeVal(i, 'fabric_group');
             for (let j = i + 1; j < sortedItems.length; j++) {
                 if (getMergeVal(j, 'fabric_group') === val) {
                     span++;
                     spans['fabric'][j] = -1; 
                 } else { break; }
             }
             
             spans['fabric'][i] = span;
             spans['description'][i] = span; // Sync
             spans['qtySofa'][i] = span;     // Sync
             spans['totalExw'][i] = span;    // Sync
             
             // Add Qty of the main item of the group to the Total Sofa Count
             totalSofaQty += sortedItems[i].item.quantidade;
         }

         // Copy -1s for synced columns
         for (let i = 0; i < sortedItems.length; i++) {
              if (spans['fabric'][i] === -1) {
                  spans['description'][i] = -1;
                  spans['qtySofa'][i] = -1;
                  spans['totalExw'][i] = -1;
              }
         }

         const firstBrandItem = brandItems[0];
         let photoUrl = firstBrandItem.mt?.modulo?.marca?.imagem || "";
         if (photoUrl && !photoUrl.startsWith("http") && !photoUrl.startsWith("data:")) {
             photoUrl = `data:image/png;base64,${photoUrl}`;
         }
         const brandName = firstBrandItem.mt?.modulo?.marca?.nome || "";
         
         return {
             sortedItems,
             spans,
             totalBrandRows: sortedItems.length,
             photoUrl,
             brandName
         };
    });

    return { brandGroups, totalSofaQty };
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

  return (
    <div className="print-container" style={{ padding: 40, fontFamily: "Arial, sans-serif", color: "#000", background: "#fff", maxWidth: "1100px", margin: "0 auto" }}>
      <style>{`
        @media print {
            @page { margin: 0.5cm; size: landscape; }
            html, body { height: auto !important; overflow: visible !important; background: #fff !important; color: #000 !important; -webkit-print-color-adjust: exact; }
            
            /* Hide App Header/Footer and other non-print elements */
            .topbar, .footer, .no-print { display: none !important; }
            
            /* Reset Main Layout Constraints */
            .app, .main, .container { 
                padding: 0 !important; 
                margin: 0 !important; 
                width: 100% !important; 
                max-width: none !important; 
                border: none !important;
                box-shadow: none !important;
                overflow: visible !important;
                height: auto !important;
                display: block !important;
            }

            .print-container { padding: 0 !important; max-width: none !important; margin: 0 !important; display: block !important; }
        }
        
        .print-table { width: 100%; border-collapse: collapse; margin-top: 20px; font-size: 11px; }
        .print-table th, .print-table td { border: 1px solid #000; padding: 4px 6px; text-align: left; }
        .print-table th { background: #2c3e50 !important; color: #fff !important; font-weight: bold; text-align: center; -webkit-print-color-adjust: exact; }
        
        /* Print Pagination Control */
        thead { display: table-header-group; }
        tfoot { display: table-footer-group; }
        tr { break-inside: avoid; page-break-inside: avoid; }
        
        .print-header { display: flex; justify-content: space-between; border-bottom: 2px solid #000; padding-bottom: 20px; margin-bottom: 20px; }
        .print-header-grid { display: grid; grid-template-columns: 1fr 1fr; border-bottom: 2px solid #000; padding-bottom: 20px; margin-bottom: 20px; }
        .print-info { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px; font-size: 13px; }
        
        .totals-section { display: flex; justify-content: flex-end; margin-top: 20px; }
        .print-totals { width: 300px; border: 1px solid #000; padding: 10px; font-size: 13px; }

        .footer-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 40px; margin-top: 30px; font-size: 12px; }
        .footer-col h3 { border-bottom: 1px solid #000; padding-bottom: 5px; margin-bottom: 10px; font-size: 14px; text-transform: uppercase; }
        .footer-col p { margin: 2px 0; }
        
        .btn-print {
            position: fixed; top: 20px; right: 20px; 
            padding: 10px 20px; background: #2563eb; color: white; 
            border: none; border-radius: 8px; cursor: pointer; 
            font-weight: bold; box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            z-index: 1000;
        }
        .btn-print:hover { background: #1d4ed8; }
      `}</style>
      
      <button className="btn-print no-print" onClick={() => window.print()}>
        🖨️ Imprimir
      </button>

      {/* Blue Top Bar */}
      <div style={{ height: "4px", background: "#003366", marginBottom: "10px" }} className="no-print-border"></div>

      <div className="print-header" style={{ display: "flex", alignItems: "center", borderBottom: "1px solid #000", paddingBottom: "10px", marginBottom: "0px" }}>
        {/* Left: Logo */}
        <div style={{ width: "150px" }}>
             <img src="/logo-karams.png" alt="Karams Logo" style={{ maxWidth: "100%", height: "auto" }} />
             {/* Date removed from here as per new layout */}
        </div>

        {/* Center: Company Info */}
        <div style={{ flex: 1, textAlign: "center" }}>
           <h1 style={{ margin: "0 0 2px 0", fontSize: 13, fontWeight: "bold", textTransform: "uppercase" }}>KARAM'S INDUSTRIA E COMERCIO DE ESTOFADOS LTDA</h1>
           <div style={{ fontSize: 10, lineHeight: "1.2em", fontWeight: "bold" }}>
               <div>CNPJ 02.670.170/0001-09</div>
               <div>ROD PR 180 - KM 04 - LOTE 11 N8 B1 BAIRRO RURAL 87890-000 TERRA RICA - PARANÁ</div>
               <div>KARAMS@KARAMS.COM.BR - https://karams.com.br/ | (44) 3441-8400 | (44) 3441-1908</div>
           </div>
        </div>
        
        {/* Right Spacer to balance Logo for centering */}
        <div style={{ width: "150px" }}></div>
      </div>

      <div className="print-header-grid" style={{ display: "grid", gridTemplateColumns: "1fr 1fr", borderBottom: "1px solid #000", paddingBottom: "10px", marginBottom: "20px" }}>
          {/* Left: Importer */}
          <div style={{ paddingRight: "10px", fontSize: "11px", lineHeight: "1.4em" }}>
              <div style={{ fontWeight: "bold", textTransform: "uppercase", marginBottom: "5px" }}>IMPORTER:</div>
              <div style={{ textTransform: "uppercase" }}>{displayClient?.nome || (pi as any).cliente?.nome}</div>
              
              <div style={{ display: "flex" }}>
                  <span style={{ width: "70px" }}>ADDRESS:</span>
                  <span>{displayClient?.endereco || (pi as any).cliente?.endereco}</span>
              </div>
              <div style={{ display: "flex" }}>
                  <span style={{ width: "70px" }}>CITY:</span>
                  <span>{displayClient?.cidade || (pi as any).cliente?.cidade}</span>
              </div>
              <div style={{ display: "flex" }}>
                  <span style={{ width: "70px" }}>COUNTRY:</span>
                  <span>{displayClient?.pais || (pi as any).cliente?.pais}</span>
              </div>
              <div style={{ display: "flex" }}>
                  <span style={{ width: "70px" }}>NIT:</span>
                  <span>{displayClient?.nit || (pi as any).cliente?.nit || ""}</span>
              </div>
              <div style={{ display: "flex" }}>
                  <span style={{ width: "70px" }}>FONE:</span>
                  <span>{displayClient?.telefone || (pi as any).cliente?.telefone}</span>
              </div>
              <div style={{ display: "flex" }}>
                  <span style={{ width: "70px" }}>RES. PERSON:</span>
                  <span>{displayClient?.pessoaContato || (pi as any).cliente?.pessoaContato || ".."}</span>
              </div>
              <div style={{ display: "flex" }}>
                  <span style={{ width: "70px" }}>E-MAIL:</span>
                  <span>{displayClient?.email || (pi as any).cliente?.email}</span>
              </div>
          </div>

          {/* Right: PI Details */}
          <div style={{ paddingLeft: "10px", fontSize: "11px", lineHeight: "1.4em", borderLeft: "1px solid #000" }}>
               <div style={{ fontWeight: "bold", textTransform: "uppercase", marginBottom: "5px" }}>PROFORMA INVOICE: {formattedPiNumber}</div>
               
               <div style={{ display: "flex", justifyContent: "space-between" }}>
                   <span>DATE:</span>
                   <span>{dateObj.toLocaleDateString("pt-BR")}</span>
               </div>
               <div style={{ display: "flex", justifyContent: "space-between" }}>
                   <span>PROFORMA INVOICE:</span>
                   <span>{formattedPiNumber}</span>
               </div>
               <div style={{ display: "flex", justifyContent: "space-between" }}>
                   <span>ORDER DATE:</span>
                   <span>{new Date(pi.dataPi).toLocaleDateString("pt-BR")}</span> 
               </div>
               <div style={{ display: "flex", justifyContent: "space-between" }}>
                   <span style={{ width: "130px" }}>PLACE OF LOADING:</span>
                   <span>{pi.configuracoes?.portoEmbarque || (pi as any).portoEmbarque || "PARANAGUA"}</span>
               </div>
               <div style={{ display: "flex", justifyContent: "space-between" }}>
                   <span style={{ width: "130px" }}>PLACE OF DISCHARGE:</span>
                   <span>{displayClient?.portoDestino || pi.cliente?.portoDestino || ""}</span>
               </div>
               <div style={{ display: "flex", justifyContent: "space-between" }}>
                   <span style={{ width: "130px" }}>DELIVERY TIME:</span>
                   <span>50 days after first payment</span>
               </div>
               <div style={{ display: "flex", justifyContent: "space-between" }}>
                   <span style={{ width: "130px" }}>INCOTERM:</span>
                   <span>FOB {pi.configuracoes?.portoEmbarque || (pi as any).portoEmbarque || ""}</span>
               </div>
               <div style={{ display: "flex", justifyContent: "space-between" }}>
                   <span style={{ width: "130px" }}>PAYMENT TERM:</span>
                   <span>{pi.configuracoes?.condicoesPagamento || (pi as any).condicoesPagamento || "T/T"}</span>
               </div>
          </div>
      </div>

      {/* Group items by "Model" (Brand) then "Fabric" (Tecido)?? 
          Actually the request says: 
          "A coluna Photo vai buscar a imagem do Modelo 'Marca'"
          "A coluna Name vai trazer o nome do Modelo 'Marca'"
          So we should group by Marca.
      */}
      <div className="print-table-container">
        <table className="print-table" style={{ width: "100%", borderCollapse: "collapse", border: "1px solid #000", fontSize: "10px" }}>
          <thead style={{ background: "#1a2e44", color: "white", textTransform: "uppercase" }}>
            <tr>
              <th rowSpan={2} style={{ width: "10%" }}>Photo</th>
              <th rowSpan={2} style={{ width: "10%" }}>Name</th>
              <th rowSpan={2} style={{ width: "25%" }}>Description</th>
              <th colSpan={3}>DIMENSIONS (m)</th>
              <th rowSpan={2} style={{ width: "5%" }}>Qty Module</th>
              <th rowSpan={2} style={{ width: "5%" }}>Qty Sofa</th>
              <th rowSpan={2} style={{ width: "5%" }}>Total Vol M³</th>
              <th rowSpan={2} style={{ width: "10%" }}>Fabric</th>
              <th rowSpan={2} style={{ width: "10%" }}>Feet</th>
              <th rowSpan={2} style={{ width: "10%" }}>Finishing</th>
              <th rowSpan={2} style={{ width: "10%" }}>Observation</th>
              <th rowSpan={2} style={{ width: "10%" }}>EXW DOLAR {fmt(pi.cotacaoAtualUSD)}</th>
              <th rowSpan={2} style={{ width: "10%" }}>TOTAL EXW</th>
            </tr>
            <tr>
               <th style={{ width: "5%" }}>Width</th>
               <th style={{ width: "5%" }}>Depth</th>
               <th style={{ width: "5%" }}>Height</th>
            </tr>
          </thead>
          <tbody>
            {processedData.brandGroups.map(({ sortedItems, spans, totalBrandRows, photoUrl, brandName }, brandIndex) => {
                
                const renderGroupListCell = (field: 'description' | 'fabric', index: number) => {
                    const span = spans[field][index];
                    if (span === -1) return null;
                    
                    const groupItems = sortedItems.slice(index, index + span);
                    
                    const cellStyle: React.CSSProperties = {
                        border: "1px solid #000", 
                        padding: "2px 5px", 
                        verticalAlign: "middle", 
                        textAlign: field === 'fabric' ? "center" : "left",
                        background: field === 'fabric' ? '#f0fdf4' : 'inherit',
                        color: field === 'fabric' ? '#166534' : 'inherit',
                        fontWeight: field === 'fabric' ? 'bold' : 'normal'
                    };

                    return (
                        <td rowSpan={span} style={cellStyle}>
                            {groupItems.map((g, i) => {
                                let text = "";
                                if (field === 'description') {
                                    text = (g.item.quantidade > 1 ? `${g.item.quantidade} ` : "") + (g.mt?.modulo?.descricao || `Modulo #${g.item.idModuloTecido}`);
                                } else { // fabric
                                    const fName = g.mt?.tecido?.nome || "Sem Tecido";
                                    const fCode = g.item.tempCodigoModuloTecido || g.mt?.codigoModuloTecido || "";
                                    text = fCode ? `${fName} - ${fCode}` : fName;
                                }
                                return (
                                    <div key={i} style={{ marginBottom: 4, borderBottom: i < groupItems.length - 1 ? "1px dashed #ccc" : "none" }}>
                                        {text}
                                    </div>
                                );
                            })}
                        </td>
                    );
                };

                return (
                    <React.Fragment key={brandIndex}>
                        {sortedItems.map((entry, index) => {
                            const { item } = entry;
                            const isFirstInBrand = index === 0;

                            // Calculate Fabric Group Total EXW
                            let fabricGroupTotal = 0;
                            if (spans['totalExw'][index] > 0) {
                                const span = spans['totalExw'][index];
                                const groupRange = sortedItems.slice(index, index + span);
                                fabricGroupTotal = groupRange.reduce((sum, g) => sum + ((Number(g.item.valorEXW) || 0) * (Number(g.item.quantidade) || 0)), 0);
                            }

                            const renderMergedCellForCurrentRow = (field: string, content: React.ReactNode, extraStyle: React.CSSProperties = {}) => {
                                const span = spans[field][index];
                                if (span === -1) return null;
                                return (
                                    <td rowSpan={span} style={{ border: "1px solid #000", verticalAlign: "middle", ...extraStyle }}>
                                        {content}
                                    </td>
                                );
                            };
                            
                            return (
                                <tr key={item.id || Math.random()} style={{ borderBottom: "1px solid #ccc" }}>
                                    {/* Photo & Name */}
                                    {isFirstInBrand && (
                                        <React.Fragment>
                                            <td rowSpan={totalBrandRows} style={{ border: "1px solid #000", textAlign: "center", padding: 5, verticalAlign: "middle" }}>
                                                {photoUrl && <img src={photoUrl} alt={brandName} style={{ maxWidth: "80px", maxHeight: "80px" }} />}
                                            </td>
                                            <td rowSpan={totalBrandRows} style={{ border: "1px solid #000", textAlign: "center", fontWeight: "bold", verticalAlign: "middle", background: "#eff6ff" }}>
                                                {brandName}
                                            </td>
                                        </React.Fragment>
                                    )}
                                    
                                    {/* Description */}
                                    {renderGroupListCell('description', index)}

                                    {/* Dimensions: Per Item */}
                                    <td style={{ border: "1px solid #000", textAlign: "center" }}>{fmt(item.largura)}</td>
                                    <td style={{ border: "1px solid #000", textAlign: "center" }}>{fmt(item.profundidade)}</td>
                                    <td style={{ border: "1px solid #000", textAlign: "center" }}>{fmt(item.altura)}</td>
                                    <td style={{ border: "1px solid #000", textAlign: "center" }}>{fmt(item.quantidade, 0)}</td>
                                    
                                    {/* Qty Sofa: Mapped to Fabric Group. User says "distinct das quantidades... sempre iguais" -> item.quantidade */}
                                    {renderMergedCellForCurrentRow('qtySofa', fmt(item.quantidade, 0), { textAlign: "center", fontWeight: "bold" })}

                                    <td className="col-m3" style={{ border: "1px solid #000", textAlign: "center" }}>{fmt3((item.m3 || 0) * (item.quantidade || 0))}</td>
                                    
                                    {/* Fabric */}
                                    {renderGroupListCell('fabric', index)}
                                    
                                    {/* Feet */}
                                    {renderMergedCellForCurrentRow('feet', item.feet || (item as any).Feet || "", { textAlign: "center" })}

                                    {/* Finishing */}
                                    {renderMergedCellForCurrentRow('finishing', item.finishing || (item as any).Finishing || "", { textAlign: "center" })}
                                    
                                    {/* Observation */}
                                    {renderMergedCellForCurrentRow('observation', item.observacao || "", { })}
                                    
                                    {/* Unit EXW: Per Item */}
                                    <td style={{ border: "1px solid #000", textAlign: "right", background: "#fff1f2" }}>$ {fmt(item.valorEXW)}</td>
                                    
                                    {/* Total Group EXW: Broken down by Fabric */}
                                    {renderMergedCellForCurrentRow('totalExw', `$ ${fmt(fabricGroupTotal)}`, { 
                                        textAlign: "right", 
                                        fontWeight: "bold", 
                                        background: "#fff1f2" 
                                    })}
                                </tr>
                            );
                        })}
                    </React.Fragment>
                );
            })}
          </tbody>
        </table>
      </div>





      <div className="footer-grid" style={{ gridTemplateColumns: "1fr 1fr", gap: 0, border: "1px solid #000", marginTop: 20 }}>
          <div className="footer-col bank-details" style={{ padding: 10, borderRight: "1px solid #000" }}>
              <h3 style={{ borderBottom: "none", marginBottom: 5 }}>ACCOUNTING DETAILS:INTERMEDIARY BANK</h3>
              <p>BANK OF AMERICA, N.A.</p>
              <p>ADDRESS: NEW YORK - US</p>
              <p>SWIFT CODE: BOFAUS3N</p>
              <p>ACCOUNT: 6550925836</p>
              <p style={{ marginTop: 10 }}><strong>BENEFICIARY BANK:</strong></p>
              <p>BANCO RENDIMENTO S/A</p>
              <p>ADDRESS: SÃO PAULO - BR</p>
              <p>SWIFT CODE: RENDBRSP</p>
              <p>IBAN: BR4468900810000010025069901i1</p>
              <p>ACCOUNT: 00250699000148</p>
              <p>NAME: KARAM'S INDUSTRIA E COMERCIO DE ESTOFADOS LTDA</p>
          </div>
          <div className="footer-col" style={{ padding: 10 }}>
              <h3 style={{ borderBottom: "none", marginBottom: 5 }}>GENERAL PRODUCT DATA</h3>
              <p><strong>Brand:</strong> Karams</p>
              <p><strong>NCM:</strong> 94016100</p>
              <p><strong>Product:</strong> {fmt(processedData.totalSofaQty, 0)}</p>
              <p><strong>CBM M³:</strong> {fmt3((pi.piItens || []).reduce((acc: number, i: any) => acc + ((Number(i.m3) || 0) * (Number(i.quantidade) || 0)), 0))}</p>
              <p><strong>P.N. TOTAL:</strong></p>
              <p><strong>P.B. TOTAL:</strong></p>
              <p><strong>VOLUMEN TOTAL:</strong> {fmt3((pi.piItens || []).reduce((acc: number, i: any) => acc + ((Number(i.m3) || 0) * (Number(i.quantidade) || 0)), 0))}</p>
              <p><strong>Productos originales de fabrica</strong></p>
              <p><strong>Made in Brasil</strong></p>
          </div>
      </div>
    
      <div style={{ marginTop: 40, borderTop: "1px solid #000", paddingTop: 10, textAlign: "center", fontSize: 10 }} className="no-print">
        Visualização de Impressão - Sistema PI Web
      </div>
    </div>
  );
}
