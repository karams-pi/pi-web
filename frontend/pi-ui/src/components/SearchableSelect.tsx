
import { useState, useEffect, useRef } from "react";

export interface SearchableSelectOption {
  value: string | number;
  label: string;
}

interface SearchableSelectProps {
  value: string | number;
  onChange: (value: any) => void; // any para aceitar string ou number dependendo do value
  options: SearchableSelectOption[];
  placeholder?: string;
  className?: string; 
}

export function SearchableSelect({
  value,
  onChange,
  options,
  placeholder = "Selecione...",
}: SearchableSelectProps) {
  const [isOpen, setIsOpen] = useState(false);
  const [search, setSearch] = useState("");
  const wrapperRef = useRef<HTMLDivElement>(null);

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

  const selectedItem = options.find((opt) => String(opt.value) === String(value));

  const filteredOptions = options.filter((opt) => {
    return opt.label.toLowerCase().includes(search.toLowerCase());
  });

  return (
    <div className="cl-select-wrapper" ref={wrapperRef} style={{ position: "relative", width: "100%" }}>
      <div
        className="cl-select"
        style={{ 
          cursor: "pointer", 
          display: "flex", 
          alignItems: "center", 
          justifyContent: "space-between",
          minHeight: "38px" 
        }}
        onClick={() => {
          setIsOpen(!isOpen);
          if (!isOpen) setTimeout(() => document.getElementById(`search-input-${placeholder}`)?.focus(), 100);
        }}
      >
        <span style={{ whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>
          {selectedItem ? selectedItem.label : placeholder}
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
            background: "#1e1e2d",
            border: "1px solid #333",
            borderRadius: "4px",
            boxShadow: "0 4px 12px rgba(0,0,0,0.5)",
            marginTop: "4px",
            maxHeight: "300px",
            display: "flex",
            flexDirection: "column",
          }}
        >
          <div style={{ padding: "8px", borderBottom: "1px solid #333" }}>
            <input
              id={`search-input-${placeholder}`}
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
                Nenhum resultado
              </div>
            ) : (
              filteredOptions.map((opt) => (
                <div
                  key={opt.value}
                  style={{
                    padding: "8px 12px",
                    cursor: "pointer",
                    borderBottom: "1px solid #2a2a35",
                    fontSize: "13px",
                    background: String(opt.value) === String(value) ? "#29293d" : "transparent",
                    color: String(opt.value) === String(value) ? "#fff" : "#ccc",
                  }}
                  onClick={() => {
                    onChange(opt.value);
                    setIsOpen(false);
                    setSearch("");
                  }}
                  onMouseEnter={(e) => (e.currentTarget.style.background = "#2a2a35")}
                  onMouseLeave={(e) => (e.currentTarget.style.background = String(opt.value) === String(value) ? "#29293d" : "transparent")}
                >
                  {opt.label}
                </div>
              ))
            )}
          </div>
        </div>
      )}
    </div>
  );
}
