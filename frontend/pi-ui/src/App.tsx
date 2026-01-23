import { BrowserRouter, Routes, Route, NavLink, Link } from "react-router-dom";
import HomeMenu from "./pages/HomeMenu";
import ClientesPage from "./pages/ClientesPage";
import FornecedoresPage from "./pages/FornecedoresPage";
import CategoriasPage from "./pages/CategoriasPage";
import TecidosPage from "./pages/TecidosPage";
import ModulosPage from "./pages/ModulosPage";
import MarcasPage from "./pages/MarcasPage";

// function ProdutosPage() {
//   return (
//     <div className="card">
//       <h2>Produtos</h2>
//       <p>Em breve: cadastro de produtos.</p>
//     </div>
//   );
// }

function NovaPiPage() {
  return (
    <div className="card">
      <h2>Criar Proforma Invoice</h2>
      <p>Em breve: formulário de criação de PI.</p>
    </div>
  );
}

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
    <BrowserRouter>
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
              <Route path="/pis/novo" element={<NovaPiPage />} />
              <Route path="/config" element={<ConfiguracoesPage />} />
              {/* <Route path="/precos" element={<PrecosPage />} /> */}
              <Route path="*" element={<NotFound />} />
            </Routes>
          </div>
        </main>
      </div>
    </BrowserRouter>
  );
}

function Header() {
  return (
    <header className="topbar">
      <div className="container">
        <div className="topbar-row">
          <Link to="/" className="brand">
            PI Web
          </Link>

          <nav className="nav">
            <NavLink
              to="/"
              end
              className={({ isActive }) =>
                `navlink ${isActive ? "navlink-active" : ""}`
              }
            >
              Menu
            </NavLink>

            <NavLink
              to="/clientes"
              className={({ isActive }) =>
                `navlink ${isActive ? "navlink-active" : ""}`
              }
            >
              Clientes
            </NavLink>
            <NavLink
              to="/fornecedores"
              className={({ isActive }) =>
                `navlink ${isActive ? "navlink-active" : ""}`
              }
            >
              Fornecedores
            </NavLink>

            <NavLink
              to="/categorias"
              className={({ isActive }) =>
                `navlink ${isActive ? "navlink-active" : ""}`
              }
            >
              Categorias
            </NavLink>
            <NavLink
              to="/marcas"
              className={({ isActive }) =>
                `navlink ${isActive ? "navlink-active" : ""}`
              }
            >
              Marcas
            </NavLink>
            <NavLink
              to="/tecidos"
              className={({ isActive }) =>
                `navlink ${isActive ? "navlink-active" : ""}`
              }
            >
              Tecidos
            </NavLink>

            <NavLink
              to="/modulos"
              className={({ isActive }) =>
                `navlink ${isActive ? "navlink-active" : ""}`
              }
            >
              Modulos
            </NavLink>

            <NavLink
              to="/config"
              className={({ isActive }) =>
                `navlink ${isActive ? "navlink-active" : ""}`
              }
            >
              Config
            </NavLink>
          </nav>
        </div>
      </div>
    </header>
  );
}
