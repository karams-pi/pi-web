import { API_BASE, apiDelete, apiGet, apiPost, apiPut } from "./api";
import type { ProformaInvoice } from "./types";

export async function listPis() {
  return apiGet<ProformaInvoice[]>("/api/pis");
}

export async function getPi(id: number) {
  return apiGet<ProformaInvoice>(`/api/pis/${id}`);
}

export async function getProximaSequencia(simulacao: boolean = false, prefixo: string = "SW") {
  const res = await apiGet<{ sequencia: string }>(`/api/pis/proxima-sequencia?simulacao=${simulacao}&prefixo=${prefixo}`);
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

export async function exportPiExcel(id: number, currency = "EXW", validity = 30, lang = "PT") {
  const res = await fetch(`${API_BASE}/api/pi/pis/${id}/excel?currency=${currency}&validity=${validity}&lang=${lang}`, {
    headers: {
        // Add auth if needed
    }
  });
  if (!res.ok) throw new Error("Falha ao exportar Excel");
  return res.blob();
}
