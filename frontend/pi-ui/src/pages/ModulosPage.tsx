import React, { useEffect, useState, useMemo } from "react";
import { useNavigate } from "react-router-dom";
import "./ClientesPage.css";

import type { Categoria, Fornecedor, Marca, Modulo, ModuloTecido, Tecido } from "../api/types";
import { listCategorias } from "../api/categorias";
import { listFornecedores } from "../api/fornecedores";
import { listMarcas } from "../api/marcas";
import { listTecidos } from "../api/tecidos";
import {
  createModulo,
  deleteModulo,
  listModulos,
  updateModulo,
  createModuloTecido,
  deleteModuloTecido,
  listModulosTecidos,
} from "../api/modulos";

type FormState = Partial<Modulo> & {
  larguraStr?: string;
  profundidadeStr?: string;
  alturaStr?: string;
  paStr?: string;
};

const emptyForm: FormState = {
  descricao: "",
  larguraStr: "0,00",
  profundidadeStr: "0,00",
  alturaStr: "0,00",
  paStr: "0,00",
};

export default function ModulosPage() {
  const navigate = useNavigate();
  const [items, setItems] = useState<Modulo[]>([]);
  const [modulosTecidos, setModulosTecidos] = useState<ModuloTecido[]>([]);
  
  const [categorias, setCategorias] = useState<Categoria[]>([]);
  const [fornecedores, setFornecedores] = useState<Fornecedor[]>([]);
  const [marcas, setMarcas] = useState<Marca[]>([]);
  const [tecidos, setTecidos] = useState<Tecido[]>([]);

  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [search, setSearch] = useState("");

  const [isOpen, setIsOpen] = useState(false);
  const [editing, setEditing] = useState<Modulo | null>(null);
  const [form, setForm] = useState<FormState>(emptyForm);
  const [saving, setSaving] = useState(false);
  const [activeTab, setActiveTab] = useState<"geral" | "tecidos">("geral");

  // Maps for display
  const catMap = useMemo(() => new Map(categorias.map((x) => [x.id, x.nome])), [categorias]);
  const fornMap = useMemo(() => new Map(fornecedores.map((x) => [x.id, x.nome])), [fornecedores]);
  const marcaMap = useMemo(() => new Map(marcas.map((x) => [x.id, x.nome])), [marcas]);
  const tecidoMap = useMemo(() => new Map(tecidos.map((x) => [x.id, x.nome])), [tecidos]);

  async function loadAll() {
    try {
      setLoading(true);
      setError(null);
      const [m, mt, c, f, ma, t] = await Promise.all([
        listModulos(),
        listModulosTecidos(),
        listCategorias(),
        listFornecedores(),
        listMarcas(),
        listTecidos(),
      ]);
      setItems(m);
      setModulosTecidos(mt);
      setCategorias(c);
      setFornecedores(f);
      setMarcas(ma);
      setTecidos(t);
    } catch (e: unknown) {
      setError(getErrorMessage(e));
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    void loadAll();
  }, []);

  const filteredItems = useMemo(() => {
    if (!search) return items;
    const lower = search.toLowerCase();
    return items.filter((x) =>
      x.descricao.toLowerCase().includes(lower) || String(x.id).includes(lower)
    );
  }, [items, search]);

  function openCreate() {
    setEditing(null);
    setForm(emptyForm);
    setActiveTab("geral");
    setIsOpen(true);
  }

  function openEdit(x: Modulo) {
    setEditing(x);
    setForm({
      ...x,
      larguraStr: fmt(x.largura),
      profundidadeStr: fmt(x.profundidade),
      alturaStr: fmt(x.altura),
      paStr: fmt(x.pa),
    });
    setActiveTab("geral");
    setIsOpen(true);
  }

  async function onSaveGeral(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    try {
      if (!form.descricao) throw new Error("Descrição é obrigatória");
      if (!form.idFornecedor) throw new Error("Fornecedor é obrigatório");
      if (!form.idCategoria) throw new Error("Categoria é obrigatória");
      if (!form.idMarca) throw new Error("Marca é obrigatória");

      const payload = {
        idFornecedor: Number(form.idFornecedor),
        idCategoria: Number(form.idCategoria),
        idMarca: Number(form.idMarca),
        descricao: form.descricao,
        largura: parse(form.larguraStr),
        profundidade: parse(form.profundidadeStr),
        altura: parse(form.alturaStr),
        pa: parse(form.paStr),
      };

      if (editing) {
        await updateModulo(editing.id, payload);
        // Reload list but keep modal open to edit fabrics if needed
        const updatedList = await listModulos();
        setItems(updatedList);
        
        // Update editing state to reflect persisted changes
        const updatedItem = updatedList.find(i => i.id === editing.id);
        if (updatedItem) setEditing(updatedItem);
        
        alert("Módulo atualizado!");
      } else {
        const created = await createModulo(payload);
        setEditing(created); // Now we have an ID to add fabrics
        alert("Módulo criado! Agora você pode adicionar tecidos.");
        
        const updatedList = await listModulos();
        setItems(updatedList);
      }
    } catch (e: unknown) {
      alert(getErrorMessage(e));
    } finally {
      setSaving(false);
    }
  }

  async function onDelete(x: Modulo) {
    if (!confirm(`Remover módulo "${x.descricao}"?`)) return;
    try {
      await deleteModulo(x.id);
      await loadAll();
    } catch (e: unknown) {
      alert(getErrorMessage(e));
    }
  }

  return (
    <div style={{ padding: 16 }}>
      <h1>Módulos</h1>
      <div style={{ display: "flex", gap: 8, marginBottom: 12 }}>
        <input
          placeholder="Buscar módulo..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          style={{ flex: 1, padding: 8 }}
        />
        <button className="btn btn-primary" onClick={openCreate}>Novo</button>
      </div>

      {error && <div style={{ color: "red" }}>{error}</div>}

      {loading ? (
        <div>Carregando...</div>
      ) : (
        <table style={{ width: "100%", borderCollapse: "collapse" }}>
          <thead>
            <tr>
              <th style={th}>ID</th>
              <th style={th}>Descrição</th>
              <th style={th}>Fornecedor</th>
              <th style={th}>Categoria</th>
              <th style={th}>Marca</th>
              <th style={th}>Dimensões (LxPxA)</th>
              <th style={th}>M³</th>
              <th style={th}>Tecidos / Valores</th>
              <th style={th}>Ações</th>
            </tr>
          </thead>
          <tbody>
            {filteredItems.map((x) => {
               // Find related fabrics
               const myTecidos = modulosTecidos.filter(mt => mt.idModulo === x.id);

               return (
                <tr key={x.id}>
                    <td style={td}>{x.id}</td>
                    <td style={td}>{x.descricao}</td>
                    <td style={td}>{fornMap.get(x.idFornecedor) || x.idFornecedor}</td>
                    <td style={td}>{catMap.get(x.idCategoria) || x.idCategoria}</td>
                    <td style={td}>{marcaMap.get(x.idMarca) || x.idMarca}</td>
                    <td style={td}>
                    {fmt(x.largura)} x {fmt(x.profundidade)} x {fmt(x.altura)}
                    </td>
                    <td style={td}>{fmt(x.m3)}</td>
                    <td style={td}>
                        {myTecidos.length > 0 ? (
                            <div style={{ display: 'flex', flexDirection: 'column', gap: 4 }}>
                                {myTecidos.map(mt => (
                                    <div key={mt.id} style={{ fontSize: '0.9em' }}>
                                        <span style={{ fontWeight: 500, color: '#94a3b8' }}>
                                            {tecidoMap.get(mt.idTecido) || mt.idTecido}:
                                        </span>
                                        {' '}
                                        <span style={{ color: '#e5e7eb' }}>
                                            R$ {fmt(mt.valorTecido, 3)}
                                        </span>
                                    </div>
                                ))}
                            </div>
                        ) : (
                            <span style={{ color: '#666', fontSize: '0.85em' }}>-</span>
                        )}
                    </td>
                    <td style={td}>
                    <button className="btn btn-sm" onClick={() => openEdit(x)}>Editar</button>{" "}
                    <button className="btn btn-danger btn-sm" onClick={() => onDelete(x)}>
                        Remover
                    </button>
                    </td>
                </tr>
               );
            })}
          </tbody>
        </table>
      )}

      {isOpen && (
        <div className="modalOverlay" onMouseDown={() => setIsOpen(false)}>
          <div className="modalCard" onMouseDown={(e) => e.stopPropagation()}>
            <div className="modalHeader">
              <h3 className="modalTitle">
                {editing ? `Editar Módulo #${editing.id}` : "Novo Módulo"}
              </h3>
              <button className="btn btn-sm" onClick={() => setIsOpen(false)}>
                Fechar
              </button>
            </div>

            <div style={{ padding: "0 16px", borderBottom: "1px solid #ddd" }}>
              <div style={{ display: "flex", gap: 16 }}>
                <button
                  className="btn"
                  style={tabStyle(activeTab === "geral")}
                  onClick={() => setActiveTab("geral")}
                >
                  Geral
                </button>
                <button
                  className="btn"
                  style={tabStyle(activeTab === "tecidos")}
                  onClick={() => {
                    if (!editing) alert("Salve o módulo antes de adicionar tecidos.");
                    else setActiveTab("tecidos");
                  }}
                  disabled={!editing}
                >
                  Tecidos
                </button>
              </div>
            </div>

            <div className="modalBody" style={{ minHeight: 300 }}>
              {activeTab === "geral" ? (
                <form onSubmit={onSaveGeral}>
                  <div className="formGrid">
                    <div className="field">
                      <label className="label">Descrição*</label>
                      <input
                        className="cl-input"
                        value={form.descricao}
                        onChange={(e) => setForm({ ...form, descricao: e.target.value })}
                        required
                      />
                    </div>
                    <div className="field">
                      <label className="label">Fornecedor*</label>
                      <select
                        className="cl-select"
                        value={form.idFornecedor || ""}
                        onChange={(e) => setForm({ ...form, idFornecedor: Number(e.target.value) })}
                        required
                      >
                        <option value="">Selecione...</option>
                        {fornecedores.map((f) => (
                          <option key={f.id} value={f.id}>
                            {f.nome}
                          </option>
                        ))}
                      </select>
                    </div>
                    <div className="field">
                      <label className="label">Categoria*</label>
                      <select
                        className="cl-select"
                        value={form.idCategoria || ""}
                        onChange={(e) => setForm({ ...form, idCategoria: Number(e.target.value) })}
                        required
                      >
                        <option value="">Selecione...</option>
                        {categorias.map((c) => (
                          <option key={c.id} value={c.id}>
                            {c.nome}
                          </option>
                        ))}
                      </select>
                    </div>
                    <div className="field">
                      <label className="label">Marca*</label>
                      <div style={{ display: "flex", gap: 8 }}>
                        <select
                          className="cl-select"
                          value={form.idMarca || ""}
                          onChange={(e) => setForm({ ...form, idMarca: Number(e.target.value) })}
                          required
                          style={{ flex: 1 }}
                        >
                          <option value="">Selecione...</option>
                          {marcas.map((m) => (
                            <option key={m.id} value={m.id}>
                              {m.nome}
                            </option>
                          ))}
                        </select>
                        <button
                          type="button"
                          className="btn btn-sm"
                          onClick={() => navigate("/marcas")}
                          title="Cadastrar nova marca"
                          style={{ minWidth: "40px" }}
                        >
                          +
                        </button>
                      </div>
                    </div>

                    <div className="field">
                      <label className="label">Largura</label>
                      <input
                        className="cl-input"
                        value={form.larguraStr}
                        onChange={(e) => setForm({ ...form, larguraStr: e.target.value })}
                      />
                    </div>
                    <div className="field">
                      <label className="label">Profundidade</label>
                      <input
                        className="cl-input"
                        value={form.profundidadeStr}
                        onChange={(e) => setForm({ ...form, profundidadeStr: e.target.value })}
                      />
                    </div>
                    <div className="field">
                      <label className="label">Altura</label>
                      <input
                        className="cl-input"
                        value={form.alturaStr}
                        onChange={(e) => setForm({ ...form, alturaStr: e.target.value })}
                      />
                    </div>
                    <div className="field">
                      <label className="label">PA</label>
                      <input
                        className="cl-input"
                        value={form.paStr}
                        onChange={(e) => setForm({ ...form, paStr: e.target.value })}
                      />
                    </div>
                  </div>
                  <div style={{ marginTop: 16, display: "flex", justifyContent: "flex-end" }}>
                    <button className="btn btn-primary" type="submit" disabled={saving}>
                      {saving ? "Salvando..." : "Salvar Geral"}
                    </button>
                  </div>
                </form>
              ) : (
                <TecidosTab
                  moduloId={editing!.id}
                  allTecidos={tecidos}
                  currentLinks={modulosTecidos.filter((mt) => mt.idModulo === editing!.id)}
                  onUpdate={() =>
                    listModulosTecidos().then(setModulosTecidos)
                  }
                />
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

function TecidosTab({
  moduloId,
  allTecidos,
  currentLinks,
  onUpdate,
}: {
  moduloId: number;
  allTecidos: Tecido[];
  currentLinks: ModuloTecido[];
  onUpdate: () => void;
}) {
  const [selTecido, setSelTecido] = useState("");
  const [valor, setValor] = useState("0,000");
  const [adding, setAdding] = useState(false);

  async function add() {
    if (!selTecido) return alert("Selecione um tecido");
    setAdding(true);
    try {
      await createModuloTecido({
        idModulo: moduloId,
        idTecido: Number(selTecido),
        valorTecido: parse(valor),
      });
      setSelTecido("");
      setValor("0,000");
      onUpdate();
    } catch (e) {
      alert(getErrorMessage(e));
    } finally {
      setAdding(false);
    }
  }

  async function remove(id: number) {
    if (!confirm("Remover tecido?")) return;
    try {
      await deleteModuloTecido(id);
      onUpdate();
    } catch (e) {
      alert(getErrorMessage(e));
    }
  }

  return (
    <div>
      <div style={{ display: "flex", gap: 8, alignItems: "flex-end", marginBottom: 16 }}>
        <div style={{ flex: 1 }}>
          <label className="label">Tecido</label>
          <select
            className="cl-select"
            value={selTecido}
            onChange={(e) => setSelTecido(e.target.value)}
          >
            <option value="">Selecione...</option>
            {allTecidos.map((t) => (
              <option key={t.id} value={t.id}>
                {t.nome}
              </option>
            ))}
          </select>
        </div>
        <div style={{ width: 120 }}>
          <label className="label">Valor</label>
          <input
            className="cl-input"
            value={valor}
            onChange={(e) => setValor(e.target.value)}
          />
        </div>
        <button className="btn btn-primary" onClick={add} disabled={adding}>
          Adicionar
        </button>
      </div>

      <table className="cl-table">
        <thead>
          <tr>
            <th>Tecido</th>
            <th>Valor</th>
            <th>Ações</th>
          </tr>
        </thead>
        <tbody>
          {currentLinks.map((link) => {
            const t = allTecidos.find((x) => x.id === link.idTecido);
            return (
              <tr key={link.id}>
                <td>{t?.nome || link.idTecido}</td>
                <td>{fmt(link.valorTecido, 3)}</td>
                <td>
                  <button
                    className="btn btn-sm btn-danger"
                    onClick={() => remove(link.id)}
                  >
                    Remover
                  </button>
                </td>
              </tr>
            );
          })}
          {currentLinks.length === 0 && (
            <tr>
              <td colSpan={3} style={{ textAlign: "center", padding: 12, color: "#888" }}>
                Nenhum tecido vinculado.
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
}

// Helpers
const th: React.CSSProperties = {
  textAlign: "left",
  borderBottom: "1px solid #ddd",
  padding: 8,
};
const td: React.CSSProperties = { borderBottom: "1px solid #eee", padding: 8 };

function tabStyle(active: boolean): React.CSSProperties {
  return {
    padding: "10px 16px",
    background: "transparent",
    border: "none",
    borderBottom: active ? "2px solid #2563eb" : "2px solid transparent",
    color: active ? "#2563eb" : "#666",
    fontWeight: active ? 600 : 400,
    cursor: "pointer",
  };
}

function fmt(n: number | undefined, decimals = 2) {
  return (n ?? 0).toLocaleString("pt-BR", {
    minimumFractionDigits: decimals,
    maximumFractionDigits: decimals,
  });
}

function parse(s: string | undefined): number {
  if (!s) return 0;
  // Pt-BR '1.000,50' -> replace . then comma->dot
  return Number(s.replace(/\./g, "").replace(",", "."));
}

function getErrorMessage(e: unknown): string {
  if (e instanceof Error) return e.message;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  if (typeof e === "object" && e && (e as any).message) return (e as any).message;
  return "Erro desconhecido";
}
