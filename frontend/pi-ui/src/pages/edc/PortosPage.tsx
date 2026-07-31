import React, { useState, useEffect } from 'react';
import { Anchor, Plus, Search, Edit2, Trash2, Save, X, Navigation } from 'lucide-react';

interface Porto {
  id: number;
  nome: string;
  sigla: string;
  pais: string;
  tipo: string;
}

const PortosPage: React.FC = () => {
  const [portos, setPortos] = useState<Porto[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [showModal, setShowModal] = useState(false);

  const [formData, setFormData] = useState({
    id: undefined as number | undefined,
    nome: '',
    sigla: '',
    pais: '',
    tipo: 'Maritimo'
  });

  useEffect(() => {
    fetchPortos();
  }, []);

  const fetchPortos = async () => {
    try {
      const response = await fetch('/api/edc/portos');
      const data = await response.json();
      setPortos(data);
    } catch (error) {
      console.error("Erro ao buscar portos:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleNewPorto = () => {
    setFormData({
      id: undefined,
      nome: '',
      sigla: '',
      pais: '',
      tipo: 'Maritimo'
    });
    setShowModal(true);
  };

  const handleEditPorto = (p: Porto) => {
    setFormData({
      id: p.id,
      nome: p.nome,
      sigla: p.sigla,
      pais: p.pais,
      tipo: p.tipo
    });
    setShowModal(true);
  };

  const handleDeletePorto = async (id: number) => {
    if (window.confirm("Deseja realmente excluir este porto?")) {
      try {
        const response = await fetch(`/api/edc/portos/${id}`, {
          method: 'DELETE'
        });
        if (response.ok) {
          fetchPortos();
        } else {
          alert("Não foi possível excluir o porto. Verifique se ele está sendo usado em alguma simulação.");
        }
      } catch (error) {
        console.error("Erro ao excluir porto:", error);
      }
    }
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const isEdit = formData.id !== undefined;
      const url = isEdit ? `/api/edc/portos/${formData.id}` : '/api/edc/portos';
      const method = isEdit ? 'PUT' : 'POST';
      const response = await fetch(url, {
        method: method,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData)
      });
      if (response.ok) {
        fetchPortos();
        setShowModal(false);
      } else {
        alert("Erro ao salvar porto. Verifique as informações fornecidas.");
      }
    } catch (error) {
      console.error("Erro ao salvar porto:", error);
    }
  };

  const filteredPortos = portos.filter(p =>
    p.nome.toLowerCase().includes(searchTerm.toLowerCase()) ||
    p.sigla.toLowerCase().includes(searchTerm.toLowerCase()) ||
    p.pais.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="animate-fadeIn">
      <div className="page-header">
        <div className="page-header-icon" style={{ background: 'rgba(59, 130, 246, 0.1)', color: '#3b82f6' }}>
          <Anchor size={24} />
        </div>
        <div>
          <h1 className="page-title">Gestão de Portos</h1>
          <p className="page-description">Cadastre e gerencie os portos de origem e destino utilizados nas simulações aduaneiras.</p>
        </div>
        <div className="page-header-line" style={{ background: 'linear-gradient(90deg, #3b82f6, transparent)' }}></div>
        <button className="btn btn-primary" onClick={handleNewPorto} style={{ marginLeft: 'auto' }}>
          <Plus size={18} />
          <span>Novo Porto</span>
        </button>
      </div>

      <div className="card" style={{ marginBottom: '24px' }}>
        <div style={{ display: 'flex', gap: '16px', alignItems: 'center' }}>
          <div style={{ position: 'relative', flexGrow: 1 }}>
            <Search size={18} style={{ position: 'absolute', left: '12px', top: '50%', transform: 'translateY(-50%)', color: 'var(--muted)' }} />
            <input
              type="text"
              className="input-text"
              placeholder="Buscar por nome, sigla ou país..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              style={{ paddingLeft: '40px', width: '100%' }}
            />
          </div>
        </div>
      </div>

      <div className="card" style={{ padding: '0', overflow: 'hidden' }}>
        <div className="table-responsive">
          <table className="table">
            <thead style={{ background: 'rgba(255,255,255,0.02)' }}>
              <tr>
                <th style={{ paddingLeft: '24px' }}>Sigla</th>
                <th>Nome do Porto</th>
                <th>País</th>
                <th>Tipo</th>
                <th style={{ width: '120px', paddingRight: '24px', textAlign: 'right' }}>Ações</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr><td colSpan={5} style={{ textAlign: 'center' }}>Carregando portos...</td></tr>
              ) : filteredPortos.length === 0 ? (
                <tr><td colSpan={5} style={{ textAlign: 'center' }}>Nenhum porto cadastrado ou encontrado.</td></tr>
              ) : (
                filteredPortos.map((p) => (
                  <tr key={p.id}>
                    <td style={{ paddingLeft: '24px' }}>
                      <span style={{ fontWeight: '700', color: 'var(--primary)', letterSpacing: '0.5px' }}>{p.sigla}</span>
                    </td>
                    <td>
                      <strong style={{ color: '#fff' }}>{p.nome}</strong>
                    </td>
                    <td>{p.pais}</td>
                    <td>
                      <span className="badge" style={{ 
                        background: p.tipo === 'Maritimo' ? 'rgba(59, 130, 246, 0.1)' : p.tipo === 'Aereo' ? 'rgba(16, 185, 129, 0.1)' : 'rgba(245, 158, 11, 0.1)',
                        color: p.tipo === 'Maritimo' ? '#60a5fa' : p.tipo === 'Aereo' ? '#34d399' : '#fbbf24',
                        padding: '4px 8px',
                        borderRadius: '6px',
                        fontSize: '0.75rem',
                        fontWeight: '600'
                      }}>
                        {p.tipo}
                      </span>
                    </td>
                    <td style={{ paddingRight: '24px', textAlign: 'right' }}>
                      <div style={{ display: 'flex', gap: '8px', justifyContent: 'flex-end' }}>
                        <button className="btn-icon" onClick={() => handleEditPorto(p)} title="Editar"><Edit2 size={16} /></button>
                        <button className="btn-icon btn-icon-danger" onClick={() => handleDeletePorto(p.id)} title="Excluir"><Trash2 size={16} /></button>
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {showModal && (
        <div className="modal-overlay">
          <div className="modal-content card" style={{ maxWidth: '500px', width: '100%' }}>
            <div className="modal-header">
              <h3 className="modal-title">{formData.id ? 'Editar Porto' : 'Novo Porto'}</h3>
              <button className="btn-close" onClick={() => setShowModal(false)}><X size={20} /></button>
            </div>
            <form onSubmit={handleSave}>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '16px', marginBottom: '24px' }}>
                <div style={{ display: 'flex', gap: '16px' }}>
                  <div style={{ flex: 1 }}>
                    <label className="label">Sigla (IATA/UN)</label>
                    <input
                      type="text"
                      className="input-text"
                      maxLength={10}
                      value={formData.sigla}
                      onChange={(e) => setFormData({ ...formData, sigla: e.target.value.toUpperCase() })}
                      required
                      placeholder="ex: SHA, PNG"
                    />
                  </div>
                  <div style={{ flex: 2 }}>
                    <label className="label">Nome do Porto</label>
                    <input
                      type="text"
                      className="input-text"
                      maxLength={100}
                      value={formData.nome}
                      onChange={(e) => setFormData({ ...formData, nome: e.target.value })}
                      required
                      placeholder="ex: Port of Shanghai"
                    />
                  </div>
                </div>

                <div style={{ display: 'flex', gap: '16px' }}>
                  <div style={{ flex: 1 }}>
                    <label className="label">País</label>
                    <input
                      type="text"
                      className="input-text"
                      maxLength={100}
                      value={formData.pais}
                      onChange={(e) => setFormData({ ...formData, pais: e.target.value })}
                      required
                      placeholder="ex: China"
                    />
                  </div>
                  <div style={{ flex: 1 }}>
                    <label className="label">Tipo de Porto</label>
                    <select
                      className="input-text"
                      value={formData.tipo}
                      onChange={(e) => setFormData({ ...formData, tipo: e.target.value })}
                      required
                    >
                      <option value="Maritimo">Marítimo</option>
                      <option value="Aereo">Aéreo</option>
                      <option value="Rodoviario">Rodoviário</option>
                    </select>
                  </div>
                </div>
              </div>

              <div className="modal-footer">
                <button type="button" className="btn btn-secondary" onClick={() => setShowModal(false)}>Cancelar</button>
                <button type="submit" className="btn btn-primary">
                  <Save size={18} />
                  <span>Salvar</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default PortosPage;
