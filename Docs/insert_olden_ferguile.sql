-- ==========================================================================
-- INSERÇÃO DE MÓDULOS E PREÇOS FERGUILE: ESTOFADO OLDEN E POLTRONA OLDEN
-- Itens: SOFÁ OLDEN (1,50m e 1,80m) e POLTRONA OLDEN GIRATÓRIA
-- Destinado à base de Produção (resolve IDs dinamicamente via subqueries)
-- ==========================================================================

BEGIN TRANSACTION;

-- --------------------------------------------------------------------------
-- 1. GARANTIR A EXISTÊNCIA DAS MARCAS
-- --------------------------------------------------------------------------
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'OLDEN', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'OLDEN');
INSERT INTO pi.marca (nome, fl_ativo) SELECT 'POLTRONA OLDEN', true WHERE NOT EXISTS (SELECT 1 FROM pi.marca WHERE UPPER(nome) = 'POLTRONA OLDEN');

-- --------------------------------------------------------------------------
-- 2. GARANTIR A EXISTÊNCIA DOS TECIDOS
-- --------------------------------------------------------------------------
INSERT INTO pi.tecido (nome) SELECT 'TC-10' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = 'TC-10');
INSERT INTO pi.tecido (nome) SELECT 'TC-12' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = 'TC-12');
INSERT INTO pi.tecido (nome) SELECT 'TC-13' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = 'TC-13');
INSERT INTO pi.tecido (nome) SELECT 'TC-14' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = 'TC-14');
INSERT INTO pi.tecido (nome) SELECT 'TC-16' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = 'TC-16');
INSERT INTO pi.tecido (nome) SELECT 'TC-18' WHERE NOT EXISTS (SELECT 1 FROM pi.tecido WHERE UPPER(nome) = 'TC-18');

-- ==========================================================================
-- MÓDULO: POLTRONA OLDEN 0,86M (POLTRONA GIRATÓRIA)
-- Medidas: Largura 0.86m | Profundidade 0.84m | Altura 0.73m | M³ 0.53
-- ==========================================================================
INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)
SELECT 
    (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1),
    (SELECT id FROM pi.categoria WHERE UPPER(nome) = 'FERGUILE' LIMIT 1),
    (SELECT id FROM pi.marca WHERE UPPER(nome) = 'POLTRONA OLDEN' LIMIT 1),
    'POLTRONA GIRATÓRIA',
    0.86,
    0.84,
    0.73,
    0.00
WHERE NOT EXISTS (
    SELECT 1 FROM pi.modulo m
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
      AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'POLTRONA OLDEN' LIMIT 1)
      AND m.descricao = 'POLTRONA GIRATÓRIA'
      AND m.largura = 0.86
);
UPDATE pi.modulo
SET profundidade = 0.84, altura = 0.73, pa = 0.00
WHERE id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
  AND id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'POLTRONA OLDEN' LIMIT 1)
  AND descricao = 'POLTRONA GIRATÓRIA'
  AND largura = 0.86;

-- Preço TC-12: R$ 916.85
UPDATE pi.modulo_tecido mt
SET valor_tecido = 916.850, dt_ultima_revisao = NOW()
WHERE mt.id_modulo = (
    SELECT m.id FROM pi.modulo m
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
      AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'POLTRONA OLDEN' LIMIT 1)
      AND m.descricao = 'POLTRONA GIRATÓRIA'
      AND m.largura = 0.86
    LIMIT 1
)
AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1)
AND mt.fl_ativo = true;

INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
SELECT 
    (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'POLTRONA OLDEN' LIMIT 1)
          AND m.descricao = 'POLTRONA GIRATÓRIA'
          AND m.largura = 0.86
        LIMIT 1
    ),
    (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1),
    916.850,
    true,
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM pi.modulo_tecido mt
    WHERE mt.id_modulo = (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'POLTRONA OLDEN' LIMIT 1)
          AND m.descricao = 'POLTRONA GIRATÓRIA'
          AND m.largura = 0.86
        LIMIT 1
    )
    AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1)
    AND mt.fl_ativo = true
);

-- Preço TC-10: R$ 943.49
UPDATE pi.modulo_tecido mt
SET valor_tecido = 943.490, dt_ultima_revisao = NOW()
WHERE mt.id_modulo = (
    SELECT m.id FROM pi.modulo m
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
      AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'POLTRONA OLDEN' LIMIT 1)
      AND m.descricao = 'POLTRONA GIRATÓRIA'
      AND m.largura = 0.86
    LIMIT 1
)
AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1)
AND mt.fl_ativo = true;

INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
SELECT 
    (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'POLTRONA OLDEN' LIMIT 1)
          AND m.descricao = 'POLTRONA GIRATÓRIA'
          AND m.largura = 0.86
        LIMIT 1
    ),
    (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1),
    943.490,
    true,
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM pi.modulo_tecido mt
    WHERE mt.id_modulo = (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'POLTRONA OLDEN' LIMIT 1)
          AND m.descricao = 'POLTRONA GIRATÓRIA'
          AND m.largura = 0.86
        LIMIT 1
    )
    AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1)
    AND mt.fl_ativo = true
);

-- Preço TC-13: R$ 960.21
UPDATE pi.modulo_tecido mt
SET valor_tecido = 960.210, dt_ultima_revisao = NOW()
WHERE mt.id_modulo = (
    SELECT m.id FROM pi.modulo m
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
      AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'POLTRONA OLDEN' LIMIT 1)
      AND m.descricao = 'POLTRONA GIRATÓRIA'
      AND m.largura = 0.86
    LIMIT 1
)
AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1)
AND mt.fl_ativo = true;

INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
SELECT 
    (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'POLTRONA OLDEN' LIMIT 1)
          AND m.descricao = 'POLTRONA GIRATÓRIA'
          AND m.largura = 0.86
        LIMIT 1
    ),
    (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1),
    960.210,
    true,
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM pi.modulo_tecido mt
    WHERE mt.id_modulo = (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'POLTRONA OLDEN' LIMIT 1)
          AND m.descricao = 'POLTRONA GIRATÓRIA'
          AND m.largura = 0.86
        LIMIT 1
    )
    AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1)
    AND mt.fl_ativo = true
);

-- Preço TC-14: R$ 980.59
UPDATE pi.modulo_tecido mt
SET valor_tecido = 980.590, dt_ultima_revisao = NOW()
WHERE mt.id_modulo = (
    SELECT m.id FROM pi.modulo m
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
      AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'POLTRONA OLDEN' LIMIT 1)
      AND m.descricao = 'POLTRONA GIRATÓRIA'
      AND m.largura = 0.86
    LIMIT 1
)
AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1)
AND mt.fl_ativo = true;

INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
SELECT 
    (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'POLTRONA OLDEN' LIMIT 1)
          AND m.descricao = 'POLTRONA GIRATÓRIA'
          AND m.largura = 0.86
        LIMIT 1
    ),
    (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1),
    980.590,
    true,
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM pi.modulo_tecido mt
    WHERE mt.id_modulo = (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'POLTRONA OLDEN' LIMIT 1)
          AND m.descricao = 'POLTRONA GIRATÓRIA'
          AND m.largura = 0.86
        LIMIT 1
    )
    AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1)
    AND mt.fl_ativo = true
);

-- Preço TC-16: R$ 1022.91
UPDATE pi.modulo_tecido mt
SET valor_tecido = 1022.910, dt_ultima_revisao = NOW()
WHERE mt.id_modulo = (
    SELECT m.id FROM pi.modulo m
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
      AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'POLTRONA OLDEN' LIMIT 1)
      AND m.descricao = 'POLTRONA GIRATÓRIA'
      AND m.largura = 0.86
    LIMIT 1
)
AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1)
AND mt.fl_ativo = true;

INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
SELECT 
    (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'POLTRONA OLDEN' LIMIT 1)
          AND m.descricao = 'POLTRONA GIRATÓRIA'
          AND m.largura = 0.86
        LIMIT 1
    ),
    (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1),
    1022.910,
    true,
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM pi.modulo_tecido mt
    WHERE mt.id_modulo = (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'POLTRONA OLDEN' LIMIT 1)
          AND m.descricao = 'POLTRONA GIRATÓRIA'
          AND m.largura = 0.86
        LIMIT 1
    )
    AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1)
    AND mt.fl_ativo = true
);

-- Preço TC-18: R$ 1098.68
UPDATE pi.modulo_tecido mt
SET valor_tecido = 1098.680, dt_ultima_revisao = NOW()
WHERE mt.id_modulo = (
    SELECT m.id FROM pi.modulo m
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
      AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'POLTRONA OLDEN' LIMIT 1)
      AND m.descricao = 'POLTRONA GIRATÓRIA'
      AND m.largura = 0.86
    LIMIT 1
)
AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1)
AND mt.fl_ativo = true;

INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
SELECT 
    (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'POLTRONA OLDEN' LIMIT 1)
          AND m.descricao = 'POLTRONA GIRATÓRIA'
          AND m.largura = 0.86
        LIMIT 1
    ),
    (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1),
    1098.680,
    true,
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM pi.modulo_tecido mt
    WHERE mt.id_modulo = (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'POLTRONA OLDEN' LIMIT 1)
          AND m.descricao = 'POLTRONA GIRATÓRIA'
          AND m.largura = 0.86
        LIMIT 1
    )
    AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1)
    AND mt.fl_ativo = true
);

-- ==========================================================================
-- MÓDULO: SOFÁ OLDEN 1,50M (PEÇA ÚNICA)
-- Medidas: Largura 1.50m | Profundidade 0.84m | Altura 0.73m | M³ 0.92
-- ==========================================================================
INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)
SELECT 
    (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1),
    (SELECT id FROM pi.categoria WHERE UPPER(nome) = 'FERGUILE' LIMIT 1),
    (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1),
    'PEÇA ÚNICA',
    1.50,
    0.84,
    0.73,
    0.00
WHERE NOT EXISTS (
    SELECT 1 FROM pi.modulo m
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
      AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
      AND m.descricao = 'PEÇA ÚNICA'
      AND m.largura = 1.50
);
UPDATE pi.modulo
SET profundidade = 0.84, altura = 0.73, pa = 0.00
WHERE id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
  AND id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
  AND descricao = 'PEÇA ÚNICA'
  AND largura = 1.50;

-- Preço TC-12: R$ 1144.98
UPDATE pi.modulo_tecido mt
SET valor_tecido = 1144.980, dt_ultima_revisao = NOW()
WHERE mt.id_modulo = (
    SELECT m.id FROM pi.modulo m
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
      AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
      AND m.descricao = 'PEÇA ÚNICA'
      AND m.largura = 1.50
    LIMIT 1
)
AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1)
AND mt.fl_ativo = true;

INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
SELECT 
    (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
          AND m.descricao = 'PEÇA ÚNICA'
          AND m.largura = 1.50
        LIMIT 1
    ),
    (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1),
    1144.980,
    true,
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM pi.modulo_tecido mt
    WHERE mt.id_modulo = (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
          AND m.descricao = 'PEÇA ÚNICA'
          AND m.largura = 1.50
        LIMIT 1
    )
    AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1)
    AND mt.fl_ativo = true
);

