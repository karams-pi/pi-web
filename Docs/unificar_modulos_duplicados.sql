-- ==========================================================================
-- UNIFICAÇÃO DE MÓDULOS DUPLICADOS NO BANCO DE DADOS (pi_db)
-- Total de módulos a unificar: 16
-- ==========================================================================

BEGIN TRANSACTION;

-- --------------------------------------------------------------------------
-- [01] Livintus - CHABLIS | Manter ID 5684 <- Mesclar ID 5471
-- --------------------------------------------------------------------------
UPDATE pi.sub_modulo SET id_modulo = 5684 WHERE id_modulo = 5471;
UPDATE pi.pi_item p
SET id_modulo_tecido = mt_keep.id
FROM pi.modulo_tecido mt_rem
JOIN pi.modulo_tecido mt_keep 
  ON mt_keep.id_modulo = 5684 
 AND mt_keep.id_tecido = mt_rem.id_tecido 
 AND mt_keep.fl_ativo = true
WHERE p.id_modulo_tecido = mt_rem.id 
  AND mt_rem.id_modulo = 5471;
DELETE FROM pi.modulo_tecido WHERE id_modulo = 5471;
DELETE FROM pi.modulo WHERE id = 5471;

-- --------------------------------------------------------------------------
-- [02] Livintus - CHABLIS | Manter ID 5685 <- Mesclar ID 5472
-- --------------------------------------------------------------------------
UPDATE pi.sub_modulo SET id_modulo = 5685 WHERE id_modulo = 5472;
UPDATE pi.pi_item p
SET id_modulo_tecido = mt_keep.id
FROM pi.modulo_tecido mt_rem
JOIN pi.modulo_tecido mt_keep 
  ON mt_keep.id_modulo = 5685 
 AND mt_keep.id_tecido = mt_rem.id_tecido 
 AND mt_keep.fl_ativo = true
WHERE p.id_modulo_tecido = mt_rem.id 
  AND mt_rem.id_modulo = 5472;
DELETE FROM pi.modulo_tecido WHERE id_modulo = 5472;
DELETE FROM pi.modulo WHERE id = 5472;

-- --------------------------------------------------------------------------
-- [03] Livintus - CHABLIS | Manter ID 5686 <- Mesclar ID 5473
-- --------------------------------------------------------------------------
UPDATE pi.sub_modulo SET id_modulo = 5686 WHERE id_modulo = 5473;
UPDATE pi.pi_item p
SET id_modulo_tecido = mt_keep.id
FROM pi.modulo_tecido mt_rem
JOIN pi.modulo_tecido mt_keep 
  ON mt_keep.id_modulo = 5686 
 AND mt_keep.id_tecido = mt_rem.id_tecido 
 AND mt_keep.fl_ativo = true
WHERE p.id_modulo_tecido = mt_rem.id 
  AND mt_rem.id_modulo = 5473;
DELETE FROM pi.modulo_tecido WHERE id_modulo = 5473;
DELETE FROM pi.modulo WHERE id = 5473;

-- --------------------------------------------------------------------------
-- [04] Livintus - BALDUZZI | Manter ID 5373 <- Mesclar ID 5582
-- --------------------------------------------------------------------------
UPDATE pi.sub_modulo SET id_modulo = 5373 WHERE id_modulo = 5582;
UPDATE pi.pi_item p
SET id_modulo_tecido = mt_keep.id
FROM pi.modulo_tecido mt_rem
JOIN pi.modulo_tecido mt_keep 
  ON mt_keep.id_modulo = 5373 
 AND mt_keep.id_tecido = mt_rem.id_tecido 
 AND mt_keep.fl_ativo = true
WHERE p.id_modulo_tecido = mt_rem.id 
  AND mt_rem.id_modulo = 5582;
DELETE FROM pi.modulo_tecido WHERE id_modulo = 5582;
DELETE FROM pi.modulo WHERE id = 5582;

-- --------------------------------------------------------------------------
-- [05] Livintus - BALDUZZI | Manter ID 5580 <- Mesclar ID 5588
-- --------------------------------------------------------------------------
UPDATE pi.sub_modulo SET id_modulo = 5580 WHERE id_modulo = 5588;
UPDATE pi.pi_item p
SET id_modulo_tecido = mt_keep.id
FROM pi.modulo_tecido mt_rem
JOIN pi.modulo_tecido mt_keep 
  ON mt_keep.id_modulo = 5580 
 AND mt_keep.id_tecido = mt_rem.id_tecido 
 AND mt_keep.fl_ativo = true
WHERE p.id_modulo_tecido = mt_rem.id 
  AND mt_rem.id_modulo = 5588;
DELETE FROM pi.modulo_tecido WHERE id_modulo = 5588;
DELETE FROM pi.modulo WHERE id = 5588;

-- --------------------------------------------------------------------------
-- [06] Livintus - BALDUZZI | Manter ID 5374 <- Mesclar ID 5583
-- --------------------------------------------------------------------------
UPDATE pi.sub_modulo SET id_modulo = 5374 WHERE id_modulo = 5583;
UPDATE pi.pi_item p
SET id_modulo_tecido = mt_keep.id
FROM pi.modulo_tecido mt_rem
JOIN pi.modulo_tecido mt_keep 
  ON mt_keep.id_modulo = 5374 
 AND mt_keep.id_tecido = mt_rem.id_tecido 
 AND mt_keep.fl_ativo = true
