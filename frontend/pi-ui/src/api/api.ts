// src/api/api.ts
const RAW_BASE = import.meta.env.VITE_API_BASE ?? "http://localhost:5000";
export const API_BASE = RAW_BASE.replace(/\/+$/, ""); // remove barra final

function buildUrl(path: string): string {
  return path.startsWith("http") ? path : `${API_BASE}${path}`;
}

function isJsonContentType(ct: string | null): boolean {
  if (!ct) return false;
  const v = ct.toLowerCase();
  return v.includes("application/json") || v.includes("+json");
}

async function assertOk(res: Response): Promise<void> {
  if (!res.ok) {
    const txt = await res.text().catch(() => "");
    throw new Error(txt || `HTTP ${res.status}`);
  }
}

async function parseJson<T>(res: Response): Promise<T> {
  // 204 No Content
  if (res.status === 204) {
    // @ts-expect-error: permitir retorno vazio quando T é void/unknown
    return undefined;
  }

  const ct = res.headers.get("content-type");
  if (!isJsonContentType(ct)) {
    const preview = await res.text().catch(() => "");
    throw new Error(
      `Resposta não é JSON (content-type="${ct ?? "desconhecido"}"). Prévia: ${preview.slice(0, 200)}`,
    );
  }

  const text = await res.text();
  if (!text) {
    // @ts-expect-error: permitir retorno vazio quando T é void/unknown
    return undefined;
  }

  let data: unknown;
  try {
    data = JSON.parse(text);
  } catch {
    throw new Error(`JSON inválido. Prévia: ${text.slice(0, 200)}`);
  }

  return data as T;
}

export async function apiGet<T>(path: string, init?: RequestInit): Promise<T> {
  const res = await fetch(buildUrl(path), { credentials: "omit", ...init });
  await assertOk(res);
  return parseJson<T>(res);
}

export async function apiPost<T>(
  path: string,
  body: unknown,
  init?: RequestInit,
): Promise<T> {
  const res = await fetch(buildUrl(path), {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
    credentials: "omit",
    ...init,
  });
  await assertOk(res);
  return parseJson<T>(res);
}

export async function apiPut<T>(
  path: string,
  body: unknown,
  init?: RequestInit,
): Promise<T> {
  const res = await fetch(buildUrl(path), {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
    credentials: "omit",
    ...init,
  });
  await assertOk(res);
  return parseJson<T>(res);
}

export async function apiDelete(
  path: string,
  init?: RequestInit,
): Promise<void> {
  const res = await fetch(buildUrl(path), {
    method: "DELETE",
    credentials: "omit",
    ...init,
  });
  await assertOk(res);
  // Se vier 204 ou body vazio, simplesmente retorna.
}
