
import React, { useEffect, useState, useMemo, useCallback } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { 
  listFretes
} from "../api/fretes";
import { 
  getProximaSequencia, 
  getCotacaoUSD, 
  createPi, 
  updatePi, 
  getPi,
  exportPiExcel 
} from "../api/pis";
import { getTotalFrete } from "../api/configuracoesFreteItem";
import { calculateCotacaoRisco, calculateEXW, calculateFreteRateio } from "../utils/calculations";
import { getLatestConfig } from "../api/configuracoes";
import { listModulosTecidos } from "../api/modulos";
import { listClientes } from "../api/clientes";
import { listFornecedores } from "../api/fornecedores";
import { listModelos } from "../api/modelos";
import { listMarcas } from "../api/marcas";
import { listCategorias } from "../api/categorias";
import { listTecidos } from "../api/tecidos";
import type { ModuloTecido, Configuracao, ProformaInvoice, PiItemPeca, Fornecedor, Frete, Modelo, Cliente, Marca, Categoria, Tecido } from "../api/types";
import { SearchableSelect } from "../components/SearchableSelect";
import { PiSearchModal } from "../components/PiSearchModal";
import { ModuloTecidoSelect } from "../components/ModuloTecidoSelect";
import { PiCurrencyModal } from "../components/PiCurrencyModal";
import { Save, Plus, Trash2, Search, FileText, Printer, FileSpreadsheet } from "lucide-react";
import PageHeader from "../components/PageHeader";
import "./ClientesPage.css"; // Reuse existing system classes

type FormState = {
  id?: number;
  prefixo: string;
  piSequencia: string;
  dataPi: string;
  idCliente: string;
  idFornecedor: string;
  idConfiguracoes: number;
  idFrete: number;
  cotacaoAtualUSD: number;
  cotacaoRisco: number | string;
  valorTotalFreteBRL: number;
  valorTotalFreteUSD: number;
  tempoEntrega?: string;
  condicaoPagamento?: string;
  idioma?: string;
  tipoRateio: string;
};

