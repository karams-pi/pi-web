import { useState, useEffect, useLayoutEffect, useRef, useCallback } from "react";
import { createPortal } from "react-dom";
import type { Modulo } from "../api/types";

interface ModuloSelectProps {
  value: string; // ID do módulo
  onChange: (value: string) => void;
  options: Modulo[];
  mapFornecedor: Map<number, string>;
  mapCategoria: Map<number, string>;
  mapMarca: Map<number, string>;
  mapTecido?: Map<number, string>;
  placeholder?: string;
  calcExw?: (valor: number, idFornecedor: number) => number | undefined;
}

export function ModuloSelect({
  value,
  onChange,
  options,
  mapFornecedor,
  mapCategoria,
  mapMarca,
  mapTecido,
  placeholder = "Buscar módulo...",
  calcExw,
}: ModuloSelectProps) {
  const [isOpen, setIsOpen] = useState(false);
  const [search, setSearch] = useState("");
  const [dropdownRect, setDropdownRect] = useState<{ top: number; left: number; width: number }>({
    top: 0,
    left: 0,
    width: 280
  });
  const wrapperRef = useRef<HTMLDivElement>(null);
  const dropdownRef = useRef<HTMLDivElement>(null);

  const updateDropdownPosition = useCallback(() => {
    if (wrapperRef.current) {
      const rect = wrapperRef.current.getBoundingClientRect();
      setDropdownRect({
        top: rect.bottom + 4,
        left: rect.left,
        width: rect.width
      });
    }
  }, []);

  useLayoutEffect(() => {
    if (!isOpen) return;
    updateDropdownPosition();
    window.addEventListener("scroll", updateDropdownPosition, true);
    window.addEventListener("resize", updateDropdownPosition);
    return () => {
      window.removeEventListener("scroll", updateDropdownPosition, true);
      window.removeEventListener("resize", updateDropdownPosition);
    };
  }, [isOpen, updateDropdownPosition]);

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      const target = event.target as Node;
      if (
        wrapperRef.current &&
        !wrapperRef.current.contains(target) &&
        (!dropdownRef.current || !dropdownRef.current.contains(target))
      ) {
        setIsOpen(false);
      }
    }
    document.addEventListener("mousedown", handleClickOutside);
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, []);

  const selectedItem = options.find((opt) => String(opt.id) === value);

  const getLabel = (opt: Modulo) => {
    const forn = mapFornecedor.get(opt.idFornecedor) || "";
    const cat = mapCategoria.get(opt.idCategoria) || "";
    const marc = mapMarca.get(opt.idMarca) || "";
    const mod = opt.descricao;

    // Dimensões
    const l = opt.largura || 0;
    const p = opt.profundidade || 0;
    const a = opt.altura || 0;

    return `${forn} > ${cat} > ${marc} > ${mod} (${l}x${p}x${a})`;
  };

  const filteredOptions = options.filter((opt) => {
    const term = search.toLowerCase();
    const label = getLabel(opt).toLowerCase();
    return label.includes(term);
  });

  const currentLabel = selectedItem ? getLabel(selectedItem) : placeholder;

  return (
    <div className="mt-select-wrapper" ref={wrapperRef} style={{ position: "relative", flex: 1 }}>
      <div
        className="cl-select"
        style={{
          cursor: "pointer",
          display: "flex",
          alignItems: "center",
          justifyContent: "space-between",
          minHeight: "38px",
          background: "var(--bg-input, #13131f)",
          borderColor: "var(--border-input, #333)",
        }}
        onClick={() => {
          setIsOpen(!isOpen);
          if (!isOpen) setTimeout(() => document.getElementById("mod-search-input")?.focus(), 100);
        }}
      >
        <span style={{ whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>
          {currentLabel}
        </span>
        <span style={{ fontSize: "10px", marginLeft: 8 }}>▼</span>
      </div>

      {isOpen &&
        createPortal(
          <div
            ref={dropdownRef}
            style={{
              position: "fixed",
              top: `${dropdownRect.top}px`,
              left: `${dropdownRect.left}px`,
              width: `${dropdownRect.width}px`,
              minWidth: "280px",
              zIndex: 99999,
              background: "#1e1e2d",
              border: "1px solid #333",
              borderRadius: "4px",
              boxShadow: "0 4px 12px rgba(0,0,0,0.5)",
              maxHeight: "400px",
              display: "flex",
              flexDirection: "column",
            }}
          >
          <div style={{ padding: "8px", borderBottom: "1px solid #333" }}>
            <input
              id="mod-search-input"
              type="text"
              placeholder="Buscar..."
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
              onClick={(e) => e.stopPropagation()}
            />
          </div>

          <div style={{ overflowY: "auto", flex: 1 }}>
            {filteredOptions.length === 0 ? (
              <div style={{ padding: "12px", color: "#888", textAlign: "center" }}>
                Nenhum resultado encontrado
              </div>
            ) : (
              filteredOptions.map((opt) => {
                const forn = mapFornecedor.get(opt.idFornecedor) || "?";
                const cat = mapCategoria.get(opt.idCategoria) || "?";
                const marc = mapMarca.get(opt.idMarca) || "?";

                return (
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
                      {forn} &gt; {cat} &gt; {marc}
                    </div>
                    <div>
                      {opt.descricao}
                      <span style={{ color: "#aaa", marginLeft: 6, fontSize: "0.9em" }}>
                        ({opt.largura} x {opt.profundidade} x {opt.altura})
                      </span>
                    </div>
                    {opt.modulosTecidos && opt.modulosTecidos.length > 0 && (
                      <div style={{ marginTop: 4, paddingLeft: 8, fontSize: "0.85em", color: "#888", borderLeft: "2px solid #333" }}>
                        {opt.modulosTecidos.map((mt) => {
                          const nomeTecido = mt.tecido?.nome || mapTecido?.get(mt.idTecido) || `#${mt.idTecido}`;
                          return (
                            <div key={mt.id} style={{ display: "flex", justifyContent: "space-between" }}>
                              <span>{nomeTecido}</span>
                              <span>
                                {calcExw && (
                                  <span style={{ color: "#10b981", marginRight: 10, fontWeight: "bold" }}>
                                    {(() => {
                                      const val = calcExw(mt.valorTecido, opt.idFornecedor);
                                      return val === undefined ? "..." : `$ ${val.toLocaleString("pt-BR", { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
                                    })()}
                                  </span>
                                )}
                                <span style={{ color: "#ccc" }}>
                                  R$ {mt.valorTecido.toLocaleString("pt-BR", { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                                </span>
                              </span>
                            </div>
                          );
                        })}
                      </div>
                    )}
                  </div>
                );
              })
            )}
          </div>
        </div>,
        document.body
      )}
    </div>
  );
}
