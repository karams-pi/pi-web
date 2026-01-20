import React from 'react';
import { Link } from 'react-router-dom';

export default function HomeMenu() {
  return (
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: '520px 1fr',
        minHeight: '100vh',
      }}>
      {/* Coluna esquerda: menu */}
      <div style={{ padding: 24 }}>
        <div style={{ fontSize: 12, color: '#666', marginBottom: 12 }}>
          Sistema PI Web - Versão 1.0
        </div>

        <div
          style={{
            background: '#d1d5db',
            color: '#111827',
            padding: '10px 14px',
            fontWeight: 700,
            borderRadius: 6,
            textAlign: 'center',
            marginBottom: 16,
          }}>
          MENU DE NAVEGAÇÃO
        </div>

        <div
          style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(2, 1fr)',
            gap: 16,
            alignContent: 'start',
          }}>
          <MenuButton to='/clientes' label='Cadastro de Clientes' />
          <MenuButton to='/produtos' label='Cadastro de Produtos' />
          <MenuButton to='/pis/novo' label='Criar Proforma Invoice' />
          <MenuButton to='/config' label='Configurações' />
          {/* “Lista de Preços” só na coluna da esquerda */}
          <MenuButton
            to='/precos'
            label='Lista de Preços'
            style={{ gridColumn: '1 / 2' }}
          />
        </div>
      </div>

      {/* Coluna direita: logos/imagem */}
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          padding: 24,
        }}>
        <div style={{ textAlign: 'center' }}>
          {/* Troque pelos seus arquivos reais em /public */}
          <img
            src='/logo-karams.png'
            alt='Karams'
            style={{ height: 60, objectFit: 'contain' }}
          />
          <div style={{ height: 24 }} />
          <img
            src='/logo-seawise.png'
            alt='SEAWISE'
            style={{ maxWidth: 520, width: '100%', objectFit: 'contain' }}
          />
        </div>
      </div>
    </div>
  );
}

function MenuButton(props: {
  to: string;
  label: string;
  style?: React.CSSProperties;
}) {
  return (
    <Link to={props.to} style={{ textDecoration: 'none' }}>
      <div
        style={{
          background: '#fff',
          border: '1px solid #e5e7eb',
          borderRadius: 8,
          padding: '14px 16px',
          color: '#111827',
          fontWeight: 600,
          textAlign: 'center',
          boxShadow: '0 1px 2px rgba(0,0,0,0.04)',
          transition: 'transform .08s ease, box-shadow .08s ease',
          ...props.style,
        }}
        onMouseEnter={(e) => {
          (e.currentTarget as HTMLDivElement).style.transform =
            'translateY(-2px)';
          (e.currentTarget as HTMLDivElement).style.boxShadow =
            '0 6px 16px rgba(0,0,0,0.08)';
        }}
        onMouseLeave={(e) => {
          (e.currentTarget as HTMLDivElement).style.transform = 'none';
          (e.currentTarget as HTMLDivElement).style.boxShadow =
            '0 1px 2px rgba(0,0,0,0.04)';
        }}>
        {props.label}
      </div>
    </Link>
  );
}