type ItemGrid = {
  id?: number;
  tempId: number;
  idModuloTecido: number;
  moduloTecido?: ModuloTecido;
  quantidade: number;
  quantidadePeca: number;
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
  idPiItemPeca?: number;
  codigoModuloTecido?: string;
  observacao?: string;
  feet?: string;
  finishing?: string;
};

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
    idConfiguracoes: 0,
    idFrete: 1,
    cotacaoAtualUSD: 0,
    cotacaoRisco: 0,
    valorTotalFreteBRL: 0,
    valorTotalFreteUSD: 0,
    tipoRateio: "IGUAL"
  });

  const [itens, setItens] = useState<ItemGrid[]>([]);
  const [saving, setSaving] = useState(false);
  const [clientes, setClientes] = useState<Cliente[]>([]);
  const [fornecedores, setFornecedores] = useState<Fornecedor[]>([]);
  const [fretes, setFretes] = useState<Frete[]>([]);
  const [modelos, setModelos] = useState<Modelo[]>([]);
  const [marcas, setMarcas] = useState<Marca[]>([]);
  const [modulosTecidos, setModulosTecidos] = useState<ModuloTecido[]>([]);
  const [categorias, setCategorias] = useState<Categoria[]>([]);
  const [tecidos, setTecidos] = useState<Tecido[]>([]);
  const [config, setConfig] = useState<Configuracao | null>(null);
  const [loading, setLoading] = useState(true);
  const [showSearchModal, setShowSearchModal] = useState(false);
  const [showItemModal, setShowItemModal] = useState(false);
  const [currencyModalOpen, setCurrencyModalOpen] = useState(false);
  const [currencyModalType, setCurrencyModalType] = useState<"print" | "excel">("print");

  const isFerguile = useMemo(() => {
    const s = fornecedores.find(f => String(f.id) === form.idFornecedor);
    const name = (s?.nome || "").toLowerCase();
    return name.includes("ferguile") || name.includes("livintus");
  }, [fornecedores, form.idFornecedor]);

  const totalM3Pi = useMemo(() => itens.reduce((sum, i) => sum + (i.m3 * i.quantidade), 0), [itens]);

  const getCalculationHint = useCallback((type: string, item?: ItemGrid, group?: any) => {
    const cot = Number(form.cotacaoAtualUSD);
    const red = config?.valorReducaoDolar || 0;
    const risk = Number(form.cotacaoRisco) || 1;
    const com = config?.percentualComissao || 0;
    const gor = config?.percentualGordura || 0;

    switch (type) {
      case "cotacaoRisco":
        if (isFerguile) return `Cálculo: Fixo Configuração = ${red.toFixed(2)}`;
        return `Cálculo: Atual (${cot.toFixed(2)}) - Redução (${red.toFixed(2)}) = ${(cot - red).toFixed(2)}`;
      
      case "freteTotalUSD":
        return `Cálculo: Total R$ (${form.valorTotalFreteBRL.toFixed(2)}) / Risco (${risk.toFixed(2)}) = ${(form.valorTotalFreteBRL / risk).toFixed(2)}`;

      case "m3Total":
        if (!item) return "";
        return `Cálculo: (L:${item.largura} * P:${item.profundidade} * A:${item.altura}) * Qtd:${item.quantidade} / 1.000.000 = ${(item.m3 * item.quantidade).toFixed(3)} m³`;

      case "exwUnit": {
        if (!item) return "";
        const mt = modulosTecidos.find(m => m.id === item.idModuloTecido);
        const vTecido = mt?.valorTecido || 0;
        
        const valorBase = risk > 0 ? vTecido / risk : 0;
        const vCom = valorBase * (com / 100);
        const vGor = valorBase * (gor / 100);
        
        const uEXW = item.ValorEXW;
        const rowFrete = item.ValorFreteRateadoUSD * item.quantidade;
        
        return `Cálculo Unit EXW:
(V. Tecido: ${vTecido.toFixed(2)} / Risco: ${risk.toFixed(2)}) = $ ${valorBase.toFixed(2)}
+ Comiss: ${com}% ($ ${vCom.toFixed(2)})
+ Gord: ${gor}% ($ ${vGor.toFixed(2)})
= Base EXW: $ ${uEXW.toFixed(2)}

Acréscimo Frete Linha:
$ ${uEXW.toFixed(2)} + $ ${rowFrete.toFixed(2)} (Frete) = $ ${(uEXW + rowFrete).toFixed(2)}`;
      }

      case "freteUnit": {
        if (!item) return "";
        const uFrete = item.ValorFreteRateadoUSD;
        const rowShare = uFrete * item.quantidade;
        if (form.tipoRateio === "IGUAL") {
          return `Cálculo Frete (POR IGUAL):
Total Frete $ ${form.valorTotalFreteUSD.toFixed(2)} / ${itens.length} linhas = $ ${rowShare.toFixed(2)} por linha.
Unitário: $ ${rowShare.toFixed(2)} / Qtd: ${item.quantidade} = $ ${uFrete.toFixed(2)} por módulo.`;
        }
        return `Cálculo Frete (POR VOLUME):
(Frete Total $ ${form.valorTotalFreteUSD.toFixed(2)} / M³ Total ${totalM3Pi.toFixed(3)}) = $ ${(form.valorTotalFreteUSD / totalM3Pi).toFixed(2)} por m³
* M³ Item: ${item.m3.toFixed(3)} = Unit Frete: $ ${uFrete.toFixed(2)}`;
      }

      case "usdUnit": {
        if (!item) return "";
        const uEXW = item.ValorEXW;
        const uFrete = item.ValorFreteRateadoUSD;
        return `Cálculo USD Unit (Com Frete):
Unit EXW: $ ${uEXW.toFixed(2)} + Unit Frete: $ ${uFrete.toFixed(2)} = $ ${(uEXW + uFrete).toFixed(2)}`;
      }

      case "totalUsd": {
        if (!item) return "";
        const unit = isFerguile ? (item.ValorEXW + item.ValorFreteRateadoUSD) : (group?.totalUsdUnit || 0);
        const qty = isFerguile ? item.quantidade : (item.quantidadePeca || 0);
        
        return `Cálculo TOTAL USD (KARAMS/KOYO):
USD Unit ($ ${unit.toFixed(2)}) * Qtd Peça (${qty}) = Total: $ ${(unit * qty).toFixed(2)}`;
      }

      case "unitFinal": {
        if (!item) return "";
        const uEXW = item.ValorEXW;
        const rowFrete = item.ValorFreteRateadoUSD * item.quantidade;
        const subTotalEXW = uEXW * item.quantidade;
        
        return `Cálculo UNIT FINAL:
(Unit EXW: $ ${uEXW.toFixed(2)} * Qtd: ${item.quantidade}) = $ ${subTotalEXW.toFixed(2)}
+ Frete Linha: $ ${rowFrete.toFixed(2)}
= Total Linha (UNIT FINAL): $ ${(subTotalEXW + rowFrete).toFixed(2)}`;
      }

      default: return "";
    }
  }, [form.cotacaoAtualUSD, form.cotacaoRisco, form.valorTotalFreteBRL, form.valorTotalFreteUSD, config, isFerguile, modulosTecidos, totalM3Pi]);

  const translate = useCallback((key: string) => {
    const lang = form.idioma || "PT";
    const dicts: Record<string, Record<string, string>> = {
      PT: {
        FOTO: "FOTO", MARCA: "MARCA", DESC: "MÓDULO / DESCRIÇÃO", LARG: "LARG.", PROF: "PROF.", ALT: "ALT.", PA: "P.A.", QTD: "QTD", QTD_PECA: "QTD PEÇA", M3: "M³ TOTAL", 
        TECIDO: "TECIDO", TELA: "TELA N", OBS: "OBS...", PES: "PÉS", ACAB: "ACABAMENTO", EXW: "EXW UNIT", FRETE: "FRETE UNIT", UNIT: "USD UNIT", TOTAL: "TOTAL USD",
        IDIOMA: "Idioma", COND_PAG: "Condição de Pagamento"
      },
      ES: {
        FOTO: "FOTO", MARCA: "MARCA", DESC: "MODULO / DESCRIPCIÓN", LARG: "LARG.", PROF: "PROF.", ALT: "ALT.", PA: "P.A.", QTD: "CANT", QTD_PECA: "CANT PZA", M3: "M³ TOTAL", 
        TECIDO: "TELA", TELA: "TELA N", OBS: "OBS...", PES: "PIES", ACAB: "ACABADO", EXW: "EXW UNIT", FRETE: "FLETE UNIT", UNIT: "UNIT USD", TOTAL: "TOTAL USD",
        IDIOMA: "Idioma", COND_PAG: "Condición de Pago"
      },
      EN: {
        FOTO: "PHOTO", MARCA: "BRAND", DESC: "MODULE / DESCRIPTION", LARG: "WIDTH", PROF: "DEPTH", ALT: "HEIGHT", PA: "P.A.", QTD: "QTY", QTD_PECA: "PIECE QTY", M3: "TOTAL M³", 
        TECIDO: "FABRIC", TELA: "FABRIC N", OBS: "OBS...", PES: "FEET", ACAB: "FINISHING", EXW: "EXW UNIT", FRETE: "FREIGHT UNIT", UNIT: "UNIT USD", TOTAL: "TOTAL USD",
        IDIOMA: "Language", COND_PAG: "Payment Condition"
      }
    };
    return dicts[lang]?.[key] || key;
  }, [form.idioma]);

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
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [id]);

  async function loadInitialData() {
    try {
      setLoading(true);
      (window as any)._isInitialLoad = true;
      const [ fList, cData, mtData, cfgData, seq, cot, fData, piData, modData, marcasData, catData, tecData ] = await Promise.all([
        listFretes(),
        listClientes({ pageSize: 1000 }),
        listModulosTecidos(),
        getLatestConfig().catch(() => null),
        getProximaSequencia(),
        getCotacaoUSD(),
        listFornecedores(),
        id ? getPi(Number(id)).catch(() => null) : Promise.resolve(null),
        listModelos().catch(() => []),
        listMarcas().catch(() => []),
        listCategorias().catch(() => []),
        listTecidos().catch(() => [])
      ]);

      setFretes(fList);
      setClientes(cData.items || []);
      setModulosTecidos(mtData || []);
      setConfig(cfgData);
      setFornecedores(fData);
      setModelos(modData);
      setMarcas(marcasData);
      setCategorias(catData || []);
      setTecidos(tecData || []);
      
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
          condicaoPagamento: piData.condicaoPagamento,
          idioma: piData.idioma,
          tipoRateio: piData.tipoRateio || "IGUAL",
          idConfiguracoes: piData.idConfiguracoes
        });

        const flatItens: ItemGrid[] = [];
        let counter = 1;

        if (piData.piItensPecas && piData.piItensPecas.length > 0) {
          piData.piItensPecas.forEach((peca: any) => {
            if (peca.piItens) {
              peca.piItens.forEach((item: any) => {
                flatItens.push({
                  id: item.id,
                  tempId: counter++,
                  idModuloTecido: item.idModuloTecido,
                  moduloTecido: item.moduloTecido,
                  quantidade: item.quantidade,
                  quantidadePeca: peca.quantidade,
                  largura: item.largura,
                  profundidade: item.profundidade,
                  altura: item.altura,
                  pa: item.pa,
                  m3: item.m3,
                  ValorEXW: item.valorEXW,
                  ValorFreteRateadoBRL: item.valorFreteRateadoBRL,
                  ValorFreteRateadoUSD: item.valorFreteRateadoUSD,
                  ValorFinalItemBRL: item.valorFinalItemBRL,
                  ValorFinalItemUSDRisco: item.valorFinalItemUSDRisco,
                  idPiItemPeca: peca.id,
                  codigoModuloTecido: item.moduloTecido?.codigoModuloTecido,
                  observacao: item.observacao,
                  feet: item.feet,
                  finishing: item.finishing,
                });
              });
            }
          });
        } else if (piData.piItens) {
          piData.piItens.forEach((i: any) => {
            flatItens.push({
              id: i.id,
              tempId: counter++,
              idModuloTecido: i.idModuloTecido,
              moduloTecido: i.moduloTecido,
              quantidade: i.quantidade,
              quantidadePeca: i.quantidadePeca || 1,
              largura: i.largura,
              profundidade: i.profundidade,
              altura: i.altura,
              pa: i.pa,
              m3: i.m3,
              ValorEXW: i.valorEXW,
              ValorFreteRateadoBRL: i.valorFreteRateadoBRL,
              ValorFreteRateadoUSD: i.valorFreteRateadoUSD,
              ValorFinalItemBRL: i.valorFinalItemBRL,
              ValorFinalItemUSDRisco: i.valorFinalItemUSDRisco,
              idPiItemPeca: i.idPiItemPeca,
              codigoModuloTecido: i.moduloTecido?.codigoModuloTecido,
              observacao: i.observacao,
              feet: i.feet,
              finishing: i.finishing,
            });
          });
        }
        setItens(flatItens);
      } else {
        setForm(prev => ({
          ...prev,
          piSequencia: seq,
          cotacaoAtualUSD: cot,
          cotacaoRisco: risk,
          idFrete: prev.idFrete || (fList.length > 0 ? fList[0].id : 1),
          idConfiguracoes: cfgData?.id || 0
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

    const idModelo = m.idModelo || (mt as any).idModelo;
    if (idModelo) {
      const dbModelo = modelos.find(md => md.id === idModelo);
      if (dbModelo?.urlImagem) rawImg = dbModelo.urlImagem;
    }

    if (!rawImg) {
      const idMarca = m.marca?.id || m.idMarca || (mt as any).idMarca;
      if (idMarca) {
        const dbMarca = marcas.find(ma => ma.id === Number(idMarca));
        if (dbMarca?.imagem) rawImg = dbMarca.imagem;
      }
    }
    
    if (!rawImg) rawImg = m.marca?.imagem || "";
    if (!rawImg) return null;

    if (rawImg.startsWith("data:") || rawImg.startsWith("http")) return rawImg;
    if (rawImg.length > 100) return `data:image/png;base64,${rawImg}`;
    
    const baseUrl = (import.meta.env.VITE_API_BASE ?? "http://localhost:5000").replace(/\/+$/, "");
    return `${baseUrl}${rawImg.startsWith("/") ? "" : "/"}${rawImg}`;
  };

  const recalcularRateio = useCallback(() => {
    setItens(prevItens => {
      if (prevItens.length === 0) return prevItens;
      const totalM3 = prevItens.reduce((sum, item) => sum + (item.m3 * item.quantidade), 0);
      
      const targetBRL = form.valorTotalFreteBRL;
      const targetUSD = form.valorTotalFreteUSD;
      
      let remainingBRL = targetBRL;
      let remainingUSD = targetUSD;

      const novosItens = prevItens.map((item, index) => {
        const isLast = index === prevItens.length - 1;
        
        let freteUnitBRL = 0;
        let freteUnitUSD = 0;

        if (isLast) {
          freteUnitBRL = item.quantidade > 0 ? remainingBRL / item.quantidade : 0;
          freteUnitUSD = item.quantidade > 0 ? remainingUSD / item.quantidade : 0;
        } else {
          freteUnitBRL = calculateFreteRateio(targetBRL, totalM3, item.m3, prevItens.length, item.quantidade, form.tipoRateio);
          freteUnitUSD = calculateFreteRateio(targetUSD, totalM3, item.m3, prevItens.length, item.quantidade, form.tipoRateio);
          
          remainingBRL -= (freteUnitBRL * item.quantidade);
          remainingUSD -= (freteUnitUSD * item.quantidade);
        }

        const valorBaseBRL = item.ValorEXW * (Number(form.cotacaoRisco) || 0);

        return {
          ...item,
          ValorFreteRateadoBRL: freteUnitBRL,
          ValorFreteRateadoUSD: freteUnitUSD,
          ValorFinalItemBRL: (valorBaseBRL + freteUnitBRL) * item.quantidade,
          ValorFinalItemUSDRisco: (item.ValorEXW + freteUnitUSD) * item.quantidade,
        };
      });

      if (JSON.stringify(novosItens) === JSON.stringify(prevItens)) return prevItens;
      return novosItens;
    });
  }, [form.valorTotalFreteBRL, form.valorTotalFreteUSD, form.cotacaoRisco, form.tipoRateio]);

  const recalculateAllItems = (risk: number, freightUSD: number, freightBRL: number, currentConfig: Configuracao | null) => {
    setItens(prev => {
      const totalM3 = prev.reduce((sum, i) => sum + (i.m3 * i.quantidade), 0);
      
      let remainingBRL = freightBRL;
      let remainingUSD = freightUSD;

      return prev.map((item, index) => {
        const isLast = index === prev.length - 1;
        const mt = modulosTecidos.find(m => m.id === item.idModuloTecido);
        if (!mt) return item;

        const newEXW = calculateEXW(mt.valorTecido, risk, currentConfig?.percentualComissao || 0, currentConfig?.percentualGordura || 0);
        
        let fUnitBRL = 0;
        let fUnitUSD = 0;

        if (isLast) {
          fUnitBRL = item.quantidade > 0 ? remainingBRL / item.quantidade : 0;
          fUnitUSD = item.quantidade > 0 ? remainingUSD / item.quantidade : 0;
        } else {
          fUnitBRL = calculateFreteRateio(freightBRL, totalM3, item.m3, prev.length, item.quantidade, form.tipoRateio);
          fUnitUSD = calculateFreteRateio(freightUSD, totalM3, item.m3, prev.length, item.quantidade, form.tipoRateio);
          remainingBRL -= (fUnitBRL * item.quantidade);
          remainingUSD -= (fUnitUSD * item.quantidade);
        }

        const vBaseBRL = newEXW * risk;

        return {
          ...item,
          ValorEXW: newEXW,
          ValorFreteRateadoBRL: fUnitBRL,
          ValorFreteRateadoUSD: fUnitUSD,
          ValorFinalItemBRL: (vBaseBRL + fUnitBRL) * item.quantidade,
          ValorFinalItemUSDRisco: (newEXW + fUnitUSD) * item.quantidade
        };
      });
    });
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

    // Dynamic Prefix for Ferguile
    if (idForn) {
      const supplier = fornecedores.find(f => f.id === idForn);
      if (supplier) {
        const name = supplier.nome.toLowerCase();
        if (name.includes("ferguile") || name.includes("livintus")) {
          const year = new Date(form.dataPi).getFullYear();
          const newPrefix = `FRG${year}-PO`;
          if (form.prefixo !== newPrefix) {
            setForm(prev => ({ ...prev, prefixo: newPrefix }));
          }
        } else if (form.prefixo.startsWith("FRG")) {
           // Reset prefix if switching away from Ferguile
           setForm(prev => ({ ...prev, prefixo: "SW" }));
        }
      }
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [form.idFornecedor, form.cotacaoAtualUSD, form.dataPi, fornecedores]);

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
    if (itens.length === 0 || !modulosTecidos) return { groups: [] };

    // 1. Sort the items
    const sorted = [...itens].sort((a, b) => {
       const mtA = (modulosTecidos || []).find(m => m.id === a.idModuloTecido);
       const mtB = (modulosTecidos || []).find(m => m.id === b.idModuloTecido);
       
       if (isFerguile) {
         // Sort by Brand (Referencia) -> Description -> Fabric
         const bA = mtA?.modulo?.marca?.nome || "";
         const bB = mtB?.modulo?.marca?.nome || "";
         if (bA !== bB) return bA.localeCompare(bB);
         
         const dA = mtA?.modulo?.descricao || "";
         const dB = mtB?.modulo?.descricao || "";
         if (dA !== dB) return dA.localeCompare(dB);
       }
       
       const fA = mtA?.tecido?.nome || "";
       const fB = mtB?.tecido?.nome || "";
       return fA.localeCompare(fB);
    });

    // 2. Group them
    const groups: any[] = [];
    let currentGroup: any = null;

    sorted.forEach(item => {
      const mt = (modulosTecidos || []).find(m => m.id === item.idModuloTecido);
      
      let groupKey = "";
      if (isFerguile) {
        groupKey = mt?.modulo?.marca?.nome || "Sem Marca";
      } else {
        groupKey = mt?.tecido?.nome || "Sem Tecido";
      }

      const rowFreightShare = item.ValorFreteRateadoUSD;
      // Piece unit price sum: (Unit EXW + Unit Freight)
      const moduleUnitCost = Number((item.ValorEXW + rowFreightShare).toFixed(2));
      // Row total (for the PI): moduleUnitCost * moduleQuantity
      const rowTotal = Number((moduleUnitCost * item.quantidade).toFixed(2));
      
      if (!currentGroup || (isFerguile ? currentGroup.brandName !== groupKey : currentGroup.fabricName !== groupKey)) {
        currentGroup = { 
          fabricName: groupKey, 
          brandName: isFerguile ? groupKey : (mt?.modulo?.marca?.nome || "Sem Marca"),
          groupName: groupKey,
          items: [], 
          span: 0, 
          totalUsdUnit: 0, 
          totalUsdGroup: 0 
        };
        groups.push(currentGroup);
      }
      currentGroup.items.push(item);
      currentGroup.span++;
      
      // UNIT FINAL logic: (EXW * Qty) + Total Frete for the row
      const rowUnitFinal = (item.ValorEXW * item.quantidade) + (item.ValorFreteRateadoUSD * item.quantidade);
      
      // USD Unit merged cell now brings the sum of UNIT FINAL from its pieces
      currentGroup.totalUsdUnit += rowUnitFinal; 
      
      // For now, keeping totalUsdGroup as the overall total
      currentGroup.totalUsdGroup += rowTotal;
    });

    // 3. If Ferguile, calculate sub-spans for Descriptions within each brand group
    if (isFerguile) {
      groups.forEach(group => {
        const descInfo: { [key: string]: number } = {};
        group.items.forEach((item: any) => {
          const mt = modulosTecidos.find(m => m.id === item.idModuloTecido);
          const desc = mt?.modulo?.descricao || "";
          descInfo[desc] = (descInfo[desc] || 0) + 1;
        });
        
        // Tag items with their spans
        let lastDesc = "";
        group.items.forEach((item: any) => {
          const mt = modulosTecidos.find(m => m.id === item.idModuloTecido);
          const desc = mt?.modulo?.descricao || "";
          if (desc !== lastDesc) {
            item._descSpan = descInfo[desc];
            lastDesc = desc;
          } else {
            item._descSpan = 0;
          }
        });
      });
    }

    return { groups };
  }, [itens, modulosTecidos, isFerguile]);

  const addItem = () => {
    setShowItemModal(true);
  };

  const novaPi = () => {
    if (id) {
      navigate("/proforma-invoice-v2");
    } else {
      setItens([]);
      loadInitialData();
    }
  };

  const abrirModalImpressao = () => {
    if (!form.id) {
      alert("Salve a PI antes de imprimir.");
      return;
    }
    setCurrencyModalType("print");
    setCurrencyModalOpen(true);
  };

  const abrirModalExcel = () => {
    if (!form.id) {
      alert("Salve a PI antes de exportar.");
      return;
    }
    setCurrencyModalType("excel");
    setCurrencyModalOpen(true);
  };

  const handleConfirmCurrency = (currency: string, validity: number) => {
    setCurrencyModalOpen(false);
    if (!form.id) return;

    if (currencyModalType === "print") {
      const url = isFerguile ? `/#/print-pi-ferguile/${form.id}?lang=${form.idioma || "PT"}&currency=${currency}&validity=${validity}` : `/#/print-pi/${form.id}?lang=${form.idioma || "PT"}&currency=${currency}&validity=${validity}`;
      window.open(url, "_blank");
    } else {
      (async () => {
        try {
          setLoading(true);
          const blob = await exportPiExcel(form.id!, currency, validity, form.idioma || "PT");
          const url = window.URL.createObjectURL(blob);
          const a = document.createElement("a");
          a.href = url;
          a.download = `PI_${form.prefixo}-${form.piSequencia}_${currency}.xlsx`;
          document.body.appendChild(a);
          a.click();
          window.URL.revokeObjectURL(url);
          document.body.removeChild(a);
        } catch (error) {
          console.error("Erro ao exportar Excel:", error);
          alert("Erro ao exportar Excel.");
        } finally {
          setLoading(false);
        }
      })();
    }
  };

  const adicionarItem = () => {
    if (!selModuloTecido || selModuloTecido === "0") {
      alert("Selecione um módulo");
      return;
    }

    const mt = modulosTecidos.find(m => m.id === Number(selModuloTecido));
    if (!mt) return;

    const risk = Number(form.cotacaoRisco) || 1;
    const exw = calculateEXW(
      mt.valorTecido, 
      risk, 
      config?.percentualComissao || 0, 
      config?.percentualGordura || 0
    );
    
    const newItem: ItemGrid = {
      tempId: Math.random(),
      idModuloTecido: mt.id,
      quantidade: Number(quantidade) || 1,
      quantidadePeca: Number(quantidade) || 1,
      largura: mt.modulo?.largura || 0,
      profundidade: mt.modulo?.profundidade || 0,
      altura: mt.modulo?.altura || 0,
      pa: 0,
      m3: ((mt.modulo?.largura || 0) * (mt.modulo?.profundidade || 0) * (mt.modulo?.altura || 0)) / 1000000,
      ValorEXW: exw,
      ValorFreteRateadoBRL: 0,
      ValorFreteRateadoUSD: 0,
      ValorFinalItemBRL: 0,
      ValorFinalItemUSDRisco: 0,
      codigoModuloTecido: codigoModuloTecido
    };

    setItens([...itens, newItem]);
    setShowItemModal(false);
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
            updated.m3 = (updated.largura * updated.profundidade * updated.altura) / 1000000;
            updated.ValorEXW = calculateEXW(
              mt.valorTecido, 
              Number(form.cotacaoRisco), 
              config?.percentualComissao || 0, 
              config?.percentualGordura || 0
            );
          }
        }
        return updated;
      }
      return it;
    }));
  };

  const updateGroupPecaQuantity = (groupItems: ItemGrid[], value: number) => {
    const tempIds = groupItems.map(it => it.tempId);
    setItens(prev => prev.map(it => {
      if (tempIds.includes(it.tempId)) {
        return { ...it, quantidadePeca: value, quantidade: value };
      }
      return it;
    }));
  };

  async function salvar() {
    try {
      if (!form.idCliente) { alert("Selecione um cliente"); return; }
      setSaving(true);
      
      const groupedItems = processedData.groups;
      const piItensPecas: PiItemPeca[] = groupedItems.map(g => ({
        id: g.items[0].idPiItemPeca || 0,
        idPi: Number(id) || 0,
        descricao: g.groupName,
        quantidade: g.items[0].quantidadePeca || 1,
        piItens: g.items.map((item: ItemGrid) => ({
          id: item.id || 0,
          idPi: Number(id) || 0,
          idModuloTecido: item.idModuloTecido,
          quantidade: item.quantidade,
          largura: item.largura,
          profundidade: item.profundidade,
          altura: item.altura,
          pa: item.pa,
          m3: item.m3,
          valorEXW: item.ValorEXW,
          valorFreteRateadoBRL: item.ValorFreteRateadoBRL,
          valorFreteRateadoUSD: item.ValorFreteRateadoUSD,
          valorFinalItemBRL: item.ValorFinalItemBRL,
          valorFinalItemUSDRisco: item.ValorFinalItemUSDRisco,
          tempCodigoModuloTecido: item.codigoModuloTecido,
          observacao: item.observacao,
          feet: item.feet,
          finishing: item.finishing || "",
          idPiItemPeca: item.idPiItemPeca,
          rateioFrete: 0,
        }))
      }));

      const payload: Partial<ProformaInvoice> = {
        ...form,
        id: Number(id) || 0,
        idFornecedor: form.idFornecedor ? Number(form.idFornecedor) : null,
        idConfiguracoes: Number(form.idConfiguracoes),
        idFrete: Number(form.idFrete),
        valorTecido: itens.reduce((sum, item) => sum + (item.ValorEXW * item.quantidade), 0),
        valorTotalFreteBRL: Number(form.valorTotalFreteBRL),
        valorTotalFreteUSD: Number(form.valorTotalFreteUSD),
        cotacaoAtualUSD: Number(form.cotacaoAtualUSD),
        cotacaoRisco: Number(form.cotacaoRisco),
        piItensPecas: piItensPecas,
        piItens: [],
      };

      if (form.id) {
        await updatePi(form.id, payload as ProformaInvoice);
      } else {
        const res = await createPi(payload as ProformaInvoice);
        setForm(prev => ({ ...prev, id: res.id, piSequencia: res.piSequencia }));
        navigate(`/pis/${res.id}`, { replace: true });
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
    <>
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
          <button className="btn btn-secondary" onClick={novaPi}><Plus size={18}/> Nova PI</button>
          <button className="btn btn-secondary" onClick={() => setShowSearchModal(true)}><Search size={18}/> Buscar PI</button>
          <button className="btn btn-secondary" onClick={abrirModalImpressao} disabled={!form.id}><Printer size={18}/> Imprimir</button>
          <button className="btn btn-secondary" onClick={abrirModalExcel} disabled={!form.id}><FileSpreadsheet size={18}/> Excel</button>
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
                 <input 
                   type="number" 
                   step="0.01" 
                   className="cl-input" 
                   value={form.cotacaoRisco} 
                   onChange={e => {
                     const risk = parseFloat(e.target.value) || 1;
                     setForm({...form, cotacaoRisco: e.target.value, valorTotalFreteUSD: form.valorTotalFreteBRL / risk});
                   }} 
                   title={getCalculationHint("cotacaoRisco")}
                 />
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
                  <div style={{ display: "flex", gap: "8px" }}>
                    <input 
                      type="number" 
                      step="0.01" 
                      className="cl-input" 
                      value={form.valorTotalFreteBRL} 
                      onChange={e => {
                        const brl = parseFloat(e.target.value) || 0;
                        const risk = Number(form.cotacaoRisco) || 1;
                        setForm({...form, valorTotalFreteBRL: brl, valorTotalFreteUSD: brl / risk});
                      }} 
                      title={getCalculationHint("freteTotalUSD")}
                    />
                    <div className="field" style={{ margin: 0, minWidth: "100px" }}>
                      <input 
                        type="text" 
                        disabled 
                        className="cl-input" 
                        style={{ backgroundColor: "#1e293b", color: "#94a3b8" }}
                        value={`$ ${fmt(form.valorTotalFreteUSD)}`} 
                      />
                    </div>
                  </div>
                </div>
               <div className="field">
                 <label className="label">Tempo Entrega</label>
                 <input type="text" className="cl-input" value={form.tempoEntrega || ""} onChange={e => setForm({...form, tempoEntrega: e.target.value})} placeholder="Ex: 30 dias" />
               </div>
               <div className="field" style={{ flex: 2 }}>
                  <label className="cl-label">{translate("COND_PAG")}</label>
                  <SearchableSelect
                    options={condicaoOptions}
                    value={form.condicaoPagamento || ""}
                    onChange={(val) => setForm(prev => ({ ...prev, condicaoPagamento: val }))}
                  />
                </div>

                <div className="field" style={{ flex: 1 }}>
                  <label className="cl-label">{translate("IDIOMA")}</label>
                  <SearchableSelect
                    options={[
                      { value: "PT", label: "Português (PT-BR)" },
                      { value: "ES", label: "Español (ES)" },
                      { value: "EN", label: "English (EN)" }
                    ]}
                    value={form.idioma || "PT"}
                    onChange={(val) => setForm(prev => ({ ...prev, idioma: val }))}
                  />
                </div>

                <div className="field" style={{ flex: 1 }}>
                  <label className="cl-label">Tipo de Rateio</label>
                  <SearchableSelect
                    options={[
                      { value: "VOLUME", label: "POR VOLUME" },
                      { value: "IGUAL", label: "POR IGUAL" }
                    ]}
                    value={form.tipoRateio || "VOLUME"}
                    onChange={(val) => setForm(prev => ({ ...prev, tipoRateio: val }))}
                  />
                </div>
            </div>
          </div>

          <div className="cl-card" style={{ padding: "0", overflow: "visible", borderRadius: "12px", border: "1px solid var(--border)", background: "transparent" }}>
            <div className="cl-tableWrap" style={{ overflow: "visible" }}>
              <table className="cl-table" style={{ width: "100%", borderCollapse: "separate", borderSpacing: "0", minWidth: "1400px" }}>
                <thead style={{ position: "sticky", top: 0, zIndex: 10 }}>
                  <tr style={{ background: "#0f172a" }}>
                    {!isFerguile ? (
                      <>
                        <th style={{ ...thStyle, width: "40px", textAlign: "center" }}>#</th>
                        <th style={{ ...thStyle, width: "60px", textAlign: "center" }}>Img</th>
                        <th style={{ ...thStyle, width: "120px", textAlign: "center" }}>Marca</th>
                        <th style={{ ...thStyle, width: "400px" }}>Módulo / Descrição</th>
                        <th style={{ ...thStyle, textAlign: "center", width: "50px" }}>L</th>
                        <th style={{ ...thStyle, textAlign: "center", width: "50px" }}>P</th>
                        <th style={{ ...thStyle, textAlign: "center", width: "50px" }}>A</th>
                        <th style={{ ...thStyle, textAlign: "center", width: "60px" }}>Qtd</th>
                        <th style={{ ...thStyle, textAlign: "center", width: "80px" }}>{translate("QTD_PECA")}</th>
                        <th style={{ ...thStyle, textAlign: "center", width: "70px" }}>M³ Total</th>
                        <th style={{ ...thStyle, width: "140px", textAlign: "center" }}>Tecido</th>
                        <th style={{ ...thStyle, width: "100px" }}>Pés</th>
                        <th style={{ ...thStyle, width: "120px" }}>Acabamento</th>
                        <th style={{ ...thStyle, width: "140px" }}>Observação</th>
                        <th style={{ ...thStyle, textAlign: "right", width: "100px" }}>Frete</th>
                        <th style={{ ...thStyle, textAlign: "right", width: "100px" }}>EXW Unit</th>
                        <th style={{ ...thStyle, textAlign: "right", width: "110px" }}>UNIT FINAL</th>
                        <th style={{ ...thStyle, textAlign: "right", width: "110px" }}>USD Unit</th>
                        <th style={{ ...thStyle, textAlign: "right", width: "130px" }}>TOTAL USD</th>
                      </>
                    ) : (
                      <>
                        <th style={{ ...thStyle, width: "60px" }}>FOTO</th>
                        <th style={{ ...thStyle, width: "100px" }}>REFERENCIA</th>
                        <th style={{ ...thStyle, width: "300px" }}>DESCRIPCIÓN</th>
                        <th style={{ ...thStyle, width: "100px" }}>MARCA</th>
                        <th style={{ ...thStyle, textAlign: "center", width: "50px" }}>LARG.</th>
                        <th style={{ ...thStyle, textAlign: "center", width: "50px" }}>ALT.</th>
                        <th style={{ ...thStyle, textAlign: "center", width: "50px" }}>PROF.</th>
                        <th style={{ ...thStyle, textAlign: "center", width: "60px" }}>CANT.</th>
                        <th style={{ ...thStyle, textAlign: "center", width: "80px" }}>{translate("QTD_PECA")}</th>
                        <th style={{ ...thStyle, textAlign: "center", width: "70px" }}>VOL M³</th>
                        <th style={{ ...thStyle, width: "120px" }}>FABRIC</th>
                        <th style={{ ...thStyle, width: "100px" }}>TELA N</th>
                        <th style={{ ...thStyle, width: "140px" }}>OBSERVACIÓN</th>
                        <th style={{ ...thStyle, textAlign: "right", width: "90px" }}>UNIT</th>
                        <th style={{ ...thStyle, textAlign: "right", width: "100px" }}>TOTAL</th>
                      </>
                    )}
                    <th style={{ ...thStyle, width: "50px" }}></th>
                  </tr>
                </thead>
                <tbody style={{ background: "rgba(15, 23, 42, 0.4)" }}>
                  {processedData.groups.map((group: any, groupIndex: number) => (
                     <React.Fragment key={groupIndex}>
                        {group.items.map((item: any, itemIndex: number) => {
                           const isFirst = itemIndex === 0;
                           const mtInfo = modulosTecidos.find(m => m.id === item.idModuloTecido);
                           
                           return (
                              <tr key={item.tempId} className="table-row-v2">
                                 {!isFerguile && (
                                   <td style={{ ...tdStyle, textAlign: "center", color: "var(--muted)", opacity: 0.5 }}>{itemIndex + 1}</td>
                                 )}

                                 {/* FOTO/Img Column */}
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

                                 {/* REFERENCIA / Marca Column */}
                                 {isFirst && (
                                   <td 
                                     rowSpan={group.span} 
                                     title={group.brandName || ""}
                                     style={{ ...tdStyle, color: "#60a5fa", fontWeight: "600", verticalAlign: "middle", textAlign: "center", background: "rgba(255,255,255,0.02)" }}
                                   >
                                     {group.brandName || "-"}
                                   </td>
                                 )}

                                 {/* Module / Description Column */}
                                 {(!isFerguile || item._descSpan > 0) && (
                                   <td rowSpan={isFerguile ? item._descSpan : 1} style={tdStyle}>
                                     <select 
                                       className="cl-select" 
                                       style={{ width: "100%", background: "transparent", border: "none", padding: "4px 0", height: "auto" }} 
                                       value={item.idModuloTecido} 
                                       onChange={e => updateItem(item.tempId, "idModuloTecido", Number(e.target.value))}
                                       title={mtInfo?.modulo?.descricao || "Selecione um módulo"}
                                     >
                                       <option value="0">Selecione um módulo...</option>
                                       {modulosTecidos.filter(mt => mt.idTecido === mtInfo?.idTecido && mt.modulo?.marca?.id === mtInfo?.modulo?.marca?.id).map(mt => (
                                          <option key={mt.id} value={mt.id} style={{ background: "#1e293b" }}>{mt.modulo?.descricao} ({mt.tecido?.nome})</option>
                                       ))}
                                     </select>
                                   </td>
                                 )}

                                 {/* Marca (Fornecedor) Column - Ferguile Only */}
                                 {isFerguile && (
                                   <td style={{ ...tdStyle, fontSize: "11px", color: "var(--muted)" }}>
                                      {mtInfo?.modulo?.fornecedor?.nome || "-"}
                                   </td>
                                 )}

                                 {/* Dimensions */}
                                 <td style={{ ...tdStyle, textAlign: "center" }}>{fmt(item.largura)}</td>
                                 {isFerguile ? (
                                    <td style={{ ...tdStyle, textAlign: "center" }}>{fmt(item.altura)}</td>
                                 ) : (
                                    <td style={{ ...tdStyle, textAlign: "center" }}>{fmt(item.profundidade)}</td>
                                 )}
                                 {isFerguile ? (
                                    <td style={{ ...tdStyle, textAlign: "center" }}>{fmt(item.profundidade)}</td>
                                 ) : (
                                    <td style={{ ...tdStyle, textAlign: "center" }}>{fmt(item.altura)}</td>
                                 )}

                                 {/* Quantity */}
                                 <td style={{ ...tdStyle, textAlign: "center" }}>
                                    <input 
                                      type="number" 
                                      className="cl-input" 
                                      style={{ width: "55px", textAlign: "center", height: "28px", padding: "0" }} 
                                      value={item.quantidade} 
                                      onChange={e => {
                                        const val = parseInt(e.target.value) || 1;
                                        updateItem(item.tempId, "quantidade", val);
                                        // If it's a single module piece, user might want to sync. 
                                        // But here we'll let user decide or provide a toggle later.
                                        // For now, only default on add.
                                      }}
                                    />
                                 </td>
                                 
                                 {/* Piece Quantity (One per group) */}
                                 {isFirst && (
                                   <td rowSpan={group.span} style={{ ...tdStyle, textAlign: "center", verticalAlign: "middle", background: "rgba(255,255,255,0.02)" }}>
                                      <input 
                                        type="number" 
                                        className="cl-input" 
                                        style={{ width: "55px", textAlign: "center", height: "30px", padding: "0", fontSize: "14px", fontWeight: "700" }} 
                                        value={item.quantidadePeca} 
                                        onChange={e => updateGroupPecaQuantity(group.items, parseInt(e.target.value) || 0)}
                                      />
                                   </td>
                                 )}
                                 
                                 {/* Vol Total M3 */}
                                 <td style={{ ...tdStyle, textAlign: "center", color: "#60a5fa" }} title={getCalculationHint("m3Total", item)}>
                                   {fmt3(item.m3 * item.quantidade)}
                                 </td>
                                 
                                 {(!isFerguile && isFirst) ? (
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
                                  ) : (
                                    isFerguile && (
                                      <td style={{ ...tdStyle, color: "#93c5fd", fontWeight: "600" }}>
                                        {mtInfo?.tecido?.nome || "-"}
                                      </td>
                                    )
                                  )}

                                 {/* Pés / Tela N */}
                                 <td style={tdStyle}>
                                     <input 
                                       className="cl-input" 
                                       style={{ width: "100%", height: "28px", padding: "4px", fontSize: "12px", background: "transparent" }} 
                                       value={isFerguile ? (item.codigoModuloTecido || "") : (item.feet || "")} 
                                       onChange={e => updateItem(item.tempId, isFerguile ? "codigoModuloTecido" : "feet", e.target.value)}
                                       placeholder={isFerguile ? "Tela..." : "Pés..."}
                                     />
                                  </td>

                                  {!isFerguile && (
                                    <td style={tdStyle}>
                                      <input 
                                        className="cl-input" 
                                        style={{ width: "100%", height: "28px", padding: "4px", fontSize: "12px", background: "transparent" }} 
                                        value={item.finishing || ""} 
                                        onChange={e => updateItem(item.tempId, "finishing", e.target.value)}
                                        placeholder="Acabamento..."
                                      />
                                    </td>
                                  )}

                                  <td style={tdStyle}>
                                     <input 
                                       className="cl-input" 
                                       style={{ width: "100%", height: "28px", padding: "4px", fontSize: "12px", background: "transparent" }} 
                                       value={item.observacao || ""} 
                                       onChange={e => updateItem(item.tempId, "observacao", e.target.value)}
                                       placeholder="Obs..."
                                     />
                                  </td>

                                 {!isFerguile && (
                                    <>
                                      <td style={{ ...tdStyle, textAlign: "right", color: "#94a3b8" }} title={getCalculationHint("freteUnit", item)}>
                                        $ {fmt(item.ValorFreteRateadoUSD * item.quantidade)}
                                      </td>
                                      <td style={{ ...tdStyle, textAlign: "right", color: "#94a3b8" }} title={getCalculationHint("exwUnit", item)}>
                                        $ {fmt(item.ValorEXW + (item.ValorFreteRateadoUSD * item.quantidade))}
                                      </td>
                                      <td style={{ ...tdStyle, textAlign: "right", color: "#94a3b8" }} title={getCalculationHint("unitFinal", item)}>
                                        $ {fmt((item.ValorEXW * item.quantidade) + (item.ValorFreteRateadoUSD * item.quantidade))}
                                      </td>
                                    </>
                                  )}
                                 
                                 {isFerguile ? (
                                   <td style={{ ...tdStyle, textAlign: "right", color: "#fff", fontWeight: "600" }} title={getCalculationHint("usdUnit", item)}>
                                     $ {fmt(item.ValorEXW + item.ValorFreteRateadoUSD)}
                                   </td>
                                 ) : (
                                   isFirst && (
                                     <td rowSpan={group.span} style={{ 
                                        ...tdStyle, 
                                        textAlign: "right", 
                                        verticalAlign: "middle", 
                                        color: "#94a3b8",
                                        background: "rgba(255, 255, 255, 0.02)",
                                        fontSize: "15px",
                                        fontWeight: "600"
                                      }}
                                      title={getCalculationHint("usdUnit", item, group)}
                                      >
                                         $ {fmt(group.totalUsdUnit)}
                                     </td>
                                   )
                                 )}
                                 
                                 {(!isFerguile && isFirst) ? (
                                    <td rowSpan={group.span} style={{ 
                                       textAlign: "right", 
                                       verticalAlign: "middle", 
                                       background: "rgba(239, 68, 68, 0.05)", 
                                       color: "#fca5a5",
                                       fontWeight: "800", 
                                       fontSize: "16px",
                                       paddingRight: "15px"
                                     }}
                                     title={getCalculationHint("totalUsd", item, group)}
                                     >
                                         $ {fmt(group.totalUsdUnit * item.quantidadePeca)}
                                    </td>
                                  ) : (
                                    isFerguile && (
                                      <td style={{ ...tdStyle, textAlign: "right", fontWeight: "700", color: "#fca5a5" }} title={getCalculationHint("totalUsd", item)}>
                                        $ {fmt((item.ValorEXW + item.ValorFreteRateadoUSD) * item.quantidade)}
                                      </td>
                                    )
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
                {itens.length > 0 && (
                  <tfoot style={{ background: "rgba(15, 23, 42, 0.8)", fontWeight: "700" }}>
                    <tr>
                      <td colSpan={isFerguile ? 13 : 14} style={{ ...tdStyle, textAlign: "right", color: "var(--muted)" }}>TOTAIS:</td>
                      {!isFerguile && (
                        <>
                          <td style={{ ...tdStyle, textAlign: "right", color: "#94a3b8" }}>
                            $ {fmt(itens.reduce((sum, i) => sum + (i.ValorFreteRateadoUSD * i.quantidade), 0))}
                          </td>
                          <td style={{ ...tdStyle, textAlign: "right", color: "#94a3b8" }}>
                            $ {fmt(itens.reduce((sum, i) => sum + (i.ValorEXW + (i.ValorFreteRateadoUSD * i.quantidade)), 0))}
                          </td>
                          <td style={{ ...tdStyle, textAlign: "right", color: "#94a3b8" }}>
                            $ {fmt(itens.reduce((sum, i) => sum + ((i.ValorEXW * i.quantidade) + (i.ValorFreteRateadoUSD * i.quantidade)), 0))}
                          </td>
                        </>
                      )}
                      <td style={{ ...tdStyle, textAlign: "right", color: "#fff" }}>
                        $ {fmt(processedData.groups.reduce((sum, g) => sum + g.totalUsdUnit, 0))}
                      </td>
                      <td style={{ ...tdStyle, textAlign: "right", color: "var(--danger)", fontSize: "16px" }}>
                        $ {fmt(processedData.groups.reduce((sum, g) => sum + (g.totalUsdUnit * g.items[0].quantidadePeca), 0))}
                      </td>
                      <td style={tdStyle}></td>
                    </tr>
                  </tfoot>
                )}
              </table>
            </div>
            <div style={{ padding: "15px 25px", background: "rgba(255, 255, 255, 0.03)", borderTop: "1px solid var(--border)", display: "flex", gap: "10px" }}>
               <button className="btn btn-secondary" onClick={addItem} style={{ borderRadius: "8px" }}><Plus size={20}/> Adicionar Módulo</button>
               <button className="btn btn-secondary" onClick={abrirModalImpressao} disabled={!form.id} style={{ borderRadius: "8px" }}><Printer size={20}/> Imprimir</button>
               <button className="btn btn-secondary" onClick={abrirModalExcel} disabled={!form.id} style={{ borderRadius: "8px" }}><FileSpreadsheet size={20}/> Excel</button>
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

              <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "25px", marginBottom: "30px" }}>
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
                  <label className="label" style={{ color: "#94a3b8" }}>Categoria</label>
                  <SearchableSelect 
                    value={filterCategoria}
                    onChange={setFilterCategoria}
                    placeholder="Todas"
                    options={[{ value: "", label: "Todas" }, ...categorias.map(c => ({ value: String(c.id), label: c.nome }))]}
                  />
                </div>
                <div className="field">
                  <label className="label" style={{ color: "#94a3b8" }}>Marca</label>
                  <SearchableSelect 
                    value={filterMarca}
                    onChange={setFilterMarca}
                    placeholder="Todas"
                    options={[{ value: "", label: "Todas" }, ...marcas.map(m => ({ value: String(m.id), label: m.nome }))]}
                  />
                </div>
                <div className="field">
                  <label className="label" style={{ color: "#94a3b8" }}>Tecido</label>
                  <SearchableSelect 
                    value={filterTecido}
                    onChange={setFilterTecido}
                    placeholder="Todos"
                    options={[{ value: "", label: "Todos" }, ...tecidos.map(t => ({ value: String(t.id), label: t.nome }))]}
                  />
                </div>
              </div>

              <div className="field" style={{ marginBottom: "25px" }}>
                <label className="label" style={{ color: "#94a3b8" }}>Módulo</label>
                <ModuloTecidoSelect 
                  value={selModuloTecido}
                  onChange={setSelModuloTecido}
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

              <div style={{ display: "grid", gridTemplateColumns: "1fr 2fr", gap: "25px", marginBottom: "35px" }}>
                <div className="field">
                  <label className="label" style={{ color: "#94a3b8" }}>Quantidade</label>
                  <input type="number" className="cl-input" value={quantidade} onChange={e => setQuantidade(e.target.value)} style={{ padding: "12px", fontSize: "16px" }} />
                </div>
                <div className="field">
                  <label className="label" style={{ color: "#94a3b8" }}>Código Personalizado</label>
                  <input type="text" className="cl-input" value={codigoModuloTecido} onChange={e => setCodigoModuloTecido(e.target.value)} placeholder="Opcional" style={{ padding: "12px", fontSize: "16px" }} />
                </div>
              </div>

              <div style={{ display: "flex", gap: "15px" }}>
                <button 
                  className="btn btn-primary" 
                  onClick={adicionarItem} 
                  style={{ flex: 2, padding: "15px", fontSize: "16px", fontWeight: "700", borderRadius: "10px", boxShadow: "0 10px 20px -5px rgba(59,130,246,0.3)" }}
                >
                  ADICIONAR À GRID
                </button>
                <button 
                  className="btn btn-secondary" 
                  onClick={() => setShowItemModal(false)}
                  style={{ flex: 1, padding: "15px", borderRadius: "10px" }}
                >
                  CANCELAR
                </button>
              </div>
            </div>
          </div>
        )}

        <PiCurrencyModal
          isOpen={currencyModalOpen}
          onClose={() => setCurrencyModalOpen(false)}
          onConfirm={handleConfirmCurrency}
          title={currencyModalType === "print" ? "Moneda para Impresión" : "Moneda para Excel"}
        />

        <style>{`
          .table-row-v2:hover { background: rgba(255, 255, 255, 0.03); }
          .cl-select:focus { outline: none; }
          .table-row-v2 td { transition: background 0.2s; }
        `}</style>
      </div>
    </>
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
