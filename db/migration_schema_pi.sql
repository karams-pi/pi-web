-- Script de Migração: public -> pi
-- Objetivo: Mover tabelas para o schema 'pi' e criar views de compatibilidade no 'public'.

BEGIN;

-- 1. Criar o schema pi se não existir
CREATE SCHEMA IF NOT EXISTS pi;

-- 2. Mover sequências para o schema pi
DO $$ 
DECLARE 
    r RECORD;
BEGIN
    FOR r IN (SELECT sequence_name FROM information_schema.sequences WHERE sequence_schema = 'public') 
    LOOP
        EXECUTE 'ALTER SEQUENCE public.' || quote_ident(r.sequence_name) || ' SET SCHEMA pi';
    END LOOP;
END $$;

-- 3. Mover tabelas e criar views
ALTER TABLE public.categoria SET SCHEMA pi;
CREATE OR REPLACE VIEW public.categoria AS SELECT * FROM pi.categoria;

-- Tabela: clientes
ALTER TABLE public.clientes SET SCHEMA pi;
CREATE OR REPLACE VIEW public.clientes AS SELECT * FROM pi.clientes;

-- Tabela: configuracoes
ALTER TABLE public.configuracoes SET SCHEMA pi;
CREATE OR REPLACE VIEW public.configuracoes AS SELECT * FROM pi.configuracoes;

-- Tabela: configuracoes_frete_item
ALTER TABLE public.configuracoes_frete_item SET SCHEMA pi;
CREATE OR REPLACE VIEW public.configuracoes_frete_item AS SELECT * FROM pi.configuracoes_frete_item;

-- Tabela: fornecedor
ALTER TABLE public.fornecedor SET SCHEMA pi;
CREATE OR REPLACE VIEW public.fornecedor AS SELECT * FROM pi.fornecedor;

-- Tabela: frete
ALTER TABLE public.frete SET SCHEMA pi;
CREATE OR REPLACE VIEW public.frete AS SELECT * FROM pi.frete;

-- Tabela: frete_item
ALTER TABLE public.frete_item SET SCHEMA pi;
CREATE OR REPLACE VIEW public.frete_item AS SELECT * FROM pi.frete_item;

-- Tabela: lista_preco
ALTER TABLE public.lista_preco SET SCHEMA pi;
CREATE OR REPLACE VIEW public.lista_preco AS SELECT * FROM pi.lista_preco;

-- Tabela: marca
ALTER TABLE public.marca SET SCHEMA pi;
CREATE OR REPLACE VIEW public.marca AS SELECT * FROM pi.marca;

-- Tabela: modelo
ALTER TABLE public.modelo SET SCHEMA pi;
CREATE OR REPLACE VIEW public.modelo AS SELECT * FROM pi.modelo;

-- Tabela: modulo
ALTER TABLE public.modulo SET SCHEMA pi;
CREATE OR REPLACE VIEW public.modulo AS SELECT * FROM pi.modulo;

-- Tabela: tecido
ALTER TABLE public.tecido SET SCHEMA pi;
CREATE OR REPLACE VIEW public.tecido AS SELECT * FROM pi.tecido;

-- Tabela: modulo_tecido
ALTER TABLE public.modulo_tecido SET SCHEMA pi;
CREATE OR REPLACE VIEW public.modulo_tecido AS SELECT * FROM pi.modulo_tecido;

-- Tabela: pi
ALTER TABLE public.pi SET SCHEMA pi;
CREATE OR REPLACE VIEW public.pi AS SELECT * FROM pi.pi;

-- Tabela: pi_item
ALTER TABLE public.pi_item SET SCHEMA pi;
CREATE OR REPLACE VIEW public.pi_item AS SELECT * FROM pi.pi_item;

-- Tabela: pi_item_peca
ALTER TABLE public.pi_item_peca SET SCHEMA pi;
CREATE OR REPLACE VIEW public.pi_item_peca AS SELECT * FROM pi.pi_item_peca;

-- Tabela: versao_sistema
ALTER TABLE public.versao_sistema SET SCHEMA pi;
CREATE OR REPLACE VIEW public.versao_sistema AS SELECT * FROM pi.versao_sistema;

-- Tabela de histórico de migrações do EF Core
ALTER TABLE public."__EFMigrationsHistory" SET SCHEMA pi;

-- Inserir a nova migration no histórico para que o EF Core não tente executá-la novamente
INSERT INTO pi."__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260510183947_ChangeSchemaToPi', '8.0.0'); -- Versão do EF Core aproximada

COMMIT;
