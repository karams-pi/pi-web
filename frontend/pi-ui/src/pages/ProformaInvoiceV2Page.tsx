
import React, { useEffect, useState, useMemo, useCallback } from "react";
import { useParams, useNavigate } from "react-router-dom";
import PasswordGuard from "../components/PasswordGuard";
import { 
  listFretes
} from "../api/fretes";
import { 
  getProximaSequencia, 
  getCotacaoUSD, 
  createPi, 
  updatePi, 
  getPi 
} from "../api/pis";
import { getTotalFrete } from "../api/configuracoesFreteItem";
import { calculateCotacaoRisco, calculateEXW, calculateFreteRateio } from "../utils/calculations";
import { getLatestConfig } from "../api/configuracoes";
import { listModulosTecidos } from "../api/modulos";
import { listClientes } from "../api/clientes";
import { listFornecedores } from "../api/fornecedores";
import { listModelos } from "../api/modelos";
import { listMarcas } from "../api/marcas";
import type { ModuloTecido, Configuracao, ProformaInvoice, PiItem, Fornecedor, Frete, Modelo, Cliente, Marca } from "../api/types";
import { SearchableSelect } from "../components/SearchableSelect";
import { PiSearchModal } from "../components/PiSearchModal";
import { ModuloTecidoSelect } from "../components/ModuloTecidoSelect";
import { Save, Plus, Trash2, Search, FileText } from "lucide-react";
import PageHeader from "../components/PageHeader";
import "./ClientesPage.css"; // Reuse existing system classes

type FormState = {
  id?: number;
  prefixo: string;
  piSequencia: string;
  dataPi: string;
  idCliente: string;
  idFornecedor: string;
  idFrete: number;
  cotacaoAtualUSD: number;
  cotacaoRisco: number | string;
  valorTotalFreteBRL: number;
  valorTotalFreteUSD: number;
  tempoEntrega?: string;
  condicaoPagamento?: string;
};

type ItemGrid = {
  id?: number;
  tempId: number;
  idModuloTecido: number;
  moduloTecido?: ModuloTecido;
  quantidade: number;
  largura: number;
  profundidade: number;
  altura: number;
  pa: number;
  m3: number;
  ValorEXW: number;
  ValorFreteRateadoBRL: number;
  ValorFreteRateadoUSD: number;
  ValorFinalItemBRL: number;
  ValorFinalItemUSDRisco: number;
  codigoModuloTecido?: string;
  observacao?: string;
  feet?: string;
  finishing?: string;
};

interface FabricGroup {
  fabricName: string;
  items: ItemGrid[];
  span: number;
  totalUsdUnit: number;
  totalUsdGroup: number;
}

const fmt = (n: number | undefined, decimals = 2) => (n || 0).toLocaleString("pt-BR", { minimumFractionDigits: decimals, maximumFractionDigits: decimals });
const fmt3 = (n: number | undefined) => (n || 0).toLocaleString("pt-BR", { minimumFractionDigits: 3, maximumFractionDigits: 3 });

