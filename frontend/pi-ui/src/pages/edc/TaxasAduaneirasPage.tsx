import React, { useState, useEffect } from 'react';
import { Coins, Plus, Save, X, Trash2, TrendingUp, Edit2 } from 'lucide-react';

interface Taxa {
  id: number;
  nome: string;
  valorPadrao: number;
  moeda: string;
  tipo: string;
}

const TaxasAduaneirasPage: React.FC = () => {
  const [taxas, setTaxas] = useState<Taxa[]>([]);
  const [loading, setLoading] = useState(true);
  const [showModal, setShowModal] = useState(false);
  const [editingTaxa, setEditingTaxa] = useState<Taxa | null>(null);

  const [formData, setFormData] = useState({
    nome: '',
    valorPadrao: 0,
    moeda: 'BRL',
    tipo: 'Fixo'
  });

  useEffect(() => { fetchTaxas(); }, []);

  const fetchTaxas = async () => {
    try {
      const response = await fetch('/api/edc/taxasaduaneiras');
      const data = await response.json();
      setTaxas(data);
    } catch (error) { console.error(error); } 
    finally { setLoading(false); }
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    const method = editingTaxa ? 'PUT' : 'POST';
    const url = editingTaxa ? `/api/edc/taxasaduaneiras/${editingTaxa.id}` : '/api/edc/taxasaduaneiras';
    const payload = editingTaxa ? { ...formData, id: editingTaxa.id } : formData;

    try {
      const response = await fetch(url, {
        method,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });
      if (response.ok) {
        fetchTaxas();
        setShowModal(false);
      } else {
        alert("Erro ao salvar taxa.");
      }
    } catch (error) {
      console.error(error);
      alert("Erro ao salvar taxa.");
    }
  };

  const handleDelete = async (id: number) => {
    if (window.confirm("Deseja realmente excluir esta taxa?")) {
      try {
        const response = await fetch(`/api/edc/taxasaduaneiras/${id}`, {
          method: 'DELETE'
        });
        if (response.ok) {
          fetchTaxas();
        } else {
          alert("Erro ao excluir taxa.");
        }
      } catch (error) {
        console.error(error);
        alert("Erro ao excluir taxa.");
      }
    }
  };

  return (
    <div className="animate-fadeIn">
      <div className="page-header">
        <div className="page-header-icon" style={{ background: 'rgba(234, 179, 8, 0.1)', color: '#eab308' }}>
          <Coins size={24} />
        </div>
        <div>
          <h1 className="page-title">Taxas Aduaneiras</h1>
          <p className="page-description">Configure os valores padrão de Siscomex, Capatazia e outras despesas portuárias.</p>
        </div>
        <div className="page-header-line" style={{ background: 'linear-gradient(90deg, #eab308, transparent)' }}></div>
        <button 
          className="btn btn-primary" 
          style={{ marginLeft: 'auto' }} 
          onClick={() => {
            setEditingTaxa(null);
            setFormData({ nome: '', valorPadrao: 0, moeda: 'BRL', tipo: 'Fixo' });
            setShowModal(true);
          }}
        >
          <Plus size={18} />
          <span>Nova Taxa</span>
        </button>
      </div>

      <div className="card">
        <div className="table-responsive">
          <table className="table">
            <thead>
              <tr>
                <th>Descrição da Taxa / Despesa</th>
                <th>Valor Base</th>
                <th>Moeda</th>
                <th>Tipo de Rateio</th>
                <th style={{ textAlign: 'right' }}>Ações</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr><td colSpan={5} style={{ textAlign: 'center' }}>Sincronizando tabelas...</td></tr>
              ) : taxas.length === 0 ? (
                <tr><td colSpan={5} style={{ textAlign: 'center' }}>Nenhuma taxa cadastrada.</td></tr>
              ) : taxas.map(t => (
                <tr key={t.id}>
                  <td>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                      <TrendingUp size={16} style={{ color: 'var(--muted)' }} />
                      <strong style={{ color: '#fff' }}>{t.nome}</strong>
                    </div>
                  </td>
                  <td>
                    <span style={{ fontSize: '1.1rem', fontWeight: '600' }}>
                      {t.tipo === 'Percentual' ? `${(t.valorPadrao * 100).toFixed(2)}%` : t.valorPadrao.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}
                    </span>
                  </td>
                  <td><span className="badge">{t.moeda}</span></td>
                  <td><span className="badge" style={{ background: 'rgba(255,255,255,0.05)' }}>{t.tipo}</span></td>
                  <td style={{ textAlign: 'right' }}>
                    <div className="action-buttons" style={{ justifyContent: 'flex-end' }}>
                      <button 
                        className="btn-icon" 
                        onClick={() => {
                          setEditingTaxa(t);
                          setFormData({
                            nome: t.nome,
                            valorPadrao: t.valorPadrao,
                            moeda: t.moeda,
                            tipo: t.tipo
                          });
                          setShowModal(true);
                        }}
                        title="Editar Taxa"
                      >
                        <Edit2 size={16} />
                      </button>
                      <button 
                        className="btn-icon btn-icon-danger" 
                        onClick={() => handleDelete(t.id)}
                        title="Excluir Taxa"
                      >
                        <Trash2 size={16} />
                      </button>
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
              <h3><Coins size={20} style={{ marginRight: '10px', verticalAlign: 'middle' }} /> {editingTaxa ? 'Editar Taxa Aduaneira' : 'Nova Taxa Aduaneira'}</h3>
              <button className="btn-icon" onClick={() => setShowModal(false)}><X size={20} /></button>
            </div>
            <div className="modal-body">
              <form onSubmit={handleSave}>
                <div className="grid grid-2">
                  <div className="form-group" style={{ gridColumn: 'span 2' }}>
                    <label>Descrição da Taxa / Despesa</label>
                    <input type="text" required value={formData.nome} onChange={e => setFormData({...formData, nome: e.target.value})} placeholder="Ex: Capatazia, Siscomex, Desembaraço" />
                  </div>
                  <div className="form-group">
                    <label>Tipo de Rateio</label>
                    <select className="premium-select" value={formData.tipo} onChange={e => setFormData({...formData, tipo: e.target.value})}>
                      <option value="Fixo">Fixo</option>
                      <option value="Percentual">Percentual</option>
                    </select>
                  </div>
                  <div className="form-group">
                    <label>Moeda</label>
                    <select className="premium-select" value={formData.moeda} onChange={e => setFormData({...formData, moeda: e.target.value})}>
                      <option value="BRL">BRL (R$)</option>
                      <option value="USD">USD ($)</option>
                    </select>
                  </div>
                  <div className="form-group" style={{ gridColumn: 'span 2' }}>
                    <label>{formData.tipo === 'Percentual' ? 'Valor Base (%)' : 'Valor Base'}</label>
                    <input 
                      type="number" 
                      step="0.0001" 
                      required
                      value={formData.tipo === 'Percentual' ? formData.valorPadrao * 100 : formData.valorPadrao} 
                      onChange={e => {
                        const val = parseFloat(e.target.value) || 0;
                        setFormData({
                          ...formData,
                          valorPadrao: formData.tipo === 'Percentual' ? val / 100 : val
                        });
                      }} 
                      placeholder={formData.tipo === 'Percentual' ? "Ex: 2.5 para 2.5%" : "Ex: 150.00"}
                    />
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

export default TaxasAduaneirasPage;
