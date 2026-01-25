import React, { useEffect, useState, useMemo } from "react";
import "./ClientesPage.css";


import { listFretes } from "../api/fretes";
import { getTotalFrete } from "../api/configuracoesFreteItem";
import { getProximaSequencia, getCotacaoUSD, createPi, getPi } from "../api/pis";
import { getLatestConfig } from "../api/configuracoes";
import { listModulosTecidos, getModuleFilters } from "../api/modulos";
import { listClientes } from "../api/clientes";
import { ModuloTecidoSelect } from "../components/ModuloTecidoSelect";
import { SearchableSelect } from "../components/SearchableSelect";
import { PiSearchModal } from "../components/PiSearchModal";
import type { Frete, ModuloTecido, Configuracao, Fornecedor, Categoria, Marca, Tecido } from "../api/types";

type FormState = {
  id?: number;
  prefixo: string;
  piSequencia: string;
  dataPi: string;
  idCliente: string;
  idFrete: number;
  cotacaoAtualUSD: number;
  cotacaoRisco: number;
  valorTotalFreteBRL: number;
  valorTotalFreteUSD: number;
};

type ItemGrid = {
  tempId: number;
  idModuloTecido: number;
  moduloTecido?: ModuloTecido;
  quantidade: number;
  largura: number;
  profundidade: number;
  altura: number;
  pa: number;
  m3: number;
  valorEXW: number;
  valorFreteRateadoBRL: number;
  valorFreteRateadoUSD: number;
  valorFinalItemBRL: number;
  valorFinalItemUSDRisco: number;
  exwTooltip?: string;
  freteBrlTooltip?: string;
  freteUsdTooltip?: string;
};

