import { apiDelete, apiGet, apiPost, apiPut } from "./api";
import type { Frete } from "./types";

export async function listFretes() {
  return apiGet<Frete[]>("/api/fretes");
}

export async function getFrete(id: number) {
  return apiGet<Frete>(`/api/fretes/${id}`);
}

export async function createFrete(input: Omit<Frete, "id">) {
  return apiPost<Frete>("/api/fretes", input);
}

export async function updateFrete(id: number, input: Omit<Frete, "id">) {
  return apiPut<void>(`/api/fretes/${id}`, input);
}

export async function deleteFrete(id: number) {
  return apiDelete(`/api/fretes/${id}`);
}