-- Preço TC-10: R$ 1181.99
UPDATE pi.modulo_tecido mt
SET valor_tecido = 1181.990, dt_ultima_revisao = NOW()
WHERE mt.id_modulo = (
    SELECT m.id FROM pi.modulo m
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
      AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
      AND m.descricao = 'PEÇA ÚNICA'
      AND m.largura = 1.50
    LIMIT 1
)
AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1)
AND mt.fl_ativo = true;

INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
SELECT 
    (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
          AND m.descricao = 'PEÇA ÚNICA'
          AND m.largura = 1.50
        LIMIT 1
    ),
    (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1),
    1181.990,
    true,
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM pi.modulo_tecido mt
    WHERE mt.id_modulo = (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
          AND m.descricao = 'PEÇA ÚNICA'
          AND m.largura = 1.50
        LIMIT 1
    )
    AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1)
    AND mt.fl_ativo = true
);

-- Preço TC-13: R$ 1205.22
UPDATE pi.modulo_tecido mt
SET valor_tecido = 1205.220, dt_ultima_revisao = NOW()
WHERE mt.id_modulo = (
    SELECT m.id FROM pi.modulo m
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
      AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
      AND m.descricao = 'PEÇA ÚNICA'
      AND m.largura = 1.50
    LIMIT 1
)
AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1)
AND mt.fl_ativo = true;

INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
SELECT 
    (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
          AND m.descricao = 'PEÇA ÚNICA'
          AND m.largura = 1.50
        LIMIT 1
    ),
    (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1),
    1205.220,
    true,
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM pi.modulo_tecido mt
    WHERE mt.id_modulo = (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
          AND m.descricao = 'PEÇA ÚNICA'
          AND m.largura = 1.50
        LIMIT 1
    )
    AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1)
    AND mt.fl_ativo = true
);

-- Preço TC-14: R$ 1233.52
UPDATE pi.modulo_tecido mt
SET valor_tecido = 1233.520, dt_ultima_revisao = NOW()
WHERE mt.id_modulo = (
    SELECT m.id FROM pi.modulo m
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
      AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
      AND m.descricao = 'PEÇA ÚNICA'
      AND m.largura = 1.50
    LIMIT 1
)
AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1)
AND mt.fl_ativo = true;

INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
SELECT 
    (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
          AND m.descricao = 'PEÇA ÚNICA'
          AND m.largura = 1.50
        LIMIT 1
    ),
    (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1),
    1233.520,
    true,
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM pi.modulo_tecido mt
    WHERE mt.id_modulo = (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
          AND m.descricao = 'PEÇA ÚNICA'
          AND m.largura = 1.50
        LIMIT 1
    )
    AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1)
    AND mt.fl_ativo = true
);

-- Preço TC-16: R$ 1292.30
UPDATE pi.modulo_tecido mt
SET valor_tecido = 1292.300, dt_ultima_revisao = NOW()
WHERE mt.id_modulo = (
    SELECT m.id FROM pi.modulo m
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
      AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
      AND m.descricao = 'PEÇA ÚNICA'
      AND m.largura = 1.50
    LIMIT 1
)
AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1)
AND mt.fl_ativo = true;

INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
SELECT 
    (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
          AND m.descricao = 'PEÇA ÚNICA'
          AND m.largura = 1.50
        LIMIT 1
    ),
    (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1),
    1292.300,
    true,
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM pi.modulo_tecido mt
    WHERE mt.id_modulo = (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
          AND m.descricao = 'PEÇA ÚNICA'
          AND m.largura = 1.50
        LIMIT 1
    )
    AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1)
    AND mt.fl_ativo = true
);

-- Preço TC-18: R$ 1397.52
UPDATE pi.modulo_tecido mt
SET valor_tecido = 1397.520, dt_ultima_revisao = NOW()
WHERE mt.id_modulo = (
    SELECT m.id FROM pi.modulo m
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
      AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
      AND m.descricao = 'PEÇA ÚNICA'
      AND m.largura = 1.50
    LIMIT 1
)
AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1)
AND mt.fl_ativo = true;

INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
SELECT 
    (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
          AND m.descricao = 'PEÇA ÚNICA'
          AND m.largura = 1.50
        LIMIT 1
    ),
    (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1),
    1397.520,
    true,
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM pi.modulo_tecido mt
    WHERE mt.id_modulo = (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
          AND m.descricao = 'PEÇA ÚNICA'
          AND m.largura = 1.50
        LIMIT 1
    )
    AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1)
    AND mt.fl_ativo = true
);

-- ==========================================================================
-- MÓDULO: SOFÁ OLDEN 1,80M (PEÇA ÚNICA)
-- Medidas: Largura 1.80m | Profundidade 0.84m | Altura 0.73m | M³ 1.10
-- ==========================================================================
INSERT INTO pi.modulo (id_fornecedor, id_categoria, id_marca, descricao, largura, profundidade, altura, pa)
SELECT 
    (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1),
    (SELECT id FROM pi.categoria WHERE UPPER(nome) = 'FERGUILE' LIMIT 1),
    (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1),
    'PEÇA ÚNICA',
    1.80,
    0.84,
    0.73,
    0.00
WHERE NOT EXISTS (
    SELECT 1 FROM pi.modulo m
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
      AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
      AND m.descricao = 'PEÇA ÚNICA'
      AND m.largura = 1.80
);
UPDATE pi.modulo
SET profundidade = 0.84, altura = 0.73, pa = 0.00
WHERE id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
  AND id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
  AND descricao = 'PEÇA ÚNICA'
  AND largura = 1.80;

-- Preço TC-12: R$ 1222.65
UPDATE pi.modulo_tecido mt
SET valor_tecido = 1222.650, dt_ultima_revisao = NOW()
WHERE mt.id_modulo = (
    SELECT m.id FROM pi.modulo m
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
      AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
      AND m.descricao = 'PEÇA ÚNICA'
      AND m.largura = 1.80
    LIMIT 1
)
AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1)
AND mt.fl_ativo = true;

INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
SELECT 
    (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
          AND m.descricao = 'PEÇA ÚNICA'
          AND m.largura = 1.80
        LIMIT 1
    ),
    (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1),
    1222.650,
    true,
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM pi.modulo_tecido mt
    WHERE mt.id_modulo = (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
          AND m.descricao = 'PEÇA ÚNICA'
          AND m.largura = 1.80
        LIMIT 1
    )
    AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-12' LIMIT 1)
    AND mt.fl_ativo = true
);

-- Preço TC-10: R$ 1264.84
UPDATE pi.modulo_tecido mt
SET valor_tecido = 1264.840, dt_ultima_revisao = NOW()
WHERE mt.id_modulo = (
    SELECT m.id FROM pi.modulo m
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
      AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
      AND m.descricao = 'PEÇA ÚNICA'
      AND m.largura = 1.80
    LIMIT 1
)
AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1)
AND mt.fl_ativo = true;

INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
SELECT 
    (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
          AND m.descricao = 'PEÇA ÚNICA'
          AND m.largura = 1.80
        LIMIT 1
    ),
    (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1),
    1264.840,
    true,
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM pi.modulo_tecido mt
    WHERE mt.id_modulo = (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
          AND m.descricao = 'PEÇA ÚNICA'
          AND m.largura = 1.80
        LIMIT 1
    )
    AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-10' LIMIT 1)
    AND mt.fl_ativo = true
);

-- Preço TC-13: R$ 1291.32
UPDATE pi.modulo_tecido mt
SET valor_tecido = 1291.320, dt_ultima_revisao = NOW()
WHERE mt.id_modulo = (
    SELECT m.id FROM pi.modulo m
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
      AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
      AND m.descricao = 'PEÇA ÚNICA'
      AND m.largura = 1.80
    LIMIT 1
)
AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1)
AND mt.fl_ativo = true;

INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
SELECT 
    (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
          AND m.descricao = 'PEÇA ÚNICA'
          AND m.largura = 1.80
        LIMIT 1
    ),
    (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1),
    1291.320,
    true,
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM pi.modulo_tecido mt
    WHERE mt.id_modulo = (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
          AND m.descricao = 'PEÇA ÚNICA'
          AND m.largura = 1.80
        LIMIT 1
    )
    AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-13' LIMIT 1)
    AND mt.fl_ativo = true
);

-- Preço TC-14: R$ 1323.58
UPDATE pi.modulo_tecido mt
SET valor_tecido = 1323.580, dt_ultima_revisao = NOW()
WHERE mt.id_modulo = (
    SELECT m.id FROM pi.modulo m
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
      AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
      AND m.descricao = 'PEÇA ÚNICA'
      AND m.largura = 1.80
    LIMIT 1
)
AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1)
AND mt.fl_ativo = true;

INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
SELECT 
    (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
          AND m.descricao = 'PEÇA ÚNICA'
          AND m.largura = 1.80
        LIMIT 1
    ),
    (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1),
    1323.580,
    true,
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM pi.modulo_tecido mt
    WHERE mt.id_modulo = (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
          AND m.descricao = 'PEÇA ÚNICA'
          AND m.largura = 1.80
        LIMIT 1
    )
    AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-14' LIMIT 1)
    AND mt.fl_ativo = true
);

-- Preço TC-16: R$ 1390.59
UPDATE pi.modulo_tecido mt
SET valor_tecido = 1390.590, dt_ultima_revisao = NOW()
WHERE mt.id_modulo = (
    SELECT m.id FROM pi.modulo m
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
      AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
      AND m.descricao = 'PEÇA ÚNICA'
      AND m.largura = 1.80
    LIMIT 1
)
AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1)
AND mt.fl_ativo = true;

INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
SELECT 
    (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
          AND m.descricao = 'PEÇA ÚNICA'
          AND m.largura = 1.80
        LIMIT 1
    ),
    (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1),
    1390.590,
    true,
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM pi.modulo_tecido mt
    WHERE mt.id_modulo = (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
          AND m.descricao = 'PEÇA ÚNICA'
          AND m.largura = 1.80
        LIMIT 1
    )
    AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-16' LIMIT 1)
    AND mt.fl_ativo = true
);

-- Preço TC-18: R$ 1510.55
UPDATE pi.modulo_tecido mt
SET valor_tecido = 1510.550, dt_ultima_revisao = NOW()
WHERE mt.id_modulo = (
    SELECT m.id FROM pi.modulo m
    WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
      AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
      AND m.descricao = 'PEÇA ÚNICA'
      AND m.largura = 1.80
    LIMIT 1
)
AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1)
AND mt.fl_ativo = true;

