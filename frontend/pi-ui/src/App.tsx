import { HashRouter, Routes, Route, NavLink, Link } from "react-router-dom";
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
  return (
    <HashRouter>
      <div className="app">
        <Header />

        <main className="main">
          <div className="container">
            <Routes>
              <Route path="/" element={<HomeMenu />} />
              <Route path="/clientes" element={<ClientesPage />} />
              <Route path="/fornecedores" element={<FornecedoresPage />} />
              <Route path="/categorias" element={<CategoriasPage />} />
              <Route path="/marcas" element={<MarcasPage />} />
              <Route path="/tecidos" element={<TecidosPage />} />
              <Route path="/modulos" element={<ModulosPage />} />
              <Route path="/proforma-invoice" element={<ProformaInvoicePage />} />
              <Route path="/print-pi/:id" element={<PrintPiPage />} />
              <Route path="/importacao" element={<ImportacaoPage />} />
              <Route path="/config" element={<ConfiguracoesPage />} />
              <Route path="/sobre" element={<SobrePage />} />
              {/* <Route path="/precos" element={<PrecosPage />} /> */}
              <Route path="*" element={<NotFound />} />
            </Routes>
          </div>
        </main>

        <Footer />
      </div>
    </HashRouter>
  );
}

function Footer() {
  return (
    <footer className="footer">
      <div className="container">
        <p>
          Desenvolvido por Paulo Roberto Schmitz Takeda • Contato: paulo.takeda@gmail.com - (43) 9 9974-1880
        </p>
      </div>
    </footer>
  );
}

// ... imports
import { useState, useEffect } from "react";
import { useLocation } from "react-router-dom";
import { 
  Menu, X, Home, Users, Truck, Layers, Tag, Scissors, 
  Grid, FileText, Download, Settings, Info 
} from "lucide-react";

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
            <NavLink to="/" end className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
              <Home size={18} />
              <span>Menu</span>
            </NavLink>

            <NavLink to="/clientes" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
              <Users size={18} />
              <span>Clientes</span>
            </NavLink>

            <NavLink to="/fornecedores" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
              <Truck size={18} />
              <span>Fornecedores</span>
            </NavLink>

            <NavLink to="/categorias" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
              <Layers size={18} />
              <span>Categorias</span>
            </NavLink>

            <NavLink to="/marcas" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
              <Tag size={18} />
              <span>Modelos</span>
            </NavLink>

            <NavLink to="/tecidos" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
              <Scissors size={18} />
              <span>Tecidos</span>
            </NavLink>

            <NavLink to="/modulos" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
              <Grid size={18} />
              <span>Modulos</span>
            </NavLink>

            <NavLink to="/proforma-invoice" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
              <FileText size={18} />
              <span>Proforma</span>
            </NavLink>

            <NavLink to="/importacao" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
              <Download size={18} />
              <span>Importar</span>
            </NavLink>

            <NavLink to="/config" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
              <Settings size={18} />
              <span>Config</span>
            </NavLink>

            <NavLink to="/sobre" className={({ isActive }) => `navlink ${isActive ? "navlink-active" : ""}`}>
              <Info size={18} />
              <span>Sobre</span>
            </NavLink>
          </nav>
        </div>
      </div>
    </header>
  );
}
