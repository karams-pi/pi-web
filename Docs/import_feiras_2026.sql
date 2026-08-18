-- ==========================================================================
-- IMPORTAÇÃO DE PREÇOS E MÓDULOS DE FEIRAS 2026 (FERGUILE E LIVINTUS)
-- Gerado automaticamente para incluir novos e atualizar existentes
-- ==========================================================================

BEGIN TRANSACTION;

-- 1. Garantir que todas as marcas/modelos existem no banco de dados
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'ALLURE', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'ALLURE');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'ATUALLE', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'ATUALLE');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'AUDAX', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'AUDAX');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'AURORA', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'AURORA');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'BALDUZZI', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'BALDUZZI');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'BANDINI', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'BANDINI');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'BAROLO', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'BAROLO');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'CAYMAN', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'CAYMAN');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'CHABLIS', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'CHABLIS');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'CHANDON GIRATÓRIA', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'CHANDON GIRATÓRIA');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'COIMBRA', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'COIMBRA');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'CONDOR', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'CONDOR');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'CORBERLLI', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'CORBERLLI');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'CORDERO', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'CORDERO');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'FERRARA', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'FERRARA');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'FRASCATI', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'FRASCATI');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'INOVARE', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'INOVARE');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'INSIEME', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'INSIEME');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'KYOTO', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'KYOTO');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'LECCE GIRATORIA', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'LECCE GIRATORIA');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'LECCE GIRATÓRIA', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'LECCE GIRATÓRIA');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'LORD', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'LORD');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'LORIENT', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'LORIENT');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'MILANO', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'MILANO');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'NARBONE', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'NARBONE');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'NATURE', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'NATURE');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'NICE', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'NICE');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'NOBILE', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'NOBILE');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'PERINI', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'PERINI');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'POLTRONA ALANA ELÉTRICA', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'POLTRONA ALANA ELÉTRICA');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'POLTRONA ZOE', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'POLTRONA ZOE');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'PUFF APALTA', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'PUFF APALTA');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'PUFF BAROLO', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'PUFF BAROLO');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'PUFF CHANDON', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'PUFF CHANDON');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'RUBI', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'RUBI');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'SOLEN', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'SOLEN');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'ZOE GIRATÓRIA', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'ZOE GIRATÓRIA');

-- 2. Garantir que todos os tecidos/couros existem no banco de dados
INSERT INTO pi.tecido (nome) SELECT 'CO-5' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = 'CO-5');
INSERT INTO pi.tecido (nome) SELECT 'CO-6' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = 'CO-6');
INSERT INTO pi.tecido (nome) SELECT 'CO-7' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = 'CO-7');
INSERT INTO pi.tecido (nome) SELECT 'TC-10' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = 'TC-10');
INSERT INTO pi.tecido (nome) SELECT 'TC-12' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = 'TC-12');
INSERT INTO pi.tecido (nome) SELECT 'TC-13' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = 'TC-13');
INSERT INTO pi.tecido (nome) SELECT 'TC-14' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = 'TC-14');
INSERT INTO pi.tecido (nome) SELECT 'TC-14 / ST' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST');
INSERT INTO pi.tecido (nome) SELECT 'TC-16' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = 'TC-16');
INSERT INTO pi.tecido (nome) SELECT 'TC-18' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = 'TC-18');
INSERT INTO pi.tecido (nome) SELECT 'TC/NOBUCK/ST' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = 'TC/NOBUCK/ST');
INSERT INTO pi.tecido (nome) SELECT 'TC/ST' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = 'TC/ST');

-- 3. IMPORTAÇÃO FERGUILE (Fornecedor 3 | Categoria 26)
-- ==========================================================================

-- Planilha Linha 3 | Marca: BALDUZZI | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (3, 26, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'BALDUZZI' LIMIT 1), 'MÓDULO - 1 LUGAR COMBRAÇO - Assento s/bç: 0,75m', 1.08, 1.14, 0.90, 0.75)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1395.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1361.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1415.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1440.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1495.000, true, NOW());

-- Planilha Linha 8 | Marca: BALDUZZI | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (3, 26, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'BALDUZZI' LIMIT 1), 'MÓDULO - 1 LUGAR COMBRAÇO - Assento s/bç: 0,85m', 1.18, 1.14, 0.90, 0.85)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1455.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1415.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1475.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1505.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1565.000, true, NOW());

-- Planilha Linha 13 | Marca: BALDUZZI | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (3, 26, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'BALDUZZI' LIMIT 1), 'MÓDULO - 1 LUGAR COMBRAÇO - Assento s/bç: 0,95m', 1.28, 1.14, 0.90, 0.95)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1505.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1470.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1530.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1560.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1620.000, true, NOW());

-- Planilha Linha 18 | Marca: BALDUZZI | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (3, 26, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'BALDUZZI' LIMIT 1), 'MÓDULO - 1 LUGAR SEMBRAÇO - Assento s/bç: 0,75m', 0.75, 1.14, 0.90, 0.75)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1230.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1205.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1250.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1265.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1305.000, true, NOW());

-- Planilha Linha 23 | Marca: BALDUZZI | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (3, 26, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'BALDUZZI' LIMIT 1), 'MÓDULO - 1 LUGAR SEMBRAÇO - Assento s/bç: 0,85m', 0.85, 1.14, 0.90, 0.85)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1285.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1255.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1299.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1320.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1365.000, true, NOW());

-- Planilha Linha 28 | Marca: BALDUZZI | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (3, 26, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'BALDUZZI' LIMIT 1), 'MÓDULO - 1 LUGAR SEMBRAÇO - Assento s/bç: 0,95m', 0.95, 1.14, 0.90, 0.95)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1340.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1310.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1360.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1380.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1430.000, true, NOW());

-- Planilha Linha 33 | Marca: BALDUZZI | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (3, 26, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'BALDUZZI' LIMIT 1), 'MÓDULO CHAISE - Assento s/bç: 0,75m', 1.08, 1.59, 0.90, 0.75)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1550.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1510.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1570.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1599.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1670.000, true, NOW());

-- Planilha Linha 38 | Marca: BALDUZZI | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (3, 26, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'BALDUZZI' LIMIT 1), 'MÓDULO CHAISE - Assento s/bç: 0,85m', 1.18, 1.59, 0.90, 0.85)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1610.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1570.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1640.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1670.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1730.000, true, NOW());

-- Planilha Linha 43 | Marca: BALDUZZI | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (3, 26, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'BALDUZZI' LIMIT 1), 'MÓDULO CHAISE - Assento s/bç: 0,95m', 1.28, 1.59, 0.90, 0.95)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1675.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1630.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1700.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1735.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1800.000, true, NOW());

-- Planilha Linha 48 | Marca: BALDUZZI | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (3, 26, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'BALDUZZI' LIMIT 1), 'PUFF', 1.14, 1.14, 0.45, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 750.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 730.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 760.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 780.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 800.000, true, NOW());

