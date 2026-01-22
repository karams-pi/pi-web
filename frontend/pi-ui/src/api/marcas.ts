import { apiDelete, apiGet, apiPost, apiPut } from "./api";
import type { Marca } from "./types";

export async function listMarcas() {
  return apiGet<Marca[]>("/api/marcas");
}

export async function createMarca(input: Omit<Marca, "id">) {
  return apiPost<Marca>("/api/marcas", input);
}

export async function updateMarca(id: number, input: Partial<Omit<Marca, "id">>) {
  return apiPut<void>(`/api/marcas/${id}`, input);
}

export async function deleteMarca(id: number) {
  return apiDelete(`/api/marcas/${id}`);
}
