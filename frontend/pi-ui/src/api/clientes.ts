import { apiGet, apiPost, apiPut, apiDelete } from "./api";

export interface Cliente {
  id: string;
  nome: string;
  empresa?: string | null;
  nit?: string | null;
  email?: string | null;
  telefone?: string | null;
  ativo: boolean;
  pais?: string | null;
  cidade?: string | null;
  endereco?: string | null;
  cep?: string | null;
  pessoaContato?: string | null;
  cargoFuncao?: string | null;
  portoDestino?: string | null;
  observacoes?: string | null;
  criadoEm?: string;
  atualizadoEm?: string;
}

export interface PagedResult<T> {
  items: T[];
  total: number;
  page: number;
  pageSize: number;
}

export async function listClientes(params: {
  search?: string;
  page?: number;
  pageSize?: number;
} = {}) {
  const u = new URLSearchParams();
  if (params.search) u.set('search', params.search);
  if (params.page) u.set('page', String(params.page));
  if (params.pageSize) u.set('pageSize', String(params.pageSize));

  const query = u.toString();
  const path = query ? `/api/clientes?${query}` : '/api/clientes';

  return apiGet<PagedResult<Cliente>>(path);
}

export async function getCliente(id: string) {
  return apiGet<Cliente>(`/api/clientes/${id}`);
}

export async function createCliente(input: Partial<Cliente>) {
  return apiPost<Cliente>('/api/clientes', input);
}

export async function updateCliente(id: string, input: Partial<Cliente>) {
  return apiPut<void>(`/api/clientes/${id}`, input);
}

export async function deleteCliente(id: string) {
  return apiDelete(`/api/clientes/${id}`);
}

