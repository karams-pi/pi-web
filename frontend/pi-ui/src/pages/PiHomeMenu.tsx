
import { Link } from "react-router-dom";

export default function PiHomeMenu() {
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
          <MenuButton to="/pi/clientes" label="Cadastro de Clientes" />
          <MenuButton to="/pi/modulos" label="Cadastro de Produtos" />
          <MenuButton to="/pi/proforma-invoice" label="Criar Proforma Invoice" />
          <MenuButton to="/pi/config" label="Configurações" />
          <MenuButton to="/pi/emissao-lista-preco" label="Emissão de Lista de Preços" />
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
