import { useEffect, useState } from "react";
import {
  type Configuracao,
  createConfig,
  getLatestConfig,
} from "../api/configuracoes";
import { createConfiguracoesFreteItem, deleteConfiguracoesFreteItem, getConfiguracoesFreteItemByFrete, updateConfiguracoesFreteItem } from "../api/configuracoesFreteItem";
import { createFreteItem, deleteFreteItem, updateFreteItem } from "../api/freteItens";
import type { ConfiguracoesFreteItem } from "../api/types";
import "./ConfiguracoesPage.css";

// --- Components ---

interface DecimalInputProps {
  label: string;
  name: string;
  value: number;
  onChange: (name: string, value: number) => void;
  prefix?: string;
  suffix?: string;
}

const DecimalInput = ({
  label,
  name,
  value,
  onChange,
  prefix,
  suffix,
}: DecimalInputProps) => {
  const [localValue, setLocalValue] = useState("");
  const [isFocused, setIsFocused] = useState(false);

  useEffect(() => {
    if (!isFocused) {
      const formatted = (value || 0).toLocaleString("pt-BR", {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
      });
      setLocalValue(formatted);
    }
  }, [value, isFocused]);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newVal = e.target.value;
    
    // Allow digits, commas, dots only
    if (!/^[\d.,]*$/.test(newVal)) return;
    
    setLocalValue(newVal);

    // Try to parse number for parent update
    // Remove thousand separators (dots) and replace decimal separator (comma) with dot
    const cleanVal = newVal.replace(/\./g, "").replace(",", ".");
    const numVal = parseFloat(cleanVal);
    
    if (!isNaN(numVal)) {
      onChange(name, numVal);
    }
  };

  const handleBlur = () => {
    setIsFocused(false);
    // On blur, force the formatted display of the current prop value
    const formatted = (value || 0).toLocaleString("pt-BR", {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    });
    setLocalValue(formatted);
  };

  const handleFocus = (e: React.FocusEvent<HTMLInputElement>) => {
    setIsFocused(true);
    e.target.select();
  };

  return (
    <div className="cfg-field">
      <label className="cfg-label">{label}</label>
      <div className="cfg-input-wrapper">
        {prefix && <span className="cfg-currency-symbol">{prefix}</span>}
        <input
          type="text"
          className={`cfg-input ${prefix ? "has-symbol" : ""}`}
          value={localValue}
          onChange={handleChange}
          onFocus={handleFocus}
          onBlur={handleBlur}
          placeholder="0,00"
        />
        {suffix && <span style={{position: "absolute", right: 12, color: "var(--cfg-muted)", fontSize: 13}}>{suffix}</span>}
      </div>
    </div>
  );
};

// Freight Modal Component
interface FreightModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSave: (nome: string, valor: number) => Promise<void>;
  initialNome?: string;
  initialValor?: number;
  title: string;
}

const FreightModal = ({ isOpen, onClose, onSave, initialNome = "", initialValor = 0, title }: FreightModalProps) => {
  const [nome, setNome] = useState(initialNome);
  const [valor, setValor] = useState(initialValor);
  const [saving, setSaving] = useState(false);

  // Update effect to reset or set initial values when modal opens
  useEffect(() => {
    if (isOpen) {
      setNome(initialNome);
      setValor(initialValor || 0);
    }
  }, [isOpen, initialNome, initialValor]);

  if (!isOpen) return null;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!nome) return alert("Preencha o nome");
    setSaving(true);
    try {
      await onSave(nome, valor);
      onClose();
    } catch (e: unknown) {
      console.error(e);
      alert("Erro ao salvar item");
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="modalOverlay" onMouseDown={onClose}>
      <div className="modalCard" style={{ maxWidth: 400 }} onMouseDown={e => e.stopPropagation()}>
        <div className="modalHeader">
          <h3 className="modalTitle">{title}</h3>
          <button className="btn btn-sm" onClick={onClose}>Fechar</button>
        </div>
        <form onSubmit={handleSubmit}>
            <div className="modalBody">
                <div style={{ marginBottom: 12 }}>
                    <label style={{ display: 'block', marginBottom: 4, fontWeight: 500, color: '#e5e7eb' }}>Nome</label>
                    <input 
                        className="cl-input" 
                        value={nome} 
                        onChange={e => setNome(e.target.value)} 
                        autoFocus
                    />
                </div>
                <div style={{ marginBottom: 12 }}>
                    <DecimalInput 
                        label="Valor" 
                        name="valor" 
                        value={valor} 
                        onChange={(_, v) => setValor(v)} 
                        prefix="R$"
                    />
                </div>
            </div>
            <div style={{ padding: 16, borderTop: '1px solid #334155', display: 'flex', justifyContent: 'flex-end', gap: 8 }}>
                 <button type="button" className="btn btn-secondary" onClick={onClose} disabled={saving}>Cancelar</button>
                 <button type="submit" className="btn btn-primary" disabled={saving}>
                    {saving ? "Salvando..." : "Salvar"}
                 </button>
            </div>
        </form>
      </div>
    </div>
  );
};


