import React from "react";
import { Link } from "react-router-dom";

export default function HomeMenu() {
  return (
    <div className="home">
      <section className="card home-left">
        <div className="meta">Sistema PI Web - Versão 1.0</div>

        <div className="title">MENU DE NAVEGAÇÃO</div>

        <div className="home-menuGrid">
          <MenuButton to="/clientes" label="Cadastro de Clientes" />
          <MenuButton to="/produtos" label="Cadastro de Produtos" />
          <MenuButton to="/pis/novo" label="Criar Proforma Invoice" />
          <MenuButton to="/config" label="Configurações" />
          <MenuButton to="/precos" label="Lista de Preços" />
        </div>
      </section>

      <section className="card home-right">
        <div className="home-logos">
          <img src="/logo-karams.png" alt="Karams" style={{ height: 60 }} />
          <div style={{ height: 24 }} />
          <img src="/logo-seawise.png" alt="SEAWISE" />
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
