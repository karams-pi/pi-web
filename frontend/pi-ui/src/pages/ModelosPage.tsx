import React, { useEffect, useMemo, useState } from "react";
import { Link } from "react-router-dom";
import "./ClientesPage.css";

import type { Categoria, Fornecedor, Modelo } from "../api/types";
import { listCategorias } from "../api/categorias";
import { listFornecedores } from "../api/fornecedores";
import { createModelo, deleteModelo, listModelos, updateModelo } from "../api/modelos";

type FormState = Partial<Modelo>;

const emptyForm: FormState = {
  descricao: "",
  urlImagem: "",
  idFornecedor: 0,
  idCategoria: 0,
};

export default function ModelosPage() {
  const [fornecedores, setFornecedores] = useState<Fornecedor[]>([]);
  const [categorias, setCategorias] = useState<Categoria[]>([]);

  const [fFornecedorId, setFFornecedorId] = useState(0);
  const [fCategoriaId, setFCategoriaId] = useState(0);

  const [items, setItems] = useState<Modelo[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const [isOpen, setIsOpen] = useState(false);
  const [editing, setEditing] = useState<Modelo | null>(null);
  const [form, setForm] = useState<FormState>(emptyForm);
  const [saving, setSaving] = useState(false);

  const fornecedorNome = useMemo(() => new Map(fornecedores.map(x => [x.id, x.nome])), [fornecedores]);
  const categoriaNome = useMemo(() => new Map(categorias.map(x => [x.id, x.nome])), [categorias]);

  async function loadCombos() {
    const [f, c] = await Promise.all([listFornecedores(), listCategorias()]);
    setFornecedores(f);
    setCategorias(c);
  }

  async function loadList() {
    try {
      setLoading(true);
      setError(null);

      const q = {
        idFornecedor: fFornecedorId || undefined,
        idCategoria: fCategoriaId || undefined,
      };

      setItems(await listModelos(q));
    } catch (e: unknown) {
      setError(getErrorMessage(e) || "Erro ao carregar");
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    void loadCombos().then(loadList);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    void loadList();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [fFornecedorId, fCategoriaId]);

  function openCreate() {
    setEditing(null);
    setForm(emptyForm);
    setIsOpen(true);
  }

  function openEdit(x: Modelo) {
    setEditing(x);
    setForm({ ...x, urlImagem: x.urlImagem ?? "" });
    setIsOpen(true);
  }

  async function onSave(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    try {
      if (!form.descricao || form.descricao.trim().length === 0) throw new Error("Descrição é obrigatória.");
      if (!form.idFornecedor) throw new Error("Fornecedor é obrigatório.");
      if (!form.idCategoria) throw new Error("Categoria é obrigatória.");

      const payload: Omit<Modelo, "id"> = {
        descricao: form.descricao.trim(),
        urlImagem: (form.urlImagem ?? "").trim() || null,
        idFornecedor: Number(form.idFornecedor),
        idCategoria: Number(form.idCategoria),
      };

      if (editing) await updateModelo(editing.id, payload);
      else await createModelo(payload);

      setIsOpen(false);
      await loadList();
    } catch (e: unknown) {
      alert(getErrorMessage(e) || "Erro ao salvar");
    } finally {
      setSaving(false);
    }
  }

  async function onDelete(x: Modelo) {
    if (!confirm(`Remover modelo "${x.descricao}"?`)) return;
    try {
      await deleteModelo(x.id);
      await loadList();
    } catch (e: unknown) {
      alert(getErrorMessage(e) || "Erro ao remover");
    }
  }

  return (
    <div className="cl-page">
      <h1 className="cl-title">Modelos</h1>

      <div className="cl-toolbar" style={{ flexWrap: "wrap" }}>
        <select className="cl-select" value={fFornecedorId} onChange={(e) => setFFornecedorId(Number(e.target.value))}>
          <option value={0}>Fornecedor (todos)</option>
          {fornecedores.map(x => <option key={x.id} value={x.id}>{x.nome}</option>)}
        </select>

        <select className="cl-select" value={fCategoriaId} onChange={(e) => setFCategoriaId(Number(e.target.value))}>
          <option value={0}>Categoria (todas)</option>
          {categorias.map(x => <option key={x.id} value={x.id}>{x.nome}</option>)}
        </select>

        <button className="btn btn-primary" onClick={openCreate}>Novo Modelo</button>
      </div>

      {error && <div className="errorBox">{error}</div>}

      <div className="cl-card">
        <div className="cl-tableWrap">
          {loading ? (
            <div style={{ padding: 16, color: "var(--muted)" }}>Carregando...</div>
          ) : (
            <table className="cl-table" style={{ minWidth: 1100 }}>
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Descrição</th>
                  <th>Fornecedor</th>
                  <th>Categoria</th>
                  <th>Imagem</th>
                  <th style={{ width: 260 }}>Ações</th>
                </tr>
              </thead>
              <tbody>
                {items.map(x => (
                  <tr key={x.id}>
                    <td>{x.id}</td>
                    <td>{x.descricao}</td>
                    <td>{fornecedorNome.get(x.idFornecedor) ?? x.idFornecedor}</td>
                    <td>{categoriaNome.get(x.idCategoria) ?? x.idCategoria}</td>
                    <td title={x.urlImagem ?? ""}>{x.urlImagem ? x.urlImagem.slice(0, 30) + "…" : "-"}</td>
                    <td className="cl-actions">
                      <Link className="btn btn-sm" to={`/modulos?modeloId=${x.id}`}>Módulos</Link>
                      <button className="btn btn-sm" onClick={() => openEdit(x)}>Editar</button>
                      <button className="btn btn-sm btn-danger" onClick={() => onDelete(x)}>Remover</button>
                    </td>
                  </tr>
                ))}
                {!loading && items.length === 0 && (
                  <tr>
                    <td colSpan={6} style={{ padding: 12, textAlign: "center", color: "var(--muted)" }}>
                      Nenhum modelo encontrado
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
              <h3 className="modalTitle">{editing ? "Editar Modelo" : "Novo Modelo"}</h3>
              <button className="btn btn-sm" type="button" onClick={() => setIsOpen(false)}>Fechar</button>
            </div>

            <form onSubmit={onSave}>
              <div className="modalBody">
                <div className="formGrid">
                  <div className="field fieldFull">
                    <div className="label">Descrição*</div>
                    <input className="cl-input" value={form.descricao || ""} onChange={(e) => setForm({ ...form, descricao: e.target.value })} required />
                  </div>

                  <div className="field">
                    <div className="label">Fornecedor*</div>
                    <select className="cl-select" value={form.idFornecedor || 0} onChange={(e) => setForm({ ...form, idFornecedor: Number(e.target.value) })} required>
                      <option value={0}>Selecione...</option>
                      {fornecedores.map(x => <option key={x.id} value={x.id}>{x.nome}</option>)}
                    </select>
                  </div>

                  <div className="field">
                    <div className="label">Categoria*</div>
                    <select className="cl-select" value={form.idCategoria || 0} onChange={(e) => setForm({ ...form, idCategoria: Number(e.target.value) })} required>
                      <option value={0}>Selecione...</option>
                      {categorias.map(x => <option key={x.id} value={x.id}>{x.nome}</option>)}
                    </select>
                  </div>

                  <div className="field fieldFull">
                    <div className="label">URL da Imagem</div>
                    <input className="cl-input" value={form.urlImagem || ""} onChange={(e) => setForm({ ...form, urlImagem: e.target.value })} />
                  </div>
                </div>
              </div>

              <div className="modalFooter">
                <button className="btn" type="button" onClick={() => setIsOpen(false)}>Cancelar</button>
                <button className="btn btn-primary" type="submit" disabled={saving}>
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
  try { return JSON.stringify(e); } catch { return "Erro desconhecido"; }
}
