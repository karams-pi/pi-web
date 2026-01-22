import { apiGet } from "./api";
import type { Fornecedor } from "./types";

export async function listFornecedores() {
  return apiGet<Fornecedor[]>("/api/fornecedores");
}
