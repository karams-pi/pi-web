
import { Link } from "react-router-dom";

export default function HomeMenu() {
  return (
    <div className="home">
      <section className="card home-logos-card">
        <div className="home-logos">
          <img src="/logo-karams.png" alt="Karams" style={{ height: 60 }} />
          <div className="logo-divider" />
          <img src="/logo-koyo.jpeg" alt="Koyo" style={{ height: 55 }} />
          <div className="logo-divider" />
          <img src="/logo-seawise.png" alt="SEAWISE" className="seawise-logo" style={{ height: 50 }} />
          <div className="logo-divider" />
          <img src="/logo-ferguile_.png" alt="Ferguile" style={{ height: 45 }} />
          <div className="logo-divider" />
          <img src="/logo-livintus.png" alt="Livintus" style={{ height: 45 }} />
        </div>
      </section>

      <section className="card home-menu-section">
        <div className="meta">Sistema PI Web - Versão 1.0</div>

        <div className="title">MENU DE NAVEGAÇÃO</div>

        <div className="home-menuGrid">
          <MenuButton to="/clientes" label="Cadastro de Clientes" />
          <MenuButton to="/produtos" label="Cadastro de Produtos" />
          <MenuButton to="/proforma-invoice" label="Criar Proforma Invoice" />
          <MenuButton to="/config" label="Configurações" />
          <MenuButton to="/precos" label="Lista de Preços" />
        </div>
      </section>
    </div>
  );
}

function MenuButton(props: { to: string; label: string }) {
  return (
    <Link to={props.to} className="menuBtn">
      <div>{props.label}</div>
    </Link>
  );
}
