
import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { 
  ArrowLeft, Printer, FileText, Download, 
  Calculator, Info, ShieldCheck, Ship, 
  TrendingUp, DollarSign, Package, CheckCircle2
} from 'lucide-react';

const DetalheEstudoEdcPage: React.FC = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const [estudo, setEstudo] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchEstudo = async () => {
      try {
        const response = await fetch(`/api/edc/simulacoes/${id}`);
        const data = await response.json();
        
        const previewRes = await fetch('/api/edc/simulacoes/preview', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(data)
        });
        const calculatedData = await previewRes.json();
        setEstudo(calculatedData);
      } catch (error) { console.error(error); } 
      finally { setLoading(false); }
    };
    fetchEstudo();
  }, [id]);

  if (loading) return <div className="page-container animate-pulse">Calculando impostos e taxas...</div>;
  if (!estudo) return <div className="page-container">Estudo não localizado.</div>;

  const ptaxFator = 1 + (estudo.spreadCambio / 100);
  const freteBrl = (estudo.valorFreteInternacional * ptaxFator) * estudo.cotacaoDolar;
  const seguroBrl = estudo.valorSeguroInternacional * estudo.cotacaoDolar;
  
  // Calcular despesas aduaneiras dinamicamente
  const despesasDetalhadas = estudo.despesas ? estudo.despesas.map((d: any) => {
    const isAfrmm = d.nomeDespesa.toUpperCase() === 'AFRMM';
    let valorBrl = 0;
    let detalheTipo = 'Fixo';

    if (isAfrmm) {
      const percentual = d.valor > 1 ? d.valor : d.valor * 100;
      detalheTipo = `${percentual.toLocaleString("pt-BR", { minimumFractionDigits: 0, maximumFractionDigits: 2 })}%`;
      valorBrl = freteBrl * (percentual / 100);
    } else {
      valorBrl = d.moeda === 'USD' ? d.valor * estudo.cotacaoDolar : d.valor;
    }

    return {
      nomeDespesa: d.nomeDespesa,
      moeda: d.moeda,
      detalheTipo,
      valorBrl,
      isAfrmm,
      metodoRateio: d.metodoRateio
    };
  }) : [];

  const totalDespesasPortuariasBrl = despesasDetalhadas.reduce((acc: number, d: any) => acc + d.valorBrl, 0);

  // Calcular itens com rateio de frete e despesas
  const totalFobBrl = estudo.itens.reduce((acc: number, i: any) => acc + (i.quantidade * i.valorFobUnitario), 0) * estudo.cotacaoDolar;

  // Se ativado no estudo, acrescentar a comissão comercial na visualização da tabela de despesas
  const comissaoValBrl = (estudo.flExibirComissao && estudo.comissaoPercentual > 0)
    ? totalFobBrl * (estudo.comissaoPercentual / 100)
    : 0;

  if (estudo.flExibirComissao && estudo.comissaoPercentual > 0) {
    despesasDetalhadas.push({
      nomeDespesa: `COMISSÃO COMERCIAL (${estudo.comissaoPercentual.toLocaleString("pt-BR", { minimumFractionDigits: 0, maximumFractionDigits: 2 })}%)`,
      moeda: 'USD',
      detalheTipo: 'Percentual',
      valorBrl: comissaoValBrl,
      isAfrmm: false
    });
  }

  const totalDespesasBrl = despesasDetalhadas.reduce((acc: number, d: any) => acc + d.valorBrl, 0);

  const totalQuantidade = estudo.itens.reduce((acc: number, i: any) => acc + i.quantidade, 0);
  const totalPeso = estudo.itens.reduce((acc: number, i: any) => acc + (i.pesoLiquidoTotal > 0 ? i.pesoLiquidoTotal : ((i.produto?.pesoLiquido * i.quantidade) || 0)), 0);
  const totalVolume = estudo.itens.reduce((acc: number, i: any) => acc + (i.cubagemTotal > 0 ? i.cubagemTotal : ((i.produto?.cubagemM3 * i.quantidade) || 0)), 0);

  const itensCalculados = estudo.itens.map((item: any) => {
    const itemFobBrl = item.quantidade * item.valorFobUnitario * estudo.cotacaoDolar;
    const fatorRateio = totalFobBrl > 0 ? itemFobBrl / totalFobBrl : 0;
    
    // Valor Aduaneiro com FOB Cheio
    const itemValorAduaneiroCheio = itemFobBrl + (freteBrl * fatorRateio) + (seguroBrl * fatorRateio);
    
    // Determina o FOB Subfaturado
    const valorFobUnitarioSub = item.valorFobSubfaturado !== null && item.valorFobSubfaturado !== undefined
      ? item.valorFobSubfaturado
      : (estudo.flSimularSubfaturamento 
          ? (item.valorFobUnitario * (estudo.percentualSubfaturamento / 100)) 
          : item.valorFobUnitario);
          
    const itemFobSubBrl = item.quantidade * valorFobUnitarioSub * estudo.cotacaoDolar;
    
    // Base de cálculo aduaneiro para impostos
    const baseCalculoAduaneiro = estudo.flSimularSubfaturamento
      ? (itemFobSubBrl + (freteBrl * fatorRateio) + (seguroBrl * fatorRateio))
      : itemValorAduaneiroCheio;
    
    const aliqII = item.produto?.ncm?.aliquotaII || 0;
    const aliqIPI = item.produto?.ncm?.aliquotaIPI || 0;
    const aliqPis = item.produto?.ncm?.aliquotaPis || 0;
    const aliqCof = item.produto?.ncm?.aliquotaCofins || 0;
    let aliqIcms = 0.18;
    if (item.produto?.ncm) {
      aliqIcms = item.produto.ncm.aliquotaIcmsPadrao;
    } else if (estudo.importador) {
      aliqIcms = estudo.importador.aliquotaIcmsPadrao;
    }

    const ii = baseCalculoAduaneiro * aliqII;
    const ipi = (baseCalculoAduaneiro + ii) * aliqIPI;
    
    let pisCofins = 0;
    if (estudo.metodoCalculoFederais === 'SimplificadoExcel') {
      pisCofins = (baseCalculoAduaneiro + ii) * (aliqPis + aliqCof);
    } else {
      pisCofins = baseCalculoAduaneiro * (aliqPis + aliqCof);
    }

    // Rateio avançado de taxas portuárias por item
    let taxasPort = 0;
    if (despesasDetalhadas) {
      despesasDetalhadas.forEach((d: any) => {
        // Ignorar frete internacional
        if (d.nomeDespesa.toUpperCase() === 'FRETE') return;

        const valorDespesaBrl = d.valorBrl;

        let fatorDespesa = 0;
        if (d.metodoRateio === 'Quantidade') {
          fatorDespesa = totalQuantidade > 0 ? item.quantidade / totalQuantidade : 0;
        } else if (d.metodoRateio === 'Peso') {
          const itemPeso = item.pesoLiquidoTotal > 0 ? item.pesoLiquidoTotal : ((item.produto?.pesoLiquido * item.quantidade) || 0);
          fatorDespesa = totalPeso > 0 ? itemPeso / totalPeso : 0;
        } else if (d.metodoRateio === 'Volume') {
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
    if (estudo.metodoCalculoIcms === 'SimplificadoExcel') {
      icms = baseCalculoAduaneiro * aliqIcms;
    } else {
      const baseIcmsSemIcms = baseCalculoAduaneiro + ii + ipi + pisCofins + taxasPort;
      icms = baseIcmsSemIcms / (1 - aliqIcms) * aliqIcms;
    }
    
    // O custo final real do item nacionalizado é baseado no aduaneiro cheio + impostos declarados
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
      totalNacItem
    };
  });

  const totalII = itensCalculados.reduce((acc: number, i: any) => acc + i.ii, 0);
  const totalIPI = itensCalculados.reduce((acc: number, i: any) => acc + i.ipi, 0);
  const totalPisCofins = itensCalculados.reduce((acc: number, i: any) => acc + i.pisCofins, 0);
  const totalIcms = itensCalculados.reduce((acc: number, i: any) => acc + i.icms, 0);
  const totalNacionalizado = itensCalculados.reduce((acc: number, i: any) => acc + i.totalNacItem, 0);

  const handleExportExcel = async () => {
    try {
      const apiBase = (import.meta.env.VITE_API_BASE ?? "http://localhost:5000").replace(/\/+$/, "");
      const response = await fetch(`${apiBase}/api/edc/simulacoes/${id}/excel`);
      if (!response.ok) {
        throw new Error("Erro ao exportar Excel");
      }
      const blob = await response.blob();
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement("a");
      a.href = url;
      a.download = `EDC_${estudo?.numeroReferencia || id}.xlsx`;
      document.body.appendChild(a);
      a.click();
      a.remove();
    } catch (error) {
      console.error(error);
      alert("Falha ao exportar o arquivo Excel.");
    }
  };

  return (
    <div className="animate-fadeIn">
      <div className="page-header">
        <button className="btn-icon" onClick={() => navigate('/edc/estudos')} style={{ marginRight: '16px' }}><ArrowLeft size={20} /></button>
        <div className="page-header-icon" style={{ background: 'rgba(16, 185, 129, 0.1)', color: '#10b981' }}>
          <CheckCircle2 size={24} />
        </div>
        <div>
          <h1 className="page-title">Relatório de Nacionalização</h1>
          <p className="page-description">Análise detalhada de custos e carga tributária do estudo {estudo.numeroReferencia}.</p>
        </div>
        <div className="page-header-line" style={{ background: 'linear-gradient(90deg, #10b981, transparent)' }}></div>
        <div className="action-buttons" style={{ marginLeft: 'auto', display: 'flex', gap: '10px' }}>
          <button className="btn btn-secondary" onClick={() => window.open(`/#/print-edc/${id}?color=true`, '_blank')} style={{ borderColor: '#7c3aed', color: '#a78bfa' }}>
            <FileText size={18} />
            <span>PDF Colorido</span>
          </button>
          <button className="btn btn-secondary" onClick={() => window.open(`/#/print-edc/${id}`, '_blank')}>
            <Printer size={18} />
            <span>Imprimir</span>
          </button>
          <button className="btn btn-primary" onClick={handleExportExcel}>
            <Download size={18} />
            <span>Exportar EDC</span>
          </button>
        </div>
      </div>

      <div className="grid grid-3" style={{ marginBottom: '2rem' }}>
        <div className="card" style={{ borderLeft: '4px solid #4f9eff' }}>
          <span style={{ fontSize: '0.75rem', textTransform: 'uppercase', color: 'var(--muted)', letterSpacing: '1px' }}>Importador</span>
          <p style={{ fontWeight: '700', fontSize: '1.2rem', margin: '8px 0 0' }}>{estudo.importador?.razaoSocial}</p>
          <span style={{ fontSize: '0.8rem', opacity: 0.6 }}>CNPJ: {estudo.importador?.cnpj}</span>
        </div>
        <div className="card" style={{ borderLeft: '4px solid #a78bfa' }}>
          <span style={{ fontSize: '0.75rem', textTransform: 'uppercase', color: 'var(--muted)', letterSpacing: '1px' }}>Exportador</span>
          <p style={{ fontWeight: '700', fontSize: '1.2rem', margin: '8px 0 0' }}>{estudo.exportador?.nome}</p>
          <span style={{ fontSize: '0.8rem', opacity: 0.6 }}>País: {estudo.exportador?.pais} | Incoterm: {estudo.tipoFrete || 'N/A'} | Frete: {estudo.modalidadeFrete || '1x40'}</span>
        </div>
        <div className="card" style={{ background: 'linear-gradient(135deg, rgba(79, 158, 255, 0.05) 0%, rgba(59, 130, 246, 0.05) 100%)', border: '1px solid rgba(79, 158, 255, 0.2)' }}>
          <span style={{ fontSize: '0.75rem', textTransform: 'uppercase', color: 'var(--muted)', letterSpacing: '1px' }}>Custo Total Nacionalizado</span>
          <p style={{ fontWeight: '800', fontSize: '1.8rem', margin: '8px 0 0', color: 'var(--primary)' }}>
            R$ {totalNacionalizado.toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
          </p>
          <div style={{ fontSize: '0.8rem', opacity: 0.8, marginTop: '4px', display: 'flex', flexDirection: 'column', gap: '2px' }}>
            <span>Câmbio: R$ {estudo.cotacaoDolar.toFixed(2)} | PTAX: {estudo.spreadCambio?.toLocaleString("pt-BR", { minimumFractionDigits: 0, maximumFractionDigits: 2 })}%</span>
            {estudo.flSimularSubfaturamento && (
              <span style={{ color: '#a78bfa', fontWeight: '600' }}>
                ⚡ Subfaturamento: {estudo.percentualSubfaturamento?.toLocaleString("pt-BR", { minimumFractionDigits: 0, maximumFractionDigits: 2 })}% Ativo
              </span>
            )}
            <span style={{ fontSize: '0.7rem', color: 'var(--muted)' }}>
              ICMS: {estudo.metodoCalculoIcms === 'SimplificadoExcel' ? 'Excel' : 'Legal'} | 
              Federais: {estudo.metodoCalculoFederais === 'SimplificadoExcel' ? 'Excel' : 'Legal'}
            </span>
          </div>
        </div>
      </div>

      <div className="card" style={{ padding: '0', overflow: 'hidden' }}>
        <div className="card-header" style={{ padding: '24px', marginBottom: '0' }}>
          <h3 className="card-title">Memória de Cálculo por Item</h3>
        </div>
        <div className="table-responsive">
          <table className="table">
            <thead style={{ background: 'rgba(255,255,255,0.02)' }}>
              <tr>
                <th style={{ paddingLeft: '24px' }}>Item / NCM</th>
                <th>V. Aduaneiro</th>
                <th>II</th>
                <th>IPI</th>
                <th>PIS/COF</th>
                <th>Taxas Port.</th>
                <th style={{ color: 'var(--primary)' }}>ICMS</th>
                <th style={{ textAlign: 'right' }}>Unit. Nac.</th>
                <th style={{ paddingRight: '24px', textAlign: 'right' }}>Total Nac.</th>
              </tr>
            </thead>
            <tbody>
              {itensCalculados.map((item: any, idx: number) => (
                <tr key={idx}>
                  <td style={{ paddingLeft: '24px' }}>
                    <div style={{ display: 'flex', gap: '12px', alignItems: 'center' }}>
                      <div style={{ padding: '8px', background: 'rgba(255,255,255,0.05)', borderRadius: '8px' }}>
                        <Package size={18} style={{ color: 'var(--muted)' }} />
                      </div>
                      <div>
                        <strong style={{ display: 'block', color: '#fff' }}>
                          {item.modelo ? `${item.modelo.codigo} - ${item.modelo.nome}` : item.produto?.referencia}
                        </strong>
                        {item.modelo && (
                          <span style={{ fontSize: '0.75rem', color: 'var(--muted)', display: 'block' }}>
                            Ref: {item.produto?.referencia} - {item.produto?.descricao}
                          </span>
                        )}
                        <span style={{ fontSize: '0.75rem', color: 'var(--muted)' }}>NCM: {item.produto?.ncm?.codigo}</span>
                      </div>
                    </div>
                  </td>
                  <td>R$ {item.itemValorAduaneiro.toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</td>
                  <td>R$ {item.ii.toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</td>
                  <td>R$ {item.ipi.toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</td>
                  <td>R$ {item.pisCofins.toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</td>
                  <td>R$ {item.taxasPort.toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</td>
                  <td style={{ color: 'var(--primary)', fontWeight: '600' }}>R$ {item.icms.toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</td>
                  <td style={{ textAlign: 'right', fontWeight: '600', color: '#fff' }}>
                    R$ {(item.quantidade > 0 ? item.totalNacItem / item.quantidade : 0).toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                  </td>
                  <td style={{ paddingRight: '24px', textAlign: 'right' }}>
                    <strong style={{ color: '#fff' }}>R$ {item.totalNacItem.toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</strong>
                  </td>
                </tr>
              ))}
            </tbody>
            <tfoot style={{ background: 'rgba(79, 158, 255, 0.05)' }}>
               <tr>
                 <td colSpan={8} style={{ padding: '24px', textAlign: 'right', fontWeight: '700', fontSize: '1.1rem', color: 'var(--muted)' }}>
                    VALOR FINAL DA IMPORTAÇÃO:
                 </td>
                 <td style={{ padding: '24px', textAlign: 'right', fontSize: '1.4rem', fontWeight: '800', color: 'var(--primary)' }}>
                    R$ {totalNacionalizado.toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                 </td>
               </tr>
            </tfoot>
          </table>
        </div>
      </div>

      {/* Seção 2: Despesas Aduaneiras e Logísticas (Planilha do Usuário) */}
      <div className="card" style={{ padding: '0', overflow: 'hidden', marginTop: '2rem' }}>
        <div className="card-header" style={{ padding: '24px', marginBottom: '0' }}>
          <h3 className="card-title">Despesas Aduaneiras e Logísticas</h3>
        </div>
        <div className="table-responsive">
          <table className="table">
            <thead style={{ background: 'rgba(255,255,255,0.02)' }}>
              <tr>
                <th style={{ paddingLeft: '24px' }}>Descrição da Despesa</th>
                <th>Tipo/Percentual</th>
                <th>Moeda Origem</th>
                <th style={{ paddingRight: '24px', textAlign: 'right' }}>Valor (R$)</th>
              </tr>
            </thead>
            <tbody>
              {despesasDetalhadas.map((despesa: any, idx: number) => (
                <tr key={idx}>
                  <td style={{ paddingLeft: '24px', fontWeight: '600', color: '#fff' }}>{despesa.nomeDespesa}</td>
                  <td>
                    <span className="badge" style={{ 
                      backgroundColor: despesa.isAfrmm ? 'rgba(245, 158, 11, 0.15)' : 'rgba(255,255,255,0.05)', 
                      color: despesa.isAfrmm ? '#fbbf24' : 'var(--muted)',
                      borderColor: despesa.isAfrmm ? 'rgba(245, 158, 11, 0.25)' : 'rgba(255,255,255,0.1)'
                    }}>
                      {despesa.detalheTipo}
                    </span>
                  </td>
                  <td>{despesa.moeda}</td>
                  <td style={{ paddingRight: '24px', textAlign: 'right', fontWeight: '700', color: '#fff' }}>
                    R$ {despesa.valorBrl.toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                  </td>
                </tr>
              ))}
            </tbody>
            <tfoot style={{ background: 'rgba(79, 158, 255, 0.02)' }}>
               <tr>
                 <td colSpan={3} style={{ padding: '20px 24px', textAlign: 'right', fontWeight: '700', color: 'var(--muted)' }}>
                    TOTAL DESPESAS ADUANEIRAS E LOGÍSTICAS:
                 </td>
                 <td style={{ padding: '20px 24px', textAlign: 'right', fontSize: '1.2rem', fontWeight: '800', color: '#fff' }}>
                    R$ {totalDespesasBrl.toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                 </td>
               </tr>
            </tfoot>
          </table>
        </div>
      </div>

      <div className="grid grid-2" style={{ marginTop: '2rem' }}>
        <div className="card" style={{ background: 'rgba(37, 99, 235, 0.03)', borderStyle: 'dashed' }}>
          <div style={{ display: 'flex', gap: '16px' }}>
            <div className="page-header-icon" style={{ background: 'rgba(37, 99, 235, 0.1)', flexShrink: 0 }}>
              <TrendingUp size={20} />
            </div>
            <div>
              <h4 style={{ margin: '0 0 8px 0', color: '#fff' }}>Resumo de Carga Tributária</h4>
              <p style={{ fontSize: '0.9rem', color: 'var(--muted)', margin: '0' }}>
                Total de Impostos Federais: R$ {(totalII + totalIPI + totalPisCofins).toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 })} ({( ((totalII + totalIPI + totalPisCofins) / totalNacionalizado) * 100 ).toFixed(1)}% do total)<br/>
                Total de Impostos Estaduais (ICMS): R$ {totalIcms.toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 })} ({( (totalIcms / totalNacionalizado) * 100 ).toFixed(1)}% do total)
              </p>
            </div>
          </div>
        </div>
        <div className="card" style={{ background: 'rgba(16, 185, 129, 0.03)', borderStyle: 'dashed' }}>
          <div style={{ display: 'flex', gap: '16px' }}>
            <div className="page-header-icon" style={{ background: 'rgba(16, 185, 129, 0.1)', flexShrink: 0 }}>
              <ShieldCheck size={20} />
            </div>
            <div>
              <h4 style={{ margin: '0 0 8px 0', color: '#fff' }}>Conformidade Fiscal</h4>
              <p style={{ fontSize: '0.9rem', color: 'var(--muted)', margin: '0' }}>
                Este estudo foi gerado com base nas alíquotas vigentes na data de hoje ({new Date().toLocaleDateString()}) para o estado de {estudo.importador?.uf || 'PR'}.
              </p>
            </div>
          </div>
        </div>
      </div>

      {/* Seção Informativa: Fórmulas de Cálculo */}
      <div className="card" style={{ marginTop: '2rem', background: 'rgba(255,255,255,0.01)', border: '1px solid rgba(255,255,255,0.05)' }}>
        <div style={{ display: 'flex', gap: '16px', alignItems: 'flex-start' }}>
          <div className="page-header-icon" style={{ background: 'rgba(245, 158, 11, 0.1)', color: '#f59e0b', flexShrink: 0 }}>
            <Calculator size={20} />
          </div>
          <div style={{ flexGrow: 1 }}>
            <h4 style={{ margin: '0 0 12px 0', color: '#fff', fontSize: '1.1rem' }}>Como são calculados os valores?</h4>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '24px', fontSize: '0.85rem', color: 'var(--muted)', lineHeight: '1.6' }}>
              <div>
                <strong style={{ color: '#fff', display: 'block', marginBottom: '4px' }}>Base Aduaneira e Rateio:</strong>
                O valor de <strong>Frete c/ PTAX</strong> e <strong>Seguro</strong> é rateado proporcionalmente ao valor FOB de cada item do estudo.
                <div style={{ marginTop: '12px' }}>
                  <strong style={{ color: '#fff', display: 'block', marginBottom: '4px' }}>Imposto de Importação (II):</strong>
                  <code>Valor II = Base Aduaneira × Alíquota II</code>
                </div>
                <div style={{ marginTop: '12px' }}>
                  <strong style={{ color: '#fff', display: 'block', marginBottom: '4px' }}>IPI (Imposto sobre Produto Industrializado):</strong>
                  <code>Valor IPI = (Base Aduaneira + II) × Alíquota IPI</code>
                </div>
              </div>
              <div>
                <strong style={{ color: '#fff', display: 'block', marginBottom: '4px' }}>PIS & COFINS:</strong>
                {estudo.metodoCalculoFederais === 'SimplificadoExcel' ? (
                  <span>
                    <strong>Método Simplificado (Excel) ativo:</strong><br/>
                    <code>Base PIS/COF = (Base Aduaneira + II) × Alíquota</code>
                  </span>
                ) : (
                  <span>
                    <strong>Método Legal (Cascata Real) ativo:</strong><br/>
                    <code>Base PIS/COF = Base Aduaneira × Alíquota</code>
                  </span>
                )}
                <div style={{ marginTop: '12px' }}>
                  <strong style={{ color: '#fff', display: 'block', marginBottom: '4px' }}>ICMS (Cálculo por Dentro):</strong>
                  {estudo.metodoCalculoIcms === 'SimplificadoExcel' ? (
                    <span>
                      <strong>Método Simplificado (Excel) ativo:</strong><br/>
                      <code>Valor ICMS = Base Aduaneira × Alíquota ICMS</code>
                    </span>
                  ) : (
                    <span>
                      <strong>Método Legal (Cálculo por Dentro) ativo:</strong><br/>
                      <code>Base ICMS = (Base Aduaneira + II + IPI + PIS + COFINS + Taxas Port.) ÷ (1 - Alíquota ICMS)</code><br/>
                      <code>Valor ICMS = Base ICMS × Alíquota ICMS</code>
                    </span>
                  )}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default DetalheEstudoEdcPage;
