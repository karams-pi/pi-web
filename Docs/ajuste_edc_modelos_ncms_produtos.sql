-- ======================================================================================
-- Script: ajuste_edc_modelos_ncms_produtos.sql
-- Descrição: 
--   1. Corrige NCMs inativos ou com caracteres de escape/espaços/tabs (ex: 39031120\t, 9616.10.00).
--   2. Atualiza vínculos de produtos que estavam apontando para NCMs desativados.
--   3. Gera modelos comerciais padrão ativos para todos os produtos ativos do EDC
--      que ainda não possuíam modelos cadastrados, garantindo que 100% dos produtos
--      apareçam na busca aprimorada da combo de vinculação em EDCs.
-- Aplicação: Banco de dados pi_db (PostgreSQL) - Ambiente Local e Produção (Render/Supabase).
-- Data: 2026-10-06
-- ======================================================================================

BEGIN;

-- 1. Limpeza de caracteres de formatação/tabulação em códigos e descrições de NCM
UPDATE edc.ncms 
SET "Codigo" = regexp_replace(TRIM("Codigo"), '[\t\r\n]+', '', 'g'),
    "Descricao" = TRIM("Descricao")
WHERE "Codigo" ~ '[\t\r\n]' OR "Codigo" != TRIM("Codigo");

-- 2. Ativar NCM 113 ('9616.10.00') utilizado por produtos do catálogo
UPDATE edc.ncms
SET "FlAtivo" = true,
    "Descricao" = 'Vaporizadores de toucador, suas armações e cabeças de armações; borlas ou esponjas para pós ou para aplicação de outros cosméticos'
WHERE "Id" = 113;

-- 3. Atualizar produto 12 que apontava para NCM 7 (inativo) para o NCM ativo correspondente (ID 9 - 8424.90.10)
UPDATE edc.produtos
SET "IdNcm" = 9
WHERE "Id" = 12 AND "IdNcm" = 7;

-- 4. Auto-geração de Modelos Comerciais Padrão para todos os produtos ativos sem modelo ativo
INSERT INTO edc.modelos ("IdProduto", "Codigo", "Nome", "Descricao", "FlAtivo")
SELECT 
    p."Id", 
    COALESCE(NULLIF(p."Referencia", ''), 'PROD-' || p."Id"::text),
    COALESCE(NULLIF(p."Referencia", ''), p."Descricao"),
    'Modelo Padrão - ' || COALESCE(NULLIF(p."Descricao", ''), p."Referencia"),
    true
FROM edc.produtos p
WHERE p."FlAtivo" = true
  AND NOT EXISTS (
      SELECT 1 
      FROM edc.modelos m 
      WHERE m."IdProduto" = p."Id" AND m."FlAtivo" = true
  );

COMMIT;

-- ======================================================================================
-- CONSULTAS DE VERIFICAÇÃO
-- ======================================================================================
-- SELECT count(*) FROM edc.produtos WHERE "FlAtivo" = true;
-- SELECT count(*) FROM edc.modelos WHERE "FlAtivo" = true;
-- SELECT count(*) FROM edc.produtos p WHERE p."FlAtivo" = true AND NOT EXISTS (SELECT 1 FROM edc.modelos m WHERE m."IdProduto" = p."Id" AND m."FlAtivo" = true);