// Freight Grid Component
interface FreightGridProps {
  title: string;
  color: string;
  idFrete: number;
}

const FreightGrid = ({ title, color, idFrete }: FreightGridProps) => {
  const [items, setItems] = useState<(ConfiguracoesFreteItem & { freteItem?: { nome: string } })[]>([]);
  const [loading, setLoading] = useState(true);
  
  // Modal State
  const [modalOpen, setModalOpen] = useState(false);
  const [editingItem, setEditingItem] = useState<(ConfiguracoesFreteItem & { freteItem?: { nome: string } }) | null>(null);

  useEffect(() => {
    loadItems();
  }, [idFrete]);

  const loadItems = async () => {
    try {
      setLoading(true);
      const data = await getConfiguracoesFreteItemByFrete(idFrete);
      setItems(data);
    } catch (error) {
      console.error(`[FreightGrid] Erro ao carregar itens de frete ${title}:`, error);
      setItems([]); 
    } finally {
      setLoading(false);
    }
  };

  const handleToggleDesconsidera = async (item: ConfiguracoesFreteItem) => {
    try {
      await updateConfiguracoesFreteItem(item.id, {
        ...item,
        flDesconsidera: !item.flDesconsidera,
      });
      await loadItems();
    } catch (error) {
      console.error("Erro ao atualizar item:", error);
    }
  };

  // Add
  const handleAdd = () => {
      setEditingItem(null);
      setModalOpen(true);
  };

  // Edit
  const handleEdit = (item: ConfiguracoesFreteItem & { freteItem?: { nome: string } }) => {
      setEditingItem(item);
      setModalOpen(true);
  };

  // Delete
  const handleDelete = async (item: ConfiguracoesFreteItem & { freteItem?: { nome: string } }) => {
      if (!confirm(`Remover item "${item.freteItem?.nome}"?`)) return;
      try {
          // Delete Item de Configuração first
          await deleteConfiguracoesFreteItem(item.id);
          // Try to delete definition if possible
          await deleteFreteItem(item.idFreteItem).catch(e => console.warn("Could not delete definition", e));
          
          await loadItems();
      } catch (e) {
          alert("Erro ao remover item");
          console.error(e);
      }
  };

  // Save Modal
  const onSaveModal = async (nome: string, valor: number) => {
      if (editingItem) {
          // Update
          // 1. Update Definition Name if changed
          if (editingItem.freteItem && editingItem.freteItem.nome !== nome) {
               await updateFreteItem(editingItem.idFreteItem, { 
                   idFrete: idFrete,
                   nome: nome 
               });
          }
          // 2. Update Value
          await updateConfiguracoesFreteItem(editingItem.id, {
              ...editingItem,
              valor: valor
          });
      } else {
          // Create
          // 1. Create Definition
          const newItem = await createFreteItem({ idFrete, nome });
          // 2. Create Config Value
          await createConfiguracoesFreteItem({
              idFreteItem: newItem.id,
              valor: valor,
              flDesconsidera: false
          });
      }
      await loadItems();
  };


  const fmt = (n: number) => n.toLocaleString("pt-BR", { minimumFractionDigits: 2, maximumFractionDigits: 2 });

  if (loading) {
    return (
      <section className="cfg-section">
        <div className="cfg-section-header">
          <svg width="24" height="24" fill="none" viewBox="0 0 24 24" stroke={color}>
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <h3 className="cfg-section-title">{title}</h3>
        </div>
        <div style={{ padding: 20, textAlign: "center", color: "var(--cfg-muted)" }}>
          Carregando...
        </div>
      </section>
    );
  }

  return (
    <section className="cfg-section" style={{ marginBottom: 24 }}>
      <div className="cfg-section-header" style={{ justifyContent: 'space-between' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            <svg width="24" height="24" fill="none" viewBox="0 0 24 24" stroke={color}>
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <h3 className="cfg-section-title">{title}</h3>
        </div>
        <button className="btn btn-sm btn-primary" onClick={handleAdd} style={{ fontSize: 12 }}>
            + Adicionar
        </button>
      </div>
      
      {items.length === 0 ? (
        <div style={{ padding: 20, textAlign: "center", color: "var(--cfg-muted)" }}>
          Nenhum item configurado para este tipo de frete.
        </div>
      ) : (
        <div style={{ overflowX: "auto" }}>
          <table style={{ width: "100%", borderCollapse: "collapse" }}>
            <thead>
              <tr>
                <th style={{ textAlign: "left", borderBottom: "1px solid #ddd", padding: 8, fontSize: 13, fontWeight: 600, color: "var(--cfg-muted)" }}>
                  Item
                </th>
                <th style={{ textAlign: "right", borderBottom: "1px solid #ddd", padding: 8, fontSize: 13, fontWeight: 600, color: "var(--cfg-muted)" }}>
                  Valor
                </th>
                <th style={{ textAlign: "center", borderBottom: "1px solid #ddd", padding: 8, fontSize: 13, fontWeight: 600, color: "var(--cfg-muted)" }}>
                  Desc.
                </th>
                <th style={{ textAlign: "right", borderBottom: "1px solid #ddd", padding: 8, fontSize: 13, fontWeight: 600, color: "var(--cfg-muted)", width: 80 }}>
                   Ações
                </th>
              </tr>
            </thead>
            <tbody>
              {items.map((item) => (
                <tr key={item.id}>
                  <td style={{ borderBottom: "1px solid #eee", padding: 8, fontSize: 14 }}>
                    {(item as any).freteItem?.nome || `Item #${item.idFreteItem}`}
                  </td>
                  <td style={{ borderBottom: "1px solid #eee", padding: 8, fontSize: 14, textAlign: "right" }}>
                    R$ {fmt(item.valor)}
                  </td>
                  <td style={{ borderBottom: "1px solid #eee", padding: 8, fontSize: 14, textAlign: "center" }}>
                    <input
                      type="checkbox"
                      checked={item.flDesconsidera}
                      onChange={() => handleToggleDesconsidera(item)}
                      style={{ cursor: "pointer", width: 18, height: 18 }}
                      title="Desconsiderar este custo?"
                    />
                  </td>
                  <td style={{ borderBottom: "1px solid #eee", padding: 8, fontSize: 14, textAlign: "right" }}>
                      <div style={{ display: 'flex', gap: 8, justifyContent: 'flex-end' }}>
                        <button 
                            className="cfg-action-btn edit" 
                            onClick={() => handleEdit(item)}
                            title="Editar"
                        >
                            <svg width="16" height="16" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                            </svg>
                        </button>
                        <button 
                            className="cfg-action-btn delete" 
                            onClick={() => handleDelete(item)}
                            title="Excluir"
                        >
                            <svg width="16" height="16" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                            </svg>
                        </button>
                      </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {modalOpen && (
          <FreightModal 
             isOpen={modalOpen}
             onClose={() => setModalOpen(false)}
             onSave={onSaveModal}
             title={editingItem ? "Editar Item" : "Novo Item"}
             initialNome={editingItem?.freteItem?.nome}
             initialValor={editingItem?.valor}
          />
      )}
    </section>
  );
};

// --- Page Component ---

const initialFormState = {
  valorReducaoDolar: 0,
  valorPercImposto: 0,
  percentualComissao: 0,
  percentualGordura: 0,
  valorFCAFreteRodFronteira: 0,
  valorDespesasFCA: 0,
  valorFOBFretePortoParanagua: 0,
  valorFOBDespPortRegDoc: 0,
  valorFOBDespDespacAduaneiro: 0,
  valorFOBDespCourier: 0,
};

export default function ConfiguracoesPage() {
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [currentConfig, setCurrentConfig] = useState<Configuracao | null>(null);
  const [formData, setFormData] = useState(initialFormState);
  const [message, setMessage] = useState<{
    type: "success" | "error";
    text: string;
  } | null>(null);

  useEffect(() => {
    loadConfig();
  }, []);

  const loadConfig = async () => {
    try {
      setLoading(true);
      const config = await getLatestConfig();
      if (config) {
        setCurrentConfig(config);
        setFormData({
          valorReducaoDolar: config.valorReducaoDolar,
          valorPercImposto: config.valorPercImposto,
          percentualComissao: config.percentualComissao,
          percentualGordura: config.percentualGordura,
          valorFCAFreteRodFronteira: config.valorFCAFreteRodFronteira,
          valorDespesasFCA: config.valorDespesasFCA,
          valorFOBFretePortoParanagua: config.valorFOBFretePortoParanagua,
          valorFOBDespPortRegDoc: config.valorFOBDespPortRegDoc,
          valorFOBDespDespacAduaneiro: config.valorFOBDespDespacAduaneiro,
          valorFOBDespCourier: config.valorFOBDespCourier,
        });
      }
    } catch (error) {
      console.error("Erro ao carregar configurações", error);
    } finally {
      setLoading(false);
    }
  };

  const handleDecimalChange = (name: string, value: number) => {
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);
    setMessage(null);

    try {
      const newConfig = await createConfig(formData);
      setCurrentConfig(newConfig);
      
      setMessage({
        type: "success",
        text: "Configurações salvas e histórico atualizado com sucesso!",
      });
      
      setTimeout(() => setMessage(null), 3000);

    } catch (error) {
      console.error("Erro ao salvar configurações", error);
      setMessage({ type: "error", text: "Erro ao salvar configurações." });
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return (
      <div className="cfg-page">
        <div style={{ padding: 40, textAlign: "center", color: "var(--cfg-muted)" }}>
          Carregando configurações...
        </div>
      </div>
    );
  }

  return (
    <div className="cfg-page">
      <div className="cfg-header">
        <h2 className="cfg-title">Configurações do Sistema</h2>
        <p className="cfg-subtitle">
          Defina os valores padrão utilizados nos cálculos do sistema. As alterações geram um novo registro histórico para auditoria.
        </p>
        
        {currentConfig && (
             <div className="cfg-last-update" style={{ marginTop: 8 }}>
                Última atualização: {new Date(currentConfig.dataConfig).toLocaleDateString()} às {new Date(currentConfig.dataConfig).toLocaleTimeString()}
             </div>
        )}
      </div>

      {message && (
        <div className={`cfg-message ${message.type}`}>
          {message.type === "success" ? (
            <svg width="20" height="20" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
            </svg>
          ) : (
            <svg width="20" height="20" fill="none" viewBox="0 0 24 24" stroke="currentColor">
               <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          )}
          {message.text}
        </div>
      )}

      <form onSubmit={handleSubmit} className="cfg-container">
        
        {/* Taxas Section */}
        <section className="cfg-section">
          <div className="cfg-section-header">
             <svg width="24" height="24" fill="none" viewBox="0 0 24 24" stroke="#3b82f6">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
             </svg>
             <h3 className="cfg-section-title">Taxas e Percentuais</h3>
          </div>
          <div className="cfg-grid">
            <DecimalInput
              label="Redução Dólar"
              name="valorReducaoDolar"
              value={formData.valorReducaoDolar}
              onChange={handleDecimalChange}
              prefix="R$"
            />
            <DecimalInput
              label="% Imposto"
              name="valorPercImposto"
              value={formData.valorPercImposto}
              onChange={handleDecimalChange}
              suffix="%"
            />
            <DecimalInput
              label="% Comissão"
              name="percentualComissao"
              value={formData.percentualComissao}
              onChange={handleDecimalChange}
              suffix="%"
            />
            <DecimalInput
              label="% Gordura"
              name="percentualGordura"
              value={formData.percentualGordura}
              onChange={handleDecimalChange}
              suffix="%"
            />
          </div>
        </section>

        {/* Footer Actions */}
        <div className="cfg-actions">
          <button type="submit" className="cfg-btn-save" disabled={saving}>
            {saving ? (
                <>Salvando...</>
            ) : (
                <>
                <svg width="20" height="20" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                </svg>
                Salvar Configurações
                </>
            )}
          </button>
        </div>

      </form>

      {/* Freight Grids - Outside form */}
      <div style={{ marginTop: 32 }}>
        <FreightGrid title="Custos FOB" color="#10b981" idFrete={1} />
        <FreightGrid title="Custos FCA" color="#8b5cf6" idFrete={2} />
        <FreightGrid title="Custos CIF" color="#f59e0b" idFrete={3} />
      </div>
    </div>
  );
}
