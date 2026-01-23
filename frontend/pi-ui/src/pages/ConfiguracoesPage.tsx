import { useEffect, useState } from "react";
import {
  type Configuracao,
  createConfig,
  getLatestConfig,
} from "../api/configuracoes";
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
  const [displayValue, setDisplayValue] = useState("");

  // Update display value when the prop value changes
  useEffect(() => {
    // Format the number to a locale string with 2 decimal places
    // If value is 0, we can show "0,00" or empty. Let's show "0,00".
    const formatted = (value || 0).toLocaleString("pt-BR", {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    });
    setDisplayValue(formatted);
  }, [value]);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    let inputValue = e.target.value;

    // Remove everything that is not a digit
    const digits = inputValue.replace(/\D/g, "");

    // Convert to number and divide by 100 to get decimal position
    const numberValue = parseInt(digits || "0", 10) / 100;

    // Propagate changes up
    onChange(name, numberValue);

    // Update local state is handled by the useEffect above reacting to the prop change
    // effectively enforcing the mask, but to make UI snappy we could update here too
    // but the useEffect approach guarantees sync with parent state.
  };

  return (
    <div className="cfg-field">
      <label className="cfg-label">{label}</label>
      <div className="cfg-input-wrapper">
        {prefix && <span className="cfg-currency-symbol">{prefix}</span>}
        <input
          type="text"
          className={`cfg-input ${prefix ? "has-symbol" : ""}`}
          value={displayValue}
          onChange={handleChange}
          onFocus={(e) => e.target.select()} // Auto-select on focus for easier editing
          placeholder="0,00"
        />
        {suffix && <span style={{position: "absolute", right: 12, color: "var(--cfg-muted)", fontSize: 13}}>{suffix}</span>}
      </div>
    </div>
  );
};

// --- Page Component ---

// Initial state for form when no config exists
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
      // It's okay if not found, we just start with defaults
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
      // Create new config (history)
      const newConfig = await createConfig(formData);
      setCurrentConfig(newConfig);
      
      // Show success message
      setMessage({
        type: "success",
        text: "Configurações salvas e histórico atualizado com sucesso!",
      });
      
      // Auto-hide message after 3 seconds
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

        {/* Custos FCA Section */}
        <section className="cfg-section">
          <div className="cfg-section-header">
            <svg width="24" height="24" fill="none" viewBox="0 0 24 24" stroke="#8b5cf6">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <h3 className="cfg-section-title">Custos FCA</h3>
          </div>
          <div className="cfg-grid">
            <DecimalInput
              label="Frete Rod. Fronteira"
              name="valorFCAFreteRodFronteira"
              value={formData.valorFCAFreteRodFronteira}
              onChange={handleDecimalChange}
              prefix="R$"
            />
            <DecimalInput
              label="Despesas FCA"
              name="valorDespesasFCA"
              value={formData.valorDespesasFCA}
              onChange={handleDecimalChange}
              prefix="R$"
            />
          </div>
        </section>

        {/* Custos FOB Section */}
        <section className="cfg-section">
          <div className="cfg-section-header">
             <svg width="24" height="24" fill="none" viewBox="0 0 24 24" stroke="#10b981">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <h3 className="cfg-section-title">Custos FOB</h3>
          </div>
          <div className="cfg-grid">
            <DecimalInput
              label="Frete Porto Paranaguá"
              name="valorFOBFretePortoParanagua"
              value={formData.valorFOBFretePortoParanagua}
              onChange={handleDecimalChange}
              prefix="R$"
            />
            <DecimalInput
              label="Desp. Port. Reg. Doc"
              name="valorFOBDespPortRegDoc"
              value={formData.valorFOBDespPortRegDoc}
              onChange={handleDecimalChange}
              prefix="R$"
            />
            <DecimalInput
              label="Desp. Aduaneiro"
              name="valorFOBDespDespacAduaneiro"
              value={formData.valorFOBDespDespacAduaneiro}
              onChange={handleDecimalChange}
              prefix="R$"
            />
            <DecimalInput
              label="Desp. Courier"
              name="valorFOBDespCourier"
              value={formData.valorFOBDespCourier}
              onChange={handleDecimalChange}
              prefix="R$"
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
    </div>
  );
}
