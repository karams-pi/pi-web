
import React from 'react';
import { 
  BarChart3, 
  FileStack, 
  Calculator, 
  Globe2, 
  Ship, 
  TrendingUp,
  ArrowRight,
  Building2,
  Plus
} from 'lucide-react';
import { useNavigate } from 'react-router-dom';

const EdcDashboard: React.FC = () => {
  const navigate = useNavigate();

  return (
    <div className="edc-dashboard animate-fadeIn">
      <div className="page-header">
        <div className="page-header-icon">
          <Calculator size={24} />
        </div>
        <div>
          <h1 className="page-title">Inteligência de Importação</h1>
          <p className="page-description">Bem-vindo ao módulo EDC. Gerencie seus custos e simulações aduaneiras.</p>
        </div>
        <div className="page-header-line"></div>
        <button className="btn btn-primary" style={{ marginLeft: 'auto' }} onClick={() => navigate('/edc/estudos/novo')}>
          <Plus size={18} />
          <span>Nova Simulação</span>
        </button>
      </div>

      <div className="stats-grid">
        <div className="stat-card">
          <div className="stat-icon" style={{ background: 'linear-gradient(135deg, rgba(79, 158, 255, 0.2) 0%, rgba(59, 130, 246, 0.2) 100%)', color: '#60a5fa' }}>
            <FileStack size={26} />
          </div>
          <div className="stat-info">
            <span className="stat-label">Simulações</span>
            <span className="stat-value">24</span>
            <span className="stat-change positive">
              <TrendingUp size={14} />
              <span>+12% vs mês anterior</span>
            </span>
          </div>
        </div>

        <div className="stat-card">
          <div className="stat-icon" style={{ background: 'linear-gradient(135deg, rgba(16, 185, 129, 0.2) 0%, rgba(5, 150, 105, 0.2) 100%)', color: '#34d399' }}>
            <Globe2 size={26} />
          </div>
          <div className="stat-info">
            <span className="stat-label">Países Ativos</span>
            <span className="stat-value">06</span>
            <span className="stat-change" style={{ color: 'var(--muted)' }}>Principais: China, IT, IN</span>
          </div>
        </div>

        <div className="stat-card">
          <div className="stat-icon" style={{ background: 'linear-gradient(135deg, rgba(245, 158, 11, 0.2) 0%, rgba(217, 119, 6, 0.2) 100%)', color: '#fbbf24' }}>
            <Ship size={26} />
          </div>
          <div className="stat-info">
            <span className="stat-label">Logística Ativa</span>
            <span className="stat-value">03</span>
            <span className="stat-change" style={{ color: 'var(--muted)' }}>Portos: PNG, SSZ, VIX</span>
          </div>
        </div>

        <div className="stat-card">
          <div className="stat-icon" style={{ background: 'linear-gradient(135deg, rgba(139, 92, 246, 0.2) 0%, rgba(124, 58, 237, 0.2) 100%)', color: '#a78bfa' }}>
            <BarChart3 size={26} />
          </div>
          <div className="stat-info">
            <span className="stat-label">NCMs Monitorados</span>
            <span className="stat-value">158</span>
            <span className="stat-change positive">Atualizado hoje</span>
          </div>
        </div>
      </div>

      <div className="grid grid-2">
        <div className="card">
          <div className="card-header">
            <h3 className="card-title">Estudos Recentes</h3>
            <button className="btn btn-icon" onClick={() => navigate('/edc/estudos')}><ArrowRight size={18} /></button>
          </div>
          <div className="table-responsive">
            <table className="table">
              <thead>
                <tr>
                  <th>Referência</th>
                  <th>Data</th>
                  <th>Status</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td><strong>EDC-2026-042</strong></td>
                  <td>10/05/2026</td>
                  <td><span className="badge badge-success">Finalizado</span></td>
                </tr>
                <tr>
                  <td><strong>EDC-2026-039</strong></td>
                  <td>08/05/2026</td>
                  <td><span className="badge badge-warning">Em Análise</span></td>
                </tr>
                <tr>
                  <td><strong>EDC-2026-035</strong></td>
                  <td>05/05/2026</td>
                  <td><span className="badge badge-success">Finalizado</span></td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <div className="card">
          <div className="card-header">
            <h3 className="card-title">Atalhos Rápidos</h3>
          </div>
          <div className="grid grid-2" style={{ gap: '1rem' }}>
            <button className="btn btn-secondary" style={{ height: '80px', justifyContent: 'center' }} onClick={() => navigate('/edc/ncms')}>
              <Calculator size={20} />
              <span>Ver NCMs</span>
            </button>
            <button className="btn btn-secondary" style={{ height: '80px', justifyContent: 'center' }} onClick={() => navigate('/edc/importadores')}>
              <Building2 size={20} />
              <span>Importadores</span>
            </button>
            <button className="btn btn-secondary" style={{ height: '80px', justifyContent: 'center' }} onClick={() => navigate('/edc/taxas')}>
              <TrendingUp size={20} />
              <span>Taxas Aduaneiras</span>
            </button>
            <button className="btn btn-secondary" style={{ height: '80px', justifyContent: 'center' }} onClick={() => navigate('/edc/produtos')}>
              <FileStack size={20} />
              <span>Produtos EDC</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default EdcDashboard;
