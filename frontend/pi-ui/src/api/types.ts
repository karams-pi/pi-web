export type Fornecedor = { id: number; nome: string; cnpj: string };
export type Categoria = { id: number; nome: string };
export type Tecido = { id: number; nome: string };

export type Modelo = {
  id: number;
  idFornecedor: number;
  idCategoria: number;
  descricao: string;
  urlImagem?: string | null;
};

export type Marca = {
  id: number;
  nome: string;
  imagem?: string | null;
  observacao?: string | null;
  flAtivo?: boolean;
};

export type Modulo = {
  id: number;
  idFornecedor: number;
  idCategoria: number;
  idMarca: number;
  descricao: string;
  largura: number;
  profundidade: number;
  altura: number;
  pa: number;
  m3: number;
  modulosTecidos?: ModuloTecido[];
};

export type ModuloTecido = {
  id: number;
  idModulo: number;
  idTecido: number;
  valorTecido: number;
  codigoModuloTecido?: string;
  flAtivo: boolean;
  dtUltimaRevisao?: string;
  modulo?: {
    id: number;
    descricao: string;
    categoria?: {
      id: number;
      nome: string;
    };
    fornecedor?: {
      id: number;
      nome: string;
    };
    marca?: {
      id: number;
      nome: string;
    };
    largura?: number;
    profundidade?: number;
    altura?: number;
    pa?: number;
    m3?: number;
  };
  tecido?: {
    id: number;
    nome: string;
  };
};

export type Cliente = {
  id: string;
  nome: string;
  empresa?: string | null;
  email?: string | null;
  telefone?: string | null;
  ativo: boolean;
  pais?: string | null;
  cidade?: string | null;
  endereco?: string | null;
  cep?: string | null;
  pessoaContato?: string | null;
  cargoFuncao?: string | null;
  observacoes?: string | null;
  criadoEm: string;
  atualizadoEm: string;
};

export type Configuracao = {
  id: number;
  dataConfig: string;
  valorReducaoDolar: number;
  valorPercImposto: number;
  percentualComissao: number;
  percentualGordura: number;
  valorFCAFreteRodFronteira: number;
  valorDespesasFCA: number;
  valorFOBFretePortoParanagua: number;
  valorFOBDespPortRegDoc: number;
  valorFOBDespDespacAduaneiro: number;
  valorFOBDespCourier: number;
};

export type Frete = {
  id: number;
  nome: string;
};

export type FreteItem = {
  id: number;
  idFrete: number;
  nome: string;
};

export type ConfiguracoesFreteItem = {
  id: number;
  idFreteItem: number;
  valor: number;
  flDesconsidera: boolean;
  idFornecedor?: number | null;
};

export type ProformaInvoice = {
  id: number;
  prefixo: string;
  piSequencia: string;
  dataPi: string;
  idCliente: string;
  idFornecedor?: number | null;
  idConfiguracoes: number;
  idFrete: number;
  valorTecido: number;
  valorTotalFreteBRL: number;
  valorTotalFreteUSD: number;
  cotacaoAtualUSD: number;
  cotacaoRisco: number;
  piItens?: PiItem[];
};

export type PiItem = {
  id: number;
  idPi: number;
  idModuloTecido: number;
  largura: number;
  profundidade: number;
  altura: number;
  pa: number;
  m3: number;
  rateioFrete: number;
  quantidade: number;
  valorEXW: number;
  valorFreteRateadoBRL: number;
  valorFreteRateadoUSD: number;
  valorFinalItemBRL: number;
  valorFinalItemUSDRisco: number;
  tempCodigoModuloTecido?: string;
};

