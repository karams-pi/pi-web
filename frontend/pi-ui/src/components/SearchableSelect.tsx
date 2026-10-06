import React, { useState, useEffect, useRef, useMemo } from "react";
import { Search, ChevronDown, X, Check } from "lucide-react";

export interface SearchableSelectOption {
  value: string | number;
  label: string;
  subtitle?: string;
  badge?: string;
  searchTerms?: string;
  disabled?: boolean;
}

interface SearchableSelectProps {
  value: string | number | null | undefined;
  onChange: (value: any) => void;
  options: SearchableSelectOption[];
  placeholder?: string;
  className?: string;
  disabled?: boolean;
  style?: React.CSSProperties;
  dropdownWidth?: string | number;
}

function normalizeText(text: string | undefined | null): string {
  if (!text) return "";
  return text
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .trim();
}

export function SearchableSelect({
  value,
  onChange,
  options = [],
  placeholder = "Selecione...",
  className = "",
  disabled = false,
  style,
  dropdownWidth
}: SearchableSelectProps) {
  const [isOpen, setIsOpen] = useState(false);
  const [search, setSearch] = useState("");
  const [highlightedIndex, setHighlightedIndex] = useState(0);

  const wrapperRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);
  const listRef = useRef<HTMLDivElement>(null);

  // Close on outside click
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (wrapperRef.current && !wrapperRef.current.contains(event.target as Node)) {
        setIsOpen(false);
        setSearch("");
      }
    }
    document.addEventListener("mousedown", handleClickOutside);
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, []);

  // Find currently selected option
  const selectedItem = useMemo(() => {
    if (value === null || value === undefined || value === 0 || value === "0" || value === "") {
      return null;
    }
    return options.find((opt) => String(opt.value) === String(value));
  }, [options, value]);

  // Enhanced Multi-keyword Filter
  const filteredOptions = useMemo(() => {
    if (!search.trim()) return options;

    const queryTokens = normalizeText(search).split(/\s+/).filter(Boolean);

    return options.filter((opt) => {
      const targetString = normalizeText(
        `${opt.label} ${opt.subtitle || ""} ${opt.badge || ""} ${opt.searchTerms || ""}`
      );
      // Every typed word token must match somewhere in the option
      return queryTokens.every((token) => targetString.includes(token));
    });
  }, [options, search]);

  // Auto-focus input and reset highlighted index when opening
  useEffect(() => {
    if (isOpen) {
      setHighlightedIndex(0);
      setTimeout(() => {
        inputRef.current?.focus();
      }, 50);
    } else {
      setSearch("");
    }
  }, [isOpen]);

  // Keyboard Navigation
  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (disabled) return;

    if (!isOpen) {
      if (e.key === "Enter" || e.key === "ArrowDown" || e.key === " " || e.key === "Spacebar") {
        e.preventDefault();
        setIsOpen(true);
      }
      return;
    }

    switch (e.key) {
      case "ArrowDown":
        e.preventDefault();
        setHighlightedIndex((prev) =>
          prev < filteredOptions.length - 1 ? prev + 1 : 0
        );
        break;
      case "ArrowUp":
        e.preventDefault();
        setHighlightedIndex((prev) =>
          prev > 0 ? prev - 1 : filteredOptions.length - 1
        );
        break;
      case "Enter":
        e.preventDefault();
        if (filteredOptions[highlightedIndex] && !filteredOptions[highlightedIndex].disabled) {
          onChange(filteredOptions[highlightedIndex].value);
          setIsOpen(false);
          setSearch("");
        }
        break;
      case "Escape":
        e.preventDefault();
        setIsOpen(false);
        setSearch("");
        break;
      case "Tab":
        setIsOpen(false);
        setSearch("");
        break;
    }
  };

  // Keep highlighted item in view during keyboard nav
  useEffect(() => {
    if (isOpen && listRef.current) {
      const activeEl = listRef.current.children[highlightedIndex] as HTMLElement;
      if (activeEl) {
        activeEl.scrollIntoView({ block: "nearest" });
      }
    }
  }, [highlightedIndex, isOpen]);

  return (
    <div
      className={`cl-select-wrapper ${className}`}
      ref={wrapperRef}
      onKeyDown={handleKeyDown}
      style={{
        position: "relative",
        width: "100%",
        userSelect: "none",
        ...style
      }}
    >
      {/* Trigger Button */}
      <div
        className="cl-select"
        tabIndex={disabled ? -1 : 0}
        onClick={() => {
          if (!disabled) setIsOpen(!isOpen);
        }}
        style={{
          cursor: disabled ? "not-allowed" : "pointer",
          display: "flex",
          alignItems: "center",
          justifyContent: "space-between",
          minHeight: "38px",
          padding: "6px 12px",
          borderRadius: "8px",
          backgroundColor: disabled ? "rgba(30, 41, 59, 0.4)" : "#1e293b",
          border: isOpen
            ? "1px solid #3b82f6"
            : "1px solid rgba(255, 255, 255, 0.12)",
          boxShadow: isOpen ? "0 0 0 2px rgba(59, 130, 246, 0.25)" : "none",
          transition: "all 0.15s ease",
          opacity: disabled ? 0.6 : 1,
          gap: "8px"
        }}
      >
        <div style={{ display: "flex", alignItems: "center", gap: "8px", overflow: "hidden", flex: 1 }}>
          {selectedItem ? (
            <div style={{ display: "flex", alignItems: "center", gap: "6px", overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
              <span style={{ color: "#f8fafc", fontWeight: "500", fontSize: "0.875rem" }}>
                {selectedItem.label}
              </span>
              {selectedItem.badge && (
                <span
                  style={{
                    backgroundColor: "rgba(59, 130, 246, 0.15)",
                    color: "#60a5fa",
                    padding: "2px 6px",
                    borderRadius: "4px",
                    fontSize: "0.75rem",
                    fontWeight: "600",
                    border: "1px solid rgba(59, 130, 246, 0.25)",
                    whiteSpace: "nowrap"
                  }}
                >
                  {selectedItem.badge}
                </span>
              )}
            </div>
          ) : (
            <span style={{ color: "#64748b", fontSize: "0.875rem" }}>
              {placeholder}
            </span>
          )}
        </div>

        <div style={{ display: "flex", alignItems: "center", gap: "4px" }}>
          {selectedItem && !disabled && (
            <button
              type="button"
              onClick={(e) => {
                e.stopPropagation();
                onChange(0);
              }}
              style={{
                background: "transparent",
                border: "none",
                color: "#64748b",
                cursor: "pointer",
                padding: "2px",
                display: "flex",
                alignItems: "center"
              }}
              title="Limpar seleção"
            >
              <X size={14} />
            </button>
          )}
          <ChevronDown
            size={16}
            style={{
              color: "#94a3b8",
              transform: isOpen ? "rotate(180deg)" : "rotate(0deg)",
              transition: "transform 0.15s ease"
            }}
          />
        </div>
      </div>

      {/* Dropdown Menu */}
      {isOpen && (
        <div
          style={{
            position: "absolute",
            top: "calc(100% + 4px)",
            left: 0,
            width: dropdownWidth || "100%",
            minWidth: "280px",
            zIndex: 9999,
            backgroundColor: "#0f172a",
            border: "1px solid #334155",
            borderRadius: "8px",
            boxShadow: "0 10px 25px -5px rgba(0, 0, 0, 0.7), 0 8px 10px -6px rgba(0, 0, 0, 0.7)",
            display: "flex",
            flexDirection: "column",
            overflow: "hidden",
            animation: "fadeIn 0.15s ease-out"
          }}
        >
          {/* Search Header */}
          <div
            style={{
              padding: "8px",
              borderBottom: "1px solid #1e293b",
              backgroundColor: "#0f172a",
              display: "flex",
              alignItems: "center",
              gap: "8px"
            }}
          >
            <div
              style={{
                position: "relative",
                display: "flex",
                alignItems: "center",
                width: "100%"
              }}
            >
              <Search
                size={15}
                style={{
                  position: "absolute",
                  left: "10px",
                  color: "#64748b"
                }}
              />
              <input
                ref={inputRef}
                type="text"
                placeholder="Digite para buscar..."
                value={search}
                onChange={(e) => {
                  setSearch(e.target.value);
                  setHighlightedIndex(0);
                }}
                onClick={(e) => e.stopPropagation()}
                style={{
                  width: "100%",
                  padding: "8px 28px 8px 32px",
                  backgroundColor: "#1e293b",
                  border: "1px solid #334155",
                  borderRadius: "6px",
                  color: "#f8fafc",
                  fontSize: "0.85rem",
                  outline: "none"
                }}
              />
              {search && (
                <button
                  type="button"
                  onClick={(e) => {
                    e.stopPropagation();
                    setSearch("");
                    inputRef.current?.focus();
                  }}
                  style={{
                    position: "absolute",
                    right: "8px",
                    background: "none",
                    border: "none",
                    color: "#94a3b8",
                    cursor: "pointer",
                    padding: "2px",
                    display: "flex",
                    alignItems: "center"
                  }}
                >
                  <X size={14} />
                </button>
              )}
            </div>
          </div>

          {/* Options List */}
          <div
            ref={listRef}
            style={{
              maxHeight: "260px",
              overflowY: "auto",
              padding: "4px"
            }}
          >
            {filteredOptions.length === 0 ? (
              <div
                style={{
                  padding: "16px 12px",
                  color: "#64748b",
                  textAlign: "center",
                  fontSize: "0.85rem"
                }}
              >
                Nenhum resultado para "{search}"
              </div>
            ) : (
              filteredOptions.map((opt, index) => {
                const isSelected = String(opt.value) === String(value);
                const isHighlighted = highlightedIndex === index;

                return (
                  <div
                    key={opt.value}
                    onClick={() => {
                      if (!opt.disabled) {
                        onChange(opt.value);
                        setIsOpen(false);
                        setSearch("");
                      }
                    }}
                    onMouseEnter={() => setHighlightedIndex(index)}
                    style={{
                      padding: "8px 10px",
                      borderRadius: "6px",
                      cursor: opt.disabled ? "not-allowed" : "pointer",
                      backgroundColor: isSelected
                        ? "rgba(59, 130, 246, 0.15)"
                        : isHighlighted
                        ? "#1e293b"
                        : "transparent",
                      display: "flex",
                      flexDirection: "column",
                      gap: "2px",
                      transition: "background-color 0.1s ease",
                      border: isSelected
                        ? "1px solid rgba(59, 130, 246, 0.3)"
                        : "1px solid transparent",
                      opacity: opt.disabled ? 0.5 : 1,
                      marginBottom: "2px"
                    }}
                  >
                    <div
                      style={{
                        display: "flex",
                        alignItems: "center",
                        justifyContent: "space-between",
                        gap: "8px"
                      }}
                    >
                      <span
                        style={{
                          color: isSelected ? "#60a5fa" : "#f1f5f9",
                          fontWeight: isSelected ? "600" : "500",
                          fontSize: "0.85rem"
                        }}
                      >
                        {opt.label}
                      </span>
                      <div style={{ display: "flex", alignItems: "center", gap: "6px" }}>
                        {opt.badge && (
                          <span
                            style={{
                              backgroundColor: "rgba(245, 158, 11, 0.15)",
                              color: "#fbbf24",
                              padding: "2px 6px",
                              borderRadius: "4px",
                              fontSize: "0.7rem",
                              fontWeight: "600",
                              border: "1px solid rgba(245, 158, 11, 0.25)"
                            }}
                          >
                            {opt.badge}
                          </span>
                        )}
                        {isSelected && <Check size={14} style={{ color: "#60a5fa" }} />}
                      </div>
                    </div>

                    {opt.subtitle && (
                      <span
                        style={{
                          color: "#94a3b8",
                          fontSize: "0.75rem",
                          lineHeight: "1.2",
                          whiteSpace: "nowrap",
                          overflow: "hidden",
                          textOverflow: "ellipsis"
                        }}
                      >
                        {opt.subtitle}
                      </span>
                    )}
                  </div>
                );
              })
            )}
          </div>

          {/* Footer Info */}
          <div
            style={{
              padding: "4px 8px",
              backgroundColor: "#090d16",
              borderTop: "1px solid #1e293b",
              fontSize: "0.7rem",
              color: "#64748b",
              display: "flex",
              justifyContent: "space-between",
              alignItems: "center"
            }}
          >
            <span>{filteredOptions.length} de {options.length} opções</span>
            <span>Use ↑↓ para navegar e Enter</span>
          </div>
        </div>
      )}
    </div>
  );
}

export default SearchableSelect;
