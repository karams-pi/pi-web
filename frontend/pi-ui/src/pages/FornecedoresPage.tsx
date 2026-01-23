import React, { useEffect, useState } from 'react';
import './ClientesPage.css'; // Reuse existing styles or create new ones if needed

import type { Fornecedor } from '../api/types';
import {
  listFornecedores,
  createFornecedor,
  updateFornecedor,
  deleteFornecedor,
} from '../api/fornecedores';

// Form state excluding 'id'
type FormState = Omit<Fornecedor, 'id'>;

const emptyForm: FormState = {
  nome: '',
  cnpj: '',
};

export default function FornecedoresPage() {
  const [search, setSearch] = useState('');
  const [data, setData] = useState<Fornecedor[] | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Modal / Form states
  const [isOpen, setIsOpen] = useState(false);
  const [editing, setEditing] = useState<Fornecedor | null>(null);
  const [form, setForm] = useState<FormState>(emptyForm);
  const [saving, setSaving] = useState(false);

  // Load data
  async function load() {
    try {
      setLoading(true);
      setError(null);
      const result = await listFornecedores();
      setData(result);
    } catch (e: unknown) {
      setError(getErrorMessage(e) || 'Erro ao carregar fornecedores');
    } finally {
      setLoading(false);
    }
  }

  // Initial load
  useEffect(() => {
    load();
  }, []);

  // Filtered data (Client-side search)
  const filteredData = React.useMemo(() => {
    if (!data) return [];
    if (!search.trim()) return data;
    const lower = search.toLowerCase();
    return data.filter(
      (f) =>
        f.nome.toLowerCase().includes(lower) ||
        f.cnpj.includes(lower) ||
        String(f.id).includes(lower)
    );
  }, [data, search]);

  // Actions
  function openCreate() {
    setEditing(null);
    setForm(emptyForm);
    setIsOpen(true);
  }

  function openEdit(item: Fornecedor) {
    setEditing(item);
    setForm({ nome: item.nome, cnpj: item.cnpj });
    setIsOpen(true);
  }

  async function onSave(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    try {
      if (!form.nome.trim()) throw new Error('Nome é obrigatório.');
      if (!form.cnpj.trim()) throw new Error('CNPJ é obrigatório.');

      if (editing) {
        await updateFornecedor(editing.id, form);
      } else {
        await createFornecedor(form);
      }
      setIsOpen(false);
      await load(); // Reload list
    } catch (e: unknown) {
      alert(getErrorMessage(e) || 'Erro ao salvar');
    } finally {
      setSaving(false);
    }
  }

  async function onDelete(item: Fornecedor) {
    if (!confirm(`Remover fornecedor "${item.nome}"?`)) return;
    try {
      await deleteFornecedor(item.id);
      await load();
    } catch (e: unknown) {
      alert(getErrorMessage(e) || 'Erro ao remover');
    }
  }

  return (
    <div style={{ padding: 16 }}>
      <h1>Fornecedores</h1>

      <div style={{ display: 'flex', gap: 8, alignItems: 'center', marginBottom: 12 }}>
        <input
          placeholder="Buscar por nome, CNPJ..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          style={{ flex: 1, padding: 8 }}
        />
        <button className="btn btn-primary" onClick={openCreate}>Novo</button>
      </div>

      <div style={{ marginBottom: 8 }}>
        <span>Total: {filteredData.length}</span>
      </div>

      {error && <div style={{ color: 'red' }}>{error}</div>}
      
      {loading && !data ? (
        <div>Carregando...</div>
      ) : (
        <table style={{ width: '100%', borderCollapse: 'collapse' }}>
          <thead>
            <tr>
              <th style={th}>ID</th>
              <th style={th}>Nome</th>
              <th style={th}>CNPJ</th>
              <th style={th}>Ações</th>
            </tr>
          </thead>
          <tbody>
            {filteredData.map((item) => (
              <tr key={item.id}>
                <td style={td}>{item.id}</td>
                <td style={td}>{item.nome}</td>
                <td style={td}>{item.cnpj}</td>
                <td style={td}>
                  <button className="btn btn-sm" onClick={() => openEdit(item)}>Editar</button>{' '}
                  <button className="btn btn-danger btn-sm" onClick={() => onDelete(item)}>
                    Remover
                  </button>
                </td>
              </tr>
            ))}
            {filteredData.length === 0 && (
              <tr>
                <td colSpan={4} style={{ padding: 12, textAlign: 'center' }}>
                  Nenhum fornecedor encontrado.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      )}

      {/* MODAL */}
      {isOpen && (
        <div className="modalOverlay" onMouseDown={() => setIsOpen(false)}>
          <div className="modalCard" onMouseDown={(e) => e.stopPropagation()}>
            <div className="modalHeader">
              <h3 className="modalTitle">
                {editing ? 'Editar Fornecedor' : 'Novo Fornecedor'}
              </h3>
              <button className="btn btn-sm" type="button" onClick={() => setIsOpen(false)}>
                Fechar
              </button>
            </div>

            <form onSubmit={onSave}>
              <div className="modalBody">
                <div className="formGrid">
                  <div className="field">
                    <div className="label">Nome*</div>
                    <input
                      className="cl-input"
                      value={form.nome}
                      onChange={(e) => setForm({ ...form, nome: e.target.value })}
                      required
                    />
                  </div>

                  <div className="field">
                    <div className="label">CNPJ*</div>
                    <input
                      className="cl-input"
                      value={form.cnpj}
                      onChange={(e) => setForm({ ...form, cnpj: e.target.value })}
                      required
                      maxLength={14}
                    />
                  </div>
                </div>
              </div>

              <div className="modalFooter">
                <button className="btn" type="button" onClick={() => setIsOpen(false)}>
                  Cancelar
                </button>
                <button className="btn btn-primary" type="submit" disabled={saving}>
                  {saving ? 'Salvando...' : 'Salvar'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}

const th: React.CSSProperties = {
  textAlign: 'left',
  borderBottom: '1px solid #ddd',
  padding: 8,
};
const td: React.CSSProperties = { borderBottom: '1px solid #eee', padding: 8 };

function getErrorMessage(e: unknown): string {
  if (e instanceof Error) return e.message;
  if (typeof e === 'string') return e;
  if (e && typeof e === 'object') {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const anyE = e as any;
    if (typeof anyE.message === 'string') return anyE.message;
    if (typeof anyE.error === 'string') return anyE.error;
  }
  return 'Erro desconhecido';
}
