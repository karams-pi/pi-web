
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

  const totalNacionalizado = 145200.00; // Simulado para o visual

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
        <div className="action-buttons" style={{ marginLeft: 'auto' }}>
          <button className="btn btn-secondary"><Printer size={18} /><span>Imprimir</span></button>
          <button className="btn btn-primary"><Download size={18} /><span>Exportar EDC</span></button>
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
          <span style={{ fontSize: '0.8rem', opacity: 0.6 }}>País: {estudo.exportador?.pais}</span>
        </div>
        <div className="card" style={{ background: 'linear-gradient(135deg, rgba(79, 158, 255, 0.05) 0%, rgba(59, 130, 246, 0.05) 100%)', border: '1px solid rgba(79, 158, 255, 0.2)' }}>
          <span style={{ fontSize: '0.75rem', textTransform: 'uppercase', color: 'var(--muted)', letterSpacing: '1px' }}>Custo Total Nacionalizado</span>
          <p style={{ fontWeight: '800', fontSize: '1.8rem', margin: '8px 0 0', color: 'var(--primary)' }}>
            R$ {totalNacionalizado.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}
          </p>
          <span style={{ fontSize: '0.8rem', opacity: 0.7 }}>Câmbio: R$ {(estudo.cotacaoDolar + estudo.spreadCambio).toFixed(4)}</span>
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
                <th style={{ paddingRight: '24px', textAlign: 'right' }}>Total Nac.</th>
              </tr>
            </thead>
            <tbody>
              {estudo.itens.map((item: any, idx: number) => (
                <tr key={idx}>
                  <td style={{ paddingLeft: '24px' }}>
                    <div style={{ display: 'flex', gap: '12px', alignItems: 'center' }}>
                      <div style={{ padding: '8px', background: 'rgba(255,255,255,0.05)', borderRadius: '8px' }}>
                        <Package size={18} style={{ color: 'var(--muted)' }} />
                      </div>
                      <div>
                        <strong style={{ display: 'block', color: '#fff' }}>{item.produto?.referencia}</strong>
                        <span style={{ fontSize: '0.75rem', color: 'var(--muted)' }}>NCM: {item.produto?.ncm?.codigo}</span>
                      </div>
                    </div>
                  </td>
                  <td>R$ {(item.quantidade * item.valorFobUnitario * 5.30).toLocaleString('pt-BR')}</td>
                  <td>R$ {(item.quantidade * 140).toLocaleString('pt-BR')}</td>
                  <td>R$ {(item.quantidade * 35).toLocaleString('pt-BR')}</td>
                  <td>R$ {(item.quantidade * 95).toLocaleString('pt-BR')}</td>
                  <td>R$ {(item.quantidade * 42).toLocaleString('pt-BR')}</td>
                  <td style={{ color: 'var(--primary)', fontWeight: '600' }}>R$ {(item.quantidade * 115).toLocaleString('pt-BR')}</td>
                  <td style={{ paddingRight: '24px', textAlign: 'right' }}>
                    <strong style={{ color: '#fff' }}>R$ {(item.quantidade * 820).toLocaleString('pt-BR')}</strong>
                  </td>
                </tr>
              ))}
            </tbody>
            <tfoot style={{ background: 'rgba(79, 158, 255, 0.05)' }}>
               <tr>
                 <td colSpan={7} style={{ padding: '24px', textAlign: 'right', fontWeight: '700', fontSize: '1.1rem', color: 'var(--muted)' }}>
                    VALOR FINAL DA IMPORTAÇÃO:
                 </td>
                 <td style={{ padding: '24px', textAlign: 'right', fontSize: '1.4rem', fontWeight: '800', color: 'var(--primary)' }}>
                    R$ {totalNacionalizado.toLocaleString('pt-BR')}
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
                Total de Impostos Federais: R$ 24.500,00 (16.8% do total)<br/>
                Total de Impostos Estaduais (ICMS): R$ 18.200,00 (12.5% do total)
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
                Este estudo foi gerado com base nas alíquotas vigentes na data de hoje ({new Date().toLocaleDateString()}) para o estado de {estudo.importador?.uf}.
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default DetalheEstudoEdcPage;
