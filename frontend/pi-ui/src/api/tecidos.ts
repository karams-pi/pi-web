import { getArray } from "./normalize";

export type Tecido = { id: string; nome: string };

const base = "/api/tecidos";

export async function listTecidos(params?: {
  search?: string;
  page?: number;
  pageSize?: number;
}) {
  const qs = new URLSearchParams({
    search: params?.search ?? "",
    page: String(params?.page ?? 1),
    pageSize: String(params?.pageSize ?? 50),
  });
  return getArray<Tecido>(`/api/tecidos?${qs.toString()}`);
}
export async function createTecido(input: Partial<Tecido>): Promise<Tecido> {
  const r = await fetch(base, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(input),
  });
  if (!r.ok) throw new Error("Erro ao criar tecido");
  return r.json();
}
export async function updateTecido(
  id: string,
  input: Partial<Tecido>,
): Promise<void> {
  const r = await fetch(`${base}/${id}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(input),
  });
  if (!r.ok) throw new Error("Erro ao atualizar tecido");
}
export async function deleteTecido(id: string): Promise<void> {
  const r = await fetch(`${base}/${id}`, { method: "DELETE" });
  if (!r.ok) throw new Error("Erro ao remover tecido");
}
