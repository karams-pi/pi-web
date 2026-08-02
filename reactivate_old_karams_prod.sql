-- ==========================================================================
-- REATIVAÇÃO SELETIVA DE MÓDULOS ANTERIORES DA KARAMS EM PRODUÇÃO
-- Esta versão NÃO utiliza IDs primários locais, sendo segura para Produção.
-- ==========================================================================

-- IMPORTANTE: Execute este script APENAS após realizar o deploy do backend
-- (para que a coluna 'data_hora_inativacao' já tenha sido criada).

BEGIN TRANSACTION;

-- 1. Reativar os preços antigos (de 27/05/2026) apenas para os módulos que NÃO foram atualizados na nova tabela de 2026.
-- (Isso atualizará exatamente 13.769 registros locais, correspondentes aos 1.583 módulos antigos).
UPDATE pi.modulo_tecido mt
SET fl_ativo = true, data_hora_inativacao = NULL
FROM pi.modulo m
WHERE mt.id_modulo = m.id
  AND m.id_fornecedor = 1
  -- O módulo não pode ter nenhum preço ativo atualmente (ou seja, não está na nova tabela)
  AND mt.id_modulo NOT IN (
      SELECT DISTINCT sub_mt.id_modulo 
      FROM pi.modulo_tecido sub_mt 
      WHERE sub_mt.fl_ativo = true
  )
  -- Garante que estamos reativando os preços da última carga válida
  AND DATE(mt.dt_ultima_revisao) = '2026-05-27';


-- 2. Preencher a data/hora de inativação para os preços antigos dos módulos Karams que de fato foram substituídos hoje.
-- (Isso atualizará exatamente 390 registros locais, correspondentes aos 46 módulos que receberam preços novos hoje).
UPDATE pi.modulo_tecido mt
SET data_hora_inativacao = NOW()
FROM pi.modulo m
WHERE mt.id_modulo = m.id
  AND m.id_fornecedor = 1
  AND mt.fl_ativo = false
  AND DATE(mt.dt_ultima_revisao) = '2026-05-27'
  -- O módulo tem preços ativos na nova tabela
  AND mt.id_modulo IN (
      SELECT DISTINCT sub_mt.id_modulo 
      FROM pi.modulo_tecido sub_mt 
      WHERE sub_mt.fl_ativo = true
  );

COMMIT;
