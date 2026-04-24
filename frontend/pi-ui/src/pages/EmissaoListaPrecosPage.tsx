import { useEffect, useState, useMemo, useCallback } from "react";
import { Download, Trash2, Printer, FileSpreadsheet } from "lucide-react";
import PageHeader from "../components/PageHeader";
import type { Modulo, Configuracao, Categoria, Marca, Fornecedor, Tecido, Frete } from "../api/types";
import { getModuleFilters, listModulos, exportPriceListExcel } from "../api/modulos";
import { API_BASE } from "../api/api";
import { getLatestConfigsAll } from "../api/configuracoes";
import { listFretes } from "../api/fretes";
import { getTotalFrete } from "../api/configuracoesFreteItem";
import { getCotacaoUSD } from "../api/pis";
import { listFornecedores } from "../api/fornecedores";
import { listCategorias } from "../api/categorias";
import { listMarcas } from "../api/marcas";
import { listTecidos } from "../api/tecidos";
import { SearchableSelect } from "../components/SearchableSelect";
import { calculateCotacaoRisco, calculateEXW, calculateFreteRateio } from "../utils/calculations";
import { printPriceListReport } from "../utils/reports/printPriceListReport";
import "./ClientesPage.css";

const fmt = (n: number | undefined | null, decimals = 2) => (n ?? 0).toLocaleString("pt-BR", { minimumFractionDigits: decimals, maximumFractionDigits: decimals });
const getImgUrl = (path?: string | null) => {
  if (!path) return "";
  if (path.startsWith("http") || path.startsWith("data:")) return path;
  
  // If it's a base64 string (from byte[] in DB), it won't have a file extension like .jpg/.png at the end
  // and will typically be quite long.
  const isLikelyBase64 = path.length > 50 && !/\.(jpg|jpeg|png|gif|webp|svg)$/i.test(path);

  if (isLikelyBase64) {
    return `data:image/png;base64,${path}`;
  }

  const baseUrl = API_BASE.replace(/\/+$/, "");
  const cleanPath = path.replace(/^\/+/, "");
  return `${baseUrl}/${cleanPath}`;
};

interface SelectedItem {
  tempId: string;
  modulo: Modulo;
}

