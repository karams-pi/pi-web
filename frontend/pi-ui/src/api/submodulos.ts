import { apiGet, apiPost, apiPut, apiDelete } from "./api";
import type { SubModulo } from "./types";

export async function listSubModulos(idModulo?: number) {
  const query = new URLSearchParams();
  if (idModulo) query.append("idModulo", String(idModulo));
  return apiGet<SubModulo[]>(`/api/submodulos?${query.toString()}`);
}

export async function listSubModulosByModulo(idModulo: number) {
  return apiGet<SubModulo[]>(`/api/submodulos/modulo/${idModulo}`);
}

export async function listSubModulosByModulos(ids: number[]) {
  if (ids.length === 0) return [];
  return apiGet<SubModulo[]>(`/api/submodulos/modulos?ids=${ids.join(",")}`);
}

export async function buscarSubModulo(idModulo: number, tecidoEspecifico: string) {
  const query = new URLSearchParams({
    idModulo: String(idModulo),
    tecidoEspecifico
  });
  return apiGet<SubModulo>(`/api/submodulos/buscar?${query.toString()}`);
}

export async function getSubModuloById(id: number) {
  return apiGet<SubModulo>(`/api/submodulos/${id}`);
}

export async function createSubModulo(input: Omit<SubModulo, "id" | "tecidoBase">) {
  return apiPost<SubModulo>("/api/submodulos", input);
}

export async function updateSubModulo(id: number, input: Omit<SubModulo, "id" | "tecidoBase">) {
  return apiPut<void>(`/api/submodulos/${id}`, { id, ...input });
}

export async function deleteSubModulo(id: number) {
  return apiDelete(`/api/submodulos/${id}`);
}