WHERE p.id_modulo_tecido = mt_rem.id 
  AND mt_rem.id_modulo = 5583;
DELETE FROM pi.modulo_tecido WHERE id_modulo = 5583;
DELETE FROM pi.modulo WHERE id = 5583;

-- --------------------------------------------------------------------------
-- [07] Livintus - BALDUZZI | Manter ID 5375 <- Mesclar ID 5584
-- --------------------------------------------------------------------------
UPDATE pi.sub_modulo SET id_modulo = 5375 WHERE id_modulo = 5584;
UPDATE pi.pi_item p
SET id_modulo_tecido = mt_keep.id
FROM pi.modulo_tecido mt_rem
JOIN pi.modulo_tecido mt_keep 
  ON mt_keep.id_modulo = 5375 
 AND mt_keep.id_tecido = mt_rem.id_tecido 
 AND mt_keep.fl_ativo = true
WHERE p.id_modulo_tecido = mt_rem.id 
  AND mt_rem.id_modulo = 5584;
DELETE FROM pi.modulo_tecido WHERE id_modulo = 5584;
DELETE FROM pi.modulo WHERE id = 5584;

-- --------------------------------------------------------------------------
-- [08] Livintus - BAROLO | Manter ID 5442 <- Mesclar ID 5655
-- --------------------------------------------------------------------------
UPDATE pi.modulo SET descricao = 'BAROLO - PEÇA ÚNICA ASSENTOS S/BÇ: 1,36M' WHERE id = 5442;
UPDATE pi.sub_modulo SET id_modulo = 5442 WHERE id_modulo = 5655;
UPDATE pi.pi_item p
SET id_modulo_tecido = mt_keep.id
FROM pi.modulo_tecido mt_rem
JOIN pi.modulo_tecido mt_keep 
  ON mt_keep.id_modulo = 5442 
 AND mt_keep.id_tecido = mt_rem.id_tecido 
 AND mt_keep.fl_ativo = true
WHERE p.id_modulo_tecido = mt_rem.id 
  AND mt_rem.id_modulo = 5655;
DELETE FROM pi.modulo_tecido WHERE id_modulo = 5655;
DELETE FROM pi.modulo WHERE id = 5655;

-- --------------------------------------------------------------------------
-- [09] Livintus - BAROLO | Manter ID 5443 <- Mesclar ID 5656
-- --------------------------------------------------------------------------
UPDATE pi.modulo SET descricao = 'BAROLO - PEÇA ÚNICA ASSENTOS S/BÇ: 1,86M' WHERE id = 5443;
UPDATE pi.sub_modulo SET id_modulo = 5443 WHERE id_modulo = 5656;
UPDATE pi.pi_item p
SET id_modulo_tecido = mt_keep.id
FROM pi.modulo_tecido mt_rem
JOIN pi.modulo_tecido mt_keep 
  ON mt_keep.id_modulo = 5443 
 AND mt_keep.id_tecido = mt_rem.id_tecido 
 AND mt_keep.fl_ativo = true
WHERE p.id_modulo_tecido = mt_rem.id 
  AND mt_rem.id_modulo = 5656;
DELETE FROM pi.modulo_tecido WHERE id_modulo = 5656;
DELETE FROM pi.modulo WHERE id = 5656;

-- --------------------------------------------------------------------------
-- [10] Livintus - AURORA | Manter ID 5444 <- Mesclar ID 5657
-- --------------------------------------------------------------------------
UPDATE pi.modulo SET descricao = 'AURORA - PEÇA ÚNICA ASSENTOS S/BÇ: 1,64M' WHERE id = 5444;
UPDATE pi.sub_modulo SET id_modulo = 5444 WHERE id_modulo = 5657;
UPDATE pi.pi_item p
SET id_modulo_tecido = mt_keep.id
FROM pi.modulo_tecido mt_rem
JOIN pi.modulo_tecido mt_keep 
  ON mt_keep.id_modulo = 5444 
 AND mt_keep.id_tecido = mt_rem.id_tecido 
 AND mt_keep.fl_ativo = true
WHERE p.id_modulo_tecido = mt_rem.id 
  AND mt_rem.id_modulo = 5657;
DELETE FROM pi.modulo_tecido WHERE id_modulo = 5657;
DELETE FROM pi.modulo WHERE id = 5657;

-- --------------------------------------------------------------------------
-- [11] Livintus - AURORA | Manter ID 5445 <- Mesclar ID 5658
-- --------------------------------------------------------------------------
UPDATE pi.modulo SET descricao = 'AURORA - PEÇA ÚNICA ASSENTOS S/BÇ: 1,84M' WHERE id = 5445;
UPDATE pi.sub_modulo SET id_modulo = 5445 WHERE id_modulo = 5658;
UPDATE pi.pi_item p
SET id_modulo_tecido = mt_keep.id
FROM pi.modulo_tecido mt_rem
JOIN pi.modulo_tecido mt_keep 
  ON mt_keep.id_modulo = 5445 
 AND mt_keep.id_tecido = mt_rem.id_tecido 
 AND mt_keep.fl_ativo = true
