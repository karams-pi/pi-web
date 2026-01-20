import React, { useEffect, useMemo, useState } from 'react';

// importe TIPOS como type-only
import type { Cliente, PagedResult } from '../api/clientes';

// importe as FUNÇÕES normalmente
import {
  listClientes,
  createCliente,
  updateCliente,
  deleteCliente,
} from '../api/clientes';

type FormState = Partial<Cliente>;

const emptyForm: FormState = {
  nome: '',
  empresa: '',
  email: '',
  telefone: '',
  ativo: true,
  pais: '',
  cidade: '',
  endereco: '',
  cep: '',
  pessoaContato: '',
  cargoFuncao: '',
  observacoes: '',
};

export default function ClientesPage() {
  const [search, setSearch] = useState('');
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);
  const [data, setData] = useState<PagedResult<Cliente> | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const [isOpen, setIsOpen] = useState(false);
  const [editing, setEditing] = useState<Cliente | null>(null);
  const [form, setForm] = useState<FormState>(emptyForm);
  const [saving, setSaving] = useState(false);

  // debounce da busca
  const debouncedSearch = useDebounce(search, 350);

  async function load() {
    try {
      setLoading(true);
      setError(null);
      const result = await listClientes({
        search: debouncedSearch,
        page,
        pageSize,
      });
      setData(result);
    } catch (e: any) {
      setError(e.message || 'Erro ao carregar');
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [debouncedSearch, page, pageSize]);

  function openCreate() {
    setEditing(null);
    setForm(emptyForm);
    setIsOpen(true);
  }

  function openEdit(c: Cliente) {
    setEditing(c);
    setForm({ ...c });
    setIsOpen(true);
  }

  async function onSave(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    try {
      if (!form.nome || form.nome.trim().length === 0)
        throw new Error('Nome é obrigatório.');

      if (editing) {
        await updateCliente(editing.id, form);
      } else {
        await createCliente(form);
      }
      setIsOpen(false);
      await load();
    } catch (e: any) {
      alert(e.message || 'Erro ao salvar');
    } finally {
      setSaving(false);
    }
  }

  async function onDelete(c: Cliente) {
    if (!confirm(`Remover cliente "${c.nome}"?`)) return;
    try {
      await deleteCliente(c.id);
      await load();
    } catch (e: any) {
      alert(e.message || 'Erro ao remover');
    }
  }

  const totalPages = useMemo(
    () => (data ? Math.max(1, Math.ceil(data.total / pageSize)) : 1),
    [data, pageSize]
  );

  return (
    <div style={{ padding: 16 }}>
      <h1>Clientes</h1>

      <div
        style={{
          display: 'flex',
          gap: 8,
          alignItems: 'center',
          marginBottom: 12,
        }}>
        <input
          placeholder='Buscar por nome, empresa, e-mail...'
          value={search}
          onChange={(e) => {
            setSearch(e.target.value);
            setPage(1);
          }}
          style={{ flex: 1, padding: 8 }}
        />
        <button onClick={openCreate}>Novo</button>
      </div>

      <div
        style={{
          marginBottom: 8,
          display: 'flex',
          gap: 8,
          alignItems: 'center',
        }}>
        <span>Total: {data?.total ?? 0}</span>
        <label>
          Page size:
          <select
            value={pageSize}
            onChange={(e) => {
              setPageSize(Number(e.target.value));
              setPage(1);
            }}>
            {[10, 20, 50, 100].map((n) => (
              <option key={n} value={n}>
                {n}
              </option>
            ))}
          </select>
        </label>
      </div>

      {error && <div style={{ color: 'red' }}>{error}</div>}
      {loading ? (
        <div>Carregando...</div>
      ) : (
        <table style={{ width: '100%', borderCollapse: 'collapse' }}>
          <thead>
            <tr>
              <th style={th}>Nome</th>
              <th style={th}>Empresa</th>
              <th style={th}>E-mail</th>
              <th style={th}>Telefone</th>
              <th style={th}>Ativo</th>
              <th style={th}>Ações</th>
            </tr>
          </thead>
          <tbody>
            {data?.items.map((c) => (
              <tr key={c.id}>
                <td style={td}>{c.nome}</td>
                <td style={td}>{c.empresa || '-'}</td>
                <td style={td}>{c.email || '-'}</td>
                <td style={td}>{c.telefone || '-'}</td>
                <td style={td}>{c.ativo ? 'Sim' : 'Não'}</td>
                <td style={td}>
                  <button onClick={() => openEdit(c)}>Editar</button>{' '}
                  <button onClick={() => onDelete(c)} style={{ color: 'red' }}>
                    Remover
                  </button>
                </td>
              </tr>
            ))}
            {data && data.items.length === 0 && (
              <tr>
                <td colSpan={6} style={{ padding: 12, textAlign: 'center' }}>
                  Nenhum cliente encontrado
                </td>
              </tr>
            )}
          </tbody>
        </table>
      )}

      <div
        style={{
          marginTop: 12,
          display: 'flex',
          gap: 8,
          alignItems: 'center',
        }}>
        <button
          disabled={page <= 1}
          onClick={() => setPage((p) => Math.max(1, p - 1))}>
          Anterior
        </button>
        <span>
          Página {page} de {totalPages}
        </span>
        <button
          disabled={page >= totalPages}
          onClick={() => setPage((p) => Math.min(totalPages, p + 1))}>
          Próxima
        </button>
      </div>

      {isOpen && (
        <div style={modalOverlay}>
          <div style={modalCard}>
            <h3>{editing ? 'Editar Cliente' : 'Novo Cliente'}</h3>
            <form onSubmit={onSave} style={{ display: 'grid', gap: 8 }}>
              <label>
                Nome*{' '}
                <input
                  value={form.nome || ''}
                  onChange={(e) => setForm({ ...form, nome: e.target.value })}
                  required
                />
              </label>
              <label>
                Empresa{' '}
                <input
                  value={form.empresa || ''}
                  onChange={(e) =>
                    setForm({ ...form, empresa: e.target.value })
                  }
                />
              </label>
              <label>
                E-mail{' '}
                <input
                  type='email'
                  value={form.email || ''}
                  onChange={(e) => setForm({ ...form, email: e.target.value })}
                />
              </label>
              <label>
                Telefone{' '}
                <input
                  value={form.telefone || ''}
                  onChange={(e) =>
                    setForm({ ...form, telefone: e.target.value })
                  }
                />
              </label>
              <label>
                Ativo{' '}
                <input
                  type='checkbox'
                  checked={!!form.ativo}
                  onChange={(e) =>
                    setForm({ ...form, ativo: e.target.checked })
                  }
                />
              </label>
              <div
                style={{
                  display: 'flex',
                  gap: 8,
                  justifyContent: 'flex-end',
                  marginTop: 8,
                }}>
                <button type='button' onClick={() => setIsOpen(false)}>
                  Cancelar
                </button>
                <button type='submit' disabled={saving}>
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

function useDebounce<T>(value: T, delay = 300) {
  const [v, setV] = useState(value);
  useEffect(() => {
    const t = setTimeout(() => setV(value), delay);
    return () => clearTimeout(t);
  }, [value, delay]);
  return v;
}

const th: React.CSSProperties = {
  textAlign: 'left',
  borderBottom: '1px solid #ddd',
  padding: 8,
};
const td: React.CSSProperties = { borderBottom: '1px solid #eee', padding: 8 };

const modalOverlay: React.CSSProperties = {
  position: 'fixed',
  inset: 0,
  background: 'rgba(0,0,0,0.3)',
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
};
const modalCard: React.CSSProperties = {
  background: '#fff',
  padding: 16,
  borderRadius: 8,
  minWidth: 420,
};
