import React, { useState } from "react";
import { createCliente } from "../api/clientes";
import type { Cliente } from "../api/types";

interface NewClientModalProps {
  isOpen: boolean;
  onClose: () => void;
  onClientCreated: (newClient: Cliente) => void;
}

export function NewClientModal({ isOpen, onClose, onClientCreated }: NewClientModalProps) {
  const [form, setForm] = useState<Partial<Cliente>>({
    nome: "",
    empresa: "",
    email: "",
    telefone: "",
    ativo: true,
  });
  const [saving, setSaving] = useState(false);

  if (!isOpen) return null;

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!form.nome?.trim()) {
      alert("Nome é obrigatório.");
      return;
    }

    setSaving(true);
    try {
      const newClient = await createCliente(form);
      onClientCreated(newClient);
      onClose();
    } catch (e: any) {
      alert("Erro ao criar cliente: " + (e.message || String(e)));
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="cl-modal-overlay" style={{ 
        position: "fixed", 
        top: 0, left: 0, right: 0, bottom: 0, 
        backgroundColor: "rgba(0, 0, 0, 0.75)", 
        display: "flex", alignItems: "center", justifyContent: "center", 
        zIndex: 9999, backdropFilter: "blur(4px)"
    }}>
      <div className="cl-modal" style={{ 
          maxWidth: 500, width: "90%", 
          background: "#1a1a1a", borderRadius: "12px", 
          padding: "24px", border: "1px solid #333",
          boxShadow: "0 20px 25px -5px rgba(0, 0, 0, 0.5)"
      }}>
        <div className="cl-modal-header" style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "16px" }}>
          <h2 className="cl-modal-title" style={{ margin: 0, fontSize: "20px", fontWeight: "bold", color: "#fff" }}>
            Novo Cliente Rápido
          </h2>
          <button 
            type="button"
            className="cl-modal-close" 
            onClick={onClose}
            style={{ background: "none", border: "none", color: "#94a3b8", fontSize: "24px", cursor: "pointer" }}
          >×</button>
        </div>

        <form onSubmit={handleSubmit}>
          <div className="cl-modal-body" style={{ display: "flex", flexDirection: "column", gap: "16px" }}>
            <div className="field">
              <label style={{ display: "block", color: "#94a3b8", fontSize: "14px", marginBottom: "8px" }}>Nome*</label>
              <input
                style={{ width: "100%", background: "rgba(255,255,255,0.05)", border: "1px solid #333", borderRadius: "8px", padding: "12px", color: "#fff", fontSize: "16px", outline: "none" }}
                value={form.nome || ""}
                onChange={(e) => setForm({ ...form, nome: e.target.value })}
                required
              />
            </div>
            <div className="field">
              <label style={{ display: "block", color: "#94a3b8", fontSize: "14px", marginBottom: "8px" }}>Empresa</label>
              <input
                style={{ width: "100%", background: "rgba(255,255,255,0.05)", border: "1px solid #333", borderRadius: "8px", padding: "12px", color: "#fff", fontSize: "16px", outline: "none" }}
                value={form.empresa || ""}
                onChange={(e) => setForm({ ...form, empresa: e.target.value })}
              />
            </div>
            <div className="field">
              <label style={{ display: "block", color: "#94a3b8", fontSize: "14px", marginBottom: "8px" }}>E-mail</label>
              <input
                type="email"
                style={{ width: "100%", background: "rgba(255,255,255,0.05)", border: "1px solid #333", borderRadius: "8px", padding: "12px", color: "#fff", fontSize: "16px", outline: "none" }}
                value={form.email || ""}
                onChange={(e) => setForm({ ...form, email: e.target.value })}
              />
            </div>
            <div className="field">
              <label style={{ display: "block", color: "#94a3b8", fontSize: "14px", marginBottom: "8px" }}>Telefone</label>
              <input
                style={{ width: "100%", background: "rgba(255,255,255,0.05)", border: "1px solid #333", borderRadius: "8px", padding: "12px", color: "#fff", fontSize: "16px", outline: "none" }}
                value={form.telefone || ""}
                onChange={(e) => setForm({ ...form, telefone: e.target.value })}
              />
            </div>
          </div>

          <div className="cl-modal-footer" style={{ marginTop: 24, display: "flex", justifyContent: "flex-end", gap: 12 }}>
            <button 
              type="button"
              className="btn btn-secondary" 
              onClick={onClose} 
              style={{ padding: "10px 20px", borderRadius: "8px", border: "1px solid #333", background: "transparent", color: "#fff", cursor: "pointer", fontWeight: "500" }}
            >
              Cancelar
            </button>
            <button 
              type="submit"
              className="btn btn-primary" 
              disabled={saving}
              style={{ padding: "10px 24px", borderRadius: "8px", border: "none", color: "#fff", cursor: "pointer", fontWeight: "600", background: "#2563eb" }}
            >
              {saving ? "Salvando..." : "Salvar Cliente"}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