-- Planilha Linha 53 | Marca: LORIENT | ID Existente: 5154 (Exact Match)
UPDATE pi.modulo SET largura = 2.10, profundidade = 1.13, altura = 1.06, pa = 0.00, descricao = 'PEÇA ÚNICA - 2 ASSENTOS' WHERE id = 5154;
UPDATE pi.modulo_tecido SET valor_tecido = 1651.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5154 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5154, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1651.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5154 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1547.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5154 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5154, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1547.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5154 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1719.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5154 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5154, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1719.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5154 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1812.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5154 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5154, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1812.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5154 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1885.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5154 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5154, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1885.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5154 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 58 | Marca: LORIENT | ID Existente: 5155 (Exact Match)
UPDATE pi.modulo SET largura = 2.30, profundidade = 1.13, altura = 1.06, pa = 0.00, descricao = 'PEÇA ÚNICA - 2 ASSENTOS' WHERE id = 5155;
UPDATE pi.modulo_tecido SET valor_tecido = 1766.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5155 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5155, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1766.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5155 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1662.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5155 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5155, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1662.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5155 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1833.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5155 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5155, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1833.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5155 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1926.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5155 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5155, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1926.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5155 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2005.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5155 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5155, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2005.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5155 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 63 | Marca: LORIENT | ID Existente: 5156 (Exact Match)
UPDATE pi.modulo SET largura = 2.50, profundidade = 1.13, altura = 1.06, pa = 0.00, descricao = 'PEÇA ÚNICA - 2 ASSENTOS' WHERE id = 5156;
UPDATE pi.modulo_tecido SET valor_tecido = 1914.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5156 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5156, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1914.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5156 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1788.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5156 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5156, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1788.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5156 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1983.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5156 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5156, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1983.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5156 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2087.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5156 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5156, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 2087.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5156 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2170.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5156 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5156, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2170.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5156 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 68 | Marca: LORIENT | ID Existente: 5157 (Exact Match)
UPDATE pi.modulo SET largura = 2.50, profundidade = 1.13, altura = 1.06, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5157;
UPDATE pi.modulo_tecido SET valor_tecido = 2051.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5157 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5157, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2051.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5157 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1926.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5157 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5157, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1926.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5157 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2131.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5157 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5157, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2131.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5157 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2235.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5157 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5157, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 2235.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5157 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2325.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5157 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5157, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2325.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5157 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 73 | Marca: LORIENT | ID Existente: 5158 (Exact Match)
UPDATE pi.modulo SET largura = 2.80, profundidade = 1.13, altura = 1.06, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5158;
UPDATE pi.modulo_tecido SET valor_tecido = 2326.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5158 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5158, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2326.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5158 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2190.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5158 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5158, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2190.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5158 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2418.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5158 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5158, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2418.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5158 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2533.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5158 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5158, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 2533.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5158 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2635.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5158 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5158, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2635.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5158 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 78 | Marca: COIMBRA | ID Existente: 5182 (Exact Match)
UPDATE pi.modulo SET largura = 1.90, profundidade = 1.13, altura = 0.88, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5182;
UPDATE pi.modulo_tecido SET valor_tecido = 1980.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5182 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5182, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1980.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5182 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2070.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5182 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5182, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2070.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5182 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2220.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5182 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5182, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2220.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5182 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2290.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5182 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5182, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 2290.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5182 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2410.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5182 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5182, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2410.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5182 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2690.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5182 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5182, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 2690.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5182 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 84 | Marca: COIMBRA | ID Existente: 5183 (Exact Match)
UPDATE pi.modulo SET largura = 2.10, profundidade = 1.13, altura = 0.88, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5183;
UPDATE pi.modulo_tecido SET valor_tecido = 2280.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5183 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5183, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2280.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5183 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2190.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5183 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5183, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2190.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5183 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2340.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5183 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5183, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2340.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5183 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2420.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5183 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5183, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 2420.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5183 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2550.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5183 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5183, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2550.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5183 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2840.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5183 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5183, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 2840.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5183 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 90 | Marca: COIMBRA | ID Existente: 5184 (Exact Match)
UPDATE pi.modulo SET largura = 2.30, profundidade = 1.13, altura = 0.88, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5184;
UPDATE pi.modulo_tecido SET valor_tecido = 2430.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5184 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5184, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2430.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5184 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2330.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5184 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5184, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2330.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5184 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2498.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5184 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5184, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2498.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5184 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2580.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5184 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5184, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 2580.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5184 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2720.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5184 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5184, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2720.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5184 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3020.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5184 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5184, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 3020.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5184 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 96 | Marca: COIMBRA | ID Existente: 5185 (Exact Match)
UPDATE pi.modulo SET largura = 2.50, profundidade = 1.13, altura = 0.88, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5185;
UPDATE pi.modulo_tecido SET valor_tecido = 2580.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5185 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5185, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2580.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5185 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2460.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5185 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5185, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2460.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5185 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2650.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5185 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5185, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2650.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5185 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2730.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5185 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5185, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 2730.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5185 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2880.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5185 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5185, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2880.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5185 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3220.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5185 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5185, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 3220.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5185 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 102 | Marca: COIMBRA | ID Existente: 5186 (Exact Match)
UPDATE pi.modulo SET largura = 2.70, profundidade = 1.13, altura = 0.88, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5186;
UPDATE pi.modulo_tecido SET valor_tecido = 2720.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5186 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5186, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2720.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5186 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2598.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5186 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5186, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2598.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5186 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2790.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5186 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5186, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2790.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5186 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2880.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5186 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5186, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 2880.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5186 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3040.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5186 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5186, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 3040.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5186 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3390.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5186 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5186, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 3390.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5186 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 108 | Marca: LORD | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (3, 26, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'LORD' LIMIT 1), 'BIPARTIDO - 
2 ASSENTOS', 2.00, 1.12, 0.93, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 4205.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 4100.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 4270.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 4350.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 4520.000, true, NOW());

-- Planilha Linha 113 | Marca: LORD | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (3, 26, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'LORD' LIMIT 1), 'BIPARTIDO - 
2 ASSENTOS', 2.20, 1.12, 0.93, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 4350.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 4240.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 4420.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 4500.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 4680.000, true, NOW());

-- Planilha Linha 118 | Marca: LORD | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (3, 26, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'LORD' LIMIT 1), 'BIPARTIDO - 
2 ASSENTOS', 2.40, 1.12, 0.93, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 4540.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 4420.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 4610.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 4700.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 4880.000, true, NOW());

-- Planilha Linha 123 | Marca: LORD | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (3, 26, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'LORD' LIMIT 1), 'BIPARTIDO - 
2 ASSENTOS', 2.60, 1.12, 0.93, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 4700.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 4580.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 4780.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 4870.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 5060.000, true, NOW());

-- Planilha Linha 128 | Marca: LORD | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (3, 26, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'LORD' LIMIT 1), 'BIPARTIDO - 
2 ASSENTOS', 2.80, 1.12, 0.93, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 4880.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 4750.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 4960.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 5050.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 5260.000, true, NOW());

