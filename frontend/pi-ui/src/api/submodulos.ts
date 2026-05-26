import { apiGet } from "./api";
import type { SubModulo } from "./types";

export async function listSubModulos(idModulo?: number) {
  const query = new URLSearchParams();
  if (idModulo) query.append("idModulo", String(idModulo));
  return apiGet<SubModulo[]>(`/api/pi/submodulos?${query.toString()}`);
}

export async function listSubModulosByModulo(idModulo: number) {
  return apiGet<SubModulo[]>(`/api/pi/submodulos/modulo/${idModulo}`);
}

export async function buscarSubModulo(idModulo: number, tecidoEspecifico: string) {
  const query = new URLSearchParams({
    idModulo: String(idModulo),
    tecidoEspecifico
  });
  return apiGet<SubModulo>(`/api/pi/submodulos/buscar?${query.toString()}`);
}
