import { getArray } from "./normalize";

export type Modelo = { id: string; nome: string };

const base = "/api/modelos";

export async function listModelos(params?: {
  search?: string;
  page?: number;
  pageSize?: number;
}) {
  const qs = new URLSearchParams({
    search: params?.search ?? "",
    page: String(params?.page ?? 1),
    pageSize: String(params?.pageSize ?? 50),
  });
  return getArray<Modelo>(`/api/modelos?${qs.toString()}`);
}
export async function createModelo(input: Partial<Modelo>): Promise<Modelo> {
  const r = await fetch(base, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(input),
  });
  if (!r.ok) throw new Error("Erro ao criar modelo");
  return r.json();
}
export async function updateModelo(
  id: string,
  input: Partial<Modelo>,
): Promise<void> {
  const r = await fetch(`${base}/${id}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(input),
  });
  if (!r.ok) throw new Error("Erro ao atualizar modelo");
}
export async function deleteModelo(id: string): Promise<void> {
  const r = await fetch(`${base}/${id}`, { method: "DELETE" });
  if (!r.ok) throw new Error("Erro ao remover modelo");
}
