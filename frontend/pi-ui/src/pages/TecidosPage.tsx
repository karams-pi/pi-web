import React, { useEffect, useState } from "react";
import {
  type Tecido,
  listTecidos,
  createTecido,
  updateTecido,
  deleteTecido,
} from "../api/tecidos";

export default function TecidosPage() {
  const [items, setItems] = useState<Tecido[]>([]);
  const [loading, setLoading] = useState(false);
  const [nome, setNome] = useState("");
  const [editing, setEditing] = useState<Tecido | null>(null);

  async function load() {
    setLoading(true);
    try {
      setItems(await listTecidos());
    } finally {
      setLoading(false);
    }
  }
  useEffect(() => {
    load();
  }, []);

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!nome.trim()) return alert("Código é obrigatório.");
    if (editing) await updateTecido(editing.id, { nome });
    else await createTecido({ nome });
    setNome("");
    setEditing(null);
    await load();
  }

  return (
    <div className="card">
      <h2>Tecidos</h2>
      <form
        onSubmit={onSubmit}
        style={{ display: "flex", gap: 8, marginBottom: 12 }}
      >
        <input
          value={nome}
          onChange={(e) => setNome(e.target.value)}
          placeholder="Ex.: G0"
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
              <th style={th}>Código</th>
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
                        await deleteTecido(x.id);
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
