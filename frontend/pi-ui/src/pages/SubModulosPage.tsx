import React, { useEffect, useState, useMemo, useCallback } from "react";
import { Layers, HelpCircle, Grid, Trash2, Edit } from "lucide-react";
import "./ClientesPage.css"; // Reuse modal styles
import PageHeader from "../components/PageHeader";
import type { SubModulo, Modulo, Tecido, Marca } from "../api/types";
import { SearchableSelect } from "../components/SearchableSelect";
import {
  listSubModulos,
  createSubModulo,
  updateSubModulo,
  deleteSubModulo,
} from "../api/submodulos";
import { listModulos } from "../api/modulos";
import { listTecidos } from "../api/tecidos";
import { listMarcas } from "../api/marcas";

type FormState = Partial<SubModulo> & {
  volumeM3Str?: string;
};

const emptyForm: FormState = {
  codigo: "",
  descricaoProduto: "",
  tecidoEspecifico: "",
  volumeM3Str: "0,000000",
};

export default function SubModulosPage() {
  const [subModulos, setSubModulos] = useState<SubModulo[]>([]);
  const [modulos, setModulos] = useState<Modulo[]>([]);
  const [tecidos, setTecidos] = useState<Tecido[]>([]);
  const [marcas, setMarcas] = useState<Marca[]>([]);

  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Search & Filtering
  const [search, setSearch] = useState("");
  const [filterModulo, setFilterModulo] = useState<string>("");
  const [filterTecidoBase, setFilterTecidoBase] = useState<string>("");

  // Pagination
  const [page, setPage] = useState(1);
  const pageSize = 12;

  // Modal / Form state
  const [isOpen, setIsOpen] = useState(false);
  const [editing, setEditing] = useState<SubModulo | null>(null);
  const [form, setForm] = useState<FormState>(emptyForm);
  const [saving, setSaving] = useState(false);

  // Load static reference databases
  const loadReferences = useCallback(async () => {
    try {
      const [modRes, tecRes, marRes] = await Promise.all([
        listModulos("", 1, 5000, undefined, undefined, undefined, undefined, "todos"),
        listTecidos(),
        listMarcas(),
      ]);
      setModulos(modRes.items);
      setTecidos(tecRes);
      setMarcas(marRes);
    } catch (e) {
      console.error("Erro ao carregar referências para SubMódulos", e);
    }
  }, []);

  useEffect(() => {
    loadReferences();
  }, [loadReferences]);

  // Load SubModulos
  const loadSubModulos = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);
      // Fetches all submodules belonging to current modulo filter, or all active
      const res = await listSubModulos(filterModulo ? Number(filterModulo) : undefined);
      setSubModulos(res);
    } catch (err) {
      setError(getErrorMessage(err));
    } finally {
      setLoading(false);
    }
  }, [filterModulo]);

  useEffect(() => {
    loadSubModulos();
  }, [loadSubModulos]);

  // Map database elements for fast display
  const marcasMap = useMemo(() => new Map(marcas.map((m) => [m.id, m.nome])), [marcas]);
  
  const modulosMap = useMemo(() => {
    const map = new Map<number, { descricao: string; marcaNome: string; largura: number }>();
    modulos.forEach((m) => {
      const brandName = marcasMap.get(m.idMarca) || "Modelo Geral";
      map.set(m.id, {
        descricao: m.descricao,
        marcaNome: brandName,
        largura: m.largura,
      });
    });
    return map;
  }, [modulos, marcasMap]);

  const tecidosMap = useMemo(() => new Map(tecidos.map((t) => [t.id, t.nome])), [tecidos]);

  // Client-side search and tecido filter over the submodules
  const filteredSubModulos = useMemo(() => {
    let list = subModulos;

    if (filterTecidoBase) {
      list = list.filter((s) => s.idTecidoBase === Number(filterTecidoBase));
    }

    if (search.trim()) {
      const q = search.toLowerCase();
      list = list.filter((s) => {
        const modInfo = modulosMap.get(s.idModulo);
        const modDesc = modInfo ? `${modInfo.marcaNome} ${modInfo.descricao}`.toLowerCase() : "";
        const tecBase = tecidosMap.get(s.idTecidoBase)?.toLowerCase() || "";
        
        return (
          s.codigo.toLowerCase().includes(q) ||
          s.descricaoProduto.toLowerCase().includes(q) ||
          s.tecidoEspecifico.toLowerCase().includes(q) ||
          tecBase.includes(q) ||
          modDesc.includes(q)
        );
      });
    }

    return list;
  }, [subModulos, search, filterTecidoBase, modulosMap, tecidosMap]);

  // Pagination bounds
  const totalPages = Math.ceil(filteredSubModulos.length / pageSize) || 1;
  const paginatedItems = useMemo(() => {
    const startIndex = (page - 1) * pageSize;
    return filteredSubModulos.slice(startIndex, startIndex + pageSize);
  }, [filteredSubModulos, page, pageSize]);

  useEffect(() => {
    setPage(1);
  }, [search, filterModulo, filterTecidoBase]);

  // Number conversion helper
  function fmt(val: number | undefined, dec = 6): string {
    if (val === undefined || isNaN(val)) return "0";
    return val.toLocaleString("pt-BR", {
      minimumFractionDigits: dec,
      maximumFractionDigits: dec,
    });
  }

  function parse(val: string | undefined): number {
    if (!val) return 0;
    const clean = val.replace(/\./g, "").replace(",", ".");
    return parseFloat(clean) || 0;
  }

  // Action methods
  function openCreate() {
    setEditing(null);
    setForm(emptyForm);
    setIsOpen(true);
  }

  function openEdit(x: SubModulo) {
    setEditing(x);
    setForm({
      ...x,
      volumeM3Str: fmt(x.volumeM3, 6),
    });
    setIsOpen(true);
  }

  async function onSave(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    try {
      if (!form.codigo) throw new Error("Código do produto é obrigatório.");
      if (!form.idModulo) throw new Error("Módulo pai é obrigatório.");
      if (!form.idTecidoBase) throw new Error("Tecido base é obrigatório.");
      if (!form.descricaoProduto) throw new Error("Descrição é obrigatória.");
      if (!form.tecidoEspecifico) throw new Error("Tecido específico é obrigatório.");

      const payload = {
        idModulo: Number(form.idModulo),
        idTecidoBase: Number(form.idTecidoBase),
        codigo: form.codigo.trim(),
        descricaoProduto: form.descricaoProduto.trim(),
        tecidoEspecifico: form.tecidoEspecifico.trim(),
        volumeM3: parse(form.volumeM3Str),
        flAtivo: form.flAtivo !== false,
      };

      if (editing) {
        await updateSubModulo(editing.id, payload);
        alert("SubMódulo atualizado com sucesso!");
      } else {
        await createSubModulo(payload);
        alert("SubMódulo cadastrado com sucesso!");
      }

      setIsOpen(false);
      await loadSubModulos();
    } catch (e: unknown) {
      alert(getErrorMessage(e));
    } finally {
      setSaving(false);
    }
  }

  async function onDelete(x: SubModulo) {
    if (!confirm(`Deseja realmente excluir o SubMódulo "${x.descricaoProduto}" (Código: ${x.codigo})?`)) return;
    try {
      await deleteSubModulo(x.id);
      await loadSubModulos();
    } catch (e: unknown) {
      alert(getErrorMessage(e));
    }
  }

  return (
    <div className="list-container">
      <PageHeader title="SubMódulos" icon={<Layers size={24} />} />

      {/* Toolbar / Filters */}
      <div
        style={{
          background: "rgba(255, 255, 255, 0.04)",
          backdropFilter: "blur(8px)",
          border: "1px solid var(--line)",
          padding: 16,
          borderRadius: 8,
          marginBottom: 16,
          display: "flex",
          gap: 10,
          flexWrap: "wrap",
          alignItems: "center",
        }}
      >
        <div style={{ width: 300 }}>
          <SearchableSelect
            value={filterModulo}
            onChange={(val) => setFilterModulo(val)}
            placeholder="Filtrar por Módulo (Todos)"
            options={[
              { value: "", label: "Filtrar por Módulo (Todos)" },
              ...modulos.map((m) => {
                const info = modulosMap.get(m.id);
                const label = info
                  ? `${info.marcaNome} - ${info.descricao} (${fmt(info.largura, 2)}m)`
                  : m.descricao;
                return { value: m.id, label };
              }),
            ]}
          />
        </div>

        <div style={{ width: 220 }}>
          <SearchableSelect
            value={filterTecidoBase}
            onChange={(val) => setFilterTecidoBase(val)}
            placeholder="Tecido Base (Todos)"
            options={[
              { value: "", label: "Tecido Base (Todos)" },
              ...tecidos.map((t) => ({ value: t.id, label: t.nome })),
            ]}
          />
        </div>

        <div style={{ flex: 1, minWidth: 200 }}>
          <input
            type="text"
            className="cl-input"
            placeholder="Buscar por código, descrição ou tecido específico..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            style={{ width: "100%", height: 38 }}
          />
        </div>

        <div style={{ display: "flex", gap: 8 }}>
          <button
            className="btn btn-secondary"
            onClick={() => {
              setFilterModulo("");
              setFilterTecidoBase("");
              setSearch("");
            }}
            style={{ height: "38px" }}
            title="Limpar todos os filtros"
          >
            🧹 Limpar
          </button>
          <button className="btn btn-primary" onClick={openCreate} style={{ height: "38px" }}>
            Novo
          </button>
        </div>
      </div>

      <div style={{ marginBottom: 12, display: "flex", justifyContent: "space-between", color: "#94a3b8" }}>
        <span>Total encontrado: {filteredSubModulos.length} itens</span>
        <span>Página {page} de {totalPages}</span>
      </div>

      {error && <div style={{ color: "#f87171", padding: 12, border: "1px solid #f87171", borderRadius: 4, marginBottom: 16 }}>{error}</div>}

      {loading ? (
        <div style={{ padding: 32, textAlign: "center" }}>Carregando dados dos SubMódulos...</div>
      ) : (
        <>
          <table style={{ width: "100%", borderCollapse: "collapse" }}>
            <thead>
              <tr>
                <th style={th}>Código</th>
                <th style={th}>Módulo Pai</th>
                <th style={th}>Tecido Base</th>
                <th style={th}>Descrição Comercial / Produto</th>
                <th style={th}>Tecido Específico</th>
                <th style={{ ...th, textAlign: "right", borderBottom: "1px solid rgba(255, 255, 255, 0.15)", padding: 8 }}>Volume (M³)</th>
                <th style={{ ...th, textAlign: "center", borderBottom: "1px solid rgba(255, 255, 255, 0.15)", padding: 8 }}>Ações</th>
              </tr>
            </thead>
            <tbody>
              {paginatedItems.map((x) => {
                const modInfo = modulosMap.get(x.idModulo);
                const modLabel = modInfo
                  ? `${modInfo.marcaNome} - ${modInfo.descricao} (${fmt(modInfo.largura, 2)}m)`
                  : `ID: ${x.idModulo}`;

                return (
                  <tr key={x.id} style={{ transition: "background 0.2s" }} className="table-row-hover">
                    <td style={{ ...td, borderBottom: "1px solid rgba(255, 255, 255, 0.08)", padding: "10px 8px", fontWeight: "bold", color: "#60a5fa" }}>
                      {x.codigo}
                    </td>
                    <td style={td}>{modLabel}</td>
                    <td style={td}>{tecidosMap.get(x.idTecidoBase) || `ID: ${x.idTecidoBase}`}</td>
                    <td style={{ ...td, borderBottom: "1px solid rgba(255, 255, 255, 0.08)", padding: "10px 8px", color: "#e5e7eb" }}>
                      {x.descricaoProduto}
                    </td>
                    <td style={td}>
                      <span className="badge" style={{ background: "rgba(167, 139, 250, 0.15)", color: "#c084fc", padding: "4px 8px", borderRadius: "4px", fontSize: "0.85rem" }}>
                        {x.tecidoEspecifico}
                      </span>
                    </td>
                    <td style={{ borderBottom: "1px solid #eee", padding: "10px 8px", textAlign: "right", color: "#10b981", fontWeight: "500" }}>
                      {fmt(x.volumeM3, 6)} m³
                    </td>
                    <td style={{ borderBottom: "1px solid #eee", padding: "10px 8px", textAlign: "center" }}>
                      <button
                        className="btn btn-sm btn-icon"
                        onClick={() => openEdit(x)}
                        title="Editar SubMódulo"
                        style={{ marginRight: 6, padding: "6px" }}
                      >
                        <Edit size={14} />
                      </button>
                      <button
                        className="btn btn-danger btn-sm btn-icon"
                        onClick={() => onDelete(x)}
                        title="Remover SubMódulo"
                        style={{ padding: "6px" }}
                      >
                        <Trash2 size={14} />
                      </button>
                    </td>
                  </tr>
                );
              })}

              {paginatedItems.length === 0 && (
                <tr>
                  <td colSpan={7} style={{ padding: 32, textAlign: "center", color: "#94a3b8" }}>
                    Nenhum SubMódulo cadastrado para os filtros selecionados.
                  </td>
                </tr>
              )}
            </tbody>
          </table>

          {/* Pagination Controls */}
          {totalPages > 1 && (
            <div style={{ marginTop: 24, display: "flex", gap: 10, alignItems: "center", justifyContent: "center" }}>
              <button
                className="btn btn-secondary"
                disabled={page <= 1}
                onClick={() => setPage((p) => p - 1)}
              >
                Anterior
              </button>
              <span style={{ fontSize: "0.9rem", color: "#94a3b8" }}>
                Página <strong>{page}</strong> de {totalPages}
              </span>
              <button
                className="btn btn-secondary"
                disabled={page >= totalPages}
                onClick={() => setPage((p) => p + 1)}
              >
                Próxima
              </button>
            </div>
          )}
        </>
      )}

      {/* Create / Edit Modal */}
      {isOpen && (
        <div className="modalOverlay" onMouseDown={() => setIsOpen(false)}>
          <div className="modalCard" onMouseDown={(e) => e.stopPropagation()} style={{ maxWidth: 680 }}>
            <div className="modalHeader">
              <h3 className="modalTitle">
                {editing ? `Editar SubMódulo: ${editing.codigo}` : "Novo SubMódulo"}
              </h3>
              <button className="btn btn-sm" type="button" onClick={() => setIsOpen(false)}>
                Fechar
              </button>
            </div>

            <form onSubmit={onSave}>
              <div className="modalBody">
                <div className="formGrid" style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "16px" }}>
                  
                  <div className="field" style={{ gridColumn: "span 2" }}>
                    <label className="label">Módulo Pai*</label>
                    <SearchableSelect
                      value={form.idModulo || ""}
                      onChange={(val) => setForm({ ...form, idModulo: Number(val) })}
                      placeholder="Selecione o módulo correspondente..."
                      options={modulos.map((m) => {
                        const info = modulosMap.get(m.id);
                        const label = info
                          ? `${info.marcaNome} - ${info.descricao} (${fmt(info.largura, 2)}m)`
                          : m.descricao;
                        return { value: m.id, label };
                      })}
                    />
                  </div>

                  <div className="field">
                    <label className="label">Tecido Base*</label>
                    <SearchableSelect
                      value={form.idTecidoBase || ""}
                      onChange={(val) => setForm({ ...form, idTecidoBase: Number(val) })}
                      placeholder="Selecione o tecido base..."
                      options={tecidos.map((t) => ({ value: t.id, label: t.nome }))}
                    />
                  </div>

                  <div className="field">
                    <label className="label">Código do Produto*</label>
                    <input
                      type="text"
                      className="cl-input"
                      value={form.codigo || ""}
                      onChange={(e) => setForm({ ...form, codigo: e.target.value })}
                      placeholder="Ex: 17966"
                      required
                    />
                  </div>

                  <div className="field" style={{ gridColumn: "span 2" }}>
                    <label className="label">Descrição Comercial / Produto*</label>
                    <input
                      type="text"
                      className="cl-input"
                      value={form.descricaoProduto || ""}
                      onChange={(e) => setForm({ ...form, descricaoProduto: e.target.value })}
                      placeholder="Ex: ESTOFADO ALASCA 2,10 TC-10063"
                      required
                    />
                  </div>

                  <div className="field">
                    <label className="label">Tecido Específico*</label>
                    <input
                      type="text"
                      className="cl-input"
                      value={form.tecidoEspecifico || ""}
                      onChange={(e) => setForm({ ...form, tecidoEspecifico: e.target.value })}
                      placeholder="Ex: TC-10063"
                      required
                    />
                  </div>

                  <div className="field">
                    <label className="label">Volume Cubagem (M³)*</label>
                    <input
                      type="text"
                      className="cl-input"
                      value={form.volumeM3Str || ""}
                      onChange={(e) => setForm({ ...form, volumeM3Str: e.target.value })}
                      placeholder="Ex: 2,007900"
                      required
                    />
                  </div>

                </div>
              </div>

              <div className="modalFooter">
                <button className="btn" type="button" onClick={() => setIsOpen(false)}>
                  Cancelar
                </button>
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

const th: React.CSSProperties = {
  textAlign: "left",
  borderBottom: "1px solid rgba(255, 255, 255, 0.15)",
  padding: "10px 8px",
  color: "#94a3b8",
  fontWeight: "600",
  fontSize: "0.9rem",
};

const td: React.CSSProperties = {
  borderBottom: "1px solid rgba(255, 255, 255, 0.08)",
  padding: "10px 8px",
  fontSize: "0.9rem",
};

function getErrorMessage(e: unknown): string {
  if (e instanceof Error) return e.message;
  if (typeof e === "string") return e;
  if (e && typeof e === "object" && "message" in e && typeof e.message === "string") {
    return (e as any).message;
  }
  try {
    return JSON.stringify(e);
  } catch {
    return "Erro desconhecido";
  }
}
