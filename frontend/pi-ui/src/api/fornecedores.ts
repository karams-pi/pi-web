import { apiDelete, apiGet, apiPost, apiPut } from "./api";
import type { Fornecedor } from "./types";

export async function listFornecedores() {
  return apiGet<Fornecedor[]>("/api/fornecedores");
}
export async function createFornecedor(input: Omit<Fornecedor, "id">) {
  return apiPost<Fornecedor>("/api/fornecedores", input);
}
export async function updateFornecedor(id: number, input: Partial<Omit<Fornecedor, "id">>) {
  return apiPut<void>(`/api/fornecedores/${id}`, input);
}
export async function deleteFornecedor(id: number) {
  return apiDelete(`/api/fornecedores/${id}`);
}