-- Planilha Linha 133 | Marca: FRASCATI | ID Existente: 5785 (Exact Match)
UPDATE pi.modulo SET largura = 2.20, profundidade = 1.12, altura = 0.93, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5785;
UPDATE pi.modulo_tecido SET valor_tecido = 2310.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5785 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5785, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2310.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5785 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2210.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5785 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5785, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2210.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5785 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2370.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5785 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5785, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2370.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5785 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2450.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5785 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5785, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 2450.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5785 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2580.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5785 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5785, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2580.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5785 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2880.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5785 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5785, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 2880.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5785 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 139 | Marca: FRASCATI | ID Existente: 5786 (Exact Match)
UPDATE pi.modulo SET largura = 2.40, profundidade = 1.12, altura = 0.93, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5786;
UPDATE pi.modulo_tecido SET valor_tecido = 2440.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5786 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5786, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2440.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5786 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2330.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5786 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5786, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2330.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5786 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2500.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5786 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5786, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2500.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5786 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2580.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5786 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5786, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 2580.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5786 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2720.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5786 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5786, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2720.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5786 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3030.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5786 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5786, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 3030.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5786 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 145 | Marca: FRASCATI | ID Existente: 5787 (Exact Match)
UPDATE pi.modulo SET largura = 2.60, profundidade = 1.12, altura = 0.93, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5787;
UPDATE pi.modulo_tecido SET valor_tecido = 2590.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5787 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5787, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2590.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5787 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2480.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5787 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5787, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2480.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5787 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2650.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5787 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5787, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2650.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5787 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2730.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5787 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5787, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 2730.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5787 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2880.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5787 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5787, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2880.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5787 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3210.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5787 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5787, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 3210.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5787 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 151 | Marca: FRASCATI | ID Existente: 5788 (Exact Match)
UPDATE pi.modulo SET largura = 2.80, profundidade = 1.12, altura = 0.93, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5788;
UPDATE pi.modulo_tecido SET valor_tecido = 2720.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5788 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5788, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2720.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5788 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2610.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5788 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5788, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2610.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5788 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2790.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5788 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5788, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2790.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5788 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2880.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5788 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5788, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 2880.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5788 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3040.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5788 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5788, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 3040.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5788 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3380.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5788 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5788, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 3380.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5788 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 157 | Marca: FERRARA | ID Existente: 5290 (Exact Match)
UPDATE pi.modulo SET largura = 2.10, profundidade = 1.07, altura = 0.93, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5290;
UPDATE pi.modulo_tecido SET valor_tecido = 2035.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5290 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5290, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2035.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5290 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1940.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5290 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5290, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1940.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5290 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2095.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5290 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5290, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2095.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5290 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2165.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5290 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5290, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 2165.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5290 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2299.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5290 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5290, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2299.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5290 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2590.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5290 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5290, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 2590.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5290 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 163 | Marca: FERRARA | ID Existente: 5291 (Exact Match)
UPDATE pi.modulo SET largura = 2.30, profundidade = 1.07, altura = 0.93, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5291;
UPDATE pi.modulo_tecido SET valor_tecido = 2210.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5291 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5291, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2210.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5291 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2110.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5291 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5291, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2110.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5291 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2270.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5291 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5291, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2270.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5291 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2345.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5291 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5291, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 2345.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5291 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2490.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5291 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5291, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2490.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5291 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2790.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5291 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5291, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 2790.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5291 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 169 | Marca: FERRARA | ID Existente: 5292 (Exact Match)
UPDATE pi.modulo SET largura = 2.50, profundidade = 1.07, altura = 0.93, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5292;
UPDATE pi.modulo_tecido SET valor_tecido = 2420.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5292 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5292, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2420.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5292 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2320.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5292 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5292, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2320.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5292 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2490.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5292 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5292, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2490.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5292 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2570.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5292 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5292, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 2570.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5292 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2720.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5292 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5292, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2720.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5292 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3040.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5292 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5292, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 3040.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5292 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 175 | Marca: CAYMAN | ID Existente: 5187 (Exact Match)
UPDATE pi.modulo SET largura = 1.90, profundidade = 1.09, altura = 0.93, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5187;
UPDATE pi.modulo_tecido SET valor_tecido = 2030.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5187 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5187, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2030.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5187 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1949.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5187 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5187, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1949.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5187 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2170.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5187 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5187, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2170.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5187 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2240.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5187 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5187, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 2240.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5187 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2360.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5187 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5187, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2360.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5187 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2640.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5187 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5187, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 2640.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5187 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 181 | Marca: CAYMAN | ID Existente: 5188 (Exact Match)
UPDATE pi.modulo SET largura = 2.10, profundidade = 1.09, altura = 0.93, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5188;
UPDATE pi.modulo_tecido SET valor_tecido = 2240.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5188 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5188, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2240.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5188 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2150.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5188 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5188, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2150.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5188 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2300.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5188 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5188, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2300.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5188 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2380.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5188 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5188, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 2380.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5188 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2520.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5188 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5188, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2520.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5188 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2798.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5188 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5188, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 2798.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5188 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 187 | Marca: CAYMAN | ID Existente: 5189 (Exact Match)
UPDATE pi.modulo SET largura = 2.30, profundidade = 1.09, altura = 0.93, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5189;
UPDATE pi.modulo_tecido SET valor_tecido = 2370.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5189 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5189, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2370.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5189 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2270.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5189 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5189, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2270.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5189 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2430.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5189 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5189, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2430.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5189 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2520.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5189 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5189, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 2520.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5189 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2640.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5189 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5189, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2640.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5189 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2950.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5189 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5189, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 2950.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5189 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 193 | Marca: CAYMAN | ID Existente: 5190 (Exact Match)
UPDATE pi.modulo SET largura = 2.50, profundidade = 1.09, altura = 0.93, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5190;
UPDATE pi.modulo_tecido SET valor_tecido = 2510.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5190 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5190, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2510.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5190 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2410.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5190 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5190, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2410.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5190 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2580.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5190 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5190, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2580.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5190 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2650.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5190 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5190, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 2650.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5190 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2798.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5190 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5190, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2798.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5190 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3120.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5190 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5190, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 3120.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5190 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 199 | Marca: CAYMAN | ID Existente: 5191 (Exact Match)
UPDATE pi.modulo SET largura = 2.70, profundidade = 1.09, altura = 0.93, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5191;
UPDATE pi.modulo_tecido SET valor_tecido = 2640.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5191 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5191, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2640.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5191 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2540.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5191 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5191, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2540.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5191 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2720.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5191 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5191, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2720.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5191 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2790.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5191 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5191, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 2790.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5191 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2940.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5191 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5191, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2940.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5191 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3270.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5191 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5191, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 3270.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5191 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 205 | Marca: NATURE | ID Existente: 5192 (Exact Match)
UPDATE pi.modulo SET largura = 2.10, profundidade = 1.09, altura = 0.93, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5192;
UPDATE pi.modulo_tecido SET valor_tecido = 2235.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5192 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5192, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2235.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5192 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2143.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5192 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5192, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2143.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5192 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2289.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5192 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5192, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2289.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5192 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2372.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5192 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5192, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 2372.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5192 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2470.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5192 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5192, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2470.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5192 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2805.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5192 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5192, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 2805.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5192 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 211 | Marca: NATURE | ID Existente: 5193 (Exact Match)
UPDATE pi.modulo SET largura = 2.30, profundidade = 1.09, altura = 0.93, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5193;
UPDATE pi.modulo_tecido SET valor_tecido = 2361.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5193 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5193, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2361.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5193 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2257.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5193 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5193, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2257.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5193 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2430.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5193 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5193, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2430.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5193 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2510.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5193 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5193, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 2510.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5193 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2615.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5193 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5193, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2615.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5193 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2970.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5193 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5193, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 2970.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5193 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 217 | Marca: NATURE | ID Existente: 5194 (Exact Match)
UPDATE pi.modulo SET largura = 2.60, profundidade = 1.09, altura = 0.93, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5194;
UPDATE pi.modulo_tecido SET valor_tecido = 2544.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5194 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5194, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2544.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5194 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2452.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5194 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5194, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2452.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5194 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2613.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5194 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5194, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2613.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5194 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2705.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5194 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5194, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 2705.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5194 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2815.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5194 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5194, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2815.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5194 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3200.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5194 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5194, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 3200.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5194 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 223 | Marca: NATURE | ID Existente: 5195 (Exact Match)
UPDATE pi.modulo SET largura = 2.90, profundidade = 1.09, altura = 0.93, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5195;
UPDATE pi.modulo_tecido SET valor_tecido = 2727.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5195 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5195, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2727.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5195 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2602.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5195 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5195, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2602.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5195 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2797.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5195 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5195, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2797.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5195 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2887.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5195 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5195, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 2887.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5195 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3005.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5195 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5195, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 3005.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5195 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3415.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5195 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5195, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 3415.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5195 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 229 | Marca: INOVARE | ID Existente: 5196 (Exact Match)
UPDATE pi.modulo SET largura = 2.10, profundidade = 1.09, altura = 0.93, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5196;
UPDATE pi.modulo_tecido SET valor_tecido = 2340.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5196 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5196, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2340.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5196 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2230.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5196 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5196, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2230.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5196 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2400.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5196 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5196, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2400.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5196 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2480.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5196 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5196, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 2480.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5196 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2630.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5196 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5196, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2630.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5196 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2940.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5196 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5196, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 2940.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5196 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 235 | Marca: INOVARE | ID Existente: 5197 (Exact Match)
UPDATE pi.modulo SET largura = 2.40, profundidade = 1.09, altura = 0.93, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5197;
UPDATE pi.modulo_tecido SET valor_tecido = 2530.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5197 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5197, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2530.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5197 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2410.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5197 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5197, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2410.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5197 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2598.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5197 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5197, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2598.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5197 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2680.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5197 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5197, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 2680.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5197 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2840.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5197 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5197, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2840.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5197 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3180.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5197 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5197, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 3180.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5197 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 241 | Marca: INOVARE | ID Existente: 5198 (Exact Match)
UPDATE pi.modulo SET largura = 2.70, profundidade = 1.09, altura = 0.93, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5198;
UPDATE pi.modulo_tecido SET valor_tecido = 2700.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5198 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5198, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2700.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5198 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2580.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5198 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5198, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2580.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5198 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2780.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5198 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5198, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2780.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5198 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2880.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5198 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5198, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 2880.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5198 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3050.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5198 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5198, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 3050.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5198 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3420.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5198 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5198, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 3420.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5198 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 247 | Marca: ATUALLE | ID Existente: 5205 (Exact Match)
UPDATE pi.modulo SET largura = 2.10, profundidade = 1.04, altura = 1.05, pa = 0.00, descricao = 'PEÇA ÚNICA - 2 ASSENTOS' WHERE id = 5205;
UPDATE pi.modulo_tecido SET valor_tecido = 1468.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5205 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5205, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1468.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5205 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1387.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5205 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5205, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1387.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5205 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1525.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5205 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5205, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1525.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5205 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1594.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5205 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5205, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1594.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5205 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1695.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5205 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5205, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1695.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5205 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 252 | Marca: ATUALLE | ID Existente: 5206 (Exact Match)
UPDATE pi.modulo SET largura = 2.30, profundidade = 1.04, altura = 1.05, pa = 0.00, descricao = 'PEÇA ÚNICA - 2 ASSENTOS' WHERE id = 5206;
UPDATE pi.modulo_tecido SET valor_tecido = 1571.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5206 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5206, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1571.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5206 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1479.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5206 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5206, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1479.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5206 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1639.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5206 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5206, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1639.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5206 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1708.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5206 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5206, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1708.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5206 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1815.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5206 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5206, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1815.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5206 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 257 | Marca: ATUALLE | ID Existente: 5207 (Exact Match)
UPDATE pi.modulo SET largura = 2.30, profundidade = 1.04, altura = 1.05, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5207;
UPDATE pi.modulo_tecido SET valor_tecido = 1662.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5207 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5207, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1662.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5207 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1571.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5207 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5207, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1571.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5207 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1742.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5207 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5207, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1742.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5207 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1812.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5207 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5207, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1812.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5207 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1925.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5207 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5207, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1925.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5207 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 262 | Marca: ATUALLE | ID Existente: 5208 (Exact Match)
UPDATE pi.modulo SET largura = 2.50, profundidade = 1.04, altura = 1.05, pa = 0.00, descricao = 'PEÇA ÚNICA - 2 ASSENTOS' WHERE id = 5208;
UPDATE pi.modulo_tecido SET valor_tecido = 1686.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5208 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5208, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1686.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5208 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1594.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5208 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5208, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1594.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5208 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1754.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5208 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5208, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1754.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5208 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1833.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5208 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5208, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1833.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5208 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1950.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5208 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5208, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1950.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5208 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 267 | Marca: ATUALLE | ID Existente: 5209 (Exact Match)
UPDATE pi.modulo SET largura = 2.50, profundidade = 1.04, altura = 1.05, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5209;
UPDATE pi.modulo_tecido SET valor_tecido = 1788.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5209 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5209, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1788.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5209 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1674.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5209 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5209, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1674.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5209 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1856.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5209 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5209, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1856.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5209 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1948.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5209 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5209, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1948.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5209 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2070.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5209 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5209, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2070.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5209 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 272 | Marca: ATUALLE | ID Existente: 5210 (Exact Match)
UPDATE pi.modulo SET largura = 2.80, profundidade = 1.04, altura = 1.05, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5210;
UPDATE pi.modulo_tecido SET valor_tecido = 2040.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5210 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5210, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2040.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5210 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1926.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5210 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5210, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1926.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5210 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2109.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5210 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5210, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2109.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5210 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2224.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5210 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5210, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 2224.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5210 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2365.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5210 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5210, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2365.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5210 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 277 | Marca: ALLURE | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (3, 26, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'ALLURE' LIMIT 1), 'PEÇA ÚNICA - 2 ASSENTOS', 2.06, 1.02, 0.94, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1540.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1445.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1599.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1675.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1825.000, true, NOW());

