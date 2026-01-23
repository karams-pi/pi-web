import { useState, useEffect } from "react";
import { listPis } from "../api/pis";
import type { ProformaInvoice } from "../api/types";

interface PiSearchModalProps {
  onClose: () => void;
  onSelect: (pi: ProformaInvoice) => void;
}

export function PiSearchModal({ onClose, onSelect }: PiSearchModalProps) {
  const [pis, setPis] = useState<ProformaInvoice[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");

  useEffect(() => {
    loadPis();
  }, []);

  async function loadPis() {
    try {
      setLoading(true);
      const data = await listPis();
      setPis(data);
    } catch (error) {
      console.error("Erro ao carregar PIs:", error);
      alert("Erro ao carregar lista de PIs");
    } finally {
      setLoading(false);
    }
  }

  const filteredPis = pis.filter((pi) => {
    const term = search.toLowerCase();
    // Ajustar campos conforme o retorno da API. 
    // Assumindo que Cliente vem preenchido ou temos idCliente
    // Se o backend nao retornar nome do cliente no listPis, teremos que filtrar só pelo que tem.
    return (
      pi.piSequencia?.toLowerCase().includes(term) ||
      pi.prefixo?.toLowerCase().includes(term)
    );
  });

  return (
    <div style={{
      position: "fixed",
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      background: "rgba(0,0,0,0.7)",
      display: "flex",
      alignItems: "center",
      justifyContent: "center",
      zIndex: 2000
    }}>
      <div className="cl-card" style={{ width: "800px", maxWidth: "90%", maxHeight: "80vh", display: "flex", flexDirection: "column", padding: 20, background: "#1e1e2d" }}>
        
        <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 20 }}>
          <h2 style={{ margin: 0 }}>Consultar PI</h2>
          <button onClick={onClose} style={{ background: "none", border: "none", color: "#fff", cursor: "pointer", fontSize: 20 }}>✕</button>
        </div>

        <div style={{ marginBottom: 16 }}>
          <input
            className="cl-input"
            placeholder="Buscar por Sequência ou Prefixo..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            autoFocus
          />
        </div>

        <div style={{ flex: 1, overflowY: "auto" }}>
          {loading ? (
            <div style={{ padding: 20, textAlign: "center" }}>Carregando...</div>
          ) : (
            <table style={{ width: "100%", borderCollapse: "collapse" }}>
              <thead>
                <tr style={{ background: "#2a2a35" }}>
                  <th style={th}>Sequência</th>
                  <th style={th}>Data</th>
                  <th style={th}>Cliente</th>
                  <th style={th}>Ação</th>
                </tr>
              </thead>
              <tbody>
                {filteredPis.map((pi) => (
                  <tr key={pi.id} style={{ borderBottom: "1px solid #333" }}>
                    <td style={td}>{pi.prefixo}-{pi.piSequencia}</td>
                    <td style={td}>{new Date(pi.dataPi).toLocaleDateString()}</td>
                    <td style={td}>
                       {/* Se o objeto cliente vier populado, mostramos o nome. Se não, mostramos o ID por enquanto */}
                       {(pi as any).cliente?.nome || `Cliente #${pi.idCliente}`}
                    </td>
                    <td style={td}>
                      <button 
                        className="btn btn-primary btn-sm"
                        onClick={() => onSelect(pi)}
                      >
                        Selecionar
                      </button>
                    </td>
                  </tr>
                ))}
                {filteredPis.length === 0 && (
                  <tr>
                    <td colSpan={4} style={{ padding: 20, textAlign: "center", color: "#888" }}>Nenhuma PI encontrada</td>
                  </tr>
                )}
              </tbody>
            </table>
          )}
        </div>
      </div>
    </div>
  );
}

const th: React.CSSProperties = {
  padding: "10px",
  textAlign: "left",
  color: "#888",
  fontSize: "13px",
  fontWeight: "bold"
};

const td: React.CSSProperties = {
  padding: "10px",
  fontSize: "14px",
  color: "#eee"
};
