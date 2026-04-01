
import React, { useState } from 'react';

interface PasswordGuardProps {
  children: React.ReactNode;
}

export default function PasswordGuard({ children }: PasswordGuardProps) {
  const [password, setPassword] = useState("");
  const [authorized, setAuthorized] = useState(false);
  const [error, setError] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (password === "000000") {
      setAuthorized(true);
      setError(false);
    } else {
      setError(true);
    }
  };

  if (authorized) {
    return <>{children}</>;
  }

  return (
    <div style={{
      display: "flex",
      flexDirection: "column",
      alignItems: "center",
      justifyContent: "center",
      height: "80vh",
      background: "#f9fafb",
      fontFamily: "Inter, sans-serif"
    }}>
      <div className="card" style={{
        padding: "40px",
        width: "100%",
        maxWidth: "400px",
        textAlign: "center",
        boxShadow: "0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1)"
      }}>
        <div style={{ fontSize: "2rem", marginBottom: "15px" }}>🔒</div>
        <h2 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "10px", color: "#111827" }}>Área Restrita (Beta)</h2>
        <p style={{ color: "#6b7280", marginBottom: "25px", fontSize: "0.95rem" }}>
          Digite a senha para acessar o novo lançamento de Proforma Invoice.
        </p>

        <form onSubmit={handleSubmit} style={{ display: "flex", flexDirection: "column", gap: "15px" }}>
          <input
            type="password"
            placeholder="Senha de acesso"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            style={{
              padding: "12px 16px",
              borderRadius: "8px",
              border: `2px solid ${error ? "#ef4444" : "#e5e7eb"}`,
              fontSize: "1rem",
              textAlign: "center",
              outline: "none",
              transition: "border-color 0.2s"
            }}
            autoFocus
          />
          {error && <div style={{ color: "#ef4444", fontSize: "0.85rem", fontWeight: "bold" }}>Senha incorreta! Tente novamente.</div>}
          <button
            type="submit"
            style={{
              padding: "12px",
              background: "#1f2937",
              color: "white",
              borderRadius: "8px",
              fontWeight: "600",
              cursor: "pointer",
              border: "none",
              transition: "background 0.2s"
            }}
            onMouseOver={(e) => (e.currentTarget.style.background = "#374151")}
            onMouseOut={(e) => (e.currentTarget.style.background = "#1f2937")}
          >
            Acessar Versão Beta
          </button>
        </form>
      </div>
    </div>
  );
}