WHERE p.id_modulo_tecido = mt_rem.id 
  AND mt_rem.id_modulo = 5658;
DELETE FROM pi.modulo_tecido WHERE id_modulo = 5658;
DELETE FROM pi.modulo WHERE id = 5658;

-- --------------------------------------------------------------------------
-- [12] Livintus - AURORA | Manter ID 5446 <- Mesclar ID 5659
-- --------------------------------------------------------------------------
UPDATE pi.modulo SET descricao = 'AURORA - PEÇA ÚNICA ASSENTOS S/BÇ: 2,04M' WHERE id = 5446;
UPDATE pi.sub_modulo SET id_modulo = 5446 WHERE id_modulo = 5659;
UPDATE pi.pi_item p
SET id_modulo_tecido = mt_keep.id
FROM pi.modulo_tecido mt_rem
JOIN pi.modulo_tecido mt_keep 
  ON mt_keep.id_modulo = 5446 
 AND mt_keep.id_tecido = mt_rem.id_tecido 
 AND mt_keep.fl_ativo = true
WHERE p.id_modulo_tecido = mt_rem.id 
  AND mt_rem.id_modulo = 5659;
DELETE FROM pi.modulo_tecido WHERE id_modulo = 5659;
DELETE FROM pi.modulo WHERE id = 5659;

-- --------------------------------------------------------------------------
-- [13] Livintus - POLTRONA ZOE | Manter ID 5490 <- Mesclar ID 5703
-- --------------------------------------------------------------------------
UPDATE pi.sub_modulo SET id_modulo = 5490 WHERE id_modulo = 5703;
UPDATE pi.pi_item p
SET id_modulo_tecido = mt_keep.id
FROM pi.modulo_tecido mt_rem
JOIN pi.modulo_tecido mt_keep 
  ON mt_keep.id_modulo = 5490 
 AND mt_keep.id_tecido = mt_rem.id_tecido 
 AND mt_keep.fl_ativo = true
WHERE p.id_modulo_tecido = mt_rem.id 
  AND mt_rem.id_modulo = 5703;
DELETE FROM pi.modulo_tecido WHERE id_modulo = 5703;
DELETE FROM pi.modulo WHERE id = 5703;

-- --------------------------------------------------------------------------
-- [14] Livintus - PUFF APALTA | Manter ID 5505 <- Mesclar ID 5718
-- --------------------------------------------------------------------------
UPDATE pi.sub_modulo SET id_modulo = 5505 WHERE id_modulo = 5718;
UPDATE pi.pi_item p
SET id_modulo_tecido = mt_keep.id
FROM pi.modulo_tecido mt_rem
JOIN pi.modulo_tecido mt_keep 
  ON mt_keep.id_modulo = 5505 
 AND mt_keep.id_tecido = mt_rem.id_tecido 
 AND mt_keep.fl_ativo = true
WHERE p.id_modulo_tecido = mt_rem.id 
  AND mt_rem.id_modulo = 5718;
DELETE FROM pi.modulo_tecido WHERE id_modulo = 5718;
DELETE FROM pi.modulo WHERE id = 5718;

-- --------------------------------------------------------------------------
-- [15] Livintus - PUFF APALTA | Manter ID 5506 <- Mesclar ID 5719
-- --------------------------------------------------------------------------
UPDATE pi.sub_modulo SET id_modulo = 5506 WHERE id_modulo = 5719;
UPDATE pi.pi_item p
SET id_modulo_tecido = mt_keep.id
FROM pi.modulo_tecido mt_rem
JOIN pi.modulo_tecido mt_keep 
  ON mt_keep.id_modulo = 5506 
 AND mt_keep.id_tecido = mt_rem.id_tecido 
 AND mt_keep.fl_ativo = true
WHERE p.id_modulo_tecido = mt_rem.id 
  AND mt_rem.id_modulo = 5719;
DELETE FROM pi.modulo_tecido WHERE id_modulo = 5719;
DELETE FROM pi.modulo WHERE id = 5719;

-- --------------------------------------------------------------------------
-- [16] Livintus - PUFF APALTA | Manter ID 5507 <- Mesclar ID 5720
-- --------------------------------------------------------------------------
UPDATE pi.sub_modulo SET id_modulo = 5507 WHERE id_modulo = 5720;
UPDATE pi.pi_item p
SET id_modulo_tecido = mt_keep.id
FROM pi.modulo_tecido mt_rem
JOIN pi.modulo_tecido mt_keep 
  ON mt_keep.id_modulo = 5507 
 AND mt_keep.id_tecido = mt_rem.id_tecido 
 AND mt_keep.fl_ativo = true
WHERE p.id_modulo_tecido = mt_rem.id 
  AND mt_rem.id_modulo = 5720;
DELETE FROM pi.modulo_tecido WHERE id_modulo = 5720;
DELETE FROM pi.modulo WHERE id = 5720;

COMMIT;