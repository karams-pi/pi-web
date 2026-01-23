
import { useState, useEffect, useRef } from "react";
import type { ModuloTecido } from "../api/types";

interface ModuloTecidoSelectProps {
  value: string;
  onChange: (value: string) => void;
  options: ModuloTecido[];
  placeholder?: string;
  className?: string; // Para manter compatibilidade com classes CSS existentes
}

export function ModuloTecidoSelect({
  value,
  onChange,
  options,
  placeholder = "Selecione...",
}: ModuloTecidoSelectProps) {
  const [isOpen, setIsOpen] = useState(false);
  const [search, setSearch] = useState("");
  const wrapperRef = useRef<HTMLDivElement>(null);

  // Fecha o dropdown ao clicar fora
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (wrapperRef.current && !wrapperRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    }
    document.addEventListener("mousedown", handleClickOutside);
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, []);

  // Encontra o item selecionado para exibir no botão quando fechado
  const selectedItem = options.find((opt) => String(opt.id) === value);

  // Filtra as opções com base na busca
  const filteredOptions = options.filter((opt) => {
    const term = search.toLowerCase();
    const fornecedor = opt.modulo?.fornecedor?.nome?.toLowerCase() || "";
    const categoria = opt.modulo?.categoria?.nome?.toLowerCase() || "";
    const marca = opt.modulo?.marca?.nome?.toLowerCase() || "";
    const modulo = opt.modulo?.descricao?.toLowerCase() || "";
    const tecido = opt.tecido?.nome?.toLowerCase() || "";
    
    // Busca em qualquer parte da descrição
    return (
      fornecedor.includes(term) ||
      categoria.includes(term) ||
      marca.includes(term) ||
      modulo.includes(term) ||
      tecido.includes(term)
    );
  });

  // Função para formatar a label do item
  const getLabel = (opt: ModuloTecido) => {
    const forn = opt.modulo?.fornecedor?.nome || "?";
    const cat = opt.modulo?.categoria?.nome || "?";
    const marc = opt.modulo?.marca?.nome || "?";
    const mod = opt.modulo?.descricao || "?";
    const tec = opt.tecido?.nome || "?";
    const val = opt.valorTecido.toLocaleString("pt-BR", { minimumFractionDigits: 2 });
    
    return `${forn} > ${cat} > ${marc} > ${mod} > ${tec} - R$ ${val}`;
  };

  const currentLabel = selectedItem ? getLabel(selectedItem) : placeholder;

  return (
    <div className="mt-select-wrapper" ref={wrapperRef} style={{ position: "relative", width: "100%" }}>
      {/* Botão principal que abre o dropdown */}
      <div
        className="cl-select" // Reutiliza estilo existente
        style={{ 
          cursor: "pointer", 
          display: "flex", 
          alignItems: "center", 
          justifyContent: "space-between",
          minHeight: "38px" 
        }}
        onClick={() => {
          setIsOpen(!isOpen);
          // Foca no input de busca ao abrir
          if (!isOpen) setTimeout(() => document.getElementById("mt-search-input")?.focus(), 100);
        }}
      >
        <span style={{ whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>
          {currentLabel}
        </span>
        <span style={{ fontSize: "10px", marginLeft: 8 }}>▼</span>
      </div>

      {isOpen && (
        <div
          style={{
            position: "absolute",
            top: "100%",
            left: 0,
            right: 0,
            zIndex: 1000,
            background: "#1e1e2d", // Cor escura do tema
            border: "1px solid #333",
            borderRadius: "4px",
            boxShadow: "0 4px 12px rgba(0,0,0,0.5)",
            marginTop: "4px",
            maxHeight: "300px",
            display: "flex",
            flexDirection: "column",
          }}
        >
          {/* Input de Busca */}
          <div style={{ padding: "8px", borderBottom: "1px solid #333" }}>
            <input
              id="mt-search-input"
              type="text"
              placeholder="Buscar categoria, módulo ou tecido..."
              style={{
                width: "100%",
                padding: "8px",
                background: "#13131f",
                border: "1px solid #444",
                color: "#e0e0e0",
                borderRadius: "4px",
                outline: "none",
              }}
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              onClick={(e) => e.stopPropagation()} // Evita fechar ao clicar no input
            />
          </div>

          {/* Lista de Opções */}
          <div style={{ overflowY: "auto", flex: 1 }}>
            {filteredOptions.length === 0 ? (
              <div style={{ padding: "12px", color: "#888", textAlign: "center" }}>
                Nenhum resultado encontrado
              </div>
            ) : (
              filteredOptions.map((opt) => (
                <div
                  key={opt.id}
                  style={{
                    padding: "8px 12px",
                    cursor: "pointer",
                    borderBottom: "1px solid #2a2a35",
                    fontSize: "13px",
                    background: String(opt.id) === value ? "#29293d" : "transparent",
                    color: String(opt.id) === value ? "#fff" : "#ccc",
                  }}
                  onClick={() => {
                    onChange(String(opt.id));
                    setIsOpen(false);
                    setSearch("");
                  }}
                  onMouseEnter={(e) => (e.currentTarget.style.background = "#2a2a35")}
                  onMouseLeave={(e) => (e.currentTarget.style.background = String(opt.id) === value ? "#29293d" : "transparent")}
                >
                  <div style={{ fontWeight: "bold", marginBottom: 2, color: "#4f9eff" }}>
                    {opt.modulo?.fornecedor?.nome} &gt; {opt.modulo?.categoria?.nome} &gt; {opt.modulo?.marca?.nome}
                  </div>
                  <div>
                    {opt.modulo?.descricao} &gt; <span style={{ color: "#eee" }}>{opt.tecido?.nome}</span>
                  </div>
                  <div style={{ fontSize: "11px", color: "#888", marginTop: 2 }}>
                    Valor Tecido: R$ {opt.valorTecido.toLocaleString("pt-BR", { minimumFractionDigits: 2 })}
                  </div>
                </div>
              ))
            )}
          </div>
        </div>
      )}
    </div>
  );
}
