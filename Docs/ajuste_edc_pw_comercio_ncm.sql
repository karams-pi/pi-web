-- ======================================================================================
-- Script: ajuste_edc_pw_comercio_ncm.sql
-- Descrição: 
--   1. Corrige o vínculo do item 'Válvula spray crimpada...' na Simulação 88
--      (EDC - PW COMÉRCIO - PARANAGUÁ) para apontar para o Produto ativo (ID 409) 
--      e Modelo ativo (ID 242) associados ao NCM 84248990.
--   2. Atualiza NCM do produto 405 por segurança e consistência.
--   3. Remove produtos/modelos órfãos duplicados sem vínculo gerados no EDC.
-- Aplicação: Banco de dados pi_db (PostgreSQL) - Ambiente Local e Produção (Render/Supabase).
-- Data: 2026-09-24
-- ======================================================================================

BEGIN;

-- 1. Vincular o item da Simulação 88 (PW COMÉRCIO - PARANAGUÁ) ao Produto ativo 409 e Modelo ativo 242
UPDATE edc.simulacao_itens
SET "IdProduto" = 409,
    "IdModelo" = 242
WHERE "IdSimulacao" = 88 
  AND "IdProduto" = 405;

-- 2. Atualizar NCM do registro antigo 405 por garantia de integridade
UPDATE edc.produtos
SET "IdNcm" = 115
WHERE "Id" = 405;

-- 3. Limpeza de modelos duplicados órfãos da Válvula spray sem nenhum vínculo a simulações
DELETE FROM edc.modelos
WHERE "Id" IN (236, 237, 238, 239, 240, 241, 245)
  AND NOT EXISTS (SELECT 1 FROM edc.simulacao_itens si WHERE si."IdModelo" = edc.modelos."Id");

-- 4. Limpeza de produtos duplicados órfãos da Válvula spray sem nenhum vínculo a simulações
DELETE FROM edc.produtos
WHERE "Id" IN (403, 404, 405, 406, 407, 408, 412)
  AND NOT EXISTS (SELECT 1 FROM edc.simulacao_itens si WHERE si."IdProduto" = edc.produtos."Id")
  AND NOT EXISTS (SELECT 1 FROM edc.modelos m WHERE m."IdProduto" = edc.produtos."Id");

COMMIT;

-- ======================================================================================
-- CONSULTAS DE VERIFICAÇÃO
-- ======================================================================================
-- SELECT si."Id", si."IdSimulacao", s."NumeroReferencia", si."IdProduto", p."Descricao", p."IdNcm", n."Codigo" as "NcmCodigo"
-- FROM edc.simulacao_itens si
-- JOIN edc.simulacoes s ON si."IdSimulacao" = s."Id"
-- JOIN edc.produtos p ON si."IdProduto" = p."Id"
-- LEFT JOIN edc.ncms n ON p."IdNcm" = n."Id"
-- WHERE si."IdSimulacao" IN (88, 89) AND p."Referencia" ILIKE '%PUMP%';