-- Planilha Linha 282 | Marca: ALLURE | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (3, 26, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'ALLURE' LIMIT 1), 'PEÇA ÚNICA - 2 ASSENTOS', 2.26, 1.02, 0.94, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1655.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1555.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1720.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1799.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1960.000, true, NOW());

-- Planilha Linha 287 | Marca: ALLURE | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (3, 26, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'ALLURE' LIMIT 1), 'BIPARTIDO - 2 ASSENTOS', 2.26, 1.02, 0.94, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1780.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1670.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1850.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1930.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2110.000, true, NOW());

-- Planilha Linha 292 | Marca: ALLURE | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (3, 26, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'ALLURE' LIMIT 1), 'PEÇA ÚNICA - 2 ASSENTOS', 2.46, 1.02, 0.94, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1755.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1650.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1825.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1910.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2080.000, true, NOW());

-- Planilha Linha 297 | Marca: ALLURE | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (3, 26, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'ALLURE' LIMIT 1), 'BIPARTIDO - 2 ASSENTOS', 2.46, 1.02, 0.94, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1880.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1770.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1950.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 2040.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2220.000, true, NOW());

-- Planilha Linha 302 | Marca: ALLURE | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (3, 26, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'ALLURE' LIMIT 1), 'BIPARTIDO - 2 ASSENTOS', 2.76, 1.02, 0.94, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2100.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1970.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2180.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 2270.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2460.000, true, NOW());

-- Planilha Linha 307 | Marca: NOBILE | ID Existente: 5211 (Exact Match)
UPDATE pi.modulo SET largura = 2.10, profundidade = 1.05, altura = 0.93, pa = 0.00, descricao = 'PEÇA ÚNICA - 2 ASSENTOS' WHERE id = 5211;
UPDATE pi.modulo_tecido SET valor_tecido = 1479.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5211 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5211, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1479.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5211 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1377.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5211 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5211, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1377.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5211 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1536.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5211 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5211, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1536.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5211 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1617.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5211 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5211, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1617.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5211 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1720.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5211 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5211, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1720.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5211 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2020.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5211 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5211, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 2020.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5211 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 313 | Marca: NOBILE | ID Existente: 5212 (Exact Match)
UPDATE pi.modulo SET largura = 2.30, profundidade = 1.05, altura = 0.93, pa = 0.00, descricao = 'PEÇA ÚNICA - 2 ASSENTOS' WHERE id = 5212;
UPDATE pi.modulo_tecido SET valor_tecido = 1582.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5212 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5212, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1582.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5212 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1479.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5212 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5212, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1479.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5212 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1651.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5212 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5212, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1651.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5212 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1731.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5212 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5212, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1731.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5212 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1840.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5212 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5212, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1840.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5212 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2160.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5212 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5212, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 2160.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5212 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 319 | Marca: NOBILE | ID Existente: 5213 (Exact Match)
UPDATE pi.modulo SET largura = 2.50, profundidade = 1.05, altura = 0.93, pa = 0.00, descricao = 'PEÇA ÚNICA - 2 ASSENTOS' WHERE id = 5213;
UPDATE pi.modulo_tecido SET valor_tecido = 1686.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5213 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5213, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1686.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5213 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1582.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5213 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5213, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1582.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5213 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1754.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5213 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5213, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1754.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5213 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1856.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5213 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5213, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1856.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5213 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1975.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5213 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5213, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1975.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5213 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2320.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5213 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5213, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 2320.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5213 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 325 | Marca: NOBILE | ID Existente: 5214 (Exact Match)
UPDATE pi.modulo SET largura = 2.50, profundidade = 1.05, altura = 0.93, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5214;
UPDATE pi.modulo_tecido SET valor_tecido = 1832.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5214 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5214, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1832.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5214 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1696.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5214 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5214, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1696.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5214 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1903.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5214 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5214, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1903.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5214 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2006.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5214 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5214, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 2006.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5214 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2130.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5214 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5214, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2130.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5214 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2500.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5214 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5214, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 2500.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5214 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 331 | Marca: NOBILE | ID Existente: 5215 (Exact Match)
UPDATE pi.modulo SET largura = 2.80, profundidade = 1.05, altura = 0.93, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5215;
UPDATE pi.modulo_tecido SET valor_tecido = 2061.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5215 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5215, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2061.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5215 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1914.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5215 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5215, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1914.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5215 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2131.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5215 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5215, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2131.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5215 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2247.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5215 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5215, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 2247.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5215 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2390.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5215 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5215, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2390.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5215 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2800.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5215 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5215, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 2800.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5215 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 337 | Marca: NOBILE | ID Existente: 5216 (Exact Match)
UPDATE pi.modulo SET largura = 3.20, profundidade = 1.05, altura = 0.93, pa = 0.00, descricao = '3 MÓDULOS' WHERE id = 5216;
UPDATE pi.modulo_tecido SET valor_tecido = 2602.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5216 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5216, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2602.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5216 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2423.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5216 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5216, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2423.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5216 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2705.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5216 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5216, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2705.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5216 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2853.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5216 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5216, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 2853.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5216 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3035.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5216 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5216, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 3035.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5216 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3570.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5216 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5216, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 3570.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5216 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 355 | Marca: NOBILE | ID Existente: 5217 (Exact Match)
UPDATE pi.modulo SET largura = 3.50, profundidade = 1.05, altura = 0.93, pa = 0.00, descricao = '3 MÓDULOS' WHERE id = 5217;
UPDATE pi.modulo_tecido SET valor_tecido = 2733.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5217 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5217, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 2733.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5217 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2544.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5217 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5217, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2544.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5217 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2853.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5217 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5217, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2853.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5217 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3008.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5217 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5217, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 3008.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5217 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3200.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5217 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5217, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 3200.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5217 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3760.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5217 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5217, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 3760.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5217 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 373 | Marca: NOBILE | ID Existente: 5218 (Exact Match)
UPDATE pi.modulo SET largura = 3.95, profundidade = 1.05, altura = 0.93, pa = 0.00, descricao = '3 MÓDULOS' WHERE id = 5218;
UPDATE pi.modulo_tecido SET valor_tecido = 3077.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5218 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5218, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 3077.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5218 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2871.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5218 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5218, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 2871.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5218 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3196.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5218 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5218, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 3196.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5218 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3369.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5218 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5218, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 3369.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5218 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3580.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5218 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5218, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 3580.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5218 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 4210.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5218 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5218, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 4210.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5218 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 391 | Marca: NARBONE | ID Existente: 5143 (Exact Match)
UPDATE pi.modulo SET largura = 2.10, profundidade = 1.10, altura = 1.10, pa = 0.00, descricao = 'PEÇA ÚNICA - 2 ASSENTOS' WHERE id = 5143;
UPDATE pi.modulo_tecido SET valor_tecido = 1479.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5143 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5143, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1479.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5143 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1387.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5143 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5143, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1387.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5143 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1536.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5143 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5143, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1536.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5143 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1623.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5143 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5143, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1623.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5143 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1690.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5143 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5143, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1690.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5143 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 396 | Marca: NARBONE | ID Existente: 5144 (Exact Match)
UPDATE pi.modulo SET largura = 2.30, profundidade = 1.10, altura = 1.10, pa = 0.00, descricao = 'PEÇA ÚNICA - 2 ASSENTOS' WHERE id = 5144;
UPDATE pi.modulo_tecido SET valor_tecido = 1582.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5144 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5144, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1582.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5144 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1479.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5144 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5144, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1479.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5144 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1651.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5144 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5144, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1651.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5144 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1742.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5144 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5144, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1742.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5144 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1810.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5144 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5144, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1810.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5144 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 401 | Marca: NARBONE | ID Existente: 5145 (Exact Match)
UPDATE pi.modulo SET largura = 2.50, profundidade = 1.10, altura = 1.10, pa = 0.00, descricao = 'PEÇA ÚNICA - 2 ASSENTOS' WHERE id = 5145;
UPDATE pi.modulo_tecido SET valor_tecido = 1696.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5145 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5145, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1696.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5145 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1594.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5145 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5145, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1594.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5145 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1766.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5145 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5145, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1766.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5145 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1856.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5145 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5145, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1856.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5145 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1930.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5145 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5145, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1930.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5145 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 406 | Marca: AUDAX | ID Existente: 5774 (Exact Match)
UPDATE pi.modulo SET largura = 2.10, profundidade = 1.00, altura = 1.10, pa = 0.00, descricao = 'PEÇA ÚNICA - 2 ASSENTOS' WHERE id = 5774;
UPDATE pi.modulo_tecido SET valor_tecido = 1450.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5774 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5774, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1450.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5774 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1355.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5774 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5774, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1355.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5774 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1505.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5774 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5774, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1505.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5774 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1580.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5774 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5774, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 1580.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5774 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1710.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5774 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5774, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1710.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5774 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 411 | Marca: AUDAX | ID Existente: 5775 (Exact Match)
UPDATE pi.modulo SET largura = 2.30, profundidade = 1.00, altura = 1.10, pa = 0.00, descricao = 'PEÇA ÚNICA - 2 ASSENTOS' WHERE id = 5775;
UPDATE pi.modulo_tecido SET valor_tecido = 1999.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5775 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5775, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1999.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5775 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1550.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5775 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5775, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1550.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5775 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1615.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5775 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5775, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1615.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5775 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1695.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5775 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5775, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 1695.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5775 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1835.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5775 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5775, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1835.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5775 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 416 | Marca: AUDAX | ID Existente: 5776 (Exact Match)
UPDATE pi.modulo SET largura = 2.30, profundidade = 1.00, altura = 1.10, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5776;
UPDATE pi.modulo_tecido SET valor_tecido = 1830.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5776 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5776, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1830.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5776 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1730.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5776 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5776, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1730.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5776 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1900.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5776 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5776, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1900.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5776 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1970.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5776 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5776, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 1970.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5776 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2120.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5776 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5776, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2120.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5776 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 421 | Marca: AUDAX | ID Existente: 5777 (Exact Match)
UPDATE pi.modulo SET largura = 2.50, profundidade = 1.00, altura = 1.10, pa = 0.00, descricao = 'PEÇA ÚNICA - 2 ASSENTOS' WHERE id = 5777;
UPDATE pi.modulo_tecido SET valor_tecido = 1665.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5777 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5777, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1665.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5777 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1555.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5777 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5777, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1555.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5777 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1730.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5777 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5777, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1730.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5777 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1815.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5777 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5777, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 1815.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5777 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1965.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5777 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5777, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1965.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5777 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 426 | Marca: AUDAX | ID Existente: 5778 (Exact Match)
UPDATE pi.modulo SET largura = 2.50, profundidade = 1.00, altura = 1.10, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5778;
UPDATE pi.modulo_tecido SET valor_tecido = 1940.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5778 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5778, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1940.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5778 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1830.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5778 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5778, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1830.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5778 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2040.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5778 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5778, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 2040.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5778 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2090.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5778 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5778, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 2090.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5778 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2240.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5778 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5778, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 2240.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5778 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 431 | Marca: KYOTO | ID Existente: 5228 (Exact Match)
UPDATE pi.modulo SET largura = 2.10, profundidade = 0.98, altura = 1.08, pa = 0.00, descricao = 'PEÇA ÚNICA - 2 ASSENTOS' WHERE id = 5228;
UPDATE pi.modulo_tecido SET valor_tecido = 1479.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5228 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5228, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1479.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5228 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1387.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5228 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5228, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1387.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5228 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1536.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5228 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5228, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1536.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5228 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1617.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5228 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5228, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1617.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5228 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 435 | Marca: KYOTO | ID Existente: 5229 (Exact Match)
UPDATE pi.modulo SET largura = 2.30, profundidade = 0.98, altura = 1.08, pa = 0.00, descricao = 'PEÇA ÚNICA - 2 ASSENTOS' WHERE id = 5229;
UPDATE pi.modulo_tecido SET valor_tecido = 1582.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5229 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5229, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1582.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5229 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1490.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5229 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5229, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1490.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5229 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1651.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5229 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5229, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1651.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5229 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1731.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5229 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5229, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1731.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5229 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 439 | Marca: KYOTO | ID Existente: 5230 (Exact Match)
UPDATE pi.modulo SET largura = 2.50, profundidade = 0.98, altura = 1.08, pa = 0.00, descricao = 'PEÇA ÚNICA - 2 ASSENTOS' WHERE id = 5230;
UPDATE pi.modulo_tecido SET valor_tecido = 1708.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5230 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5230, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1708.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5230 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1604.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5230 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5230, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1604.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5230 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1777.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5230 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5230, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1777.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5230 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1869.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5230 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5230, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1869.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5230 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 443 | Marca: KYOTO | ID Existente: 5231 (Exact Match)
UPDATE pi.modulo SET largura = 2.50, profundidade = 0.98, altura = 1.08, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS' WHERE id = 5231;
UPDATE pi.modulo_tecido SET valor_tecido = 1788.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5231 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5231, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1788.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5231 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1674.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5231 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5231, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1674.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5231 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1856.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5231 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5231, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1856.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5231 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1948.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5231 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5231, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1), 1948.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5231 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 447 | Marca: PERINI | ID Existente: 5338 (Exact Match)
UPDATE pi.modulo SET largura = 1.10, profundidade = 0.95, altura = 0.95, pa = 0.00, descricao = 'POLTRONA' WHERE id = 5338;
UPDATE pi.modulo_tecido SET valor_tecido = 1135.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5338 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5338, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1135.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5338 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1090.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5338 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5338, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1090.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5338 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1170.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5338 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5338, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1170.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5338 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1204.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5338 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5338, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 1204.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5338 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1235.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5338 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5338, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1235.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5338 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1370.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5338 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5338, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 1370.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5338 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 453 | Marca: PERINI | ID Existente: 5339 (Exact Match)
UPDATE pi.modulo SET largura = 1.70, profundidade = 0.95, altura = 0.95, pa = 0.00, descricao = 'PEÇA ÚNICA' WHERE id = 5339;
UPDATE pi.modulo_tecido SET valor_tecido = 1433.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5339 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5339, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1433.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5339 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1376.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5339 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5339, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1376.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5339 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1479.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5339 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5339, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1479.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5339 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1525.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5339 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5339, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 1525.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5339 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1565.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5339 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5339, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1565.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5339 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1730.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5339 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5339, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 1730.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5339 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 459 | Marca: PERINI | ID Existente: 5340 (Exact Match)
UPDATE pi.modulo SET largura = 2.30, profundidade = 0.95, altura = 0.95, pa = 0.00, descricao = 'PEÇA ÚNICA' WHERE id = 5340;
UPDATE pi.modulo_tecido SET valor_tecido = 1822.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5340 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5340, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1822.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5340 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1742.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5340 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5340, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1742.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5340 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1869.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5340 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5340, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1869.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5340 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1937.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5340 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5340, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 1937.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5340 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1990.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5340 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5340, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1990.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5340 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2200.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5340 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5340, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 2200.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5340 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 465 | Marca: LECCE GIRATÓRIA | ID Existente: 5352 (Exact Match)
UPDATE pi.modulo SET largura = 0.75, profundidade = 0.72, altura = 0.75, pa = 0.00, descricao = 'POLTRONA' WHERE id = 5352;
UPDATE pi.modulo_tecido SET valor_tecido = 791.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5352 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5352, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 791.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5352 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 769.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5352 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5352, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 769.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5352 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 815.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5352 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5352, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 815.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5352 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 838.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5352 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5352, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 838.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5352 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 855.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5352 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5352, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 855.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5352 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 915.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5352 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5352, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 915.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5352 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 471 | Marca: ZOE GIRATÓRIA | ID Existente: 5356 (Exact Match)
UPDATE pi.modulo SET largura = 0.75, profundidade = 0.80, altura = 0.84, pa = 0.00, descricao = 'POLTRONA' WHERE id = 5356;
UPDATE pi.modulo_tecido SET valor_tecido = 835.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5356 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5356, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 835.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5356 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 805.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5356 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5356, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 805.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5356 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 855.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5356 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5356, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 855.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5356 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 875.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5356 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5356, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 875.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5356 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 915.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5356 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5356, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 915.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5356 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1010.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5356 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5356, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 1010.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5356 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 477 | Marca: SOLEN | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (3, 26, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'SOLEN' LIMIT 1), 'POLTRONA', 0.74, 0.75, 0.75, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 1060.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 1040.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 1075.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 1095.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 1130.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 1195.000, true, NOW());

