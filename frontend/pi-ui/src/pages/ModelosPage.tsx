import React, { useEffect, useMemo, useState } from "react";
import "./ClientesPage.css";
import type { Categoria, Fornecedor, Modelo, Tecido } from "../api/types";
import { listCategorias } from "../api/categorias";
import { listTecidos } from "../api/tecidos";
import { listFornecedores } from "../api/fornecedores";
import {
  createModelo,
  deleteModelo,
  listModelos,
  updateModelo,
} from "../api/modelos";

type FormState = Partial<Modelo>;

const emptyForm: FormState = {
  descricao: "",
  fornecedorId: 0,
  categoriaId: 0,
  tecidoId: 0,
  largura: 0,
  profundidade: 0,
  altura: 0,
  pa: null,
  valorTecido: 0,
};

function toNumber(v: string): number {
  // aceita "1,23" (pt-BR) e "1.23"
  const normalized = v.replace(/\./g, "").replace(",", ".");
  const n = Number(normalized);
  return Number.isFinite(n) ? n : 0;
}

function calcM3(l?: number, p?: number, a?: number): number {
  const L = Number(l ?? 0);
  const P = Number(p ?? 0);
  const A = Number(a ?? 0);
  const m3 = (L * P * A) / 1_000_000; // se suas medidas são em mm; ajuste se for cm/m
  // se no backend você usa outra unidade, me diga e eu ajusto
  return Number.isFinite(m3) ? m3 : 0;
}

