-- ======================================================================================
-- Script: ajuste_passador_fita_e_ncms.sql
-- Descrição: 
--   1. Corrige a descrição do produto 'PASSADOR DE FITA' (que estava com o NCM '84224090').
--   2. Remove o registro duplicado e órfão do NCM 84224090 (ID 109) gerado por clique duplo.
--   3. Limpa NCMs duplicados órfãos adicionais (IDs 104 e 105).
-- Aplicação: Banco de dados pi_db (PostgreSQL) - Ambiente Local e Produção (Render/Supabase).
-- Data: 2026-09-16
-- ======================================================================================

BEGIN;

-- 1. Corrigir a descrição detalhada do produto Passador de Fita
UPDATE edc.produtos
SET "Descricao" = 'PASSADOR DE FITA'
WHERE "Id" = 383 
   OR ("Referencia" ILIKE '%PASSADOR DE FITA%' AND ("Descricao" = '84224090' OR "Descricao" ~ '^[0-9.-]+$'));

-- 2. Remover o NCM 84224090 duplicado órfão (ID 109 não possui nenhum produto associado)
DELETE FROM edc.ncms
WHERE "Id" = 109
  AND "Codigo" = '84224090'
  AND NOT EXISTS (SELECT 1 FROM edc.produtos p WHERE p."IdNcm" = 109);

-- 3. Limpar outros NCMs duplicados órfãos gerados por duplo clique sem vínculo
DELETE FROM edc.ncms
WHERE "Id" IN (104, 105)
  AND NOT EXISTS (SELECT 1 FROM edc.produtos p WHERE p."IdNcm" = edc.ncms."Id");

COMMIT;

-- ======================================================================================
-- CONSULTAS DE VERIFICAÇÃO (Executar após o COMMIT para confirmar o resultado)
-- ======================================================================================
-- SELECT "Id", "Referencia", "Descricao", "IdNcm" FROM edc.produtos WHERE "Referencia" ILIKE '%PASSADOR%';
-- SELECT "Id", "Codigo", "Descricao", "FlAtivo" FROM edc.ncms WHERE "Codigo" = '84224090';
