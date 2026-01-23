
import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { getPi } from "../api/pis";
import type { ProformaInvoice, ModuloTecido } from "../api/types";
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

  const fmt = (n: number) => (n || 0).toLocaleString("pt-BR", { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  const fmt3 = (n: number) => (n || 0).toLocaleString("pt-BR", { minimumFractionDigits: 3, maximumFractionDigits: 3 });
  const dateObj = new Date(pi.dataPi);

  const totalGeralUSD = (pi.piItens || []).reduce((acc: number, i: any) => acc + i.valorFinalItemUSDRisco, 0);
  
  // Calculate total items quantity for "Product" field
  const totalItemsQty = (pi.piItens || []).reduce((acc: number, i: any) => acc + i.quantidade, 0);

  // Fallback if explicit fetch fails but PI has nested client (legacy check)
  const displayClient = cliente || (pi as any).cliente;

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

      <div className="print-header">
        <div>
           <h1 style={{ margin: "0 0 10px 0", fontSize: 20, textTransform: "uppercase" }}>KARAM'S INDUSTRIA E COMERCIO DE ESTOFADOS LTDA</h1>
           <div style={{ fontSize: 12, lineHeight: "1.4em" }}>
               <strong>CNPJ:</strong> 02.670.170/0001-09<br/>
               ROD PR 180 - KM 04 - LOTE 11 N8 B1 BAIRRO RURAL<br/>
               87890-000 TERRA RICA - PARANÁ<br/>
               KARAMS@KARAMS.COM.BR - https://karams.com.br/ <br/>
               (44) 3441-8400 | (44) 3441-1908
           </div>
        </div>
        <div style={{ textAlign: "right" }}>
            <h2 style={{ margin: 0, fontSize: 20 }}>PI Nº: {pi.prefixo}-{pi.piSequencia}</h2>
            <p style={{ margin: "5px 0", fontSize: 14 }}>Data: {dateObj.toLocaleDateString()}</p>
        </div>
      </div>

      <div className="print-info">
        <div>
            <strong>CLIENTE:</strong><br />
            <span style={{ fontSize: 16, fontWeight: "bold" }}>{displayClient?.nome || `Cliente #${pi.idCliente}`}</span><br />
            <span style={{ fontSize: 14 }}>
              {[
                displayClient?.endereco,
                displayClient?.cidade,
                displayClient?.pais,
                displayClient?.cep ? `CEP: ${displayClient?.cep}` : null
              ].filter(Boolean).join(" - ")}
            </span>
        </div>
        <div style={{ textAlign: "right" }}>
            <strong>Frete Tipo:</strong> {(pi as any).frete?.nome || `Frete #${pi.idFrete}`}
        </div>
      </div>

      <table className="print-table">
        <thead>
            <tr>
                <th style={{ width: 40 }}>Item</th>
                <th>Descrição</th>
                <th style={{ width: 60 }}>Qtd</th>
                <th style={{ width: 80 }}>m³ Unit.</th>
                <th style={{ width: 80 }}>m³ Total</th>
                <th style={{ width: 100 }}>Vl. Unit. EXW</th>
                <th style={{ width: 100 }}>Frete USD</th>
                <th style={{ width: 100 }}>Total USD</th>
            </tr>
        </thead>
        <tbody>
            {(pi.piItens || []).map((item: any, idx: number) => {
                const desc = getDescricao(item.idModuloTecido);
                return (
                    <tr key={idx}>
                        <td style={{ textAlign: "center" }}>{idx + 1}</td>
                        <td>{desc}</td>
                        <td style={{ textAlign: "center" }}>{fmt(item.quantidade)}</td>
                        <td style={{ textAlign: "center" }}>{fmt3(item.m3)}</td>
                        <td style={{ textAlign: "center" }}>{fmt3(item.m3 * item.quantidade)}</td>
                        <td style={{ textAlign: "right" }}>$ {fmt(item.valorEXW)}</td>
                        <td style={{ textAlign: "right" }}>$ {fmt(item.valorFreteRateadoUSD)}</td>
                        <td style={{ textAlign: "right" }}>$ {fmt(item.valorFinalItemUSDRisco)}</td>
                    </tr>
                );
            })}
        </tbody>
        <tfoot>
            <tr style={{ background: "#f9f9f9", fontWeight: "bold" }}>
                <td colSpan={2} style={{ textAlign: "right" }}>TOTAIS:</td>
                <td style={{ textAlign: "center" }}>
                    {fmt((pi.piItens || []).reduce((acc: number, i: any) => acc + i.quantidade, 0))}
                </td>
                <td></td>
                <td style={{ textAlign: "center" }}>
                    {fmt3((pi.piItens || []).reduce((acc: number, i: any) => acc + (i.m3 * i.quantidade), 0))}
                </td>
                <td></td>
                <td></td>
                <td style={{ textAlign: "right" }}>$ {fmt(totalGeralUSD)}</td>
            </tr>
        </tfoot>
      </table>

      <div className="totals-section">
          <div className="print-totals">
             <div style={{ display: "flex", justifyContent: "space-between" }}>
                <span>Valor Tecido:</span>
                <span>R$ {fmt(pi.valorTecido)}</span>
             </div>
             <div style={{ display: "flex", justifyContent: "space-between" }}>
                <span>Total Frete USD:</span>
                <span>$ {fmt(pi.valorTotalFreteUSD)}</span>
             </div>
             <div style={{ display: "flex", justifyContent: "space-between", marginTop: 10, fontWeight: "bold", borderTop: "1px solid #ccc", paddingTop: 5 }}>
                <span>TOTAL GERAL (USD):</span>
                <span>$ {fmt(totalGeralUSD)}</span>
             </div>
          </div>
      </div>

      <div style={{ marginTop: 50, marginBottom: 30 }}>
          <strong>SIGNATURE:</strong> __________________________________________________________________
      </div>

      <div className="footer-grid">
          <div className="footer-col bank-details">
              <h3>ACCOUNTING DETAILS:</h3>
              <p><strong>INTERMEDIARY BANK</strong></p>
              <p>BANK OF AMERICA, N.A.</p>
              <p>ADDRESS: NEW YORK - US</p>
              <p>SWIFT CODE: BOFAUS3N</p>
              <p>ACCOUNT: 6550925836</p>
              <br/>
              <p><strong>BENEFICIARY BANK:</strong></p>
              <p>BANCO RENDIMENTO S/A</p>
              <p>ADDRESS: SÃO PAULO - BR</p>
              <p>SWIFT CODE: RENDBRSP</p>
              <p>IBAN: BR4468900810000010025069901 I1</p>
              <p>ACCOUNT: 00250699000148</p>
              <p>NAME: KARAM'S INDUSTRIA E COMERCIO DE ESTOFADOS LTDA</p>
          </div>
          <div className="footer-col">
              <h3>GENERAL PRODUCT DATA</h3>
              <p><strong>Brand:</strong> Karams</p>
              <p><strong>NCM:</strong> 94016100</p>
              <p><strong>Product:</strong> {fmt(totalItemsQty)}</p>
              <p><strong>Factory original products</strong></p>
          </div>
      </div>
    
      <div style={{ marginTop: 40, borderTop: "1px solid #000", paddingTop: 10, textAlign: "center", fontSize: 10 }} className="no-print">
        Visualização de Impressão - Sistema PI Web
      </div>
    </div>
  );
}
