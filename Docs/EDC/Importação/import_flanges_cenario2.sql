-- SCRIPT DE IMPORTAÇÃO - EDC - FLANGES - CENÁRIO 2 - CORRIGIDO (1).xlsx
-- ESTUDO DE REFERÊNCIA: SECAMAQ-FLANGES-CENARIO-2
-- GERADO AUTOMATICAMENTE PARA O SISTEMA PI

DO $$ 
DECLARE 
    v_importador_id INTEGER;
    v_exportador_id INTEGER;
    v_porto_origem_id INTEGER;
    v_porto_destino_id INTEGER;
    v_ncm_id INTEGER;
    v_produto_id INTEGER;
    v_simulacao_id INTEGER;
BEGIN 
    -- 1. Importador
    SELECT "Id" INTO v_importador_id FROM edc.importadores WHERE "RazaoSocial" = 'SECAMAQ';
    IF v_importador_id IS NULL THEN
        INSERT INTO edc.importadores ("RazaoSocial", "Cnpj", "UF", "RegimeTributario", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('SECAMAQ', '00.000.000/0001-00', 'PR', 'Lucro Real', 0.06, true)
        RETURNING "Id" INTO v_importador_id;
    END IF;

    -- 2. Exportador
    SELECT "Id" INTO v_exportador_id FROM edc.exportadores WHERE "Nome" = 'Flanges e conexões soldaveis';
    IF v_exportador_id IS NULL THEN
        INSERT INTO edc.exportadores ("Nome", "Pais", "FlAtivo", "Incoterm")
        VALUES ('Flanges e conexões soldaveis', 'CHINA', true, 'FOB')
        RETURNING "Id" INTO v_exportador_id;
    END IF;

    -- 3. Portos
    SELECT "Id" INTO v_porto_origem_id FROM edc.portos WHERE "Nome" ILIKE '%TIANJIN%' OR "Sigla" = 'TIA';
    IF v_porto_origem_id IS NULL THEN
        INSERT INTO edc.portos ("Nome", "Sigla", "Pais", "Tipo")
        VALUES ('TIANJIN', 'TIA', 'CHINA', 'Maritimo')
        RETURNING "Id" INTO v_porto_origem_id;
    END IF;

    SELECT "Id" INTO v_porto_destino_id FROM edc.portos WHERE "Nome" ILIKE '%PARANAGUÁ%' OR "Sigla" = 'PAR';
    IF v_porto_destino_id IS NULL THEN
        INSERT INTO edc.portos ("Nome", "Sigla", "Pais", "Tipo")
        VALUES ('PARANAGUÁ', 'PAR', 'BRASIL', 'Maritimo')
        RETURNING "Id" INTO v_porto_destino_id;
    END IF;

    -- 4. Excluir simulação anterior de mesma referência se houver
    DELETE FROM edc.simulacoes WHERE "NumeroReferencia" = 'SECAMAQ-FLANGES-CENARIO-2';

    -- 5. Criar Simulação
    INSERT INTO edc.simulacoes (
        "NumeroReferencia", "DataEstudo", "IdImportador", "IdExportador", "IdPortoOrigem", "IdPortoDestino",
        "CotacaoDolar", "SpreadCambio", "TipoFrete", "ModalidadeFrete", "ValorFreteInternacional", "ValorSeguroInternacional",
        "ComissaoPercentual", "FlExibirComissao", "FlSimularSubfaturamento", "PercentualSubfaturamento",
        "MetodoCalculoIcms", "MetodoCalculoFederais", "Status"
    ) VALUES (
        'SECAMAQ-FLANGES-CENARIO-2', '2026-07-30 00:00:00', v_importador_id, v_exportador_id, v_porto_origem_id, v_porto_destino_id,
        5.14, 0.000000, 'FOB', '1x40HC', 18778.21, 0,
        0.000000, false, false, 50,
        'SimplificadoExcel', 'SimplificadoExcel', 'Aprovado'
    ) RETURNING "Id" INTO v_simulacao_id;

    -- 6. Itens e Ncms
    -- Item: CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 6"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 6"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 6"', 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 6"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 7.480000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 20.000000, 7.480000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 8"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 8"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 8"', 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 8"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 12.880000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 25.000000, 12.880000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 2"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 2"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 2"', 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 2"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.860000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 300.000000, 0.860000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 3"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 3"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 3"', 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 3"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 2.700000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 2.700000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 4"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 4"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 4"', 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 4"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 4.910000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 4.910000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 5"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 5"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 5"', 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 5"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 8.380000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 20.000000, 8.380000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 6"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 6"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 6"', 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 6"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 12.470000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 12.470000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 2"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 2"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 2"', 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 2"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.420000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 200.000000, 0.420000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 4"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 4"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 4"', 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 4"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.840000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 100.000000, 1.840000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 8''
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 8''';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 8''', 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 8''', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 7.570000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 80.000000, 7.570000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 1"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 1"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 1"', 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 1"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.200000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 250.000000, 0.200000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 1.1/2
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 1.1/2';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 1.1/2', 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 1.1/2', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.400000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 500.000000, 0.400000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 2"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 2"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 2"', 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 2"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.630000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 1000.000000, 0.630000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 3"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 3"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 3"', 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 3"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.640000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 300.000000, 1.640000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 4"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 4"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 4"', 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 4"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 3.030000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 75.000000, 3.030000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 5"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 5"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 5"', 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 5"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 4.870000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 150.000000, 4.870000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 6"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 6"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 6"', 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 6"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 7.320000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 200.000000, 7.320000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 8"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 8"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 8"', 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 8"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 13.900000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 13.900000, NULL, 0.0, 0.0, 0.0);

    -- Item: REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 40 8" X 6"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 40 8" X 6"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 40 8" X 6"', 'REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 40 8" X 6"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 5.010000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 60.000000, 5.010000, NULL, 0.0, 0.0, 0.0);

    -- Item: REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 40 3" X 2"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 40 3" X 2"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 40 3" X 2"', 'REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 40 3" X 2"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.000000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 1.000000, NULL, 0.0, 0.0, 0.0);

    -- Item: REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 40 2" X 1.1/2"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 40 2" X 1.1/2"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 40 2" X 1.1/2"', 'REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 40 2" X 1.1/2"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.470000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 120.000000, 0.470000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 1
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 1';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 1', 'FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 1', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.010000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 1.010000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 2"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 2"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 2"', 'FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 2"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 2.130000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 15.000000, 2.130000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 3"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 3"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 3"', 'FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 3"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 3.860000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 3.860000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 5"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 5"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 5"', 'FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 5"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 7.100000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 100.000000, 7.100000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 6"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 6"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 6"', 'FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 6"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 9.540000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 200.000000, 9.540000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 8"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 8"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 8"', 'FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 8"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 15.630000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 15.630000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 1/2" PLATE
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 1/2" PLATE';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 1/2" PLATE', 'FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 1/2" PLATE', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.750000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 25.000000, 0.750000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 3/4"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 3/4"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 3/4"', 'FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 3/4"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.890000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 0.890000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 1"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 1"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 1"', 'FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 1"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.990000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 200.000000, 0.990000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 1.1/2"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 1.1/2"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 1.1/2"', 'FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 1.1/2"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.480000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 300.000000, 1.480000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 2"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 2"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 2"', 'FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 2"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.970000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 800.000000, 1.970000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 2.1/2"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 2.1/2"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 2.1/2"', 'FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 2.1/2"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 3.150000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 60.000000, 3.150000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 3"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 3"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 3"', 'FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 3"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 3.550000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 3.550000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 4"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 4"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 4"', 'FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 4"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 4.930000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 60.000000, 4.930000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 5"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 5"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 5"', 'FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 5"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 5.910000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 80.000000, 5.910000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 6"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 6"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 6"', 'FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 6"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 6.900000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 100.000000, 6.900000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 8"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 8"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 8"', 'FLANGE LISO ASTM A105 GR WPB B16.5 150 LBS 8"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 10.440000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 10.440000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 1/2"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 1/2"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 1/2"', 'FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 1/2"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.420000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 1.420000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 4"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 4"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 4"', 'FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 4"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 9.940000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 9.940000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 6"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 6"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 6"', 'FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 6"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 17.860000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 35.000000, 17.860000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 8"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 8"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 8"', 'FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 8"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 29.420000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 45.000000, 29.420000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 3/4""
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 3/4""';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 3/4""', 'FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 3/4""', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.480000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 20.000000, 1.480000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 1.1/2"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 1.1/2"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 1.1/2"', 'FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 1.1/2"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 2.760000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 20.000000, 2.760000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 2"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 2"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 2"', 'FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 2"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 3.150000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 100.000000, 3.150000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 4"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 4"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 4"', 'FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 4"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 8.470000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 20.000000, 8.470000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 6"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 6"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 6"', 'FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 6"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 15.760000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 40.000000, 15.760000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 8"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 8"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 8"', 'FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 8"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 25.610000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 20.000000, 25.610000, NULL, 0.0, 0.0, 0.0);

    -- Item: TEE 6" SCH-40 ASTM A-234 ASME B16.9
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'TEE 6" SCH-40 ASTM A-234 ASME B16.9';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('TEE 6" SCH-40 ASTM A-234 ASME B16.9', 'TEE 6" SCH-40 ASTM A-234 ASME B16.9', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 8.790000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 40.000000, 8.790000, NULL, 0.0, 0.0, 0.0);

    -- Item: TEE 3" SCH-40 ASTM A-234 ASME B16.9
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'TEE 3" SCH-40 ASTM A-234 ASME B16.9';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('TEE 3" SCH-40 ASTM A-234 ASME B16.9', 'TEE 3" SCH-40 ASTM A-234 ASME B16.9', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 2.600000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 2.600000, NULL, 0.0, 0.0, 0.0);

    -- Item: TEE 2" SCH-40 ASTM A-234 ASME B16.9
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'TEE 2" SCH-40 ASTM A-234 ASME B16.9';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('TEE 2" SCH-40 ASTM A-234 ASME B16.9', 'TEE 2" SCH-40 ASTM A-234 ASME B16.9', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.120000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 60.000000, 1.120000, NULL, 0.0, 0.0, 0.0);

    -- Item: TEE 1.1/2" SCH-40 ASTM A-234 ASME B16.9
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'TEE 1.1/2" SCH-40 ASTM A-234 ASME B16.9';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('TEE 1.1/2" SCH-40 ASTM A-234 ASME B16.9', 'TEE 1.1/2" SCH-40 ASTM A-234 ASME B16.9', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.920000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 60.000000, 0.920000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 1.1/2"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 1.1/2"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 1.1/2"', 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 1.1/2"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.530000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 100.000000, 0.530000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 1"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 1"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 1"', 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 1"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.290000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 75.000000, 0.290000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 8"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 8"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 8"', 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 8"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 23.510000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 10.000000, 23.510000, NULL, 0.0, 0.0, 0.0);

    -- Item: REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 40 1.1/2" X 1"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 40 1.1/2" X 1"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 40 1.1/2" X 1"', 'REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 40 1.1/2" X 1"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.370000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 40.000000, 0.370000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 2''
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 2''';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 2''', 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 2''', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.570000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 0.570000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 3''
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 3''';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 3''', 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 3''', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.640000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 1.640000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 4''
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 4''';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 4''', 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 4''', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 2.940000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 2.940000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 10"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 10"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 10"', 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 10"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 25.360000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 10.000000, 25.360000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 1"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 1"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 1"', 'FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 1"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 2.030000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 20.000000, 2.030000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 2"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 2"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 2"', 'FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 2"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 3.040000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 20.000000, 3.040000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 1" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 1" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 1" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF', 'FLANGE 1" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.990000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 40.000000, 0.990000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 1" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 1" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 1" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF', 'FLANGE 1" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.580000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 40.000000, 1.580000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 1.1/2" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 1.1/2" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 1.1/2" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF', 'FLANGE 1.1/2" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.480000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 100.000000, 1.480000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 1.1/2" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 1.1/2" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 1.1/2" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF', 'FLANGE 1.1/2" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 2.760000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 2.760000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 1.1/4" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 1.1/4" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 1.1/4" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF', 'FLANGE 1.1/4" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.380000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 1.380000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 2" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 2" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 2" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF', 'FLANGE 2" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.970000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 250.000000, 1.970000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 2" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 2" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 2" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF', 'FLANGE 2" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 3.150000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 80.000000, 3.150000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 2.1/2" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 2.1/2" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 2.1/2" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF', 'FLANGE 2.1/2" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 3.150000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 3.150000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 2.1/2" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 2.1/2" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 2.1/2" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF', 'FLANGE 2.1/2" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 4.140000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 4.140000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 3" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 3" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 3" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF', 'FLANGE 3" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 3.550000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 3.550000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 4" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 4" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 4" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF', 'FLANGE 4" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 4.930000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 4.930000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 5" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 5" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 5" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF', 'FLANGE 5" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 5.910000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 80.000000, 5.910000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 6" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 6" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 6" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF', 'FLANGE 6" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 6.900000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 80.000000, 6.900000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 6" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 6" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 6" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF', 'FLANGE 6" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 15.760000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 15.760000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 8" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 8" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 8" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF', 'FLANGE 8" 150LBS PLAIN ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 10.440000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 10.440000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 8" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 8" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 8" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF', 'FLANGE 8" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 25.610000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 15.000000, 25.610000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 4" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 4" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 4" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF', 'FLANGE 4" 300LBS PLAIN ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 8.470000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 15.000000, 8.470000, NULL, 0.0, 0.0, 0.0);

    -- Item: ELBOW 1.1/2" SCH40 LR 90° ASTM A-234 ASME B16.9
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'ELBOW 1.1/2" SCH40 LR 90° ASTM A-234 ASME B16.9';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('ELBOW 1.1/2" SCH40 LR 90° ASTM A-234 ASME B16.9', 'ELBOW 1.1/2" SCH40 LR 90° ASTM A-234 ASME B16.9', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.400000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 100.000000, 0.400000, NULL, 0.0, 0.0, 0.0);

    -- Item: ELBOW 2" SCH40 LR 90° ASTM A-234 ASME B16.9
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'ELBOW 2" SCH40 LR 90° ASTM A-234 ASME B16.9';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('ELBOW 2" SCH40 LR 90° ASTM A-234 ASME B16.9', 'ELBOW 2" SCH40 LR 90° ASTM A-234 ASME B16.9', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.630000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 200.000000, 0.630000, NULL, 0.0, 0.0, 0.0);

    -- Item: ELBOW 3" SCH40 LR 90° ASTM A-234 ASME B16.9
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'ELBOW 3" SCH40 LR 90° ASTM A-234 ASME B16.9';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('ELBOW 3" SCH40 LR 90° ASTM A-234 ASME B16.9', 'ELBOW 3" SCH40 LR 90° ASTM A-234 ASME B16.9', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 3.030000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 3.030000, NULL, 0.0, 0.0, 0.0);

    -- Item: ELBOW 5" SCH40 LR 90° ASTM A-234 ASME B16.9
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'ELBOW 5" SCH40 LR 90° ASTM A-234 ASME B16.9';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('ELBOW 5" SCH40 LR 90° ASTM A-234 ASME B16.9', 'ELBOW 5" SCH40 LR 90° ASTM A-234 ASME B16.9', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 4.870000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 40.000000, 4.870000, NULL, 0.0, 0.0, 0.0);

    -- Item: ELBOW 6" SCH40 LR 90° ASTM A-234 ASME B16.9
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'ELBOW 6" SCH40 LR 90° ASTM A-234 ASME B16.9';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('ELBOW 6" SCH40 LR 90° ASTM A-234 ASME B16.9', 'ELBOW 6" SCH40 LR 90° ASTM A-234 ASME B16.9', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 7.320000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 7.320000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 1" 150LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 1" 150LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 1" 150LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 1" 150LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.990000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 40.000000, 0.990000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 1" 300LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 1" 300LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 1" 300LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 1" 300LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.580000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 40.000000, 1.580000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 1.1/2" 150LBS LISO ASTM A105 GR WPB B16.5
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 1.1/2" 150LBS LISO ASTM A105 GR WPB B16.5';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 1.1/2" 150LBS LISO ASTM A105 GR WPB B16.5', 'FLANGE 1.1/2" 150LBS LISO ASTM A105 GR WPB B16.5', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.480000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 100.000000, 1.480000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 1.1/2" 300LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 1.1/2" 300LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 1.1/2" 300LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 1.1/2" 300LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 2.760000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 2.760000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 1.1/4" 150LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 1.1/4" 150LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 1.1/4" 150LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 1.1/4" 150LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.380000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 1.380000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 2" 150LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 2" 150LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 2" 150LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 2" 150LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.970000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 250.000000, 1.970000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 2" 300LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 2" 300LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 2" 300LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 2" 300LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 3.150000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 80.000000, 3.150000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 2.1/2" 150LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 2.1/2" 150LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 2.1/2" 150LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 2.1/2" 150LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 3.150000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 3.150000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 2.1/2" 300LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 2.1/2" 300LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 2.1/2" 300LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 2.1/2" 300LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 4.140000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 4.140000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 3" 150LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 3" 150LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 3" 150LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 3" 150LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 3.550000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 3.550000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 4" 150LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 4" 150LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 4" 150LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 4" 150LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 4.930000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 4.930000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 5" 150LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 5" 150LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 5" 150LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 5" 150LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 5.910000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 80.000000, 5.910000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 6" 150LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 6" 150LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 6" 150LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 6" 150LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 6.900000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 80.000000, 6.900000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 8" 150LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 8" 150LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 8" 150LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 8" 150LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 10.440000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 80.000000, 10.440000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 8" 300LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 8" 300LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 8" 300LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 8" 300LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 25.610000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 25.610000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 6" 300LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 6" 300LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 6" 300LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 6" 300LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 15.760000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 15.760000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 5" 300LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 5" 300LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 5" 300LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 5" 300LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 11.030000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 15.000000, 11.030000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 4" 300LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 4" 300LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 4" 300LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 4" 300LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 8.470000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 15.000000, 8.470000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA 1.1/2" SCH40 RL 90° ASTM A-234 ASME B16.9
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA 1.1/2" SCH40 RL 90° ASTM A-234 ASME B16.9';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA 1.1/2" SCH40 RL 90° ASTM A-234 ASME B16.9', 'CURVA 1.1/2" SCH40 RL 90° ASTM A-234 ASME B16.9', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.400000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 100.000000, 0.400000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA 2" SCH40 RL 90° ASTM A-234 ASME B16.9
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA 2" SCH40 RL 90° ASTM A-234 ASME B16.9';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA 2" SCH40 RL 90° ASTM A-234 ASME B16.9', 'CURVA 2" SCH40 RL 90° ASTM A-234 ASME B16.9', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.630000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 200.000000, 0.630000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA 4" SCH40 RL 90° ASTM A-234 ASME B16.9
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA 4" SCH40 RL 90° ASTM A-234 ASME B16.9';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA 4" SCH40 RL 90° ASTM A-234 ASME B16.9', 'CURVA 4" SCH40 RL 90° ASTM A-234 ASME B16.9', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 3.030000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 3.030000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA 5" SCH40 RL 90° ASTM A-234 ASME B16.9
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA 5" SCH40 RL 90° ASTM A-234 ASME B16.9';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA 5" SCH40 RL 90° ASTM A-234 ASME B16.9', 'CURVA 5" SCH40 RL 90° ASTM A-234 ASME B16.9', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 4.870000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 40.000000, 4.870000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA 6" SCH40 RL 90° ASTM A-234 ASME B16.9
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA 6" SCH40 RL 90° ASTM A-234 ASME B16.9';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA 6" SCH40 RL 90° ASTM A-234 ASME B16.9', 'CURVA 6" SCH40 RL 90° ASTM A-234 ASME B16.9', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 7.320000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 7.320000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 1" 150LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 1" 150LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 1" 150LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 1" 150LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.990000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 200.000000, 0.990000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 1" 300LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 1" 300LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 1" 300LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 1" 300LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.580000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 1.580000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 1.1/2" 150LBS LISO ASTM A105 GR WPB B16.5
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 1.1/2" 150LBS LISO ASTM A105 GR WPB B16.5';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 1.1/2" 150LBS LISO ASTM A105 GR WPB B16.5', 'FLANGE 1.1/2" 150LBS LISO ASTM A105 GR WPB B16.5', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.480000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 800.000000, 1.480000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 1.1/2" 300LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 1.1/2" 300LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 1.1/2" 300LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 1.1/2" 300LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 2.760000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 2.760000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 1.1/4" 150LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 1.1/4" 150LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 1.1/4" 150LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 1.1/4" 150LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.380000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 1.380000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 2" 150LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 2" 150LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 2" 150LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 2" 150LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.970000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 1500.000000, 1.970000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 2" 300LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 2" 300LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 2" 300LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 2" 300LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 3.150000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 400.000000, 3.150000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 2.1/2" 150LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 2.1/2" 150LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 2.1/2" 150LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 2.1/2" 150LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 3.150000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 3.150000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 2.1/2" 300LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 2.1/2" 300LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 2.1/2" 300LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 2.1/2" 300LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 4.140000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 4.140000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 3" 150LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 3" 150LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 3" 150LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 3" 150LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 3.550000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 150.000000, 3.550000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 4" 150LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 4" 150LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 4" 150LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 4" 150LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 4.930000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 200.000000, 4.930000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 4" 300LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 4" 300LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 4" 300LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 4" 300LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 8.470000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 60.000000, 8.470000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA 1.1/2" SCH40 RL 90° ASTM A-234 ASME B16.9
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA 1.1/2" SCH40 RL 90° ASTM A-234 ASME B16.9';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA 1.1/2" SCH40 RL 90° ASTM A-234 ASME B16.9', 'CURVA 1.1/2" SCH40 RL 90° ASTM A-234 ASME B16.9', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.400000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 1300.000000, 0.400000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA 2" SCH40 RL 90° ASTM A-234 ASME B16.9
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA 2" SCH40 RL 90° ASTM A-234 ASME B16.9';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA 2" SCH40 RL 90° ASTM A-234 ASME B16.9', 'CURVA 2" SCH40 RL 90° ASTM A-234 ASME B16.9', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.630000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 1700.000000, 0.630000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA 4" SCH40 RL 90° ASTM A-234 ASME B16.9
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA 4" SCH40 RL 90° ASTM A-234 ASME B16.9';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA 4" SCH40 RL 90° ASTM A-234 ASME B16.9', 'CURVA 4" SCH40 RL 90° ASTM A-234 ASME B16.9', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 3.030000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 220.000000, 3.030000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA 5" SCH40 RL 90° ASTM A-234 ASME B16.9
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA 5" SCH40 RL 90° ASTM A-234 ASME B16.9';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA 5" SCH40 RL 90° ASTM A-234 ASME B16.9', 'CURVA 5" SCH40 RL 90° ASTM A-234 ASME B16.9', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 4.870000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 210.000000, 4.870000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA 6" SCH40 RL 90° ASTM A-234 ASME B16.9
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA 6" SCH40 RL 90° ASTM A-234 ASME B16.9';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA 6" SCH40 RL 90° ASTM A-234 ASME B16.9', 'CURVA 6" SCH40 RL 90° ASTM A-234 ASME B16.9', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 7.320000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 200.000000, 7.320000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 5" 150LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 5" 150LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 5" 150LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 5" 150LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 5.910000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 10.000000, 5.910000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 6" 150LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 6" 150LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 6" 150LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 6" 150LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 6.900000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 20.000000, 6.900000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 8" 150LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 8" 150LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 8" 150LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 8" 150LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 10.440000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 8.000000, 10.440000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 8" 300LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 8" 300LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 8" 300LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 8" 300LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 25.610000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 5.000000, 25.610000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 6" 300LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 6" 300LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 6" 300LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 6" 300LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 15.760000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 10.000000, 15.760000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 5" 300LBS LISO ASTM A105 GR WPB B16.5 RF
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 5" 300LBS LISO ASTM A105 GR WPB B16.5 RF';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 5" 300LBS LISO ASTM A105 GR WPB B16.5 RF', 'FLANGE 5" 300LBS LISO ASTM A105 GR WPB B16.5 RF', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 11.030000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 5.000000, 11.030000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 5" 150LBS WN ASTM A105 GR WPB B16.5
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 5" 150LBS WN ASTM A105 GR WPB B16.5';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 5" 150LBS WN ASTM A105 GR WPB B16.5', 'FLANGE 5" 150LBS WN ASTM A105 GR WPB B16.5', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 9.460000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 150.000000, 9.460000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 6" 150LBS WN ASTM A105 GR WPB B16.5
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 6" 150LBS WN ASTM A105 GR WPB B16.5';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 6" 150LBS WN ASTM A105 GR WPB B16.5', 'FLANGE 6" 150LBS WN ASTM A105 GR WPB B16.5', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 11.510000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 250.000000, 11.510000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 8" 150LBS WN ASTM A105 GR WPB B16.5
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 8" 150LBS WN ASTM A105 GR WPB B16.5';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 8" 150LBS WN ASTM A105 GR WPB B16.5', 'FLANGE 8" 150LBS WN ASTM A105 GR WPB B16.5', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 18.520000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 18.520000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 8" 300LBS WN ASTM A105 GR WPB B16.5
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 8" 300LBS WN ASTM A105 GR WPB B16.5';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 8" 300LBS WN ASTM A105 GR WPB B16.5', 'FLANGE 8" 300LBS WN ASTM A105 GR WPB B16.5', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 38.420000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 40.000000, 38.420000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 6" 300LBS WN ASTM A105 GR WPB B16.5
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 6" 300LBS WN ASTM A105 GR WPB B16.5';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 6" 300LBS WN ASTM A105 GR WPB B16.5', 'FLANGE 6" 300LBS WN ASTM A105 GR WPB B16.5', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 21.280000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 21.280000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE 5" 300LBS WN ASTM A105 GR WPB B16.5
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE 5" 300LBS WN ASTM A105 GR WPB B16.5';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE 5" 300LBS WN ASTM A105 GR WPB B16.5', 'FLANGE 5" 300LBS WN ASTM A105 GR WPB B16.5', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 20.100000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 15.000000, 20.100000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 2"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 2"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 2"', 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 2"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.860000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 1600.000000, 0.860000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 6"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 6"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 6"', 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 80 - 6"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 12.470000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 70.000000, 12.470000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 8"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 8"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 8"', 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 8"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 12.880000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 10.000000, 12.880000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 6"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 6"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 6"', 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 80 - 6"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 7.480000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 7.480000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 8''
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 8''';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 8''', 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 8''', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 7.570000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 70.000000, 7.570000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 6''
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 6''';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 6''', 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 6''', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 4.400000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 80.000000, 4.400000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 4"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 4"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 4"', 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 4"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 4.400000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 90.000000, 4.400000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 2"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 2"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 2"', 'CURVA SOLD RL 45° ASTM A-234 ASME B16.9 SCH 40 - 2"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.420000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 110.000000, 0.420000, NULL, 0.0, 0.0, 0.0);

    -- Item: REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 40 8" X 6"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 40 8" X 6"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 40 8" X 6"', 'REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 40 8" X 6"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 5.010000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 60.000000, 5.010000, NULL, 0.0, 0.0, 0.0);

    -- Item: REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 80 8" X 6"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 80 8" X 6"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 80 8" X 6"', 'REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 80 8" X 6"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 8.380000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 20.000000, 8.380000, NULL, 0.0, 0.0, 0.0);

    -- Item: REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 40 2" X 1.1/2"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 40 2" X 1.1/2"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 40 2" X 1.1/2"', 'REDUÇÃO CONCENTRICA ASTM A-234 ASME B16.9 SCH 40 2" X 1.1/2"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.470000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 120.000000, 0.470000, NULL, 0.0, 0.0, 0.0);

    -- Item: TEE 6" SCH-40 ASTM A-234 ASME B16.9
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'TEE 6" SCH-40 ASTM A-234 ASME B16.9';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('TEE 6" SCH-40 ASTM A-234 ASME B16.9', 'TEE 6" SCH-40 ASTM A-234 ASME B16.9', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 8.790000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 8.790000, NULL, 0.0, 0.0, 0.0);

    -- Item: TEE 3" SCH-40 ASTM A-234 ASME B16.9
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'TEE 3" SCH-40 ASTM A-234 ASME B16.9';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('TEE 3" SCH-40 ASTM A-234 ASME B16.9', 'TEE 3" SCH-40 ASTM A-234 ASME B16.9', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 2.600000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 2.600000, NULL, 0.0, 0.0, 0.0);

    -- Item: TEE 2" SCH-40 ASTM A-234 ASME B16.9
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'TEE 2" SCH-40 ASTM A-234 ASME B16.9';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('TEE 2" SCH-40 ASTM A-234 ASME B16.9', 'TEE 2" SCH-40 ASTM A-234 ASME B16.9', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.120000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 1.120000, NULL, 0.0, 0.0, 0.0);

    -- Item: TEE 1.1/2" SCH-40 ASTM A-234 ASME B16.9
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'TEE 1.1/2" SCH-40 ASTM A-234 ASME B16.9';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('TEE 1.1/2" SCH-40 ASTM A-234 ASME B16.9', 'TEE 1.1/2" SCH-40 ASTM A-234 ASME B16.9', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.920000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 60.000000, 0.920000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 5"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 5"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 5"', 'FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 5"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 7.100000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 145.000000, 7.100000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 6"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 6"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 6"', 'FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 6"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 9.540000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 260.000000, 9.540000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 8"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 8"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 8"', 'FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 8"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 15.630000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 15.630000, NULL, 0.0, 0.0, 0.0);

    -- Item: CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 1"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 1"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 1"', 'CURVA SOLD RL 90° ASTM A-234 ASME B16.9 SCH 40 - 1"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.200000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 550.000000, 0.200000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 3"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 3"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 3"', 'FLANGE CEGO ASTM A105 GR WPB B16.5 150 LBS 3"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 3.860000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 55.000000, 3.860000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 1/2"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 1/2"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 1/2"', 'FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 1/2"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.420000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 140.000000, 1.420000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 4"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 4"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 4"', 'FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 4"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 9.940000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 40.000000, 9.940000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 6"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 6"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 6"', 'FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 6"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 17.860000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 60.000000, 17.860000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 8"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 8"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 8"', 'FLANGE CEGO ASTM A105 GR WPB B16.5 300 LBS 8"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 29.420000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 29.420000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 3/4"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 3/4"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 3/4"', 'FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 3/4"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.480000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 50.000000, 1.480000, NULL, 0.0, 0.0, 0.0);

    -- Item: FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 1/2"
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('72121000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('72121000', 'NCM 72121000', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 1/2"';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 1/2"', 'FLANGE LISO ASTM A105 GR WPB B16.5 300 LBS 1/2"', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1.080000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 300.000000, 1.080000, NULL, 0.0, 0.0, 0.0);

    -- 7. Despesas da Simulação
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'TAXA SISCOMEX', 350.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'B/L', 1100.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'T.H.C|  CAPATAZIA', 1500.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'ISPS', 100.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'DAMAGE PROTECTION', 180.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'DESCONSOLIDAÇÃO', 490.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'SERVIÇO DE ENTREGA DE CONTAINER', 1060.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'DELIVERY ORDER', 366.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'AFRMM', 8.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'ARMAZENAGEM', 1500.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'IMPORT LOGIST FREE', 300.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'DROP OFF', 320.330000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'TAXA', 200.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'FRETE RODOVIÁRIO', 4500.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'COMISSÃO', 8303.300000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'DESEMBARAÇO ADUANEIRO', 1300.000000, 'BRL', 'Valor FOB');
END $$;
