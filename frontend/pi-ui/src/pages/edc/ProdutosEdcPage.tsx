
import React, { useState, useEffect } from 'react';
import { Grid, Plus, Search, Edit2, Trash2, Save, X, Box, Info, Package } from 'lucide-react';

interface Ncm {
  id: number;
  codigo: string;
}

interface ProdutoEdc {
  id: number;
  referencia: string;
  descricao: string;
  idNcm: number;
  ncm?: Ncm;
  pesoLiquido: number;
  pesoBruto: number;
  cubagemM3: number;
  precoFobBase: number;
}

const ProdutosEdcPage: React.FC = () => {
  const [produtos, setProdutos] = useState<ProdutoEdc[]>([]);
  const [ncms, setNcms] = useState<Ncm[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [showModal, setShowModal] = useState(false);

  const [formData, setFormData] = useState({
    referencia: '',
    descricao: '',
    idNcm: 0,
    pesoLiquido: 0,
    pesoBruto: 0,
    cubagemM3: 0,
    precoFobBase: 0,
    unidadeMedida: 'UN'
  });

  useEffect(() => {
    fetchProdutos();
    fetchNcms();
  }, []);

  const fetchProdutos = async () => {
    try {
      const response = await fetch('/api/edc/produtos');
      const data = await response.json();
      setProdutos(data);
    } catch (error) { console.error(error); } 
    finally { setLoading(false); }
  };

  const fetchNcms = async () => {
    try {
      const response = await fetch('/api/edc/ncms');
      const data = await response.json();
      setNcms(data);
      if (data.length > 0) setFormData(prev => ({ ...prev, idNcm: data[0].id }));
    } catch (error) { console.error(error); }
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const response = await fetch('/api/edc/produtos', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData)
      });
      if (response.ok) { fetchProdutos(); setShowModal(false); }
    } catch (error) { console.error(error); }
  };

  return (
    <div className="animate-fadeIn">
      <div className="page-header">
        <div className="page-header-icon" style={{ background: 'rgba(245, 158, 11, 0.1)', color: '#f59e0b' }}>
          <Package size={24} />
        </div>
        <div>
          <h1 className="page-title">Catálogo de Produtos</h1>
          <p className="page-description">Gerencie as especificações técnicas e logísticas para importação.</p>
        </div>
        <div className="page-header-line" style={{ background: 'linear-gradient(90deg, #f59e0b, transparent)' }}></div>
        <button className="btn btn-primary" style={{ marginLeft: 'auto' }} onClick={() => setShowModal(true)}>
          <Plus size={18} />
          <span>Novo Produto</span>
        </button>
      </div>

      <div className="card">
        <div className="search-bar">
          <Search size={20} className="search-icon" />
          <input 
            type="text" 
            placeholder="Filtrar por referência técnica ou descrição..." 
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>

        <div className="table-responsive">
          <table className="table">
            <thead>
              <tr>
                <th>Referência</th>
                <th>Descrição do Produto</th>
                <th>NCM</th>
                <th>Pesos (L/B)</th>
                <th>Volume (m³)</th>
                <th>Preço FOB</th>
                <th style={{ textAlign: 'right' }}>Ações</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr><td colSpan={7} style={{ textAlign: 'center' }}>Sincronizando catálogo...</td></tr>
              ) : produtos.filter(p => p.referencia.toLowerCase().includes(searchTerm.toLowerCase())).map(p => (
                <tr key={p.id}>
                  <td><strong style={{ color: '#fff' }}>{p.referencia}</strong></td>
                  <td style={{ maxWidth: '250px' }}>{p.descricao}</td>
                  <td><span className="badge">{p.ncm?.codigo || '-'}</span></td>
                  <td>
                    <div style={{ fontSize: '0.85rem' }}>
                      <span style={{ color: 'var(--muted)' }}>L:</span> {p.pesoLiquido.toFixed(2)}kg<br/>
                      <span style={{ color: 'var(--muted)' }}>B:</span> {p.pesoBruto.toFixed(2)}kg
                    </div>
                  </td>
                  <td>{p.cubagemM3.toFixed(4)}</td>
                  <td><strong style={{ color: 'var(--primary)' }}>USD {p.precoFobBase.toFixed(2)}</strong></td>
                  <td style={{ textAlign: 'right' }}>
                    <div className="action-buttons" style={{ justifyContent: 'flex-end' }}>
                      <button className="btn-icon"><Edit2 size={16} /></button>
                      <button className="btn-icon btn-icon-danger"><Trash2 size={16} /></button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {showModal && (
        <div className="modal-overlay">
          <div className="modal-content" style={{ maxWidth: '700px' }}>
            <div className="modal-header">
              <h3>Novo Produto EDC</h3>
              <button className="btn-icon" onClick={() => setShowModal(false)}><X size={20} /></button>
            </div>
            <div className="modal-body">
              <form onSubmit={handleSave}>
                <div className="grid grid-2">
                  <div className="form-group">
                    <label>Referência de Fábrica</label>
                    <input type="text" required value={formData.referencia} onChange={e => setFormData({...formData, referencia: e.target.value})} />
                  </div>
                  <div className="form-group" style={{ gridColumn: 'span 2' }}>
                    <label>Descrição Detalhada</label>
                    <input type="text" required value={formData.descricao} onChange={e => setFormData({...formData, descricao: e.target.value})} />
                  </div>
                  <div className="form-group">
                    <label>Classificação NCM</label>
                    <select value={formData.idNcm} onChange={e => setFormData({...formData, idNcm: parseInt(e.target.value)})}>
                      {ncms.map(n => <option key={n.id} value={n.id}>{n.codigo}</option>)}
                    </select>
                  </div>
                  <div className="form-group">
                    <label>Preço FOB Base (USD)</label>
                    <input type="number" step="0.01" value={formData.precoFobBase} onChange={e => setFormData({...formData, precoFobBase: parseFloat(e.target.value)})} />
                  </div>
                  <div className="form-group">
                    <label>Peso Líquido (kg)</label>
                    <input type="number" step="0.001" value={formData.pesoLiquido} onChange={e => setFormData({...formData, pesoLiquido: parseFloat(e.target.value)})} />
                  </div>
                  <div className="form-group">
                    <label>Peso Bruto (kg)</label>
                    <input type="number" step="0.001" value={formData.pesoBruto} onChange={e => setFormData({...formData, pesoBruto: parseFloat(e.target.value)})} />
                  </div>
                  <div className="form-group" style={{ gridColumn: 'span 2' }}>
                    <label>Volume Total (m³)</label>
                    <input type="number" step="0.0001" value={formData.cubagemM3} onChange={e => setFormData({...formData, cubagemM3: parseFloat(e.target.value)})} />
                  </div>
                </div>
                <div className="modal-footer" style={{ padding: '20px 0 0 0' }}>
                  <button type="button" className="btn btn-secondary" onClick={() => setShowModal(false)}>Descartar</button>
                  <button type="submit" className="btn btn-primary"><Save size={18} /><span>Salvar Produto</span></button>
                </div>
              </form>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ProdutosEdcPage;
