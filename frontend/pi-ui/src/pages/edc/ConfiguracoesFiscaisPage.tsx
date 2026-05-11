
import React, { useState, useEffect } from 'react';
import { ShieldCheck, Plus, Save, Trash2, CheckCircle2, AlertCircle } from 'lucide-react';

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

  useEffect(() => { fetchConfigs(); }, []);

  const fetchConfigs = async () => {
    try {
      const response = await fetch('/api/edc/configuracoesfiscais');
      const data = await response.json();
      setConfigs(data);
    } catch (error) { console.error(error); } 
    finally { setLoading(false); }
  };

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
        <button className="btn btn-primary" style={{ marginLeft: 'auto' }}>
          <Plus size={18} />
          <span>Nova Regra UF</span>
        </button>
      </div>

      <div className="card">
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
              ) : configs.map(c => (
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

export default ConfiguracoesFiscaisPage;
