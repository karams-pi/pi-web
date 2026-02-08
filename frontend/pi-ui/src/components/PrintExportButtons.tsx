
import { useState, useRef, useEffect } from "react";
import { Printer, FileSpreadsheet, ChevronDown } from "lucide-react";

interface PrintExportButtonsProps {
  onPrint: (all: boolean) => void;
  onExcel: (all: boolean) => void;
  disabled?: boolean;
}

export function PrintExportButtons({ onPrint, onExcel, disabled = false }: PrintExportButtonsProps) {
  const [open, setOpen] = useState<"print" | "excel" | null>(null);
  const printRef = useRef<HTMLDivElement>(null);
  const excelRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (printRef.current && !printRef.current.contains(event.target as Node)) {
        if (open === "print") setOpen(null);
      }
      if (excelRef.current && !excelRef.current.contains(event.target as Node)) {
        if (open === "excel") setOpen(null);
      }
    }
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, [open]);

  return (
    <div style={{ display: "flex", gap: 10 }}>
      {/* Print Button Group */}
      <div style={{ position: "relative" }} ref={printRef}>
        <button
          className="btn btn-secondary"
          onClick={() => setOpen(open === "print" ? null : "print")}
          disabled={disabled}
          title="Imprimir"
        >
          <Printer size={18} />
          <span style={{ marginLeft: 6 }}>Imprimir</span>
          <ChevronDown size={14} style={{ marginLeft: 4, opacity: 0.7 }} />
        </button>
        {open === "print" && (
          <div className="dropdown-menu">
            <div
              className="dropdown-item"
              onClick={() => {
                onPrint(false);
                setOpen(null);
              }}
            >
              Imprimir Filtrados (Tela)
            </div>
            <div
              className="dropdown-item"
              onClick={() => {
                onPrint(true);
                setOpen(null);
              }}
            >
              Imprimir Todos (Completo)
            </div>
          </div>
        )}
      </div>

      {/* Excel Button Group */}
      <div style={{ position: "relative" }} ref={excelRef}>
        <button
          className="btn btn-secondary"
          onClick={() => setOpen(open === "excel" ? null : "excel")}
          disabled={disabled}
          title="Exportar Excel/CSV"
        >
          <FileSpreadsheet size={18} />
          <span style={{ marginLeft: 6 }}>Excel</span>
          <ChevronDown size={14} style={{ marginLeft: 4, opacity: 0.7 }} />
        </button>
        {open === "excel" && (
          <div className="dropdown-menu">
            <div
              className="dropdown-item"
              onClick={() => {
                onExcel(false);
                setOpen(null);
              }}
            >
              Exportar Filtrados (Tela)
            </div>
            <div
              className="dropdown-item"
              onClick={() => {
                onExcel(true);
                setOpen(null);
              }}
            >
              Exportar Todos (Completo)
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
