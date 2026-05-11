import { Routes, Route, NavLink, Link } from "react-router-dom";
import ModuleSelector from "./pages/ModuleSelector";
import PiHomeMenu from "./pages/PiHomeMenu";
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
import EdcDashboard from "./pages/edc/EdcDashboard";
import NcmsPage from "./pages/edc/NcmsPage";
import ImportadoresPage from "./pages/edc/ImportadoresPage";
import ExportadoresPage from "./pages/edc/ExportadoresPage";
import ProdutosEdcPage from "./pages/edc/ProdutosEdcPage";
import TaxasAduaneirasPage from "./pages/edc/TaxasAduaneirasPage";
import ConfiguracoesFiscaisPage from "./pages/edc/ConfiguracoesFiscaisPage";
import EstudosEdcPage from "./pages/edc/EstudosEdcPage";
import NovoEstudoEdcPage from "./pages/edc/NovoEstudoEdcPage";
import DetalheEstudoEdcPage from "./pages/edc/DetalheEstudoEdcPage";


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

  const isSelectionPage = location.pathname === "/";
  const isPrintRoute = location.pathname.startsWith("/print-pi");

  // Esconder UI global em telas de seleção ou impressão
  const showGlobalUI = !isPrintRoute && !isSelectionPage;

  return (
    <div className={`app ${isPrintRoute ? "print-mode" : ""} ${isSelectionPage ? "selection-mode" : ""}`}>
      {showGlobalUI && (
        <Sidebar 
          isCollapsed={isSidebarCollapsed} 
          setIsCollapsed={setIsSidebarCollapsed} 
        />
      )}
      {showGlobalUI && <Header />}

      <main className={showGlobalUI ? "main" : ""}>
        <div className={showGlobalUI ? "container" : ""}>
          <Routes>
            <Route path="/" element={<ModuleSelector />} />
            
            {/* Módulo PI (Proforma Invoice) */}
            <Route path="/pi">
              <Route index element={<PiHomeMenu />} />
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

            {/* Módulo EDC (Estudo de Custos - Importação) */}
            <Route path="/edc">
              <Route index element={<EdcDashboard />} />
              <Route path="estudos" element={<EstudosEdcPage />} />
              <Route path="estudos/novo" element={<NovoEstudoEdcPage />} />
              <Route path="estudos/:id" element={<DetalheEstudoEdcPage />} />
              <Route path="ncms" element={<NcmsPage />} />
              <Route path="taxas" element={<TaxasAduaneirasPage />} />
              <Route path="config-fiscal" element={<ConfiguracoesFiscaisPage />} />
              <Route path="importadores" element={<ImportadoresPage />} />
              <Route path="exportadores" element={<ExportadoresPage />} />
              <Route path="produtos" element={<ProdutosEdcPage />} />
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
  Grid, FileText, Download, Settings, Info, ChevronLeft, ChevronRight,
  Calculator, ListChecks, BookOpen, Coins, ShieldCheck, Ship, BarChart3, Globe2
} from "lucide-react";

function NavLinks() {
  const location = useLocation();
  const isEdc = location.pathname.startsWith("/edc");

  if (isEdc) {
    return (
      <>
        <NavLink to="/edc" end className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
          <BarChart3 size={18} />
          <span>Dashboard</span>
        </NavLink>

        <NavLink to="/edc/estudos" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
          <ListChecks size={18} />
          <span>Estudos (EDC)</span>
        </NavLink>

        <NavLink to="/edc/ncms" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
          <BookOpen size={18} />
          <span>NCMs</span>
        </NavLink>

        <NavLink to="/edc/taxas" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
          <Coins size={18} />
          <span>Taxas</span>
        </NavLink>

        <NavLink to="/edc/config-fiscal" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
          <ShieldCheck size={18} />
          <span>Fiscal</span>
        </NavLink>

        <div className="nav-divider">Cadastros</div>

        <NavLink to="/edc/importadores" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
          <Users size={18} />
          <span>Importadores</span>
        </NavLink>

        <NavLink to="/edc/exportadores" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
          <Globe2 size={18} />
          <span>Exportadores</span>
        </NavLink>

        <NavLink to="/edc/produtos" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
          <Grid size={18} />
          <span>Produtos</span>
        </NavLink>

        <div className="nav-divider">Sistema</div>

        <NavLink to="/" className="navlink">
          <Home size={18} />
          <span>Trocar Módulo</span>
        </NavLink>
      </>
    );
  }

  // Menu PI (Proforma Invoice)
  return (
    <>
      <NavLink to="/pi" end className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
        <Home size={18} />
        <span>Menu PI</span>
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

      <NavLink to="/" className="navlink">
        <Grid size={18} />
        <span>Trocar Módulo</span>
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
        {location.pathname.startsWith("/edc") ? "EDC System" : "PI Web"}
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
