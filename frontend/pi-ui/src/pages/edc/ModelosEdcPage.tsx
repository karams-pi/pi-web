import React, { useState, useEffect } from 'react';
import { Plus, Search, Edit2, Trash2, Save, X, Grid, Box } from 'lucide-react';

interface Produto {
  id: number;
  referencia: string;
  descricao: string;
  unidadeMedida?: string;
  pesoBruto: number;
}

interface ModeloEdc {
  id: number;
  codigo: string;
  nome: string;
  descricao?: string;
  idProduto: number;
  produto?: Produto;
}

const ModelosEdcPage: React.FC = () => {
  const [modelos, setModelos] = useState<ModeloEdc[]>([]);
  const [produtos, setProdutos] = useState<Produto[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [showModal, setShowModal] = useState(false);

  const [formData, setFormData] = useState({
    id: undefined as number | undefined,
    codigo: '',
    nome: '',
    descricao: '',
    idProduto: 0
  });

  useEffect(() => {
    fetchModelos();
    fetchProdutos();
  }, []);

  const fetchModelos = async () => {
    try {
      const response = await fetch('/api/edc/modelos');
      const data = await response.json();
      setModelos(data);
    } catch (error) { console.error(error); } 
    finally { setLoading(false); }
  };

  const fetchProdutos = async () => {
    try {
      const response = await fetch('/api/edc/produtos');
      const data = await response.json();
      setProdutos(data);
      if (data.length > 0) setFormData(prev => ({ ...prev, idProduto: data[0].id }));
    } catch (error) { console.error(error); }
  };

  const handleNewModelo = () => {
    setFormData({
      id: undefined,
      codigo: '',
      nome: '',
      descricao: '',
      idProduto: produtos[0]?.id || 0
    });
    setShowModal(true);
  };

  const handleEditModelo = (m: ModeloEdc) => {
    setFormData({
      id: m.id,
      codigo: m.codigo,
      nome: m.nome,
      descricao: m.descricao || '',
      idProduto: m.idProduto
    });
    setShowModal(true);
  };

  const handleDeleteModelo = async (id: number) => {
    if (window.confirm("Deseja realmente inativar este modelo comercial?")) {
      try {
        const response = await fetch(`/api/edc/modelos/${id}`, {
          method: 'DELETE'
        });
        if (response.ok) {
          fetchModelos();
        }
      } catch (error) { console.error(error); }
    }
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const isEdit = formData.id !== undefined;
      const url = isEdit ? `/api/edc/modelos/${formData.id}` : '/api/edc/modelos';
      const method = isEdit ? 'PUT' : 'POST';
      const response = await fetch(url, {
        method: method,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData)
      });
      if (response.ok) { fetchModelos(); setShowModal(false); }
    } catch (error) { console.error(error); }
  };

  return (
    <div className="animate-fadeIn">
      <div className="page-header">
        <div className="page-header-icon" style={{ background: 'rgba(59, 130, 246, 0.1)', color: '#3b82f6' }}>
          <Grid size={24} />
        </div>
        <div>
          <h1 className="page-title">Modelos de Produtos</h1>
          <p className="page-description">Gerencie as variações e modelos comerciais vinculados aos produtos técnicos.</p>
        </div>
        <div className="page-header-line" style={{ background: 'linear-gradient(90deg, #3b82f6, transparent)' }}></div>
        <button className="btn btn-primary" style={{ marginLeft: 'auto' }} onClick={handleNewModelo}>
          <Plus size={18} />
          <span>Novo Modelo</span>
        </button>
      </div>

      <div className="card">
        <div className="search-bar">
          <Search size={20} className="search-icon" />
          <input 
            type="text" 
            placeholder="Filtrar por código ou nome do modelo comercial..." 
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>

        <div className="table-responsive">
          <table className="table">
            <thead>
              <tr>
                <th>Código</th>
                <th>Nome do Modelo</th>
                <th>Descrição</th>
                <th>Produto Técnico Vinculado</th>
                <th>U.M.</th>
                <th>Peso Bruto</th>
                <th style={{ textAlign: 'right' }}>Ações</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr><td colSpan={7} style={{ textAlign: 'center' }}>Sincronizando modelos...</td></tr>
              ) : modelos.length === 0 ? (
                <tr><td colSpan={7} style={{ textAlign: 'center' }}>Nenhum modelo cadastrado.</td></tr>
              ) : modelos.filter(m => m.nome.toLowerCase().includes(searchTerm.toLowerCase()) || m.codigo.toLowerCase().includes(searchTerm.toLowerCase())).map(m => (
                <tr key={m.id}>
                  <td><span className="badge" style={{ backgroundColor: 'rgba(59, 130, 246, 0.15)', color: '#60a5fa', borderColor: 'rgba(59, 130, 246, 0.25)' }}>{m.codigo}</span></td>
                  <td><strong style={{ color: '#fff' }}>{m.nome}</strong></td>
                  <td style={{ maxWidth: '200px' }}>{m.descricao || '-'}</td>
                  <td>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                      <Box size={14} style={{ color: '#a78bfa' }} />
                      <span>{m.produto?.referencia} - {m.produto?.descricao}</span>
                    </div>
                  </td>
                  <td>
                    <span className="badge" style={{ backgroundColor: 'rgba(245, 158, 11, 0.15)', color: '#fbbf24' }}>
                      {m.produto?.unidadeMedida || 'UN'}
                    </span>
                  </td>
                  <td>
                    {m.produto ? (
                      <span>{m.produto.pesoBruto.toFixed(2)} {m.produto.unidadeMedida === 'T' ? 'T' : m.produto.unidadeMedida === 'UN' ? 'UN' : 'kg'}</span>
                    ) : '-'}
                  </td>
                  <td style={{ textAlign: 'right' }}>
                    <div className="action-buttons" style={{ justifyContent: 'flex-end' }}>
                      <button className="btn-icon" onClick={() => handleEditModelo(m)}><Edit2 size={16} /></button>
                      <button className="btn-icon btn-icon-danger" onClick={() => handleDeleteModelo(m.id)}><Trash2 size={16} /></button>
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
              <h3>{formData.id ? 'Editar Modelo Comercial' : 'Novo Modelo Comercial'}</h3>
              <button className="btn-icon" onClick={() => setShowModal(false)}><X size={20} /></button>
            </div>
            <div className="modal-body">
              <form onSubmit={handleSave}>
                <div className="grid grid-2">
                  <div className="form-group">
                    <label>Código do Modelo</label>
                    <input type="text" required placeholder="ex: MOD-X12" value={formData.codigo} onChange={e => setFormData({...formData, codigo: e.target.value})} />
                  </div>
                  <div className="form-group">
                    <label>Nome do Modelo Comercial</label>
                    <input type="text" required placeholder="ex: Modelo Standard" value={formData.nome} onChange={e => setFormData({...formData, nome: e.target.value})} />
                  </div>
                  <div className="form-group" style={{ gridColumn: 'span 2' }}>
                    <label>Produto Técnico Vinculado (Propriedades Logísticas)</label>
                    <select 
                      className="premium-select"
                      value={formData.idProduto} 
                      onChange={e => setFormData({...formData, idProduto: parseInt(e.target.value)})}
                      style={{
                        width: '100%',
                        padding: '10px',
                        borderRadius: '8px',
                        background: '#1e293b',
                        border: '1px solid #475569',
                        color: '#fff'
                      }}
                    >
                      {produtos.map(p => (
                        <option key={p.id} value={p.id}>
                          {p.referencia} - {p.descricao} ({p.unidadeMedida || 'UN'} | {p.pesoBruto.toFixed(2)} {p.unidadeMedida === 'T' ? 'T' : 'kg'})
                        </option>
                      ))}
                    </select>
                  </div>
                  <div className="form-group" style={{ gridColumn: 'span 2' }}>
                    <label>Descrição Detalhada / Observações</label>
                    <input type="text" value={formData.descricao} onChange={e => setFormData({...formData, descricao: e.target.value})} />
                  </div>
                </div>
                <div className="modal-footer" style={{ padding: '20px 0 0 0' }}>
                  <button type="button" className="btn btn-secondary" onClick={() => setShowModal(false)}>Descartar</button>
                  <button type="submit" className="btn btn-primary"><Save size={18} /><span>Salvar Modelo</span></button>
                </div>
              </form>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ModelosEdcPage;