-- Planilha Linha 483 | Marca: RUBI | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (3, 26, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'RUBI' LIMIT 1), 'POLTRONA', 0.74, 0.75, 0.75, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 785.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 765.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 799.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 815.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 850.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 915.000, true, NOW());

-- Planilha Linha 489 | Marca: NICE | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (3, 26, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'NICE' LIMIT 1), 'POLTRONA', 0.75, 0.80, 0.77, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1), 799.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1), 770.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1), 820.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14 / ST' LIMIT 1), 845.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1), 899.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1), 980.000, true, NOW());

-- 4. IMPORTAÇÃO LIVINTUS (Fornecedor 4 | Categoria 27)
-- ==========================================================================

-- Planilha Linha 3 | Marca: MILANO | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (4, 27, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'MILANO' LIMIT 1), 'MÓDULO
ASSENTO', 1.00, 1.00, 0.46, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 1110.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 1185.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 1245.000, true, NOW());

-- Planilha Linha 6 | Marca: MILANO | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (4, 27, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'MILANO' LIMIT 1), 'MÓDULO
ASSENTO', 1.20, 1.00, 0.46, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 1265.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 1350.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 1420.000, true, NOW());

-- Planilha Linha 9 | Marca: MILANO | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (4, 27, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'MILANO' LIMIT 1), 'MÓDULO
ASSENTO', 1.40, 1.00, 0.46, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 1425.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 1515.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 1595.000, true, NOW());

-- Planilha Linha 12 | Marca: MILANO | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (4, 27, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'MILANO' LIMIT 1), 'MÓDULO
ASSENTO', 1.60, 1.00, 0.46, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 1635.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 1740.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 1825.000, true, NOW());

-- Planilha Linha 15 | Marca: MILANO | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (4, 27, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'MILANO' LIMIT 1), 'MÓDULO
ASSENTO', 1.80, 1.00, 0.46, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 1870.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 1985.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 2085.000, true, NOW());