INSERT INTO pi.modulo_tecido (id_modulo, id_tecido, valor_tecido, fl_ativo, dt_ultima_revisao)
SELECT 
    (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
          AND m.descricao = 'PEÇA ÚNICA'
          AND m.largura = 1.80
        LIMIT 1
    ),
    (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1),
    1510.550,
    true,
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM pi.modulo_tecido mt
    WHERE mt.id_modulo = (
        SELECT m.id FROM pi.modulo m
        WHERE m.id_fornecedor = (SELECT id FROM pi.fornecedor WHERE UPPER(nome) = 'FERGUILE' LIMIT 1)
          AND m.id_marca = (SELECT id FROM pi.marca WHERE UPPER(nome) = 'OLDEN' LIMIT 1)
          AND m.descricao = 'PEÇA ÚNICA'
          AND m.largura = 1.80
        LIMIT 1
    )
    AND mt.id_tecido = (SELECT id FROM pi.tecido WHERE UPPER(nome) = 'TC-18' LIMIT 1)
    AND mt.fl_ativo = true
);

-- --------------------------------------------------------------------------
-- 4. ATUALIZAÇÃO / GARANTIA DAS FOTOS DOS MODELOS (BASE LIVINTUS)
-- --------------------------------------------------------------------------
-- Foto Sofá OLDEN
UPDATE pi.marca SET imagem = decode('89504e470d0a1a0a0000000d49484452000000a400000088080600000069db400c000000017352474200aece1ce90000000467414d410000b18f0bfc6105000000097048597300000ec300000ec301c76fa86400002cd449444154785eed7d7bb4654959dfafaaf6dee79c7b6f3f99817932332023c868403088c3233e0818132406b2041fcb4510179aa8288a2fc468d4f85a68b2a206575c62a22bbab2cc322144635c61a94934883c020c304ccfbb7ba6a767ba6fdf7bcfd98f7ae48fdff7d5dee774334c77cfdc3e63f6afe7ccdd67efdab56b57fdeafbbefaeaab3ae6ced31f4b1831624d60574f8c187139311272c45a6124e488b5c248c8116b85919023d60a232147ac1546428e582b8c841cb15618093962ad301272c45a6124e488b5c248c8116b85919023d60a232147ac1546428e582b8c841cb15618093962ad301272c45a6124e488b5c248c8116b85919023d60a232147ac1546428e582b8c841cb15618093962ad301272c45a6124e488b5c248c8116b85919023d60a232147ac1546428e582b8c841cb15618093962ad301272c45a6124e488b5c248c8116b85919023d60ae6afe5af30c81b990424d37f474a4830b030f97a940323e77801f93bef304848404a8091f3a9af3663fa47e45c8c245f49b4541e30c1f0d909803129e7c4a47ffd9ae8b3e1c941c804986410bac0b64906c94720045863912290ba48c21903a36f14d9ac4a2a85b1aa18a4b953823106c65812c7187e07ff928cca459e4f2cc8908219ccc2e6abbc2f7fcbf9b46d83aaac608ce5396384a03ce613fae6492c1a92019249002273754040625ac7bfc3fb9e4c583f42fa84d846441fe0eb00e381e03b38e3002102c90221470f23d26bf5f851bf1b8a321f3c9c75b0964422299d904b49b46ce1a82423e19572523221b5c21a4bb219e66184f88bc51e66d30dde3fb8ce44fde1a36128adf37763906c444a11704004ff06044493a81ed610979f9089d22d2c3ce2dc23f8c09618a8c76123af829c1836fcb969b072eff98e638a8831a02caa9e903080b5b0964ade2e49d6e53c8c318829f23b8c9443252d00abd277f99eae6d61ad85756e89c4949acc0380981bcc62c8bf24cfd4bfc618a41825e1f0764af99422090920da806813928b0836668d713971f9081912c23ca0db6da96e577924956921ea6c4800ad3a51b543e87755c38ad5ef7adc930c594a1a23ba512496730e3006d65891601180c9c46072122fc4c4f266292e041552a74cca3efff9de2e363637970894d5b8e4002491843ca6d980febc904dedd618034d9394c44491ce61fbfae13d0921061867901ce06d8758d000b81cd87742a6042c4e9d45da4bb062b7596b915402a06fcc98129cda75da14c2022d746eb3017a296396d4991eab24d28f9eef7c07e79c106f90b3b530d6c25a07b6a7da9043a19284dc248a347b9654c332e5ce20efb6bb7b165b9b0796dec9188324e4c948f2bf6142ad8f941082e7f31310a287351631526df3b9ec5cae2832e1830f08c1c3b982e5b7ec285dd1c1bb4e6cd5fdc3be12328588f989b3886d84ef3a6c6d1d04008418e06c91c965449a8418604432a5444930245548b157e7fa10439d36245a4262bb19695403127d40104a8a8898024a572e11921226517d1b4ad09cf790e4924e4ba483210c24a84a2aed74c6189c3d7b06870e1d418ca27ec5f4b0437b52aec4c173f93a060991751393bc2d108287350e317a20f6f59600b8a2405994b0cea269ea6c1d39ebe08a12ae28609d639d14015dd92122ac94e589c1be1272efc46934db7314e50421044cab29ca72026b2d49e91cc928922385801459d990464829716c9984687904cd8147cf3951a1625b29f43a90c41ce825564a099d6f5196934c160cd57a967242d05c0ebd2caa5ebb873148c1f3bce4c10e3624a445e73b04df613299c97d10aa0d07462c39ab62a8befb4e1153a2344c89f5c68bacb318e53acb5db802ae2c8490ecc05624a8750e6559a1282adab616f036a2732d82f5529e2706fb46481381873e792f8c31288a02b6a8d0350d36370ef2bbb5f0c1a39c4cb364883120068f1848aa90441200482964e9c807c8ff92483469246499d153912713cd05515d29524c745d83a2283319563f0ab3620e0ccf63f824113f06328a8690d1da7c9c6280f71dca722aa5e5ddc6b05b31cbde4c504948d75202fb5ca2a48cd243061d31c6881823eb4f642a4002b65d83180352a2c961ad8373058aa24451142466398175f4124413d0961d82796288b9aa139e30f8a6cd3d35048f183caae90c7bf3b368db062104944589e0bba586d7964d69e0a0ce97e45f4a220938524c2920a6c80602fd93e2026786597d51054621790407006c3669d78184191270f5384b294da71f2690bf3c4e3122068eea63f0484868ea05620abc5f3e31f07b8cf2fc48b5accf0b728d83192163ec47cb9a4edf25bfbb0c809a6681aeade1bb065d5ba3a9e768eb399a6681ba9ea3ae1768160b34f51ca1eb8098e05281593743d54e9605c2e3847d93907eb7c523771ecfd2c23a075754704589d075b0d66136dbe0c0c15ac058a448951d42c86a3aa6404128956dad4508b46f54b5aa6449728f59726ecbe8342518cb01804ac318237cd7a2a82a768a249231e7c9677c36e90821814a534db3d4c14cefb731d6d245036051cf31dbe0487b297fcd0b80199c931c8014297dd5a6e40b89142548de8090023b84983bcd628fc48f2113da180b630d5c51c09515aa6a8ad29528cb0ad56402eb8a3c280a0868abe6719596fb2721db4e467b0064f4a7bdd3150e09117b7b3bac9c1881c8ca0358794894601432cb95ad0d1842c8ea672849cf855ccb7f347d82730ec1776283e920a3974a2a01871f55895aaee1b5fc443d37bc5fecbc94128aa2647954b20ac1d41e4454492fdf5382517b7148c6e17b0dcac6c1103b4614891abc47f05d2fad53820f1d7cd7a26d6a744d8db659a0ed5ab46d83b6aee1bb16a1f3300670c962a3dd808b457ecf4bc5be115289427bb0f7090679f994686bedee9e45d775b981a3365a2f13961a3c8a84e99f9344d5f17930da009a8bb4969ce757218fe947f8d0e740258a740821fe6a63e7e361b91f85c4fa8174a8f9de4e96f02c6bff9e2c8f947c40da3ce0d3bc32fae324831db991c729a16d6ad4f59cf59544f58b304889a681ef3a84ae85f72d3adfa2691bb44d83ae6bd1b51deb30464cbb196c7283e75f3cf68d90c650b5a618397a961e1b23fd67c1b700226c5160bed841db36721fa51f9ba39f8d185e1b3638a401b2ddb5d450da983c643efc223902e26eeabf2591942466043b0ecb245a1389f3cb9a5a075fe721eab09c8a94120e1c3c8cba5e7cd6eb4ac47c6df5bd04bcbf2733524254dd9248a0e05bf88ede04be17252e6d69fe0d31208680ae6de15b21a16fd1a8add92ce03b2f034860d66dc0a64ba7d3a5e7f01861ac410c012104be6c0c4891c7d63ac410e0bb163178b8b244dd2ed0b43500a02c4a924389b494f32afa8652426422e4aba216071812a170659f52ce89ac64b788218f58c320df986418257f85b2f9faf019b94cfa891cd8ac9667f5d397e9dc73c38fbef7d0ed1553440c1d42083000ba563453cea7af137655daef5ddba26b16e8ba1a6d5ba3691b34f5026db340e83a3ad5e130e9669fb3753e17f68d90d96d1003bcf7ec7d5d0b6b2cac3528ca1200107c8be83b58e7e08347db353000aa724252e7395bf6760c1a68f578083614d3eba8daa0af3f0e44781ca2cf3918212f1b4eec38714be567894d069344008ba4411f859384a829db70e7126d329d9e736e08d508fcdb7716e4b22c0f8802f8ce46aed3feeb1083c762b187b2ac78ef208f44cb257720d633dbccb71c8d7bdfa0e96aeceded60beb7439b3b25d860e0ba4b53ddfb464863398a0da15705ac8080e03d52e280c21883ae6b11ba16314574be43ddcc915222298d418811210c6d35b5a53873a38da59fdeae5b3ea78ee294449a09c118d2c686cce5177997b23b4925a0102d7704216d2219528a944c898a93c7aa16076500b058ec9d637bf66597ba1b980010d2a84d1b62800f1e5e25b874c01055fb741cbc44fa7013fafa537b3a894da9340d51de354578ef1182e760a75ea06d6b2c9a05eaf91ee6bb67e1bb0ea639b7235d08f68d903a20a0a46005b44d0ddf75e8ba16ded375e09c83738e15e7bbdce08b7a0f8809b3c92c1307e2e4a53ad78a8859aaf1f480744b2abc6fe09412bca7544cd28029db5ebd2855091ad50390a86a8d4cd02cb95a726e83cf80cc51fe85e811a43eaa6a8a98e8c08ea26ee96b1c9054887c0e61e5c33ad64e2a1d2104f8ae81174916251a48dba3af1f8894e7b15673d22f0934bbbc87f75df65f2e167b08be43dbd6088dbfa4c8b67d2324dd6f4a8a5e2a74d2eb7cd7c27722fa2da7b0620ca2225ac418b137df414ac0c6c69654525ff1ac391d25d2afd693b4c752e54b63c4c8e0036d601dec24190468c321893e1b40c74549ae0d1b9952920da9d7d9b05266299f12278480242a3d64e7be905048aa1d7a89b429d2a93e94745206da80b4f55288089e3664d7b5bde723ca471df35a6ee9582c9fd4651293277076c9770ddaae41d3d6e8ba06b1f388972025f78d904555d1119cd8ed92d827aa0abaaea54ba16dd9eeaea46f0ea0ba891d3adfa2aef75094150e6c1e4294517bdfc8b94b8bbdd757eef0b94a143a8523928c28355d882c53963e2bee9d947a29dfabb4413af9a8740b5106732120c4884e6c6888ece4ff13ea7a8fd22dc62c8563a2244d29224254b61215e2d056c20c081b65462c740ddd37aaf213cf1745891064d64c0697c3770c033fb05a9514212caf76d018234d2cef45db75087527e92e1cfb46485716409ec5e06c8795d8c394127ca0fdd389e19c4207eb0a9455056b2da2f770d66277671bd6184c661b28cbaa9790228594306c64aa6f2392cc882d6800d81c792ed7851448091640d7366ce03c5b443b17e0739234fa50f5ebb3973e43b5aa1238139884521258431f68cc9d0b99acfde04be22db5b365020aa9d4b526264fd7d66237faa5a9c97ab1276464997a69de4b37966b10e593c84d860df673fb3174e8ba1a75bd872e76f0edc5cfdcecdbd4614a09777fe0e312110e40825663a49a524d68ad43559628ca12d5640a631d6260ef4b896155878f5c8903878ea06b1b9c3a797f1fa8c06cf9472a4c6314fb69bafe75a9a6d506e460086223c610f3c81f0612c8d04f232a610c8731790a2f6695af52456ccf446d4008b15932e607a0ad6b4c679b3caf15a2a03ae19dda31f4757be3563a4a408c09be6b963a424a116d435bb2eb3a54930900a0eb5a1863e01c675c545068fda909a5b1ab9c3ea577c458c777701648066555a1dc9c6076d5012df90561df080900f77fe4762c76f70069540851870d0c8051264589b29aa0282b009c35d04a7545852baebc1ad63a3cfcd009b46d0d68b89615092c44b412e43a7c9e362e09296e115e0560399d96228aa284d5796419951a88a8050731217844994da134efdd1e14383107c6eeee6e6336dbc464b2c1f25a1257dfbd6b1b54d504313178d9da3e1c4f0961ac10533482b516ae708c27958ec9fc7af26afdb20a54ba71ed5053ef61319fc3150576ce9e46f03e4fe19edd7e18b3d926e30e5cc19035e7605d016b2582de71ad93b5063144586b516e4e71f0862b723d5c08f695900fdc7637761f390d08412831a402257841af596b5195131425034639bf2c330831e169575d8fa228b1bbbb8d471e7e900d6c4c6e98945839ce393ade45cd1a30d6d220c1150cc4d50558c14be87e62104551505233fe1108210012195e9413144529832faa66ebd80960241a3cc364dbd0150516f35d5493a944ee44c61d5a5904266e2bd6c3500c0e7293cec5cec17ad372f31ac9a85798419f517fbf744431157a1b91e58d2162b1d845bd986367671bbe6bb1a8f7600054d5045539812d180c638c10d259941b131cbce14a2dee05617f09f9c9bbb0f7c876968a06264785037d8f5789519615aaaa8475059086f3e1014fb9f21a4caa29bcef70ff7dc7504d674829a1280a4ca68c1aa234655c5f0f9116488cfe1689e124421ac64084101b5b25e440871a090e3186ea8d4c000c6c968ad6d23aa534627e46f2a1cb9c520ae0aaca10028c35985413769ac17c7fdf614d969e6620e521c4d2056e5abf30ec98b0bc376b87159e27f5bd0a21cdd02451f750629a103cb6b71fc1a99327b0bb731a870e1e852b1cb4431b63501e98e2e84d574bee17867d25e44377dc8733271eea2b4c5b6955044845586b5116fd683bcada90ae6bb1b17110070e1e81b30e7bf36dc418605d0163558530f856a5ce305f92b05f49685dc176329c90ee6d3d3da5c44c4296fe22f362500749a41d4bed30922bab7bc953e809a316803108327dcae058992e55520c649e926a9019cb22f92a49796ef07d909e3919212bcf48e1994e068a21fadc4ec638f8aec57c6f07d3d926eebeeb763c78fc2e3cf5a957c3160e6dd3c05a8bc9a10d5cf1ccebfa675e00f69590dbc71fc68377dc85184512c628b65edf13f9a557795cffc188728e49e89228ca0936b70e6232d9c0deee19c4d0a1aca6b0ae84b1fd08beaf6cf92b42c2c0c24af4ba365c7e78a2433c37a3a1b451b9624caf2a8d48214a1f0cb6a630b00e30702463363df5594a4691a042122391f34829dbcf9ae3b904d3efb41d8d91558d52f65eca51fa45efb3d3df18be7f8c114d3347bd9823460ee4acb5a8170ba414319dce107cc07cbe0b630d8e1e7d2a9a7a0ee70aa494f0d18ffc398e1c790a8aa244143ff0c16bafc4e16b9e042afbcc895378f0f6bb73055b59cbbcd483a562b5f974e6c65a9739c5115e81ad434760adc57ce72c168b5d6c6c6ea128273012e4ab8dc77fd2a89a070c008b42eccc7c6969044d16253d0f36644f2aca3e1249321ea84e55c992592e0b64792fcd135e4b4894ee89b65bddd4984ca6409275ea320a4e4812c7e8393312a819ec606e9f7e4771ff20d181ed3b38eb5096257c08689a1ace394caa29caaaca655f96a6ac0396592a426a318937e2c4fd770148984cb84e2ac6882b3fef3a6c5d71a4cfe702b0af84dc79e8348edf76c739f649ffb75f83ade76d763bd08e84a8c4b6a971e0d0516c1e3888338f9cc27cef2c0e1d3c827232a54d230d9ea59f18fc2a9121eadac0c019927e582e851eb38cca0d9a020055335d471ce1abdf4eeeca9da26d9b6cf4fbae43d32cf87ece71da34260e2452026242d32c18a16d1dcaaa42d3d458ccf748a2c9ac0f46918196760f4a6e8bae6b5155d5c00da5e04bc8ab9068807c53e7baa2ef60c6ba1c61af88c1e3debb3e83e96c9a5d463146dcf8c2e7a29888cbec02b1af846c776adcf1c18fe6efeac2e87ba7d85b090881614dce15b95199862475aec4e6d6165c51e2a1930f606ff70c8e1cb94256cb95b0e28ee0bd0074b1be753489aca5ba4e340f347f95325ca74c09de360d82efd0f92e2f0a7305555b4242d7301084a48d791946d7b6f0816b84aa6a2273c991ab1a0d09b0dc395915ec2832c890eb79c021eea75e5a311f96bb7f571f3c0a578839c1b4fa8ed9ba9073bac04dcb43cd25b490fbadd34d12b41d5857c7efbb1bd5841e0763003887677cc973973afe85605f09d92d5a7ce62f3e2c1549224471fd6845b261e80eb1d602b25415d26846249436f274b689e3f7df03a48083878fa2700ebef3795db1b30e5656cff9ae45d775288a1293e994d35c126964ad41594d608d61c87ec358ccaa9aa0ac2a385764b2528a50556ba3ea27caec0c60509415525c9ee121c4decb64933c8591f49d9220e78037e6b49a8fdab2183ca7279bdcaa6406fab44a31f16d52480c9f03a4a12744d293b0090f9d3c01eb1c8a82b36607ae3c82eb9efb2c3ef022707134be4818f22ba3afee5e52ac4a0c2527a54040089c75704e16b34786b23df8c0096c9f79048bf93c4fbd25d944aa6b1b34f51cd61a4c2613148593dd1a1c26d309a6b32926d399b86a80aaaa70e0e0216c6e1d44359902a0f14f29c346336253a6c41176d269cb3c7dc868a67c5ecaa3f3d441c2f074aa4fe7d2f99e3abb22f70c3e4a120a4f461be9319fbf720f5896a473e05206244e3119dd44200d46d8a6ef202c93e42fb3405e6c58efb9e65cdf0900360e71f3878bc5be12d295250a57e6cad3e81e858e5655cdb0a24840c6e2050489e9dbd9d946bd98a3eb3a9c3e7d0655556232994ae7e690c53987b2e4ac0f558a48dbacbafa79e810bc848ff5f3cfda51fa0ec1f42168004492f5e10ccbcac48b113178d4f5bc0faa5002caf514259a47094256497da8db89648b91a37e9645ffb25c51237d2418625502b2c7287925e044492ac7fc2f5162e475dd2c8f816c5c2576bd3e3f0406c4306083cff4dee3c09547a5ec17877d25a4b106c629191242ec236a7ae8b1541a6b473408d36aafa42bc863fbec36a2449d68a5715a0ea2d6a8fef45efad8e87aa2ba12528904e82b9fcf2519253a674054ce5fd3ce64c3f6a452759962d4ed7200f9abefbb349b2365a494a22d9a442ac983e50f073174ae6b7abdce32b11c2af1d260ebbd5ea26aed28c10c582f7c2f213030288b6c5b23c7daa9d5e4699b061b07b7505ee46046b1af84048072361375d4db3bfa59fd3efc687a88bb417be86231c7c68c4e64ef293d29f944020cecaa2851e66c3bc6f4317f71f50c1b23b1430ccb89a43b89c975c86040ef53a20a96ec4451a7245842ca924fc94d226ada9e1c2415c92d64d44e2c129d9d00ba93a99ce2142befebefe1fbf7b195fa8c2cad257a48d3d27d044e7d26c666f66dc0b8ca4e62090e5ca4ab67887d27643529b30a33629be5461b34a6220da2557a229b3ce20bde63fbf469240051e2fbf4c3ef0ccb52b5ab2a3a4abc626e50957c4848baa05e1a52d5580249c1c6d590ffa174d47750c2e9b3d8b814b63df1805e3b6b27e1bd3d199540107995eb8bff49f9250f491fc59799ef977c87df99eff233f45cd2ba0e5ec84b726b67efbc8717f3298480b669e1aa0257dc704d7ead8bc5be1372e3f0c11c14ca205851852b953534e8831afed2c041b69d8bb286c4c8064e4a342f21f6242249c388e898a3c953a21dc7c6264792a82e0ea8b49575440919300837e4b241bf8574be878a191057130f550a4b1255b14ae6bc74407774eb25af129d645ca9abb8ba688cefd6b4cd52147914e936b45b5503e44f8eabf4f2e9838bbdb8bdb46ed563d1d40b44043ce3f9b788abedd2b0ef84dc3c7a986491a50bda1bfbc61462c8cc06442af84002776d03ef3d8ab24008ac9cc57c2e2452152c1250360c608533c69173ce1083ae77839069d2d871e86896e45972e9a73fa7f7913cbdb4e44c8cdc27cfe56d24f6e095493a80fba7cbfdfc23ff74c02564621e3272964e1a9390c97b005c2714a30ec07424afa4d368f77e601402251f49e7d1f90e6ddb72e96b5363b19863b1d8435dcfd1750d6c59e0bae7dc8ce77fc5cbb179e4d0e0652e1efbea87541cfbf0c7f1c01dc7e05c0918603adbcc33254a42454a095dd7710db748cac96c066b1cacb338f9e0093c78e238aebbee3a4ca61b28aa2a3bc78ba2e44c475108b10c8ac173b8c85d6788c436d4c89744aa72ac418947750e386bb3d4b4599a329f984d0a60512f30994c7b5fe140fa26353f813c6f92969cd77d30464c31c76526f52ba63ed8045a561d80081959a779fc21334a7aac8e7cb10b071e073e5fb44a2051430c7025e7af0f1e3d82a3d73c0d47ae7e6a9ff9e384cb42c8e823feea8fde8fbd3367609dc36c734bdc323a222692d861be6bb3144829a2aca6a8eb1a9b5b0770d71db7c320e129575c89723291ede32a545595f79e748ef19016dc440942346b34f0416c5225d960475f8874b28ed749d25e2573942d84d46391f075d3602251d9bcae130149482e90cdf335574dcfffe40c93886455894b32b14330ac4dcd93b66d50149cad821090a64e7f1c03b7d28e31626f875bd840c8183a8f6b3fef26dcf09ccfc7f4c016e31c273ac3f4c4e1b2101200baa6c56d7ffe013c78d73d984e67282713b8a240e14a1899bf4e89be4aefbba5414a5952f2a594f0b18f7e18d75c730db60e1eec256335c144c8a9513fd0b9ebc1ac0a4169c6990e51d5bde8d2144b6e248a1de93199444a204a37351b747a920ddfdb799074fa578fb53cc36bfa97d26bb0b790482e4840455d2f106344b358c0586ea8af128c1b3374b096513e210634752d9a8491e06a3a1989827afa736ec6736ffd5229d7fee0b2111252c90fdd7b1cb77ff0c3a87776e14add209384836c4d1c037f9d21ca80c55883a2a8d0360bdcf689dbf0cc673e131b9b9ba8aa0ab6285055534ca65398c142b29e84fdb14a4288135d8ff5bcb3dcec5e09a4f7b2ec6af7d2274a75be3c2b136557e0246b81a2d87eea5b54bb4e9f11237724e3c896c4f0be43bd58e474f3bd1d8410b246d118445d1f632560c3398724efc5295803271d5d9f6d0c772ed6bad039f82891ed5b870fe1b92f7ff1e3ad951f159795901929e1d4f10770ffa78fe1f8b13b65e756f6dc84d42fd79488e42e786c6c6ce0ce63c7801471d555d760ba31435556b421ab298a824119443f3fcc53fd1207ac9091c549790d49d4f5d2f93aed3ff50e4419304196eb72ab4159a9e83deac5029d6cc21a6340533754a7f24c12a39f3d82da91e2dc2f1c9749706d0d3b4bf0fc85058d84d7a94c3aae13a6b30db8a244927541d5642aa64b015796287579b1e7bc3e56cc89209b01745d8b9b5ff242b8f2d247cf8f15eb41c801a2f7b8ffd85d3871ec6e9c79f06476a94471414cca0a497edfe5f64f7f0a575d7d350e1f3e82e96c866a52c15ace716789a80d2df6180716aa66690f2e0f36a852834cf5354d0320499edc44b55e50351ac3e9325d630d18da693275a992278ab47585c67652025b274b282cdd5603a59d55a72bb84168e10a54b2e8cd7b8fb22c5196258ce17c3ca39328d1d594e05b72b0a6ef0a19c8a91dda758dcc18b14c51dc624196255ffdec9bb079f4f119413f16ac1d218768eb0627efbd0fc73f7317eebdfd7618b16d767777b0b7bb8bbaa9618dc5e6e6160e1d3e0c883fd239071f83c418520292701130164e960b40d7d2c8c8da08d1798f369ca83d2152e1183da47621d5ba904f56f2299478c10758278bc60a250ef32d1c17b139eb60e427498ab2647ca1e4aba603406d124218440409d1b497192134c0d91ee9846a6e0cf440de240ad4212b84e4be4a47ae7d1aaeb8f1e2d6c75c0cd69a901929e10fffedefe0f4430fc18bfa63a388a411f5a5d1272a99782cbfcde21c8aa2dfccbd28b9fec6158504a0327eb128ca3e484b062f74b5b0f1952c56837b9d4321616b0909455161524d006be1444dc6c4e824aa63193c8964a647a9976046241c07d10caa185e4b090cde95e50d72b527e592b457dbb787c9a60189db34758e7087e4c820109a49c5c604d77fd1cdf9fa138d270521771f3e833b3ef851746d8b7a31c7deee8ea8cd00671d0e1c3a0c630d820ff0e2ba304232274b539d8c24cba294a59b5c6b0c5db75356593aa961af2470b2830697d072b5e2d05d1425d2c64a847aca53dc145931b2f30cc900e875fee535b17145d2e940460366b9ee9afc8d9101217abf95886e252d6490a552949d61f9f90050d70b14969d85a9348c8d8ef3d6b778e6977e51b6b79f683c290879e2537762fb8187e41ba59ff71ef3dd1dd4f55c0c76ba2d540dd3e0e7ee0ace1528ca0ace595415c3edad73285d015807a38bca6454bbbc6c561dca249686b0f1b827a4919d1c9464c8762028794b59036e2d678b84c0dcc9ac1f60f5d24d54ad98801a806b8c455dcf196a97c4312f929742526337856203b22b29b39a3606bef3390037269911325cb71353c2eeee593ceb4b9f8772a6fed427166b4fc814238efd9f8fa16bea3ca362d57d61b82b6f5556d0f51e4a029506dad0d6ca4fc6590323128e8dc446860c9c528c28ab6aa9d1962599488aa45bda214b17c86086d77be19455b4cc060d9168134847e30d2a9d87796b3948383aea93ccbc5042f6126ca94ce7c1f09d9aba8613b710007167013171fe7a67671bd7df72330e3dede276a2b850ec8f1cbe04748b16be6d91eda4ac2aa9ca4ad907c8b982ee22d94dc2a88d9600240dbc6030026dab44d35f492c0da5924ca124a7c4437ebeda94bdadda93d118ddd2859269b158483ab93658c3633259a5436489a669359fe567d1961e3c6f90aeef90fd39851910db18c35d740d5575766918da9f5e621d93fc70d57e60ed09393f7d564840e96844b552da48a5f772493afaf03a2b9aedc26002865d6923f0b6245234878ae54656226069ad8b36746f4bae92a2bf7f369b6512f2fae09ec1de4343c2f1dcf98915835f7e67f4f6e830ddaa944c6a0a0ccc82a655cd33b84f9665e85463aea47dc0da1372f7f45918fd0dbec16f5753b245386791c090ad21350db8b2d0a0df8089724e1a7d40e76c020c76023b1f86520ed2f86e402225945e5373b2284a2c167bf93ba43cf9db799e3754c1ab978d73e2d096efda3906792a86445d92e6724f8e2180f29711f05e227d628c48f6dc7c9f28ac352163886876f7fa16211bb21f4f7b2ed56a2f959ca5df50c9634c4f4c454a54daabad4d774a9fd7b9526bf9f87c302281aca8ed288bd2faf22ce7a3f7acdeaf1f0c8895c4c9deb5ec38c3fb96d20e38a4698679ea54a5730ce34b123d142267696af98939372970e8caa7f4993dc1586b42768b5a360e9506140a72b40909f3d7d45ad1227d129dd6d6d25593a7d78c4132497e077ab5317589c2b9385fc39feff8fce9b82dca2ac156ef3df77899f0fdbd118b05b7351cc2c8c60151026a93cc956bec2943c9648ff0ce237ac609c4101062871802dab6c6de7c176dd7e2e87557e1395ff6c2c725f0f6b162ad47d93ba74ee39e8f7e124551c9dc3447a926bb4f227fc346b759c9c4e137da7ceae456c964918cd870b0b2d1a61029014ddb603ad38df57b69c5bf0056760ac30a99ce8794129abace011fe7434ad979399090006d939e9b2931407751cf319b6df6ef24e7394a5609c97c6292a94d315b18b44c29591625420ab045013729516c4c303db0818d4307ce717fed07d69a90f333bb38f6c18fd2315d720f456d2cda92f439c288fda884d51dbd44aa6afc77b6cb72a44faf421539f651a004d2e7ae42cfad5ecf649234f56281c9742a514ccab0fe3a3f329acdd90c065f7a260129062c160bcc661bb4f164a0a6e9484e595b23b33de5a442519580058a49c5f9f14989e9d6268ab24439a5a972b9b1d6840c3ee0d37ff121f845d36f9162b93b2e037603a653916632afcca636e7902a456ee6a4a35a86a5b1f1484a124a031786f72a3e1bf9f45a2fd9789cdd383223a251374a3223d392c3c8213259262f9391b965923549185b5289bb31cbd2be9c4d3099cde0ca02d58cbb6d98a240b5c1694dbef7f9a5f33a61ad090900f5de02c73ef431b47b0b54157fe55e341b554e0ec2a5eab23cc81294fff552cec8fcb7b156a26d0825d362be87cdad837926668821d996c829d24949a88eee103c2061644d53739304a42c2193ac150244a22171173363504ce85f2dcb02a62ce0aa02c61954d3298aaa8275562281f6cfbedb0fac3d2121443879d7bd3879cf7174f339f78134165ddb30f66fb021951d6cd0ce1908367f921d60e97303d5b9a497111252e23edf93e90c2932bc5fed30a3bfcca0a16269b0be2517545700523286c0dff976ae403454c7e5a44239ad28ad9d41399da2ac4a18675156158a4995676cfe7fc49382903d121667f7b0fdd029ec3c7c067b67b6f96b09a2ca95989ccbe686f5b42b4545622021859046667cb84f10ed2e23d1442a058348318d2602c43f610c5c45fbabd019a3898493150ec58c9b540d47f8231e1d4f32422e238688666f0ff5a246b3374757b7e8160d628c086d8714b8f4d559469ec714195b286a1462b70dc99c0014d34ab67c497055857252a2a82a149309ca0903338a8ac41bf1f8e2494dc847834ab794c09f41ebbca853ce671bd0cd62f567358a5e928db87cf86b4bc8114f4e9c7f5a62c488cb84919023d60a232147ac1546428e582b8c841cb1561847d96b8a071e3e893ff89f7f84d367cf00009ef5f467e2152ffaf2c1e655c4ddc7efc1a9ed47f0ec1b9f85cdd9e6d23500d85bece19377ddbe7a1acfb8f6461c397878f5343e79e7a7b157cf574f03009e76f44a5cf7b46bd1b62d3e76ec364cab09bee019cf5e4d86d3dba771ecf8dd78d6f5cfc4c1ad0bfb99e291906b861022defd7bbf8e5ffced5f46dbb58c769759a6ebafba163ff51defc4adcf7f714efff65f7c077ef7bfff47fc879ffb7778c1739eb7941700fce5273e84d77dff372d9d33309854155ef1a2afc08fbef90770c5913e00f735dff37a7ce4d3ff7729bde28d5ffb4d78c7b7be1dc74f9ec0cbdef44a14aec4afbde35fe2a55ffc654be97efffdff05dffdf36fc77bfee9bfc6cb5e70ebd2b5cf855165af19defd7bbf8e9f7bcf2fe1ea2baec22fffe0bbf0c7bffa9ff1c7bffa5e7cd71bde8253671ec19b7efc1fe3e377dcb674cf3012fe7c3030f8bb2f7b15def9e61fc43bdffc83f8e1377d1fbef0f36ec17bfff40ff0861f7a23b677cf2ea52f8b12dffb4ddf99d3ebe7952ffecaa5744dd7e06deffa619c3afdf0d2f94bc148c835c203a71ec42ffdf6afe08ac34fc1efbfebdfe3ab6f7d056ebaee463ce3ba1bf15d6ff876fcab1ff805d45d839ff8b59f59ba6f182f793e24247cd917be08dff2ea6fc0b7bcfa1bf08f5ef3cdf8dd9f7d0fbeedb56fc4edf7de819f7dcf2f2ea52facc3eb5ff9da9c5e3f7ff396172ea5db9a6de1e4e987f0969ffa6e78af0bc22e0d2321d708effbb3ff86a66bf0ad5ff72d38b475ee0f10bdfc052fc10b9efd3c7cf0931fc6fd278faf5ebe607ce7ebdf822b0e3f05ffe3037f02ef75c3acc78e2f7fe14bf1baaffafbf8cbdb3e849ff98d77ad5ebea869d891906b8479b30000bcf4f9cb3699c2188397bde05678efb1909fbebb14cc2653dc78cd0d3871ea811c240c004dd7e29bdff1667ced5bbf3e7f5efbb66f4458599f6d8cc13bbfed07f005373d1bbff1dedfc27bffe40f96ae6b3cc1856024e41a62d5a61be2ecee0e80951f5dba04b45dbb7a0ac61adc70cdd3f18c6b6fcc9f9baebd7169a9876273b6899f7feb4fe2c06c0b3ffaab3f893befbb6b35c905e1f179ab118f0b6eb8fa7a1818bcefcffe70f51200a0eb3afce1fffe636ccdb67078ebd2f76cdcde3d8b7b4edc8b9b9ffeaca5055d952bf1136ff911bceb6dff3c7f7eeeadffac5f93b482e73ce3f3f1236ffa7e6cef6ce37bdff5c3a8db6635c963c6f99f30e2b2e02b5ef8323cf5c895f8adfffa3b78df9f2e93d27b8f77fcf24fe0be93f7e36b5efab771f4f0a5fd6ad6bc5ee0c77ee5a77066771b7fef65affaac647bacf8baaf7c35def0aad7e1439ffa087ee137ffc5eae5c78cd10fb966f8d0273f8237fed8b76377b18757bffcefe025cf7b31f6ea39fed3fbdf87bffcc45fe18b6ebe05bffd93ff061bb30d60e0877ce58bbf12571eee37843a7ae828defa8ddf91fd902ffbe25bf19c9b3e1fde7b3c72f6343ef0f1bfc27d27efc78b6e79217ef3c7df8daae2aac3d77ccfebf1f13b6ec31b5ef53acca6b39c1f00fc8d9bbf105f7deb2bb21ff26b5ef22afcd2f7ff6cbeeebdc7ebdefecdf8f0a7f89be8bff9e3ef3ec747f9b93012720df1b1cf7c023ffdebbf80fff5d1bfc8e7aab2c2ebbeea35f8a137be2d93110342aee286ab9f8ef7ffdafbceeb1807801baeba1eaffe5b5f836fff87df8a69d5cffe3c9a63fceb5ff95afcf43ff9b1cf4a4800b8e7c47df807dff70d3875e6e18b728c8f845c53a494f0d0e953f8d8673e81b228f125b7bc6089388ab3bb3b58b41c9d0f51d8024f397c145dd7e1919dd3f9bc351607370ec84fab9caba64f6f9f461bb8e9eb2a36261b38b0b98510224e6d9fc2b49ce2d08173dd53dbbb6751b7358e6c1dce92f7b16224e488b5c2b95d64c488cb88919023d60a232147ac1546428e582b8c841cb15618093962ad301272c45a6124e488b5c248c8116b85919023d60a232147ac1546428e582b8c841cb15618093962ad301272c45a6124e488b5c248c8116b85ff07f22ee21bbc61b2170000000049454e44ae426082', 'hex') WHERE UPPER(nome) = 'OLDEN';

