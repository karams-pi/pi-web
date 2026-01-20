import { BrowserRouter, Routes, Route, NavLink, Link } from 'react-router-dom';
import HomeMenu from './pages/HomeMenu';
import ClientesPage from './pages/ClientesPage'; // CRUD real de clientes

// Placeholders temporários para as demais rotas
function ProdutosPage() {
  return (
    <div style={{ padding: 16 }}>
      <h2>Produtos</h2>
      <p>Em breve: cadastro de produtos.</p>
    </div>
  );
}

function NovaPiPage() {
  return (
    <div style={{ padding: 16 }}>
      <h2>Criar Proforma Invoice</h2>
      <p>Em breve: formulário de criação de PI.</p>
    </div>
  );
}

function ConfigPage() {
  return (
    <div style={{ padding: 16 }}>
      <h2>Configurações</h2>
      <p>Em breve: preferências do sistema.</p>
    </div>
  );
}

function PrecosPage() {
  return (
    <div style={{ padding: 16 }}>
      <h2>Lista de Preços</h2>
      <p>Em breve: gerenciamento de preços.</p>
    </div>
  );
}

function NotFound() {
  return (
    <div style={{ padding: 16 }}>
      <h2>404</h2>
      <p>
        Página não encontrada. <Link to='/'>Voltar ao menu</Link>
      </p>
    </div>
  );
}

export default function App() {
  return (
    <BrowserRouter>
      <Header />
      <Routes>
        <Route path='/' element={<HomeMenu />} />
        <Route path='/clientes' element={<ClientesPage />} />{' '}
        {/* CRUD conectado */}
        <Route path='/produtos' element={<ProdutosPage />} />
        <Route path='/pis/novo' element={<NovaPiPage />} />
        <Route path='/config' element={<ConfigPage />} />
        <Route path='/precos' element={<PrecosPage />} />
        <Route path='*' element={<NotFound />} />
      </Routes>
    </BrowserRouter>
  );
}

function Header() {
  const linkStyle: React.CSSProperties = {
    padding: '6px 10px',
    borderRadius: 8,
    textDecoration: 'none',
    color: '#111827',
  };
  const activeStyle: React.CSSProperties = {
    ...linkStyle,
    background: '#e5e7eb',
  };

  return (
    <header
      style={{
        padding: 10,
        borderBottom: '1px solid #e5e7eb',
        display: 'flex',
        alignItems: 'center',
        gap: 16,
      }}>
      <Link
        to='/'
        style={{ fontWeight: 700, color: '#111827', textDecoration: 'none' }}>
        PI Web
      </Link>
      <nav style={{ display: 'flex', gap: 8 }}>
        <NavLink
          to='/'
          end
          style={({ isActive }) => (isActive ? activeStyle : linkStyle)}>
          Menu
        </NavLink>
        <NavLink
          to='/clientes'
          style={({ isActive }) => (isActive ? activeStyle : linkStyle)}>
          Clientes
        </NavLink>
        <NavLink
          to='/produtos'
          style={({ isActive }) => (isActive ? activeStyle : linkStyle)}>
          Produtos
        </NavLink>
        <NavLink
          to='/precos'
          style={({ isActive }) => (isActive ? activeStyle : linkStyle)}>
          Lista de Preços
        </NavLink>
        <NavLink
          to='/config'
          style={({ isActive }) => (isActive ? activeStyle : linkStyle)}>
          Config
        </NavLink>
      </nav>
    </header>
  );
}
