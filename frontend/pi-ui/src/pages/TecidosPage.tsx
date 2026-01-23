import React, { useEffect, useState } from "react";
import "./ClientesPage.css";
import type { Tecido } from "../api/types";
import {
  createTecido,
  deleteTecido,
  listTecidos,
  updateTecido,
} from "../api/tecidos";

type FormState = Partial<Tecido>;
const emptyForm: FormState = { nome: "" };

export default function TecidosPage() {
  const [items, setItems] = useState<Tecido[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [search, setSearch] = useState("");

  const [isOpen, setIsOpen] = useState(false);
  const [editing, setEditing] = useState<Tecido | null>(null);
  const [form, setForm] = useState<FormState>(emptyForm);
  const [saving, setSaving] = useState(false);

  async function load() {
    try {
      setLoading(true);
      setError(null);
      setItems(await listTecidos());
    } catch (e: unknown) {
      setError(getErrorMessage(e) || "Erro ao carregar");
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    void load();
  }, []);

  const filteredHelper = React.useMemo(() => {
    if (!search) return items;
    const lower = search.toLowerCase();
    return items.filter((x) => x.nome.toLowerCase().includes(lower));
  }, [items, search]);

  function openCreate() {
    setEditing(null);
    setForm(emptyForm);
    setIsOpen(true);
  }

  function openEdit(x: Tecido) {
    setEditing(x);
    setForm({ ...x });
    setIsOpen(true);
  }

  async function onSave(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    try {
      if (!form.nome || form.nome.trim().length === 0)
        throw new Error("Nome é obrigatório.");

      if (editing) {
        await updateTecido(editing.id, { nome: form.nome.trim() });
      } else {
        await createTecido({ nome: form.nome.trim() });
      }

      setIsOpen(false);
      await load();
    } catch (e: unknown) {
      alert(getErrorMessage(e) || "Erro ao salvar");
    } finally {
      setSaving(false);
    }
  }

  async function onDelete(x: Tecido) {
    if (!confirm(`Remover tecido "${x.nome}"?`)) return;
    try {
      await deleteTecido(x.id);
      await load();
    } catch (e: unknown) {
      alert(getErrorMessage(e) || "Erro ao remover");
    }
  }

  return (
    <div style={{ padding: 16 }}>
      <h1>Tecidos</h1>

      <div
        style={{
          display: "flex",
          gap: 8,
          alignItems: "center",
          marginBottom: 12,
        }}
      >
        <input
          placeholder="Buscar..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          style={{ flex: 1, padding: 8 }}
        />
        <button className="btn btn-primary" onClick={openCreate}>Novo</button>
      </div>

      <div style={{ marginBottom: 8 }}>
        <span>Total: {filteredHelper.length}</span>
      </div>

      {error && <div style={{ color: "red" }}>{error}</div>}

      {loading ? (
        <div>Carregando...</div>
      ) : (
        <table style={{ width: "100%", borderCollapse: "collapse" }}>
          <thead>
            <tr>
              <th style={th}>ID</th>
              <th style={th}>Nome</th>
              <th style={th}>Ações</th>
            </tr>
          </thead>
          <tbody>
            {filteredHelper.map((x) => (
              <tr key={x.id}>
                <td style={td}>{x.id}</td>
                <td style={td}>{x.nome}</td>
                <td style={td}>
                  <button className="btn btn-sm" onClick={() => openEdit(x)}>Editar</button>{" "}
                  <button className="btn btn-danger btn-sm" onClick={() => onDelete(x)}>
                    Remover
                  </button>
                </td>
              </tr>
            ))}
            {filteredHelper.length === 0 && (
              <tr>
                <td colSpan={3} style={{ padding: 12, textAlign: "center" }}>
                  Nenhum tecido cadastrado
                </td>
              </tr>
            )}
          </tbody>
        </table>
      )}

      {isOpen && (
        <div className="modalOverlay" onMouseDown={() => setIsOpen(false)}>
          <div className="modalCard" onMouseDown={(e) => e.stopPropagation()}>
            <div className="modalHeader">
              <h3 className="modalTitle">
                {editing ? "Editar Tecido" : "Novo Tecido"}
              </h3>
              <button
                className="btn btn-sm"
                type="button"
                onClick={() => setIsOpen(false)}
              >
                Fechar
              </button>
            </div>

            <form onSubmit={onSave}>
              <div className="modalBody">
                <div className="formGrid">
                  <div className="field fieldFull">
                    <div className="label">Nome*</div>
                    <input
                      className="cl-input"
                      value={form.nome || ""}
                      onChange={(e) =>
                        setForm({ ...form, nome: e.target.value })
                      }
                      required
                    />
                  </div>
                </div>
              </div>

              <div className="modalFooter">
                <button
                  className="btn"
                  type="button"
                  onClick={() => setIsOpen(false)}
                >
                  Cancelar
                </button>
                <button
                  className="btn btn-primary"
                  type="submit"
                  disabled={saving}
                >
                  {saving ? "Salvando..." : "Salvar"}
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
  textAlign: "left",
  borderBottom: "1px solid #ddd",
  padding: 8,
};
const td: React.CSSProperties = { borderBottom: "1px solid #eee", padding: 8 };

function getErrorMessage(e: unknown): string {
  if (e instanceof Error) return e.message;
  if (typeof e === "string") return e;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  if (e && typeof e === "object" && "message" in e && typeof e.message === "string") {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      return (e as any).message;
  }
  try {
    return JSON.stringify(e);
  } catch {
    return "Erro desconhecido";
  }
}
