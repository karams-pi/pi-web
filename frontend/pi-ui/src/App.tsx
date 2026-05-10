import { Routes, Route, NavLink, Link } from "react-router-dom";
import HomeMenu from "./pages/HomeMenu";
import ClientesPage from "./pages/ClientesPage";
import FornecedoresPage from "./pages/FornecedoresPage";
import CategoriasPage from "./pages/CategoriasPage";
import TecidosPage from "./pages/TecidosPage";
import ModulosPage from "./pages/ModulosPage";
import MarcasPage from "./pages/MarcasPage";
import ProformaInvoicePage from "./pages/ProformaInvoicePage";
import PrintPiPage from "./pages/PrintPiPage";
import ImportacaoPage from "./pages/ImportacaoPage";
import SobrePage from "./pages/SobrePage";
import PrintPiFerguilePage from "./pages/PrintPiFerguilePage";
import ProformaInvoiceV2Page from "./pages/ProformaInvoiceV2Page";
import EmissaoListaPrecosPage from "./pages/EmissaoListaPrecosPage";


// function ProdutosPage() {
//   return (
//     <div className="card">
//       <h2>Produtos</h2>
//       <p>Em breve: cadastro de produtos.</p>
//     </div>
//   );
// }



import ConfiguracoesPage from "./pages/ConfiguracoesPage";

// function PrecosPage() {
//   return (
//     <div className="card">
//       <h2>Lista de Preços</h2>
//       <p>Em breve: gerenciamento de preços.</p>
//     </div>
//   );
// }

function NotFound() {
  return (
    <div className="card">
      <h2>404</h2>
      <p>
        Página não encontrada. <Link to="/">Voltar ao menu</Link>
      </p>
    </div>
  );
}

export default function App() {
  const [isSidebarCollapsed, setIsSidebarCollapsed] = useState(false);
  const location = useLocation();

  const isPrintRoute = location.pathname.startsWith("/print-pi");

  return (
    <div className={`app ${isPrintRoute ? "print-mode" : ""}`}>
      {!isPrintRoute && (
        <Sidebar 
          isCollapsed={isSidebarCollapsed} 
          setIsCollapsed={setIsSidebarCollapsed} 
        />
      )}
      {!isPrintRoute && <Header />}

      <main className={isPrintRoute ? "" : "main"}>
        <div className={isPrintRoute ? "" : "container"}>
          <Routes>
            <Route path="/" element={<HomeMenu />} />
            
            {/* Módulo PI (Proforma Invoice) */}
            <Route path="/pi">
              <Route index element={<HomeMenu />} />
              <Route path="clientes" element={<ClientesPage />} />
              <Route path="fornecedores" element={<FornecedoresPage />} />
              <Route path="categorias" element={<CategoriasPage />} />
              <Route path="marcas" element={<MarcasPage />} />
              <Route path="tecidos" element={<TecidosPage />} />
              <Route path="modulos" element={<ModulosPage />} />
              <Route path="proforma-invoice" element={<ProformaInvoicePage />} />
              <Route path="proforma-invoice-v2" element={<ProformaInvoiceV2Page />} />
              <Route path="proforma-invoice-v2/:id" element={<ProformaInvoiceV2Page />} />
              <Route path="importacao" element={<ImportacaoPage />} />
              <Route path="emissao-lista-preco" element={<EmissaoListaPrecosPage />} />
              <Route path="config" element={<ConfiguracoesPage />} />
            </Route>

            {/* Rotas de Impressão (Mantidas na raiz por simplicidade de link externo) */}
            <Route path="/print-pi/:id" element={<PrintPiPage />} />
            <Route path="/print-pi-ferguile/:id" element={<PrintPiFerguilePage />} />

            <Route path="/sobre" element={<SobrePage />} />
            <Route path="*" element={<NotFound />} />
          </Routes>
        </div>
      </main>
    </div>
  );
}

// ... imports
import { useState, useEffect } from "react";
import { useLocation } from "react-router-dom";
import { 
  Menu, X, Home, Users, Truck, Layers, Tag, Scissors, 
  Grid, FileText, Download, Settings, Info, ChevronLeft, ChevronRight
} from "lucide-react";

function NavLinks() {
  return (
    <>
      <NavLink to="/" end className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
        <Home size={18} />
        <span>Menu</span>
      </NavLink>

      <NavLink to="/pi/clientes" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
        <Users size={18} />
        <span>Clientes</span>
      </NavLink>

      <NavLink to="/pi/fornecedores" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
        <Truck size={18} />
        <span>Fornecedores</span>
      </NavLink>

      <NavLink to="/pi/categorias" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
        <Layers size={18} />
        <span>Categorias</span>
      </NavLink>

      <NavLink to="/pi/marcas" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
        <Tag size={18} />
        <span>Modelos</span>
      </NavLink>

      <NavLink to="/pi/tecidos" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
        <Scissors size={18} />
        <span>Tecidos</span>
      </NavLink>

      <NavLink to="/pi/modulos" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
        <Grid size={18} />
        <span>Modulos</span>
      </NavLink>

      <NavLink to="/pi/emissao-lista-preco" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
        <Download size={18} />
        <span>Lista de Preços</span>
      </NavLink>

      <NavLink to="/pi/proforma-invoice" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
        <FileText size={18} />
        <span>Proforma</span>
      </NavLink>
      <NavLink to="/pi/proforma-invoice-v2" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
        <FileText size={18} />
        <span style={{ fontWeight: "bold", color: "#4f9eff" }}>Proforma V2</span>
      </NavLink>

      <NavLink to="/pi/importacao" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
        <Download size={18} />
        <span>Importar</span>
      </NavLink>

      <NavLink to="/pi/config" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
        <Settings size={18} />
        <span>Config</span>
      </NavLink>

      <NavLink to="/sobre" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
        <Info size={18} />
        <span>Sobre</span>
      </NavLink>
    </>
  );
}

function Sidebar({ isCollapsed, setIsCollapsed }: { isCollapsed: boolean, setIsCollapsed: (v: boolean) => void }) {
  return (
    <aside className={`sidebar ${isCollapsed ? "collapsed" : ""}`}>
      <button 
        className="sidebar-toggle" 
        onClick={() => setIsCollapsed(!isCollapsed)}
        aria-label={isCollapsed ? "Expand sidebar" : "Collapse sidebar"}
      >
        {isCollapsed ? <ChevronRight size={20} /> : <ChevronLeft size={20} />}
      </button>

      <Link to="/" className="brand">
        PI Web
      </Link>

      <nav className="nav">
        <NavLinks />
      </nav>
    </aside>
  );
}

function Header() {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const location = useLocation();

  // Close menu when route changes
  useEffect(() => {
    setIsMenuOpen(false);
  }, [location]);

  return (
    <header className="topbar">
      <div className="container">
        <div className="topbar-row">
          <Link to="/" className="brand">
            PI Web
          </Link>

          <button 
            className="hamburger" 
            onClick={() => setIsMenuOpen(!isMenuOpen)}
            aria-label="Toggle menu"
          >
            {isMenuOpen ? <X size={24} /> : <Menu size={24} />}
          </button>

          <nav className={`nav ${isMenuOpen ? "open" : ""}`}>
            <NavLinks />
          </nav>
        </div>
      </div>
    </header>
  );
}
