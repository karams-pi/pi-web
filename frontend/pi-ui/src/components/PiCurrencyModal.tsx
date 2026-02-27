
import { useState } from "react";

interface PiCurrencyModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: (currency: "BRL" | "EXW", validity: number) => void;
  title?: string;
}

export function PiCurrencyModal({ isOpen, onClose, onConfirm, title = "Seleccione la Moneda" }: PiCurrencyModalProps) {
  const [currency, setCurrency] = useState<"BRL" | "EXW">("BRL");
  const [validityDays, setValidityDays] = useState<number>(30);

  if (!isOpen) return null;

  return (
    <div className="cl-modal-overlay" style={{ 
        position: "fixed", 
        top: 0, 
        left: 0, 
        right: 0, 
        bottom: 0, 
        backgroundColor: "rgba(0, 0, 0, 0.75)", 
        display: "flex", 
        alignItems: "center", 
        justifyContent: "center", 
        zIndex: 9999,
        backdropFilter: "blur(4px)"
    }}>
      <div className="cl-modal" style={{ 
          maxWidth: 400, 
          width: "90%", 
          background: "#1a1a1a", 
          borderRadius: "12px", 
          padding: "24px",
          border: "1px solid #333",
          boxShadow: "0 20px 25px -5px rgba(0, 0, 0, 0.5)"
      }}>
        <div className="cl-modal-header" style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "16px" }}>
          <h2 className="cl-modal-title" style={{ margin: 0, fontSize: "20px", fontWeight: "bold", color: "#fff" }}>{title}</h2>
          <button 
            className="cl-modal-close" 
            onClick={onClose}
            style={{ background: "none", border: "none", color: "#94a3b8", fontSize: "24px", cursor: "pointer" }}
          >×</button>
        </div>

        <div className="cl-modal-body">
          <p style={{ marginBottom: 20, color: "#94a3b8" }}>
            Elija la moneda y la validez que se mostrará en el documento.
          </p>

          <div style={{ display: "flex", flexDirection: "column", gap: 16 }}>
            {/* Currency Options */}
            <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
              <label 
                style={{ 
                  display: "flex", 
                  alignItems: "center", 
                  gap: 12, 
                  cursor: "pointer",
                  padding: "14px 18px",
                  borderRadius: "10px",
                  background: currency === "BRL" ? "rgba(37, 99, 235, 0.15)" : "rgba(255,255,255,0.03)",
                  border: `2px solid ${currency === "BRL" ? "#2563eb" : "#333"}`,
                  transition: "all 0.2s"
                }}
                onClick={() => setCurrency("BRL")}
              >
                <input
                  type="radio"
                  name="pi-currency"
                  checked={currency === "BRL"}
                  onChange={() => setCurrency("BRL")}
                  style={{ width: "18px", height: "18px", cursor: "pointer" }}
                />
                <div>
                  <div style={{ fontWeight: "600", color: "#fff" }}>Reales (R$)</div>
                  <div style={{ fontSize: "12px", color: "#64748b" }}>Muestra los valores finales en moneda brasileña.</div>
                </div>
              </label>

              <label 
                style={{ 
                  display: "flex", 
                  alignItems: "center", 
                  gap: 12, 
                  cursor: "pointer",
                  padding: "14px 18px",
                  borderRadius: "10px",
                  background: currency === "EXW" ? "rgba(16, 185, 129, 0.15)" : "rgba(255,255,255,0.03)",
                  border: `2px solid ${currency === "EXW" ? "#10b981" : "#333"}`,
                  transition: "all 0.2s"
                }}
                onClick={() => setCurrency("EXW")}
              >
                <input
                  type="radio"
                  name="pi-currency"
                  checked={currency === "EXW"}
                  onChange={() => setCurrency("EXW")}
                  style={{ width: "18px", height: "18px", cursor: "pointer" }}
                />
                <div>
                  <div style={{ fontWeight: "600", color: "#fff" }}>Dólar (EXW)</div>
                  <div style={{ fontSize: "12px", color: "#64748b" }}>Muestra los valores base en moneda extranjera.</div>
                </div>
              </label>
            </div>

            {/* Validity Days */}
            <div style={{ marginTop: 8 }}>
              <label style={{ display: "block", color: "#94a3b8", fontSize: "14px", marginBottom: "8px" }}>
                Vencimiento / Validez (días)
              </label>
              <input 
                type="number"
                value={validityDays}
                onChange={(e) => setValidityDays(Number(e.target.value))}
                style={{ 
                  width: "100%", 
                  background: "rgba(255,255,255,0.05)", 
                  border: "1px solid #333", 
                  borderRadius: "8px", 
                  padding: "12px", 
                  color: "#fff",
                  fontSize: "16px",
                  outline: "none"
                }}
              />
            </div>
          </div>
        </div>

        <div className="cl-modal-footer" style={{ marginTop: 24, display: "flex", justifyContent: "flex-end", gap: 12 }}>
          <button 
            className="btn btn-secondary" 
            onClick={onClose} 
            style={{ 
                padding: "10px 20px", 
                borderRadius: "8px", 
                border: "1px solid #333", 
                background: "transparent", 
                color: "#fff", 
                cursor: "pointer",
                fontWeight: "500"
            }}
          >
            Cancelar
          </button>
          <button 
            className="btn btn-primary" 
            onClick={() => onConfirm(currency, validityDays)}
            style={{ 
              padding: "10px 24px",
              borderRadius: "8px",
              border: "none",
              color: "#fff",
              cursor: "pointer",
              fontWeight: "600",
              background: currency === "BRL" ? "#2563eb" : "#10b981",
              transition: "transform 0.1s active"
            }}
          >
            Confirmar
          </button>
        </div>
      </div>
    </div>
  );
}
