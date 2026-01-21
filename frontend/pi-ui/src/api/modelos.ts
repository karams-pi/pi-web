export type Modelo = { id: string; nome: string };

const base = "/api/modelos";

export async function listModelos(): Promise<Modelo[]> {
  const r = await fetch(base);
  if (!r.ok) throw new Error("Erro ao listar modelos");
  return r.json();
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