export default function EmissaoListaPrecosPage() {
  const [items, setItems] = useState<Modulo[]>([]); // Results from search
  const [selectedItems, setSelectedItems] = useState<SelectedItem[]>([]); // Selection for the list
  
  // Filters
  const [filterFornecedor, setFilterFornecedor] = useState("");
  const [filterCategoria, setFilterCategoria] = useState("");
  const [filterMarca, setFilterMarca] = useState("");
  const [filterTecido, setFilterTecido] = useState("");
  const [search, setSearch] = useState("");

  // Data
  const [fornecedores, setFornecedores] = useState<Fornecedor[]>([]);
  const [categorias, setCategorias] = useState<Categoria[]>([]);
  const [marcas, setMarcas] = useState<Marca[]>([]);
  const [tecidos, setTecidos] = useState<Tecido[]>([]);
  const [fretes, setFretes] = useState<Frete[]>([]);
  const [configsMap, setConfigsMap] = useState<Map<number | null, Configuracao>>(new Map());
  const [cotacao, setCotacao] = useState<number>(0);

  // Freight Settings
  const [selectedFreteId, setSelectedFreteId] = useState("");
  const [totalFreteBRL, setTotalFreteBRL] = useState<number>(0);
  const [tipoRateio, setTipoRateio] = useState<"IGUAL" | "M3">("IGUAL");
  const [currency, setCurrency] = useState<"BRL" | "EXW">("EXW");
  const [validityDays, setValidityDays] = useState(30);

  const [loading, setLoading] = useState(false);
  const [exportLoading, setExportLoading] = useState(false);

  // Maps
  const fornMap = useMemo(() => new Map(fornecedores.map(f => [f.id, f.nome])), [fornecedores]);
  const catMap = useMemo(() => new Map(categorias.map(c => [c.id, c.nome])), [categorias]);
  const marcaMap = useMemo(() => new Map(marcas.map(m => [m.id, m])), [marcas]);
  const tecidoMap = useMemo(() => new Map(tecidos.map(t => [t.id, t.nome])), [tecidos]);

  // Load initial data
  useEffect(() => {
    getCotacaoUSD().then(v => setCotacao(v)).catch(console.error);
    listFretes().then(setFretes).catch(console.error);
    
    getLatestConfigsAll().then(configs => {
      const map = new Map<number | null, Configuracao>();
      configs.forEach(c => { if (c) map.set(c.idFornecedor ?? null, c); });
      setConfigsMap(map);
    }).catch(console.error);

    Promise.all([listFornecedores(), listCategorias(), listMarcas(), listTecidos()])
      .then(([f, c, m, t]) => {
        setFornecedores(f);
        setCategorias(c);
        setMarcas(m);
        setTecidos(t);
      }).catch(console.error);
  }, []);

  // Load dynamic filters
  const loadFilters = useCallback(async () => {
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
    } catch (e) { console.error(e); }
  }, [filterFornecedor, filterCategoria, filterMarca, filterTecido]);

  useEffect(() => { loadFilters(); }, [loadFilters]);

  // Load modules based on filters
  const loadModules = useCallback(async () => {
    try {
      setLoading(true);
      const res = await listModulos(search, 1, 100, 
        filterFornecedor ? Number(filterFornecedor) : undefined,
        filterCategoria ? Number(filterCategoria) : undefined,
        filterMarca ? Number(filterMarca) : undefined,
        filterTecido ? Number(filterTecido) : undefined,
        'ativos'
      );
      setItems(res.items);
    } catch (e) { console.error(e); }
    finally { setLoading(false); }
  }, [search, filterFornecedor, filterCategoria, filterMarca, filterTecido]);

  useEffect(() => {
    const timer = setTimeout(loadModules, 300);
    return () => clearTimeout(timer);
  }, [loadModules]);

  // Handle Freight Selection
  useEffect(() => {
    if (selectedFreteId) {
      getTotalFrete(Number(selectedFreteId), filterFornecedor ? Number(filterFornecedor) : undefined)
        .then(setTotalFreteBRL)
        .catch(console.error);
    }
  }, [selectedFreteId, filterFornecedor]);

  // Add to selection
  const addToSelection = (mod: Modulo) => {
    if (selectedItems.some(si => si.modulo.id === mod.id)) {
      alert("Módulo já está na lista!");
      return;
    }
    setSelectedItems(prev => [...prev, {
      tempId: Math.random().toString(36).substr(2, 9),
      modulo: mod
    }]);
  };

  const removeFromSelection = (tempId: string) => {
    setSelectedItems(prev => prev.filter(i => i.tempId !== tempId));
  };

  const clearSelection = () => {
    if (confirm("Limpar toda a lista?")) setSelectedItems([]);
  };

  // Recalculate Apportionment on the fly
  const itemsWithCalculations = useMemo(() => {
    const totalM3 = selectedItems.reduce((sum, i) => sum + (i.modulo.m3 || 0), 0);
    
    return selectedItems.map(item => {
      const mod = item.modulo;
      const c = configsMap.get(mod.idFornecedor) || configsMap.get(null);
      const supplier = fornecedores.find(f => f.id === mod.idFornecedor);
      
      const riskVal = c ? calculateCotacaoRisco(supplier?.nome, cotacao, c.valorReducaoDolar) : 1;
      const freightUSD = calculateFreteRateio(totalFreteBRL / (riskVal || 1), totalM3, mod.m3, selectedItems.length, 1, tipoRateio);
      const freightDisp = currency === "BRL" ? freightUSD * riskVal : freightUSD;

      return { 
        ...item, 
        freightUSD, 
        freightDisp,
        riskVal,
        config: c
      };
    });
  }, [selectedItems, totalFreteBRL, tipoRateio, cotacao, configsMap, currency, fornecedores]);

  // Handlers for Print/Excel
  const handlePrint = () => {
    if (itemsWithCalculations.length === 0) return alert("Selecione itens primeiro.");
    
    printPriceListReport({
      modules: itemsWithCalculations.map(si => si.modulo),
      freightMap: new Map(itemsWithCalculations.map(si => [si.modulo.id, si.freightUSD])),
      currency,
      cotacao,
      configsMap,
      maps: {
        fornecedor: fornMap,
        categoria: catMap,
        marca: marcaMap,
        tecido: tecidoMap
      },
      validityDays
    });
  };

  const handleExcel = async () => {
    if (itemsWithCalculations.length === 0) return alert("Selecione itens primeiro.");
    setExportLoading(true);
    try {
      const payload = {
        items: itemsWithCalculations.map(si => ({
          moduloId: si.modulo.id,
          valorFreteRateadoUSD: si.freightUSD
        })),
        currency,
        cotacao,
        validityDays
      };

      const blob = await exportPriceListExcel(payload);
      
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement("a");
      a.href = url;
      a.download = `ListaPrecos_${currency}_${new Date().getTime()}.xlsx`;
      document.body.appendChild(a);
      a.click();
      window.URL.revokeObjectURL(url);
    } catch (e) {
      alert("Erro ao exportar Excel");
      console.error(e);
    } finally {
      setExportLoading(false);
    }
  };

  // Helper for grid display
  const calcPriceWithFreight = useCallback((mod: Modulo, valorTecido: number, freightUSD: number) => {
    const c = configsMap.get(mod.idFornecedor) || configsMap.get(null);
    if (!c) return 0;
    
    const supplier = fornecedores.find(f => f.id === mod.idFornecedor);
    const riskVal = calculateCotacaoRisco(supplier?.nome, cotacao, c.valorReducaoDolar);
    
    const exw = calculateEXW(valorTecido, riskVal, c.percentualComissao, c.percentualGordura);
    const unitUSD = exw + freightUSD;

    return currency === "BRL" ? unitUSD * riskVal : unitUSD;
  }, [configsMap, cotacao, currency, fornecedores]);

  return (
    <div className="list-container">
      <PageHeader title="Emissão de Lista de Preços" icon={<Download size={24} />} />

      {/* Selection Setup */}
      <div style={{ background: 'rgba(255, 255, 255, 0.04)', padding: 16, borderRadius: 8, marginBottom: 16, display: 'flex', gap: 12, flexWrap: 'wrap', alignItems: 'flex-end' }}>
        <div style={{ width: 220 }}>
           <label className="label">Frete Base (Rateio)</label>
           <SearchableSelect 
             value={selectedFreteId}
             onChange={setSelectedFreteId}
             options={[{ value: "", label: "Nenhum" }, ...fretes.map(f => ({ value: f.id, label: f.nome }))]}
             placeholder="Selecione o frete..."
           />
        </div>
        <div style={{ width: 120 }}>
           <label className="label">Valor BRL</label>
           <input className="cl-input" type="number" value={totalFreteBRL} onChange={e => setTotalFreteBRL(Number(e.target.value))} />
        </div>
        <div style={{ width: 140 }}>
           <label className="label">Tipo Rateio</label>
           <select className="cl-input" value={tipoRateio} onChange={e => setTipoRateio(e.target.value as "IGUAL" | "M3")}>
             <option value="IGUAL">Igualitário</option>
             <option value="M3">Por M³</option>
           </select>
        </div>
        <div style={{ width: 100 }}>
           <label className="label">Moeda</label>
           <select className="cl-input" value={currency} onChange={e => setCurrency(e.target.value as "BRL" | "EXW")}>
             <option value="EXW">USD (EXW)</option>
             <option value="BRL">BRL (R$)</option>
           </select>
        </div>
        <div style={{ width: 90 }}>
           <label className="label">Validade</label>
           <input className="cl-input" type="number" value={validityDays} onChange={e => setValidityDays(Number(e.target.value))} title="Dias de validade" />
        </div>
        <div style={{ display: 'flex', gap: 8 }}>
          <button className="btn btn-primary" onClick={handlePrint}>
            <Printer size={18} /> Imprimir PDF
          </button>
          <button className="btn btn-secondary" onClick={handleExcel} disabled={exportLoading}>
            <FileSpreadsheet size={18} /> Exportar Excel
          </button>
          <button className="btn btn-danger" onClick={clearSelection} title="Limpar Lista">
            <Trash2 size={18} />
          </button>
        </div>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 20 }}>
        
        {/* Left: Search and Add */}
        <div className="card" style={{ padding: 16 }}>
           <h4 style={{ marginBottom: 12 }}>1. Buscar Módulos</h4>
           <div style={{ display: 'flex', gap: 8, marginBottom: 12, flexWrap: 'wrap' }}>
              <div style={{ flex: 1 }}>
                <SearchableSelect 
                  value={filterFornecedor}
                  onChange={setFilterFornecedor}
                  options={[{ value: "", label: "Fornecedor (Todos)" }, ...fornecedores.map(f => ({ value: f.id, label: f.nome }))]}
                  placeholder="Fornecedor"
                />
              </div>
               <div style={{ flex: 1 }}>
                 <SearchableSelect 
                   value={filterMarca}
                   onChange={setFilterMarca}
                   options={[{ value: "", label: "Marca (Todas)" }, ...marcas.map(m => ({ value: m.id, label: m.nome }))]}
                   placeholder="Marca"
                 />
               </div>
               <div style={{ flex: 1 }}>
                 <SearchableSelect 
                   value={filterCategoria}
                   onChange={setFilterCategoria}
                   options={[{ value: "", label: "Categoria (Todas)" }, ...categorias.map(c => ({ value: c.id, label: c.nome }))]}
                   placeholder="Categoria"
                 />
               </div>
               <div style={{ flex: 1 }}>
                 <SearchableSelect 
                   value={filterTecido}
                   onChange={setFilterTecido}
                   options={[{ value: "", label: "Tecido (Todos)" }, ...tecidos.map(t => ({ value: t.id, label: t.nome }))]}
                   placeholder="Tecido"
                 />
               </div>
            </div>
           <input 
             className="cl-input" 
             placeholder="Pesquisar módulo..." 
             value={search} 
             onChange={e => setSearch(e.target.value)} 
             style={{ marginBottom: 12 }}
           />

           <div style={{ maxHeight: '500px', overflowY: 'auto' }}>
             <table style={{ width: '100%' }}>
               <thead>
                 <tr style={{ borderBottom: '2px solid var(--border)' }}>
                   <th style={{ textAlign: 'left', padding: '12px 8px' }}>Módulo</th>
                   <th style={{ textAlign: 'right', padding: '12px 8px' }}></th>
                 </tr>
               </thead>
               <tbody>
                  {loading ? (
                    <tr><td colSpan={2} style={{ textAlign: 'center', padding: 20 }}>Carregando módulos...</td></tr>
                  ) : (
                    <>
                      {items.map(m => (
                        <tr key={m.id} style={{ borderBottom: '1px solid rgba(255,255,255,0.03)' }}>
                          <td style={{ padding: '10px 8px' }}>
                            <div style={{ display: 'flex', gap: 10, alignItems: 'center' }}>
                              {marcaMap.get(m.idMarca)?.imagem ? (
                                <img 
                                  src={getImgUrl(marcaMap.get(m.idMarca)?.imagem)} 
                                  alt="" 
                                  style={{ width: 40, height: 40, objectFit: 'cover', borderRadius: 6, background: 'rgba(255,255,255,0.05)' }} 
                                />
                              ) : (
                                <div style={{ width: 40, height: 40, borderRadius: 6, background: 'rgba(255,255,255,0.05)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '0.6rem', color: '#475569' }}>N/A</div>
                              )}
                              <div>
                                <div style={{ fontWeight: 600, color: '#e2e8f0' }}>{m.descricao}</div>
                                <div style={{ fontSize: '0.75rem', color: '#64748b' }}>Fornecedor: {fornMap.get(m.idFornecedor)}</div>
                              </div>
                            </div>
                          </td>
                          <td style={{ textAlign: 'right', padding: '10px 8px' }}>
                             <button className="btn btn-sm btn-primary" onClick={() => addToSelection(m)}>Adicionar</button>
                          </td>
                        </tr>
                      ))}
                      {items.length === 0 && (
                        <tr><td colSpan={2} style={{ textAlign: 'center', padding: 20, color: '#94a3b8' }}>Nenhum módulo encontrado</td></tr>
                      )}
                    </>
                  )}
               </tbody>
             </table>
           </div>
        </div>

        {/* Right: Selected List */}
        <div className="card" style={{ padding: 16 }}>
           <h4 style={{ marginBottom: 12 }}>2. Itens Selecionados ({selectedItems.length})</h4>
           <div style={{ maxHeight: '600px', overflowY: 'auto' }}>
             <table style={{ width: '100%' }}>
                <thead>
                  <tr style={{ borderBottom: '2px solid var(--border)' }}>
                    <th style={{ textAlign: 'left', padding: '12px 8px' }}>Módulo</th>
                    <th style={{ textAlign: 'right', padding: '12px 8px' }}>Frete ({currency})</th>
                    <th style={{ textAlign: 'left', padding: '12px 20px' }}>Valores (C/ Frete por Tecido)</th>
                    <th style={{ textAlign: 'center', padding: '12px 8px' }}></th>
                  </tr>
                </thead>
               <tbody>
                 {itemsWithCalculations.map(si => (
                   <tr key={si.tempId} style={{ borderBottom: '1px solid rgba(255,255,255,0.05)' }}>
                     <td style={{ verticalAlign: 'top', padding: '12px 8px' }}>
                        <div style={{ display: 'flex', gap: 12 }}>
                          {marcaMap.get(si.modulo.idMarca)?.imagem ? (
                            <img 
                              src={getImgUrl(marcaMap.get(si.modulo.idMarca)?.imagem)} 
                              alt="" 
                              style={{ width: 60, height: 60, objectFit: 'cover', borderRadius: 8, background: 'rgba(255,255,255,0.05)' }} 
                            />
                          ) : (
                            <div style={{ width: 60, height: 60, borderRadius: 8, background: 'rgba(255,255,255,0.05)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '0.7rem', color: '#475569' }}>S/ Foto</div>
                          )}
                          <div>
                            <div style={{ fontWeight: 700, color: '#fff', fontSize: '1rem' }}>{si.modulo.descricao}</div>
                            <div style={{ color: '#94a3b8', fontSize: '0.85rem', marginTop: 4 }}>
                              Marca: <span style={{ color: '#cbd5e1' }}>{marcaMap.get(si.modulo.idMarca)?.nome || "N/A"}</span>
                            </div>
                          </div>
                        </div>
                     </td>
                     <td style={{ verticalAlign: 'top', textAlign: 'right', padding: '12px 8px', width: 140 }}>
                        <div style={{ color: '#60a5fa', fontWeight: 600, fontSize: '0.95rem' }}>
                          {currency === 'BRL' ? 'R$' : '$'} {fmt(si.freightDisp)}
                        </div>
                        <div style={{ fontSize: '0.7rem', color: '#64748b', marginTop: 4 }}>FRETE UNITÁRIO</div>
                     </td>
                     <td style={{ verticalAlign: 'top', padding: '12px 8px' }}>
                        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '4px 12px', background: 'rgba(0,0,0,0.2)', padding: 8, borderRadius: 6 }}>
                          {si.modulo.modulosTecidos?.map(mt => (
                            <div key={`${si.tempId}_${mt.id}`} style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.8rem', borderBottom: '1px solid rgba(255,255,255,0.03)', paddingBottom: 2 }}>
                              <span style={{ color: '#94a3b8' }}>{mt.tecido?.nome}:</span>
                              <span style={{ fontWeight: 600, color: '#fff', marginLeft: 8 }}>
                                {currency === 'BRL' ? 'R$' : '$'} {fmt(calcPriceWithFreight(si.modulo, mt.valorTecido, si.freightUSD))}
                              </span>
                            </div>
                          ))}
                        </div>
                     </td>
                     <td style={{ verticalAlign: 'top', textAlign: 'center', padding: '12px 8px', width: 50 }}>
                        <button className="btn-icon" onClick={() => removeFromSelection(si.tempId)} title="Remover" style={{ marginTop: 4 }}>
                          <Trash2 size={18} color="#ef4444" />
                        </button>
                     </td>
                   </tr>
                 ))}
                 {itemsWithCalculations.length === 0 && (
                   <tr>
                     <td colSpan={4} style={{ textAlign: 'center', padding: 20, color: '#94a3b8' }}>Nenhum item selecionado</td>
                   </tr>
                 )}
               </tbody>
             </table>
           </div>
        </div>

      </div>
    </div>
  );
}
