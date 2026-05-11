
import React, { useState, useEffect } from 'react';
import { 
  ListChecks, Plus, Search, FileText, 
  Download, Trash2, Edit2, Calendar, 
  User, Globe, ArrowRight, ExternalLink 
} from 'lucide-react';
import { useNavigate } from 'react-router-dom';

interface Simulacao {
  id: number;
  numeroReferencia: string;
  dataEstudo: string;
  importador?: { razaoSocial: string };
  exportador?: { nome: string };
  status: string;
  cotacaoDolar: number;
}

const EstudosEdcPage: React.FC = () => {
  const navigate = useNavigate();
  const [estudos, setEstudos] = useState<Simulacao[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');

  useEffect(() => { fetchEstudos(); }, []);

  const fetchEstudos = async () => {
    try {
      const response = await fetch('/api/edc/simulacoes');
      const data = await response.json();
      setEstudos(data);
    } catch (error) { console.error(error); } 
    finally { setLoading(false); }
  };

  const getStatusBadge = (status: string) => {
    switch (status.toLowerCase()) {
      case 'aprovado': return <span className="badge badge-success">Aprovado</span>;
      case 'rascunho': return <span className="badge badge-warning">Rascunho</span>;
      case 'cancelado': return <span className="badge badge-danger">Cancelado</span>;
      default: return <span className="badge">{status}</span>;
    }
  };

  return (
    <div className="animate-fadeIn">
      <div className="page-header">
        <div className="page-header-icon" style={{ background: 'rgba(16, 185, 129, 0.1)', color: '#10b981' }}>
          <ListChecks size={24} />
        </div>
        <div>
          <h1 className="page-title">Estudos de Custo (EDC)</h1>
          <p className="page-description">Histórico de simulações de nacionalização e inteligência aduaneira.</p>
        </div>
        <div className="page-header-line" style={{ background: 'linear-gradient(90deg, #10b981, transparent)' }}></div>
        <button className="btn btn-primary" style={{ marginLeft: 'auto' }} onClick={() => navigate('/edc/estudos/novo')}>
          <Plus size={18} />
          <span>Novo Estudo</span>
        </button>
      </div>

      <div className="card">
        <div className="search-bar">
          <Search size={20} className="search-icon" />
          <input 
            type="text" 
            placeholder="Filtrar estudos por referência ou parceiro..." 
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>

        <div className="table-responsive">
          <table className="table">
            <thead>
              <tr>
                <th>Referência</th>
                <th>Parceiros (Imp/Exp)</th>
                <th>Data Criação</th>
                <th>Câmbio Base</th>
                <th>Status</th>
                <th style={{ textAlign: 'right' }}>Ações</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr><td colSpan={6} style={{ textAlign: 'center' }}>Carregando simulações...</td></tr>
              ) : estudos.length === 0 ? (
                <tr><td colSpan={6} style={{ textAlign: 'center', padding: '40px' }}>
                  <div style={{ opacity: 0.5 }}>
                    <FileText size={48} style={{ marginBottom: '12px' }} />
                    <p>Nenhuma simulação encontrada. Comece criando um novo estudo.</p>
                  </div>
                </td></tr>
              ) : estudos.filter(e => e.numeroReferencia.toLowerCase().includes(searchTerm.toLowerCase())).map(e => (
                <tr key={e.id}>
                  <td>
                    <div style={{ display: 'flex', flexDirection: 'column' }}>
                      <strong style={{ color: '#fff', fontSize: '1rem' }}>{e.numeroReferencia}</strong>
                      <span style={{ fontSize: '0.75rem', color: 'var(--muted)' }}>ID: #{e.id}</span>
                    </div>
                  </td>
                  <td>
                    <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
                      <div style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '0.85rem' }}>
                        <User size={12} style={{ color: 'var(--primary)' }} />
                        <span>{e.importador?.razaoSocial || 'Importador não definido'}</span>
                      </div>
                      <div style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '0.85rem', opacity: 0.7 }}>
                        <Globe size={12} />
                        <span>{e.exportador?.nome || 'Exportador não definido'}</span>
                      </div>
                    </div>
                  </td>
                  <td>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px', opacity: 0.8 }}>
                      <Calendar size={14} />
                      {new Date(e.dataEstudo).toLocaleDateString('pt-BR')}
                    </div>
                  </td>
                  <td>
                    <div style={{ fontWeight: '600' }}>
                      USD {e.cotacaoDolar.toFixed(4)}
                    </div>
                  </td>
                  <td>{getStatusBadge(e.status)}</td>
                  <td style={{ textAlign: 'right' }}>
                    <div className="action-buttons" style={{ justifyContent: 'flex-end' }}>
                      <button className="btn-icon" title="Ver Detalhes" onClick={() => navigate(`/edc/estudos/${e.id}`)}><ExternalLink size={16} /></button>
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
    </div>
  );
};

export default EstudosEdcPage;
