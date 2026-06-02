import { apiDelete, apiGet, apiPost } from "./api";
import type { ListaEmitida } from "./types";

export async function listListasEmitidas() {
  return apiGet<ListaEmitida[]>("/api/listas-emitidas");
}

export async function createListaEmitida(input: ListaEmitida) {
  return apiPost<ListaEmitida>("/api/listas-emitidas", input);
}

export async function deleteListaEmitida(id: number) {
  return apiDelete(`/api/listas-emitidas/${id}`);
}
