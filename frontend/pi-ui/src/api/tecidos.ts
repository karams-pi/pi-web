import { apiDelete, apiGet, apiPost, apiPut } from "./api";
import type { Tecido } from "./types";

export async function listTecidos() {
  return apiGet<Tecido[]>("/api/tecidos");
}
export async function createTecido(input: Omit<Tecido, "id">) {
  return apiPost<Tecido>("/api/tecidos", input);
}
export async function updateTecido(id: number, input: Partial<Omit<Tecido, "id">>) {
  return apiPut<void>(`/api/tecidos/${id}`, input);
}
export async function deleteTecido(id: number) {
  return apiDelete(`/api/tecidos/${id}`);
}
