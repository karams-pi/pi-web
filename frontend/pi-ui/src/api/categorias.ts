import { apiGet } from "./api";

export type Categoria = { id: string; nome: string };

const base = "/api/categorias";

type Paged<T> = {
  items: T[];
  total?: number;
  page?: number;
  pageSize?: number;
};

export async function listCategorias(params?: {
  search?: string;
  page?: number;
  pageSize?: number;
}): Promise<Categoria[]> {
  const qs = new URLSearchParams({
    search: params?.search ?? "",
    page: String(params?.page ?? 1),
    pageSize: String(params?.pageSize ?? 50),
  });
  const r = await apiGet<Paged<Categoria> | Categoria[]>(
    `/api/categorias?${qs.toString()}`,
  );
  return Array.isArray(r) ? r : (r?.items ?? []);
}
export async function createCategoria(
  input: Partial<Categoria>,
): Promise<Categoria> {
  const r = await fetch(base, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(input),
  });
  if (!r.ok) throw new Error("Erro ao criar categoria");
  return r.json();
}
export async function updateCategoria(
  id: string,
  input: Partial<Categoria>,
): Promise<void> {
  const r = await fetch(`${base}/${id}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(input),
  });
  if (!r.ok) throw new Error("Erro ao atualizar categoria");
}
export async function deleteCategoria(id: string): Promise<void> {
  const r = await fetch(`${base}/${id}`, { method: "DELETE" });
  if (!r.ok) throw new Error("Erro ao remover categoria");
}
