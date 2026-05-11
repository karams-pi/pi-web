
import React, { useState, useEffect } from 'react';
import { Globe2, Plus, Search, Edit2, Trash2, Save, X, MapPin } from 'lucide-react';

interface Exportador {
  id: number;
  nome: string;
  pais: string;
  taxId: string;
  contato: string;
}

const ExportadoresPage: React.FC = () => {
  const [exportadores, setExportadores] = useState<Exportador[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [showModal, setShowModal] = useState(false);

  const [formData, setFormData] = useState({
    nome: '',
    pais: '',
    taxId: '',
    contato: '',
    endereco: ''
  });

  useEffect(() => { fetchExportadores(); }, []);

  const fetchExportadores = async () => {
    try {
      const response = await fetch('/api/edc/exportadores');
      const data = await response.json();
      setExportadores(data);
    } catch (error) { console.error(error); } 
    finally { setLoading(false); }
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const response = await fetch('/api/edc/exportadores', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData)
      });
      if (response.ok) { fetchExportadores(); setShowModal(false); }
    } catch (error) { console.error(error); }
  };

  return (
    <div className="animate-fadeIn">
      <div className="page-header">
        <div className="page-header-icon" style={{ background: 'rgba(167, 139, 250, 0.1)', color: '#a78bfa' }}>
          <Globe2 size={24} />
        </div>
        <div>
          <h1 className="page-title">Exportadores (Fornecedores)</h1>
          <p className="page-description">Gerencie os parceiros internacionais para faturamento das Proformas.</p>
        </div>
        <div className="page-header-line" style={{ background: 'linear-gradient(90deg, #a78bfa, transparent)' }}></div>
        <button className="btn btn-primary" style={{ marginLeft: 'auto' }} onClick={() => setShowModal(true)}>
          <Plus size={18} />
          <span>Novo Fornecedor</span>
        </button>
      </div>

      <div className="card">
        <div className="search-bar">
          <Search size={20} className="search-icon" />
          <input 
            type="text" 
            placeholder="Filtrar por nome ou país de origem..." 
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>

        <div className="table-responsive">
          <table className="table">
            <thead>
              <tr>
                <th>Nome do Exportador</th>
                <th>País de Origem</th>
                <th>Tax ID / Documento</th>
                <th>Contato</th>
                <th style={{ textAlign: 'right' }}>Ações</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr><td colSpan={5} style={{ textAlign: 'center' }}>Carregando dados globais...</td></tr>
              ) : exportadores.filter(e => e.nome.toLowerCase().includes(searchTerm.toLowerCase())).map(e => (
                <tr key={e.id}>
                  <td><strong style={{ color: '#fff' }}>{e.nome}</strong></td>
                  <td>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                      <MapPin size={14} style={{ color: '#a78bfa' }} />
                      <span>{e.pais}</span>
                    </div>
                  </td>
                  <td><span className="badge">{e.taxId || 'N/A'}</span></td>
                  <td>{e.contato || '-'}</td>
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
              <h3>Novo Exportador Internacional</h3>
              <button className="btn-icon" onClick={() => setShowModal(false)}><X size={20} /></button>
            </div>
            <div className="modal-body">
              <form onSubmit={handleSave}>
                <div className="grid grid-2">
                  <div className="form-group" style={{ gridColumn: 'span 2' }}>
                    <label>Razão Social / Nome Fantasia</label>
                    <input type="text" required value={formData.nome} onChange={e => setFormData({...formData, nome: e.target.value})} />
                  </div>
                  <div className="form-group">
                    <label>País</label>
                    <input type="text" required value={formData.pais} onChange={e => setFormData({...formData, pais: e.target.value})} />
                  </div>
                  <div className="form-group">
                    <label>Tax ID / VAT</label>
                    <input type="text" value={formData.taxId} onChange={e => setFormData({...formData, taxId: e.target.value})} />
                  </div>
                  <div className="form-group" style={{ gridColumn: 'span 2' }}>
                    <label>Informações de Contato</label>
                    <input type="text" value={formData.contato} onChange={e => setFormData({...formData, contato: e.target.value})} />
                  </div>
                </div>
                <div className="modal-footer" style={{ padding: '20px 0 0 0' }}>
                  <button type="button" className="btn btn-secondary" onClick={() => setShowModal(false)}>Cancelar</button>
                  <button type="submit" className="btn btn-primary"><Save size={18} /><span>Salvar Exportador</span></button>
                </div>
              </form>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ExportadoresPage;
