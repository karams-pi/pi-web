
import React, { useState, useEffect } from 'react';
import { BookOpen, Plus, Search, Edit2, Trash2, Save, X, Info } from 'lucide-react';

interface Ncm {
  id: number;
  codigo: string;
  descricao: string;
  aliquotaII: number;
  aliquotaIPI: number;
  aliquotaPis: number;
  aliquotaCofins: number;
  aliquotaIcmsPadrao: number;
}

const NcmsPage: React.FC = () => {
  const [ncms, setNcms] = useState<Ncm[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [editingNcm, setEditingNcm] = useState<Ncm | null>(null);

  const [formData, setFormData] = useState({
    codigo: '',
    descricao: '',
    aliquotaII: 0,
    aliquotaIPI: 0,
    aliquotaPis: 0,
    aliquotaCofins: 0,
    aliquotaIcmsPadrao: 0.19
  });

  useEffect(() => { fetchNcms(); }, []);

  const fetchNcms = async () => {
    try {
      const response = await fetch('/api/edc/ncms');
      const data = await response.json();
      setNcms(data);
    } catch (error) { console.error(error); } 
    finally { setLoading(false); }
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    const method = editingNcm ? 'PUT' : 'POST';
    const url = editingNcm ? `/api/edc/ncms/${editingNcm.id}` : '/api/edc/ncms';
    
    try {
      const response = await fetch(url, {
        method,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData)
      });
      if (response.ok) {
        fetchNcms();
        setShowModal(false);
      }
    } catch (error) { console.error(error); }
  };

  const filteredNcms = ncms.filter(n => 
    n.codigo.includes(searchTerm) || 
    n.descricao.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="animate-fadeIn">
      <div className="page-header">
        <div className="page-header-icon" style={{ background: 'rgba(59, 130, 246, 0.1)', color: '#3b82f6' }}>
          <BookOpen size={24} />
        </div>
        <div>
          <h1 className="page-title">Catálogo de NCMs</h1>
          <p className="page-description">Gerencie as alíquotas de importação e impostos federais por código.</p>
        </div>
        <div className="page-header-line"></div>
        <button className="btn btn-primary" style={{ marginLeft: 'auto' }} onClick={() => { setEditingNcm(null); setFormData({ codigo: '', descricao: '', aliquotaII: 0, aliquotaIPI: 0, aliquotaPis: 0, aliquotaCofins: 0, aliquotaIcmsPadrao: 0.19 }); setShowModal(true); }}>
          <Plus size={18} />
          <span>Novo Código</span>
        </button>
      </div>

      <div className="card">
        <div className="search-bar">
          <Search size={20} className="search-icon" />
          <input 
            type="text" 
            placeholder="Buscar por código ou descrição..." 
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>

        <div className="table-responsive">
          <table className="table">
            <thead>
              <tr>
                <th>Código</th>
                <th>Descrição</th>
                <th>II (%)</th>
                <th>IPI (%)</th>
                <th>PIS/COF (%)</th>
                <th>ICMS (%)</th>
                <th style={{ textAlign: 'right' }}>Ações</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr><td colSpan={7} style={{ textAlign: 'center' }}>Carregando dados...</td></tr>
              ) : filteredNcms.length === 0 ? (
                <tr><td colSpan={7} style={{ textAlign: 'center' }}>Nenhum NCM encontrado.</td></tr>
              ) : filteredNcms.map(n => (
                <tr key={n.id}>
                  <td><span className="badge" style={{ fontSize: '0.9rem', padding: '6px 12px' }}>{n.codigo}</span></td>
                  <td style={{ maxWidth: '300px', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{n.descricao}</td>
                  <td><strong style={{ color: '#fff' }}>{(n.aliquotaII * 100).toFixed(2)}%</strong></td>
                  <td><strong style={{ color: '#fff' }}>{(n.aliquotaIPI * 100).toFixed(2)}%</strong></td>
                  <td>{((n.aliquotaPis + n.aliquotaCofins) * 100).toFixed(2)}%</td>
                  <td><span className="badge badge-success">{(n.aliquotaIcmsPadrao * 100).toFixed(0)}%</span></td>
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
          <div className="modal-content" style={{ maxWidth: '650px' }}>
            <div className="modal-header">
              <h3><Calculator size={20} style={{ marginRight: '10px', verticalAlign: 'middle' }} /> {editingNcm ? 'Editar NCM' : 'Novo NCM'}</h3>
              <button className="btn-icon" onClick={() => setShowModal(false)}><X size={20} /></button>
            </div>
            <div className="modal-body">
              <form onSubmit={handleSave}>
                <div className="grid grid-2">
                  <div className="form-group">
                    <label>Código NCM</label>
                    <input type="text" required value={formData.codigo} onChange={e => setFormData({...formData, codigo: e.target.value})} placeholder="Ex: 8708.80.00" />
                  </div>
                  <div className="form-group" style={{ gridColumn: 'span 2' }}>
                    <label>Descrição Completa</label>
                    <textarea rows={2} required value={formData.descricao} onChange={e => setFormData({...formData, descricao: e.target.value})} />
                  </div>
                  
                  <div className="form-group">
                    <label>Alíquota II (%)</label>
                    <input type="number" step="0.01" value={formData.aliquotaII * 100} onChange={e => setFormData({...formData, aliquotaII: parseFloat(e.target.value) / 100})} />
                  </div>
                  <div className="form-group">
                    <label>Alíquota IPI (%)</label>
                    <input type="number" step="0.01" value={formData.aliquotaIPI * 100} onChange={e => setFormData({...formData, aliquotaIPI: parseFloat(e.target.value) / 100})} />
                  </div>
                  <div className="form-group">
                    <label>Alíquota PIS (%)</label>
                    <input type="number" step="0.01" value={formData.aliquotaPis * 100} onChange={e => setFormData({...formData, aliquotaPis: parseFloat(e.target.value) / 100})} />
                  </div>
                  <div className="form-group">
                    <label>Alíquota COFINS (%)</label>
                    <input type="number" step="0.01" value={formData.aliquotaCofins * 100} onChange={e => setFormData({...formData, aliquotaCofins: parseFloat(e.target.value) / 100})} />
                  </div>
                  <div className="form-group" style={{ gridColumn: 'span 2' }}>
                    <label>ICMS Padrão (%)</label>
                    <input type="number" step="0.01" value={formData.aliquotaIcmsPadrao * 100} onChange={e => setFormData({...formData, aliquotaIcmsPadrao: parseFloat(e.target.value) / 100})} />
                  </div>
                </div>
                <div className="modal-footer" style={{ padding: '20px 0 0 0' }}>
                  <button type="button" className="btn btn-secondary" onClick={() => setShowModal(false)}>Descartar</button>
                  <button type="submit" className="btn btn-primary"><Save size={18} /><span>Salvar Alterações</span></button>
                </div>
              </form>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default NcmsPage;