export default function ModelosPage() {
  // combos
  const [fornecedores, setFornecedores] = useState<Fornecedor[]>([]);
  const [categorias, setCategorias] = useState<Categoria[]>([]);
  const [tecidos, setTecidos] = useState<Tecido[]>([]);

  // filtros
  const [fFornecedorId, setFFornecedorId] = useState<number>(0);
  const [fCategoriaId, setFCategoriaId] = useState<number>(0);
  const [fTecidoId, setFTecidoId] = useState<number>(0);

  // lista
  const [items, setItems] = useState<Modelo[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // modal
  const [isOpen, setIsOpen] = useState(false);
  const [editing, setEditing] = useState<Modelo | null>(null);
  const [form, setForm] = useState<FormState>(emptyForm);
  const [saving, setSaving] = useState(false);

  const fornecedorNome = useMemo(
    () => new Map(fornecedores.map((x) => [x.id, x.nome])),
    [fornecedores],
  );
  const categoriaNome = useMemo(
    () => new Map(categorias.map((x) => [x.id, x.nome])),
    [categorias],
  );
  const tecidoNome = useMemo(
    () => new Map(tecidos.map((x) => [x.id, x.nome])),
    [tecidos],
  );

  const m3Preview = useMemo(() => {
    // preferir o valor vindo do backend; se não vier, calcular
    const fromApi = form.m3;
    if (fromApi !== undefined && fromApi !== null) return fromApi;
    return calcM3(form.largura, form.profundidade, form.altura);
  }, [form.m3, form.largura, form.profundidade, form.altura]);

  async function loadCombos() {
    const [f, c, t] = await Promise.all([
      listFornecedores(),
      listCategorias(),
      listTecidos(),
    ]);
    setFornecedores(f);
    setCategorias(c);
    setTecidos(t);
  }

  async function loadList() {
    try {
      setLoading(true);
      setError(null);

      const q = {
        fornecedorId: fFornecedorId || undefined,
        categoriaId: fCategoriaId || undefined,
        tecidoId: fTecidoId || undefined,
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
  }, [fFornecedorId, fCategoriaId, fTecidoId]);

  function openCreate() {
    setEditing(null);
    setForm(emptyForm);
    setIsOpen(true);
  }

  function openEdit(x: Modelo) {
    setEditing(x);
    setForm({ ...x });
    setIsOpen(true);
  }

  async function onSave(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);

    try {
      // validações mínimas
      if (!form.descricao || form.descricao.trim().length === 0)
        throw new Error("Descrição é obrigatória.");
      if (!form.fornecedorId) throw new Error("Fornecedor é obrigatório.");
      if (!form.categoriaId) throw new Error("Categoria é obrigatória.");
      if (!form.tecidoId) throw new Error("Tecido é obrigatório.");

      const payload = {
        descricao: form.descricao.trim(),
        fornecedorId: Number(form.fornecedorId),
        categoriaId: Number(form.categoriaId),
        tecidoId: Number(form.tecidoId),

        largura: Number(form.largura ?? 0),
        profundidade: Number(form.profundidade ?? 0),
        altura: Number(form.altura ?? 0),

        pa: form.pa === null || form.pa === undefined ? null : Number(form.pa),

        valorTecido: Number(form.valorTecido ?? 0),
      };

      if (editing) {
        await updateModelo(editing.id, payload);
      } else {
        await createModelo(payload);
      }

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

      {/* Filtros */}
      <div className="cl-toolbar" style={{ flexWrap: "wrap" }}>
        <select
          className="cl-select"
          value={fFornecedorId}
          onChange={(e) => setFFornecedorId(Number(e.target.value))}
        >
          <option value={0}>Fornecedor (todos)</option>
          {fornecedores.map((x) => (
            <option key={x.id} value={x.id}>
              {x.nome}
            </option>
          ))}
        </select>

        <select
          className="cl-select"
          value={fCategoriaId}
          onChange={(e) => setFCategoriaId(Number(e.target.value))}
        >
          <option value={0}>Categoria (todas)</option>
          {categorias.map((x) => (
            <option key={x.id} value={x.id}>
              {x.nome}
            </option>
          ))}
        </select>

        <select
          className="cl-select"
          value={fTecidoId}
          onChange={(e) => setFTecidoId(Number(e.target.value))}
        >
          <option value={0}>Tecido (todos)</option>
          {tecidos.map((x) => (
            <option key={x.id} value={x.id}>
              {x.nome}
            </option>
          ))}
        </select>

        <button className="btn btn-primary" onClick={openCreate}>
          Novo Modelo
        </button>
      </div>

      {error && <div className="errorBox">{error}</div>}

      {/* Lista */}
      <div className="cl-card">
        <div className="cl-tableWrap">
          {loading ? (
            <div style={{ padding: 16, color: "var(--muted)" }}>
              Carregando...
            </div>
          ) : (
            <table className="cl-table" style={{ minWidth: 1200 }}>
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Descrição</th>
                  <th>Fornecedor</th>
                  <th>Categoria</th>
                  <th>Tecido</th>
                  <th>L</th>
                  <th>P</th>
                  <th>A</th>
                  <th>PA</th>
                  <th>M³</th>
                  <th>Valor Tecido</th>
                  <th style={{ width: 220 }}>Ações</th>
                </tr>
              </thead>
              <tbody>
                {items.map((x) => {
                  const m3 =
                    x.m3 ?? calcM3(x.largura, x.profundidade, x.altura);
                  return (
                    <tr key={x.id}>
                      <td>{x.id}</td>
                      <td>{x.descricao}</td>
                      <td>
                        {fornecedorNome.get(x.fornecedorId) ?? x.fornecedorId}
                      </td>
                      <td>
                        {categoriaNome.get(x.categoriaId) ?? x.categoriaId}
                      </td>
                      <td>{tecidoNome.get(x.tecidoId) ?? x.tecidoId}</td>
                      <td>{x.largura}</td>
                      <td>{x.profundidade}</td>
                      <td>{x.altura}</td>
                      <td>{x.pa ?? "-"}</td>
                      <td>{Number(m3).toFixed(4)}</td>
                      <td>{x.valorTecido}</td>
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
                  );
                })}
                {!loading && items.length === 0 && (
                  <tr>
                    <td
                      colSpan={12}
                      style={{
                        padding: 12,
                        textAlign: "center",
                        color: "var(--muted)",
                      }}
                    >
                      Nenhum modelo encontrado
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          )}
        </div>
      </div>

      {/* Modal */}
      {isOpen && (
        <div className="modalOverlay" onMouseDown={() => setIsOpen(false)}>
          <div className="modalCard" onMouseDown={(e) => e.stopPropagation()}>
            <div className="modalHeader">
              <h3 className="modalTitle">
                {editing ? "Editar Modelo" : "Novo Modelo"}
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
                    <div className="label">Descrição*</div>
                    <input
                      className="cl-input"
                      value={form.descricao || ""}
                      onChange={(e) =>
                        setForm({ ...form, descricao: e.target.value })
                      }
                      required
                    />
                  </div>

                  <div className="field">
                    <div className="label">Fornecedor*</div>
                    <select
                      className="cl-select"
                      value={form.fornecedorId || 0}
                      onChange={(e) =>
                        setForm({
                          ...form,
                          fornecedorId: Number(e.target.value),
                        })
                      }
                      required
                    >
                      <option value={0}>Selecione...</option>
                      {fornecedores.map((x) => (
                        <option key={x.id} value={x.id}>
                          {x.nome}
                        </option>
                      ))}
                    </select>
                  </div>

                  <div className="field">
                    <div className="label">Categoria*</div>
                    <select
                      className="cl-select"
                      value={form.categoriaId || 0}
                      onChange={(e) =>
                        setForm({
                          ...form,
                          categoriaId: Number(e.target.value),
                        })
                      }
                      required
                    >
                      <option value={0}>Selecione...</option>
                      {categorias.map((x) => (
                        <option key={x.id} value={x.id}>
                          {x.nome}
                        </option>
                      ))}
                    </select>
                  </div>

                  <div className="field">
                    <div className="label">Tecido*</div>
                    <select
                      className="cl-select"
                      value={form.tecidoId || 0}
                      onChange={(e) =>
                        setForm({ ...form, tecidoId: Number(e.target.value) })
                      }
                      required
                    >
                      <option value={0}>Selecione...</option>
                      {tecidos.map((x) => (
                        <option key={x.id} value={x.id}>
                          {x.nome}
                        </option>
                      ))}
                    </select>
                  </div>

                  <div className="field">
                    <div className="label">PA (nullable)</div>
                    <input
                      className="cl-input"
                      placeholder="vazio = null"
                      value={
                        form.pa === null || form.pa === undefined
                          ? ""
                          : String(form.pa)
                      }
                      onChange={(e) =>
                        setForm({
                          ...form,
                          pa:
                            e.target.value.trim() === ""
                              ? null
                              : toNumber(e.target.value),
                        })
                      }
                    />
                  </div>

                  <div className="field">
                    <div className="label">Largura</div>
                    <input
                      className="cl-input"
                      value={String(form.largura ?? 0)}
                      onChange={(e) =>
                        setForm({ ...form, largura: toNumber(e.target.value) })
                      }
                    />
                  </div>

                  <div className="field">
                    <div className="label">Profundidade</div>
                    <input
                      className="cl-input"
                      value={String(form.profundidade ?? 0)}
                      onChange={(e) =>
                        setForm({
                          ...form,
                          profundidade: toNumber(e.target.value),
                        })
                      }
                    />
                  </div>

                  <div className="field">
                    <div className="label">Altura</div>
                    <input
                      className="cl-input"
                      value={String(form.altura ?? 0)}
                      onChange={(e) =>
                        setForm({ ...form, altura: toNumber(e.target.value) })
                      }
                    />
                  </div>

                  <div className="field">
                    <div className="label">M³ (preview)</div>
                    <input
                      className="cl-input"
                      value={Number(m3Preview).toFixed(6)}
                      disabled
                    />
                  </div>

                  <div className="field">
                    <div className="label">Valor Tecido</div>
                    <input
                      className="cl-input"
                      value={String(form.valorTecido ?? 0)}
                      onChange={(e) =>
                        setForm({
                          ...form,
                          valorTecido: toNumber(e.target.value),
                        })
                      }
                    />
                  </div>
                </div>

                <div
                  style={{ marginTop: 10, color: "var(--muted)", fontSize: 12 }}
                >
                  * O M³ acima é apenas para exibição. Se o backend retornar
                  `m3`, ele prevalece.
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