-- Planilha Linha 18 | Marca: MILANO | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (4, 27, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'MILANO' LIMIT 1), 'MÓDULO
ASSENTO', 2.00, 1.00, 0.46, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 2160.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 2295.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 2405.000, true, NOW());

-- Planilha Linha 21 | Marca: MILANO | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (4, 27, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'MILANO' LIMIT 1), 'ALMOFADA 
ENCOSTO', 0.60, 0.00, 0.50, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 160.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 175.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 190.000, true, NOW());

-- Planilha Linha 24 | Marca: MILANO | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (4, 27, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'MILANO' LIMIT 1), 'ALMOFADA 
ENCOSTO', 0.90, 0.00, 0.50, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 205.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 225.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 240.000, true, NOW());

-- Planilha Linha 27 | Marca: MILANO | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (4, 27, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'MILANO' LIMIT 1), 'BASE DO ENCOSTO', 0.60, 0.62, 0.29, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 285.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 295.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 305.000, true, NOW());

-- Planilha Linha 30 | Marca: MILANO | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (4, 27, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'MILANO' LIMIT 1), 'BASE DO ENCOSTO', 0.90, 0.62, 0.29, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 325.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 345.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 360.000, true, NOW());

-- Planilha Linha 33 | Marca: MILANO | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (4, 27, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'MILANO' LIMIT 1), 'PUFF', 0.32, 1.00, 0.46, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 620.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 660.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 695.000, true, NOW());

-- Planilha Linha 36 | Marca: MILANO | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (4, 27, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'MILANO' LIMIT 1), 'BRAÇO', 0.24, 0.76, 0.14, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 255.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 265.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 280.000, true, NOW());

