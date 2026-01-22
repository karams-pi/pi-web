import { apiDelete, apiGet, apiPost, apiPut } from "./api";
import type { Modelo } from "./types";

export type ListModelosQuery = {
  fornecedorId?: number;
  categoriaId?: number;
  tecidoId?: number;
};

export async function listModelos(q?: ListModelosQuery) {
  const qs = new URLSearchParams();
  if (q?.fornecedorId) qs.set("fornecedorId", String(q.fornecedorId));
  if (q?.categoriaId) qs.set("categoriaId", String(q.categoriaId));
  if (q?.tecidoId) qs.set("tecidoId", String(q.tecidoId));
  const url = `/api/modelos${qs.toString() ? `?${qs}` : ""}`;
  return apiGet<Modelo[]>(url);
}

export async function createModelo(input: Omit<Modelo, "id" | "m3">) {
  return apiPost<Modelo>("/api/modelos", input);
}

export async function updateModelo(
  id: number,
  input: Partial<Omit<Modelo, "id" | "m3">>,
) {
  return apiPut<void>(`/api/modelos/${id}`, input);
}

export async function deleteModelo(id: number) {
  return apiDelete(`/api/modelos/${id}`);
}
