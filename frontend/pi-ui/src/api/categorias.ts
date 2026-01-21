export type Categoria = { id: string; nome: string };

const base = "/api/categorias";

export async function listCategorias(): Promise<Categoria[]> {
  const r = await fetch(base);
  if (!r.ok) throw new Error("Erro ao listar categorias");
  return r.json();
}
export async function createCategoria(
  input: Partial<Categoria>,
): Promise<Categoria> {
  const r = await fetch(base, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(input),
  });
  if (!r.ok) throw new Error("Erro ao criar categoria");
  return r.json();
}
export async function updateCategoria(
  id: string,
  input: Partial<Categoria>,
): Promise<void> {
  const r = await fetch(`${base}/${id}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(input),
  });
  if (!r.ok) throw new Error("Erro ao atualizar categoria");
}
export async function deleteCategoria(id: string): Promise<void> {
  const r = await fetch(`${base}/${id}`, { method: "DELETE" });
  if (!r.ok) throw new Error("Erro ao remover categoria");
}
