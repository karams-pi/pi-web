
import React, { useState, useEffect } from 'react';
import { 
  Calculator, Save, X, Plus, Trash2, 
  ArrowLeft, Building, Globe, Ship, 
  DollarSign, Percent, TrendingUp, Info, Package, Anchor
} from 'lucide-react';
import { useNavigate } from 'react-router-dom';

const NovoEstudoEdcPage: React.FC = () => {
  const navigate = useNavigate();
  
  const [importadores, setImportadores] = useState<any[]>([]);
  const [exportadores, setExportadores] = useState<any[]>([]);
  const [portos, setPortos] = useState<any[]>([]);
  const [produtos, setProdutos] = useState<any[]>([]);
  const [taxasPadrao, setTaxasPadrao] = useState<any[]>([]);

  const [formData, setFormData] = useState({
    numeroReferencia: `EDC-${new Date().getFullYear()}-${Math.floor(1000 + Math.random() * 9000)}`,
    idImportador: 0,
    idExportador: 0,
    idPortoOrigem: 0,
    idPortoDestino: 0,
    cotacaoDolar: 5.25,
    spreadCambio: 0.05,
    tipoFrete: 'FOB',
    valorFreteInternacional: 0,
    valorSeguroInternacional: 0,
    status: 'Rascunho',
    itens: [] as any[],
    despesas: [] as any[]
  });

  useEffect(() => {
    const loadData = async () => {
      try {
        const [imp, exp, por, pro, tax] = await Promise.all([
          fetch('/api/edc/importadores').then(r => r.json()),
          fetch('/api/edc/exportadores').then(r => r.json()),
          fetch('/api/edc/portos').then(r => r.json()),
          fetch('/api/edc/produtos').then(r => r.json()),
          fetch('/api/edc/taxasaduaneiras').then(r => r.json())
        ]);
        setImportadores(imp);
        setExportadores(exp);
        setPortos(por);
        setProdutos(pro);
        setTaxasPadrao(tax);
        
        if (tax.length > 0) {
          setFormData(prev => ({
            ...prev,
            despesas: tax.map((t: any) => ({
              nomeDespesa: t.nome,
              valor: t.valorPadrao,
              moeda: t.moeda,
              metodoRateio: 'Valor FOB'
            }))
          }));
        }
      } catch (error) { console.error(error); }
    };
    loadData();
  }, []);

  const handleAddItem = () => {
    setFormData({
      ...formData,
      itens: [...formData.itens, { idProduto: produtos[0]?.id || 0, quantidade: 1, valorFobUnitario: 0 }]
    });
  };

  const handleRemoveItem = (index: number) => {
    const newItens = [...formData.itens];
    newItens.splice(index, 1);
    setFormData({ ...formData, itens: newItens });
  };

  const updateItem = (index: number, field: string, value: any) => {
    const newItens = [...formData.itens];
    newItens[index][field] = value;
    setFormData({ ...formData, itens: newItens });
  };

  const handleSave = async () => {
    try {
      const response = await fetch('/api/edc/simulacoes', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData)
      });
      if (response.ok) navigate('/edc/estudos');
    } catch (error) { console.error(error); }
  };

  const totalFob = formData.itens.reduce((acc, i) => acc + (i.quantidade * i.valorFobUnitario), 0);
  const cotacaoFinal = formData.cotacaoDolar + formData.spreadCambio;

  return (
    <div className="animate-fadeIn">
      <div className="page-header">
        <button className="btn-icon" onClick={() => navigate('/edc/estudos')} style={{ marginRight: '16px' }}><ArrowLeft size={20} /></button>
        <div className="page-header-icon" style={{ background: 'rgba(79, 158, 255, 0.1)', color: '#4f9eff' }}>
          <Calculator size={24} />
        </div>
        <div>
          <h1 className="page-title">Nova Simulação de Custo</h1>
          <p className="page-description">Configure os parâmetros logísticos e fiscais para o Estudo de Nacionalização.</p>
        </div>
        <div className="page-header-line"></div>
      </div>

      <div className="grid" style={{ gridTemplateColumns: '1fr 380px', gap: '2rem', alignItems: 'start' }}>
        <div className="form-sections" style={{ display: 'flex', flexDirection: 'column', gap: '1.5rem' }}>
          {/* Seção 1: Identificação */}
          <div className="card">
            <div className="card-header"><h3 className="card-title">1. Identificação do Estudo</h3></div>
            <div className="grid grid-2">
              <div className="form-group" style={{ gridColumn: 'span 2' }}>
                <label>Referência Interna</label>
                <input type="text" className="premium-input" value={formData.numeroReferencia} onChange={e => setFormData({...formData, numeroReferencia: e.target.value})} />
              </div>
              <div className="form-group">
                <label>Importador (Comprador)</label>
                <div className="input-with-icon">
                   <Building size={16} />
                   <select value={formData.idImportador} onChange={e => setFormData({...formData, idImportador: parseInt(e.target.value)})}>
                    <option value="0">Selecione o Cliente...</option>
                    {importadores.map(i => <option key={i.id} value={i.id}>{i.razaoSocial}</option>)}
                  </select>
                </div>
              </div>
              <div className="form-group">
                <label>Exportador (Fornecedor)</label>
                <div className="input-with-icon">
                   <Globe size={16} />
                   <select value={formData.idExportador} onChange={e => setFormData({...formData, idExportador: parseInt(e.target.value)})}>
                    <option value="0">Selecione o Fornecedor...</option>
                    {exportadores.map(e => <option key={e.id} value={e.id}>{e.nome}</option>)}
                  </select>
                </div>
              </div>
            </div>
          </div>

          {/* Seção 2: Itens */}
          <div className="card">
            <div className="card-header">
              <h3 className="card-title">2. Itens da Proforma</h3>
              <button className="btn btn-secondary" onClick={handleAddItem}><Plus size={16} /> Adicionar Produto</button>
            </div>
            <div className="table-responsive">
              <table className="table">
                <thead>
                  <tr>
                    <th>Produto / Referência</th>
                    <th style={{ width: '120px' }}>Quantidade</th>
                    <th style={{ width: '160px' }}>FOB Unit. (USD)</th>
                    <th style={{ width: '50px' }}></th>
                  </tr>
                </thead>
                <tbody>
                  {formData.itens.length === 0 ? (
                    <tr><td colSpan={4} style={{ textAlign: 'center', opacity: 0.5, padding: '30px' }}>Nenhum item adicionado.</td></tr>
                  ) : formData.itens.map((item, idx) => (
                    <tr key={idx}>
                      <td>
                        <select className="premium-select" value={item.idProduto} onChange={e => updateItem(idx, 'idProduto', parseInt(e.target.value))}>
                          {produtos.map(p => <option key={p.id} value={p.id}>{p.referencia} - {p.descricao}</option>)}
                        </select>
                      </td>
                      <td><input type="number" value={item.quantidade} onChange={e => updateItem(idx, 'quantidade', parseFloat(e.target.value))} /></td>
                      <td>
                        <div className="input-with-icon">
                          <DollarSign size={14} />
                          <input type="number" step="0.01" value={item.valorFobUnitario} onChange={e => updateItem(idx, 'valorFobUnitario', parseFloat(e.target.value))} />
                        </div>
                      </td>
                      <td><button className="btn-icon btn-icon-danger" onClick={() => handleRemoveItem(idx)}><Trash2 size={16} /></button></td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>

        {/* Sidebar Fixa de Resumo e Ações */}
        <div className="sidebar-form" style={{ position: 'sticky', top: '24px', display: 'flex', flexDirection: 'column', gap: '1.5rem' }}>
          <div className="card" style={{ background: 'linear-gradient(145deg, #1e293b 0%, #0f172a 100%)', border: '1px solid #334155' }}>
            <div className="card-header"><h3 className="card-title" style={{ color: 'var(--primary)' }}>Logística & Câmbio</h3></div>
            <div className="form-stack">
              <div className="form-group">
                <label>Câmbio PTAX (USD)</label>
                <div className="input-with-icon">
                   <TrendingUp size={16} />
                   <input type="number" step="0.0001" value={formData.cotacaoDolar} onChange={e => setFormData({...formData, cotacaoDolar: parseFloat(e.target.value)})} />
                </div>
              </div>
              <div className="form-group">
                <label>Spread Bancário (%)</label>
                <input type="number" step="0.0001" value={formData.spreadCambio} onChange={e => setFormData({...formData, spreadCambio: parseFloat(e.target.value)})} />
              </div>
              <div className="form-group">
                <label>Frete Internacional (USD)</label>
                <input type="number" value={formData.valorFreteInternacional} onChange={e => setFormData({...formData, valorFreteInternacional: parseFloat(e.target.value)})} />
              </div>
              <div className="form-group">
                <label>Seguro (USD)</label>
                <input type="number" value={formData.valorSeguroInternacional} onChange={e => setFormData({...formData, valorSeguroInternacional: parseFloat(e.target.value)})} />
              </div>
              <div className="form-group">
                <label>Porto Destino</label>
                <select value={formData.idPortoDestino} onChange={e => setFormData({...formData, idPortoDestino: parseInt(e.target.value)})}>
                  <option value="0">Selecione...</option>
                  {portos.map(p => <option key={p.id} value={p.id}>{p.sigla} - {p.nome}</option>)}
                </select>
              </div>
            </div>

            <div style={{ marginTop: '2rem', paddingTop: '1.5rem', borderTop: '1px solid rgba(255,255,255,0.1)' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px' }}>
                <span style={{ opacity: 0.7 }}>FOB Total:</span>
                <span style={{ fontWeight: '600' }}>USD {totalFob.toLocaleString()}</span>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '1.5rem' }}>
                <span style={{ opacity: 0.7 }}>Câmbio Final:</span>
                <span style={{ fontWeight: '600' }}>R$ {cotacaoFinal.toFixed(4)}</span>
              </div>
              <div style={{ textAlign: 'right' }}>
                <span style={{ fontSize: '0.8rem', opacity: 0.6, display: 'block', marginBottom: '4px' }}>Custo Est. Nacionalizado</span>
                <span style={{ fontSize: '1.8rem', fontWeight: '800', color: 'var(--primary)' }}>
                  R$ {(totalFob * cotacaoFinal * 1.62).toLocaleString('pt-BR', { minimumFractionDigits: 2 })}
                </span>
              </div>
            </div>
          </div>

          <div style={{ display: 'flex', flexDirection: 'column', gap: '0.75rem' }}>
            <button className="btn btn-primary" style={{ width: '100%', height: '54px', fontSize: '1.1rem' }} onClick={handleSave}>
              <Save size={20} />
              <span>Gerar Estudo EDC</span>
            </button>
            <button className="btn btn-secondary" style={{ width: '100%' }} onClick={() => navigate('/edc/estudos')}>
              <X size={18} />
              <span>Descartar Simulação</span>
            </button>
          </div>
          
          <div className="alert alert-info" style={{ background: 'rgba(79, 158, 255, 0.05)', padding: '12px', borderRadius: '10px', fontSize: '0.8rem', border: '1px solid rgba(79, 158, 255, 0.1)' }}>
            <div style={{ display: 'flex', gap: '8px' }}>
              <Info size={16} style={{ flexShrink: 0 }} />
              <p>O custo estimado inclui impostos federais (II, IPI, PIS, COF) e ICMS de 19%.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default NovoEstudoEdcPage;
