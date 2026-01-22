import { apiDelete, apiGet, apiPost, apiPut } from "./api";
import type { Modelo } from "./types";

export type ListModelosQuery = {
  idFornecedor?: number;
  idCategoria?: number;
};

export async function listModelos(q?: ListModelosQuery) {
  const qs = new URLSearchParams();
  if (q?.idFornecedor) qs.set("idFornecedor", String(q.idFornecedor));
  if (q?.idCategoria) qs.set("idCategoria", String(q.idCategoria));
  const url = `/api/modelos${qs.toString() ? `?${qs}` : ""}`;
  return apiGet<Modelo[]>(url);
}

export async function createModelo(input: Omit<Modelo, "id">) {
  return apiPost<Modelo>("/api/modelos", input);
}
export async function updateModelo(id: number, input: Partial<Omit<Modelo, "id">>) {
  return apiPut<void>(`/api/modelos/${id}`, input);
}
export async function deleteModelo(id: number) {
  return apiDelete(`/api/modelos/${id}`);
}
