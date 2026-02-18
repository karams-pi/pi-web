import { apiDelete, apiGet, apiPost, apiPut } from "./api";
import type { ConfiguracoesFreteItem } from "./types";

export async function listConfiguracoesFreteItem() {
  return apiGet<ConfiguracoesFreteItem[]>("/api/configuracoesfreteitem");
}

export async function getConfiguracoesFreteItemByFrete(idFrete: number, fornecedorId?: number) {
  let url = `/api/configuracoesfreteitem/by-frete/${idFrete}`;
  if (fornecedorId) url += `?fornecedorId=${fornecedorId}`;
  return apiGet<ConfiguracoesFreteItem[]>(url);
}

export async function getTotalFrete(idFrete: number, fornecedorId?: number) {
  let url = `/api/configuracoesfreteitem/total-frete/${idFrete}`;
  if (fornecedorId) url += `?fornecedorId=${fornecedorId}`;
  return apiGet<number>(url);
}

export async function getConfiguracoesFreteItem(id: number) {
  return apiGet<ConfiguracoesFreteItem>(`/api/configuracoesfreteitem/${id}`);
}

export async function createConfiguracoesFreteItem(input: Omit<ConfiguracoesFreteItem, "id">) {
  return apiPost<ConfiguracoesFreteItem>("/api/configuracoesfreteitem", input);
}

export async function updateConfiguracoesFreteItem(id: number, input: Omit<ConfiguracoesFreteItem, "id">) {
  return apiPut<void>(`/api/configuracoesfreteitem/${id}`, input);
}

export async function deleteConfiguracoesFreteItem(id: number) {
  return apiDelete(`/api/configuracoesfreteitem/${id}`);
}
