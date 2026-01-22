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
  urlImagem?: string | null;
  observacao?: string | null;
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
};

export type ModuloTecido = {
  id: number;
  idModulo: number;
  idTecido: number;
  valorTecido: number;
};