-- Foto Poltrona OLDEN
UPDATE pi.marca SET imagem = decode('89504e470d0a1a0a0000000d49484452000000ae0000007f0806000000766ef964000000017352474200aece1ce90000000467414d410000b18f0bfc6105000000097048597300000ec300000ec301c76fa8640000225c49444154785eed7d6bd0644779ded3dde79c99f96e7bd56ab5da9558092190844c84881d8284212e48140abb5ce5c20e95508909d8408c7c8104d9b109c1c4d8b1e50ab1a33885ed1fa4702205dba41cc0120a090621811c24882424b18895d8cbb7fbdde7722eddfde6c7fb769f3323095b364b6666cfb3353b33e73edf79fae9f7d67dd43736be4a68d162c6a02717b468310b6889db6226d112b7c54ca2256e8b99444bdc16338996b82d66122d715bcc245ae2b69849b4c46d31936889db6226d112b7c54ca2256e8b99444bdc16338996b82d66122d715bcc245ae2b69849b4c46d319350ed08881a0a0a4404a514e015a07899860679803c416b69eb24ff91021441290d02af272210085e79103c1478338097b7f8ebe33c26ae822605e50d9453302a85f22a929308304a48aa1494bc877d85b94c74f9562f95cf14be111c793e2e1c2c1c9401081e1e04520ed08027cf3bb6f80b71de115743c3d804da1a68245050acb0a889a9586a65b92c63e6368e4420024014194b20d997b763e236ffbc4d6a0b888f43f0f0e4e1b503e0e13401da81b482871ddfa7c579445ca760ac41ea32a6a6d2dced07b24635e5cfe4b95b17ade5cf44f042462282f79e892bdf014069c3fb8bc9a1a04000b4d6f11cc1ac0824e7e57c8c5aa585d4dc8650a18257159c7680267850dd019c87380f88aba07300a546967499244a432b0525f62a938ba2187af220ef41f2ceb4052f03c13bc71b8a2d1b48ac941222d78d4169feac7522e706b4d2505a47e2b2dd2c0c0d4d25129abf7bf27c6ddec17b878a2ae84cc16b0ba7fd7947e2f926ae03680730a460920cc6242000c6088904440408f998ac4c8ea8aac19ef504222fdb35d5317cae4d81e8e4296e164a697909a985b84a3371c3baba279046a57483945aceef90669d781eeb2b786de11307afd9219c77cc2d715de1409b16c6a4302681f70eddde1294d620ef44c914db96be56584f04ef6c24262f0f6414c2829707f8e8d0f1319ab6706d1e84f710810c6466e50f24e6f79ac4bc1babafd21a6551a0db5d8036065a1b6863d8f4200fef1c1c797853c1690b6f9cf415f387b9242e79c2e0a92d6449074992c224098c4990e723ecda730100c03b8b7c3484311adeb38a79e7a2990028565d50b477b55270ce455d6ddaa3c14e6535ae9db9a6b2cba2a7ad8f9f0379a3fa36f767bb194448b22c123731294c924269032db6b5f78e1b2039f8ccc1ea02a4e6eb36cf2571476b03949b236459076992317193044a1b8c067dacecde0f630c9cab908f86f0ce46a50dc45542524c1034a86ed32c504a4532b269d12063cd5bd9ffd9fedc7cbc602a2871ec6ae71170ce214d33f9ce043749c28dd32430f2aeb461023bcb0d091e36a9e0130bd2cf76fed9c25c1277f38933f0a563e2a6199224956e956ddb221fa2d35d40776119de56e8f7b7e06c05e76ca3ab0fea59dbaf4d55859007107fac41e20026f4d3ffbce1986c36f0f142e2625c696bc5e58654214d3bb21d0028686d608c813142e034459264f25bf9f8ce5990670576690597d899cf99ce257137beb10a57581893204dd35a914c022d37d9561508c0d2f22e1001db9b675114a306596b72b2caf2b1037959616b623655377c8e618a06945291f8215a112211cd738e39728a09ea9c85d61a9e48826cecd835c9ab8d915e86096cd2548ecd2604798fca16b04909d50b918cd9c35c1277ebf81aaa410e28056d0c92a04626e11b6d4cfc5e5525b449b0b4bc1ba3d100db1b6791e703843b1a53b8e4391eabeaefec54059b95436a0a8096ae1aa2ae2a44c904c1dc08c48caaac241416cd909ab8de3909df35f7adcd0a234e1a13386502671d64690726e5888af71ece56b055094f1e569550cb1a9841fb772e89db3fb981e15a1fda4848492b6893c0e864ac5b4d920449d681b516f970807d175c04a53476b6d7b1b579a6b671bd90569b9a502a9052011408ce8ac9c465f56d9a0a9e386111547c52ee98fc7c8adae2e00fcedad80094aa95327c365a1a655460fe8d59d641927690641d686de0bd83b356ec5f878a4ae85d4a6a2966077349dced936b189ed9198fd72a21b06693214d8343c3b6a0d106ce3b38e7b177df01585b61737d153bdb9b31b2101a42389e96d86cadaab54a624cad457de1a3f530bea510509436903eb097bcc768b08334ed344268dc6082adca6a1bc86ba0357f37498a344d91665d24698763c4009b4adec179074b25b03c5bb5823374a9cf0d440e4e542574cdde139cb5a8aa026599a3287214f9085559c03a8b2449d1eb2de2f4c9e3a8aa0afb2f3c8c83173f8f091394d70b1143d8c93b1049b2822459a198a4de73fd019391d598036b75aa98af9533729c856ba8ad9cc75a0be79864f19c721de4e54504e75c0ced3967616d05672b546581aacc61cb1cde7b56e394436ac618184a60d74b909f1d0d9b4bc51d6df4b1f6c449561e71741083f821ccc4a1ab34ebc088cd9b2429d2ac8334eda02c727822ecdd7f219c73d8da38838db5559077721cae20e3942eeb67adee6cab12388d1cf43640092763772f5b8bcc46252610bce5aebdb21594a83cabe644bc572b402b49271b280026c47a9304c6d4bf2f493b48d20c4484aa6487d456252a2a61f6a4216937d598814b7cee304902808919930b5ed4b75183409ed859b125cab2e0573142910f90a46c4e9c39f92440843dfb0ee2d091cbc652ad402383d6481923c67a597923691b2590b2b22638cb740401f09693225555c0590ed579f2b0f2991d35a99f10d5f5e4e05dc58e98b3a8aa12d65a585bc2da0a6599a3aa0ad8aa84528acd07c5e685720a76a3a82f628a3197c42525dda874df4e425c7c33b93bb5ce8a930478c7de76341f8a02453e0291c7e2ca2e6c6fada1180dd05b58c2a123cfc7e2f2eee894813853c72796ef4e52c54e6cda094236fe8b1603dbc962d31281446901484c96cfe33d3b8c5e7e8f9774b502019e002978f7dec1351229de7b588928d8324755b2890448efe11db4d670238b726bfac93b97c435c648b71b1c23b61d19753cd37b0befc45ef45cf55595258a62887c145e0324490ae72a9c397d02c624d87fe062ecbbe022893230fb98bc757a9884d0e4d94e458806c83bbf825316484c80d41c585bb1c27ac7d93d212824de4b5ed2d3f21b598583bd1bcecdc771cec2597eb1ea72c32c467d14a33e9cad62c6d0da0af9fa00ae9aee1ae0b9246ed24941d28d22289862078989aceab4a8e71b1b1c1eef58e9ca32c770b883d1b08fd1b08faa2cd0e976d0df5e071161716937f61fbc18499a8abab3e9c1e70bff09e47b18e010ae8337e1eb614905bcf5a8ca52cc1b565448edadf74c6aee49420110bf9452f13b9b2a7c3dde7b386f619de577cbe64359e6c88b118a7c88b2cca3ea77ba3d8008c3333bf5f54f21e692b8d00a085e37c5806af4dcbd14cfb04d0a0e093552beacc6ec1895458ee1b08fe1b08faac8a18dc1c6fa690c073bc8d20ef6edbf1059a72b0d8249590705ea1adfe87211a0889db0f09d19cb8da62c7378895210119c3883e173203449b4840bdbf918619ff81b9ce7bf832378cf0e5e8836848803bf73c3f58d92cdd1461fae9c5ed59d4fe282154e4122f67273635eaa91e96472893dec1d879d5c70e26a13a2c887180c76d0dfd984d11adb9b67311af541009696778bf206850f0e19bb5d248da609151d332632798fcab2d242f60cdd77517018ab2667add8445e081d96118898e8418dbd73dc101d87c9c26f0cea5b951c1eb455558707ad45be3518bbe669c2dc1237e974a2c2c61b0abed9c1b141103c41b8d9dc458718b010db136c55212f46188d0648b30c9beb9c5dd35a637169570c91f1b1c4960dc7f66cbff27530318900727cbeca966222344a2cc56c494c220d2b34b0baa18513f277ee3182e9c30e9985f716aeb2f15cdeb1e91094b7ac0a2670559b28e41d069bdbf51f67ca30b7c44d3b297f8876a4fc2f4c0ae64250b1004e1888a92021a54860b05d190891757b583f7b1ace391863d0e974c5c614b58b470500b14b651d370656446b4b94c508ce89bd1d9591d5b1bfc3d56bb14c3176e9dc42bc243a088a232810b382f8e5a4213a67e1ad38a4d228385c5609710bf9cd9cec186df763439c36cc2d71b92e803f3743fa2c73ece804c2b2fa8d67af78e7d0dd36545b5e4c300b932418f4b7616d85acd30514e042b64ce2c7c1362569088130952d51562546a3017bfa0587e3f2d108f968583b4e8074df95286233ea20e7712ed61f84edb8d18982cbb943168ea329e2c039262b4909a4ad4a6e10b656f469c35c66ce0060fdf82ab64f9de56c9336a2b462dc12e09d93da03c9a405285922592cc8241f9ca5e2418eda701d40585f1639babd4568ad519605aa2247dae9c25625d22c43d6e989adc975b1264990a65c7aa8583459fda5410c877d0c077df47a0ba8ca0a3b3b5b7062ff1271ca168ac7ce6963e2f52a8eaf41499c371c1b8d019a90222000305a434b710eb4ec4f84e1b00f05a02c4b1cbee672749617eabfcf94606e89bb7d6a1debc74f0224031375b8a94c5267b93601a2adecb00981e506868400e4662b1991abb48149ea6a2ce71cca628424edc09804cb2bbb91a662aa20c46a1b29e17a8dbc0bbbe267b6590382ca03c4aa3c1ac2da0aa3d10083fe3648481a880b89f5c6f3c554b1c4b7e5b772b51c57cc29230543dea32c0b78675194390ebce00896f7ee8ed7322d985fe29e5ec7da13272321f9c6d4c4f1ce439b241225aa6b33513f466005adb9a09b892b85db9ac7ac59a9eb25222c2dad607169590e52d7134c222c63476e7cdd1895c7baeb60ae209a3165c9c54245ce26c668344055163290b256e3d0f02083309532c8d28c6b3a12ee7d8880aacce1ac10f78a2358ded712f7bb867c7b88930f1f6b904e8bb24a57ea3db4e1fa5a264ec86a0961054a69212fe4383cb2360cc03486131965594049bc35cb3ad8bbefc29a24f158f1535830febdd1886ae2b2d23657d35819a5283242cc989db5b22c301cec6034dc61bb79380084b8a1d7d05af36809934027624e1160cb122e28ee1547b0b477975cd7f4606e9db324633b6eec26379c31c8b23adbc5373f04f423293c4707c2ee24b15556bd3a22919804deb1335316393b468d737237ae016598cc9a472c84996ff815d4b061afca3efc2ecb64069e60776bcdf5c44c4aae74eb7617b067ef011c3a7c192e3d7a252ebff2c5d8b3ef00b2ac1bd3bfec3cd6f16a4e5ac8c05122b8aa42d6e5a2a269c3dc1297142b2c220939f885405692e54a64867859280c971dc31164ef9aa875ba95bfb37ad78d81eb0b388c5693569c3b5dbf871975c25c0a5c8629ef72767eaf89ca75873591798ba79b23449c74e06bd042e4a3b8e8f051f4161651e439caaa80751ca120cf73443889581008694bdcef2ed28c473734555149780b410199c97ce3b502a49e81e7140d54158287fa00899b86029a66b8ac284651953903c55d2e11cf2966c2a0463133b4bc8c4958318d4cf01186a7cb7b0d696021ddeb9cc47eb93433c4628b6224af612c962f8b1c5599a32c7368adb167ef053878e85294f908a3611f65c9a58e7cbd6cfac8af6f9c7f7a30b7362e007ce34b0f81ac147e4765e254308187d6b0cc6ac96af17e4ab35dcbdd715dd1c52b21044ca1c5410beb78388c14c6281e41bcb8b482acd3456232287196809a0f442435bb8a2bc3880089bd7283a80b85f85d8e1f1b923422a9d50d8da8ee11c2be8d06ac397aa09482b50e1b6ba70105a46906efa414d25bc0281c7de9557ca15386b926ee930f3c8a72980b71837ab133a67520321a37b5f6bc596fc7bb5ec430122ba7d6094c1214526338d891f42c50550596567663797917d2ac53c74b857c4cd87193639280a125d5a40dd729e424c416e0bd97419aec74727d024f35351ceca0d3ed61341c4041411bb9d63483b31506fd6da46986acdb83b3569a372159c870c9b557d6bf7f8a30d7c45d7dec496c9fdd8876e324111578e80df9dad6ad091e8d0828c5a36015587db5d1d04a2349b348da3024c84a49e2f6ce0676edda87a5150e25d53334d6a815b156cad8b0e2885f622236262171d622495314f928dad66591a3d3e921cf8748b30c6551c0398bacd385f75cb1e6a53698a49ec179ceb60dfa3b30c6a0db5b44559548b30eaab2c0ca457b71e0e891c6154f0fe6d6c605e4d785ae534831f6d2420e35be1d8963c292264e5db8e961923cc9be79278ae97d4ce3725c972bad6cc9a309ace52a2c1beb0d08ce13d709945c2f1062c2a3619fbd7ae790e73c262ccf8771184e654b54b68aa4554a314189c7d0010a264d916699981aec78420ad3430a98d3c2fce2f3b17dcb93fe79f49616c7fe9cd384b9266ea7d76b90b6ee6a89b88b8674cf415a9578f28d1e784c11b90087b3525cc0228e9c1cdbd90a5551c07b8b9dad4df4fb5b28f21cc3fe0e06831d94452e4e1457637967e15c2563c0b8520b00babd0510f19cb75cebebd1e974912409b45648d32cf604688ead236e442e8cec2092675760ac6e818b6ea45e41fe36208273f23ba5d0a6bbb2c4eba610734d5c9d727220bc82d2b1a28aed189d9c40d2d09d8e3157e63120893804b2b8a8bce444755d05e71cb24e07bdde02a03854d6e9f490a4293b86e11a88edd234eb20eb74c4169f0c6b49f5975c7b2469a38aaba9a0de3bee1d7857763aa5c6972bc642f55b6d9e8486a9a5fec13987ce4217698727d89b46cc3571f90fdf3415184d3237825e4c92e018c9765cbb5bc74327c9cde3d6b864b0aaaae8146dacaf818867588c2493754df285eb08db4c927392a8de73e42112566a6c2984f0e4a728e21ae07adfba46d73566a1f432cece5a8b3ce71a08e72c765fc4d3b14e2be69ab8d942574af7b8842f9018c1e19a20331aee5bb00d63f44a48e17d180ece0a1b461f38ef784e3293606b6b138b4b4b8092a88193b8ab9792c258ac5e9337bc5bcb45def5fa09328b82d6d9bb60c38ad9d32832e77386ed1abf33ae0f0d80cd12e71cd7fdc263e5c27df297984ecc35717562b0b0778563ab31e4f4f42e976f6c50e09ac46159746e827a4772c8b142b72f498361bf8f2ceb40c9e4d07134b16ba456a5db660729148df3680556ca71132090b40e9f49c3e2cb1a33759abf89c3d0f22fd8f5cd1e451a95b51665c9f34b1cbcec923837c5b462ae890b00072ebb0495b75c38626b0725dcbc806752e0fa06cbcd1712079b708cfc0006831d58290c0fb62293b36e30dc033081103e8f65e0426c3734a640d4e6f9c17d83b4275e2caa2bd717c8cbd72faa1c48dc68a8655144c21b63d05d5ec4dec307e3df615a31f7c4ed2c7471e4ea2b39842463aa82f91089dcb8d13e8c456bdcdcd8cf06958ae497e1e29e271421228c246cc5098a103b0e840bc763fb332a2500908a0328a36f26621f631d24418c4052924940a2cad68e5838004710e477c593d5f3e5d633dc1470dee2d26b5f38e11c4e27e69eb800b0fbc27d78fecb5e0207c2488ab063d7ec6c2441d38c08a00669f97bad7e3e0cc511f27ae7b0b9be86a5e5159e9484f7683402265724593c67a88d6884e7c24422a2ac90627150639b781ddc889ad74532838fc8311087e3d78d8ebc43293164ef3d9e7fddb5531dbb6d62ae33679370d6e1e4e3dfc0996f9ee0f1623a81361a699aca73c858ee547c5453ad3cc19408366190c550564844180e76f0d4f12770d1a1c3585ad9852cebc08469fc63da391e51f61b3f4f0d216d7c97a5424ead9b61b5da24a8437bdc405428d58c715ab1ab65f69af5ad752cefd98dcb5e7c1556f6ee699c7fba715e1137c05b8bb3274ee1ecf113d859df44922448e5e93c7a627c191aa48d9370f8a062f5f82de72c564f9dc27034c025971e45b7b7c8b32426699c613110f4991ac6246a32d6b787afa34e82a03128940538a8b78c628eef0d658e613587c53d2bb8fcfa6be3f16709e725719bc80723ac9f3885cdd36730d8da81064f4b1fc79435aabf823d6b2535aad86507c980c9c71f7b14472ebd14fbf61de0e93c131e21118bc343cdac0af511b5a632eaca3536033cd7078bb911b6a5a68d2b3335364d8170ad1c95e03981d9fce13477dacdb0b47b370ebdf032a4d9f42619be1dce7be236518e726c9d5dc3c689556c9c390bb20e59a7cb8309e5a1231cf09718a87331fef9ada79e449224387ce4522c2daf484598148c47b27a2902e7ee5f4d282a62c4a05ee6c50e16368330990ca96de6b0dc7a8beee222924e8ac59515245986def2223a8b3d24598a34e3079acc325ae23e0b88089bab6bf8ca67ef01397ef49431895454b19a85b8e7f6f636fa3b7d5c7cf830f6edbb00bd8545b69b65e878c3b08d6a89b16e5ec829a600473d84a4c1616cc45b83a95096a598001e977fcf5558deb31b9dc545f496979aa79c4bb4c4fd36d838b58a87eff912caa28c69524e2678146589b2e4c991d996e404c4d2f212961697916429dbc9415f1b43712261a94ee372a88ecd0f5b55a8aa0a9974e37951f0f4f78981b5569c49aebde56b22bcf4076ec0fe8b2f8ad73eef6889fb2c20021efadc7d186e6c8b8dd9e8962561e09c43220f3f71cec3b92aceebe564e024ab669d3af69eb8f83c14d488dd4b20242681d21aa93c1188ed6c79d4a9d8b9a594496a19a5c1e7f358debb1b57ddf0bd73afb4012d719f055bab6b78fc8b0fc48802c06661087f852e9c4b0df9314cec0031a9ead017338984c4b1a05cc9f31ac2d83204d7ac791e267670eeb4e6e79d95322d53b0774371cf652fbd06bb0eec0f3f61aed112f759f0d87d0f60b0b135b64c351e84475292181e724de4e12c9b132172c0247c7aa962341b222199e8ecccf130f3a8c813a968e72c3f013364ec1acf79c81617f0c2975f3776ae79454bdc6740de1fe26bf7dccf5d77f0f14521a39a6a8d2491f90e9ed1432700a29a21f91087a44b4c373c2507f2d49c182e9b3c14c5109973ae266e4cdbda3849f3a52f791196f7cd4e22e1af8a96b8cf80538f3e818d13a7618ccc2d463cf11d4fbf24e3c694820993e629261d496cb77ef158b430f45c293d46ca709cf06d5299f978128410538327f3703c178224449c9549a19d45b6d8c3d1975e3df7aa7b5ed42a3c179027f4d736f801cef29c306312246923b3264f6d548ad72b216692244852796eb0981046cb53cc8392ca10212090b69e3f81ede2da4cd0f179669c94082683d261e210cdd760ea4946f29d01465bfdf11f358768893b817c67086f7d4d1ac8085d3051c27c615ad733d070864d26f450ecac1963c411535046058e4633a176e0820326b66fd81088ef44926553e101833cc486cfcdf3998509f88c49b071e2f4d86f9a47b4c49dc0cefa069432a2743c79864e64a2bb8699a0143fbd5107db37bc827a8a32d6ce19939f8fcb66079b1fcd08035f8392a842f8c2eb83c2ca73c910949baf938f67a01430da1af0834be6182d712730d8d8627ac97ffce0ea9a6004e2c29a7aa398d60d362c3f9e54c25e13e40dc781102f2c8fc76a101451731bc716151f0ba5290d6378e23b6312386b61f372ec77cd1b5ae24ec0592b8f6be2c04030118491ac6a6828618c1288591064535013b18e40348919c92a658ef57ecd78709876b4a1baa2d27c593c115e7000151446fdf9b6735be24ee082e75d8c5c1ecfc4490306934518259f9944122968bc228115932dcca4138e5193795c7dc37bb0afebef0d85550a40dd48d83ee6f7d0783cd1540f2dff4ea025ee04761dd88f8bae3c8aa2909963aa4a1eb9c445da2143465257c045335c7f10bc7e0a2587c2fa66c557481dcb1a79976fb25f48eff2b27a640320f5b5f22f1ca12e617470d621e9a4533d99c777022d719f01171c3984a3d75f03952894c5085599cbcc334eba7b00f2849a6724a9a82d426d6d0c6545fd96efe3664520e7389fb988070d3287bd0832b0528ac3adade035e1e2ab2f1f333be6116d02e2db803c61e3f42ad69f3a85b23f82313cd377b46fa56cd12449acb9052464a5c05dfa985911ba75fe0e3105481217fc0e005cfbcbcb1a63c9646c1a2bac177b9c5015399cafb0b07f05078e1e41d27870cabca225ee5f0244847c30c4f6ea1a465b03e43b7d686578b646c5c4558d182f73af61bb8a5d8be88009f165cc1985910e443c8c5729f8e683a5456d499e47e6e5a990ce5648ba1d2c5eb01bcbfb774fedb4f7e7022d71ff0af0d661d41f60b0b5035f5954a312de5a90e5110ee4a9e19049e14cf81eb364b599a062d962b035c4de0d45e4e4a112cd918654c36429926e8aeef222ba8b0b63c73a5fd012f73b04229ee3c0790f5b96500458e76047fc9851a514c8119ce5c791c649c821462b018a08a4019324483a299452c8167a504621ed64316ad0a2256e8b19c57cbb9e2de6162d715bcc245ae2b69849b4c46d31936889fb5d0011212f0b143242b7c55f1f6d54e11cc27b8f8f7ef20edc7ddf67f0f0138fc268836b2e7f11fede2b5e83d7bff2a6b16d6fbbfdc3f8f2a30fe2bd6fbd0507f75f38b60e003ef6e98fe3939fbf6b6cd9f32eba042fb9f2c578d5df7c257a9d6e5c7ef2cc29fcd26d1f18db3660cfca2e7cf09dff1a00f081dffdb7387ef249bceb4d37e3f2c347c7b6bbffe12fe33fdef1bbb8e986d7e087beff7563eba601ade29e23acae9fc10ffdf48fe2976e7b3f4eadade2efbfe2b578cdf7bd1a5ffbe6e3f8995fff1778e32d3f8ee16818b77fe0d1afe0ae7bff27faa3c1d871021e7bf2ebb8f3debbf1f853c7707a7d15a7d757f1277ff629fcd4afbd0b7fe7adafc3035ffb4adcb63f1ae0ce7befc657bffe50dc36bcce6eacc5edeefdca97f0a7f7dc8db7ff9b9fc1dac67a5c0e00ab6babb8f3debbf1f5e3c7c6964f0b5ae29e23dcf2efff15feefb147f08b6f790ffee8373e8a9f7ff3bbf02fdff2cff13f3ef4dff08e37fc04ee79f03e7cf0f77f7372b7bf10bff0e3efc61fdffa07f8e35bff0077def671fcbb77fd1a46f9086f7dff3bb1b1bd39b6ed9b5ef70fe2b6e1f5e1f7fef6d83600f0f853c7f0b3b7de82613e9a5c5517fe4c195ae29e033cfee4317ce6fecfe295d7bd02ffe8753f86b451f4d2ed74f08e37bc152fbee26adc7ee7c7b0beb931b6ef73c142b7879b6e782ddef34f7e0ea73758819f2bb234c3db7fe42df8df7ffe39bcf759cc8b69444bdc7380478e3d0ae71cbeff65af985c05004812831bffc6cb919705beb57a6272f573c615975c0605852f7ef5feb1e51ffdd4edf8b1f7fce3b1d7e7befc85b16d94026e7ee3dbf0c3af7e3deeb8eb8f70eb477e6b62fd74a6985be29e03ec5a5e01000c474fef7a03b6077d10080b0b0b93ab9e33bc74e7bd6e6f6cf9e10b0fe37baf79d9d86bffeea73f064a2985f7bded17f0f2eff93efcd6edbf833fbcfbbfc775ada9701ee185475f80a5de126ebfeb0f31183eddd93ab5b68a4f7cee4f7170ef011cdc776072f573c6ddf7fd2f1008afbafec6b1e537bce46fe1e637be6dec75e5f3ae18db2660a1dbc387defdabb8fcd051dcf2a1f7e20b0f7e717293a9424bdc73800bf6ecc7cffec37f866f9e3c8e9ff8c0cd78e8d823a8aa0a4551e04b0ffd1ffce4076ec6c6ce267efecdefc6626ffc61216737d6706a6d35be26bdfdcd9dcdb8eee1635fc3fbffd3afe2773ef67bb8fe45d7e155d7df30b6edce6067ec58a7d638b21026e79bc49e5d7bf01f6ef94dec5ade858f7ce2bf4cae9e2ab471dc7304ef3dfef327fe2b7ee5f77e036555e2d0fe8370dee3f4fa2a967a8bf8e5b7ff226ebae1b571fb9ffce59bf1a97b3ecdb33fc6e141c03597bd0877fcfa47f0c1dfbf15b7ddf161a4f24c09c83cbb5a69bcfa6537e2577eea7d58595a06003c76fceb78cddb7e10c618247afc417b0bbd05dcf5db1fc7dedd7bf0833ffda378f49b8fe1e18f8ddbc65f78f08b78f3fbde81413ec0db7fe49fe2e7def4ceb1f5d38096b8e718eb9b1bb8ebbecfe05bab2790188323070fe355d7df18ede080cfdeff793c79faa9b16500b077d75efcddbffd03f8f2230fe2a1638f8cad5be82de065575f878b0f1c1a5bbeb5b38d3ff9ec27c79605a4698ad7df78133a9d0e3ef5f94f6373670b6f78ed0f4f6e863ffbf37b70fcd493b8e6f957e1da175c33b9faff3b5ae2b69849b4366e8b99444bdc16338996b82d66122d715bcc245ae2b69849b4c46d31936889db6226d112b7c54ca2256e8b99444bdc16338996b82d66122d715bcc245ae2b69849b4c46d31936889db6226d112b7c54ca2256e8b99444bdc16338996b82d66122d715bcc245ae2b69849b4c46d31936889db6226d112b7c54ca2256e8b99c4ff0324f7e6f76fb4f5ac0000000049454e44ae426082', 'hex') WHERE UPPER(nome) = 'POLTRONA OLDEN';

COMMIT;