import React, { useEffect, useState, useMemo } from "react";
import { useNavigate } from "react-router-dom";
import { HelpCircle, Calculator } from "lucide-react"; // Import icons
import "./ClientesPage.css";

import type { Categoria, Fornecedor, Marca, Modulo, ModuloTecido, Tecido, Configuracao } from "../api/types";

import {
  createModulo,
  deleteModulo,
  listModulos,
  updateModulo,
  createModuloTecido,
  deleteModuloTecido,
  updateModuloTecido,
  getModuleFilters,
} from "../api/modulos";
import { PrintExportButtons } from "../components/PrintExportButtons";
import { exportToCSV } from "../utils/printExport";
import type { ColumnDefinition } from "../utils/printExport";

import { getCotacaoUSD } from "../api/pis";
import { SearchableSelect } from "../components/SearchableSelect";
import { ModuloSelect } from "../components/ModuloSelect";
import { PrintModulesModal } from "../components/PrintModulesModal";
import { printModulesReport } from "../utils/reports/printModulesReport";

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
  const [allModules, setAllModules] = useState<Modulo[]>([]); // For the combo box
  
  const [categorias, setCategorias] = useState<Categoria[]>([]);
  const [fornecedores, setFornecedores] = useState<Fornecedor[]>([]);
  const [marcas, setMarcas] = useState<Marca[]>([]);
  const [tecidos, setTecidos] = useState<Tecido[]>([]);

  const [config, setConfig] = useState<Configuracao | null>(null);
  const [configsMap, setConfigsMap] = useState<Map<number | null, Configuracao>>(new Map());
  const [cotacao, setCotacao] = useState<number>(0);

  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  
  // Pagination / Search State
  const [search, setSearch] = useState("");
  const [filterFornecedor, setFilterFornecedor] = useState("");
  const [filterCategoria, setFilterCategoria] = useState("");
  const [filterMarca, setFilterMarca] = useState("");
  const [filterTecido, setFilterTecido] = useState("");
  const [filterStatus, setFilterStatus] = useState<'ativos' | 'inativos' | 'todos'>('ativos');

  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [totalItems, setTotalItems] = useState(0);

  const [isOpen, setIsOpen] = useState(false);
  const [editing, setEditing] = useState<Modulo | null>(null);
  const [form, setForm] = useState<FormState>(emptyForm);
  const [saving, setSaving] = useState(false);
  const [activeTab, setActiveTab] = useState<"geral" | "tecidos">("geral");
  const [isPrintModalOpen, setIsPrintModalOpen] = useState(false);
  const [calcModalData, setCalcModalData] = useState<{ valorTecido: number; idFornecedor: number } | null>(null);

  // Selection state for combo
  const [selectedModuleId, setSelectedModuleId] = useState("");

  // Maps for display
  const catMap = useMemo(() => new Map(categorias.map((x) => [x.id, x.nome])), [categorias]);
  const fornMap = useMemo(() => new Map(fornecedores.map((x) => [x.id, x.nome])), [fornecedores]);
  const marcaMap = useMemo(() => new Map(marcas.map((x) => [x.id, x.nome])), [marcas]);
  const tecidoMap = useMemo(() => new Map(tecidos.map((x) => [x.id, x.nome])), [tecidos]);

  // Dynamic Filters Loader
  async function loadFilters() {
    try {
      const res = await getModuleFilters(
        filterFornecedor ? Number(filterFornecedor) : undefined,
        filterCategoria ? Number(filterCategoria) : undefined,
        filterMarca ? Number(filterMarca) : undefined,
        filterTecido ? Number(filterTecido) : undefined
      );
      setFornecedores(res.fornecedores);
      setCategorias(res.categorias);
      setMarcas(res.marcas);
      setTecidos(res.tecidos);
    } catch (e) {
      console.error("Erro ao carregar filtros", e);
    }
  }

  // Load All Modules for Combo
  async function loadAllModules() {
    try {
      const res = await listModulos(
        "", 
        1, 
        1000, 
        filterFornecedor ? Number(filterFornecedor) : undefined,
        filterCategoria ? Number(filterCategoria) : undefined,
        filterMarca ? Number(filterMarca) : undefined,
        filterTecido ? Number(filterTecido) : undefined,
        filterStatus
      );
      setAllModules(res.items);
    } catch (e) {
      console.error("Erro ao carregar lista completa de módulos", e);
    }
  }

  // Load Config and Cotacao
  const loadConfigData = async () => {
    try {
      const { getLatestConfigsAll } = await import("../api/configuracoes");
      const allConfigs = await getLatestConfigsAll();
      const map = new Map<number | null, Configuracao>();
      allConfigs.forEach(c => {
        if (c) map.set(c.idFornecedor ?? null, c);
      });
      setConfigsMap(map);

      // Current config for legacy/general use (global or filter)
      const currentId = filterFornecedor ? Number(filterFornecedor) : null;
      setConfig(map.get(currentId) || map.get(null) || null);
    } catch (e) {
      console.error("Erro ao carregar configs", e);
    }
  };

  useEffect(() => {
    loadConfigData();
    getCotacaoUSD().then(setCotacao).catch(console.error);
  }, [filterFornecedor]);

  // Load filters AND all modules whenever filter selection changes
  useEffect(() => {
    loadFilters();
    loadAllModules();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [filterFornecedor, filterCategoria, filterMarca, filterTecido, filterStatus]);

  // Main Loader
  async function loadItems() {
    try {
      setLoading(true);
      setError(null);
      // Calls paged API
      const res = await listModulos(
        search, 
        page, 
        10, 
        filterFornecedor ? Number(filterFornecedor) : undefined,
        filterCategoria ? Number(filterCategoria) : undefined,
        filterMarca ? Number(filterMarca) : undefined,
        filterTecido ? Number(filterTecido) : undefined,
        filterStatus
      );
      setItems(res.items);
      setTotalPages(res.totalPages);
      setTotalItems(res.total);
    } catch (e: unknown) {
      setError(getErrorMessage(e));
    } finally {
      setLoading(false);
    }
  }

  // Effect: reload items when page or search changes (and filters)
  useEffect(() => {
    const timer = setTimeout(() => {
      loadItems();
    }, 300);
    return () => clearTimeout(timer);
  }, [page, search, filterFornecedor, filterCategoria, filterMarca, filterTecido, filterStatus]);

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
      if (!form.idMarca) throw new Error("Modelo é obrigatório");

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
        alert("Módulo atualizado!");
        await loadItems();
        setIsOpen(false); 
      } else {
        const created = await createModulo(payload);
        alert("Módulo criado! Agora você pode adicionar tecidos.");
        await loadItems();
        setEditing(created);
        setActiveTab("tecidos"); 
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
      await loadItems();
    } catch (e: unknown) {
      alert(getErrorMessage(e));
    }
  }

  // Callback when fabrics are changed in the modal
  async function onFabricsUpdated() {
    await loadItems();
  }

  // Update editing object when items change (to refresh fabrics in modal)
  useEffect(() => {
    if (editing && items.length > 0) {
      const fresh = items.find(i => i.id === editing.id);
      if (fresh) setEditing(fresh);
    }
  }, [items]);

  function calcEXW(valorTecido: number, idFornecedor: number) {
    const c = configsMap.get(idFornecedor) || configsMap.get(null);
    if (!c || !cotacao) return 0;
    const cotacaoRisco = cotacao - c.valorReducaoDolar;
    if (cotacaoRisco <= 0) return 0;
    const valorBase = valorTecido / cotacaoRisco;
    const comissao = valorBase * (c.percentualComissao / 100);
    // Reverted: Gordura on Base Only
    const gordura = valorBase * (c.percentualGordura / 100);
    return valorBase + comissao + gordura;
  }

  // Helper to handle combo selection
  const handleModuleSelect = (idStr: string) => {
    const mod = allModules.find(m => String(m.id) === idStr);
    if (mod) {
        setSearch(mod.descricao);
        setPage(1);
    }
  };

  const exportColumns = useMemo<ColumnDefinition<Modulo>[]>(() => [
    { header: "ID", accessor: (m) => m.id },
    { header: "Fornecedor", accessor: (m) => fornMap.get(m.idFornecedor) || m.idFornecedor },
    { header: "Categoria", accessor: (m) => catMap.get(m.idCategoria) || m.idCategoria },
    { header: "Modelo", accessor: (m) => marcaMap.get(m.idMarca) || m.idMarca },
    { header: "Descrição", accessor: (m) => m.descricao },
    { header: "Dimensões", accessor: (m) => `${fmt(m.largura)}x${fmt(m.profundidade)}x${fmt(m.altura)}` },
    { header: "M3", accessor: (m) => fmt(m.m3) },
  ], [fornMap, catMap, marcaMap]);

  function handlePrint() {
      setIsPrintModalOpen(true);
  }

  async function onConfirmPrint(scope: 'screen' | 'all', currency: 'BRL' | 'EXW') {
      let list = items;
      if (scope === 'all') {
          try {
              setLoading(true);
              const res = await listModulos(
                 search,
                 1, 100000,
                 filterFornecedor ? Number(filterFornecedor) : undefined,
                 filterCategoria ? Number(filterCategoria) : undefined,
                 filterMarca ? Number(filterMarca) : undefined,
                 filterTecido ? Number(filterTecido) : undefined,
                 filterStatus
              );
              list = res.items;
          } catch(e) {
              alert("Erro ao carregar tudo");
              return;
          } finally {
              setLoading(false);
          }
      }

      printModulesReport({
          modules: list,
          currency,
          cotacao,
          config,
          maps: {
              fornecedor: fornMap,
              categoria: catMap,
              marca: marcaMap,
              tecido: tecidoMap
          },
          marcasFull: new Map(marcas.map(m => [m.id, m]))
      });
      setIsPrintModalOpen(false);
  }

  async function handleExcel(all: boolean) {
     let list = items;
     if (all) {
         try {
             setLoading(true);
             const res = await listModulos(
                search, 1, 100000,
                filterFornecedor ? Number(filterFornecedor) : undefined,
                filterCategoria ? Number(filterCategoria) : undefined,
                filterMarca ? Number(filterMarca) : undefined,
                filterTecido ? Number(filterTecido) : undefined,
                filterStatus
             );
             list = res.items;
         } catch(e) {
             alert("Erro ao carregar tudo");
             return;
         } finally {
             setLoading(false);
         }
     }
     exportToCSV(list, exportColumns, "modulos");
  }

  // --- Render ---

  if (loading && page === 1 && items.length === 0) return <div style={{ padding: 16 }}>Carregando...</div>;

  return (
    <div className="list-container">
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 }}>
        <h1>Módulos</h1>
      </div>

      <div style={{ background: '#1a1a2e', padding: 16, borderRadius: 8, marginBottom: 16, display: 'flex', gap: 10, flexWrap: 'wrap', alignItems: 'center' }}>
        <div style={{ width: 220 }}>
          <SearchableSelect
            value={filterFornecedor}
            onChange={(val) => { setFilterFornecedor(val); setPage(1); }}
            placeholder="Fornecedor (Todos)"
            options={[{ value: "", label: "Fornecedor (Todos)" }, ...fornecedores.map(f => ({ value: f.id, label: f.nome }))]}
          />
        </div>
        <div style={{ width: 220 }}>
          <SearchableSelect
            value={filterCategoria}
            onChange={(val) => { setFilterCategoria(val); setPage(1); }}
            placeholder="Categoria (Todas)"
            options={[{ value: "", label: "Categoria (Todas)" }, ...categorias.map(c => ({ value: c.id, label: c.nome }))]}
          />
        </div>
        <div style={{ width: 220 }}>
          <SearchableSelect
            value={filterMarca}
            onChange={(val) => { setFilterMarca(val); setPage(1); }}
            placeholder="Modelo (Todos)"
            options={[{ value: "", label: "Modelo (Todos)" }, ...marcas.map(m => ({ value: m.id, label: m.nome }))]}
          />
        </div>
        <div style={{ width: 220 }}>
          <SearchableSelect
            value={filterTecido}
            onChange={(val) => { setFilterTecido(val); setPage(1); }}
            placeholder="Tecido (Todos)"
            options={[{ value: "", label: "Tecido (Todos)" }, ...tecidos.map(t => ({ value: t.id, label: t.nome }))]}
          />
        </div>

        <div style={{ width: 140 }}>
           <select 
              className="cl-input"
              value={filterStatus}
              onChange={(e) => { setFilterStatus(e.target.value as any); setPage(1); }}
              style={{ height: 38, color: 'var(--text)' }}
           >
              <option value="ativos" style={{ color: 'black' }}>Status: Ativos</option>
              <option value="inativos" style={{ color: 'black' }}>Status: Inativos</option>
              <option value="todos" style={{ color: 'black' }}>Status: Todos</option>
           </select>
        </div>

        <div style={{ flex: 1, minWidth: 200 }}>
             <ModuloSelect
                value={selectedModuleId}
                onChange={(val) => {
                    setSelectedModuleId(val);
                    handleModuleSelect(val);
                }}
                options={allModules}
                mapFornecedor={fornMap}
                mapCategoria={catMap}
                mapMarca={marcaMap}
                mapTecido={tecidoMap}
                calcExw={calcEXW}
             />
        </div>

        <div style={{ display: 'flex', gap: 8 }}>
            <button 
                className="btn btn-secondary" 
                onClick={() => {
                    setFilterFornecedor("");
                    setFilterCategoria("");
                    setFilterMarca("");
                    setFilterTecido("");
                    setFilterStatus("ativos");
                    setSearch("");
                    setPage(1);
                    setSelectedModuleId("");
                }}
                style={{ height: '38px', whiteSpace: 'nowrap' }}
                title="Limpar todos os filtros"
            >
                🧹 Limpar
            </button>
            <button className="btn btn-primary" onClick={openCreate} style={{ height: '38px' }}>Novo</button>
            <PrintExportButtons
                onPrint={() => handlePrint()}
                onExcel={handleExcel}
                disabled={loading}
            />
        </div>
      </div>

      {error && <div style={{ color: "red" }}>{error}</div>}

      {loading ? (
        <div>Carregando...</div>
      ) : (
        <>
            <table style={{ width: "100%", borderCollapse: "collapse" }}>
            <thead>
                <tr>
                <th style={th}>ID</th>
                <th style={th}>Fornecedor</th>
                <th style={th}>Categoria</th>
                <th style={th}>Modelo</th>
                <th style={th}>Módulo</th>
                <th style={th}>Dimensões (LxPxA)</th>
                <th style={th}>M³</th>
                <th style={th}>EXW (Parcial)</th>
                <th style={th}>Tecidos / Valores</th>
                <th style={th}>Status</th>
                <th style={th}>Ações</th>
                </tr>
            </thead>
            <tbody>
                {items.map((x) => {
                let myTecidos = x.modulosTecidos || [];
                if (filterTecido) {
                  myTecidos = myTecidos.filter(t => t.idTecido === Number(filterTecido));
                }

                const rowSpan = myTecidos.length > 0 ? myTecidos.length : 1;

                // First row (contains all module info + first fabric if exists)
                const firstRow = (
                  <tr key={`${x.id}-row-0`}>
                    <td style={td} rowSpan={rowSpan}>{x.id}</td>
                    <td style={td} rowSpan={rowSpan}>{fornMap.get(x.idFornecedor) || x.idFornecedor}</td>
                    <td style={td} rowSpan={rowSpan}>{catMap.get(x.idCategoria) || x.idCategoria}</td>
                    <td style={td} rowSpan={rowSpan}>{marcaMap.get(x.idMarca) || x.idMarca}</td>
                    <td style={td} rowSpan={rowSpan}>{x.descricao}</td>
                    <td style={td} rowSpan={rowSpan}>
                      {fmt(x.largura)} x {fmt(x.profundidade)} x {fmt(x.altura)}
                    </td>
                    <td style={td} rowSpan={rowSpan}>{fmt(x.m3)}</td>
                    
                    {/* EXW */}
                    <td style={td}>
                        {myTecidos.length > 0 ? (
                             <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'flex-end', gap: 6 }}>
                                 <span style={{ color: '#10b981' }}>
                                    $ {fmt(calcEXW(myTecidos[0].valorTecido, x.idFornecedor), 2)}
                                 </span>
                                 <button 
                                    className="btn-icon" 
                                    onClick={() => setCalcModalData({ valorTecido: myTecidos[0].valorTecido, idFornecedor: x.idFornecedor })}
                                    title="Ver memória de cálculo"
                                    style={{ padding: 2, display: 'flex' }}
                                 >
                                    <HelpCircle size={14} color="#94a3b8" />
                                 </button>
                             </div>
                        ) : "-"}
                    </td>

                    {/* Tecidos/Valores */}
                    <td style={td}>
                        {myTecidos.length > 0 ? (
                            <div>
                                <span style={{ fontWeight: 500, color: '#94a3b8' }}>
                                    {myTecidos[0].tecido?.nome || myTecidos[0].idTecido}:
                                </span>{' '}
                                <span style={{ color: '#e5e7eb' }}>
                                    R$ {fmt(myTecidos[0].valorTecido, 2)}
                                </span>
                            </div>
                        ) : "-"}
                    </td>

                    <td style={td}>
                        {myTecidos.length > 0 ? (
                             <span style={{ 
                                 color: myTecidos[0].flAtivo ? '#4ade80' : '#f87171',
                                 fontWeight: 500,
                                 fontSize: '0.85rem'
                             }}>
                                {myTecidos[0].flAtivo ? 'Ativo' : 'Inativo'}
                             </span>
                        ) : "-"}
                    </td>

                    <td style={td} rowSpan={rowSpan}>
                      <button className="btn btn-sm" onClick={() => openEdit(x)}>Editar</button>{" "}
                      <button className="btn btn-danger btn-sm" onClick={() => onDelete(x)}>
                        Remover
                      </button>
                    </td>
                  </tr>
                );

                // Additional rows for remaining fabrics
                const otherRows = myTecidos.slice(1).map((mt, i) => (
                    <tr key={`${x.id}-row-${i+1}`}>
                        <td style={td}>
                             <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'flex-end', gap: 6 }}>
                                 <span style={{ color: '#10b981' }}>
                                    $ {fmt(calcEXW(mt.valorTecido, x.idFornecedor), 2)}
                                 </span>
                                 <button 
                                    className="btn-icon" 
                                    onClick={() => setCalcModalData({ valorTecido: mt.valorTecido, idFornecedor: x.idFornecedor })}
                                    title="Ver memória de cálculo"
                                    style={{ padding: 2, display: 'flex' }}
                                 >
                                    <HelpCircle size={14} color="#94a3b8" />
                                 </button>
                             </div>
                        </td>
                        <td style={td}>
                            <div>
                                <span style={{ fontWeight: 500, color: '#94a3b8' }}>
                                    {mt.tecido?.nome || mt.idTecido}:
                                </span>{' '}
                                <span style={{ color: '#e5e7eb' }}>
                                    R$ {fmt(mt.valorTecido, 2)}
                                </span>
                            </div>
                        </td>
                        <td style={td}>
                             <span style={{ 
                                 color: mt.flAtivo ? '#4ade80' : '#f87171',
                                 fontWeight: 500,
                                 fontSize: '0.85rem'
                             }}>
                                {mt.flAtivo ? 'Ativo' : 'Inativo'}
                             </span>
                        </td>
                    </tr>
                ));

                return (
                    <React.Fragment key={x.id}>
                        {firstRow}
                        {otherRows}
                    </React.Fragment>
                );
                })}
            </tbody>
            </table>

            {/* Pagination Controls */}
            <div style={{ marginTop: 16, display: 'flex', gap: 10, alignItems: 'center', justifyContent: 'center' }}>
                <button 
                    className="btn btn-secondary" 
                    disabled={page <= 1} 
                    onClick={() => setPage(p => p - 1)}
                >
                    Anterior
                </button>
                <span>Página {page} de {totalPages || 1} (Total: {totalItems})</span>
                <button 
                    className="btn btn-secondary" 
                    disabled={page >= totalPages} 
                    onClick={() => setPage(p => p + 1)}
                >
                    Próxima
                </button>
            </div>
        </>
      )}

      {isOpen && (
        <div className="modalOverlay" onMouseDown={() => setIsOpen(false)}>
          <div className="modalCard" onMouseDown={(e) => e.stopPropagation()}>
            <div className="modalHeader">
              <h3 className="modalTitle">
                {editing ? "Editar Módulo" : "Novo Módulo"}
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

            <div className="modalBody">
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
                      <SearchableSelect
                        value={form.idFornecedor || ""}
                        onChange={(val) => setForm({ ...form, idFornecedor: Number(val) })}
                        options={fornecedores.map(f => ({ value: f.id, label: f.nome }))}
                        placeholder="Selecione..."
                      />
                    </div>
                    <div className="field">
                      <label className="label">Categoria*</label>
                      <SearchableSelect
                        value={form.idCategoria || ""}
                        onChange={(val) => setForm({ ...form, idCategoria: Number(val) })}
                        options={categorias.map(c => ({ value: c.id, label: c.nome }))}
                        placeholder="Selecione..."
                      />
                    </div>
                      <div className="field">
                        <label className="label">Modelo*</label>
                        <div style={{ display: "flex", gap: 8 }}>
                          <div style={{ flex: 1 }}>
                            <SearchableSelect
                              value={form.idMarca || ""}
                              onChange={(val) => setForm({ ...form, idMarca: Number(val) })}
                              options={marcas.map(m => ({ value: m.id, label: m.nome }))}
                              placeholder="Selecione..."
                            />
                          </div>
                          <button
                            type="button"
                            className="btn btn-sm"
                            onClick={() => navigate("/marcas")}
                            title="Cadastrar novo modelo"
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
                  currentLinks={editing?.modulosTecidos || []}
                  onUpdate={onFabricsUpdated}
                />
              )}
            </div>
          </div>
        </div>
      )}

      <PrintModulesModal 
        isOpen={isPrintModalOpen}
        onClose={() => setIsPrintModalOpen(false)}
        onConfirm={onConfirmPrint}
        loading={loading}
      />

      {calcModalData && (
          <CalculationDetailsModal
            isOpen={!!calcModalData}
            onClose={() => setCalcModalData(null)}
            valorTecido={(calcModalData as any).valorTecido}
            config={configsMap.get((calcModalData as any).idFornecedor) || configsMap.get(null) || config}
            cotacao={cotacao}
          />
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
  
  const [editingId, setEditingId] = useState<number | null>(null);
  const [editingValor, setEditingValor] = useState("");
  const [editingFlAtivo, setEditingFlAtivo] = useState(true);
  const [editingDtRevisao, setEditingDtRevisao] = useState("");
  
  const [filterStatus, setFilterStatus] = useState<'todos' | 'ativos' | 'inativos'>('todos');

  async function add() {
    if (!selTecido) return alert("Selecione um tecido");
    setAdding(true);
    try {
      await createModuloTecido({
        idModulo: moduloId,
        idTecido: Number(selTecido),
        valorTecido: parse(valor),
        flAtivo: true,
        dtUltimaRevisao: new Date().toISOString()
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

  function startEdit(link: ModuloTecido) {
    setEditingId(link.id);
    setEditingValor(fmt(link.valorTecido, 2));
    setEditingFlAtivo(link.flAtivo !== false); 
    setEditingDtRevisao(link.dtUltimaRevisao ? link.dtUltimaRevisao.split('T')[0] : "");
  }

  function cancelEdit() {
    setEditingId(null);
    setEditingValor("");
    setEditingFlAtivo(true);
    setEditingDtRevisao("");
  }

  async function saveEdit(id: number) {
    try {
      const link = currentLinks.find(l => l.id === id);
      if (!link) return;
      
      await updateModuloTecido(id, {
        idModulo: link.idModulo,
        idTecido: link.idTecido,
        valorTecido: parse(editingValor),
        flAtivo: editingFlAtivo,
        dtUltimaRevisao: editingDtRevisao ? new Date(editingDtRevisao).toISOString() : undefined
      });
      setEditingId(null);
      setEditingValor("");
      onUpdate();
    } catch (e) {
      alert(getErrorMessage(e));
    }
  }

  // Filter links
  const filteredLinks = (currentLinks || []).filter(l => {
      if (filterStatus === 'ativos') return l.flAtivo !== false;
      if (filterStatus === 'inativos') return l.flAtivo === false;
      return true;
  });

  return (
    <div>
      <div style={{ display: "flex", gap: 12, alignItems: "flex-end", marginBottom: 16 }}>
        <div className="field" style={{ flex: 1 }}>
          <label className="label">Tecido</label>
          <SearchableSelect
            value={selTecido ? Number(selTecido) : ""}
            onChange={(val) => setSelTecido(String(val))}
            options={allTecidos.map(t => ({ value: t.id, label: t.nome }))}
            placeholder="Selecione..."
          />
        </div>
        <div className="field" style={{ width: 140 }}>
          <label className="label">Valor</label>
          <input
            className="cl-input"
            value={valor}
            onChange={(e) => setValor(e.target.value)}
          />
        </div>
        <button className="btn btn-primary" onClick={add} disabled={adding} style={{ marginBottom: 0 }}>
          {adding ? "Adicionando..." : "Adicionar"}
        </button>
      </div>

      <div style={{ marginBottom: 10, display: 'flex', justifyContent: 'flex-end', alignItems: 'center', gap: 8 }}>
          <label style={{ fontSize: 14, color: '#aaa' }}>Filtro:</label>
          <select 
            className="cl-input" 
            style={{ width: 120, padding: 4, height: 30 }}
            value={filterStatus}
            onChange={e => setFilterStatus(e.target.value as any)}
          >
              <option value="todos">Todos</option>
              <option value="ativos">Ativos</option>
              <option value="inativos">Inativos</option>
          </select>
      </div>

      <table style={{ width: "100%", borderCollapse: "collapse", marginTop: 16 }}>
        <thead>
          <tr>
            <th style={{ ...th, textAlign: "left" }}>Tecido</th>
            <th style={{ ...th, textAlign: "right" }}>Valor (R$)</th>
            <th style={{ ...th, textAlign: "center", width: 80 }}>Ativo?</th>
            <th style={{ ...th, textAlign: "center", width: 100 }}>Data Rev.</th>
            <th style={{ ...th, width: 100 }}>Ações</th>
          </tr>
        </thead>
        <tbody>
          {filteredLinks.map((link) => {
            const isEditing = editingId === link.id;
            return (
              <tr key={link.id} style={{ borderBottom: "1px solid #333", opacity: (link.flAtivo === false && !isEditing) ? 0.5 : 1 }}>
                <td style={{ ...td, textAlign: "left" }}>
                  {link.tecido?.nome || link.idTecido}
                </td>
                <td style={{ ...td, textAlign: "right" }}>
                  {isEditing ? (
                     <input 
                        className="cl-input" 
                        style={{ width: 80, padding: 4, height: 28 }}
                        value={editingValor}
                        onChange={e => setEditingValor(e.target.value)}
                     /> 
                  ) : (
                    fmt(link.valorTecido, 2)
                  )}
                </td>
                <td style={{ ...td, textAlign: "center" }}>
                    {isEditing ? (
                        <input 
                            type="checkbox"
                            checked={editingFlAtivo}
                            onChange={e => setEditingFlAtivo(e.target.checked)}
                        />
                    ) : (
                        <span>{link.flAtivo !== false ? "✅" : "❌"}</span>
                    )}
                </td>
                 <td style={{ ...td, textAlign: "center" }}>
                    {isEditing ? (
                        <input 
                            type="date"
                            className="cl-input"
                            style={{ width: 110, padding: 2, fontSize: 12 }}
                            value={editingDtRevisao}
                            onChange={e => setEditingDtRevisao(e.target.value)}
                        />
                    ) : (
                        <span style={{ fontSize: 12 }}>
                            {link.dtUltimaRevisao ? new Date(link.dtUltimaRevisao).toLocaleDateString() : '-'}
                        </span>
                    )}
                </td>
                <td style={{ ...td, textAlign: "center" }}>
                   {isEditing ? (
                       <div style={{ display: 'flex', gap: 4, justifyContent: 'center' }}>
                           <button className="btn btn-sm btn-primary" onClick={() => saveEdit(link.id)} style={{ padding: '2px 6px' }}>✔️</button>
                           <button className="btn btn-sm btn-secondary" onClick={cancelEdit} style={{ padding: '2px 6px' }}>❌</button>
                       </div>
                   ) : (
                       <div style={{ display: 'flex', gap: 4, justifyContent: 'center' }}>
                            <button className="btn btn-sm" onClick={() => startEdit(link)} title="Editar valor">✏️</button>
                            <button className="btn btn-sm btn-danger" onClick={() => remove(link.id)} title="Remover">🗑️</button>
                       </div>
                   )}
                </td>
              </tr>
            );
          })}
          {filteredLinks.length === 0 && (
            <tr>
              <td colSpan={5} style={{ padding: 16, textAlign: "center", color: "#888" }}>
                {filterStatus === 'todos' ? 'Nenhum tecido vinculado.' : 'Nenhum registro encontrado para este filtro.'}
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
}

function CalculationDetailsModal({
    isOpen,
    onClose,
    valorTecido,
    config,
    cotacao
}: {
    isOpen: boolean;
    onClose: () => void;
    valorTecido: number;
    config: Configuracao | null;
    cotacao: number;
}) {
    if (!isOpen) return null;

    // Recalculate Logic to display
    const cotacaoRisco = cotacao - (config?.valorReducaoDolar || 0);
    // Safety check div by zero
    const safeCotacao = cotacaoRisco <= 0 ? 1 : cotacaoRisco;

    const valorBase = valorTecido / safeCotacao;
    const comissao = valorBase * ((config?.percentualComissao || 0) / 100);
    // Reverted: Gordura on Base Only
    const gordura = valorBase * ((config?.percentualGordura || 0) / 100);
    const total = valorBase + comissao + gordura;

    return (
        <div className="modalOverlay" onMouseDown={onClose}>
            <div className="modalCard" style={{ maxWidth: 500 }} onMouseDown={e => e.stopPropagation()}>
                <div className="modalHeader">
                    <h3 className="modalTitle" style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
                        <Calculator size={20} /> Memória de Cálculo EXW
                    </h3>
                    <button className="btn btn-sm" onClick={onClose}>Fechar</button>
                </div>
                <div className="modalBody" style={{ padding: 24 }}>
                    <div style={{ background: '#0f172a', padding: 16, borderRadius: 8, marginBottom: 16 }}>
                        <h4 style={{ margin: '0 0 12px 0', color: '#94a3b8', fontSize: 14 }}>PARÂMETROS</h4>
                        <div style={rowStyle}>
                            <span>Cotação do Dia:</span>
                            <strong>R$ {fmt(cotacao, 2)}</strong>
                        </div>
                        <div style={rowStyle}>
                            <span>Redução Dólar (Config):</span>
                            <span style={{ color: '#ef4444' }}>- R$ {fmt(config?.valorReducaoDolar, 2)}</span>
                        </div>
                        <div style={{ ...rowStyle, borderTop: '1px solid #334155', paddingTop: 8, marginTop: 8 }}>
                            <span>Cotação de Risco:</span>
                            <strong style={{ color: '#3b82f6' }}>R$ {fmt(cotacaoRisco, 2)}</strong>
                        </div>
                    </div>

                    <div style={{ background: '#0f172a', padding: 16, borderRadius: 8 }}>
                        <h4 style={{ margin: '0 0 12px 0', color: '#94a3b8', fontSize: 14 }}>CÁLCULO DO PREÇO</h4>
                        
                        <div style={rowStyle}>
                            <span>Valor do Tecido:</span>
                            <strong>R$ {fmt(valorTecido, 2)}</strong>
                        </div>
                        <div style={rowStyle}>
                            <span>Valor Base (Tecido / Cotação Risco):</span>
                            <strong>$ {fmt(valorBase, 2)}</strong>
                        </div>
                        
                        <div style={{ margin: '8px 0', borderLeft: '2px solid #334155', paddingLeft: 12 }}>
                            <div style={rowStyle}>
                                <span>Comissão ({fmt(config?.percentualComissao)}%):</span>
                                <span>+ $ {fmt(comissao, 2)}</span>
                            </div>
                            <div style={rowStyle}>
                                <span>Gordura (Sobre Base) ({fmt(config?.percentualGordura)}%):</span>
                                <span style={{ color: '#10b981' }}>+ $ {fmt(gordura, 2)}</span>
                            </div>
                        </div>

                        <div style={{ ...rowStyle, borderTop: '1px solid #334155', paddingTop: 12, marginTop: 12, fontSize: 18 }}>
                            <span>Preço EXW Final:</span>
                            <strong style={{ color: '#10b981' }}>$ {fmt(total, 2)}</strong>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}

const rowStyle: React.CSSProperties = {
    display: 'flex',
    justifyContent: 'space-between',
    marginBottom: 6,
    fontSize: 14
};


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
