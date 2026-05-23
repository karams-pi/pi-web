import React, { useState, useEffect } from 'react';
import { Plus, Search, Edit2, Trash2, Save, X, Package } from 'lucide-react';

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
  unidadeMedida?: string;
}

const ProdutosEdcPage: React.FC = () => {
  const [produtos, setProdutos] = useState<ProdutoEdc[]>([]);
  const [ncms, setNcms] = useState<Ncm[]>([]);
  const [productModels, setProductModels] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [loadingModels, setLoadingModels] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [showModelModal, setShowModelModal] = useState(false);

  const [formData, setFormData] = useState({
    id: undefined as number | undefined,
    referencia: '',
    descricao: '',
    idNcm: 0,
    pesoLiquido: 0,
    pesoBruto: 0,
    cubagemM3: 0,
    precoFobBase: 0,
    unidadeMedida: 'UN'
  });

  const [modelFormData, setModelFormData] = useState({
    id: undefined as number | undefined,
    codigo: '',
    nome: '',
    descricao: '',
    idProduto: 0
  });

  useEffect(() => {
    fetchProdutos();
    fetchNcms();
    fetchProductModels();
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

  const fetchProductModels = async () => {
    setLoadingModels(true);
    try {
      const response = await fetch('/api/edc/modelos');
      const data = await response.json();
      setProductModels(data);
    } catch (error) { console.error(error); }
    finally { setLoadingModels(false); }
  };

  const handleNewProduto = () => {
    setFormData({
      id: undefined,
      referencia: '',
      descricao: '',
      idNcm: ncms[0]?.id || 0,
      pesoLiquido: 0,
      pesoBruto: 0,
      cubagemM3: 0,
      precoFobBase: 0,
      unidadeMedida: 'UN'
    });
    setShowModal(true);
  };

  const handleEditProduto = (p: ProdutoEdc) => {
    setFormData({
      id: p.id,
      referencia: p.referencia,
      descricao: p.descricao,
      idNcm: p.idNcm,
      pesoLiquido: p.pesoLiquido || 0,
      pesoBruto: p.pesoBruto || 0,
      cubagemM3: p.cubagemM3 || 0,
      precoFobBase: p.precoFobBase || 0,
      unidadeMedida: p.unidadeMedida || 'UN'
    });
    setShowModal(true);
  };

  const handleDeleteProduto = async (id: number) => {
    if (window.confirm("Deseja realmente inativar este produto?")) {
      try {
        const response = await fetch(`/api/edc/produtos/${id}`, {
          method: 'DELETE'
        });
        if (response.ok) {
          fetchProdutos();
        }
      } catch (error) { console.error(error); }
    }
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const isEdit = formData.id !== undefined;
      const url = isEdit ? `/api/edc/produtos/${formData.id}` : '/api/edc/produtos';
      const method = isEdit ? 'PUT' : 'POST';
      const response = await fetch(url, {
        method: method,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData)
      });
      if (response.ok) { 
        fetchProdutos(); 
        fetchProductModels(); // Refresh auto-created default models
        setShowModal(false); 
      }
    } catch (error) { console.error(error); }
  };

  // Sub-Model CRUD Handlers inside Product Modal
  const handleAddSubModel = (productId: number) => {
    setModelFormData({
      id: undefined,
      codigo: '',
      nome: '',
      descricao: '',
      idProduto: productId
    });
    setShowModelModal(true);
  };

  const handleEditSubModel = (m: any) => {
    setModelFormData({
      id: m.id,
      codigo: m.codigo,
      nome: m.nome,
      descricao: m.descricao || '',
      idProduto: m.idProduto
    });
    setShowModelModal(true);
  };

  const handleDeleteSubModel = async (id: number) => {
    if (window.confirm("Deseja realmente inativar este modelo comercial?")) {
      try {
        const response = await fetch(`/api/edc/modelos/${id}`, {
          method: 'DELETE'
        });
        if (response.ok) {
          fetchProductModels();
        }
      } catch (error) { console.error(error); }
    }
  };

  const handleSaveSubModel = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const isEdit = modelFormData.id !== undefined;
      const url = isEdit ? `/api/edc/modelos/${modelFormData.id}` : '/api/edc/modelos';
      const method = isEdit ? 'PUT' : 'POST';
      const response = await fetch(url, {
        method: method,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(modelFormData)
      });
      if (response.ok) { 
        fetchProductModels(); 
        setShowModelModal(false); 
      }
    } catch (error) { console.error(error); }
  };

  const filteredModels = productModels.filter(m => m.idProduto === formData.id);

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
        <button className="btn btn-primary" style={{ marginLeft: 'auto' }} onClick={handleNewProduto}>
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
                <th>U.M.</th>
                <th>Peso Bruto</th>
                <th>Volume (m³)</th>
                <th style={{ textAlign: 'right' }}>Ações</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr><td colSpan={7} style={{ textAlign: 'center' }}>Sincronizando catálogo...</td></tr>
              ) : produtos.length === 0 ? (
                <tr><td colSpan={7} style={{ textAlign: 'center' }}>Nenhum produto cadastrado.</td></tr>
              ) : produtos.filter(p => p.referencia.toLowerCase().includes(searchTerm.toLowerCase())).map(p => (
                <tr key={p.id}>
                  <td><strong style={{ color: '#fff' }}>{p.referencia}</strong></td>
                  <td style={{ maxWidth: '350px' }}>{p.descricao}</td>
                  <td><span className="badge">{p.ncm?.codigo || '-'}</span></td>
                  <td><span className="badge" style={{ backgroundColor: 'rgba(245, 158, 11, 0.15)', color: '#fbbf24' }}>{p.unidadeMedida || 'UN'}</span></td>
                  <td>
                    <div style={{ fontWeight: '500' }}>
                      {p.pesoBruto.toFixed(2)} {p.unidadeMedida === 'T' ? 'T' : p.unidadeMedida === 'UN' ? 'UN' : 'kg'}
                    </div>
                  </td>
                  <td>{p.cubagemM3.toFixed(4)}</td>
                  <td style={{ textAlign: 'right' }}>
                    <div className="action-buttons" style={{ justifyContent: 'flex-end' }}>
                      <button className="btn-icon" onClick={() => handleEditProduto(p)}><Edit2 size={16} /></button>
                      <button className="btn-icon btn-icon-danger" onClick={() => handleDeleteProduto(p.id)}><Trash2 size={16} /></button>
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
          <div className="modal-content" style={{ maxWidth: '700px', maxHeight: '90vh', overflowY: 'auto' }}>
            <div className="modal-header">
              <h3>{formData.id ? 'Editar Produto EDC' : 'Novo Produto EDC'}</h3>
              <button className="btn-icon" onClick={() => setShowModal(false)}><X size={20} /></button>
            </div>
            <div className="modal-body">
              <form onSubmit={handleSave}>
                <div className="grid grid-2">
                  <div className="form-group" style={{ gridColumn: 'span 2' }}>
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
                    <label>Unidade de Medida</label>
                    <select 
                      className="premium-select"
                      value={formData.unidadeMedida} 
                      onChange={e => setFormData({...formData, unidadeMedida: e.target.value})}
                      style={{
                        width: '100%',
                        padding: '10px',
                        borderRadius: '8px',
                        background: '#1e293b',
                        border: '1px solid #475569',
                        color: '#fff'
                      }}
                    >
                      <option value="UN">UN (Unidade)</option>
                      <option value="KG">KG (Quilograma)</option>
                      <option value="T">T (Tonelada)</option>
                    </select>
                  </div>
                  <div className="form-group">
                    <label>Peso Bruto ({formData.unidadeMedida === 'T' ? 'T' : formData.unidadeMedida === 'UN' ? 'UN' : 'kg'})</label>
                    <input type="number" step="0.001" value={formData.pesoBruto} onChange={e => setFormData({...formData, pesoBruto: parseFloat(e.target.value)})} />
                  </div>
                  <div className="form-group" style={{ gridColumn: 'span 2' }}>
                    <label>Volume Total (m³)</label>
                    <input type="number" step="0.0001" value={formData.cubagemM3} onChange={e => setFormData({...formData, cubagemM3: parseFloat(e.target.value)})} />
                  </div>
                </div>

                {/* Sub-Models Section in Edit Mode */}
                {formData.id !== undefined && (
                  <div style={{ marginTop: '30px', borderTop: '1px solid rgba(255,255,255,0.1)', paddingTop: '20px' }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '16px' }}>
                      <h4 style={{ margin: 0, color: '#fff', fontSize: '1.1rem' }}>Modelos Comerciais Vinculados</h4>
                      <button 
                        type="button" 
                        className="btn btn-secondary btn-sm" 
                        onClick={() => handleAddSubModel(formData.id!)}
                        style={{ padding: '6px 12px', fontSize: '0.8rem', display: 'flex', alignItems: 'center', gap: '6px' }}
                      >
                        <Plus size={14} /> Adicionar Modelo
                      </button>
                    </div>

                    {loadingModels ? (
                      <p style={{ fontSize: '0.9rem', opacity: 0.5, padding: '10px 0' }}>Carregando modelos comerciais...</p>
                    ) : filteredModels.length === 0 ? (
                      <div style={{ padding: '20px', textAlign: 'center', background: 'rgba(255,255,255,0.02)', borderRadius: '8px', border: '1px dashed rgba(255,255,255,0.1)' }}>
                        <p style={{ fontSize: '0.85rem', opacity: 0.5, margin: 0 }}>Nenhum modelo customizado cadastrado para este produto.</p>
                      </div>
                    ) : (
                      <div className="table-responsive" style={{ maxHeight: '250px', overflowY: 'auto', background: 'rgba(255,255,255,0.01)', borderRadius: '8px', border: '1px solid rgba(255,255,255,0.05)' }}>
                        <table className="table" style={{ fontSize: '0.85rem', margin: 0 }}>
                          <thead>
                            <tr style={{ background: 'rgba(255,255,255,0.02)' }}>
                              <th style={{ padding: '10px' }}>Código</th>
                              <th style={{ padding: '10px' }}>Nome do Modelo</th>
                              <th style={{ padding: '10px' }}>Descrição</th>
                              <th style={{ padding: '10px', textAlign: 'right' }}>Ações</th>
                            </tr>
                          </thead>
                          <tbody>
                            {filteredModels.map(m => (
                              <tr key={m.id}>
                                <td style={{ padding: '10px' }}><span className="badge" style={{ backgroundColor: 'rgba(59, 130, 246, 0.15)', color: '#60a5fa', borderColor: 'rgba(59, 130, 246, 0.2)' }}>{m.codigo}</span></td>
                                <td style={{ padding: '10px' }}><strong style={{ color: '#fff' }}>{m.nome}</strong></td>
                                <td style={{ padding: '10px', maxWidth: '180px', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{m.descricao || '-'}</td>
                                <td style={{ padding: '10px', textAlign: 'right' }}>
                                  <div className="action-buttons" style={{ justifyContent: 'flex-end', gap: '4px' }}>
                                    <button type="button" className="btn-icon" onClick={() => handleEditSubModel(m)}><Edit2 size={14} /></button>
                                    <button type="button" className="btn-icon btn-icon-danger" onClick={() => handleDeleteSubModel(m.id)}><Trash2 size={14} /></button>
                                  </div>
                                </td>
                              </tr>
                            ))}
                          </tbody>
                        </table>
                      </div>
                    )}
                  </div>
                )}

                <div className="modal-footer" style={{ padding: '20px 0 0 0', marginTop: '20px', borderTop: '1px solid rgba(255,255,255,0.05)' }}>
                  <button type="button" className="btn btn-secondary" onClick={() => setShowModal(false)}>Descartar</button>
                  <button type="submit" className="btn btn-primary"><Save size={18} /><span>Salvar Produto</span></button>
                </div>
              </form>
            </div>
          </div>
        </div>
      )}

      {/* Sub-Model Add/Edit Modal */}
      {showModelModal && (
        <div className="modal-overlay" style={{ zIndex: 1100 }}>
          <div className="modal-content" style={{ maxWidth: '500px' }}>
            <div className="modal-header">
              <h3>{modelFormData.id ? 'Editar Modelo Comercial' : 'Novo Modelo Comercial'}</h3>
              <button className="btn-icon" onClick={() => setShowModelModal(false)}><X size={20} /></button>
            </div>
            <div className="modal-body">
              <form onSubmit={handleSaveSubModel}>
                <div className="form-stack">
                  <div className="form-group">
                    <label>Código do Modelo</label>
                    <input type="text" required placeholder="ex: MOD-X12" value={modelFormData.codigo} onChange={e => setModelFormData({...modelFormData, codigo: e.target.value})} />
                  </div>
                  <div className="form-group">
                    <label>Nome do Modelo Comercial</label>
                    <input type="text" required placeholder="ex: Modelo Standard" value={modelFormData.nome} onChange={e => setModelFormData({...modelFormData, nome: e.target.value})} />
                  </div>
                  <div className="form-group">
                    <label>Descrição / Detalhes</label>
                    <input type="text" placeholder="ex: Modelo padrão ou observações" value={modelFormData.descricao} onChange={e => setModelFormData({...modelFormData, descricao: e.target.value})} />
                  </div>
                </div>
                <div className="modal-footer" style={{ padding: '20px 0 0 0', marginTop: '20px' }}>
                  <button type="button" className="btn btn-secondary" onClick={() => setShowModelModal(false)}>Cancelar</button>
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

export default ProdutosEdcPage;
