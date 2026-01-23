import { apiDelete, apiGet, apiPost, apiPut } from "./api";
import type { FreteItem } from "./types";

export async function listFreteItens() {
  return apiGet<FreteItem[]>("/api/freteitens");
}

export async function getFreteItensByFrete(idFrete: number) {
  return apiGet<FreteItem[]>(`/api/freteitens/by-frete/${idFrete}`);
}

export async function getFreteItem(id: number) {
  return apiGet<FreteItem>(`/api/freteitens/${id}`);
}

export async function createFreteItem(input: Omit<FreteItem, "id">) {
  return apiPost<FreteItem>("/api/freteitens", input);
}

export async function updateFreteItem(id: number, input: Omit<FreteItem, "id">) {
  return apiPut<void>(`/api/freteitens/${id}`, input);
}

export async function deleteFreteItem(id: number) {
  return apiDelete(`/api/freteitens/${id}`);
}
