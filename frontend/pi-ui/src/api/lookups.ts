// src/api/lookups.ts
export type PagedResult<T> = {
  items: T[];
  total: number;
  page: number;
  pageSize: number;
};

export type Categoria = { id: string; nome: string };
export type Modelo = { id: string; nome: string };
export type Tecido = { id: string; nome: string };

async function http<T>(input: RequestInfo, init?: RequestInit): Promise<T> {
  const r = await fetch(input, {
    headers: { "Content-Type": "application/json" },
    ...init,
  });
  if (!r.ok) throw new Error(await r.text());
  return r.json() as Promise<T>;
}

export const categoriasApi = {
  list: (p: { search?: string; page?: number; pageSize?: number }) =>
    http<PagedResult<Categoria>>(
      `/api/categorias?search=${encodeURIComponent(p.search ?? "")}&page=${p.page ?? 1}&pageSize=${p.pageSize ?? 50}`,
    ),
  create: (b: Partial<Categoria>) =>
    http<Categoria>("/api/categorias", {
      method: "POST",
      body: JSON.stringify(b),
    }),
  update: (id: string, b: Partial<Categoria>) =>
    fetch(`/api/categorias/${id}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(b),
    }).then((r) => {
      if (!r.ok) return r.text().then((t) => Promise.reject(new Error(t)));
    }),
  remove: (id: string) =>
    fetch(`/api/categorias/${id}`, { method: "DELETE" }).then((r) => {
      if (!r.ok) return r.text().then((t) => Promise.reject(new Error(t)));
    }),
};

export const modelosApi = {
  list: (p: { search?: string; page?: number; pageSize?: number }) =>
    http<PagedResult<Modelo>>(
      `/api/modelos?search=${encodeURIComponent(p.search ?? "")}&page=${p.page ?? 1}&pageSize=${p.pageSize ?? 50}`,
    ),
  create: (b: Partial<Modelo>) =>
    http<Modelo>("/api/modelos", { method: "POST", body: JSON.stringify(b) }),
  update: (id: string, b: Partial<Modelo>) =>
    fetch(`/api/modelos/${id}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(b),
    }).then((r) => {
      if (!r.ok) return r.text().then((t) => Promise.reject(new Error(t)));
    }),
  remove: (id: string) =>
    fetch(`/api/modelos/${id}`, { method: "DELETE" }).then((r) => {
      if (!r.ok) return r.text().then((t) => Promise.reject(new Error(t)));
    }),
};

export const tecidosApi = {
  list: (p: { search?: string; page?: number; pageSize?: number }) =>
    http<PagedResult<Tecido>>(
      `/api/tecidos?search=${encodeURIComponent(p.search ?? "")}&page=${p.page ?? 1}&pageSize=${p.pageSize ?? 50}`,
    ),
  create: (b: Partial<Tecido>) =>
    http<Tecido>("/api/tecidos", { method: "POST", body: JSON.stringify(b) }),
  update: (id: string, b: Partial<Tecido>) =>
    fetch(`/api/tecidos/${id}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(b),
    }).then((r) => {
      if (!r.ok) return r.text().then((t) => Promise.reject(new Error(t)));
    }),
  remove: (id: string) =>
    fetch(`/api/tecidos/${id}`, { method: "DELETE" }).then((r) => {
      if (!r.ok) return r.text().then((t) => Promise.reject(new Error(t)));
    }),
};
