
import React, { useEffect, useState } from "react";
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

  if (loading) return <div style={{ padding: 20 }}>Carregando documento...</div>;
  if (!pi) return <div style={{ padding: 20 }}>Documento não encontrado.</div>;

  const getDescricao = (idModuloTecido: number) => {
    const mt = modulosTecidos.find(m => m.id === idModuloTecido);
    if (!mt) return `Item #${idModuloTecido}`;
    
    const forn = mt.modulo?.fornecedor?.nome || "?";
    const cat = mt.modulo?.categoria?.nome || "?";
    const marc = mt.modulo?.marca?.nome || "?";
    const mod = mt.modulo?.descricao || "?";
    const tec = mt.tecido?.nome || "?";
    
    return `${forn} > ${cat} > ${marc} > ${mod} > ${tec}`;
  };

  const fmt = (n: number | undefined, decimals = 2) => (n || 0).toLocaleString("pt-BR", { minimumFractionDigits: decimals, maximumFractionDigits: decimals });
  const fmt3 = (n: number) => (n || 0).toLocaleString("pt-BR", { minimumFractionDigits: 3, maximumFractionDigits: 3 });
  const dateObj = new Date(pi.dataPi);

  const totalGeralUSD = (pi.piItens || []).reduce((acc: number, i: any) => acc + i.valorFinalItemUSDRisco, 0);
  
  // Calculate total items quantity for "Product" field
  const totalItemsQty = (pi.piItens || []).reduce((acc: number, i: any) => acc + i.quantidade, 0);

  // Fallback if explicit fetch fails but PI has nested client (legacy check)
  const displayClient = cliente || (pi as any).cliente;
  console.log(dateObj); // Use dateObj to avoid unused warning or remove if strictly not needed, but it is used in render.

  return (
    <div className="print-container" style={{ padding: 40, fontFamily: "Arial, sans-serif", color: "#000", background: "#fff", maxWidth: "1100px", margin: "0 auto" }}>
      <style>{`
        @media print {
            @page { margin: 1cm; size: landscape; }
            body { background: #fff !important; color: #000 !important; -webkit-print-color-adjust: exact; }
            .no-print { display: none !important; }
            .print-container { padding: 0 !important; max-width: none !important; margin: 0 !important; }
        }
        .print-table { width: 100%; border-collapse: collapse; margin-top: 20px; font-size: 11px; }
        .print-table th, .print-table td { border: 1px solid #ccc; padding: 4px 6px; text-align: left; }
        .print-table th { background: #f0f0f0; font-weight: bold; text-align: center; }
        
        .print-header { display: flex; justify-content: space-between; border-bottom: 2px solid #000; padding-bottom: 20px; margin-bottom: 20px; }
        .print-header-grid { display: grid; grid-template-columns: 1fr 1fr; border-bottom: 2px solid #000; padding-bottom: 20px; margin-bottom: 20px; }
        .print-info { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px; font-size: 13px; }
        
        .totals-section { display: flex; justify-content: flex-end; margin-top: 20px; }
        .print-totals { width: 300px; border: 1px solid #000; padding: 10px; font-size: 13px; }

        .footer-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 40px; margin-top: 30px; font-size: 12px; }
        .footer-col h3 { border-bottom: 1px solid #000; padding-bottom: 5px; margin-bottom: 10px; font-size: 14px; text-transform: uppercase; }
        .bank-details p { margin: 2px 0; }
        
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

      <div className="print-header" style={{ alignItems: "center", borderBottom: "none", marginBottom: "10px" }}>
        {/* Left: Logo */}
        <div style={{ flex: "0 0 120px" }}>
             <img src="/logo-karams.png" alt="Karams Logo" style={{ maxWidth: "100%", height: "auto" }} />
             <div style={{ fontSize: 9, textAlign: "center", marginTop: 5 }}>{dateObj.toLocaleDateString()}</div>
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
        
        {/* Right Spacer for checking centering - optional, or just let flex 1 take space. 
            If we want true center relative to page, we might need a spacer or absolute positioning.
            Flex 1 usually centers between the other two items. If right item is missing, it centers between left and edge.
            To allow text to be truly centered, we can add a dummy div of same width as logo.
        */}
        <div style={{ flex: "0 0 120px" }}></div>
      </div>

      <div className="print-header-grid" style={{ marginBottom: "10px" }}>
          {/* Left: Importer */}
          <div style={{ paddingRight: "20px" }}>
              <h3 style={{ borderBottom: "1px solid #000", paddingBottom: "5px", marginBottom: "10px", fontSize: "12px" }}>IMPORTER</h3>
              <div style={{ fontSize: "11px", lineHeight: "1.4em" }}>
                  <p style={{ margin: 0 }}><strong>{displayClient?.nome || (pi as any).cliente?.nome}</strong></p>
                  <p style={{ margin: 0 }}>{displayClient?.endereco || (pi as any).cliente?.endereco}</p>
                  <p style={{ margin: 0 }}>{displayClient?.cidade || (pi as any).cliente?.cidade} - {displayClient?.estado || (pi as any).cliente?.estado}</p>
                  <p style={{ margin: 0 }}>{displayClient?.pais || (pi as any).cliente?.pais}</p>
                  <p style={{ margin: 0 }}>CNPJ/Tax ID: {displayClient?.cnpj || (pi as any).cliente?.cnpj}</p>
              </div>
          </div>

          {/* Right: Proforma Invoice Details */}
          <div style={{ paddingLeft: "20px", borderLeft: "1px solid #ccc" }}>
              <h3 style={{ borderBottom: "1px solid #000", paddingBottom: "5px", marginBottom: "10px", fontSize: "12px", textAlign: "right" }}>PROFORMA INVOICE</h3>
              <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "5px", fontSize: "11px", lineHeight: "1.4em" }}>
                  <div style={{ textAlign: "right", fontWeight: "bold" }}>DATE:</div>
                  <div>{dateObj.toLocaleDateString()}</div>
                  
                  <div style={{ textAlign: "right", fontWeight: "bold" }}>INVOICE N°:</div>
                  <div>{pi.prefixo}-{pi.piSequencia}</div>
                  
                  <div style={{ textAlign: "right", fontWeight: "bold" }}>PAYMENT TERM:</div>
                  <div>{pi.configuracoes?.condicoesPagamento || (pi as any).condicoesPagamento || "T/T"}</div>
                  
                  <div style={{ textAlign: "right", fontWeight: "bold" }}>INCOTERM:</div>
                  <div>{pi.frete?.nome || "FOB"}</div>
                  
                  <div style={{ textAlign: "right", fontWeight: "bold" }}>PORT OF LOADING:</div>
                  <div>{pi.configuracoes?.portoEmbarque || (pi as any).portoEmbarque || "PARANAGUA"}</div>
                  
                  <div style={{ textAlign: "right", fontWeight: "bold" }}>PORT OF DISCHARGE:</div>
                  <div>{pi.cliente?.portoDestino || (pi as any).portoDestino || ""}</div>
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
              <th style={{ border: "1px solid #000", padding: 5, width: "10%" }}>Photo</th>
              <th style={{ border: "1px solid #000", padding: 5, width: "10%" }}>Name</th>
              <th style={{ border: "1px solid #000", padding: 5, width: "25%" }}>Description</th>
              <th style={{ border: "1px solid #000", padding: 5, width: "5%" }}>Width</th>
              <th style={{ border: "1px solid #000", padding: 5, width: "5%" }}>Depth</th>
              <th style={{ border: "1px solid #000", padding: 5, width: "5%" }}>Height</th>
              <th style={{ border: "1px solid #000", padding: 5, width: "5%" }}>Qty Module</th>
              <th style={{ border: "1px solid #000", padding: 5, width: "5%" }}>Total Vol M³</th>
              <th style={{ border: "1px solid #000", padding: 5, width: "10%" }}>Fabric</th>
              <th style={{ border: "1px solid #000", padding: 5, width: "10%" }}>Feet</th>
              <th style={{ border: "1px solid #000", padding: 5, width: "10%" }}>Finishing</th>
              <th style={{ border: "1px solid #000", padding: 5, width: "10%" }}>Observation</th>
              <th style={{ border: "1px solid #000", padding: 5, width: "10%" }}>EXW DOLAR {fmt(pi.cotacaoRisco)}</th>
              <th style={{ border: "1px solid #000", padding: 5, width: "10%" }}>TOTAL EXW</th>
            </tr>
          </thead>
          <tbody>
            {(function() {
                // Grouping Logic:
                // 1. Group by Marca (Brand)
                // 2. Inside Marca, Group by Fabric Code (tecido + cor?? User said: "baseado no tecido dos módulos" and "codigo informado no lançamento")
                //    The "codigo informado" is likely `moduloTecido.codigoModuloTecido` or just strict Fabric ID.
                //    Let's group by `idModuloTecido` (since that defines the variant) OR by specific fabric if different modules have same fabric?
                //    User said: "Os campos Description e Fabric devem ser mesclados baseado no tecido dos módulos"
                //    This likely means: If I have Module A with Fabric X and Module B with Fabric X, they should be listed together?
                //    Or does it mean: If I have 2 units of Module A with Fabric X, show "2 Module A"?
                //    Given "Qty Sofa" (from reference) and "Qty Module" columns, it seems we list unique Module+Fabric combinations.
                
                // Let's first group by Marca.
                const itemsByMarca: { [key: string]: { item: PiItem, mt: ModuloTecido | undefined }[] } = {};
                
                (pi.piItens || []).forEach(item => {
                    const mt = modulosTecidos.find(m => m.id === item.idModuloTecido);
                    const marca = mt?.modulo?.marca?.nome || "Outros";
                    if (!itemsByMarca[marca]) itemsByMarca[marca] = [];
                    itemsByMarca[marca].push({ item, mt });
                });

                return Object.entries(itemsByMarca).map(([_, brandItems], brandIndex) => {
                    // Sort items by Description to match "Description" order? Or by Fabric?
                    // User said "merged based on fabric".
                    // Let's group by Fabric Code within the Brand.
                    const itemsByFabric: { [key: string]: { item: PiItem, mt: ModuloTecido | undefined }[] } = {};
                    
                    brandItems.forEach(entry => {
                         // User said: "No campo Fabric deve trazer G0 - (Codigo informado no lançamento da PI)"
                         // G0 suggests a price group, but "Codigo informado" might be `observacao` or `codigoModuloTecido`?
                         // In `PiItem` we have `tempCodigoModuloTecido`? Or `moduloTecido.codigoModuloTecido`?
                         // Let's assume `mt.codigoModuloTecido` or create a composite key.
                         // Actually, looking at previous context, we might treat `mt.idTecido` as the grouping key for "Fabric".
                         const fabricKey = entry.mt?.tecido?.nome || "Sem Tecido"; 
                         if (!itemsByFabric[fabricKey]) itemsByFabric[fabricKey] = [];
                         itemsByFabric[fabricKey].push(entry);
                    });

                    // Flatten back to list for rendering, but we need to know boundaries for spans.
                    // Actually, the request says "Description and Fabric must be merged".
                    // This is ambiguous. Does it mean "Description RowSpan" and "Fabric RowSpan"?
                    // Or "Fabric Column shows X" and "Description Column shows Y" for the whole group?
                    // Reference image 2 shows:
                    // Photo | Name | Description (List of modules) | ... | Fabric (One Value) | ...
                    // If multiple modules have SAME fabric, they share the Fabric Cell?
                    
                    // Let's try to interpret "Description e Fabric devem ser mesclados baseado no tecido":
                    // It likely means: Group by Fabric. For each Fabric group, show 1 Fabric Cell.
                    // AND inside that Fabric group, list the modules in the Description column? 
                    // NO, Description column is per module. Fabric column is "mesclado" (merged/spanned).
                    
                    // Let's group brandItems by Fabric for the render loop.
                    const fabricGroups = Object.entries(itemsByFabric);
                    
                    // Calculate Total EXW for the visual Brand Group
                    const brandTotalEXW = brandItems.reduce((sum, { item }) => sum + ((item.valorEXW || 0) * (item.quantidade || 0)), 0);

                    const firstBrandItem = brandItems[0];
                    let photoUrl = firstBrandItem.mt?.modulo?.marca?.imagem || "";
                    if (photoUrl && !photoUrl.startsWith("http") && !photoUrl.startsWith("data:")) {
                        photoUrl = `data:image/png;base64,${photoUrl}`;
                    }
                    const brandName = firstBrandItem.mt?.modulo?.marca?.nome || "";
                    
                    // Determine total rows for Brand (to span Photo/Name/Total)
                    const totalBrandRows = brandItems.length;
                    
                    let renderedRows = 0;

                    return (
                        <React.Fragment key={brandIndex}>
                            {fabricGroups.map(([fabricName, fabItems], fabIndex) => {
                                // fabItems is list of modules with same fabric
                                const fabRowSpan = fabItems.length;
                                
                                return fabItems.map(({ item, mt }, itemIndex) => {
                                    const isFirstInBrand = renderedRows === 0; // First row of the entire Brand group
                                    const isFirstInFabric = itemIndex === 0; // First row of this Fabric sub-group

                                    // Fabric Format: "Name - Code"
                                    // Code: item.tempCodigoModuloTecido (most likely) or mt.codigoModuloTecido
                                    const fabricName = mt?.tecido?.nome || "";
                                    const fabricCode = item.tempCodigoModuloTecido || mt?.codigoModuloTecido || "";
                                    const fabricDisplay = fabricCode ? `${fabricName} - ${fabricCode}` : fabricName;

                                    renderedRows++;

                                    return (
                                        <tr key={item.id} style={{ borderBottom: "1px solid #ccc" }}>
                                            {/* Photo & Name: Span across ALL Brand items */}
                                            {isFirstInBrand && (
                                                <React.Fragment>
                                                    <td rowSpan={totalBrandRows} style={{ border: "1px solid #000", textAlign: "center", padding: 5, verticalAlign: "middle" }}>
                                                        {photoUrl && <img src={photoUrl} alt={brandName} style={{ maxWidth: "80px", maxHeight: "80px" }} />}
                                                    </td>
                                                    <td rowSpan={totalBrandRows} style={{ border: "1px solid #000", textAlign: "center", fontWeight: "bold", verticalAlign: "middle" }}>
                                                        {brandName}
                                                    </td>
                                                </React.Fragment>
                                            )}
                                            
                                            {/* Module Description: Per Item or Merged?
                                                User said: "Os campos Description e Fabric devem ser mesclados baseado no tecido"
                                                If we merge Description, we must list all items in one cell?
                                                OR we just remove borders to look merged?
                                                Given the columns Width/Depth/Height are per item, merging Description PHYSICALLY is tricky if height doesn't match.
                                                However, if we rowSpan Description, we must ensure the height covers the rows.
                                                Let's try rowSpan and render the content of THIS item only? No, that's regular.
                                                If we rowSpan, we render content for ALL items in this fabric group in one cell.
                                                BUT we have Width/Depth columns to the right which are 1 row each.
                                                So the Description cell will be tall. Inside it, we list the modules.
                                                We need to make sure the list lines up with the rows?
                                                Actually, if I look at the reference image, the Description text is centered vertically if it was merged?
                                                No, the reference image shows Description as "Modulo...".
                                                If the user wants MERGED Description, maybe they want the TEXT to be just the "Base Module Name" once?
                                                And then Qty is summed?
                                                No, "Qty Module" is a column.
                                                If I merge Description, I will list the modules with <br/> to try and align.
                                                BUT this is risky for alignment with Width/Depth.
                                                
                                                ALTERNATIVE INTERPRETATION: "Mesclados" means visual grouping.
                                                I will apply rowSpan to Description and list the items.
                                            */}
                                            {isFirstInFabric && (
                                                <td rowSpan={fabRowSpan} style={{ border: "1px solid #000", padding: 2, verticalAlign: "middle" }}>
                                                    {fabItems.map((f, i) => (
                                                        <div key={i} style={{ height: "20px", overflow: "hidden" }}> 
                                                            {/* Fixed height to try to align? No, unsafe. 
                                                                Let's just list them. The row heights of the other columns will stretch this cell 
                                                                BUT this cell is spanning multiple rows.
                                                                Wait, if I span, the other columns (Width etc) will be rendered in subsequent Trs.
                                                                The browser handles the height.
                                                                If I put all descriptions here, they might not align with the Widths visually if text wraps.
                                                                But let's do what asked.
                                                            */}
                                                            {(f.item.quantidade > 1 ? `${f.item.quantidade} ` : "") + (f.mt?.modulo?.descricao || "")}
                                                        </div>
                                                    ))}
                                                </td>
                                            )} 
                                            {/* If not first in fabric, we skip Description cell (it's spanned) */}
                                            
                                            {/* Dimensions: Per Item */}
                                            <td style={{ border: "1px solid #000", textAlign: "center" }}>{fmt(item.largura)}</td>
                                            <td style={{ border: "1px solid #000", textAlign: "center" }}>{fmt(item.profundidade)}</td>
                                            <td style={{ border: "1px solid #000", textAlign: "center" }}>{fmt(item.altura)}</td>
                                            <td style={{ border: "1px solid #000", textAlign: "center" }}>{fmt(item.quantidade, 0)}</td>
                                            <td className="col-m3" style={{ border: "1px solid #000", textAlign: "center" }}>{fmt3((item.m3 || 0) * (item.quantidade || 0))}</td>
                                            
                                            {/* Fabric: Span across Fabric Group */}
                                            {isFirstInFabric && (
                                                <td rowSpan={fabRowSpan} className="col-fabric" style={{ border: "1px solid #000", textAlign: "center", verticalAlign: "middle" }}>
                                                    {fabricDisplay}
                                                </td>
                                            )}
                                            
                                            {/* Feet & Finishing: Per Item (Data from PiItem, fallback to empty) */}
                                            <td style={{ border: "1px solid #000", textAlign: "center" }}>{item.feet || (item as any).Feet || ""}</td>
                                            <td style={{ border: "1px solid #000", textAlign: "center" }}>{item.finishing || (item as any).Finishing || ""}</td>
                                            
                                            {/* Observation: Per Item */}
                                            <td style={{ border: "1px solid #000" }}>{item.observacao || ""}</td>
                                            
                                            {/* Unit EXW: Per Item */}
                                            <td style={{ border: "1px solid #000", textAlign: "right" }}>$ {fmt(item.valorEXW)}</td>
                                            
                                            {/* Total Group EXW: Span across ALL Brand items */}
                                            {isFirstInBrand && (
                                                <td rowSpan={totalBrandRows} className="col-total" style={{ border: "1px solid #000", textAlign: "right", fontWeight: "bold", verticalAlign: "middle" }}>
                                                    $ {fmt(brandTotalEXW)}
                                                </td>
                                            )}
                                        </tr>
                                    );
                                });
                            })}
                        </React.Fragment>
                    );
                });
            })()}
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
              <p><strong>PRODUCTO:</strong> {fmt(totalItemsQty, 0)}</p>
              <p><strong>CBM M³:</strong> {fmt3((pi.piItens || []).reduce((acc: number, i: any) => acc + (i.m3 * i.quantidade), 0))}</p>
              <p><strong>P.N. TOTAL:</strong></p>
              <p><strong>P.B. TOTAL:</strong></p>
              <p><strong>VOLUMEN TOTAL:</strong> {fmt3((pi.piItens || []).reduce((acc: number, i: any) => acc + (i.m3 * i.quantidade), 0))}</p>
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