export default function ProformaInvoicePage() {
  const [form, setForm] = useState<FormState>({
    id: undefined,
    prefixo: "SW",
    piSequencia: "00001",
    dataPi: new Date().toISOString().split('T')[0],
    idCliente: "",
    idFrete: 1,
    cotacaoAtualUSD: 0,
    cotacaoRisco: 0,
    valorTotalFreteBRL: 0,
    valorTotalFreteUSD: 0,
  });

  const [fretes, setFretes] = useState<Frete[]>([]);
  const [clientes, setClientes] = useState<any[]>([]);
  const [modulosTecidos, setModulosTecidos] = useState<ModuloTecido[]>([]);
  const [config, setConfig] = useState<Configuracao | null>(null);
  const [itens, setItens] = useState<ItemGrid[]>([]);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);

  // Filters State
  const [filterFornecedor, setFilterFornecedor] = useState("");
  const [filterCategoria, setFilterCategoria] = useState("");
  const [filterMarca, setFilterMarca] = useState("");
  const [filterTecido, setFilterTecido] = useState("");

  const [fornecedores, setFornecedores] = useState<Fornecedor[]>([]);
  const [categorias, setCategorias] = useState<Categoria[]>([]);
  const [marcas, setMarcas] = useState<Marca[]>([]);
  const [tecidos, setTecidos] = useState<Tecido[]>([]);

  // Novo item
  const [selModuloTecido, setSelModuloTecido] = useState("");
  const [quantidade, setQuantidade] = useState("1");

  // Modal State
  const [showSearchModal, setShowSearchModal] = useState(false);

  // Help Modal State
  const [helpModalOpen, setHelpModalOpen] = useState(false);
  const [helpTitle, setHelpTitle] = useState("");
  const [helpContent, setHelpContent] = useState("");

  function openHelp(title: string, content?: string) {
    if (!content) return;
    setHelpTitle(title);
    setHelpContent(content);
    setHelpModalOpen(true);
  }

  useEffect(() => {
    loadInitialData();
  }, []);

  useEffect(() => {
    loadFilters();
  }, [filterFornecedor, filterCategoria, filterMarca, filterTecido]);

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

  useEffect(() => {
    if (form.idFrete) {
      loadFreteTotals();
    }
  }, [form.idFrete, form.cotacaoRisco]);

  useEffect(() => {
    // Recalcular rateio quando itens mudarem ou totais de frete mudarem
    recalcularRateio();
  }, [itens.length, form.valorTotalFreteBRL, form.valorTotalFreteUSD]); 

  // Filter ModulosTecidos in memory
  const filteredModulosTecidos = useMemo(() => {
      let list = modulosTecidos;
      
      if (filterFornecedor) {
          const id = Number(filterFornecedor);
          list = list.filter(mt => (mt as any).modulo?.fornecedor?.id === id);
      }
      if (filterCategoria) {
          const id = Number(filterCategoria);
          list = list.filter(mt => (mt as any).modulo?.categoria?.id === id);
      }
      if (filterMarca) {
          const id = Number(filterMarca);
          list = list.filter(mt => (mt as any).modulo?.marca?.id === id);
      }
      if (filterTecido) {
          // Here we filter by the Tecido linked to the ModuloTecido
          const id = Number(filterTecido);
          list = list.filter(mt => mt.idTecido === id);
      }
      return list;
  }, [modulosTecidos, filterFornecedor, filterCategoria, filterMarca, filterTecido]); 

  async function loadInitialData() {
    try {
      setLoading(true);
      
      const [
        fretesData,
        clientesData,
        modulosTecidosData,
        configData,
        sequencia,
        cotacao
      ] = await Promise.all([
        listFretes(),
        listClientes({ pageSize: 1000 }),
        listModulosTecidos(),
        getLatestConfig().catch(() => null),
        getProximaSequencia(),
        getCotacaoUSD()
      ]);

      setFretes(fretesData);
      setClientes(clientesData.items || []);
      setModulosTecidos(modulosTecidosData);
      setConfig(configData);

      const cotacaoRisco = cotacao - (configData?.valorReducaoDolar || 0);

      setForm(prev => ({
        ...prev,
        piSequencia: sequencia,
        cotacaoAtualUSD: cotacao,
        cotacaoRisco: cotacaoRisco,
      }));
      
    } catch (e: any) {
      console.error("Erro detalhado:", e);
      alert("Erro ao carregar dados: " + getErrorMessage(e));
    } finally {
      setLoading(false);
    }
  }

  async function loadFreteTotals() {
    try {
      const total = await getTotalFrete(form.idFrete);
      const totalUSD = form.cotacaoRisco > 0 ? total / form.cotacaoRisco : 0;

      setForm(prev => ({
        ...prev,
        valorTotalFreteBRL: total,
        valorTotalFreteUSD: totalUSD,
      }));
    } catch (e) {
      console.error("Erro ao carregar totais de frete:", e);
    }
  }

  function recalcularRateio() {
    if (itens.length === 0) return;

    const totalM3 = itens.reduce((sum, item) => sum + (item.m3 * item.quantidade), 0);
    
    const novosItens = itens.map(item => {
       const custoPorM3BRL = totalM3 > 0 ? (form.valorTotalFreteBRL || 0) / totalM3 : 0;
       const custoPorM3USD = totalM3 > 0 ? (form.valorTotalFreteUSD || 0) / totalM3 : 0;

       const freteUnitarioBRL = custoPorM3BRL * item.m3;
       const freteUnitarioUSD = custoPorM3USD * item.m3;
      
      const valorFinalBRL = (item.valorEXW + freteUnitarioBRL) * item.quantidade;
      const valorFinalUSD = (item.valorEXW + freteUnitarioUSD) * item.quantidade;

      const freteBrlTooltip = 
        `Total Frete R$ ${fmt(form.valorTotalFreteBRL)} / Total M³ ${fmt(totalM3)} = R$ ${fmt(custoPorM3BRL)}/m³\n` +
        `x Item M³ ${fmt(item.m3)} = R$ ${fmt(freteUnitarioBRL)}`;
      
      const freteUsdTooltip = 
        `Total Frete $ ${fmt(form.valorTotalFreteUSD)} / Total M³ ${fmt(totalM3)} = $ ${fmt(custoPorM3USD)}/m³\n` +
        `x Item M³ ${fmt(item.m3)} = $ ${fmt(freteUnitarioUSD)}`;

      return {
        ...item,
        valorFreteRateadoBRL: freteUnitarioBRL,
        valorFreteRateadoUSD: freteUnitarioUSD,
        valorFinalItemBRL: valorFinalBRL,
        valorFinalItemUSDRisco: valorFinalUSD,
        freteBrlTooltip,
        freteUsdTooltip
      };
    });

    if (JSON.stringify(novosItens) !== JSON.stringify(itens)) {
        setItens(novosItens);
    }
  }

  function adicionarItem() {
    if (!selModuloTecido) {
      alert("Selecione um módulo-tecido");
      return;
    }

    const moduloTecido = modulosTecidos.find(mt => mt.id === Number(selModuloTecido));
    if (!moduloTecido) return;

    const qtd = parseFloat(quantidade.replace(",", ".")) || 1;

    const modulo = (moduloTecido as any).modulo;
    const largura = modulo?.largura || 0;
    const profundidade = modulo?.profundidade || 0;
    const altura = modulo?.altura || 0;
    const pa = modulo?.pa || 0;
    const m3 = modulo?.m3 || (largura * profundidade * altura);

    const valorModuloTecido = moduloTecido.valorTecido;
    const comissao = config?.percentualComissao || 0;
    const gordura = config?.percentualGordura || 0;
    
    // Calculation
    const valorBase = form.cotacaoRisco > 0 ? valorModuloTecido / form.cotacaoRisco : 0;
    const vComissao = valorBase * (comissao / 100);
    const vGordura = valorBase * (gordura / 100);
    const valorEXW = valorBase + vComissao + vGordura;

    const exwTooltip = 
      `Base (R$ ${fmt(valorModuloTecido)} / ${fmt(form.cotacaoRisco)}) = $ ${fmt(valorBase)}\n` +
      `+ Comissão (${fmt(comissao)}%) = $ ${fmt(vComissao)}\n` +
      `+ Gordura (${fmt(gordura)}%) = $ ${fmt(vGordura)}\n` +
      `= $ ${fmt(valorEXW)}`;

    const novoItem: ItemGrid = {
      tempId: Date.now(),
      idModuloTecido: moduloTecido.id,
      moduloTecido,
      quantidade: qtd,
      largura,
      profundidade,
      altura,
      pa,
      m3,
      valorEXW,
      valorFreteRateadoBRL: 0,
      valorFreteRateadoUSD: 0,
      valorFinalItemBRL: 0,
      valorFinalItemUSDRisco: 0,
      exwTooltip,
      freteBrlTooltip: "",
      freteUsdTooltip: "",
    };

    setItens(prev => [...prev, novoItem]);
    setSelModuloTecido("");
    setQuantidade("1");
  }

  function removerItem(tempId: number) {
    setItens(prev => prev.filter(i => i.tempId !== tempId));
  }

  const atualizarQuantidade = (tempId: number, novaQtd: string) => {
      const qtd = parseFloat(novaQtd.replace(",", ".")) || 0;
      setItens(prev => prev.map(item => {
          if (item.tempId === tempId) {
             return { ...item, quantidade: qtd };
          }
          return item;
      }));
  };

  async function salvar() {
    try {
      if (!form.idCliente) {
        alert("Selecione um cliente");
        return;
      }

      if (itens.length === 0) {
        alert("Adicione pelo menos um item");
        return;
      }

      setSaving(true);

      const valorTecido = itens.reduce((sum, item) => sum + (item.valorEXW * item.quantidade), 0);

      const piData = {
        prefixo: form.prefixo,
        piSequencia: form.piSequencia,
        dataPi: new Date(form.dataPi).toISOString(),
        idCliente: form.idCliente,
        idConfiguracoes: config?.id || 0,
        idFrete: form.idFrete,
        valorTecido,
        valorTotalFreteBRL: form.valorTotalFreteBRL,
        valorTotalFreteUSD: form.valorTotalFreteUSD,
        cotacaoAtualUSD: form.cotacaoAtualUSD,
        cotacaoRisco: form.cotacaoRisco,
        piItens: itens.map(item => ({
          idModuloTecido: item.idModuloTecido,
          quantidade: item.quantidade,
          largura: item.largura,
          profundidade: item.profundidade,
          altura: item.altura,
          pa: item.pa,
          m3: item.m3,
          valorEXW: item.valorEXW,
          valorFreteRateadoBRL: item.valorFreteRateadoBRL,
          valorFreteRateadoUSD: item.valorFreteRateadoUSD,
          valorFinalItemBRL: item.valorFinalItemBRL,
          valorFinalItemUSDRisco: item.valorFinalItemUSDRisco,
          rateioFrete: 0 
        })) as any[]
      };

      const piCriada = await createPi(piData);
      
      alert(`PI ${piCriada.piSequencia} salva com sucesso!`);
      
      setForm(prev => ({ ...prev, id: piCriada.id }));
    } catch (e: any) {
      alert("Erro ao salvar PI: " + getErrorMessage(e));
    } finally {
      setSaving(false);
    }
  }

  const handleSelectPi = async (piSelection: any) => {
    try {
        setLoading(true);
        // Fetch full PI details to ensure we have items
        const pi = await getPi(piSelection.id);

        setForm({
            id: pi.id,
            prefixo: pi.prefixo,
            piSequencia: pi.piSequencia,
            dataPi: pi.dataPi.split('T')[0],
            idCliente: String(pi.idCliente),
            idFrete: pi.idFrete,
            cotacaoAtualUSD: pi.cotacaoAtualUSD,
            cotacaoRisco: pi.cotacaoRisco,
            valorTotalFreteBRL: pi.valorTotalFreteBRL,
            valorTotalFreteUSD: pi.valorTotalFreteUSD
        });

        const itensApi = pi.piItens || (pi as any).PiItens;

        if (itensApi && Array.isArray(itensApi)) {
           const novosItens: ItemGrid[] = itensApi.map((item: any) => {

               const mt = modulosTecidos.find(m => m.id === item.idModuloTecido || m.id === item.IdModuloTecido);
               
               const largura = item.largura || item.Largura || (mt as any)?.modulo?.largura || 0;
               const profundidade = item.profundidade || item.Profundidade || (mt as any)?.modulo?.profundidade || 0;
               const altura = item.altura || item.Altura || (mt as any)?.modulo?.altura || 0;
               const pa = item.pa || item.Pa || (mt as any)?.modulo?.pa || 0;
               const m3 = item.m3 || item.M3 || (mt as any)?.modulo?.m3 || (largura * profundidade * altura);

               return {
                   tempId: Date.now() + Math.random(),
                   idModuloTecido: item.idModuloTecido || item.IdModuloTecido,
                   moduloTecido: mt,
                   quantidade: item.quantidade || item.Quantidade,
                   largura,
                   profundidade,
                   altura,
                   pa,
                   m3,
                   valorEXW: item.valorEXW || item.ValorEXW,
                   valorFreteRateadoBRL: item.valorFreteRateadoBRL || item.ValorFreteRateadoBRL,
                   valorFreteRateadoUSD: item.valorFreteRateadoUSD || item.ValorFreteRateadoUSD,
                   valorFinalItemBRL: item.valorFinalItemBRL || item.ValorFinalItemBRL,
                   valorFinalItemUSDRisco: item.valorFinalItemUSDRisco || item.ValorFinalItemUSDRisco,
                   exwTooltip: "Cálculo importado",
                   freteBrlTooltip: "Cálculo importado",
                   freteUsdTooltip: "Cálculo importado"
               };
           });
           setItens(novosItens);
        } else {
             setItens([]);
        }
    } catch (error) {
        alert("Erro ao carregar detalhes da PI.");
        console.error(error);
    } finally {
        setLoading(false);
        setShowSearchModal(false);
    }
  };
  
  const getItemDescription = (item: ItemGrid) => {
    if (item.moduloTecido) {
        const mt = item.moduloTecido;
        const forn = mt.modulo?.fornecedor?.nome || "?";
        const cat = mt.modulo?.categoria?.nome || "?";
        const mod = mt.modulo?.descricao || "?";
        return `${forn.substring(0,10)} > ${cat.substring(0,10)}... > ${mod.substring(0,15)}...`;
    }
    return `Módulo #${item.idModuloTecido}`;
  };

  const getItemDescriptionFull = (item: ItemGrid) => {
    if (item.moduloTecido) {
        const mt = item.moduloTecido;
        const forn = mt.modulo?.fornecedor?.nome || "?";
        const cat = mt.modulo?.categoria?.nome || "?";
        const marc = mt.modulo?.marca?.nome || "?";
        const mod = mt.modulo?.descricao || "?";
        const tec = mt.tecido?.nome || "?";
        return `${forn} > ${cat} > ${marc} > ${mod} > ${tec}`;
    }
    return `Módulo #${item.idModuloTecido}`;
  };

  const totalGeralBRL = useMemo(() => {
    return itens.reduce((sum, item) => sum + item.valorFinalItemBRL, 0);
  }, [itens]);

  const totalGeralUSD = useMemo(() => {
    return itens.reduce((sum, item) => sum + item.valorFinalItemUSDRisco, 0);
  }, [itens]);

  if (loading) return <div style={{ padding: 16 }}>Carregando...</div>;

  return (
    <div style={{ padding: 16, maxWidth: "100%", overflowX: "hidden" }}>
      
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <h1>Proforma Invoice</h1>
        <div style={{ display: "flex", gap: 10 }}>
            {form.id && (
                <button
                    className="btn btn-secondary"
                    onClick={() => window.open(`/print-pi/${form.id}`, "_blank")}
                    style={{ height: 40, background: "#10b981", borderColor: "#10b981", color: "white" }}
                >
                    🖨️ Imprimir
                </button>
            )}
            <button 
                className="btn btn-secondary" 
                onClick={() => setShowSearchModal(true)}
                style={{ height: 40 }}
            >
                🔍 Consultar PI
            </button>
        </div>
      </div>

      {showSearchModal && (
        <PiSearchModal 
            onClose={() => setShowSearchModal(false)}
            onSelect={handleSelectPi}
        />
      )}

      {helpModalOpen && (
        <div className="modalOverlay" onMouseDown={() => setHelpModalOpen(false)}>
          <div className="modalCard" style={{ width: 400, height: 'auto', maxHeight: '80vh' }} onMouseDown={(e) => e.stopPropagation()}>
            <div className="modalHeader">
              <h3 className="modalTitle">{helpTitle}</h3>
              <button className="btn btn-sm" onClick={() => setHelpModalOpen(false)}>Fechar</button>
            </div>
            <div className="modalBody" style={{ whiteSpace: 'pre-line', lineHeight: 1.5 }}>
              {helpContent}
            </div>
          </div>
        </div>
      )}

      <div className="cl-card" style={{ marginBottom: 20, padding: 16 }}>
        <h3 style={{ marginTop: 0 }}>Dados da PI</h3>
        <div className="formGrid">
          <div className="field">
            <label className="label">Prefixo</label>
            <input
              className="cl-input"
              value={form.prefixo}
              onChange={(e) => setForm({ ...form, prefixo: e.target.value })}
            />
          </div>
          <div className="field">
            <label className="label">Sequência</label>
            <input
              className="cl-input"
              value={form.piSequencia}
              readOnly
              style={{ background: "#1a1a2e" }}
            />
          </div>
          <div className="field">
            <label className="label">Data PI</label>
            <input
              className="cl-input"
              type="date"
              value={form.dataPi}
              onChange={(e) => setForm({ ...form, dataPi: e.target.value })}
            />
          </div>
          <div className="field">
            <label className="label">Cliente*</label>
            <SearchableSelect
              value={form.idCliente}
              onChange={(val) => setForm({ ...form, idCliente: String(val) })}
              options={clientes.map((c) => ({ value: c.id, label: c.nome }))}
              placeholder="Selecione..."
            />
          </div>
          <div className="field">
            <label className="label">Frete*</label>
            <SearchableSelect
              value={form.idFrete}
              onChange={(val) => setForm({ ...form, idFrete: Number(val) })}
              options={fretes.map((f) => ({ value: f.id, label: f.nome }))}
              placeholder="Selecione..."
            />
          </div>
          <div className="field">
            <label className="label">Cotação USD Atual</label>
            <input
              className="cl-input"
              value={fmt(form.cotacaoAtualUSD)}
              readOnly
              style={{ background: "#1a1a2e" }}
            />
          </div>
          <div className="field">
            <label className="label">Cotação Risco</label>
            <input
              className="cl-input"
              value={fmt(form.cotacaoRisco)}
              readOnly
              style={{ background: "#1a1a2e" }}
            />
          </div>
          <div className="field">
            <label className="label">Total Frete BRL</label>
            <input
              className="cl-input"
              value={fmt(form.valorTotalFreteBRL)}
              readOnly
              style={{ background: "#1a1a2e" }}
            />
          </div>
          <div className="field">
            <label className="label">Total Frete USD</label>
            <input
              className="cl-input"
              value={fmt(form.valorTotalFreteUSD)}
              readOnly
              style={{ background: "#1a1a2e" }}
            />
          </div>
        </div>
      </div>

      <div className="cl-card" style={{ marginBottom: 20, padding: 10, overflow: "visible" }}> 
        <h3 style={{ marginTop: 0 }}>Itens da PI</h3>
        
        <div style={{ display: "flex", gap: 10, marginBottom: 15, flexWrap: "wrap", alignItems: "flex-end" }}>
            <div style={{ width: 180 }}>
                <label className="label" style={{marginBottom: 4, display: 'block', fontSize: '0.8em'}}>Fornecedor</label>
                <SearchableSelect
                    value={filterFornecedor}
                    onChange={setFilterFornecedor}
                    placeholder="Todos"
                    options={[{ value: "", label: "Todos" }, ...fornecedores.map(f => ({ value: f.id, label: f.nome }))]}
                />
            </div>
            <div style={{ width: 180 }}>
                <label className="label" style={{marginBottom: 4, display: 'block', fontSize: '0.8em'}}>Categoria</label>
                <SearchableSelect
                    value={filterCategoria}
                    onChange={setFilterCategoria}
                    placeholder="Todas"
                    options={[{ value: "", label: "Todas" }, ...categorias.map(c => ({ value: c.id, label: c.nome }))]}
                />
            </div>
            <div style={{ width: 180 }}>
                <label className="label" style={{marginBottom: 4, display: 'block', fontSize: '0.8em'}}>Marca</label>
                <SearchableSelect
                    value={filterMarca}
                    onChange={setFilterMarca}
                    placeholder="Todas"
                    options={[{ value: "", label: "Todas" }, ...marcas.map(m => ({ value: m.id, label: m.nome }))]}
                />
            </div>
            <div style={{ width: 180 }}>
                <label className="label" style={{marginBottom: 4, display: 'block', fontSize: '0.8em'}}>Tecido</label>
                <SearchableSelect
                    value={filterTecido}
                    onChange={setFilterTecido}
                    placeholder="Todos"
                    options={[{ value: "", label: "Todos" }, ...tecidos.map(t => ({ value: t.id, label: t.nome }))]}
                />
            </div>
            <button 
                className="btn btn-secondary"
                onClick={() => {
                    setFilterFornecedor("");
                    setFilterCategoria("");
                    setFilterMarca("");
                    setFilterTecido("");
                }}
                style={{ height: 38 }}
                title="Limpar Filtros"
            >
                🧹
            </button>
        </div>

        <div style={{ display: "flex", gap: 8, marginBottom: 10, alignItems: "flex-end", flexWrap: "wrap" }}>
          <div className="field" style={{ flex: 1, minWidth: 300 }}>
            <label className="label">Módulo-Tecido</label>
            <ModuloTecidoSelect
              value={selModuloTecido}
              onChange={(val) => setSelModuloTecido(val)}
              options={filteredModulosTecidos}
              placeholder="Selecione um módulo..."
            />
          </div>
          <div className="field" style={{ width: 80 }}>
            <label className="label">Qtd</label>
            <input
              className="cl-input"
              value={quantidade}
              onChange={(e) => setQuantidade(e.target.value)}
            />
          </div>
          <button className="btn btn-primary" onClick={adicionarItem} style={{ marginBottom: 0 }}>
            Adicionar
          </button>
        </div>

        <div style={{ overflowX: "auto" }}>
          <table style={{ width: "100%", borderCollapse: "collapse", minWidth: 900, fontSize: "12px" }}>
            <thead>
              <tr style={{ background: "#f8f9fa", borderBottom: "2px solid #dee2e6" }}>
                <th style={{...th, width: "30px", textAlign: "center"}}>#</th>
                <th style={{...th, minWidth: "250px"}}>Descrição</th>
                <th style={{...th, width: "70px"}}>Qtd</th>
                <th style={{...th, width: "60px"}}>Larg</th>
                <th style={{...th, width: "60px"}}>Prof</th>
                <th style={{...th, width: "60px"}}>Alt</th>
                <th style={{...th, width: "50px"}}>PA</th>
                <th style={{...th, width: "70px"}}>m³</th>
                <th style={{...th, textAlign:"right", minWidth: "100px"}}>Valor EXW</th>
                <th style={{...th, textAlign:"right", minWidth: "100px"}}>Frete R$</th>
                <th style={{...th, textAlign:"right", minWidth: "100px"}}>Frete $</th>
                <th style={{...th, textAlign:"right", minWidth: "100px"}}>Total R$</th>
                <th style={{...th, textAlign:"right", minWidth: "100px"}}>Total $</th>
              </tr>
            </thead>
            <tbody>
              {itens.map((item) => (
                <tr key={item.tempId} style={{ borderBottom: "1px solid #eee" }}>
                  <td style={{...td, textAlign:"center"}}>
                    <button
                      className="btn btn-sm btn-danger"
                      onClick={() => removerItem(item.tempId)}
                      style={{ padding: "0", width: "24px", height: "24px", minHeight: "24px", borderRadius: "4px", display: "flex", alignItems: "center", justifyContent: "center", fontSize: "14px", lineHeight: 1 }}
                      title="Remover Item"
                    >
                      ×
                    </button>
                  </td>
                  <td style={td} title={getItemDescriptionFull(item)}>
                      {getItemDescription(item)}
                  </td>
                  <td style={td}>
                      <input 
                        type="number"
                        value={item.quantidade}
                        onChange={(e) => atualizarQuantidade(item.tempId, e.target.value)}
                        style={{ width: "60px", padding: "4px", border: "1px solid #ddd", borderRadius: "4px", background: "rgba(255,255,255,0.05)", color: "var(--text)" }}
                      />
                  </td>
                  <td style={td}>{fmt(item.largura)}</td>
                  <td style={td}>{fmt(item.profundidade)}</td>
                  <td style={td}>{fmt(item.altura)}</td>
                  <td style={td}>{fmt(item.pa)}</td>
                  <td style={td}>{fmt(item.m3, 3)}</td>
                  <td style={{...td, textAlign:"right"}} title={item.exwTooltip}>
                      <div style={{display: 'flex', alignItems: 'center', justifyContent: 'flex-end'}}>
                          R$ {fmt(item.valorEXW)}
                          <span className="mobile-help-icon" onClick={() => openHelp("Cálculo EXW", item.exwTooltip)}>?</span>
                      </div>
                  </td>
                  <td style={{...td, textAlign:"right"}} title={item.freteBrlTooltip}>
                      <div style={{display: 'flex', alignItems: 'center', justifyContent: 'flex-end'}}>
                          R$ {fmt(item.valorFreteRateadoBRL)}
                          <span className="mobile-help-icon" onClick={() => openHelp("Cálculo Frete R$", item.freteBrlTooltip)}>?</span>
                      </div>
                  </td>
                  <td style={{...td, textAlign:"right"}} title={item.freteUsdTooltip}>
                      <div style={{display: 'flex', alignItems: 'center', justifyContent: 'flex-end'}}>
                          $ {fmt(item.valorFreteRateadoUSD)}
                          <span className="mobile-help-icon" onClick={() => openHelp("Cálculo Frete USD", item.freteUsdTooltip)}>?</span>
                      </div>
                  </td>
                  <td style={{...td, textAlign:"right"}}>R$ {fmt(item.valorFinalItemBRL)}</td>
                  <td style={{...td, textAlign:"right"}}>$ {fmt(item.valorFinalItemUSDRisco)}</td>
                </tr>
              ))}
              {itens.length === 0 && (
                <tr>
                  <td colSpan={13} style={{ ...td, textAlign: "center", color: "#888", padding: 20 }}>
                    Nenhum item adicionado
                  </td>
                </tr>
              )}
              {itens.length > 0 && (
                <tr style={{ fontWeight: "bold", background: "rgba(37, 99, 235, 0.1)" }}>
                  <td colSpan={11} style={{ ...td, textAlign: "right" }}>TOTAL:</td>
                  <td style={td}>R$ {fmt(totalGeralBRL)}</td>
                  <td style={td}>$ {fmt(totalGeralUSD)}</td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>

      <div style={{ display: "flex", gap: 12, justifyContent: "flex-end" }}>
        <button className="btn btn-primary" onClick={salvar} disabled={saving}>
          {saving ? "Salvando..." : "Salvar PI"}
        </button>
      </div>
    </div>
  );
}

const th: React.CSSProperties = {
  textAlign: "left",
  borderBottom: "1px solid #ddd",
  padding: "12px 8px",
  fontSize: 13,
  fontWeight: 600,
  color: "var(--muted)",
  whiteSpace: "nowrap",
};

const td: React.CSSProperties = {
  borderBottom: "1px solid #eee",
  padding: "8px 8px",
  fontSize: 14,
  whiteSpace: "nowrap",
  verticalAlign: "middle",
};

function fmt(n: number | undefined, decimals = 2) {
  return (n ?? 0).toLocaleString("pt-BR", {
    minimumFractionDigits: decimals,
    maximumFractionDigits: decimals,
  });
}

function getErrorMessage(e: unknown): string {
  if (e instanceof Error) return e.message;
  if (typeof e === "object" && e && (e as any).message) return (e as any).message;
  return "Erro desconhecido";
}
