import React, { useEffect, useMemo, useState } from 'react';
import './ClientesPage.css';

// importe TIPOS como type-only
import type { Cliente, PagedResult } from '../api/clientes';

// importe as FUNÇÕES normalmente
import {
  listClientes,
  createCliente,
  updateCliente,
  deleteCliente,
} from '../api/clientes';
import { PrintExportButtons } from "../components/PrintExportButtons";
import { printData, exportToCSV } from "../utils/printExport";
import type { ColumnDefinition } from "../utils/printExport";

type FormState = Partial<Cliente>;

const emptyForm: FormState = {
  nome: '',
  empresa: '',
  nit: '',
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
    } catch (e: unknown) {
      setError(getErrorMessage(e) || 'Erro ao carregar');
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
    } catch (e: unknown) {
      alert(getErrorMessage(e) || 'Erro ao salvar');
    } finally {
      setSaving(false);
    }
  }

  async function onDelete(c: Cliente) {
    if (!confirm(`Remover cliente "${c.nome}"?`)) return;
    try {
      await deleteCliente(c.id);
      await load();
    } catch (e: unknown) {
      alert(getErrorMessage(e) || 'Erro ao remover');
    }
  }

  const totalPages = useMemo(
    () => (data ? Math.max(1, Math.ceil(data.total / pageSize)) : 1),
    [data, pageSize]
  );


  const exportColumns: ColumnDefinition<Cliente>[] = [
    { header: "Nome", accessor: (c) => c.nome },
    { header: "Empresa", accessor: (c) => c.empresa },
    { header: "NIT", accessor: (c) => c.nit },
    { header: "Email", accessor: (c) => c.email },
    { header: "Telefone", accessor: (c) => c.telefone },
    { header: "País", accessor: (c) => c.pais },
    { header: "Cidade", accessor: (c) => c.cidade },
    { header: "Endereço", accessor: (c) => c.endereco },
    { header: "CEP", accessor: (c) => c.cep },
    { header: "Contato", accessor: (c) => c.pessoaContato },
    { header: "Cargo", accessor: (c) => c.cargoFuncao },
    { header: "Obs", accessor: (c) => c.observacoes },
    { header: "Ativo", accessor: (c) => c.ativo ? "Sim" : "Não" },
  ];

  async function handlePrint(all: boolean) {
    if (all) {
      try {
        setLoading(true);
        const res = await listClientes({ pageSize: 100000 });
        printData(res.items, exportColumns, "Relatório Geral de Clientes");
      } catch (e) {
        alert("Erro ao carregar dados completos");
      } finally {
        setLoading(false);
      }
    } else {
      printData(data?.items || [], exportColumns, "Relatório de Clientes (Tela)");
    }
  }

  async function handleExcel(all: boolean) {
    if (all) {
      try {
        setLoading(true);
        const res = await listClientes({ pageSize: 100000 });
        exportToCSV(res.items, exportColumns, "clientes_completo");
      } catch (e) {
        alert("Erro ao carregar dados completos");
      } finally {
        setLoading(false);
      }
    } else {
      exportToCSV(data?.items || [], exportColumns, "clientes_tela");
    }
  }

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
        <button className="btn btn-primary" onClick={openCreate}>Novo</button>
      </div>

      <div style={{ display: "flex", justifyContent: "flex-end", marginBottom: 12 }}>
          <PrintExportButtons
            onPrint={handlePrint}
            onExcel={handleExcel}
            disabled={loading}
          />
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
              <th style={th}>NIT</th>
              <th style={th}>E-mail</th>
              <th style={th}>Telefone</th>
              <th style={th}>País</th>
              <th style={th}>Cidade</th>
              <th style={th}>Endereço</th>
              <th style={th}>CEP</th>
              <th style={th}>Contato</th>
              <th style={th}>Cargo</th>
              <th style={th}>Obs.</th>
              <th style={th}>Ativo</th>
              <th style={th}>Ações</th>
            </tr>
          </thead>
          <tbody>
            {data?.items.map((c) => (
              <tr key={c.id}>
                <td style={td}>{c.nome}</td>
                <td style={td}>{c.empresa || '-'}</td>
                <td style={td}>{c.nit || '-'}</td>
                <td style={td}>{c.email || '-'}</td>
                <td style={td}>{c.telefone || '-'}</td>
                <td style={td}>{c.pais || "-"}</td>
                <td style={td}>{c.cidade || "-"}</td>
                <td style={td}>{c.endereco || "-"}</td>
                <td style={td}>{c.cep || "-"}</td>
                <td style={td}>{c.pessoaContato || "-"}</td>
                <td style={td}>{c.cargoFuncao || "-"}</td>
                <td style={td} title={c.observacoes || ""}>
                  {(c.observacoes || "-").slice(0, 24)}
                  {(c.observacoes?.length ?? 0) > 24 ? "…" : ""}
                </td>
                <td style={td}>{c.ativo ? 'Sim' : 'Não'}</td>
                <td style={td}>
                  <button className="btn btn-sm" onClick={() => openEdit(c)}>Editar</button>{' '}
                  <button className="btn btn-danger btn-sm" onClick={() => onDelete(c)}>
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
          className="btn"
          disabled={page <= 1}
          onClick={() => setPage((p) => Math.max(1, p - 1))}>
          Anterior
        </button>
        <span>
          Página {page} de {totalPages}
        </span>
        <button
          className="btn"
          disabled={page >= totalPages}
          onClick={() => setPage((p) => Math.min(totalPages, p + 1))}>
          Próxima
        </button>
      </div>

      {isOpen && (
      <div className="modalOverlay" onMouseDown={() => setIsOpen(false)}>
        <div className="modalCard" onMouseDown={(e) => e.stopPropagation()}>
          <div className="modalHeader">
            <h3 className="modalTitle">{editing ? 'Editar Cliente' : 'Novo Cliente'}</h3>
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
                    value={form.nome || ''}
                    onChange={(e) => setForm({ ...form, nome: e.target.value })}
                    required
                  />
                </div>

                <div className="field">
                  <div className="label">Empresa</div>
                  <input
                    className="cl-input"
                    value={form.empresa || ''}
                    onChange={(e) => setForm({ ...form, empresa: e.target.value })}
                  />
                </div>

                <div className="field">
                  <div className="label">E-mail</div>
                  <input
                    className="cl-input"
                    type="email"
                    value={form.email || ''}
                    onChange={(e) => setForm({ ...form, email: e.target.value })}
                  />
                </div>

                <div className="field">
                  <div className="label">Telefone</div>
                  <input
                    className="cl-input"
                    value={form.telefone || ''}
                    onChange={(e) => setForm({ ...form, telefone: e.target.value })}
                  />
                </div>

                <div className="field">
                  <div className="label">País</div>
                  <input
                    className="cl-input"
                    value={form.pais || ''}
                    onChange={(e) => setForm({ ...form, pais: e.target.value })}
                  />
                </div>

                <div className="field">
                  <div className="label">Cidade</div>
                  <input
                    className="cl-input"
                    value={form.cidade || ''}
                    onChange={(e) => setForm({ ...form, cidade: e.target.value })}
                  />
                </div>

                <div className="field fieldFull">
                  <div className="label">Endereço</div>
                  <input
                    className="cl-input"
                    value={form.endereco || ''}
                    onChange={(e) => setForm({ ...form, endereco: e.target.value })}
                  />
                </div>

                <div className="field">
                  <div className="label">CEP</div>
                  <input
                    className="cl-input"
                    value={form.cep || ''}
                    onChange={(e) => setForm({ ...form, cep: e.target.value })}
                    placeholder="00000-000"
                  />
                </div>

                <div className="field">
                  <div className="label">Contato</div>
                  <input
                    className="cl-input"
                    value={form.pessoaContato || ''}
                    onChange={(e) =>
                      setForm({ ...form, pessoaContato: e.target.value })
                    }
                    placeholder="Nome do contato"
                  />
                </div>

                <div className="field">
                  <div className="label">Cargo</div>
                  <input
                    className="cl-input"
                    value={form.cargoFuncao || ''}
                    onChange={(e) =>
                      setForm({ ...form, cargoFuncao: e.target.value })
                    }
                    placeholder="Ex.: Compras"
                  />
                </div>

                <div className="field fieldFull">
                  <div className="label">Observações</div>
                  <textarea
                    className="textarea"
                    value={form.observacoes || ''}
                    onChange={(e) =>
                      setForm({ ...form, observacoes: e.target.value })
                    }
                    rows={4}
                  />
                </div>

                <div className="field fieldFull">
                  <label className="checkboxRow">
                    <input
                      type="checkbox"
                      checked={!!form.ativo}
                      onChange={(e) => setForm({ ...form, ativo: e.target.checked })}
                    />
                    Ativo
                  </label>
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

// const modalOverlay: React.CSSProperties = {
//   position: 'fixed',
//   inset: 0,
//   background: 'rgba(0,0,0,0.3)',
//   display: 'flex',
//   alignItems: 'center',
//   justifyContent: 'center',
// };
// const modalCard: React.CSSProperties = {
//   background: "#fff",
//   padding: 16,
//   borderRadius: 8,
//   width: "min(900px, 92vw)",
//   maxHeight: "85vh",
//   overflow: "auto",
// };

function getErrorMessage(e: unknown): string {
  if (e instanceof Error) return e.message;

  // Caso o seu api.ts jogue string (às vezes acontece)
  if (typeof e === 'string') return e;

  // Casos comuns (axios/fetch wrappers, etc.)
  if (e && typeof e === 'object') {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const anyE = e as any;
    if (typeof anyE.message === 'string') return anyE.message;
    if (typeof anyE.error === 'string') return anyE.error;
  }

  try {
    return JSON.stringify(e);
  } catch {
    return 'Erro desconhecido';
  }
}