-- Planilha Linha 39 | Marca: BALDUZZI | ID Existente: 5367 (Dimension Match (diff desc))
UPDATE pi.modulo SET largura = 1.08, profundidade = 1.14, altura = 0.90, pa = 0.00, descricao = 'MÓDULO - 1 LUGAR COM
BRAÇO - Assento s/bç: 0,75m' WHERE id = 5367;
UPDATE pi.modulo_tecido SET valor_tecido = 2445.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5367 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5367, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 2445.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5367 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2559.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5367 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5367, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 2559.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5367 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2649.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5367 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5367, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 2649.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5367 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 42 | Marca: BALDUZZI | ID Existente: 5368 (Dimension Match (diff desc))
UPDATE pi.modulo SET largura = 1.18, profundidade = 1.14, altura = 0.90, pa = 0.00, descricao = 'MÓDULO - 1 LUGAR COM
BRAÇO - Assento s/bç: 0,85m' WHERE id = 5368;
UPDATE pi.modulo_tecido SET valor_tecido = 2547.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5368 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5368, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 2547.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5368 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2672.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5368 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5368, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 2672.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5368 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2542.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5368 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5368, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 2542.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5368 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 45 | Marca: BALDUZZI | ID Existente: 5369 (Dimension Match (diff desc))
UPDATE pi.modulo SET largura = 1.28, profundidade = 1.14, altura = 0.90, pa = 0.00, descricao = 'MÓDULO - 1 LUGAR COM
BRAÇO - Assento s/bç: 0,95m' WHERE id = 5369;
UPDATE pi.modulo_tecido SET valor_tecido = 2660.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5369 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5369, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 2660.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5369 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2786.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5369 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5369, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 2786.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5369 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2898.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5369 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5369, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 2898.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5369 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 48 | Marca: BALDUZZI | ID Existente: 5370 (Dimension Match (diff desc))
UPDATE pi.modulo SET largura = 0.75, profundidade = 1.14, altura = 0.90, pa = 0.00, descricao = 'MÓDULO - 1 LUGAR SEM
BRAÇO - Assento s/bç: 0,75m' WHERE id = 5370;
UPDATE pi.modulo_tecido SET valor_tecido = 2106.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5370 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5370, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 2106.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5370 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2186.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5370 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5370, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 2186.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5370 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2259.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5370 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5370, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 2259.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5370 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 51 | Marca: BALDUZZI | ID Existente: 5371 (Dimension Match (diff desc))
UPDATE pi.modulo SET largura = 0.85, profundidade = 1.14, altura = 0.90, pa = 0.00, descricao = 'MÓDULO - 1 LUGAR SEM
BRAÇO - Assento s/bç: 0,85m' WHERE id = 5371;
UPDATE pi.modulo_tecido SET valor_tecido = 2203.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5371 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5371, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 2203.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5371 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2293.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5371 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5371, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 2293.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5371 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2366.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5371 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5371, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 2366.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5371 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 54 | Marca: BALDUZZI | ID Existente: 5372 (Dimension Match (diff desc))
UPDATE pi.modulo SET largura = 0.95, profundidade = 1.14, altura = 0.90, pa = 0.00, descricao = 'MÓDULO - 1 LUGAR SEM
BRAÇO - Assento s/bç: 0,95m' WHERE id = 5372;
UPDATE pi.modulo_tecido SET valor_tecido = 2310.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5372 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5372, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 2310.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5372 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2400.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5372 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5372, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 2400.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5372 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2479.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5372 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5372, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 2479.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5372 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 57 | Marca: BALDUZZI | ID Existente: 5373 (Dimension Match (diff desc))
UPDATE pi.modulo SET largura = 1.08, profundidade = 1.59, altura = 0.90, pa = 0.00, descricao = 'MÓDULO CHAISE -  Assento s/bç: 0,75m' WHERE id = 5373;
UPDATE pi.modulo_tecido SET valor_tecido = 2808.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5373 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5373, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 2808.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5373 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2955.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5373 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5373, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 2955.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5373 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3074.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5373 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5373, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 3074.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5373 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 60 | Marca: BALDUZZI | ID Existente: 5374 (Dimension Match (diff desc))
UPDATE pi.modulo SET largura = 1.18, profundidade = 1.59, altura = 0.90, pa = 0.00, descricao = 'MÓDULO CHAISE -  Assento s/bç: 0,85m' WHERE id = 5374;
UPDATE pi.modulo_tecido SET valor_tecido = 2921.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5374 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5374, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 2921.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5374 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3074.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5374 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5374, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 3074.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5374 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3198.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5374 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5374, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 3198.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5374 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 63 | Marca: BALDUZZI | ID Existente: 5375 (Dimension Match (diff desc))
UPDATE pi.modulo SET largura = 1.28, profundidade = 1.59, altura = 0.90, pa = 0.00, descricao = 'MÓDULO CHAISE -  Assento s/bç: 0,95m' WHERE id = 5375;
UPDATE pi.modulo_tecido SET valor_tecido = 3045.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5375 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5375, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 3045.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5375 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3198.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5375 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5375, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 3198.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5375 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3323.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5375 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5375, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 3323.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5375 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 66 | Marca: BALDUZZI | ID Existente: 5580 (Exact Match)
UPDATE pi.modulo SET largura = 1.14, profundidade = 1.14, altura = 0.45, pa = 0.00, descricao = 'PUFF' WHERE id = 5580;
UPDATE pi.modulo_tecido SET valor_tecido = 1761.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5580 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5580, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 1761.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5580 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1829.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5580 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5580, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 1829.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5580 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1891.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5580 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5580, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 1891.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5580 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 69 | Marca: INSIEME | ID Existente: 5589 (Insieme Width Match)
UPDATE pi.modulo SET largura = 2.24, profundidade = 1.00, altura = 0.98, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS
Assento s/bç: 0,90m' WHERE id = 5589;
UPDATE pi.modulo_tecido SET valor_tecido = 7742.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5589 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5589, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 7742.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5589 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 7991.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5589 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5589, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 7991.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5589 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 8183.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5589 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5589, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 8183.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5589 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 72 | Marca: INSIEME | ID Existente: 5590 (Insieme Width Match)
UPDATE pi.modulo SET largura = 2.54, profundidade = 1.00, altura = 0.98, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS
Assento s/bç: 1,05m' WHERE id = 5590;
UPDATE pi.modulo_tecido SET valor_tecido = 8252.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5590 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5590, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 8252.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5590 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 8500.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5590 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5590, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 8500.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5590 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 8715.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5590 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5590, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 8715.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5590 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 75 | Marca: INSIEME | ID Existente: 5591 (Insieme Width Match)
UPDATE pi.modulo SET largura = 2.84, profundidade = 1.00, altura = 0.98, pa = 0.00, descricao = 'BIPARTIDO - 2 ASSENTOS
Assento s/bç: 1,20m' WHERE id = 5591;
UPDATE pi.modulo_tecido SET valor_tecido = 8874.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5591 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5591, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 8874.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5591 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 9157.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5591 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5591, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 9157.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5591 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 9383.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5591 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5591, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 9383.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5591 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 78 | Marca: INSIEME | ID Existente: 5592 (Insieme Width Match)
UPDATE pi.modulo SET largura = 3.14, profundidade = 1.00, altura = 0.98, pa = 0.00, descricao = 'BIPARTIDO - 3 ASSENTOS
Assento s/bç : 0,90m' WHERE id = 5592;
UPDATE pi.modulo_tecido SET valor_tecido = 11392.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5592 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5592, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 11392.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5592 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 11743.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5592 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5592, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 11743.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5592 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 12020.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5592 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5592, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 12020.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5592 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 81 | Marca: INSIEME | ID Existente: 5593 (Insieme Width Match)
UPDATE pi.modulo SET largura = 3.59, profundidade = 1.00, altura = 0.98, pa = 0.00, descricao = 'BIPARTIDO - 3 ASSENTOS
Assento s/bç : 1,05m' WHERE id = 5593;
UPDATE pi.modulo_tecido SET valor_tecido = 12116.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5593 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5593, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 12116.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5593 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 12473.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5593 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5593, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 12473.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5593 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 12778.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5593 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5593, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 12778.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5593 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 84 | Marca: INSIEME | ID Existente: 5594 (Insieme Width Match)
UPDATE pi.modulo SET largura = 4.04, profundidade = 1.00, altura = 0.98, pa = 0.00, descricao = 'BIPARTIDO - 3 ASSENTOS
Assento s/bç : 1,20m' WHERE id = 5594;
UPDATE pi.modulo_tecido SET valor_tecido = 12999.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5594 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5594, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 12999.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5594 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 13400.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5594 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5594, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 13400.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5594 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 13723.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5594 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5594, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 13723.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5594 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 87 | Marca: CORDERO | ID Existente: 5747 (Swapped Dimensions Match)
UPDATE pi.modulo SET largura = 1.95, profundidade = 0.90, altura = 0.78, pa = 0.00, descricao = 'PEÇA ÚNICA
Assentos s/bç: 1,69m' WHERE id = 5747;
UPDATE pi.modulo_tecido SET valor_tecido = 2470.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5747 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5747, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 2470.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5747 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2600.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5747 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5747, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 2600.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5747 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2720.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5747 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5747, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 2720.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5747 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 90 | Marca: CORDERO | ID Existente: 5758 (Swapped Dimensions Match)
UPDATE pi.modulo SET largura = 2.15, profundidade = 0.90, altura = 0.78, pa = 0.00, descricao = 'PEÇA ÚNICA
Assentos s/bç: 1,89m' WHERE id = 5758;
UPDATE pi.modulo_tecido SET valor_tecido = 2720.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5758 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5758, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 2720.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5758 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2870.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5758 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5758, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 2870.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5758 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2999.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5758 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5758, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 2999.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5758 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 93 | Marca: CORDERO | ID Existente: 5759 (Swapped Dimensions Match)
UPDATE pi.modulo SET largura = 2.35, profundidade = 0.90, altura = 0.78, pa = 0.00, descricao = 'PEÇA ÚNICA
Assentos s/bç: 2,09m' WHERE id = 5759;
UPDATE pi.modulo_tecido SET valor_tecido = 2999.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5759 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5759, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 2999.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5759 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3160.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5759 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5759, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 3160.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5759 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3299.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5759 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5759, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 3299.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5759 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 96 | Marca: BAROLO | ID Existente: 5442 (Exact Match)
UPDATE pi.modulo SET largura = 1.90, profundidade = 0.96, altura = 0.78, pa = 0.00, descricao = 'PEÇA ÚNICA
Assentos s/bç: 1,36m' WHERE id = 5442;
UPDATE pi.modulo_tecido SET valor_tecido = 2536.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5442 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5442, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 2536.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5442 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2700.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5442 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5442, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 2700.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5442 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2842.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5442 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5442, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 2842.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5442 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 99 | Marca: BAROLO | ID Existente: 5443 (Exact Match)
UPDATE pi.modulo SET largura = 2.40, profundidade = 0.96, altura = 0.78, pa = 0.00, descricao = 'PEÇA ÚNICA
Assentos s/bç: 1,86m' WHERE id = 5443;
UPDATE pi.modulo_tecido SET valor_tecido = 3018.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5443 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5443, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 3018.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5443 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3226.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5443 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5443, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 3226.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5443 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3408.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5443 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5443, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 3408.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5443 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 102 | Marca: AURORA | ID Existente: 5444 (Exact Match)
UPDATE pi.modulo SET largura = 2.00, profundidade = 0.92, altura = 0.85, pa = 0.00, descricao = 'PEÇA ÚNICA
Assentos s/bç: 1,64m' WHERE id = 5444;
UPDATE pi.modulo_tecido SET valor_tecido = 2474.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5444 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5444, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 2474.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5444 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2638.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5444 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5444, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 2638.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5444 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2774.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5444 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5444, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 2774.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5444 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 105 | Marca: AURORA | ID Existente: 5445 (Exact Match)
UPDATE pi.modulo SET largura = 2.20, profundidade = 0.92, altura = 0.85, pa = 0.00, descricao = 'PEÇA ÚNICA
Assentos s/bç: 1,84m' WHERE id = 5445;
UPDATE pi.modulo_tecido SET valor_tecido = 2615.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5445 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5445, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 2615.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5445 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2791.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5445 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5445, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 2791.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5445 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2938.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5445 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5445, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 2938.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5445 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 108 | Marca: AURORA | ID Existente: 5446 (Exact Match)
UPDATE pi.modulo SET largura = 2.40, profundidade = 0.92, altura = 0.85, pa = 0.00, descricao = 'PEÇA ÚNICA
Assentos s/bç: 2,04m' WHERE id = 5446;
UPDATE pi.modulo_tecido SET valor_tecido = 2769.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5446 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5446, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 2769.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5446 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2955.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5446 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5446, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 2955.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5446 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3108.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5446 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5446, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 3108.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5446 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 111 | Marca: CORBERLLI | ID Existente: 5454 (Exact Match)
UPDATE pi.modulo SET largura = 0.84, profundidade = 0.92, altura = 0.88, pa = 0.00, descricao = 'POLTRONA
Assento s/bç: 0,44m' WHERE id = 5454;
UPDATE pi.modulo_tecido SET valor_tecido = 1654.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5454 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5454, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 1654.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5454 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1732.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5454 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5454, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 1732.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5454 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1806.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5454 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5454, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 1806.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5454 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 924.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5454 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5454, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1), 924.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5454 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 115 | Marca: CORBERLLI | ID Existente: 5455 (Exact Match)
UPDATE pi.modulo SET largura = 1.60, profundidade = 0.92, altura = 0.88, pa = 0.00, descricao = 'PEÇA ÚNICA
Assentos s/bç: 1,20m' WHERE id = 5455;
UPDATE pi.modulo_tecido SET valor_tecido = 2150.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5455 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5455, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 2150.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5455 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2281.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5455 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5455, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 2281.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5455 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2389.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5455 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5455, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 2389.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5455 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1291.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5455 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5455, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1), 1291.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5455 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 119 | Marca: CORBERLLI | ID Existente: 5456 (Exact Match)
UPDATE pi.modulo SET largura = 2.10, profundidade = 0.92, altura = 0.88, pa = 0.00, descricao = 'PEÇA ÚNICA
Assentos s/bç: 1,70m' WHERE id = 5456;
UPDATE pi.modulo_tecido SET valor_tecido = 2486.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5456 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5456, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 2486.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5456 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2649.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5456 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5456, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 2649.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5456 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2791.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5456 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5456, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 2791.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5456 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1427.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5456 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5456, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1), 1427.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5456 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 123 | Marca: CORBERLLI | ID Existente: 5457 (Exact Match)
UPDATE pi.modulo SET largura = 2.40, profundidade = 0.92, altura = 0.88, pa = 0.00, descricao = 'PEÇA ÚNICA
Assentos s/bç: 2,00m' WHERE id = 5457;
UPDATE pi.modulo_tecido SET valor_tecido = 2740.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5457 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5457, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 2740.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5457 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2876.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5457 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5457, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 2876.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5457 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3023.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5457 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5457, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 3023.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5457 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1540.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5457 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5457, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1), 1540.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5457 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 127 | Marca: CHABLIS | ID Existente: 5471 (Exact Match)
UPDATE pi.modulo SET largura = 0.80, profundidade = 0.92, altura = 0.86, pa = 0.00, descricao = 'POLTRONA
Assento s/bç: 0,70m' WHERE id = 5471;
UPDATE pi.modulo_tecido SET valor_tecido = 1755.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5471 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5471, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 1755.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5471 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1846.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5471 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5471, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 1846.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5471 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1924.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5471 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5471, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 1924.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5471 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 130 | Marca: CHABLIS | ID Existente: 5472 (Exact Match)
UPDATE pi.modulo SET largura = 2.10, profundidade = 0.92, altura = 0.86, pa = 0.00, descricao = '2 MÓDULOS
Assento s/bç: 1,00m' WHERE id = 5472;
UPDATE pi.modulo_tecido SET valor_tecido = 3260.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5472 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5472, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 3260.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5472 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3430.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5472 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5472, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 3430.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5472 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3577.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5472 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5472, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 3577.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5472 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 133 | Marca: CHABLIS | ID Existente: 5473 (Exact Match)
UPDATE pi.modulo SET largura = 2.40, profundidade = 0.92, altura = 0.86, pa = 0.00, descricao = '2 MÓDULOS
Assento s/bç: 1,15m' WHERE id = 5473;
UPDATE pi.modulo_tecido SET valor_tecido = 3555.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5473 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5473, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 3555.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5473 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3747.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5473 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5473, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 3747.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5473 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3916.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5473 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5473, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 3916.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5473 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 136 | Marca: CHABLIS | ID Existente: 5474 (Exact Match)
UPDATE pi.modulo SET largura = 2.70, profundidade = 0.92, altura = 0.86, pa = 0.00, descricao = '2 MÓDULOS
Assento s/bç: 1,30m' WHERE id = 5474;
UPDATE pi.modulo_tecido SET valor_tecido = 3872.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5474 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5474, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 3872.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5474 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 4098.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5474 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5474, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 4098.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5474 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 138 | Marca: BANDINI | ID Existente: 5748 (Swapped Dimensions Match)
UPDATE pi.modulo SET largura = 1.50, profundidade = 0.90, altura = 0.93, pa = 0.00, descricao = 'PEÇA ÚNICA
Assentos s/bç: 1,10m' WHERE id = 5748;
UPDATE pi.modulo_tecido SET valor_tecido = 2270.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5748 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5748, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 2270.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5748 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2420.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5748 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5748, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 2420.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5748 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2520.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5748 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5748, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 2520.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5748 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1270.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5748 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5748, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1), 1270.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5748 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 142 | Marca: BANDINI | ID Existente: 5760 (Swapped Dimensions Match)
UPDATE pi.modulo SET largura = 2.05, profundidade = 0.90, altura = 0.93, pa = 0.00, descricao = 'PEÇA ÚNICA
Assentos s/bç: 1,65m' WHERE id = 5760;
UPDATE pi.modulo_tecido SET valor_tecido = 2870.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5760 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5760, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 2870.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5760 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3050.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5760 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5760, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 3050.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5760 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3199.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5760 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5760, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 3199.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5760 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1480.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5760 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5760, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1), 1480.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5760 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 146 | Marca: BANDINI | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (4, 27, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'BANDINI' LIMIT 1), 'PEÇA ÚNICA', 1.50, 0.84, 0.73, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 2005.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 2110.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 2195.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1), 1350.000, true, NOW());

