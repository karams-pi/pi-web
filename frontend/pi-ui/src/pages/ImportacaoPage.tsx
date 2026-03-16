import React, { useState, useEffect } from 'react';
import { Download } from "lucide-react";
import PageHeader from "../components/PageHeader";
import { importKarams, importKoyo, importFerguile, importLivintus, sincronizarItens } from '../api/importacao';
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
  const [message, setMessage] = useState<{ type: 'success' | 'informative' | 'error', text: string } | null>(null);
  const [importResult, setImportResult] = useState<{ 
    totalFilas: number, 
    totalModulos: number, 
    discrepancias: string[], 
    itensImportados: Array<{
      linha: number,
      idModulo: number,
      idModuloTecido?: number,
      descricao: string,
      largura: number,
      altura: number,
      profundidade: number,
      larguraExcel: number,
      alturaExcel: number,
      profundidadeExcel: number,
      m3: number,
      tecido: string,
      valorTecido: number,
      valorExcel: number,
      status: string
    }>,
    sucesso: boolean 
  } | null>(null);
  const [showFullReport, setShowFullReport] = useState(false);
  const [isPreviewMode, setIsPreviewMode] = useState(false);

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

  async function handleSubmit(e: React.FormEvent, preview: boolean = false) {
    if (e) e.preventDefault();
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
    setIsPreviewMode(preview);

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
        const res = await importLivintus(file, Number(selectedFornecedor), dtRevisao, preview);
        setImportResult(res);
        if (preview) {
            setMessage({ type: 'informative', text: "Simulação concluída. Verifique os dados no relatório abaixo antes de confirmar." });
            setShowFullReport(true);
        } else {
            if (res.sucesso) {
                setMessage({ type: 'success', text: "Importação Livintus realizada e verificada com sucesso!" });
            } else {
                setMessage({ type: 'informative', text: "Importação concluída, mas foram encontradas divergências na verificação." });
            }
            setFile(null);
        }
      }
      
    } catch (err: any) {
        const msg = err.response?.data?.message || err.message || 'Erro desconhecido na importação.';
        setMessage({ type: 'error', text: msg });
    } finally {
      setLoading(false);
    }
  }

  async function handleSyncItems(itemsToSync: any[]) {
    if (!importResult) return;
    setLoading(true);
    try {
        const payload = {
            idFornecedor: Number(selectedFornecedor),
            itens: itemsToSync.map(item => ({
                linha: item.linha,
                idModulo: item.idModulo,
                idModuloTecido: item.idModuloTecido,
                largura: item.larguraExcel,
                altura: item.alturaExcel,
                profundidade: item.profundidadeExcel,
                tecido: item.tecido,
                valor: item.valorExcel
            }))
        };
        
        await sincronizarItens(payload);

        // Update local state to show synchronized items
        const updatedItens = importResult.itensImportados.map(item => {
            if (itemsToSync.some(s => s.linha === item.linha)) {
                return {
                    ...item,
                    largura: item.larguraExcel,
                    profundidade: item.profundidadeExcel,
                    altura: item.alturaExcel,
                    valorTecido: item.valorExcel,
                    status: 'OK'
                };
            }
            return item;
        });

        setImportResult({
            ...importResult,
            itensImportados: updatedItens,
            discrepancias: importResult.discrepancias.filter(d => 
                !itemsToSync.some(s => d.includes(`Linha ${s.linha}:`))
            )
        });

        setMessage({ type: 'success', text: "Itens sincronizados com o banco de dados!" });
    } catch (err: any) {
        console.error(err);
        setMessage({ type: 'error', text: "Erro ao sincronizar itens." });
    } finally {
        setLoading(false);
    }
  }

  return (
    <div className="cl-page">
      <PageHeader title="Importação de Tabela de Preços" icon={<Download size={24} />} />
      
      <div className="cl-card" style={{ maxWidth: '800px', margin: '0 auto', padding: '24px' }}>
        {message && (
          <div style={{ 
            padding: '12px', 
            marginBottom: '20px', 
            borderRadius: '8px', 
            border: message.type === 'success' ? '1px solid rgba(134, 239, 172, 0.25)' : 
                   message.type === 'informative' ? '1px solid rgba(147, 197, 253, 0.25)' : 
                   '1px solid rgba(252, 165, 165, 0.25)',
            backgroundColor: message.type === 'success' ? 'rgba(134, 239, 172, 0.08)' : 
                             message.type === 'informative' ? 'rgba(147, 197, 253, 0.08)' : 
                             'rgba(252, 165, 165, 0.08)',
            color: message.type === 'success' ? '#86efac' : 
                   message.type === 'informative' ? '#93c5fd' : 
                   '#fca5a5'
          }}>
            {message.text}
          </div>
        )}

        {importResult && (
          <div style={{ 
            padding: '16px', 
            marginBottom: '24px', 
            borderRadius: '8px', 
            background: 'rgba(255, 255, 255, 0.03)',
            border: '1px solid var(--line)'
          }}>
             <h4 style={{ marginTop: 0, marginBottom: '12px', color: 'var(--text)' }}>Resultado da Verificação:</h4>
             <ul style={{ margin: 0, paddingLeft: '20px', color: 'var(--muted)', fontSize: '14px' }}>
                <li>Filas processadas no Excel: <strong>{importResult.totalFilas}</strong></li>
                <li>Módulos no banco para este fornecedor: <strong>{importResult.totalModulos}</strong></li>
                <li style={{ color: importResult.sucesso ? '#86efac' : '#fca5a5' }}>
                    Status da Verificação: <strong>{importResult.sucesso ? 'Tudo OK' : `${importResult.discrepancias.length} divergências encontradas`}</strong>
                </li>
             </ul>

             {importResult.discrepancias.length > 0 && (
                <div style={{ marginTop: '16px', maxHeight: '200px', overflowY: 'auto', background: 'rgba(0,0,0,0.2)', padding: '12px', borderRadius: '4px' }}>
                    <p style={{ margin: '0 0 8px 0', fontSize: '13px', fontWeight: 'bold', color: '#fca5a5' }}>Divergências detalhadas:</p>
                    {importResult.discrepancias.map((d, i) => (
                        <div key={i} style={{ fontSize: '12px', color: '#fca5a5', marginBottom: '4px', borderBottom: '1px solid rgba(252, 165, 165, 0.1)', paddingBottom: '4px' }}>
                            {d}
                        </div>
                    ))}
                </div>
             )}

             <div style={{ marginTop: '20px' }}>
                <button 
                  type="button" 
                  className="btn btn-secondary" 
                  onClick={() => setShowFullReport(!showFullReport)}
                  style={{ width: '100%', fontSize: '13px' }}
                >
                  {showFullReport ? 'Ocultar Relatório Completo' : 'Ver Relatório Completo de Importação'}
                </button>

                {showFullReport && (
                  <div style={{ marginTop: '16px', overflowX: 'auto', background: 'rgba(0,0,0,0.2)', borderRadius: '4px' }}>
                    <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '12px' }}>
                      <thead>
                        <tr style={{ background: 'rgba(255,255,255,0.05)', textAlign: 'left' }}>
                          <th style={{ padding: '8px', borderBottom: '1px solid var(--line)' }}>Linha</th>
                          <th style={{ padding: '8px', borderBottom: '1px solid var(--line)' }}>Descrição</th>
                          <th style={{ padding: '8px', borderBottom: '1px solid var(--line)' }}>L x P x A (Excel)</th>
                          <th style={{ padding: '8px', borderBottom: '1px solid var(--line)' }}>L x P x A (Sistema)</th>
                          <th style={{ padding: '8px', borderBottom: '1px solid var(--line)' }}>Tecido</th>
                          <th style={{ padding: '8px', borderBottom: '1px solid var(--line)' }}>Preço (Excel)</th>
                          <th style={{ padding: '8px', borderBottom: '1px solid var(--line)' }}>Preço (Sistema)</th>
                          <th style={{ padding: '8px', borderBottom: '1px solid var(--line)' }}>Status</th>
                          <th style={{ padding: '8px', borderBottom: '1px solid var(--line)' }}>Ação</th>
                        </tr>
                      </thead>
                      <tbody>
                        {importResult.itensImportados.map((item, idx) => {
                          const dimExcel = `${item.larguraExcel}x${item.profundidadeExcel}x${item.alturaExcel}`;
                          const dimSistema = `${item.largura}x${item.profundidade}x${item.altura}`;
                          const dimDiff = dimExcel !== dimSistema;
                          const priceDiff = Math.abs(item.valorExcel - item.valorTecido) > 0.001;

                          return (
                            <tr key={idx} style={{ 
                              borderBottom: '1px solid rgba(255,255,255,0.03)',
                              background: item.status === 'OK' ? 'transparent' : 
                                         item.status === 'Divergente' ? 'rgba(251, 191, 36, 0.1)' : 
                                         item.status === 'Novo' ? 'rgba(52, 211, 153, 0.1)' : 'rgba(248, 113, 113, 0.1)'
                            }}>
                              <td style={{ padding: '8px' }}>{item.linha}</td>
                              <td style={{ padding: '8px' }}>{item.descricao}</td>
                              <td style={{ padding: '8px', color: dimDiff ? '#fbbf24' : 'inherit' }}>{dimExcel}</td>
                              <td style={{ padding: '8px', color: dimDiff ? '#fca5a5' : 'inherit' }}>{dimSistema}</td>
                              <td style={{ padding: '8px' }}>{item.tecido}</td>
                              <td style={{ padding: '8px', color: priceDiff ? '#fbbf24' : 'inherit' }}>
                                {item.valorExcel.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}
                              </td>
                              <td style={{ padding: '8px', color: priceDiff ? '#fca5a5' : 'inherit' }}>
                                {item.valorTecido.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}
                              </td>
                              <td style={{ padding: '8px', fontWeight: 'bold', color: 
                                  item.status === 'OK' ? '#34d399' : 
                                  item.status === 'Divergente' ? '#fbbf24' : 
                                  item.status === 'Novo' ? '#60a5fa' : '#f87171' 
                              }}>
                                {item.status}
                              </td>
                              <td style={{ padding: '8px' }}>
                                {item.status === 'Divergente' && (
                                    <button 
                                        type="button" 
                                        onClick={() => handleSyncItems([item])}
                                        disabled={loading}
                                        style={{ 
                                            padding: '4px 8px', 
                                            background: 'var(--accent)', 
                                            color: '#000', 
                                            border: 'none', 
                                            borderRadius: '4px',
                                            fontSize: '11px',
                                            cursor: 'pointer'
                                        }}
                                    >
                                        Sincronizar
                                    </button>
                                )}
                              </td>
                            </tr>
                          );
                        })}
                      </tbody>
                    </table>
                  </div>
                )}
             </div>

             {isPreviewMode && importResult.itensImportados.some(i => i.status === 'Divergente') && (
                <div style={{ marginTop: '16px' }}>
                    <button 
                      type="button" 
                      className="cl-button" 
                      onClick={() => handleSyncItems(importResult.itensImportados.filter(i => i.status === 'Divergente'))}
                      disabled={loading}
                      style={{ width: '100%', backgroundColor: '#fbbf24', color: '#000' }}
                    >
                      Sincronizar Todas as Divergências
                    </button>
                </div>
             )}
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

          {importType === 'livintus' ? (
            <div style={{ display: 'flex', gap: '10px' }}>
              <button 
                type="button" 
                className="cl-button" 
                disabled={loading}
                onClick={(e) => handleSubmit(e, true)}
                style={{ flex: 1, backgroundColor: 'var(--accent)', color: '#000' }}
              >
                {loading && isPreviewMode ? 'Simulando...' : 'Simular (Pré-visualizar)'}
              </button>
              <button 
                type="submit" 
                className="cl-button" 
                disabled={loading}
                style={{ flex: 1 }}
              >
                {loading && !isPreviewMode ? 'Sincronizando...' : 'Confirmar Importação Real (Sincronizar Banco)'}
              </button>
            </div>
          ) : (
            <button 
              type="submit" 
              className="cl-button" 
              disabled={loading}
              style={{ width: '100%' }}
            >
              {loading ? 'Processando...' : 'Iniciar Importação'}
            </button>
          )}
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
                    <li><strong>Categoria</strong>: "Livintus"</li>
                    <li><strong>Col B</strong>: Modelo (Marca)</li>
                    <li><strong>Col C</strong>: Largura (m)</li>
                    <li><strong>Col D</strong>: Profundidade (m)</li>
                    <li><strong>Col E</strong>: Altura (m)</li>
                    <li><strong>Col F</strong>: Composição (Módulo)</li>
                    <li><strong>Col G</strong>: Tecido</li>
                    <li><strong>Col H</strong>: Valor</li>
                </ul>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
