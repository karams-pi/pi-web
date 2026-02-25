import { API_BASE, apiDelete, apiGet, apiPost, apiPut } from "./api";
import type { ProformaInvoice } from "./types";

export async function listPis() {
  return apiGet<ProformaInvoice[]>("/api/pis");
}

export async function getPi(id: number) {
  return apiGet<ProformaInvoice>(`/api/pis/${id}`);
}

export async function getProximaSequencia() {
  const res = await apiGet<{ sequencia: string }>("/api/pis/proxima-sequencia");
  return res.sequencia;
}

export async function getCotacaoUSD() {
  const res = await apiGet<{ valor: number }>("/api/pis/cotacao-usd");
  return res.valor;
}

export async function createPi(input: Omit<ProformaInvoice, "id">) {
  return apiPost<ProformaInvoice>("/api/pis", input);
}

export async function updatePi(id: number, input: Omit<ProformaInvoice, "id">) {
  return apiPut<void>(`/api/pis/${id}`, input);
}

export async function deletePi(id: number) {
  return apiDelete(`/api/pis/${id}`);
}

export async function exportPiExcel(id: number) {
  const res = await fetch(`${API_BASE}/api/pis/${id}/excel`, {
    headers: {
        // Add auth if needed, but current api.ts seems to use simple fetch wrappers
    }
  });
  if (!res.ok) throw new Error("Falha ao exportar Excel");
  return res.blob();
}