-- Planilha Linha 150 | Marca: BANDINI | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (4, 27, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'BANDINI' LIMIT 1), 'PEÇA ÚNICA', 1.80, 0.84, 0.73, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 2280.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 2405.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 2505.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1), 1460.000, true, NOW());

-- Planilha Linha 154 | Marca: POLTRONA ALANA ELÉTRICA | ID Existente: 5491 (Recliner Match (desc + width))
UPDATE pi.modulo SET largura = 0.84, profundidade = 0.92, altura = 1.02, pa = 0.00, descricao = 'POLTRONA' WHERE id = 5491;
UPDATE pi.modulo_tecido SET valor_tecido = 3068.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5491 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5491, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 3068.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5491 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3164.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5491 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5491, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 3164.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5491 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3238.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5491 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5491, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 3238.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5491 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2190.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5491 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5491, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1), 2190.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5491 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 158 | Marca: CONDOR | ID Existente: 5493 (Recliner Match (desc + width))
UPDATE pi.modulo SET largura = 0.82, profundidade = 0.97, altura = 1.02, pa = 0.00, descricao = 'POLTRONA' WHERE id = 5493;
UPDATE pi.modulo_tecido SET valor_tecido = 3102.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5493 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5493, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 3102.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5493 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3198.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5493 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5493, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 3198.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5493 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 3277.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5493 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5493, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 3277.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5493 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 2389.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5493 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5493, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1), 2389.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5493 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 162 | Marca: CONDOR | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (4, 27, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'CONDOR' LIMIT 1), 'POLTRONA GIRATÓRIA', 0.86, 0.84, 0.73, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 1480.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 1550.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 1605.000, true, NOW());

-- Planilha Linha 166 | Marca: CONDOR | Novo Módulo
WITH new_mod AS (
  INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)   VALUES (4, 27, (SELECT id FROM pi.marca WHERE UPPER(nome) = 'CONDOR' LIMIT 1), 'POLTRONA GIRATÓRIA', 0.80, 0.84, 0.77, 0.00)   RETURNING id
)
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
VALUES
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 1520.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 1595.000, true, NOW()),
  ((SELECT id FROM new_mod), (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 1655.000, true, NOW());

-- Planilha Linha 170 | Marca: POLTRONA ZOE | ID Existente: 5490 (Exact Match)
UPDATE pi.modulo SET largura = 0.75, profundidade = 0.80, altura = 0.84, pa = 0.00, descricao = 'POLTRONA' WHERE id = 5490;
UPDATE pi.modulo_tecido SET valor_tecido = 1388.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5490 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5490, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 1388.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5490 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1461.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5490 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5490, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 1461.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5490 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1518.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5490 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5490, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 1518.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5490 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 890.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5490 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/NOBUCK/ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5490, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/NOBUCK/ST' LIMIT 1), 890.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5490 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/NOBUCK/ST' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 174 | Marca: LECCE GIRATORIA | ID Existente: 5495 (Exact Match)
UPDATE pi.modulo SET largura = 0.75, profundidade = 0.72, altura = 0.75, pa = 0.00, descricao = 'POLTRONA GIRATÓRIA' WHERE id = 5495;
UPDATE pi.modulo_tecido SET valor_tecido = 1342.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5495 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5495, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 1342.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5495 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1405.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5495 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5495, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 1405.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5495 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1461.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5495 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5495, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 1461.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5495 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 827.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5495 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5495, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1), 827.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5495 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 178 | Marca: CHANDON GIRATÓRIA | ID Existente: 5500 (Exact Match)
UPDATE pi.modulo SET largura = 0.86, profundidade = 0.90, altura = 0.78, pa = 0.00, descricao = 'POLTRONA GIRATÓRIA' WHERE id = 5500;
UPDATE pi.modulo_tecido SET valor_tecido = 1688.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5500 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5500, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 1688.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5500 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1766.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5500 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5500, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 1766.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5500 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1823.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5500 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5500, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 1823.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5500 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1156.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5500 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5500, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1), 1156.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5500 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 182 | Marca: PUFF BAROLO | ID Existente: 5749 (Swapped Dimensions Match)
UPDATE pi.modulo SET largura = 0.60, profundidade = 0.80, altura = 0.40, pa = 0.00, descricao = 'PUFF' WHERE id = 5749;
UPDATE pi.modulo_tecido SET valor_tecido = 850.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5749 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5749, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 850.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5749 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 890.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5749 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5749, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 890.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5749 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 920.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5749 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5749, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 920.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5749 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 185 | Marca: PUFF BAROLO | ID Existente: 5761 (Swapped Dimensions Match)
UPDATE pi.modulo SET largura = 0.80, profundidade = 0.80, altura = 0.40, pa = 0.00, descricao = 'PUFF' WHERE id = 5761;
UPDATE pi.modulo_tecido SET valor_tecido = 990.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5761 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5761, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 990.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5761 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1030.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5761 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5761, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 1030.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5761 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 1070.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5761 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5761, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 1070.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5761 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 188 | Marca: PUFF APALTA | ID Existente: 5505 (Exact Match)
UPDATE pi.modulo SET largura = 0.43, profundidade = 0.43, altura = 0.45, pa = 0.00, descricao = 'PUFF' WHERE id = 5505;
UPDATE pi.modulo_tecido SET valor_tecido = 578.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5505 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5505, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 578.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5505 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 590.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5505 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5505, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 590.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5505 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 612.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5505 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5505, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 612.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5505 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 191 | Marca: PUFF APALTA | ID Existente: 5506 (Exact Match)
UPDATE pi.modulo SET largura = 0.70, profundidade = 0.43, altura = 0.45, pa = 0.00, descricao = 'PUFF' WHERE id = 5506;
UPDATE pi.modulo_tecido SET valor_tecido = 686.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5506 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5506, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 686.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5506 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 714.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5506 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5506, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 714.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5506 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 737.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5506 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5506, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 737.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5506 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 194 | Marca: PUFF APALTA | ID Existente: 5507 (Exact Match)
UPDATE pi.modulo SET largura = 0.85, profundidade = 0.57, altura = 0.45, pa = 0.00, descricao = 'PUFF' WHERE id = 5507;
UPDATE pi.modulo_tecido SET valor_tecido = 792.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5507 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5507, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 792.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5507 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 827.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5507 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5507, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 827.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5507 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 861.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5507 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5507, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 861.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5507 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);

-- Planilha Linha 197 | Marca: PUFF CHANDON | ID Existente: 5508 (Exact Match)
UPDATE pi.modulo SET largura = 0.67, profundidade = 0.63, altura = 0.42, pa = 0.00, descricao = 'PUFF' WHERE id = 5508;
UPDATE pi.modulo_tecido SET valor_tecido = 686.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5508 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5508, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1), 686.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5508 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-5' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 714.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5508 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5508, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1), 714.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5508 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-6' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 737.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5508 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5508, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1), 737.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5508 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'CO-7' LIMIT 1) AND fl_ativo = true);
UPDATE pi.modulo_tecido SET valor_tecido = 369.000, dt_ultima_revisao = NOW() WHERE id_modulo = 5508 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1) AND fl_ativo = true;
INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao) SELECT 5508, (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1), 369.000, true, NOW() WHERE NOT EXISTS (  SELECT 1 FROM pi.modulo_tecido   WHERE id_modulo = 5508 AND id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC/ST' LIMIT 1) AND fl_ativo = true);

COMMIT;