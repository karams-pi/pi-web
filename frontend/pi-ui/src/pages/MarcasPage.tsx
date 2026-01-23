import React, { useEffect, useState, useMemo } from "react";
import "./ClientesPage.css";

import type { Marca } from "../api/types";
import {
  createMarca,
  deleteMarca,
  listMarcas,
  updateMarca,
} from "../api/marcas";

type FormState = Partial<Marca>;
const emptyForm: FormState = {
  nome: "",
  urlImagem: "",
  observacao: "",
};

export default function MarcasPage() {
  const [items, setItems] = useState<Marca[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [search, setSearch] = useState("");

  const [isOpen, setIsOpen] = useState(false);
  const [editing, setEditing] = useState<Marca | null>(null);
  const [form, setForm] = useState<FormState>(emptyForm);
  const [saving, setSaving] = useState(false);

  async function load() {
    try {
      setLoading(true);
      setError(null);
      setItems(await listMarcas());
    } catch (e: unknown) {
      setError(getErrorMessage(e) || "Erro ao carregar");
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    void load();
  }, []);

  const filteredItems = useMemo(() => {
    if (!search) return items;
    const lower = search.toLowerCase();
    return items.filter((x) => x.nome.toLowerCase().includes(lower));
  }, [items, search]);

  function openCreate() {
    setEditing(null);
    setForm(emptyForm);
    setIsOpen(true);
  }

  function openEdit(x: Marca) {
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

      const payload = {
        nome: form.nome.trim(),
        urlImagem: form.urlImagem || null,
        observacao: form.observacao || null,
      };

      if (editing) {
        await updateMarca(editing.id, payload);
      } else {
        await createMarca(payload);
      }

      setIsOpen(false);
      await load();
    } catch (e: unknown) {
      alert(getErrorMessage(e) || "Erro ao salvar");
    } finally {
      setSaving(false);
    }
  }

  async function onDelete(x: Marca) {
    if (!confirm(`Remover marca "${x.nome}"?`)) return;
    try {
      await deleteMarca(x.id);
      await load();
    } catch (e: unknown) {
      alert(getErrorMessage(e) || "Erro ao remover");
    }
  }

  return (
    <div style={{ padding: 16 }}>
      <h1>Marcas</h1>

      <div style={{ display: "flex", gap: 8, marginBottom: 12 }}>
        <input
          placeholder="Buscar marca..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          style={{ flex: 1, padding: 8 }}
        />
        <button className="btn btn-primary" onClick={openCreate}>Nova</button>
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
              <th style={th}>Imagem (URL)</th>
              <th style={th}>Observação</th>
              <th style={th}>Ações</th>
            </tr>
          </thead>
          <tbody>
            {filteredItems.map((x) => (
              <tr key={x.id}>
                <td style={td}>{x.id}</td>
                <td style={td}>{x.nome}</td>
                <td style={td}>
                  {x.urlImagem ? (
                    <a href={x.urlImagem} target="_blank" rel="noreferrer">
                      Link
                    </a>
                  ) : (
                    "-"
                  )}
                </td>
                <td style={td}>{x.observacao || "-"}</td>
                <td style={td}>
                  <button className="btn btn-sm" onClick={() => openEdit(x)}>Editar</button>{" "}
                  <button className="btn btn-danger btn-sm" onClick={() => onDelete(x)}>
                    Remover
                  </button>
                </td>
              </tr>
            ))}
            {filteredItems.length === 0 && (
              <tr>
                <td colSpan={5} style={{ padding: 12, textAlign: "center" }}>
                  Nenhuma marca encontrada
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
                {editing ? "Editar Marca" : "Nova Marca"}
              </h3>
              <button className="btn btn-sm" onClick={() => setIsOpen(false)}>
                Fechar
              </button>
            </div>

            <form onSubmit={onSave}>
              <div className="modalBody">
                <div className="formGrid">
                  <div className="field">
                    <label className="label">Nome*</label>
                    <input
                      className="cl-input"
                      value={form.nome || ""}
                      onChange={(e) =>
                        setForm({ ...form, nome: e.target.value })
                      }
                      required
                    />
                  </div>
                  <div className="field">
                    <label className="label">URL Imagem</label>
                    <input
                      className="cl-input"
                      value={form.urlImagem || ""}
                      onChange={(e) =>
                        setForm({ ...form, urlImagem: e.target.value })
                      }
                    />
                  </div>
                  <div className="field fieldFull">
                    <label className="label">Observação</label>
                    <textarea
                      className="textarea"
                      value={form.observacao || ""}
                      onChange={(e) =>
                        setForm({ ...form, observacao: e.target.value })
                      }
                      rows={3}
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
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  if (typeof e === "object" && e && (e as any).message) return (e as any).message;
  return "Erro desconhecido";
}
