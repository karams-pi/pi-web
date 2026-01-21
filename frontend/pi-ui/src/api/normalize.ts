// src/api/normalize.ts
import { apiGet } from "./api";

export type PagedResult<T> = {
  items: T[];
  total?: number;
  page?: number;
  pageSize?: number;
};

function isObject(value: unknown): value is Record<string, unknown> {
  return value !== null && typeof value === "object";
}

function isPagedResult<T>(value: unknown): value is PagedResult<T> {
  if (!isObject(value)) return false;
  const items = (value as Record<string, unknown>).items;
  return Array.isArray(items);
}

export async function getArray<T>(path: string): Promise<T[]> {
  const r = await apiGet<unknown>(path);
  if (Array.isArray(r)) return r as T[];
  if (isPagedResult<T>(r)) return r.items;
  return [];
}

// Opcional: se quiser um helper que sempre devolve um PagedResult completo
export async function getPaged<T>(path: string): Promise<PagedResult<T>> {
  const r = await apiGet<unknown>(path);
  if (isPagedResult<T>(r)) return r;
  if (Array.isArray(r)) {
    const arr = r as T[];
    return { items: arr, total: arr.length, page: 1, pageSize: arr.length };
  }
  return { items: [], total: 0, page: 1, pageSize: 0 };
}
