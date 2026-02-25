import { API_BASE, apiDelete, apiGet, apiPost, apiPut } from "./api";
import type { Modulo, ModuloTecido } from "./types";

// --- MODULOS ---

export async function listModulos(
  search = "", 
  page = 1, 
  pageSize = 10,
  idFornecedor?: number,
  idCategoria?: number,
  idMarca?: number,
  idTecido?: number,
  status: 'ativos' | 'inativos' | 'todos' = 'ativos'
) {
  const query = new URLSearchParams({
    search,
    page: String(page),
    pageSize: String(pageSize),
    status
  });

  if (idFornecedor) query.append("idFornecedor", String(idFornecedor));
  if (idCategoria) query.append("idCategoria", String(idCategoria));
  if (idMarca) query.append("idMarca", String(idMarca));
  if (idTecido) query.append("idTecido", String(idTecido));

  return apiGet<{ items: Modulo[]; total: number; totalPages: number }>(
    `/api/modulos?${query.toString()}`
  );
}

export async function createModulo(input: Omit<Modulo, "id" | "m3">) {
  // m3 é calculado no backend
  return apiPost<Modulo>("/api/modulos", input);
}

export async function updateModulo(id: number, input: Omit<Modulo, "id" | "m3">) {
  return apiPut<void>(`/api/modulos/${id}`, input);
}

export async function deleteModulo(id: number) {
  return apiDelete(`/api/modulos/${id}`);
}

// --- MODULOS TECIDOS ---

// Normalmente listamos por modulo, mas o controller deu GetAll.
// Se precisar filtrar no front, usamos o GetAll.
// Se o backend tiver filtro, ajustamos aqui.
export async function listModulosTecidos() {
  return apiGet<ModuloTecido[]>("/api/modulostecidos");
}

export async function createModuloTecido(input: Omit<ModuloTecido, "id">) {
  return apiPost<ModuloTecido>("/api/modulostecidos", input);
}

export async function updateModuloTecido(id: number, input: Omit<ModuloTecido, "id">) {
  return apiPut<void>(`/api/modulostecidos/${id}`, input);
}


export async function deleteModuloTecido(id: number) {
  return apiDelete(`/api/modulostecidos/${id}`);
}

export async function getModuleFilters(
  idFornecedor?: number,
  idCategoria?: number,
  idMarca?: number,
  idTecido?: number
) {
  const query = new URLSearchParams();
  if (idFornecedor) query.append("idFornecedor", String(idFornecedor));
  if (idCategoria) query.append("idCategoria", String(idCategoria));
  if (idMarca) query.append("idMarca", String(idMarca));
  if (idTecido) query.append("idTecido", String(idTecido));

  return apiGet<{
    fornecedores: import("./types").Fornecedor[];
    categorias: import("./types").Categoria[];
    marcas: import("./types").Marca[];
    tecidos: import("./types").Tecido[];
  }>(`/api/modulos/filters?${query.toString()}`);
}
export async function exportModulosExcel(params: {
  ids?: number[];
  currency: "BRL" | "EXW";
  cotacao: number;
  search?: string;
  idFornecedor?: number;
  idCategoria?: number;
  idMarca?: number;
  idTecido?: number;
  status?: string;
}) {
  const res = await fetch(`${API_BASE}/api/modulos/excel`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(params),
  });

  if (!res.ok) throw new Error("Erro ao exportar Excel");
  return res.blob();
}
