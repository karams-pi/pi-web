-- ======================================================================================
-- Script: remover_duplicados_edc.sql
-- Descrição: Limpeza de registros duplicados gerados por múltiplos cliques no módulo EDC.
-- Aplicação: Banco de dados pi_db (PostgreSQL) - Ambiente Local e Produção (Render).
-- Data: 2026-09-10
--
-- Detalhes dos registros mantidos e excluídos:
-- 1. 'EDC - EPS X VTC':
--    Mantido: ID 67 (Versão consolidada com Frete Internacional R$ 17.700,00 e despesas atualizadas).
--    Excluídos: IDs 63, 64, 65, 66, 68 (cliques em rajada e versões intermediárias).
--
-- 2. 'CHAPAS - 304 - ALUPLOM ':
--    Mantido: ID 61 (Versão editada com Frete R$ 9.140,00).
--    Excluídos: IDs 58, 59, 60 (cliques repetidos com valores zerados).
--
-- 3. 'EDC - BATERIA ':
--    Mantido: ID 72.
--    Excluído: ID 73 (duplicado gerado a 54ms de diferença).
--
-- 4. 'EDC - CHAPAS - FÁBRICA 2':
--    Mantido: ID 19.
--    Excluídos: IDs 20, 21, 22, 23, 24, 25 (6 cliques gerados em menos de 3 segundos).
--
-- 5. 'EDC-2026-7654':
--    Mantido: ID 54 (Versão mais recente atualizada).
--    Excluídos: IDs 29 a 51, 53, 55 (rajada de cliques repetidos).
-- ======================================================================================

BEGIN;

-- 1. Remover cópias fantasmas do estudo 'EDC - EPS X VTC'
DELETE FROM edc.simulacoes 
WHERE "Id" IN (63, 64, 65, 66, 68);

-- 2. Remover cópias fantasmas do estudo 'CHAPAS - 304 - ALUPLOM '
DELETE FROM edc.simulacoes 
WHERE "Id" IN (58, 59, 60);

-- 3. Remover cópia duplicada do estudo 'EDC - BATERIA '
DELETE FROM edc.simulacoes 
WHERE "Id" = 73;

-- 4. Remover cópias repetidas do estudo 'EDC - CHAPAS - FÁBRICA 2'
DELETE FROM edc.simulacoes 
WHERE "Id" IN (20, 21, 22, 23, 24, 25);

-- 5. Remover rajada de cliques do estudo 'EDC-2026-7654'
DELETE FROM edc.simulacoes 
WHERE "Id" IN (
    29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 53, 55
);

COMMIT;
