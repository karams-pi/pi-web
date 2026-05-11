
import React, { useState, useEffect } from 'react';
import { Building2, Plus, Search, Edit2, Trash2, Save, X, MapPin, UserCheck } from 'lucide-react';

interface Importador {
  id: number;
  razaoSocial: string;
  cnpj: string;
  inscricaoEstadual: string;
  uf: string;
  regimeTributario: string;
  aliquotaIcmsPadrao: number;
}

const ImportadoresPage: React.FC = () => {
  const [importadores, setImportadores] = useState<Importador[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [showModal, setShowModal] = useState(false);

  const [formData, setFormData] = useState({
    razaoSocial: '',
    cnpj: '',
    inscricaoEstadual: '',
    uf: 'PR',
    regimeTributario: 'Lucro Real',
    aliquotaIcmsPadrao: 0.19
  });

  useEffect(() => { fetchImportadores(); }, []);

  const fetchImportadores = async () => {
    try {
      const response = await fetch('/api/edc/importadores');
      const data = await response.json();
      setImportadores(data);
    } catch (error) { console.error(error); } 
    finally { setLoading(false); }
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const response = await fetch('/api/edc/importadores', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData)
      });
      if (response.ok) { fetchImportadores(); setShowModal(false); }
    } catch (error) { console.error(error); }
  };

  return (
    <div className="animate-fadeIn">
      <div className="page-header">
        <div className="page-header-icon" style={{ background: 'rgba(79, 158, 255, 0.1)', color: '#4f9eff' }}>
          <Building2 size={24} />
        </div>
        <div>
          <h1 className="page-title">Gestão de Importadores</h1>
          <p className="page-description">Cadastre e gerencie as empresas brasileiras responsáveis pela nacionalização.</p>
        </div>
        <div className="page-header-line"></div>
        <button className="btn btn-primary" style={{ marginLeft: 'auto' }} onClick={() => setShowModal(true)}>
          <Plus size={18} />
          <span>Novo Cliente</span>
        </button>
      </div>

      <div className="card">
        <div className="search-bar">
          <Search size={20} className="search-icon" />
          <input 
            type="text" 
            placeholder="Buscar por razão social ou documento..." 
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>

        <div className="table-responsive">
          <table className="table">
            <thead>
              <tr>
                <th>Empresa / Razão Social</th>
                <th>CNPJ</th>
                <th>Localização</th>
                <th>Regime Fiscal</th>
                <th>ICMS Base</th>
                <th style={{ textAlign: 'right' }}>Ações</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr><td colSpan={6} style={{ textAlign: 'center' }}>Carregando importadores...</td></tr>
              ) : importadores.filter(i => i.razaoSocial.toLowerCase().includes(searchTerm.toLowerCase())).map(i => (
                <tr key={i.id}>
                  <td>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                      <div style={{ padding: '8px', background: 'rgba(79, 158, 255, 0.05)', borderRadius: '8px', color: 'var(--primary)' }}>
                        <Building2 size={16} />
                      </div>
                      <strong style={{ color: '#fff' }}>{i.razaoSocial}</strong>
                    </div>
                  </td>
                  <td>{i.cnpj}</td>
                  <td><span className="badge">{i.uf}</span></td>
                  <td><div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}><UserCheck size={14} style={{ color: '#10b981' }}/> {i.regimeTributario}</div></td>
                  <td><span className="badge badge-success">{(i.aliquotaIcmsPadrao * 100).toFixed(0)}%</span></td>
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
          <div className="modal-content" style={{ maxWidth: '600px' }}>
            <div className="modal-header">
              <h3>Novo Importador</h3>
              <button className="btn-icon" onClick={() => setShowModal(false)}><X size={20} /></button>
            </div>
            <div className="modal-body">
              <form onSubmit={handleSave}>
                <div className="grid grid-2">
                  <div className="form-group" style={{ gridColumn: 'span 2' }}>
                    <label>Razão Social</label>
                    <input type="text" required value={formData.razaoSocial} onChange={e => setFormData({...formData, razaoSocial: e.target.value})} />
                  </div>
                  <div className="form-group">
                    <label>CNPJ</label>
                    <input type="text" required value={formData.cnpj} onChange={e => setFormData({...formData, cnpj: e.target.value})} />
                  </div>
                  <div className="form-group">
                    <label>UF</label>
                    <select value={formData.uf} onChange={e => setFormData({...formData, uf: e.target.value})}>
                      <option value="PR">Paraná (PR)</option>
                      <option value="SP">São Paulo (SP)</option>
                      <option value="SC">Santa Catarina (SC)</option>
                    </select>
                  </div>
                  <div className="form-group">
                    <label>Regime Tributário</label>
                    <select value={formData.regimeTributario} onChange={e => setFormData({...formData, regimeTributario: e.target.value})}>
                      <option value="Lucro Real">Lucro Real</option>
                      <option value="Lucro Presumido">Lucro Presumido</option>
                    </select>
                  </div>
                  <div className="form-group">
                    <label>ICMS Padrão (%)</label>
                    <input type="number" step="0.01" value={formData.aliquotaIcmsPadrao * 100} onChange={e => setFormData({...formData, aliquotaIcmsPadrao: parseFloat(e.target.value) / 100})} />
                  </div>
                </div>
                <div className="modal-footer" style={{ padding: '20px 0 0 0' }}>
                  <button type="button" className="btn btn-secondary" onClick={() => setShowModal(false)}>Cancelar</button>
                  <button type="submit" className="btn btn-primary"><Save size={18} /><span>Salvar Cadastro</span></button>
                </div>
              </form>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ImportadoresPage;
