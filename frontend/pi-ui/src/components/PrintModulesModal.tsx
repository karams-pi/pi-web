import React, { useState } from 'react';

interface PrintModulesModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: (scope: 'screen' | 'all', currency: 'BRL' | 'EXW') => void;
  loading?: boolean;
}

export function PrintModulesModal({ isOpen, onClose, onConfirm, loading }: PrintModulesModalProps) {
  const [scope, setScope] = useState<'screen' | 'all'>('screen');
  const [currency, setCurrency] = useState<'BRL' | 'EXW'>('BRL');

  if (!isOpen) return null;

  return (
    <div className="modalOverlay" onMouseDown={onClose}>
      <div className="modalCard" style={{ maxWidth: 400 }} onMouseDown={(e) => e.stopPropagation()}>
        <div className="modalHeader">
          <h3 className="modalTitle">Imprimir Relatório de Módulos</h3>
          <button className="btn btn-sm" onClick={onClose} disabled={loading}>
            Fechar
          </button>
        </div>

        <div className="modalBody">
          <div className="field">
            <label className="label">O que imprimir?</label>
            <div style={{ display: 'flex', gap: 16, marginTop: 8 }}>
              <label style={{ display: 'flex', alignItems: 'center', gap: 6, cursor: 'pointer' }}>
                <input 
                  type="radio" 
                  name="scope" 
                  checked={scope === 'screen'} 
                  onChange={() => setScope('screen')}
                />
                Listagem Atual (Tela)
              </label>
              <label style={{ display: 'flex', alignItems: 'center', gap: 6, cursor: 'pointer' }}>
                <input 
                  type="radio" 
                  name="scope" 
                  checked={scope === 'all'} 
                  onChange={() => setScope('all')}
                />
                Todos os Registros
              </label>
            </div>
          </div>

          <div className="field" style={{ marginTop: 16 }}>
            <label className="label">Moeda / Preço</label>
            <div style={{ display: 'flex', gap: 16, marginTop: 8 }}>
              <label style={{ display: 'flex', alignItems: 'center', gap: 6, cursor: 'pointer' }}>
                <input 
                  type="radio" 
                  name="currency" 
                  checked={currency === 'BRL'} 
                  onChange={() => setCurrency('BRL')}
                />
                Reais (R$)
              </label>
              <label style={{ display: 'flex', alignItems: 'center', gap: 6, cursor: 'pointer' }}>
                <input 
                  type="radio" 
                  name="currency" 
                  checked={currency === 'EXW'} 
                  onChange={() => setCurrency('EXW')}
                />
                Dólar (EXW)
              </label>
            </div>
          </div>

          <div style={{ marginTop: 24, display: 'flex', justifyContent: 'flex-end', gap: 10 }}>
            <button className="btn btn-secondary" onClick={onClose} disabled={loading}>
              Cancelar
            </button>
            <button 
              className="btn btn-primary" 
              onClick={() => onConfirm(scope, currency)}
              disabled={loading}
            >
              {loading ? 'Gerando...' : 'Imprimir'}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
