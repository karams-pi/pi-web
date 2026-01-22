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
    <div className="cl-page">
      <h1 className="cl-title">Tecidos</h1>

      <div className="cl-toolbar">
        <button className="btn btn-primary" onClick={openCreate}>
          Novo
        </button>
      </div>

      {error && <div className="errorBox">{error}</div>}

      <div className="cl-card">
        <div className="cl-tableWrap">
          {loading ? (
            <div style={{ padding: 16, color: "var(--muted)" }}>
              Carregando...
            </div>
          ) : (
            <table className="cl-table" style={{ minWidth: 600 }}>
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Nome</th>
                  <th style={{ width: 220 }}>Ações</th>
                </tr>
              </thead>
              <tbody>
                {items.map((x) => (
                  <tr key={x.id}>
                    <td>{x.id}</td>
                    <td>{x.nome}</td>
                    <td className="cl-actions">
                      <button
                        className="btn btn-sm"
                        onClick={() => openEdit(x)}
                      >
                        Editar
                      </button>
                      <button
                        className="btn btn-sm btn-danger"
                        onClick={() => onDelete(x)}
                      >
                        Remover
                      </button>
                    </td>
                  </tr>
                ))}
                {!loading && items.length === 0 && (
                  <tr>
                    <td
                      colSpan={3}
                      style={{
                        padding: 12,
                        textAlign: "center",
                        color: "var(--muted)",
                      }}
                    >
                      Nenhum tecido cadastrado
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          )}
        </div>
      </div>

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

function getErrorMessage(e: unknown): string {
  if (e instanceof Error) return e.message;
  if (typeof e === "string") return e;
  try {
    return JSON.stringify(e);
  } catch {
    return "Erro desconhecido";
  }
}
