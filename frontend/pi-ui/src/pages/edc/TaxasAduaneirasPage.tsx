
import React, { useState, useEffect } from 'react';
import { Coins, Plus, Save, X, Trash2, TrendingUp } from 'lucide-react';

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

  useEffect(() => { fetchTaxas(); }, []);

  const fetchTaxas = async () => {
    try {
      const response = await fetch('/api/edc/taxasaduaneiras');
      const data = await response.json();
      setTaxas(data);
    } catch (error) { console.error(error); } 
    finally { setLoading(false); }
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
        <button className="btn btn-primary" style={{ marginLeft: 'auto' }}>
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

export default TaxasAduaneirasPage;
