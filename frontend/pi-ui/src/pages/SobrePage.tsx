import { useState, useEffect } from 'react';
import { getVersion, type VersionInfo } from '../api/version';
import './ClientesPage.css';

export default function SobrePage() {
  const [info, setInfo] = useState<VersionInfo | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    getVersion()
      .then(setInfo)
      .catch(() => {})
      .finally(() => setLoading(false));
  }, []);

  const formatDate = (iso: string) => {
    try {
      return new Date(iso).toLocaleDateString('pt-BR', {
        day: '2-digit', month: '2-digit', year: 'numeric',
      });
    } catch {
      return iso;
    }
  };

  // Strip git hash from version string (e.g. "1.0.0+abc123..." → "1.0.0")
  const cleanVersion = (v: string) => v.split('+')[0];

  return (
    <div className="cl-page">
      <h1 className="cl-title" style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
        <span style={{ fontSize: '28px' }}>ℹ️</span> Sobre
      </h1>

      {loading && (
        <div className="cl-card" style={{ textAlign: 'center', padding: '40px' }}>
          <p style={{ color: 'var(--muted)' }}>Carregando...</p>
        </div>
      )}

      {info && (
        <div style={{
          background: 'var(--card)',
          border: '1px solid var(--line)',
          borderRadius: '12px',
          padding: '32px',
          maxWidth: '500px',
          margin: '0 auto',
        }}>
          {/* App name */}
          <div style={{ textAlign: 'center', marginBottom: '28px' }}>
            <h2 style={{ margin: '0 0 4px 0', fontSize: '28px', color: 'var(--text)', fontWeight: 800 }}>
              PI Web
            </h2>
            <p style={{ margin: 0, color: 'var(--muted)', fontSize: '14px' }}>
              Sistema de Gerenciamento de Proforma Invoices
            </p>
          </div>

          {/* Current version */}
          <div style={{
            background: 'rgba(59,130,246,0.08)',
            border: '1px solid rgba(59,130,246,0.2)',
            borderRadius: '10px',
            padding: '16px 20px',
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
            marginBottom: '24px',
          }}>
            <div>
              <div style={{ color: 'var(--muted)', fontSize: '11px', textTransform: 'uppercase', letterSpacing: '0.5px' }}>
                Versão Atual
              </div>
              <div style={{ color: '#60a5fa', fontSize: '22px', fontWeight: 700 }}>
                v{cleanVersion(info.app.version)}
              </div>
              {info.history && info.history.length > 0 && (
                <div style={{ color: 'var(--muted)', fontSize: '12px', marginTop: '2px' }}>
                  {formatDate(info.history[0].data)}
                </div>
              )}
            </div>
            <div style={{
              display: 'inline-block',
              padding: '4px 12px',
              borderRadius: '20px',
              fontSize: '12px',
              fontWeight: 700,
              textTransform: 'uppercase',
              background: info.app.environment === 'Production' ? 'rgba(245,158,11,0.15)' : 'rgba(139,92,246,0.15)',
              color: info.app.environment === 'Production' ? '#f59e0b' : '#8b5cf6',
              border: `1px solid ${info.app.environment === 'Production' ? 'rgba(245,158,11,0.3)' : 'rgba(139,92,246,0.3)'}`,
            }}>
              {info.app.environment}
            </div>
          </div>

          {/* Version history */}
          {info.history && info.history.length > 0 && (
            <>
              <div style={{ color: 'var(--muted)', fontSize: '12px', textTransform: 'uppercase', letterSpacing: '0.5px', marginBottom: '12px' }}>
                Histórico
              </div>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
                {info.history.map((entry, index) => (
                  <div key={index} style={{
                    display: 'flex',
                    justifyContent: 'space-between',
                    alignItems: 'center',
                    padding: '10px 14px',
                    borderRadius: '8px',
                    background: index === 0 ? 'rgba(59,130,246,0.06)' : 'rgba(0,0,0,0.15)',
                    border: `1px solid ${index === 0 ? 'rgba(59,130,246,0.15)' : 'var(--line)'}`,
                  }}>
                    <span style={{
                      fontWeight: 600,
                      fontSize: '14px',
                      color: index === 0 ? '#60a5fa' : 'var(--text)',
                    }}>
                      v{cleanVersion(entry.versao)}
                    </span>
                    <span style={{ color: 'var(--muted)', fontSize: '13px' }}>
                      {formatDate(entry.data)}
                    </span>
                  </div>
                ))}
              </div>
            </>
          )}

          {/* Credits */}
          <div style={{
            marginTop: '28px',
            paddingTop: '16px',
            borderTop: '1px solid var(--line)',
            textAlign: 'center',
          }}>
            <p style={{ margin: '0 0 2px 0', color: 'var(--text)', fontWeight: 600, fontSize: '13px' }}>
              Desenvolvido por Paulo Roberto Schmitz Takeda
            </p>
            <p style={{ margin: 0, color: 'var(--muted)', fontSize: '12px' }}>
              📧 paulo.takeda@gmail.com &nbsp;|&nbsp; 📱 (43) 9 9974-1880
            </p>
          </div>
        </div>
      )}
    </div>
  );
}
