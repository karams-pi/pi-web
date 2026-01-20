-- Extensões úteis
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ==========
-- Domínios / Enums (opcional)
-- ==========
DO $$ BEGIN
  CREATE TYPE tipo_preco AS ENUM ('EXW','FCA','FOB');
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  CREATE TYPE pi_status AS ENUM ('ABERTA','ENVIADA','APROVADA','CANCELADA');
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

-- ==========
-- Clientes
-- ==========
CREATE TABLE IF NOT EXISTS clientes (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nome            TEXT NOT NULL,
  empresa         TEXT,
  email           TEXT,
  telefone        TEXT,
  ativo           BOOLEAN NOT NULL DEFAULT TRUE,

  pais            TEXT,
  cidade          TEXT,
  endereco        TEXT,
  cep             TEXT,

  pessoa_contato  TEXT,
  cargo_funcao    TEXT,
  observacoes     TEXT,

  criado_em       TIMESTAMPTZ NOT NULL DEFAULT now(),
  atualizado_em   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS ix_clientes_nome ON clientes (nome);
CREATE INDEX IF NOT EXISTS ix_clientes_email ON clientes (email);

-- ==========
-- Tecidos (G0..G8)
-- ==========
CREATE TABLE IF NOT EXISTS tecidos (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo      TEXT NOT NULL UNIQUE, -- ex: G0, G1, G2...
  descricao   TEXT,
  ativo       BOOLEAN NOT NULL DEFAULT TRUE
);

-- ==========
-- Produtos
-- ==========
CREATE TABLE IF NOT EXISTS produtos (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  categoria     TEXT NOT NULL,
  nome          TEXT NOT NULL,
  foto_url      TEXT,
  observacao    TEXT,
  ativo         BOOLEAN NOT NULL DEFAULT TRUE,

  criado_em     TIMESTAMPTZ NOT NULL DEFAULT now(),
  atualizado_em TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS ix_produtos_categoria ON produtos (categoria);
CREATE INDEX IF NOT EXISTS ix_produtos_nome ON produtos (nome);

-- ==========
-- Modelos do Produto (o "modelo" do Excel)
-- ==========
CREATE TABLE IF NOT EXISTS produto_modelos (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  produto_id     UUID NOT NULL REFERENCES produtos(id) ON DELETE CASCADE,

  descricao      TEXT NOT NULL,         -- ex: "Daybed giratória (144)"
  largura_m      NUMERIC(12,3),
  profundidade_m NUMERIC(12,3),
  altura_m       NUMERIC(12,3),

  pa             NUMERIC(12,3),         -- se você usa esse campo
  area_m2        NUMERIC(12,3),
  volume_m3      NUMERIC(12,3),

  qtd_caminhao   NUMERIC(12,2),
  qtd_container  NUMERIC(12,2),

  ativo          BOOLEAN NOT NULL DEFAULT TRUE,
  criado_em      TIMESTAMPTZ NOT NULL DEFAULT now(),
  atualizado_em  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS ix_produto_modelos_produto ON produto_modelos (produto_id);

-- ==========
-- Preços por (modelo × tecido × tipo_preco)
-- Valores em USD (como sua PI é USD e BRL é informativo)
-- ==========
CREATE TABLE IF NOT EXISTS produto_precos (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  produto_modelo_id UUID NOT NULL REFERENCES produto_modelos(id) ON DELETE CASCADE,
  tecido_id         UUID NOT NULL REFERENCES tecidos(id),
  tipo              tipo_preco NOT NULL,
  valor_usd         NUMERIC(14,2) NOT NULL CHECK (valor_usd >= 0),

  UNIQUE (produto_modelo_id, tecido_id, tipo)
);

CREATE INDEX IF NOT EXISTS ix_produto_precos_lookup
  ON produto_precos (produto_modelo_id, tecido_id, tipo);

-- ==========
-- Configurações (um "singleton" simples)
-- Você pode manter uma linha só (id = 1) e atualizar.
-- ==========
CREATE TABLE IF NOT EXISTS configuracoes (
  id                     INT PRIMARY KEY DEFAULT 1,
  ultima_pi_numero        INT NOT NULL DEFAULT 0,

  imposto_percent         NUMERIC(7,3) NOT NULL DEFAULT 0,
  comissao_percent        NUMERIC(7,3) NOT NULL DEFAULT 0,
  gordura_percent         NUMERIC(7,3) NOT NULL DEFAULT 0,

  fca_valor_brl           NUMERIC(14,2) NOT NULL DEFAULT 0,
  fca_frete_fronteira_brl NUMERIC(14,2) NOT NULL DEFAULT 0,
  fca_despesas_brl        NUMERIC(14,2) NOT NULL DEFAULT 0,

  fob_valor_brl           NUMERIC(14,2) NOT NULL DEFAULT 0,
  fob_frete_porto_brl     NUMERIC(14,2) NOT NULL DEFAULT 0,
  fob_despesas_portuarias_brl NUMERIC(14,2) NOT NULL DEFAULT 0,
  fob_despesas_despachante_brl NUMERIC(14,2) NOT NULL DEFAULT 0,
  fob_despesas_courier_brl NUMERIC(14,2) NOT NULL DEFAULT 0,

  dolar_fonte             TEXT,           -- ex: AwesomeAPI
  email_obrigatorio       BOOLEAN NOT NULL DEFAULT FALSE,
  conta_bancaria_final    TEXT,

  atualizado_em           TIMESTAMPTZ NOT NULL DEFAULT now()
);

INSERT INTO configuracoes (id) VALUES (1)
ON CONFLICT (id) DO NOTHING;

-- ==========
-- Proforma Invoices (PI)
-- ==========
CREATE TABLE IF NOT EXISTS pis (
  id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  numero             TEXT NOT NULL UNIQUE,      -- ex: SW003-2025
  data_pi            DATE NOT NULL DEFAULT CURRENT_DATE,
  status             pi_status NOT NULL DEFAULT 'ABERTA',

  cliente_id          UUID NOT NULL REFERENCES clientes(id),

  tipo_preco          tipo_preco NOT NULL,      -- EXW/FCA/FOB escolhido por PI

  usd_rate            NUMERIC(14,6),            -- taxa USD->BRL usada
  usd_rate_fonte      TEXT,
  usd_rate_atualizado_em TIMESTAMPTZ,

  loading_port        TEXT,
  discharge_port      TEXT,
  incoterm            TEXT,                     -- ex: FCA
  delivery_time       TEXT,
  payment_term        TEXT,

  total_usd           NUMERIC(14,2) NOT NULL DEFAULT 0,
  total_brl           NUMERIC(14,2) NOT NULL DEFAULT 0,

  criado_em           TIMESTAMPTZ NOT NULL DEFAULT now(),
  atualizado_em       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS ix_pis_cliente_data ON pis (cliente_id, data_pi);

-- ==========
-- Itens da PI
-- ==========
CREATE TABLE IF NOT EXISTS pi_itens (
  id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  pi_id              UUID NOT NULL REFERENCES pis(id) ON DELETE CASCADE,

  produto_id         UUID NOT NULL REFERENCES produtos(id),
  produto_modelo_id  UUID NOT NULL REFERENCES produto_modelos(id),
  tecido_id          UUID NOT NULL REFERENCES tecidos(id),

  -- Quantidades do Excel
  qtd_modulos        INT NOT NULL DEFAULT 1 CHECK (qtd_modulos > 0),
  qtd_pecas          INT NOT NULL DEFAULT 1 CHECK (qtd_pecas > 0),

  observacao         TEXT,

  -- Snapshots para o PDF (evita mudar se você editar o cadastro depois)
  modelo_descricao_snapshot TEXT,
  largura_m_snapshot        NUMERIC(12,3),
  profundidade_m_snapshot   NUMERIC(12,3),
  altura_m_snapshot         NUMERIC(12,3),
  volume_unit_m3_snapshot   NUMERIC(12,3),

  valor_unit_usd     NUMERIC(14,2) NOT NULL CHECK (valor_unit_usd >= 0),
  valor_total_usd    NUMERIC(14,2) NOT NULL CHECK (valor_total_usd >= 0)
);

CREATE INDEX IF NOT EXISTS ix_pi_itens_pi ON pi_itens (pi_id);

CREATE TABLE IF NOT EXISTS pi_sequencia (
  ano INT PRIMARY KEY,
  ultimo_numero INT NOT NULL
);

ALTER TABLE configuracoes
  ADD COLUMN IF NOT EXISTS empresa_nome TEXT,
  ADD COLUMN IF NOT EXISTS empresa_cnpj TEXT,
  ADD COLUMN IF NOT EXISTS empresa_tel TEXT,
  ADD COLUMN IF NOT EXISTS empresa_email TEXT,
  ADD COLUMN IF NOT EXISTS empresa_logo_url TEXT,
  ADD COLUMN IF NOT EXISTS accounting_details_text TEXT,
  ADD COLUMN IF NOT EXISTS general_product_data_text TEXT;

CREATE TABLE IF NOT EXISTS pi_sequencia (
  prefixo TEXT NOT NULL,
  ano INT NOT NULL,
  ultimo_numero INT NOT NULL,
  PRIMARY KEY (prefixo, ano)
);


ALTER TABLE pis
  ADD COLUMN IF NOT EXISTS prefixo TEXT;

-- (Se a tabela pis ainda não existe no seu banco, isso vai no CREATE TABLE)
