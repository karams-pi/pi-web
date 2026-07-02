import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { ArrowLeft, Printer, FileText } from "lucide-react";

export default function PrintEdcPage() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [estudo, setEstudo] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function load() {
      if (!id) return;
      try {
        const response = await fetch(`/api/edc/simulacoes/${id}`);
        const data = await response.json();
        
        const previewRes = await fetch("/api/edc/simulacoes/preview", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(data)
        });
        const calculatedData = await previewRes.json();
        setEstudo(calculatedData);
      } catch (error) {
        console.error("Erro ao carregar estudo para impressão:", error);
      } finally {
        setLoading(false);
      }
    }
    load();
  }, [id]);

  useEffect(() => {
    if (!loading && estudo) {
      const query = new URLSearchParams(window.location.search);
      if (query.get("color") === "true") {
        document.body.classList.add("print-keep-colors");
        
        const handleAfterPrint = () => {
          document.body.classList.remove("print-keep-colors");
          window.removeEventListener("afterprint", handleAfterPrint);
        };
        window.addEventListener("afterprint", handleAfterPrint);
        
        setTimeout(() => {
          window.print();
        }, 500);
      }
    }
  }, [loading, estudo]);

  if (loading) return <div style={{ padding: 40, fontFamily: "Segoe UI, sans-serif" }}>Calculando impostos e taxas para impressão...</div>;
  if (!estudo) return <div style={{ padding: 40, fontFamily: "Segoe UI, sans-serif" }}>Estudo não localizado.</div>;

  // Calculos Locais baseados no DetalheEstudoEdcPage
  const ptaxFator = 1 + (estudo.spreadCambio / 100);
  const freteBrl = (estudo.valorFreteInternacional * ptaxFator) * estudo.cotacaoDolar;
  const seguroBrl = estudo.valorSeguroInternacional * estudo.cotacaoDolar;

  // Filtrar e normalizar despesas aduaneiras
  const despesasDetalhadas = estudo.despesas ? estudo.despesas.map((d: any) => {
    const isAfrmm = d.nomeDespesa.toUpperCase() === "AFRMM";
    let valorBrl = 0;
    let detalheTipo = "Fixo";
    let valorOriginal = d.valor;

    if (isAfrmm) {
      const percentual = d.valor > 1 ? d.valor : d.valor * 100;
      detalheTipo = `${percentual.toLocaleString("pt-BR", { minimumFractionDigits: 0, maximumFractionDigits: 2 })}%`;
      valorBrl = freteBrl * (percentual / 100);
      valorOriginal = valorBrl;
    } else {
      valorBrl = d.moeda === "USD" ? d.valor * estudo.cotacaoDolar : d.valor;
    }

    return {
      nomeDespesa: d.nomeDespesa,
      moeda: d.moeda,
      valorOriginal,
      detalheTipo,
      valorBrl,
      isAfrmm
    };
  }) : [];

  const totalFobUSD = estudo.itens ? estudo.itens.reduce((acc: number, i: any) => acc + (i.quantidade * i.valorFobUnitario), 0) : 0;
  const totalFobBrl = totalFobUSD * estudo.cotacaoDolar;

  const totalQuantidade = estudo.itens ? estudo.itens.reduce((acc: number, i: any) => acc + i.quantidade, 0) : 0;
  const totalPeso = estudo.itens ? estudo.itens.reduce((acc: number, i: any) => acc + (i.pesoLiquidoTotal > 0 ? i.pesoLiquidoTotal : ((i.produto?.pesoLiquido * i.quantidade) || 0)), 0) : 0;
  const totalVolume = estudo.itens ? estudo.itens.reduce((acc: number, i: any) => acc + (i.cubagemTotal > 0 ? i.cubagemTotal : ((i.produto?.cubagemM3 * i.quantidade) || 0)), 0) : 0;

  // Adicionar comissão Seewise se aplicável
  const comissaoValBrl = (estudo.flExibirComissao && estudo.comissaoPercentual > 0)
    ? totalFobBrl * (estudo.comissaoPercentual / 100)
    : 0;

  const despesasFinalParaResumo = [...despesasDetalhadas];
  if (estudo.flExibirComissao && estudo.comissaoPercentual > 0) {
    despesasFinalParaResumo.push({
      nomeDespesa: `COMISSÃO COMERCIAL (${estudo.comissaoPercentual.toLocaleString("pt-BR", { minimumFractionDigits: 0, maximumFractionDigits: 2 })}%)`,
      moeda: "USD",
      valorOriginal: totalFobUSD * (estudo.comissaoPercentual / 100),
      detalheTipo: "Percentual",
      valorBrl: comissaoValBrl,
      isAfrmm: false
    });
  }

  const totalDespesasPortuariasSemFreteBrl = despesasFinalParaResumo
    .filter((d: any) => d.nomeDespesa.toUpperCase() !== "FRETE")
    .reduce((acc: number, d: any) => acc + d.valorBrl, 0);

  const itensCalculados = estudo.itens ? estudo.itens.map((item: any) => {
    const itemFobBrl = item.quantidade * item.valorFobUnitario * estudo.cotacaoDolar;
    const fatorRateio = totalFobBrl > 0 ? itemFobBrl / totalFobBrl : 0;
    
    // Valor aduaneiro cheio
    const itemValorAduaneiroCheio = itemFobBrl + (freteBrl * fatorRateio) + (seguroBrl * fatorRateio);
    
    // Subfaturamento
    const valorFobUnitarioSub = item.valorFobSubfaturado !== null && item.valorFobSubfaturado !== undefined
      ? item.valorFobSubfaturado
      : (estudo.flSimularSubfaturamento 
          ? (item.valorFobUnitario * (estudo.percentualSubfaturamento / 100)) 
          : item.valorFobUnitario);
          
    const itemFobSubBrl = item.quantidade * valorFobUnitarioSub * estudo.cotacaoDolar;
    
    // Base de cálculo tributos
    const baseCalculoAduaneiro = estudo.flSimularSubfaturamento
      ? (itemFobSubBrl + (freteBrl * fatorRateio) + (seguroBrl * fatorRateio))
      : itemValorAduaneiroCheio;
    
    const aliqII = item.produto?.ncm?.aliquotaII || 0;
    const aliqIPI = item.produto?.ncm?.aliquotaIPI || 0;
    const aliqPis = item.produto?.ncm?.aliquotaPis || 0;
    const aliqCof = item.produto?.ncm?.aliquotaCofins || 0;
    let aliqIcms = item.produto?.ncm?.aliquotaIcmsPadrao;
    if (!aliqIcms || aliqIcms <= 0) {
      aliqIcms = estudo.importador?.aliquotaIcmsPadrao;
    }
    if (!aliqIcms || aliqIcms <= 0) {
      aliqIcms = 0.18;
    }

    const ii = baseCalculoAduaneiro * aliqII;
    const ipi = (baseCalculoAduaneiro + ii) * aliqIPI;
    
    let pisCofins = 0;
    if (estudo.metodoCalculoFederais === "SimplificadoExcel") {
      pisCofins = (baseCalculoAduaneiro + ii) * (aliqPis + aliqCof);
    } else {
      pisCofins = baseCalculoAduaneiro * (aliqPis + aliqCof);
    }

    // Rateio despesas portuárias (incluindo comissão)
    let taxasPort = 0;
    if (despesasFinalParaResumo) {
      despesasFinalParaResumo.forEach((d: any) => {
        // Ignorar frete internacional pois ele já entra na base aduaneira
        if (d.nomeDespesa.toUpperCase() === "FRETE") return;

        const valorDespesaBrl = d.valorBrl;

        let fatorDespesa = 0;
        if (d.metodoRateio === "Quantidade") {
          fatorDespesa = totalQuantidade > 0 ? item.quantidade / totalQuantidade : 0;
        } else if (d.metodoRateio === "Peso") {
          const itemPeso = item.pesoLiquidoTotal > 0 ? item.pesoLiquidoTotal : ((item.produto?.pesoLiquido * item.quantidade) || 0);
          fatorDespesa = totalPeso > 0 ? itemPeso / totalPeso : 0;
        } else if (d.metodoRateio === "Volume") {
          const itemVolume = item.cubagemTotal > 0 ? item.cubagemTotal : ((item.produto?.cubagemM3 * item.quantidade) || 0);
          fatorDespesa = totalVolume > 0 ? itemVolume / totalVolume : 0;
        } else {
          fatorDespesa = fatorRateio;
        }

        taxasPort += valorDespesaBrl * fatorDespesa;
      });
    }

    // ICMS
    let icms = 0;
    if (estudo.metodoCalculoIcms === "SimplificadoExcel") {
      icms = baseCalculoAduaneiro * aliqIcms;
    } else {
      const baseIcmsSemIcms = baseCalculoAduaneiro + ii + ipi + pisCofins + taxasPort;
      icms = baseIcmsSemIcms / (1 - aliqIcms) * aliqIcms;
    }
    
    const totalNacItem = itemValorAduaneiroCheio + ii + ipi + pisCofins + taxasPort + icms;

    return {
      ...item,
      itemFobBrl,
      itemValorAduaneiro: itemValorAduaneiroCheio,
      baseCalculoAduaneiro,
      ii,
      ipi,
      pisCofins,
      taxasPort,
      icms,
      totalNacItem,
      custoUnitarioNacionalizado: item.quantidade > 0 ? totalNacItem / item.quantidade : 0
    };
  }) : [];

  const totalII = itensCalculados.reduce((acc: number, i: any) => acc + i.ii, 0);
  const totalIPI = itensCalculados.reduce((acc: number, i: any) => acc + i.ipi, 0);
  const totalPisCofins = itensCalculados.reduce((acc: number, i: any) => acc + i.pisCofins, 0);
  const totalIcms = itensCalculados.reduce((acc: number, i: any) => acc + i.icms, 0);
  const totalTributos = totalII + totalIPI + totalPisCofins + totalIcms;
  
  const totalGeralNacionalizado = totalFobBrl + freteBrl + seguroBrl + totalTributos + totalDespesasPortuariasSemFreteBrl;

  // Formatação
  const fmtBrl = (val: number) => "R$ " + (val || 0).toLocaleString("pt-BR", { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  const fmtUsd = (val: number) => "$ " + (val || 0).toLocaleString("pt-BR", { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  const fmtPct = (val: number) => ((val || 0) * 100).toLocaleString("pt-BR", { minimumFractionDigits: 0, maximumFractionDigits: 2 }) + "%";

  const ncmPadrao = estudo.itens && estudo.itens[0]?.produto?.ncm?.codigo ? estudo.itens[0].produto.ncm.codigo : "87088000";
  const descNcm = estudo.itens && estudo.itens[0]?.produto?.descricao ? estudo.itens[0].produto.descricao : "AMORTECEDORES";
  let icmsPadrao = estudo.itens && estudo.itens[0]?.produto?.ncm?.aliquotaIcmsPadrao;
  if (!icmsPadrao || icmsPadrao <= 0) {
    icmsPadrao = estudo.importador?.aliquotaIcmsPadrao;
  }
  if (!icmsPadrao || icmsPadrao <= 0) {
    icmsPadrao = 0.18;
  }

  const handlePrintColors = () => {
    document.body.classList.add("print-keep-colors");
    const handleAfterPrint = () => {
      document.body.classList.remove("print-keep-colors");
      window.removeEventListener("afterprint", handleAfterPrint);
    };
    window.addEventListener("afterprint", handleAfterPrint);
    window.print();
  };

  return (
    <div className="print-edc-wrapper">
      <style>{`
        @media screen {
          .print-edc-wrapper {
            background-color: #0f172a;
            color: #f8fafc;
            padding: 30px;
            font-family: 'Segoe UI', system-ui, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
          }
          .print-page-container {
            background-color: #1e293b;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.3), 0 8px 10px -6px rgba(0, 0, 0, 0.3);
            border-radius: 12px;
            width: 100%;
            max-width: 1100px;
            padding: 40px;
            border: 1px solid rgba(255, 255, 255, 0.05);
          }
          .top-bar-actions {
            max-width: 1100px;
            width: 100%;
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
          }
          .btn-action {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 18px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            border: none;
          }
          .btn-back {
            background-color: rgba(255, 255, 255, 0.05);
            color: #e2e8f0;
          }
          .btn-back:hover {
            background-color: rgba(255, 255, 255, 0.1);
          }
          .btn-print {
            background-color: #10b981;
            color: white;
          }
          .btn-print:hover {
            background-color: #059669;
          }
          .sheet-header-box {
            border: 1px solid rgba(255, 255, 255, 0.08);
            background: rgba(255, 255, 255, 0.02);
          }
          .section-title {
            color: #38bdf8;
            border-bottom: 2px solid rgba(56, 189, 248, 0.2);
          }
          .custom-table {
            width: 100%;
            border-collapse: collapse;
          }
          .custom-table th {
            background: rgba(255, 255, 255, 0.04);
            color: #94a3b8;
            border: 1px solid rgba(255, 255, 255, 0.08);
          }
          .custom-table td {
            border: 1px solid rgba(255, 255, 255, 0.08);
          }
          .total-highlight {
            background: rgba(245, 158, 11, 0.1);
            color: #fbbf24;
            font-weight: 700;
          }
          .page-break-indicator {
            border-top: 2px dashed rgba(255, 255, 255, 0.1);
            margin: 40px 0;
            position: relative;
            text-align: center;
          }
          .page-break-indicator::after {
            content: "Quebra de Página Impressa";
            position: absolute;
            top: -10px;
            left: 50%;
            transform: translateX(-50%);
            background: #1e293b;
            padding: 0 10px;
            font-size: 0.75rem;
            color: #64748b;
          }
        }

        @media print {
          @page {
            margin: 1.2cm;
            size: portrait;
          }
          /* Normal Print (Light mode for saving ink) */
          body:not(.print-keep-colors), html:not(.print-keep-colors) {
            background: #fff !important;
            color: #000 !important;
          }
          body:not(.print-keep-colors) .print-edc-wrapper {
            background: #fff !important;
            color: #000 !important;
            padding: 0 !important;
            min-height: 0 !important;
            display: block !important;
          }
          body:not(.print-keep-colors) .print-page-container {
            box-shadow: none !important;
            border: none !important;
            border-radius: 0 !important;
            padding: 0 !important;
            max-width: 100% !important;
            width: 100% !important;
          }
          body:not(.print-keep-colors) .sheet-header-box {
            border: 1px solid #000 !important;
            background: #f1f5f9 !important;
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
          }
          body:not(.print-keep-colors) .section-title {
            color: #0f172a !important;
            border-bottom: 2px solid #000 !important;
            font-weight: bold;
          }
          body:not(.print-keep-colors) .custom-table th {
            background: #f1f5f9 !important;
            color: #0f172a !important;
            border: 1px solid #000 !important;
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
          }
          body:not(.print-keep-colors) .custom-table td {
            border: 1px solid #000 !important;
            color: #000 !important;
          }
          body:not(.print-keep-colors) .total-highlight {
            background: #fef08a !important;
            color: #000 !important;
            font-weight: bold;
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
          }

          /* Color PDF Print (Exact Screen Styling) */
          body.print-keep-colors, html.print-keep-colors {
            background: #0f172a !important;
            color: #f8fafc !important;
            -webkit-print-color-adjust: exact !important;
            print-color-adjust: exact !important;
          }
          body.print-keep-colors .print-edc-wrapper {
            background: #0f172a !important;
            color: #f8fafc !important;
            padding: 0 !important;
            min-height: 0 !important;
            display: block !important;
            -webkit-print-color-adjust: exact !important;
            print-color-adjust: exact !important;
          }
          body.print-keep-colors .print-page-container {
            background-color: #1e293b !important;
            box-shadow: none !important;
            border: 1px solid rgba(255, 255, 255, 0.05) !important;
            border-radius: 12px !important;
            padding: 20px !important;
            max-width: 100% !important;
            width: 100% !important;
            -webkit-print-color-adjust: exact !important;
            print-color-adjust: exact !important;
          }
          body.print-keep-colors .sheet-header-box {
            border: 1px solid rgba(255, 255, 255, 0.08) !important;
            background: rgba(255, 255, 255, 0.02) !important;
            color: #f8fafc !important;
            -webkit-print-color-adjust: exact !important;
            print-color-adjust: exact !important;
          }
          body.print-keep-colors .section-title {
            color: #38bdf8 !important;
            border-bottom: 2px solid rgba(56, 189, 248, 0.2) !important;
            -webkit-print-color-adjust: exact !important;
            print-color-adjust: exact !important;
          }
          body.print-keep-colors .custom-table th {
            background: rgba(255, 255, 255, 0.04) !important;
            color: #94a3b8 !important;
            border: 1px solid rgba(255, 255, 255, 0.08) !important;
            -webkit-print-color-adjust: exact !important;
            print-color-adjust: exact !important;
          }
          body.print-keep-colors .custom-table td {
            border: 1px solid rgba(255, 255, 255, 0.08) !important;
            color: #f8fafc !important;
            -webkit-print-color-adjust: exact !important;
            print-color-adjust: exact !important;
          }
          body.print-keep-colors .total-highlight {
            background: rgba(245, 158, 11, 0.1) !important;
            color: #fbbf24 !important;
            font-weight: 700 !important;
            -webkit-print-color-adjust: exact !important;
            print-color-adjust: exact !important;
          }

          .no-print {
            display: none !important;
          }
          .page-break-print {
            page-break-before: always;
            break-before: page;
          }
          .page-break-indicator {
            display: none !important;
          }
        }

        /* Common Styling */
        .sheet-header-box {
          padding: 16px;
          border-radius: 8px;
          margin-bottom: 25px;
        }
        .header-grid {
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: 20px;
        }
        .header-cell {
          font-size: 0.85rem;
          line-height: 1.5;
        }
        .header-cell strong {
          color: inherit;
        }
        .section-title {
          font-size: 1.15rem;
          text-transform: uppercase;
          letter-spacing: 0.5px;
          padding-bottom: 6px;
          margin-top: 30px;
          margin-bottom: 15px;
        }
        .custom-table {
          font-size: 0.85rem;
          margin-bottom: 20px;
        }
        .custom-table th, .custom-table td {
          padding: 8px 12px;
          text-align: left;
        }
        .text-right {
          text-align: right !important;
        }
        .text-center {
          text-align: center !important;
        }
        .bold {
          font-weight: bold;
        }
        .summary-blocks {
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: 30px;
          margin-top: 20px;
        }
        .commission-warning-text {
          font-size: 0.8rem;
          font-weight: 600;
          font-style: italic;
          line-height: 1.4;
          max-width: 420px;
          text-align: justify;
          color: #ca8a04 !important;
          -webkit-print-color-adjust: exact;
          print-color-adjust: exact;
        }
        @media screen {
          .commission-warning-text {
            color: #fbbf24 !important;
          }
        }
        @media print {
          body.print-keep-colors .commission-warning-text {
            color: #fbbf24 !important;
            -webkit-print-color-adjust: exact !important;
            print-color-adjust: exact !important;
          }
        }
        .simulation-warning-text {
          font-size: 0.72rem;
          font-weight: 500;
          font-style: italic;
          line-height: 1.4;
          max-width: 420px;
          text-align: justify;
          color: #ca8a04 !important;
          margin-bottom: 8px;
          -webkit-print-color-adjust: exact;
          print-color-adjust: exact;
        }
        @media screen {
          .simulation-warning-text {
            color: #fbbf24 !important;
          }
        }
        @media print {
          body.print-keep-colors .simulation-warning-text {
            color: #fbbf24 !important;
            -webkit-print-color-adjust: exact !important;
            print-color-adjust: exact !important;
          }
        }
        .grand-total-card {
          width: 100%;
          max-width: 460px;
          background: rgba(255, 255, 255, 0.02);
          border: 1px solid rgba(255, 255, 255, 0.08);
          border-radius: 10px;
          padding: 8px 12px;
          overflow: hidden;
        }
        @media print {
          .grand-total-card {
            background: #f8fafc !important;
            border: 1px solid #e2e8f0 !important;
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
          }
          body.print-keep-colors .grand-total-card {
            background: #1e293b !important;
            border: 1px solid rgba(255, 255, 255, 0.08) !important;
            -webkit-print-color-adjust: exact !important;
            print-color-adjust: exact !important;
          }
        }
        .subtotal-table {
          width: 100%;
          border-collapse: collapse;
          font-size: 0.9rem;
        }
        .subtotal-table td {
          padding: 8px 12px;
          border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        }
        @media print {
          .subtotal-table td {
            border-bottom: 1px solid #000 !important;
          }
        }
      `}</style>

      {/* Top action bar visible only on screen */}
      <div className="top-bar-actions no-print">
        <button className="btn-action btn-back" onClick={() => navigate(`/edc/estudos/${id}`)}>
          <ArrowLeft size={18} />
          <span>Voltar para Detalhes</span>
        </button>
        <div style={{ display: "flex", gap: "12px" }}>
          <button className="btn-action btn-print" onClick={handlePrintColors} style={{ backgroundColor: "#7c3aed" }}>
            <FileText size={18} />
            <span>Exportar PDF Colorido</span>
          </button>
          <button className="btn-action btn-print" onClick={() => window.print()}>
            <Printer size={18} />
            <span>Imprimir Relatório</span>
          </button>
        </div>
      </div>

      <div className="print-page-container">
        {/* ================= PAGE 1: ESTIMATIVA DE CUSTOS GERAL ================= */}
        <div style={{ display: "flex", alignItems: "center", marginBottom: "30px", gap: "20px" }}>
          <div style={{ flexShrink: 0 }}>
            <img src="/logo-seawise.png" alt="SEAWISE" style={{ height: "55px", objectFit: "contain" }} />
          </div>
          <div style={{ flexGrow: 1, textAlign: "center", marginRight: "75px" }}>
            <h1 style={{ margin: "0 0 5px 0", fontSize: "1.8rem", fontWeight: "800" }}>Estimativa de Custo 100%</h1>
            <p style={{ margin: 0, fontSize: "0.9rem", color: "#94a3b8" }}>
              Estudo de Nacionalização e Tributos Aduaneiros - Referência {estudo.numeroReferencia}
            </p>
          </div>
        </div>

        <div className="sheet-header-box">
          <div className="header-grid">
            <div className="header-cell">
              <div><strong>IMPORTADOR:</strong> {estudo.importador?.razaoSocial} (CNPJ: {estudo.importador?.cnpj})</div>
              <div><strong>REGIME TRIBUTÁRIO:</strong> {(estudo.importador?.regimeTributario || "SIMPLES NACIONAL").toUpperCase()}</div>
              <div><strong>PRODUTO:</strong> {descNcm.toUpperCase()}</div>
              <div><strong>INCOTERM:</strong> {estudo.tipoFrete || "1x40"}</div>
              <div><strong>TAXA DE CÂMBIO UTILIZADA:</strong> {fmtBrl(estudo.cotacaoDolar)}</div>
            </div>
            <div className="header-cell" style={{ paddingLeft: "20px", borderLeft: "1px solid rgba(255,255,255,0.1)" }}>
              <div><strong>ICMS:</strong> {fmtPct(icmsPadrao)}</div>
              <div><strong>PORTO ORIGEM / SAÍDA:</strong> {estudo.portoOrigem?.nome || "SHANGHAI"}</div>
              <div><strong>PORTO DESTINO / ENTRADA:</strong> {estudo.portoDestino?.nome || "PARANAGUÁ"}</div>
              <div><strong>DATA:</strong> {new Date(estudo.dataEstudo).toLocaleDateString("pt-BR")}</div>
              <div><strong>NCM:</strong> {ncmPadrao}</div>
            </div>
          </div>
        </div>

        {/* VALORES ADUANEIROS */}
        <h2 className="section-title">1. Valores Aduaneiros</h2>
        <table className="custom-table">
          <thead>
            <tr>
              <th>Discriminação</th>
              <th className="text-center">Qtd Itens</th>
              <th className="text-right">Preço USD (FOB)</th>
              <th className="text-right">FOB Total USD</th>
              <th className="text-right">FOB Total BRL</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>PRODUTO</td>
              <td className="text-center">{totalQuantidade}</td>
              <td className="text-right">{fmtUsd(totalFobUSD / (totalQuantidade || 1))}</td>
              <td className="text-right">{fmtUsd(totalFobUSD)}</td>
              <td className="text-right">{fmtBrl(totalFobBrl)}</td>
            </tr>
            <tr className="bold" style={{ background: "rgba(255,255,255,0.01)" }}>
              <td>TOTAL FOB</td>
              <td className="text-center">{totalQuantidade}</td>
              <td className="text-right">{fmtUsd(totalFobUSD / (totalQuantidade || 1))}</td>
              <td className="text-right">{fmtUsd(totalFobUSD)}</td>
              <td className="text-right">{fmtBrl(totalFobBrl)}</td>
            </tr>
            <tr>
              <td>PRODUTO + FRETE</td>
              <td className="text-center">-</td>
              <td className="text-right">-</td>
              <td className="text-right">-</td>
              <td className="text-right">{fmtBrl(totalFobBrl + freteBrl)}</td>
            </tr>
            <tr>
              <td>Seguro Internacional</td>
              <td className="text-center">-</td>
              <td className="text-right">{fmtUsd(estudo.valorSeguroInternacional)}</td>
              <td className="text-right">-</td>
              <td className="text-right">{fmtBrl(seguroBrl)}</td>
            </tr>
            <tr>
              <td>Frete Internacional</td>
              <td className="text-center">-</td>
              <td className="text-right">{fmtUsd(estudo.valorFreteInternacional)}</td>
              <td className="text-right">-</td>
              <td className="text-right">{fmtBrl(freteBrl)}</td>
            </tr>
            <tr className="total-highlight">
              <td colSpan={4}>TOTAL VALOR ADUANEIRO</td>
              <td className="text-right">{fmtBrl(totalFobBrl + freteBrl + seguroBrl)}</td>
            </tr>
          </tbody>
        </table>

        {/* IMPOSTOS */}
        <h2 className="section-title">2. Impostos Nacionalização</h2>
        <table className="custom-table">
          <thead>
            <tr>
              <th>Impostos</th>
              <th className="text-center">Alíquota (%)</th>
              <th className="text-right">Valor em Reais (R$)</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>IMPOSTO DE IMPORTAÇÃO (II)</td>
              <td className="text-center">{fmtPct(itensCalculados[0]?.produto?.ncm?.aliquotaII || 0.18)}</td>
              <td className="text-right">{fmtBrl(totalII)}</td>
            </tr>
            <tr>
              <td>IPI</td>
              <td className="text-center">{fmtPct(itensCalculados[0]?.produto?.ncm?.aliquotaIPI || 0.0306)}</td>
              <td className="text-right">{fmtBrl(totalIPI)}</td>
            </tr>
            <tr>
              <td>PIS</td>
              <td className="text-center">{fmtPct(itensCalculados[0]?.produto?.ncm?.aliquotaPis || 0.0312)}</td>
              <td className="text-right">{fmtBrl(totalPisCofins * (0.0312 / (0.0312 + 0.1437)))}</td>
            </tr>
            <tr>
              <td>COFINS</td>
              <td className="text-center">{fmtPct(itensCalculados[0]?.produto?.ncm?.aliquotaCofins || 0.1437)}</td>
              <td className="text-right">{fmtBrl(totalPisCofins * (0.1437 / (0.0312 + 0.1437)))}</td>
            </tr>
            <tr>
              <td>ICMS</td>
              <td className="text-center">{fmtPct(icmsPadrao)}</td>
              <td className="text-right">{fmtBrl(totalIcms)}</td>
            </tr>
            <tr className="total-highlight">
              <td colSpan={2}>TOTAL VALOR IMPOSTOS</td>
              <td className="text-right">{fmtBrl(totalTributos)}</td>
            </tr>
          </tbody>
        </table>

        {/* DESPESAS ADUANEIRAS */}
        <h2 className="section-title">3. Despesas Portuárias, Aduaneiras e Logísticas</h2>
        <table className="custom-table">
          <thead>
            <tr>
              <th>Descrição da Despesa</th>
              <th className="text-center">Tipo / Alíquota</th>
              <th className="text-right">Moeda</th>
              <th className="text-right">Valor Original</th>
              <th className="text-right">Valor BRL (R$)</th>
            </tr>
          </thead>
          <tbody>
            {despesasFinalParaResumo.filter((d: any) => d.nomeDespesa.toUpperCase() !== "FRETE").map((desp: any, index: number) => (
              <tr key={index}>
                <td>{desp.nomeDespesa}</td>
                <td className="text-center">{desp.detalheTipo}</td>
                <td className="text-right">{desp.moeda}</td>
                <td className="text-right">{desp.moeda === "USD" ? fmtUsd(desp.valorOriginal) : fmtBrl(desp.valorOriginal)}</td>
                <td className="text-right">{fmtBrl(desp.valorBrl)}</td>
              </tr>
            ))}
            <tr className="total-highlight">
              <td colSpan={4}>TOTAL VALOR DESEMBARAÇO ADUANEIRO</td>
              <td className="text-right">{fmtBrl(totalDespesasPortuariasSemFreteBrl)}</td>
            </tr>
          </tbody>
        </table>

        {/* GRAND TOTAL */}
        <div style={{ display: "flex", justifyContent: "flex-end", marginTop: "25px", marginBottom: "25px" }}>
          <div className="grand-total-card">
            <table className="subtotal-table">
              <tbody>
                <tr>
                  <td className="bold">TOTAL FOB DO LOTE (BRL)</td>
                  <td className="text-right bold">{fmtBrl(totalFobBrl)}</td>
                </tr>
                <tr>
                  <td className="bold">TOTAL DESPESAS + TRIBUTOS</td>
                  <td className="text-right bold">{fmtBrl(totalGeralNacionalizado - totalFobBrl)}</td>
                </tr>
                <tr className="total-highlight" style={{ fontSize: "1.1rem" }}>
                  <td className="bold" style={{ borderBottom: "none", borderRadius: "0 0 0 8px" }}>CUSTO TOTAL NACIONALIZADO</td>
                  <td className="text-right bold" style={{ borderBottom: "none", borderRadius: "0 0 8px 0" }}>{fmtBrl(totalGeralNacionalizado)}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <div className="page-break-indicator"></div>
        <div className="page-break-print"></div>

        {/* ================= PAGE 2: MEMÓRIA DE CÁLCULO E LISTA DE COMPRAS ================= */}
        <div style={{ display: "flex", alignItems: "center", marginBottom: "30px", gap: "20px" }}>
          <div style={{ flexShrink: 0 }}>
            <img src="/logo-seawise.png" alt="SEAWISE" style={{ height: "55px", objectFit: "contain" }} />
          </div>
          <div style={{ flexGrow: 1, textAlign: "center", marginRight: "75px" }}>
            <h1 style={{ margin: "0" /* removed bottom margin as there is no subtitle now */, fontSize: "1.8rem", fontWeight: "800" }}>Custo Nacionalizado Por Item</h1>
          </div>
        </div>

        <table className="custom-table" style={{ fontSize: "0.75rem", width: "100%" }}>
          <thead>
            <tr>
              <th>Prod.</th>
              <th className="text-center">NCM</th>
              <th className="text-center">Qtd</th>
              <th className="text-center">U.M.</th>
              <th className="text-right">FOB Unit (USD)</th>
              <th className="text-right">Aduaneiro (R$)</th>
              <th className="text-right">II (R$)</th>
              <th className="text-right">IPI (R$)</th>
              <th className="text-right">PIS/COF (R$)</th>
              <th className="text-right">Taxas Port. (R$)</th>
              <th className="text-right">ICMS (R$)</th>
              <th className="text-right bold">Total Item (R$)</th>
              <th className="text-right bold">Unit. Nac. (R$)</th>
            </tr>
          </thead>
          <tbody>
            {itensCalculados.map((item: any, idx: number) => (
              <tr key={idx}>
                <td style={{ fontWeight: "bold" }}>
                  {item.modelo ? item.modelo.codigo : item.produto?.referencia}
                </td>
                <td className="text-center">{item.produto?.ncm?.codigo}</td>
                <td className="text-center">{item.quantidade}</td>
                <td className="text-center">{item.produto?.unidadeMedida || "UN"}</td>
                <td className="text-right">{fmtUsd(item.valorFobUnitario)}</td>
                <td className="text-right">{fmtBrl(item.itemValorAduaneiro)}</td>
                <td className="text-right">{fmtBrl(item.ii)}</td>
                <td className="text-right">{fmtBrl(item.ipi)}</td>
                <td className="text-right">{fmtBrl(item.pisCofins)}</td>
                <td className="text-right">{fmtBrl(item.taxasPort)}</td>
                <td className="text-right">{fmtBrl(item.icms)}</td>
                <td className="text-right bold">{fmtBrl(item.totalNacItem)}</td>
                <td className="text-right bold" style={{ background: "rgba(16, 185, 129, 0.05)" }}>{fmtBrl(item.custoUnitarioNacionalizado)}</td>
              </tr>
            ))}
            <tr className="bold" style={{ background: "rgba(255, 255, 255, 0.03)" }}>
              <td>TOTAIS / MÉDIAS</td>
              <td className="text-center">-</td>
              <td className="text-center">{totalQuantidade}</td>
              <td className="text-center">-</td>
              <td className="text-right">{fmtUsd(totalFobUSD / (totalQuantidade || 1))}</td>
              <td className="text-right">{fmtBrl(totalFobBrl + freteBrl + seguroBrl)}</td>
              <td className="text-right">{fmtBrl(totalII)}</td>
              <td className="text-right">{fmtBrl(totalIPI)}</td>
              <td className="text-right">{fmtBrl(totalPisCofins)}</td>
              <td className="text-right">{fmtBrl(totalDespesasPortuariasSemFreteBrl)}</td>
              <td className="text-right">{fmtBrl(totalIcms)}</td>
              <td className="text-right bold">{fmtBrl(totalGeralNacionalizado)}</td>
              <td className="text-right bold">{fmtBrl(totalGeralNacionalizado / (totalQuantidade || 1))}</td>
            </tr>
          </tbody>
        </table>

        {/* Configurações do Estudo */}
        <div style={{ marginTop: "30px", fontSize: "0.8rem", color: "#64748b", display: "grid", gridTemplateColumns: "1fr 1fr", gap: "20px" }}>
          <div>
            <strong>Parâmetros de Simulação:</strong>
            <div>Método de Cálculo ICMS: {estudo.metodoCalculoIcms === "SimplificadoExcel" ? "Simplificado (Excel)" : "Por Dentro (Legal)"}</div>
            <div>Método de Cálculo Federais: {estudo.metodoCalculoFederais === "SimplificadoExcel" ? "Simplificado (Excel)" : "Cascata Real"}</div>
            {estudo.flSimularSubfaturamento && (
              <div>Subfaturamento Simulado: {estudo.percentualSubfaturamento?.toLocaleString("pt-BR", { minimumFractionDigits: 0, maximumFractionDigits: 2 })}%</div>
            )}
          </div>
          <div style={{ textAlign: "right", display: "flex", flexDirection: "column", alignItems: "flex-end", justifyContent: "flex-end", paddingBottom: "5px" }}>
            <div className="simulation-warning-text">
              * ESTE DOCUMENTO TRATA-SE DE UMA SIMULAÇÃO PRELIMINAR DE CUSTOS E TRIBUTOS. OS VALORES APRESENTADOS SÃO ESTIMATIVOS E PODEM SOFRER ALTERAÇÕES DE ACORDO COM A OSCILAÇÃO CAMBIAL, LEGISLAÇÃO FISCAL OU VARIAÇÕES OPERACIONAIS NA DATA DO DESEMBARAÇO EFETIVO.
            </div>
            <div className="commission-warning-text">
              * FAVOR NOTAR QUE A ESTIMATIVA DE CUSTOS NÃO CONTEMPLA VALORES DE COMISSÃO, POIS ELES VARIAM CONFORME CONTRATO.
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