export default function ProformaInvoiceV2Page() {
  const { id } = useParams();
  const navigate = useNavigate();

  const [form, setForm] = useState<FormState>({
    prefixo: "SW",
    piSequencia: "00001",
    dataPi: new Date().toISOString().split('T')[0],
    idCliente: "",
    idFornecedor: "",
    idFrete: 1,
    cotacaoAtualUSD: 0,
    cotacaoRisco: 0,
    valorTotalFreteBRL: 0,
    valorTotalFreteUSD: 0,
  });

  const [itens, setItens] = useState<ItemGrid[]>([]);
  const [saving, setSaving] = useState(false);
  const [clientes, setClientes] = useState<Cliente[]>([]);
  const [fornecedores, setFornecedores] = useState<Fornecedor[]>([]);
  const [fretes, setFretes] = useState<Frete[]>([]);
  const [modelos, setModelos] = useState<Modelo[]>([]);
  const [marcas, setMarcas] = useState<Marca[]>([]);
  const [modulosTecidos, setModulosTecidos] = useState<ModuloTecido[]>([]);
  const [config, setConfig] = useState<Configuracao | null>(null);
  const [loading, setLoading] = useState(true);
  const [showSearchModal, setShowSearchModal] = useState(false);
  const [showItemModal, setShowItemModal] = useState(false);

  // Filters for Item Selection Modal
  const [filterFornecedor, setFilterFornecedor] = useState("");
  const [filterCategoria, setFilterCategoria] = useState("");
  const [filterMarca, setFilterMarca] = useState("");
  const [filterTecido, setFilterTecido] = useState("");
  const [selModuloTecido, setSelModuloTecido] = useState("");
  const [codigoModuloTecido, setCodigoModuloTecido] = useState("");
  const [quantidade, setQuantidade] = useState<number | string>(1);

  useEffect(() => {
    loadInitialData();
  }, [id]);

  async function loadInitialData() {
    try {
      setLoading(true);
      (window as any)._isInitialLoad = true;
      const [ fList, cData, mtData, cfgData, seq, cot, fData, piData, modData, marcasData ] = await Promise.all([
        listFretes(),
        listClientes({ pageSize: 1000 }),
        listModulosTecidos(),
        getLatestConfig().catch(() => null),
        getProximaSequencia(),
        getCotacaoUSD(),
        listFornecedores(),
        id ? getPi(Number(id)).catch(() => null) : Promise.resolve(null),
        listModelos().catch(() => []),
        listMarcas().catch(() => [])
      ]);

      setFretes(fList);
      setClientes(cData.items || []);
      setModulosTecidos(mtData || []);
      setConfig(cfgData);
      setFornecedores(fData);
      setModelos(modData);
      setMarcas(marcasData);
      
      // Removed fixed maxHeight and overflow from grid container to eliminate scroll
      
      const risk = Number((cot - (cfgData?.valorReducaoDolar || 0)).toFixed(2));
      
      if (piData) {
        setForm({
          id: piData.id,
          prefixo: piData.prefixo,
          piSequencia: piData.piSequencia,
          dataPi: new Date(piData.dataPi).toISOString().split('T')[0],
          idCliente: String(piData.idCliente),
          idFornecedor: String(piData.idFornecedor || ""),
          idFrete: piData.idFrete,
          cotacaoAtualUSD: piData.cotacaoAtualUSD,
          cotacaoRisco: piData.cotacaoRisco,
          valorTotalFreteBRL: piData.valorTotalFreteBRL,
          valorTotalFreteUSD: piData.valorTotalFreteUSD,
          tempoEntrega: piData.tempoEntrega,
          condicaoPagamento: piData.condicaoPagamento
        });

        const itapi = piData.piItens || [];
        setItens(itapi.map((it: any) => ({
          id: it.id,
          tempId: Math.random(),
          idModuloTecido: it.idModuloTecido,
          quantidade: it.quantidade,
          largura: it.largura,
          profundidade: it.profundidade,
          altura: it.altura,
          pa: it.pa,
          m3: it.m3 || (it.largura * it.profundidade * it.altura),
          ValorEXW: it.valorEXW,
          ValorFreteRateadoBRL: it.valorFreteRateadoBRL,
          ValorFreteRateadoUSD: it.valorFreteRateadoUSD,
          ValorFinalItemBRL: it.valorFinalItemBRL,
          ValorFinalItemUSDRisco: it.valorFinalItemUSDRisco,
          codigoModuloTecido: it.tempCodigoModuloTecido,
          observacao: it.observacao,
          feet: it.feet,
          finishing: it.finishing
        })));
      } else {
        setForm(prev => ({
          ...prev,
          piSequencia: seq,
          cotacaoAtualUSD: cot,
          cotacaoRisco: risk,
          idFrete: prev.idFrete || (fList.length > 0 ? fList[0].id : 1)
        }));
      }
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
      setTimeout(() => { (window as any)._isInitialLoad = false; }, 500);
    }
  }

  const getModelImage = (idModuloTecido: number) => {
    const mt = modulosTecidos.find(m => m.id === idModuloTecido);
    const m = mt?.modulo as any;
    if (!m) return null;
    
    let rawImg = "";

    // 1. Try finding image in Modelo state (highest priority)
    const idModelo = m.idModelo || (mt as any).idModelo;
    if (idModelo) {
      const dbModelo = modelos.find(md => md.id === idModelo);
      if (dbModelo?.urlImagem) rawImg = dbModelo.urlImagem;
    }

    // 2. Try finding image in Marca state (fallback if no model image)
    if (!rawImg) {
      const idMarca = m.marca?.id || m.idMarca || (mt as any).idMarca;
      if (idMarca) {
        const dbMarca = marcas.find(ma => ma.id === Number(idMarca));
        if (dbMarca?.imagem) rawImg = dbMarca.imagem;
      }
    }
    
    // 3. Last fallback: try the object's nested image
    if (!rawImg) rawImg = m.marca?.imagem || "";
    
    if (!rawImg) return null;

    // Handle formats
    if (rawImg.startsWith("data:") || rawImg.startsWith("http")) return rawImg;
    if (rawImg.length > 100) return `data:image/png;base64,${rawImg}`;
    
    const baseUrl = (import.meta.env.VITE_API_BASE ?? "http://localhost:5000").replace(/\/+$/, "");
    return `${baseUrl}${rawImg.startsWith("/") ? "" : "/"}${rawImg}`;
  };

  const recalcularRateio = useCallback(() => {
    setItens(prevItens => {
      if (prevItens.length === 0) return prevItens;
      const totalM3 = prevItens.reduce((sum, item) => sum + (item.m3 * item.quantidade), 0);
      
      const novosItens = prevItens.map(item => {
        const freteUnitarioBRL = calculateFreteRateio(form.valorTotalFreteBRL, totalM3, item.m3);
        const freteUnitarioUSD = calculateFreteRateio(form.valorTotalFreteUSD, totalM3, item.m3);
        const valorBaseBRL = item.ValorEXW * (Number(form.cotacaoRisco) || 0);

        return {
          ...item,
          ValorFreteRateadoBRL: freteUnitarioBRL,
          ValorFreteRateadoUSD: freteUnitarioUSD,
          ValorFinalItemBRL: (valorBaseBRL + freteUnitarioBRL) * item.quantidade,
          ValorFinalItemUSDRisco: (item.ValorEXW + freteUnitarioUSD) * item.quantidade,
        };
      });

      if (JSON.stringify(novosItens) === JSON.stringify(prevItens)) return prevItens;
      return novosItens;
    });
  }, [form.valorTotalFreteBRL, form.valorTotalFreteUSD, form.cotacaoRisco]);

  const recalculateAllItems = (risk: number, freightUSD: number, freightBRL: number, currentConfig: Configuracao | null) => {
    setItens(prev => prev.map(item => {
      const mt = modulosTecidos.find(m => m.id === item.idModuloTecido);
      if (!mt) return item;

      const newEXW = calculateEXW(mt.valorTecido, risk, currentConfig?.percentualComissao || 0, currentConfig?.percentualGordura || 0);
      const totalM3 = prev.reduce((sum, i) => sum + (i.m3 * i.quantidade), 0);
      const fUnitBRL = calculateFreteRateio(freightBRL, totalM3, item.m3);
      const fUnitUSD = calculateFreteRateio(freightUSD, totalM3, item.m3);
      const vBaseBRL = newEXW * risk;

      return {
        ...item,
        ValorEXW: newEXW,
        ValorFreteRateadoBRL: fUnitBRL,
        ValorFreteRateadoUSD: fUnitUSD,
        ValorFinalItemBRL: (vBaseBRL + fUnitBRL) * item.quantidade,
        ValorFinalItemUSDRisco: (newEXW + fUnitUSD) * item.quantidade
      };
    }));
  };

  const loadFreteTotals = useCallback(async () => {
    if ((window as any)._isInitialLoad && id) return;

    try {
      const idForn = form.idFornecedor && form.idFornecedor !== "0" && form.idFornecedor !== "" ? Number(form.idFornecedor) : undefined;
      const total = await getTotalFrete(form.idFrete, idForn);
      const cotacao = Number(form.cotacaoRisco) || 0;
      const totalUSD = cotacao > 0 ? total / cotacao : 0;
      setForm(prev => ({ ...prev, valorTotalFreteBRL: total, valorTotalFreteUSD: totalUSD }));
    } catch (e) {
      console.error("Error loading freight totals:", e);
    }
  }, [form.idFrete, form.idFornecedor, form.cotacaoRisco, id]);

  useEffect(() => {
    const idForn = form.idFornecedor ? Number(form.idFornecedor) : undefined;
    getLatestConfig(idForn).then(newConfig => {
      setConfig(newConfig);
      if (newConfig && form.cotacaoAtualUSD) {
        const supplier = idForn ? fornecedores.find(f => f.id === idForn) : undefined;
        const risk = calculateCotacaoRisco(supplier?.nome, form.cotacaoAtualUSD, newConfig.valorReducaoDolar);
        setForm(prev => ({ ...prev, cotacaoRisco: risk }));
        recalculateAllItems(risk, form.valorTotalFreteBRL / risk, form.valorTotalFreteBRL, newConfig);
      }
    }).catch(console.error);
  }, [form.idFornecedor, form.cotacaoAtualUSD]);

  useEffect(() => {
    if (form.idFrete) loadFreteTotals();
  }, [form.idFrete, form.idFornecedor, loadFreteTotals]);

  useEffect(() => {
    recalcularRateio();
  }, [recalcularRateio]);


  const fornecedorOptions = useMemo(() => fornecedores.map(f => ({ value: String(f.id), label: f.nome })), [fornecedores]);
  const clienteOptions = useMemo(() => clientes.map(c => ({ value: String(c.id), label: c.empresa ? `${c.nome} - ${c.empresa}` : c.nome })), [clientes]);
  const freteOptions = useMemo(() => fretes.map(f => ({ value: String(f.id), label: f.nome })), [fretes]);
  const condicaoOptions = useMemo(() => [
    { value: "A VISTA", label: "A VISTA" },
    { value: "ANTECIPADO", label: "ANTECIPADO" },
    { value: "30% PARA FABRICAÇÃO E 70% ANTES DA COLETA", label: "30% PARA FABRICAÇÃO E 70% ANTES DA COLETA" }
  ], []);

  const modalFornecedorOptions = useMemo(() => {
    const parentId = form.idFornecedor;
    const parentSup = fornecedores.find(f => String(f.id) === parentId);
    const name = parentSup?.nome?.toLowerCase() || "";

    const groupA = ["karams", "koyo"];
    const groupB = ["ferguile", "livintus"];

    const isGroupA = groupA.some(g => name.includes(g));
    const isGroupB = groupB.some(g => name.includes(g));

    let filtered = fornecedores;
    if (isGroupA) {
      filtered = fornecedores.filter(f => groupA.some(g => f.nome.toLowerCase().includes(g)));
    } else if (isGroupB) {
      filtered = fornecedores.filter(f => groupB.some(g => f.nome.toLowerCase().includes(g)));
    }

    return [{ value: "", label: "Todos" }, ...filtered.map(f => ({ value: String(f.id), label: f.nome }))];
  }, [fornecedores, form.idFornecedor]);

  const processedData = useMemo(() => {
    if (itens.length === 0 || !modulosTecidos) return { groups: [] as FabricGroup[] };

    const sorted = [...itens].sort((a, b) => {
       const mtA = (modulosTecidos || []).find(m => m.id === a.idModuloTecido);
       const mtB = (modulosTecidos || []).find(m => m.id === b.idModuloTecido);
       const fA = mtA?.tecido?.nome || "";
       const fB = mtB?.tecido?.nome || "";
       return fA.localeCompare(fB);
    });

    const groups: FabricGroup[] = [];
    let currentGroup: FabricGroup | null = null;

    sorted.forEach(item => {
      const mt = (modulosTecidos || []).find(m => m.id === item.idModuloTecido);
      const fabricName = mt?.tecido?.nome || "Sem Tecido";
      
      const usdUnit = Number((item.ValorFinalItemUSDRisco).toFixed(2));
      const totalUsd = Number((usdUnit * item.quantidade).toFixed(2));
      
      if (!currentGroup || currentGroup.fabricName !== fabricName) {
        currentGroup = { fabricName, items: [], span: 0, totalUsdUnit: 0, totalUsdGroup: 0 };
        groups.push(currentGroup);
      }
      currentGroup.items.push(item);
      currentGroup.span++;
      currentGroup.totalUsdUnit += usdUnit;
      currentGroup.totalUsdGroup += totalUsd;
    });

    return { groups };
  }, [itens, modulosTecidos]);

  const addItem = () => {
    setShowItemModal(true);
  };

  const adicionarItem = () => {
    if (!selModuloTecido || selModuloTecido === "0") {
      alert("Selecione um módulo");
      return;
    }

    const mt = modulosTecidos.find(m => m.id === Number(selModuloTecido));
    if (!mt) return;

    const risk = Number(form.cotacaoRisco) || 1;
    const exw = calculateEXW(mt.valorTecido, risk, config?.percentualComissao || 0, config?.percentualGordura || 0);
    
    const newItem: ItemGrid = {
      tempId: Math.random(),
      idModuloTecido: mt.id,
      quantidade: Number(quantidade) || 1,
      largura: mt.modulo?.largura || 0,
      profundidade: mt.modulo?.profundidade || 0,
      altura: mt.modulo?.altura || 0,
      pa: 0,
      m3: (mt.modulo?.largura || 0) * (mt.modulo?.profundidade || 0) * (mt.modulo?.altura || 0),
      ValorEXW: exw,
      ValorFreteRateadoBRL: 0,
      ValorFreteRateadoUSD: 0,
      ValorFinalItemBRL: 0,
      ValorFinalItemUSDRisco: 0,
      codigoModuloTecido: codigoModuloTecido
    };

    setItens([...itens, newItem]);
    setShowItemModal(false);
    // Optional: reset selection but keep filters
    setSelModuloTecido("");
    setCodigoModuloTecido("");
    setQuantidade(1);
  };

  const removeItem = (tempId: number) => {
    setItens(itens.filter(i => i.tempId !== tempId));
  };

  const updateItem = (tempId: number, field: keyof ItemGrid, value: any) => {
    setItens(itens.map(it => {
      if (it.tempId === tempId) {
        const updated = { ...it, [field]: value };
        if (field === "idModuloTecido") {
          const mt = modulosTecidos.find(m => m.id === Number(value));
          if (mt) {
            updated.largura = mt.modulo?.largura || 0;
            updated.profundidade = mt.modulo?.profundidade || 0;
            updated.altura = mt.modulo?.altura || 0;
            updated.m3 = updated.largura * updated.profundidade * updated.altura;
            updated.ValorEXW = calculateEXW(mt.valorTecido, Number(form.cotacaoRisco), config?.percentualComissao || 0, config?.percentualGordura || 0);
          }
        }
        return updated;
      }
      return it;
    }));
  };

  async function salvar() {
    try {
      if (!form.idCliente) { alert("Selecione um cliente"); return; }
      setSaving(true);
      const totalM3 = itens.reduce((sum, i) => sum + (i.m3 * i.quantidade), 0);
      const valorTecido = itens.reduce((sum, item) => sum + (item.ValorEXW * item.quantidade), 0);
      
      const piData: Omit<ProformaInvoice, "id"> = {
        prefixo: form.prefixo,
        piSequencia: form.piSequencia,
        dataPi: new Date(form.dataPi).toISOString(),
        idCliente: form.idCliente,
        idFornecedor: form.idFornecedor ? Number(form.idFornecedor) : null,
        idConfiguracoes: config?.id || 0,
        idFrete: form.idFrete,
        valorTecido,
        valorTotalFreteBRL: form.valorTotalFreteBRL,
        valorTotalFreteUSD: form.valorTotalFreteUSD,
        cotacaoAtualUSD: form.cotacaoAtualUSD,
        cotacaoRisco: Number(form.cotacaoRisco),
        tempoEntrega: form.tempoEntrega || "",
        condicaoPagamento: form.condicaoPagamento || "",
        piItens: itens.map(item => {
          const freteUnitBRL = totalM3 > 0 ? (form.valorTotalFreteBRL / totalM3) * item.m3 : 0;
          const freteUnitUSD = totalM3 > 0 ? (form.valorTotalFreteUSD / totalM3) * item.m3 : 0;
          const valorBaseBRL = item.ValorEXW * (Number(form.cotacaoRisco) || 0);

          return {
            id: item.id || 0,
            idPi: form.id || 0,
            idModuloTecido: item.idModuloTecido,
            quantidade: item.quantidade,
            largura: item.largura,
            profundidade: item.profundidade,
            altura: item.altura,
            pa: item.pa,
            m3: item.m3,
            rateioFrete: freteUnitUSD,
            valorEXW: item.ValorEXW,
            valorFreteRateadoBRL: freteUnitBRL,
            valorFreteRateadoUSD: freteUnitUSD,
            valorFinalItemBRL: (valorBaseBRL + freteUnitBRL) * item.quantidade,
            valorFinalItemUSDRisco: (item.ValorEXW + freteUnitUSD) * item.quantidade,
            observacao: item.observacao || "",
            tempCodigoModuloTecido: item.codigoModuloTecido || "",
            feet: item.feet || "",
            finishing: item.finishing || ""
          } as PiItem;
        })
      };

      if (form.id) {
        await updatePi(form.id, piData as any);
      } else {
        const newPi = await createPi(piData as any);
        setForm(prev => ({ ...prev, id: newPi.id }));
        navigate(`/proforma-invoice-v2/${newPi.id}`);
      }
      alert("PI Salva com sucesso!");
    } catch (e) {
      console.error(e);
      alert("Erro ao salvar PI");
    } finally {
      setSaving(false);
    }
  }

  return (
    <PasswordGuard>
      {loading && (
        <div style={{
          position: "fixed", top: 0, left: 0, right: 0, bottom: 0,
          background: "rgba(10, 10, 18, 0.8)", backdropFilter: "blur(5px)",
          display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center",
          zIndex: 9999, color: "white"
        }}>
          <div className="spinner" style={{ 
            width: "50px", height: "50px", border: "5px solid rgba(255,255,255,0.1)", 
            borderTop: "5px solid #3b82f6", borderRadius: "50%", animation: "spin 1s linear infinite",
            marginBottom: "15px"
          }}></div>
          <style>{`@keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }`}</style>
          <span style={{ fontSize: "16px", fontWeight: "600", letterSpacing: "1px" }}>CARREGANDO DADOS...</span>
        </div>
      )}

      <div className="pi-v2-full-screen-override" style={{ width: "100%", minHeight: "100vh", background: "transparent", color: "var(--text)" }}>
        <style>{`
          .main { padding-left: 0 !important; padding-right: 0 !important; }
          .main > .container, .main .container { max-width: 100% !important; width: 100% !important; padding-left: 5px !important; padding-right: 5px !important; margin: 0 !important; }
          .pi-v2-full-screen-override { width: 100% !important; padding: 0 10px !important; }
          .page-header { padding: 0 10px !important; }
          .table-row-v2:hover { background: rgba(255, 255, 255, 0.03) !important; }
        `}</style>

        <div style={{ padding: "10px 10px" }}>
          <PageHeader 
            title="Lançamento PI (V2 WYSIWYG - BETA)"
            icon={<FileText size={24} />}
          />
        </div>

        <div style={{ display: "flex", justifyContent: "flex-end", gap: "10px", padding: "0 10px 15px" }}>
          <button className="btn btn-secondary" onClick={() => setShowSearchModal(true)}><Search size={18}/> Buscar PI</button>
          <button className="btn btn-primary" onClick={salvar} disabled={saving}>
            <Save size={18}/> {saving ? "Salvando..." : "Salvar PI"}
          </button>
        </div>

        <div style={{ padding: "0 10px" }}>
          <div className="cl-card" style={{ marginBottom: "15px", padding: "15px", position: "relative", zIndex: 30 }}>
            <div style={{ display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: "15px" }}>
               <div className="field">
                 <label className="label">Fornecedor</label>
                 <SearchableSelect 
                   options={fornecedorOptions}
                   value={form.idFornecedor}
                   onChange={(val) => setForm({...form, idFornecedor: val})}
                   placeholder="Selecione"
                 />
               </div>
               <div className="field">
                 <label className="label">Cliente</label>
                 <SearchableSelect 
                   options={clienteOptions}
                   value={form.idCliente}
                   onChange={(val) => setForm({...form, idCliente: val})}
                   placeholder="Selecione"
                 />
               </div>
               <div className="field" style={{ minWidth: "120px" }}>
                 <label className="label">Sequência</label>
                 <div style={{ display: "flex", gap: "4px" }}>
                    <input type="text" className="cl-input" style={{ width: "50px" }} value={form.prefixo} onChange={e => setForm({...form, prefixo: e.target.value})} />
                    <input type="text" className="cl-input" value={form.piSequencia} onChange={e => setForm({...form, piSequencia: e.target.value})} />
                 </div>
               </div>
               <div className="field">
                 <label className="label">Data</label>
                 <input type="date" className="cl-input" value={form.dataPi} onChange={e => setForm({...form, dataPi: e.target.value})} />
               </div>
               <div className="field">
                 <label className="label">Cotação Risco</label>
                 <input type="number" step="0.01" className="cl-input" value={form.cotacaoRisco} onChange={e => setForm({...form, cotacaoRisco: e.target.value})} />
               </div>
               <div className="field">
                 <label className="label">Frete</label>
                 <SearchableSelect 
                   options={freteOptions}
                   value={String(form.idFrete)}
                   onChange={(val) => setForm({...form, idFrete: Number(val)})}
                   placeholder="Selecione"
                 />
               </div>
               <div className="field">
                 <label className="label">Frete Total (R$)</label>
                 <input type="number" step="0.01" className="cl-input" value={form.valorTotalFreteBRL} onChange={e => {
                    const brl = parseFloat(e.target.value) || 0;
                    const risk = Number(form.cotacaoRisco) || 1;
                    setForm({...form, valorTotalFreteBRL: brl, valorTotalFreteUSD: brl / risk});
                 }} />
               </div>
               <div className="field">
                 <label className="label">Tempo Entrega</label>
                 <input type="text" className="cl-input" value={form.tempoEntrega || ""} onChange={e => setForm({...form, tempoEntrega: e.target.value})} placeholder="Ex: 30 dias" />
               </div>
               <div className="field">
                 <label className="label">Cond. Pagamento</label>
                 <SearchableSelect 
                   options={condicaoOptions}
                   value={form.condicaoPagamento || ""}
                   onChange={(val) => setForm({...form, condicaoPagamento: val})}
                   placeholder="Selecione"
                 />
               </div>
            </div>
          </div>

          <div className="cl-card" style={{ padding: "0", overflow: "visible", borderRadius: "12px", border: "1px solid var(--border)", background: "transparent" }}>
            <div className="cl-tableWrap" style={{ overflow: "visible" }}>
              <table className="cl-table" style={{ width: "100%", borderCollapse: "separate", borderSpacing: "0", minWidth: "1400px" }}>
                <thead style={{ position: "sticky", top: 0, zIndex: 10 }}>
                  <tr style={{ background: "#0f172a" }}>
                    <th style={{ ...thStyle, width: "40px", textAlign: "center" }}>#</th>
                    <th style={{ ...thStyle, width: "60px", textAlign: "center" }}>Img</th>
                    <th style={{ ...thStyle, width: "120px", textAlign: "center" }}>Marca</th>
                    <th style={{ ...thStyle, width: "400px" }}>Módulo / Descrição</th>
                    <th style={{ ...thStyle, textAlign: "center", width: "50px" }}>L</th>
                    <th style={{ ...thStyle, textAlign: "center", width: "50px" }}>P</th>
                    <th style={{ ...thStyle, textAlign: "center", width: "50px" }}>A</th>
                    <th style={{ ...thStyle, textAlign: "center", width: "60px" }}>Qtd</th>
                    <th style={{ ...thStyle, textAlign: "center", width: "70px" }}>M³ Total</th>
                    <th style={{ ...thStyle, width: "140px", textAlign: "center" }}>Tecido</th>
                    <th style={{ ...thStyle, width: "100px" }}>Pés</th>
                    <th style={{ ...thStyle, width: "120px" }}>Acabamento</th>
                    <th style={{ ...thStyle, width: "140px" }}>Observação</th>
                    <th style={{ ...thStyle, textAlign: "right", width: "100px" }}>EXW Unit</th>
                    <th style={{ ...thStyle, textAlign: "right", width: "100px" }}>Frete</th>
                    <th style={{ ...thStyle, textAlign: "right", width: "110px" }}>USD Unit</th>
                    <th style={{ ...thStyle, textAlign: "right", width: "130px" }}>TOTAL USD</th>
                    <th style={{ ...thStyle, width: "50px" }}></th>
                  </tr>
                </thead>
                <tbody style={{ background: "rgba(15, 23, 42, 0.4)" }}>
                  {processedData.groups.map((group: FabricGroup, groupIndex: number) => (
                     <React.Fragment key={groupIndex}>
                        {group.items.map((item: ItemGrid, itemIndex: number) => {
                           const isFirst = itemIndex === 0;
                           const mtInfo = modulosTecidos.find(m => m.id === item.idModuloTecido);
                           
                           return (
                              <tr key={item.tempId} className="table-row-v2">
                                 <td style={{ ...tdStyle, textAlign: "center", color: "var(--muted)", opacity: 0.5 }}>{itemIndex + 1}</td>
                                 {isFirst && (
                                   <td rowSpan={group.span} style={{ ...tdStyle, textAlign: "center", verticalAlign: "middle", background: "rgba(255,255,255,0.02)" }}>
                                       {getModelImage(item.idModuloTecido) ? (
                                          <img 
                                            src={getModelImage(item.idModuloTecido)!} 
                                            alt="Modelo" 
                                            style={{ width: "45px", height: "45px", objectFit: "cover", borderRadius: "6px", border: "1px solid rgba(255,255,255,0.1)" }} 
                                          />
                                       ) : (
                                          <div style={{ width: "45px", height: "45px", background: "rgba(255,255,255,0.05)", borderRadius: "6px", display: "flex", alignItems: "center", justifyContent: "center", fontSize: "10px", color: "#666" }}>N/A</div>
                                       )}
                                    </td>
                                 )}
                                 {isFirst && (
                                   <td 
                                     rowSpan={group.span} 
                                     title={mtInfo?.modulo?.marca?.nome || ""}
                                     style={{ ...tdStyle, color: "#60a5fa", fontWeight: "600", verticalAlign: "middle", textAlign: "center", background: "rgba(255,255,255,0.02)" }}
                                   >
                                     {mtInfo?.modulo?.marca?.nome || "-"}
                                   </td>
                                 )}
                                 <td style={tdStyle}>
                                   <select 
                                     className="cl-select" 
                                     style={{ width: "100%", background: "transparent", border: "none", padding: "4px 0", height: "auto" }} 
                                     value={item.idModuloTecido} 
                                     onChange={e => updateItem(item.tempId, "idModuloTecido", Number(e.target.value))}
                                     title={mtInfo?.modulo?.descricao || "Selecione um módulo"}
                                   >
                                     <option value="0">Selecione um módulo...</option>
                                     {modulosTecidos.map(mt => (
                                        <option key={mt.id} value={mt.id} style={{ background: "#1e293b" }}>{mt.modulo?.descricao} ({mt.tecido?.nome})</option>
                                     ))}
                                   </select>
                                 </td>
                                 <td style={{ ...tdStyle, textAlign: "center" }}>{fmt(item.largura)}</td>
                                 <td style={{ ...tdStyle, textAlign: "center" }}>{fmt(item.profundidade)}</td>
                                 <td style={{ ...tdStyle, textAlign: "center" }}>{fmt(item.altura)}</td>
                                 <td style={{ ...tdStyle, textAlign: "center" }}>
                                    <input 
                                      type="number" 
                                      className="cl-input" 
                                      style={{ width: "55px", textAlign: "center", height: "28px", padding: "0" }} 
                                      value={item.quantidade} 
                                      onChange={e => updateItem(item.tempId, "quantidade", parseInt(e.target.value) || 1)}
                                    />
                                 </td>
                                 <td style={{ ...tdStyle, textAlign: "center", color: "#60a5fa" }}>{fmt3(item.m3 * item.quantidade)}</td>
                                 
                                 {isFirst && (
                                    <td rowSpan={group.span} style={{ 
                                      verticalAlign: "middle", 
                                      background: "rgba(59, 130, 246, 0.1)", 
                                      backdropFilter: "blur(4px)",
                                      borderLeft: "1px solid rgba(255, 255, 255, 0.05)", 
                                      borderRight: "1px solid rgba(255, 255, 255, 0.05)",
                                      color: "#93c5fd", 
                                      fontWeight: "700", 
                                      textAlign: "center",
                                      fontSize: "14px",
                                      letterSpacing: "0.5px"
                                    }}>
                                       {group.fabricName}
                                    </td>
                                  )}

                                 <td style={tdStyle}>
                                     <input 
                                       className="cl-input" 
                                       style={{ width: "100%", height: "28px", padding: "4px", fontSize: "12px", background: "transparent" }} 
                                       value={item.feet || ""} 
                                       onChange={e => updateItem(item.tempId, "feet", e.target.value)}
                                       placeholder="Pés..."
                                     />
                                  </td>
                                  <td style={tdStyle}>
                                     <input 
                                       className="cl-input" 
                                       style={{ width: "100%", height: "28px", padding: "4px", fontSize: "12px", background: "transparent" }} 
                                       value={item.finishing || ""} 
                                       onChange={e => updateItem(item.tempId, "finishing", e.target.value)}
                                       placeholder="Acabamento..."
                                     />
                                  </td>
                                  <td style={tdStyle}>
                                     <input 
                                       className="cl-input" 
                                       style={{ width: "100%", height: "28px", padding: "4px", fontSize: "12px", background: "transparent" }} 
                                       value={item.observacao || ""} 
                                       onChange={e => updateItem(item.tempId, "observacao", e.target.value)}
                                       placeholder="Obs..."
                                     />
                                  </td>

                 <td style={{ ...tdStyle, textAlign: "right", color: "#94a3b8" }}>$ {fmt(item.ValorEXW)}</td>
                                 <td style={{ ...tdStyle, textAlign: "right", color: "#94a3b8" }}>$ {fmt(item.ValorFreteRateadoUSD)}</td>
                                 
                                 {isFirst && (
                                    <td rowSpan={group.span} style={{ 
                                       textAlign: "right", 
                                       verticalAlign: "middle", 
                                       background: "rgba(255, 255, 255, 0.02)", 
                                       color: "#e5e7eb",
                                       fontWeight: "600",
                                       paddingRight: "10px"
                                     }}>
                                        $ {fmt(group.totalUsdUnit)}
                                    </td>
                                  )}

                                 {isFirst && (
                                    <td rowSpan={group.span} style={{ 
                                       textAlign: "right", 
                                       verticalAlign: "middle", 
                                       background: "rgba(239, 68, 68, 0.05)", 
                                       color: "#fca5a5",
                                       fontWeight: "800", 
                                       fontSize: "16px",
                                       paddingRight: "15px"
                                     }}>
                                        $ {fmt(group.totalUsdGroup)}
                                    </td>
                                  )}

                                 <td style={{ ...tdStyle, textAlign: "center" }}>
                                     <button onClick={() => removeItem(item.tempId)} className="btn btn-sm" style={{ border: "none", color: "var(--danger)", padding: 0, background: "none" }}><Trash2 size={16}/></button>
                                  </td>
                               </tr>
                           );
                        })}
                     </React.Fragment>
                  ))}
                  {itens.length === 0 && (
                     <tr>
                        <td colSpan={11} style={{ padding: "80px", textAlign: "center", color: "var(--muted)", fontSize: "16px" }}>
                           Nenhum item adicionado. Clique em <strong>Adicionar Módulo</strong> para começar.
                        </td>
                     </tr>
                  )}
                </tbody>
              </table>
            </div>
            <div style={{ padding: "15px 25px", background: "rgba(255, 255, 255, 0.03)", borderTop: "1px solid var(--border)" }}>
               <button className="btn btn-secondary" onClick={addItem} style={{ borderRadius: "8px" }}><Plus size={20}/> Adicionar Módulo</button>
            </div>
          </div>
        </div>

        {showSearchModal && (
          <PiSearchModal 
            onClose={() => setShowSearchModal(false)} 
            onSelect={(selectedPi) => { setShowSearchModal(false); navigate(`/proforma-invoice-v2/${selectedPi.id}`); }}
          />
        )}

        {showItemModal && (
          <div style={{
            position: "fixed", top: 0, left: 0, right: 0, bottom: 0,
            background: "rgba(10, 10, 18, 0.9)", backdropFilter: "blur(10px)",
            display: "flex", alignItems: "center", justifyContent: "center",
            zIndex: 10000, padding: "20px"
          }}>
            <div className="cl-card" style={{ width: "100%", maxWidth: "800px", padding: "30px", border: "1px solid rgba(255,255,255,0.1)", boxShadow: "0 25px 50px -12px rgba(0,0,0,0.5)" }}>
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "25px" }}>
                <h2 style={{ margin: 0, fontSize: "24px", color: "var(--primary)", fontWeight: "800", letterSpacing: "1px" }}>NOVO ITEM</h2>
                <button onClick={() => setShowItemModal(false)} style={{ background: "none", border: "none", color: "var(--muted)", cursor: "pointer", fontSize: "24px" }}>×</button>
              </div>

              <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "15px", marginBottom: "20px" }}>
                <div className="field">
                  <label className="label">Categoria</label>
                  <SearchableSelect
                    value={filterCategoria}
                    onChange={setFilterCategoria}
                    placeholder="Todas"
                    options={[{ value: "", label: "Todas" }, ...Array.from(new Set(modulosTecidos.map(mt => mt.modulo?.categoria?.id))).filter(Boolean).map(id => {
                      const mt = modulosTecidos.find(m => m.modulo?.categoria?.id === id);
                      return { value: String(id), label: mt?.modulo?.categoria?.nome || `Cat ${id}` };
                    })]}
                  />
                </div>
                <div className="field">
                  <label className="label" style={{ color: "#94a3b8" }}>Fornecedor</label>
                  <SearchableSelect 
                    value={filterFornecedor}
                    onChange={setFilterFornecedor}
                    placeholder="Todos"
                    options={modalFornecedorOptions}
                  />
                </div>
                <div className="field">
                  <label className="label">Modelo</label>
                  <SearchableSelect
                    value={filterMarca}
                    onChange={setFilterMarca}
                    placeholder="Todos"
                    options={[{ value: "", label: "Todos" }, ...marcas.map(m => ({ value: String(m.id), label: m.nome }))]}
                  />
                </div>
                <div className="field">
                  <label className="label">Tecido</label>
                  <SearchableSelect
                    value={filterTecido}
                    onChange={setFilterTecido}
                    placeholder="Todos"
                    options={[{ value: "", label: "Todos" }, ...Array.from(new Set(modulosTecidos.map(mt => mt.tecido?.id))).filter(Boolean).map(id => {
                      const mt = modulosTecidos.find(m => m.tecido?.id === id);
                      return { value: String(id), label: mt?.tecido?.nome || `Tec ${id}` };
                    })]}
                  />
                </div>
                <div style={{ display: "flex", alignItems: "flex-end", paddingBottom: "2px" }}>
                  <button 
                    className="btn btn-secondary"
                    onClick={() => {
                        setFilterFornecedor("");
                        setFilterCategoria("");
                        setFilterMarca("");
                        setFilterTecido("");
                    }}
                    style={{ height: "38px", width: "45px", padding: 0 }}
                    title="Limpar Filtros"
                  >
                    🧹
                  </button>
                </div>
              </div>

              <div className="field" style={{ marginBottom: "20px" }}>
                <label className="label" style={{ color: "#94a3b8" }}>Módulo-Tecido</label>
                <ModuloTecidoSelect
                  value={selModuloTecido}
                  onChange={(val) => setSelModuloTecido(val)}
                  options={modulosTecidos.filter(mt => {
                    const matchForn = !filterFornecedor || String(mt.modulo?.fornecedor?.id) === filterFornecedor;
                    const matchCat = !filterCategoria || String(mt.modulo?.categoria?.id) === filterCategoria;
                    const matchMarca = !filterMarca || String(mt.modulo?.marca?.id) === filterMarca;
                    const matchTecido = !filterTecido || String(mt.tecido?.id) === filterTecido;
                    return matchForn && matchCat && matchMarca && matchTecido;
                  })}
                  placeholder="Selecione um módulo..."
                />
              </div>

              <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "15px", marginBottom: "30px" }}>
                <div className="field">
                  <label className="label">Código</label>
                  <input
                    className="cl-input"
                    value={codigoModuloTecido}
                    onChange={(e) => setCodigoModuloTecido(e.target.value.substring(0, 10))}
                    placeholder="Código (opcional)"
                  />
                </div>
                <div className="field">
                  <label className="label">Quantidade</label>
                  <input
                    className="cl-input"
                    type="number"
                    value={quantidade}
                    onChange={(e) => setQuantidade(e.target.value)}
                  />
                </div>
              </div>

              <div style={{ display: "flex", gap: "15px" }}>
                <button 
                  className="btn btn-primary" 
                  style={{ flex: 2, padding: "12px", fontSize: "16px", fontWeight: "700" }}
                  onClick={adicionarItem}
                >
                  <Plus size={20} style={{ marginRight: "10px" }} /> ADICIONAR AO PEDIDO
                </button>
                <button 
                  className="btn btn-secondary" 
                  style={{ flex: 1, padding: "12px" }}
                  onClick={() => setShowItemModal(false)}
                >
                  CANCELAR
                </button>
              </div>
            </div>
          </div>
        )}

        <style>{`
          .table-row-v2:hover { background: rgba(255, 255, 255, 0.03); }
          .cl-select:focus { outline: none; }
          .table-row-v2 td { transition: background 0.2s; }
        `}</style>
      </div>
    </PasswordGuard>
  );
}

const thStyle: React.CSSProperties = {
  padding: "16px 12px",
  fontSize: "13px",
  fontWeight: "600",
  color: "var(--muted)",
  borderBottom: "1px solid var(--border)",
  textTransform: "uppercase",
  letterSpacing: "1px"
};

const tdStyle: React.CSSProperties = {
  padding: "12px",
  fontSize: "14px",
  borderBottom: "1px solid rgba(255, 255, 255, 0.05)",
  verticalAlign: "middle"
};
