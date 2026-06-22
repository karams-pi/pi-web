import React, { useState, useEffect } from 'react';
import { ShieldCheck, Plus, Save, Trash2, CheckCircle2, AlertCircle, Edit2, X, Search } from 'lucide-react';

interface ConfiguracaoFiscal {
  id: number;
  uf: string;
  aliquotaIcms: number;
  aliquotaFCP: number;
  isencaoIPI: boolean;
}

const ConfiguracoesFiscaisPage: React.FC = () => {
  const [configs, setConfigs] = useState<ConfiguracaoFiscal[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [editingConfig, setEditingConfig] = useState<ConfiguracaoFiscal | null>(null);

  const [formData, setFormData] = useState({
    id: undefined as number | undefined,
    uf: '',
    aliquotaIcms: 0.18,
    aliquotaFCP: 0.00,
    isencaoIPI: false
  });

  useEffect(() => { fetchConfigs(); }, []);

  const fetchConfigs = async () => {
    try {
      const response = await fetch('/api/edc/configuracoesfiscais');
      const data = await response.json();
      setConfigs(data);
    } catch (error) { console.error(error); } 
    finally { setLoading(false); }
  };

  const handleNewConfig = () => {
    setFormData({
      id: undefined,
      uf: '',
      aliquotaIcms: 0.18,
      aliquotaFCP: 0.00,
      isencaoIPI: false
    });
    setEditingConfig(null);
    setShowModal(true);
  };

  const handleEditConfig = (c: ConfiguracaoFiscal) => {
    setFormData({
      id: c.id,
      uf: c.uf,
      aliquotaIcms: c.aliquotaIcms,
      aliquotaFCP: c.aliquotaFCP,
      isencaoIPI: c.isencaoIPI
    });
    setEditingConfig(c);
    setShowModal(true);
  };

  const handleDeleteConfig = async (id: number) => {
    if (window.confirm("Deseja realmente excluir esta regra fiscal?")) {
      try {
        const response = await fetch(`/api/edc/configuracoesfiscais/${id}`, {
          method: 'DELETE'
        });
        if (response.ok) {
          fetchConfigs();
        } else {
          alert("Erro ao excluir regra fiscal.");
        }
      } catch (error) {
        console.error(error);
        alert("Erro ao excluir regra fiscal.");
      }
    }
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!formData.uf || formData.uf.length !== 2) {
      alert("Por favor, informe uma UF válida com 2 letras.");
      return;
    }
    
    try {
      const isEdit = formData.id !== undefined;
      const url = isEdit ? `/api/edc/configuracoesfiscais/${formData.id}` : '/api/edc/configuracoesfiscais';
      const method = isEdit ? 'PUT' : 'POST';
      const payload = {
        ...formData,
        uf: formData.uf.toUpperCase()
      };
      
      const response = await fetch(url, {
        method: method,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });
      
      if (response.ok) {
        fetchConfigs();
        setShowModal(false);
      } else {
        alert("Erro ao salvar regra fiscal.");
      }
    } catch (error) {
      console.error(error);
      alert("Erro ao salvar regra fiscal.");
    }
  };

  const filteredConfigs = configs.filter(c => 
    c.uf.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="animate-fadeIn">
      <div className="page-header">
        <div className="page-header-icon" style={{ background: 'rgba(16, 185, 129, 0.1)', color: '#10b981' }}>
          <ShieldCheck size={24} />
        </div>
        <div>
          <h1 className="page-title">Configurações Fiscais (ICMS)</h1>
          <p className="page-description">Regras tributárias estaduais para cálculo de nacionalização "por dentro".</p>
        </div>
        <div className="page-header-line" style={{ background: 'linear-gradient(90deg, #10b981, transparent)' }}></div>
        <button className="btn btn-primary" style={{ marginLeft: 'auto' }} onClick={handleNewConfig}>
          <Plus size={18} />
          <span>Nova Regra UF</span>
        </button>
      </div>

      <div className="card">
        <div className="search-bar">
          <Search size={20} className="search-icon" />
          <input 
            type="text" 
            placeholder="Filtrar por UF..." 
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>

        <div className="table-responsive">
          <table className="table">
            <thead>
              <tr>
                <th>Estado (UF)</th>
                <th>Alíquota ICMS</th>
                <th>Fundo Comb. Pobreza (FCP)</th>
                <th>Status Isenção IPI</th>
                <th style={{ textAlign: 'right' }}>Ações</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr><td colSpan={5} style={{ textAlign: 'center' }}>Carregando matriz tributária...</td></tr>
              ) : filteredConfigs.length === 0 ? (
                <tr><td colSpan={5} style={{ textAlign: 'center' }}>Nenhuma regra cadastrada para esta busca.</td></tr>
              ) : filteredConfigs.map(c => (
                <tr key={c.id}>
                  <td><strong style={{ color: '#fff', fontSize: '1.2rem' }}>{c.uf}</strong></td>
                  <td><span className="badge badge-success" style={{ fontSize: '1rem' }}>{(c.aliquotaIcms * 100).toFixed(2)}%</span></td>
                  <td>{(c.aliquotaFCP * 100).toFixed(2)}%</td>
                  <td>
                    {c.isencaoIPI ? 
                      <div style={{ display: 'flex', alignItems: 'center', gap: '6px', color: '#10b981' }}><CheckCircle2 size={16} /> Isento</div> : 
                      <div style={{ display: 'flex', alignItems: 'center', gap: '6px', color: 'var(--muted)' }}><AlertCircle size={16} /> Tributado</div>
                    }
                  </td>
                  <td style={{ textAlign: 'right' }}>
                    <div className="action-buttons" style={{ justifyContent: 'flex-end' }}>
                      <button className="btn-icon" onClick={() => handleEditConfig(c)} title="Editar Regra"><Edit2 size={16} /></button>
                      <button className="btn-icon btn-icon-danger" onClick={() => handleDeleteConfig(c.id)} title="Excluir Regra"><Trash2 size={16} /></button>
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
          <div className="modal-content" style={{ maxWidth: '550px' }}>
            <div className="modal-header">
              <h3><ShieldCheck size={20} style={{ marginRight: '10px', verticalAlign: 'middle', color: '#10b981' }} /> {formData.id ? 'Editar Regra Fiscal' : 'Nova Regra Fiscal'}</h3>
              <button className="btn-icon" onClick={() => setShowModal(false)}><X size={20} /></button>
            </div>
            <div className="modal-body">
              <form onSubmit={handleSave}>
                <div className="grid grid-2">
                  <div className="form-group" style={{ gridColumn: 'span 2' }}>
                    <label>Estado (UF - 2 Letras)</label>
                    <input 
                      type="text" 
                      required 
                      maxLength={2} 
                      placeholder="Ex: SP, RJ, MG" 
                      value={formData.uf} 
                      onChange={e => setFormData({...formData, uf: e.target.value.toUpperCase().replace(/[^A-Z]/g, '')})} 
                      disabled={formData.id !== undefined}
                    />
                  </div>
                  <div className="form-group">
                    <label>Alíquota ICMS (%)</label>
                    <input 
                      type="number" 
                      step="0.01" 
                      required
                      value={formData.aliquotaIcms * 100} 
                      onChange={e => setFormData({...formData, aliquotaIcms: parseFloat(e.target.value) / 100})} 
                    />
                  </div>
                  <div className="form-group">
                    <label>Alíquota FCP (%)</label>
                    <input 
                      type="number" 
                      step="0.01" 
                      required
                      value={formData.aliquotaFCP * 100} 
                      onChange={e => setFormData({...formData, aliquotaFCP: parseFloat(e.target.value) / 100})} 
                    />
                  </div>
                  <div className="form-group" style={{ gridColumn: 'span 2', display: 'flex', alignItems: 'center', gap: '10px', marginTop: '10px' }}>
                    <input 
                      type="checkbox" 
                      id="isencaoIPI"
                      checked={formData.isencaoIPI} 
                      onChange={e => setFormData({...formData, isencaoIPI: e.target.checked})} 
                      style={{ width: '20px', height: '20px', cursor: 'pointer' }}
                    />
                    <label htmlFor="isencaoIPI" style={{ margin: 0, cursor: 'pointer', fontWeight: '500' }}>Isenção total de IPI para este Estado</label>
                  </div>
                </div>
                <div className="modal-footer" style={{ padding: '20px 0 0 0', marginTop: '20px', borderTop: '1px solid rgba(255,255,255,0.05)' }}>
                  <button type="button" className="btn btn-secondary" onClick={() => setShowModal(false)}>Descartar</button>
                  <button type="submit" className="btn btn-primary"><Save size={18} /><span>Salvar Regra</span></button>
                </div>
              </form>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ConfiguracoesFiscaisPage;
