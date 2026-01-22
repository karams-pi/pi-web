import { apiDelete, apiGet, apiPost, apiPut } from "./api";
import type { Categoria } from "./types";

export async function listCategorias() {
  return apiGet<Categoria[]>("/api/categorias");
}
export async function createCategoria(input: Omit<Categoria, "id">) {
  return apiPost<Categoria>("/api/categorias", input);
}
export async function updateCategoria(id: number, input: Partial<Omit<Categoria, "id">>) {
  return apiPut<void>(`/api/categorias/${id}`, input);
}
export async function deleteCategoria(id: number) {
  return apiDelete(`/api/categorias/${id}`);
}
