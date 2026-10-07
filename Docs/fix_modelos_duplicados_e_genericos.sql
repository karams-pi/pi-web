-- ======================================================================================
-- Script: fix_modelos_duplicados_e_genericos.sql
-- Descrição: 
--   1. Alinha os Modelos Comerciais padrão para terem o Código e Nome iguais à 
--      Referência comercial do produto pai quando o modelo estiver cadastrado com 
--      termos genéricos (ex: BEVERAGE COOLER, FREEZER) ou duplicados.
--   2. Remove espaços em branco redundantes nas referências e descrições.
-- Aplicação: Banco de dados pi_db (PostgreSQL) - Local e Produção (Render/Supabase).
-- Data: 2026-10-07
-- ======================================================================================

BEGIN;

-- 1. Limpeza de espaços em branco em produtos e modelos
UPDATE edc.produtos
SET "Referencia" = TRIM("Referencia"),
    "Descricao" = TRIM("Descricao")
WHERE "Referencia" != TRIM("Referencia") OR "Descricao" != TRIM("Descricao");

UPDATE edc.modelos
SET "Codigo" = TRIM("Codigo"),
    "Nome" = TRIM("Nome")
WHERE "Codigo" != TRIM("Codigo") OR "Nome" != TRIM("Nome");

-- 2. Atualizar modelos que possuem código genérico ou igual à descrição quando a referência do produto for mais específica
UPDATE edc.modelos m
SET "Codigo" = p."Referencia",
    "Nome" = p."Referencia"
FROM edc.produtos p
WHERE m."IdProduto" = p."Id"
  AND m."FlAtivo" = true
  AND p."FlAtivo" = true
  AND NULLIF(p."Referencia", '') IS NOT NULL
  AND (
      m."Codigo" = m."Nome" 
      OR m."Codigo" = p."Descricao"
      OR m."Nome" = p."Descricao"
      OR m."Codigo" ~* '^(BEVERAGE COOLER|FREEZER|REFRIGERADOR|COOLER|PRODUTO|PROD)'
  )
  AND m."Codigo" != p."Referencia";

COMMIT;
