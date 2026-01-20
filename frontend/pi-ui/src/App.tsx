import { BrowserRouter, Routes, Route, NavLink, Link } from "react-router-dom";
import HomeMenu from "./pages/HomeMenu";
import ClientesPage from "./pages/ClientesPage";

function ProdutosPage() {
  return (
    <div className="card">
      <h2>Produtos</h2>
      <p>Em breve: cadastro de produtos.</p>
    </div>
  );
}

function NovaPiPage() {
  return (
    <div className="card">
      <h2>Criar Proforma Invoice</h2>
      <p>Em breve: formulário de criação de PI.</p>
    </div>
  );
}

function ConfigPage() {
  return (
    <div className="card">
      <h2>Configurações</h2>
      <p>Em breve: preferências do sistema.</p>
    </div>
  );
}

function PrecosPage() {
  return (
    <div className="card">
      <h2>Lista de Preços</h2>
      <p>Em breve: gerenciamento de preços.</p>
    </div>
  );
}

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
              <Route path="/produtos" element={<ProdutosPage />} />
              <Route path="/pis/novo" element={<NovaPiPage />} />
              <Route path="/config" element={<ConfigPage />} />
              <Route path="/precos" element={<PrecosPage />} />
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
              to="/produtos"
              className={({ isActive }) =>
                `navlink ${isActive ? "navlink-active" : ""}`
              }
            >
              Produtos
            </NavLink>

            <NavLink
              to="/precos"
              className={({ isActive }) =>
                `navlink ${isActive ? "navlink-active" : ""}`
              }
            >
              Lista de Preços
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
