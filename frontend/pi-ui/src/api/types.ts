export type Categoria = { id: number; nome: string };
export type Tecido = { id: number; nome: string };
export type Fornecedor = { id: number; nome: string; cnpj?: string | null };

export type Modelo = {
  id: number;
  descricao: string;

  fornecedorId: number;
  categoriaId: number;
  tecidoId: number;

  largura: number;
  profundidade: number;
  altura: number;

  pa: number | null;

  // pode não vir do backend
  m3?: number | null;

  valorTecido: number;
};
