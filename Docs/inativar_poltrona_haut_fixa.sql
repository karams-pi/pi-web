-- ======================================================================================
-- Script: inativar_poltrona_haut_fixa.sql
-- Descrição: Inativa a marca "POLTRONA HAUT - FIXA" (ID 694) e todos os tecidos/preços
--            ativos vinculados aos seus módulos (IDs 5497 e 5710 - "POLTRONA HAUT - FIXA - POLTRONA")
--            do fornecedor Livintus (ID 4).
-- Aplicação: Banco de dados pi_db (PostgreSQL) - Local e Produção (Render/Supabase).
-- Data: 2026-10-30
-- ======================================================================================

BEGIN;

-- 1. Inativa os registros de tecido/preço ativos dos módulos da marca "POLTRONA HAUT - FIXA"
UPDATE pi.modulo_tecido mt
SET fl_ativo = false,
    data_hora_inativacao = NOW()
FROM pi.modulo m
JOIN pi.marca ma ON ma.id = m.id_marca
WHERE mt.id_modulo = m.id
  AND m.id_fornecedor = 4
  AND (ma.id = 694 OR ma.nome = 'POLTRONA HAUT - FIXA')
  AND mt.fl_ativo = true;

-- 2. Inativa a marca/modelo "POLTRONA HAUT - FIXA" para não aparecer nos filtros e listagens
UPDATE pi.marca
SET fl_ativo = false
WHERE id = 694
   OR nome = 'POLTRONA HAUT - FIXA';

COMMIT;

