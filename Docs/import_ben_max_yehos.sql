-- ==========================================================================
-- IMPORTAÇÃO DA EDC - BEN MAX YEHOS 1 - 2 - 3 - 4
-- Gerado automaticamente para inserção segura em Produção
-- ==========================================================================

BEGIN TRANSACTION;

-- 1. Garantir NCM 84186999
INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
SELECT '84186999', 'COOLERS / REFRIGERADORES', 0.1260, 0.0975, 0.0210, 0.0965, 0.0260, true
WHERE NOT EXISTS (SELECT 1 FROM edc.ncms WHERE "Codigo" = '84186999');

-- 2. Garantir Produtos e Modelos
-- Produto & Modelo: BAC 51 LR (127V)
INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
SELECT 'BAC 51 LR (127V)', 'BAC 51 LR (127V)', (SELECT "Id" FROM edc.ncms WHERE "Codigo" = '84186999'), 0.0, 0.0, 0.0, 'UN', 269.0, true
WHERE NOT EXISTS (SELECT 1 FROM edc.produtos WHERE "Referencia" = 'BAC 51 LR (127V)');

INSERT INTO edc.modelos ("Codigo", "Nome", "Descricao", "IdProduto", "FlAtivo")
SELECT 'BAC 51 LR (127V)', 'BAC 51 LR (127V)', 'Modelo Padrão - BAC 51 LR (127V)', (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 51 LR (127V)'), true
WHERE NOT EXISTS (SELECT 1 FROM edc.modelos WHERE "Codigo" = 'BAC 51 LR (127V)' AND "IdProduto" = (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 51 LR (127V)'));

-- Produto & Modelo: BAC 51 RL (127V)
INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
SELECT 'BAC 51 RL (127V)', 'BAC 51 RL (127V)', (SELECT "Id" FROM edc.ncms WHERE "Codigo" = '84186999'), 0.0, 0.0, 0.0, 'UN', 269.0, true
WHERE NOT EXISTS (SELECT 1 FROM edc.produtos WHERE "Referencia" = 'BAC 51 RL (127V)');

INSERT INTO edc.modelos ("Codigo", "Nome", "Descricao", "IdProduto", "FlAtivo")
SELECT 'BAC 51 RL (127V)', 'BAC 51 RL (127V)', 'Modelo Padrão - BAC 51 RL (127V)', (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 51 RL (127V)'), true
WHERE NOT EXISTS (SELECT 1 FROM edc.modelos WHERE "Codigo" = 'BAC 51 RL (127V)' AND "IdProduto" = (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 51 RL (127V)'));

-- Produto & Modelo: BAC 209A (220V)
INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
SELECT 'BAC 209A (220V)', 'BAC 209A (220V)', (SELECT "Id" FROM edc.ncms WHERE "Codigo" = '84186999'), 0.0, 0.0, 0.0, 'UN', 456.0, true
WHERE NOT EXISTS (SELECT 1 FROM edc.produtos WHERE "Referencia" = 'BAC 209A (220V)');

INSERT INTO edc.modelos ("Codigo", "Nome", "Descricao", "IdProduto", "FlAtivo")
SELECT 'BAC 209A (220V)', 'BAC 209A (220V)', 'Modelo Padrão - BAC 209A (220V)', (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 209A (220V)'), true
WHERE NOT EXISTS (SELECT 1 FROM edc.modelos WHERE "Codigo" = 'BAC 209A (220V)' AND "IdProduto" = (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 209A (220V)'));

-- Produto & Modelo: BAC 209 (127V)
INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
SELECT 'BAC 209 (127V)', 'BAC 209 (127V)', (SELECT "Id" FROM edc.ncms WHERE "Codigo" = '84186999'), 0.0, 0.0, 0.0, 'UN', 456.0, true
WHERE NOT EXISTS (SELECT 1 FROM edc.produtos WHERE "Referencia" = 'BAC 209 (127V)');

INSERT INTO edc.modelos ("Codigo", "Nome", "Descricao", "IdProduto", "FlAtivo")
SELECT 'BAC 209 (127V)', 'BAC 209 (127V)', 'Modelo Padrão - BAC 209 (127V)', (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 209 (127V)'), true
WHERE NOT EXISTS (SELECT 1 FROM edc.modelos WHERE "Codigo" = 'BAC 209 (127V)' AND "IdProduto" = (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 209 (127V)'));

-- Produto & Modelo: BAC 218SA (220V)
INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
SELECT 'BAC 218SA (220V)', 'BAC 218SA (220V)', (SELECT "Id" FROM edc.ncms WHERE "Codigo" = '84186999'), 0.0, 0.0, 0.0, 'UN', 823.0, true
WHERE NOT EXISTS (SELECT 1 FROM edc.produtos WHERE "Referencia" = 'BAC 218SA (220V)');

INSERT INTO edc.modelos ("Codigo", "Nome", "Descricao", "IdProduto", "FlAtivo")
SELECT 'BAC 218SA (220V)', 'BAC 218SA (220V)', 'Modelo Padrão - BAC 218SA (220V)', (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 218SA (220V)'), true
WHERE NOT EXISTS (SELECT 1 FROM edc.modelos WHERE "Codigo" = 'BAC 218SA (220V)' AND "IdProduto" = (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 218SA (220V)'));

-- Produto & Modelo: BAC 218BA (220V)
INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
SELECT 'BAC 218BA (220V)', 'BAC 218BA (220V)', (SELECT "Id" FROM edc.ncms WHERE "Codigo" = '84186999'), 0.0, 0.0, 0.0, 'UN', 818.0, true
WHERE NOT EXISTS (SELECT 1 FROM edc.produtos WHERE "Referencia" = 'BAC 218BA (220V)');

INSERT INTO edc.modelos ("Codigo", "Nome", "Descricao", "IdProduto", "FlAtivo")
SELECT 'BAC 218BA (220V)', 'BAC 218BA (220V)', 'Modelo Padrão - BAC 218BA (220V)', (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 218BA (220V)'), true
WHERE NOT EXISTS (SELECT 1 FROM edc.modelos WHERE "Codigo" = 'BAC 218BA (220V)' AND "IdProduto" = (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 218BA (220V)'));

-- Produto & Modelo: BAC 28 (127V)
INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
SELECT 'BAC 28 (127V)', 'BAC 28 (127V)', (SELECT "Id" FROM edc.ncms WHERE "Codigo" = '84186999'), 0.0, 0.0, 0.0, 'UN', 234.0, true
WHERE NOT EXISTS (SELECT 1 FROM edc.produtos WHERE "Referencia" = 'BAC 28 (127V)');

INSERT INTO edc.modelos ("Codigo", "Nome", "Descricao", "IdProduto", "FlAtivo")
SELECT 'BAC 28 (127V)', 'BAC 28 (127V)', 'Modelo Padrão - BAC 28 (127V)', (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 28 (127V)'), true
WHERE NOT EXISTS (SELECT 1 FROM edc.modelos WHERE "Codigo" = 'BAC 28 (127V)' AND "IdProduto" = (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 28 (127V)'));

-- Produto & Modelo: BAC 28A (220V)
INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
SELECT 'BAC 28A (220V)', 'BAC 28A (220V)', (SELECT "Id" FROM edc.ncms WHERE "Codigo" = '84186999'), 0.0, 0.0, 0.0, 'UN', 234.0, true
WHERE NOT EXISTS (SELECT 1 FROM edc.produtos WHERE "Referencia" = 'BAC 28A (220V)');

INSERT INTO edc.modelos ("Codigo", "Nome", "Descricao", "IdProduto", "FlAtivo")
SELECT 'BAC 28A (220V)', 'BAC 28A (220V)', 'Modelo Padrão - BAC 28A (220V)', (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 28A (220V)'), true
WHERE NOT EXISTS (SELECT 1 FROM edc.modelos WHERE "Codigo" = 'BAC 28A (220V)' AND "IdProduto" = (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 28A (220V)'));

-- Produto & Modelo: BAC 120A (220V)
INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
SELECT 'BAC 120A (220V)', 'BAC 120A (220V)', (SELECT "Id" FROM edc.ncms WHERE "Codigo" = '84186999'), 0.0, 0.0, 0.0, 'UN', 332.0, true
WHERE NOT EXISTS (SELECT 1 FROM edc.produtos WHERE "Referencia" = 'BAC 120A (220V)');

INSERT INTO edc.modelos ("Codigo", "Nome", "Descricao", "IdProduto", "FlAtivo")
SELECT 'BAC 120A (220V)', 'BAC 120A (220V)', 'Modelo Padrão - BAC 120A (220V)', (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 120A (220V)'), true
WHERE NOT EXISTS (SELECT 1 FROM edc.modelos WHERE "Codigo" = 'BAC 120A (220V)' AND "IdProduto" = (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 120A (220V)'));

-- Produto & Modelo: BAC 120 (127V)
INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
SELECT 'BAC 120 (127V)', 'BAC 120 (127V)', (SELECT "Id" FROM edc.ncms WHERE "Codigo" = '84186999'), 0.0, 0.0, 0.0, 'UN', 332.0, true
WHERE NOT EXISTS (SELECT 1 FROM edc.produtos WHERE "Referencia" = 'BAC 120 (127V)');

INSERT INTO edc.modelos ("Codigo", "Nome", "Descricao", "IdProduto", "FlAtivo")
SELECT 'BAC 120 (127V)', 'BAC 120 (127V)', 'Modelo Padrão - BAC 120 (127V)', (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 120 (127V)'), true
WHERE NOT EXISTS (SELECT 1 FROM edc.modelos WHERE "Codigo" = 'BAC 120 (127V)' AND "IdProduto" = (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 120 (127V)'));

-- Produto & Modelo: BAC111 (220V)
INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
SELECT 'BAC111 (220V)', 'BAC111 (220V)', (SELECT "Id" FROM edc.ncms WHERE "Codigo" = '84186999'), 0.0, 0.0, 0.0, 'UN', 730.0, true
WHERE NOT EXISTS (SELECT 1 FROM edc.produtos WHERE "Referencia" = 'BAC111 (220V)');

INSERT INTO edc.modelos ("Codigo", "Nome", "Descricao", "IdProduto", "FlAtivo")
SELECT 'BAC111 (220V)', 'BAC111 (220V)', 'Modelo Padrão - BAC111 (220V)', (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC111 (220V)'), true
WHERE NOT EXISTS (SELECT 1 FROM edc.modelos WHERE "Codigo" = 'BAC111 (220V)' AND "IdProduto" = (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC111 (220V)'));

-- Produto & Modelo: BEC 100GD (127V)
INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
SELECT 'BEC 100GD (127V)', 'BEC 100GD (127V)', (SELECT "Id" FROM edc.ncms WHERE "Codigo" = '84186999'), 0.0, 0.0, 0.0, 'UN', 240.0, true
WHERE NOT EXISTS (SELECT 1 FROM edc.produtos WHERE "Referencia" = 'BEC 100GD (127V)');

INSERT INTO edc.modelos ("Codigo", "Nome", "Descricao", "IdProduto", "FlAtivo")
SELECT 'BEC 100GD (127V)', 'BEC 100GD (127V)', 'Modelo Padrão - BEC 100GD (127V)', (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BEC 100GD (127V)'), true
WHERE NOT EXISTS (SELECT 1 FROM edc.modelos WHERE "Codigo" = 'BEC 100GD (127V)' AND "IdProduto" = (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BEC 100GD (127V)'));

-- Produto & Modelo: BEC 100GDA (220V)
INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
SELECT 'BEC 100GDA (220V)', 'BEC 100GDA (220V)', (SELECT "Id" FROM edc.ncms WHERE "Codigo" = '84186999'), 0.0, 0.0, 0.0, 'UN', 240.0, true
WHERE NOT EXISTS (SELECT 1 FROM edc.produtos WHERE "Referencia" = 'BEC 100GDA (220V)');

INSERT INTO edc.modelos ("Codigo", "Nome", "Descricao", "IdProduto", "FlAtivo")
SELECT 'BEC 100GDA (220V)', 'BEC 100GDA (220V)', 'Modelo Padrão - BEC 100GDA (220V)', (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BEC 100GDA (220V)'), true
WHERE NOT EXISTS (SELECT 1 FROM edc.modelos WHERE "Codigo" = 'BEC 100GDA (220V)' AND "IdProduto" = (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BEC 100GDA (220V)'));

-- Produto & Modelo: BEC 100SD (127V)
INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
SELECT 'BEC 100SD (127V)', 'BEC 100SD (127V)', (SELECT "Id" FROM edc.ncms WHERE "Codigo" = '84186999'), 0.0, 0.0, 0.0, 'UN', 243.0, true
WHERE NOT EXISTS (SELECT 1 FROM edc.produtos WHERE "Referencia" = 'BEC 100SD (127V)');

INSERT INTO edc.modelos ("Codigo", "Nome", "Descricao", "IdProduto", "FlAtivo")
SELECT 'BEC 100SD (127V)', 'BEC 100SD (127V)', 'Modelo Padrão - BEC 100SD (127V)', (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BEC 100SD (127V)'), true
WHERE NOT EXISTS (SELECT 1 FROM edc.modelos WHERE "Codigo" = 'BEC 100SD (127V)' AND "IdProduto" = (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BEC 100SD (127V)'));

-- Produto & Modelo: UCH50BA (220V)
INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
SELECT 'UCH50BA (220V)', 'UCH50BA (220V)', (SELECT "Id" FROM edc.ncms WHERE "Codigo" = '84186999'), 0.0, 0.0, 0.0, 'UN', 113.0, true
WHERE NOT EXISTS (SELECT 1 FROM edc.produtos WHERE "Referencia" = 'UCH50BA (220V)');

INSERT INTO edc.modelos ("Codigo", "Nome", "Descricao", "IdProduto", "FlAtivo")
SELECT 'UCH50BA (220V)', 'UCH50BA (220V)', 'Modelo Padrão - UCH50BA (220V)', (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'UCH50BA (220V)'), true
WHERE NOT EXISTS (SELECT 1 FROM edc.modelos WHERE "Codigo" = 'UCH50BA (220V)' AND "IdProduto" = (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'UCH50BA (220V)'));

-- Produto & Modelo: UCH150SA (220V)
INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
SELECT 'UCH150SA (220V)', 'UCH150SA (220V)', (SELECT "Id" FROM edc.ncms WHERE "Codigo" = '84186999'), 0.0, 0.0, 0.0, 'UN', 339.0, true
WHERE NOT EXISTS (SELECT 1 FROM edc.produtos WHERE "Referencia" = 'UCH150SA (220V)');

INSERT INTO edc.modelos ("Codigo", "Nome", "Descricao", "IdProduto", "FlAtivo")
SELECT 'UCH150SA (220V)', 'UCH150SA (220V)', 'Modelo Padrão - UCH150SA (220V)', (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'UCH150SA (220V)'), true
WHERE NOT EXISTS (SELECT 1 FROM edc.modelos WHERE "Codigo" = 'UCH150SA (220V)' AND "IdProduto" = (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'UCH150SA (220V)'));

-- Produto & Modelo: BEC 100SDA (220V)
INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
SELECT 'BEC 100SDA (220V)', 'BEC 100SDA (220V)', (SELECT "Id" FROM edc.ncms WHERE "Codigo" = '84186999'), 0.0, 0.0, 0.0, 'UN', 243.0, true
WHERE NOT EXISTS (SELECT 1 FROM edc.produtos WHERE "Referencia" = 'BEC 100SDA (220V)');

INSERT INTO edc.modelos ("Codigo", "Nome", "Descricao", "IdProduto", "FlAtivo")
SELECT 'BEC 100SDA (220V)', 'BEC 100SDA (220V)', 'Modelo Padrão - BEC 100SDA (220V)', (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BEC 100SDA (220V)'), true
WHERE NOT EXISTS (SELECT 1 FROM edc.modelos WHERE "Codigo" = 'BEC 100SDA (220V)' AND "IdProduto" = (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BEC 100SDA (220V)'));

-- Produto & Modelo: SPARE PARTS
INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
SELECT 'SPARE PARTS', 'SPARE PARTS', (SELECT "Id" FROM edc.ncms WHERE "Codigo" = '84186999'), 0.0, 0.0, 0.0, 'UN', 95.0, true
WHERE NOT EXISTS (SELECT 1 FROM edc.produtos WHERE "Referencia" = 'SPARE PARTS');

INSERT INTO edc.modelos ("Codigo", "Nome", "Descricao", "IdProduto", "FlAtivo")
SELECT 'SPARE PARTS', 'SPARE PARTS', 'Modelo Padrão - SPARE PARTS', (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'SPARE PARTS'), true
WHERE NOT EXISTS (SELECT 1 FROM edc.modelos WHERE "Codigo" = 'SPARE PARTS' AND "IdProduto" = (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'SPARE PARTS'));

-- Produto & Modelo: SPARE PARTS
INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
SELECT 'SPARE PARTS', 'SPARE PARTS', (SELECT "Id" FROM edc.ncms WHERE "Codigo" = '84186999'), 0.0, 0.0, 0.0, 'UN', 99.0, true
WHERE NOT EXISTS (SELECT 1 FROM edc.produtos WHERE "Referencia" = 'SPARE PARTS');

INSERT INTO edc.modelos ("Codigo", "Nome", "Descricao", "IdProduto", "FlAtivo")
SELECT 'SPARE PARTS', 'SPARE PARTS', 'Modelo Padrão - SPARE PARTS', (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'SPARE PARTS'), true
WHERE NOT EXISTS (SELECT 1 FROM edc.modelos WHERE "Codigo" = 'SPARE PARTS' AND "IdProduto" = (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'SPARE PARTS'));


-- 3. Inserir Simulação, Itens e Despesas em bloco
WITH insert_sim AS (
    INSERT INTO edc.simulacoes (
        "NumeroReferencia", "DataEstudo", "IdImportador", "IdExportador", 
        "IdPortoOrigem", "IdPortoDestino", "CotacaoDolar", "SpreadCambio", 
        "TipoFrete", "ValorFreteInternacional", "ValorSeguroInternacional", "Status", 
        "ComissaoPercentual", "FlExibirComissao", "FlSimularSubfaturamento", 
        "MetodoCalculoFederais", "MetodoCalculoIcms", "PercentualSubfaturamento", "ModalidadeFrete"
    )
    VALUES (
        'EDC - BEN MAX YEHOS 1 - 2 - 3 - 4', 
        '2025-11-26 00:00:00'::timestamp, 
        (SELECT "Id" FROM edc.importadores WHERE "RazaoSocial" = 'BENMAX IMPORTACAO E EXPORTACAO LTDA' LIMIT 1), 
        (SELECT "Id" FROM edc.exportadores WHERE "Nome" = 'CHANGSHU LINGKE' LIMIT 1), 
        2, 6, 5.3797, 0.00, 'FOB', 10660.00, 0.00, 'Rascunho', 
        0.0000, false, false, 'SimplificadoExcel', 'SimplificadoExcel', 100.00, '4x40HC'
    ) RETURNING "Id"
),
insert_items AS (
    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", 
        "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal", "IdModelo", "ValorFobSubfaturado"
    )
    VALUES
        ((SELECT "Id" FROM insert_sim), (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 51 LR (127V)' LIMIT 1), 75.0, 269.0, 0.0, 0.0, 0.0, (SELECT "Id" FROM edc.modelos WHERE "Codigo" = 'BAC 51 LR (127V)' LIMIT 1), 134.5),
        ((SELECT "Id" FROM insert_sim), (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 51 RL (127V)' LIMIT 1), 50.0, 269.0, 0.0, 0.0, 0.0, (SELECT "Id" FROM edc.modelos WHERE "Codigo" = 'BAC 51 RL (127V)' LIMIT 1), NULL),
        ((SELECT "Id" FROM insert_sim), (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 209A (220V)' LIMIT 1), 20.0, 456.0, 0.0, 0.0, 0.0, (SELECT "Id" FROM edc.modelos WHERE "Codigo" = 'BAC 209A (220V)' LIMIT 1), NULL),
        ((SELECT "Id" FROM insert_sim), (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 209 (127V)' LIMIT 1), 34.0, 456.0, 0.0, 0.0, 0.0, (SELECT "Id" FROM edc.modelos WHERE "Codigo" = 'BAC 209 (127V)' LIMIT 1), NULL),
        ((SELECT "Id" FROM insert_sim), (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 218SA (220V)' LIMIT 1), 15.0, 823.0, 0.0, 0.0, 0.0, (SELECT "Id" FROM edc.modelos WHERE "Codigo" = 'BAC 218SA (220V)' LIMIT 1), NULL),
        ((SELECT "Id" FROM insert_sim), (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 218BA (220V)' LIMIT 1), 12.0, 818.0, 0.0, 0.0, 0.0, (SELECT "Id" FROM edc.modelos WHERE "Codigo" = 'BAC 218BA (220V)' LIMIT 1), NULL),
        ((SELECT "Id" FROM insert_sim), (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 28 (127V)' LIMIT 1), 40.0, 234.0, 0.0, 0.0, 0.0, (SELECT "Id" FROM edc.modelos WHERE "Codigo" = 'BAC 28 (127V)' LIMIT 1), NULL),
        ((SELECT "Id" FROM insert_sim), (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 28A (220V)' LIMIT 1), 20.0, 234.0, 0.0, 0.0, 0.0, (SELECT "Id" FROM edc.modelos WHERE "Codigo" = 'BAC 28A (220V)' LIMIT 1), NULL),
        ((SELECT "Id" FROM insert_sim), (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 120A (220V)' LIMIT 1), 20.0, 332.0, 0.0, 0.0, 0.0, (SELECT "Id" FROM edc.modelos WHERE "Codigo" = 'BAC 120A (220V)' LIMIT 1), NULL),
        ((SELECT "Id" FROM insert_sim), (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC 120 (127V)' LIMIT 1), 34.0, 332.0, 0.0, 0.0, 0.0, (SELECT "Id" FROM edc.modelos WHERE "Codigo" = 'BAC 120 (127V)' LIMIT 1), NULL),
        ((SELECT "Id" FROM insert_sim), (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BAC111 (220V)' LIMIT 1), 14.0, 730.0, 0.0, 0.0, 0.0, (SELECT "Id" FROM edc.modelos WHERE "Codigo" = 'BAC111 (220V)' LIMIT 1), NULL),
        ((SELECT "Id" FROM insert_sim), (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BEC 100GD (127V)' LIMIT 1), 45.0, 240.0, 0.0, 0.0, 0.0, (SELECT "Id" FROM edc.modelos WHERE "Codigo" = 'BEC 100GD (127V)' LIMIT 1), NULL),
        ((SELECT "Id" FROM insert_sim), (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BEC 100GDA (220V)' LIMIT 1), 20.0, 240.0, 0.0, 0.0, 0.0, (SELECT "Id" FROM edc.modelos WHERE "Codigo" = 'BEC 100GDA (220V)' LIMIT 1), NULL),
        ((SELECT "Id" FROM insert_sim), (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BEC 100SD (127V)' LIMIT 1), 36.0, 243.0, 0.0, 0.0, 0.0, (SELECT "Id" FROM edc.modelos WHERE "Codigo" = 'BEC 100SD (127V)' LIMIT 1), NULL),
        ((SELECT "Id" FROM insert_sim), (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'UCH50BA (220V)' LIMIT 1), 5.0, 113.0, 0.0, 0.0, 0.0, (SELECT "Id" FROM edc.modelos WHERE "Codigo" = 'UCH50BA (220V)' LIMIT 1), NULL),
        ((SELECT "Id" FROM insert_sim), (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'UCH150SA (220V)' LIMIT 1), 2.0, 339.0, 0.0, 0.0, 0.0, (SELECT "Id" FROM edc.modelos WHERE "Codigo" = 'UCH150SA (220V)' LIMIT 1), NULL),
        ((SELECT "Id" FROM insert_sim), (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'BEC 100SDA (220V)' LIMIT 1), 13.0, 243.0, 0.0, 0.0, 0.0, (SELECT "Id" FROM edc.modelos WHERE "Codigo" = 'BEC 100SDA (220V)' LIMIT 1), NULL),
        ((SELECT "Id" FROM insert_sim), (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'SPARE PARTS' LIMIT 1), 5.0, 95.0, 0.0, 0.0, 0.0, (SELECT "Id" FROM edc.modelos WHERE "Codigo" = 'SPARE PARTS' LIMIT 1), NULL),
        ((SELECT "Id" FROM insert_sim), (SELECT "Id" FROM edc.produtos WHERE "Referencia" = 'SPARE PARTS' LIMIT 1), 2.0, 99.0, 0.0, 0.0, 0.0, (SELECT "Id" FROM edc.modelos WHERE "Codigo" = 'SPARE PARTS' LIMIT 1), NULL)
)
INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio", "Ordem")
VALUES 
    ((SELECT "Id" FROM insert_sim), 'TAXA SISCOMEX', 224.00, 'BRL', 'Quantidade', 0),
    ((SELECT "Id" FROM insert_sim), 'ANUENCIA DE LI', 107.06, 'BRL', 'Quantidade', 1),
    ((SELECT "Id" FROM insert_sim), 'DIFERENÇA DO VALOR DO FRETE', 11657.97, 'BRL', 'Quantidade', 2),
    ((SELECT "Id" FROM insert_sim), 'LICENÇA DE IMPORTAÇÃO', 130.00, 'BRL', 'Quantidade', 3),
    ((SELECT "Id" FROM insert_sim), 'AFRMM', 8.00, 'BRL', 'Quantidade', 4),
    ((SELECT "Id" FROM insert_sim), 'ARMAZENAGEM', 24000.00, 'BRL', 'Quantidade', 5),
    ((SELECT "Id" FROM insert_sim), 'FRETE RODOVIÁRIO', 12200.00, 'BRL', 'Quantidade', 6),
    ((SELECT "Id" FROM insert_sim), 'DESEMBARAÇO ADUANEIRO', 1390.00, 'BRL', 'Quantidade', 7);

COMMIT;