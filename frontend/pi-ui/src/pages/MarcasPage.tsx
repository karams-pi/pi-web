import React, { useEffect, useState, useMemo } from "react";
import "./ClientesPage.css";

import type { Marca } from "../api/types";
import {
  createMarca,
  deleteMarca,
  listMarcas,
  updateMarca,
} from "../api/marcas";
import { PrintExportButtons } from "../components/PrintExportButtons";
import { printData, exportToCSV } from "../utils/printExport";
import type { ColumnDefinition } from "../utils/printExport";

type FormState = Partial<Marca>;
const emptyForm: FormState = {
  nome: "",
  imagem: "",
  observacao: "",
  flAtivo: true,
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
    setForm({ ...x, imagem: x.imagem ?? "" });
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
        imagem: form.imagem || null,
        observacao: form.observacao || null,
        flAtivo: form.flAtivo !== undefined ? form.flAtivo : true,
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
    if (!confirm(`Remover modelo "${x.nome}"?`)) return;
    try {
      await deleteMarca(x.id);
      await load();
    } catch (e: unknown) {
      alert(getErrorMessage(e) || "Erro ao remover");
    }
  }

  const exportColumns: ColumnDefinition<Marca>[] = [
    { header: "ID", accessor: (m) => m.id },
    { header: "Nome", accessor: (m) => m.nome },
    { header: "Ativo", accessor: (m) => m.flAtivo ? "Sim" : "Não" },
    { header: "Imagem (Base64)", accessor: (m) => m.imagem ? "Sim" : "Não" },
    { header: "Obs", accessor: (m) => m.observacao },
  ];

  function handlePrint(all: boolean) {
     const list = all ? (items || []) : filteredItems;
     printData(list, exportColumns, "Relatório de Modelos");
  }

  function handleExcel(all: boolean) {
     const list = all ? (items || []) : filteredItems;
     exportToCSV(list, exportColumns, "modelos");
  }

  return (
    <div style={{ padding: 16 }}>
      <h1>Modelos</h1>

      <div style={{ display: "flex", gap: 8, marginBottom: 12 }}>
        <input
          placeholder="Buscar modelo..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          style={{ flex: 1, padding: 8 }}
        />
        <button className="btn btn-primary" onClick={openCreate}>Nova</button>
        <div style={{ marginLeft: "auto" }}>
            <PrintExportButtons
                onPrint={handlePrint}
                onExcel={handleExcel}
                disabled={loading}
            />
        </div>
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
              <th style={th}>Ativo</th>
              <th style={th}>Imagem</th>
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
                    {x.flAtivo !== false ? (
                        <span style={{ color: "#10b981", fontWeight: 500 }}>Sim</span>
                    ) : (
                        <span style={{ color: "#ef4444", fontWeight: 500 }}>Não</span>
                    )}
                </td>
                <td style={td}>
                  {x.imagem ? (
                    <img 
                      src={`data:image/png;base64,${x.imagem}`} 
                      alt="Modelo" 
                      style={{ maxWidth: 50, maxHeight: 50, objectFit: "contain" }} 
                    />
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
                <td colSpan={6} style={{ padding: 12, textAlign: "center" }}>
                  Nenhum modelo encontrado
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
                {editing ? "Editar Modelo" : "Novo Modelo"}
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
                    <label className="label">Ativo</label>
                    <div style={{ display: "flex", alignItems: "center", height: "38px" }}>
                        <label style={{ display: "flex", alignItems: "center", gap: 8, cursor: "pointer" }}>
                            <input 
                                type="checkbox"
                                checked={form.flAtivo !== false}
                                onChange={(e) => setForm({ ...form, flAtivo: e.target.checked })}
                                style={{ width: 18, height: 18 }}
                            />
                            <span>{form.flAtivo !== false ? "Sim" : "Não"}</span>
                        </label>
                    </div>
                  </div>
                  <div className="field fieldFull">
                    <div className="label">Imagem</div>
                    <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
                        <input 
                            type="file" 
                            accept="image/*"
                            onChange={(e) => {
                                const file = e.target.files?.[0];
                                if (file) {
                                    const reader = new FileReader();
                                    reader.onloadend = () => {
                                        const result = reader.result as string;
                                        const base64 = result.split(",")[1];
                                        setForm({ ...form, imagem: base64 });
                                    };
                                    reader.readAsDataURL(file);
                                }
                            }} 
                            className="cl-input"
                        />
                        {form.imagem && (
                            <img 
                                src={`data:image/png;base64,${form.imagem}`} 
                                alt="Preview" 
                                style={{ height: 40, border: "1px solid #444" }} 
                            />
                        )}
                        {form.imagem && (
                            <button type="button" className="btn btn-sm btn-danger" onClick={() => setForm({...form, imagem: ""})}>X</button>
                        )}
                    </div>
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
