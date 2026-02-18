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

const API_BASE = import.meta.env.VITE_API_BASE ?? ''; // deixe vazio se usa proxy do Vite

export async function listClientes(params: {
  search?: string;
  page?: number;
  pageSize?: number;
} = {}) {
  const u = new URL(`${API_BASE}/api/clientes`, window.location.origin);
  if (params.search) u.searchParams.set('search', params.search);
  if (params.page) u.searchParams.set('page', String(params.page));
  if (params.pageSize) u.searchParams.set('pageSize', String(params.pageSize));

  const res = await fetch(u.toString().replace(window.location.origin, ''));
  if (!res.ok) throw new Error('Erro ao listar clientes');
  return (await res.json()) as PagedResult<Cliente>;
}

export async function getCliente(id: string) {
  const res = await fetch(`${API_BASE}/api/clientes/${id}`);
  if (!res.ok) throw new Error('Cliente não encontrado');
  return (await res.json()) as Cliente;
}

export async function createCliente(input: Partial<Cliente>) {
  const res = await fetch(`${API_BASE}/api/clientes`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(input),
  });
  if (!res.ok) throw new Error('Erro ao criar cliente');
  return (await res.json()) as Cliente;
}

export async function updateCliente(id: string, input: Partial<Cliente>) {
  const res = await fetch(`${API_BASE}/api/clientes/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(input),
  });
  if (!res.ok) throw new Error('Erro ao atualizar cliente');
}

export async function deleteCliente(id: string) {
  const res = await fetch(`${API_BASE}/api/clientes/${id}`, {
    method: 'DELETE',
  });
  if (!res.ok) throw new Error('Erro ao remover cliente');
}
