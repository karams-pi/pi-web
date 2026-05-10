
import React from "react";
import { useNavigate } from "react-router-dom";
import { FileText, Calculator, ArrowRight, Package, Ship } from "lucide-react";
import "./ModuleSelector.css";

export default function ModuleSelector() {
  const navigate = useNavigate();

  return (
    <div className="selector-container">
      <div className="selector-header">
        <img src="/logo-seawise.png" alt="Seawyse" className="selector-logo" />
        <h1 className="selector-title">Portal de Gestão Logística</h1>
        <p className="selector-subtitle">Selecione o módulo que deseja acessar para continuar</p>
      </div>

      <div className="selector-grid">
        {/* Card Proforma Invoice */}
        <div className="selector-card pi-card" onClick={() => navigate("/pi")}>
          <div className="card-icon-wrapper">
            <Ship size={48} className="card-icon" />
          </div>
          <div className="card-content">
            <h2 className="card-title">Proforma Invoice</h2>
            <p className="card-description">
              Gestão de exportação, criação de PIs, listas de preços e controle de módulos e tecidos.
            </p>
            <div className="card-footer">
              <span>Acessar Módulo</span>
              <ArrowRight size={18} />
            </div>
          </div>
          <div className="card-badge">Exportação</div>
        </div>

        {/* Card EDC */}
        <div className="selector-card edc-card" onClick={() => navigate("/edc")}>
          <div className="card-icon-wrapper">
            <Calculator size={48} className="card-icon" />
          </div>
          <div className="card-content">
            <h2 className="card-title">EDC - Estimativa de Custos</h2>
            <p className="card-description">
              Cálculo de custos de importação, simulações tributárias e gestão de EDC por Proforma.
            </p>
            <div className="card-footer">
              <span>Acessar Módulo</span>
              <ArrowRight size={18} />
            </div>
          </div>
          <div className="card-badge edc">Importação</div>
        </div>
      </div>

      <div className="selector-footer">
        <p>© {new Date().getFullYear()} Seawyse - Todos os direitos reservados</p>
      </div>
    </div>
  );
}
