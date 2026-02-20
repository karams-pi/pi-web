import React, { useState, useEffect } from 'react';
import { importKarams, importKoyo, importFerguile, importLivintus } from '../api/importacao';
import { listFornecedores } from '../api/fornecedores';
import type { Fornecedor } from '../api/types';
import './ClientesPage.css';

export default function ImportacaoPage() {
  const [fornecedores, setFornecedores] = useState<Fornecedor[]>([]);
  const [selectedFornecedor, setSelectedFornecedor] = useState<number | ''>('');
  const [importType, setImportType] = useState<'karams' | 'koyo' | 'ferguile' | 'livintus'>('karams');
  const [file, setFile] = useState<File | null>(null);
  const [dtRevisao, setDtRevisao] = useState('');
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState<{ type: 'success' | 'error', text: string } | null>(null);

  useEffect(() => {
    loadFornecedores();
  }, []);

  async function loadFornecedores() {
    try {
      const res = await listFornecedores();
      setFornecedores(res);
    } catch (err) {
      console.error(err);
      setMessage({ type: 'error', text: 'Erro ao carregar fornecedores.' });
    }
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!selectedFornecedor) {
      setMessage({ type: 'error', text: 'Selecione um fornecedor.' });
      return;
    }
    if (!file) {
      setMessage({ type: 'error', text: 'Selecione um arquivo.' });
      return;
    }

    if (!dtRevisao) {
      setMessage({ type: 'error', text: 'Informe a data de revisão.' });
      return;
    }
    
    setLoading(true);
    setMessage(null);

    try {
      if (importType === 'karams') {
        await importKarams(file, Number(selectedFornecedor), dtRevisao);
        setMessage({ type: 'success', text: "Importação Karam's realizada com sucesso!" });
      } else if (importType === 'koyo') {
        await importKoyo(file, Number(selectedFornecedor), dtRevisao);
        setMessage({ type: 'success', text: "Importação Koyo realizada com sucesso!" });
      } else if (importType === 'ferguile') {
        await importFerguile(file, Number(selectedFornecedor), dtRevisao);
        setMessage({ type: 'success', text: "Importação Ferguile realizada com sucesso!" });
      } else if (importType === 'livintus') {
        await importLivintus(file, Number(selectedFornecedor), dtRevisao);
        setMessage({ type: 'success', text: "Importação Livintus realizada com sucesso!" });
      }
      
      setFile(null);
      // setDtRevisao(''); // Optional: clear date after import
    } catch (err: any) {
        const msg = err.response?.data?.message || err.message || 'Erro desconhecido na importação.';
        setMessage({ type: 'error', text: msg });
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="cl-page">
      <h1 className="cl-title">Importação de Tabela de Preços</h1>
      
      <div className="cl-card" style={{ maxWidth: '800px', margin: '0 auto', padding: '24px' }}>
        {message && (
          <div style={{ 
            padding: '12px', 
            marginBottom: '20px', 
            borderRadius: '8px', 
            border: message.type === 'success' ? '1px solid rgba(134, 239, 172, 0.25)' : '1px solid rgba(252, 165, 165, 0.25)',
            backgroundColor: message.type === 'success' ? 'rgba(134, 239, 172, 0.08)' : 'rgba(252, 165, 165, 0.08)',
            color: message.type === 'success' ? '#86efac' : '#fca5a5'
          }}>
            {message.text}
          </div>
        )}
        
        <form onSubmit={handleSubmit}>
          
          <div className="field" style={{ marginBottom: '24px' }}>
            <label className="label">Tipo de Importação</label>
            <div style={{ display: 'flex', gap: '10px', flexWrap: 'wrap' }}>
              <button
                type="button"
                className={`btn ${importType === 'karams' ? 'btn-primary' : 'btn-secondary'}`}
                onClick={() => setImportType('karams')}
                style={{ flex: 1, minWidth: '120px' }}
              >
                Karam's
              </button>
              <button
                type="button"
                className={`btn ${importType === 'koyo' ? 'btn-primary' : 'btn-secondary'}`}
                onClick={() => setImportType('koyo')}
                style={{ flex: 1, minWidth: '120px' }}
              >
                Koyo
              </button>
              <button
                type="button"
                className={`btn ${importType === 'ferguile' ? 'btn-primary' : 'btn-secondary'}`}
                onClick={() => setImportType('ferguile')}
                style={{ flex: 1, minWidth: '120px' }}
              >
                Ferguile
              </button>
              <button
                type="button"
                className={`btn ${importType === 'livintus' ? 'btn-primary' : 'btn-secondary'}`}
                onClick={() => setImportType('livintus')}
                style={{ flex: 1, minWidth: '120px' }}
              >
                Livintus
              </button>
            </div>
          </div>

          <div className="field" style={{ marginBottom: '16px' }}>
            <label className="label">Fornecedor</label>
            <select 
              className="cl-select"
              value={selectedFornecedor}
              onChange={e => setSelectedFornecedor(Number(e.target.value))}
              disabled={loading}
              style={{ width: '100%' }}
            >
              <option value="">Selecione...</option>
              {fornecedores.map(f => (
                <option key={f.id} value={f.id}>{f.nome}</option>
              ))}
            </select>
          </div>

          <div className="field" style={{ marginBottom: '24px' }}>
            <label className="label">Data de Revisão</label>
            <input 
              type="date" 
              className="cl-input"
              value={dtRevisao}
              onChange={e => setDtRevisao(e.target.value)}
              style={{ width: '100%' }}
              required
            />
          </div>

          <div className="field" style={{ marginBottom: '24px' }}>
            <label className="label">Arquivo (.xlsm, .xlsx)</label>
            <div style={{ 
                border: '1px dashed var(--line)', 
                borderRadius: '10px', 
                padding: '20px', 
                textAlign: 'center',
                background: 'rgba(255,255,255,0.02)'
            }}>
                <input 
                  type="file" 
                  accept=".xlsx, .xlsm"
                  onChange={e => setFile(e.target.files ? e.target.files[0] : null)}
                  disabled={loading}
                  style={{ color: 'var(--text)' }}
                />
            </div>
          </div>

          <button 
            type="submit" 
            className="btn btn-primary" 
            disabled={loading || !file || !selectedFornecedor || !dtRevisao}
            style={{ width: '100%', height: '48px', fontSize: '16px' }}
          >
            {loading ? 'Processando...' : 'Iniciar Importação'}
          </button>
        </form>

        <div style={{ marginTop: '32px', borderTop: '1px solid var(--line)', paddingTop: '24px' }}>
          <h3 style={{ marginTop: 0, fontSize: '18px', color: 'var(--text)', marginBottom: '16px' }}>
            Instruções de Layout ({importType === 'karams' ? "Karam's" : importType === 'koyo' ? 'Koyo' : importType === 'ferguile' ? 'Ferguile' : 'Livintus'})
          </h3>
          <p style={{ color: 'var(--muted)', marginBottom: '12px' }}>
            O arquivo Excel deve seguir a seguinte estrutura de colunas:
          </p>
          
          <div style={{ 
            background: 'rgba(0,0,0,0.2)', 
            padding: '16px', 
            borderRadius: '8px',
            fontSize: '14px',
            color: 'var(--text)'
          }}>
            {importType === 'karams' ? (
                <ul style={{ margin: 0, paddingLeft: '24px', lineHeight: '1.6' }}>
                    <li><strong>Aba</strong>: Nome da Categoria</li>
                    <li><strong>A</strong>: Modelo (Distinct)</li>
                    <li><strong>B</strong>: Descrição (Ignora "Descrição" ou vazio)</li>
                    <li><strong>C</strong>: Largura (Ignora "Larg" ou vazio)</li>
                    <li><strong>D</strong>: Profundidade (Ignora "Prof" ou vazio)</li>
                    <li><strong>F</strong>: Altura (Ignora "Altura" ou vazio)</li>
                    <li><strong>H a P</strong>: Tecidos G0 a G8</li>
                </ul>
            ) : importType === 'koyo' ? (
                <ul style={{ margin: 0, paddingLeft: '24px', lineHeight: '1.6' }}>
                    <li><strong>Aba</strong>: Nome da Categoria</li>
                    <li><strong>Col A</strong>: Modelo (Distinct)</li>
                    <li><strong>Col B</strong>: Descrição (Ignora "Descrição" / Vazio)</li>
                    <li><strong>Col C</strong>: Largura (Ignora "Larg" / Vazio)</li>
                    <li><strong>Col D</strong>: Profundidade (Ignora "Prof" / Vazio)</li>
                    <li><strong>Col E</strong>: Altura (Ignora "Altura" / Vazio)</li>
                    <li><strong>PA</strong>: Sempre Zero (0)</li>
                    <li><strong>Tecidos</strong>: Mapeamento Especial (G1..G10 nas colunas H..S)</li>
                </ul>
            ) : importType === 'ferguile' ? (
                <ul style={{ margin: 0, paddingLeft: '24px', lineHeight: '1.6' }}>
                    <li><strong>Categoria</strong>: Sempre "Ferguile" (criada automaticamente)</li>
                    <li><strong>Col B</strong>: Modelo (Marca) — Ignora "MODELO"</li>
                    <li><strong>Col F</strong>: Largura — Ignora "COMP (m)"</li>
                    <li><strong>Col G</strong>: Profundidade — Ignora "PROF (m)"</li>
                    <li><strong>Col H</strong>: Altura — Ignora "ALTURA (m)"</li>
                    <li><strong>Col L</strong>: Descrição do Módulo — Ignora "COMPOSIÇÃO"</li>
                    <li><strong>Col M</strong>: Nome do Tecido — Ignora "LINHA"</li>
                    <li><strong>Col N</strong>: Valor do Tecido por Módulo</li>
                </ul>
            ) : (
                <ul style={{ margin: 0, paddingLeft: '24px', lineHeight: '1.6' }}>
                    <li><strong>Categoria</strong>: Sempre "Livintus" (criada automaticamente)</li>
                    <li><strong>Col B</strong>: Modelo (Marca) — Ignora "MODELO"</li>
                    <li><strong>Col C</strong>: Largura — Ignora "COMP (m)"</li>
                    <li><strong>Col D</strong>: Altura — Ignora "ALTURA (m)"</li>
                    <li><strong>Col E</strong>: Profundidade — Ignora "PROF (m)"</li>
                    <li><strong>Col F</strong>: Descrição do Módulo — Ignora "COMPOSIÇÃO"</li>
                    <li><strong>Col G</strong>: Nome do Tecido — Ignora "LINHA"</li>
                    <li><strong>Col H</strong>: Valor do Tecido por Módulo</li>
                </ul>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
