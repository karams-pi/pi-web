import { apiDelete, apiGet, apiPost, apiPut } from "./api";
import type { PiItem } from "./types";

export async function listPiItens() {
  return apiGet<PiItem[]>("/api/piitens");
}

export async function getPiItensByPi(idPi: number) {
  return apiGet<PiItem[]>(`/api/piitens/by-pi/${idPi}`);
}

export async function getPiItem(id: number) {
  return apiGet<PiItem>(`/api/piitens/${id}`);
}

export async function createPiItem(input: Omit<PiItem, "id">) {
  return apiPost<PiItem>("/api/piitens", input);
}

export async function updatePiItem(id: number, input: Omit<PiItem, "id">) {
  return apiPut<void>(`/api/piitens/${id}`, input);
}

export async function deletePiItem(id: number) {
  return apiDelete(`/api/piitens/${id}`);
}
