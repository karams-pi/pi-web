import React, { useEffect, useState } from "react";
import {
  type Categoria,
  listCategorias,
  createCategoria,
  updateCategoria,
  deleteCategoria,
} from "../api/categorias";

export default function CategoriasPage() {
  const [items, setItems] = useState<Categoria[]>([]);
  const [loading, setLoading] = useState(false);
  const [nome, setNome] = useState("");
  const [editing, setEditing] = useState<Categoria | null>(null);

  async function load() {
    setLoading(true);
    try {
      setItems(await listCategorias());
    } finally {
      setLoading(false);
    }
  }
  useEffect(() => {
    load();
  }, []);

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!nome.trim()) return alert("Nome é obrigatório.");
    if (editing) {
      await updateCategoria(editing.id, { nome });
      setEditing(null);
    } else {
      await createCategoria({ nome });
    }
    setNome("");
    await load();
  }

  return (
    <div className="card">
      <h2>Categorias</h2>
      <form
        onSubmit={onSubmit}
        style={{ display: "flex", gap: 8, marginBottom: 12 }}
      >
        <input
          value={nome}
          onChange={(e) => setNome(e.target.value)}
          placeholder="Nome da categoria"
        />
        <button type="submit">{editing ? "Salvar" : "Adicionar"}</button>
        {editing && (
          <button
            type="button"
            onClick={() => {
              setEditing(null);
              setNome("");
            }}
          >
            Cancelar
          </button>
        )}
      </form>

      {loading ? (
        "Carregando..."
      ) : (
        <table style={{ width: "100%", borderCollapse: "collapse" }}>
          <thead>
            <tr>
              <th style={th}>Nome</th>
              <th style={th}>Ações</th>
            </tr>
          </thead>
          <tbody>
            {items.map((x) => (
              <tr key={x.id}>
                <td style={td}>{x.nome}</td>
                <td style={td}>
                  <button
                    onClick={() => {
                      setEditing(x);
                      setNome(x.nome);
                    }}
                  >
                    Editar
                  </button>{" "}
                  <button
                    onClick={async () => {
                      if (confirm(`Remover "${x.nome}"?`)) {
                        await deleteCategoria(x.id);
                        await load();
                      }
                    }}
                    style={{ color: "red" }}
                  >
                    Remover
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}

const th: React.CSSProperties = {
  textAlign: "left",
  borderBottom: "1px solid #ddd",
  padding: 8,
};
const td: React.CSSProperties = { borderBottom: "1px solid #eee", padding: 8 };
