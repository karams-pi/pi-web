-- SCRIPT DE IMPORTAÇÃO - EDC_PINZAN_rolamentos_aco_carbono_CORRIGIDA_FINAL(1).xlsx
-- ESTUDO DE REFERÊNCIA: ROLAMENTOS-PINZAN-CORRIGIDA-FINAL
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
    SELECT "Id" INTO v_importador_id FROM edc.importadores WHERE "RazaoSocial" ILIKE '%PINZAN%';
    IF v_importador_id IS NULL THEN
        INSERT INTO edc.importadores ("RazaoSocial", "Cnpj", "UF", "RegimeTributario", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('PINZAN & SILVA', '12.039.655/0001-52', 'PR', 'Lucro Presumido', 0.06, true)
        RETURNING "Id" INTO v_importador_id;
    END IF;

    -- 2. Exportador
    SELECT "Id" INTO v_exportador_id FROM edc.exportadores WHERE "Nome" = 'FORNECEDOR ROLAMENTOS (QINGDAO)';
    IF v_exportador_id IS NULL THEN
        INSERT INTO edc.exportadores ("Nome", "Pais", "FlAtivo", "Incoterm")
        VALUES ('FORNECEDOR ROLAMENTOS (QINGDAO)', 'CHINA', true, 'FOB')
        RETURNING "Id" INTO v_exportador_id;
    END IF;

    -- 3. Portos
    SELECT "Id" INTO v_porto_origem_id FROM edc.portos WHERE "Nome" ILIKE '%QINGDAO%' OR "Sigla" = 'QIN';
    IF v_porto_origem_id IS NULL THEN
        INSERT INTO edc.portos ("Nome", "Sigla", "Pais", "Tipo")
        VALUES ('PORT OF QINGDAO', 'QIN', 'CHINA', 'Maritimo')
        RETURNING "Id" INTO v_porto_origem_id;
    END IF;

    SELECT "Id" INTO v_porto_destino_id FROM edc.portos WHERE "Nome" ILIKE '%PARANAGUÁ%' OR "Sigla" = 'PAR';
    IF v_porto_destino_id IS NULL THEN
        INSERT INTO edc.portos ("Nome", "Sigla", "Pais", "Tipo")
        VALUES ('PORTO DE PARANAGUÁ', 'PAR', 'BRASIL', 'Maritimo')
        RETURNING "Id" INTO v_porto_destino_id;
    END IF;

    -- 4. Excluir simulação anterior de mesma referência se houver
    DELETE FROM edc.simulacoes WHERE "NumeroReferencia" = 'ROLAMENTOS-PINZAN-CORRIGIDA-FINAL';

    -- 5. Criar Simulação
    INSERT INTO edc.simulacoes (
        "NumeroReferencia", "DataEstudo", "IdImportador", "IdExportador", "IdPortoOrigem", "IdPortoDestino",
        "CotacaoDolar", "SpreadCambio", "TipoFrete", "ModalidadeFrete", "ValorFreteInternacional", "ValorSeguroInternacional",
        "ComissaoPercentual", "FlExibirComissao", "FlSimularSubfaturamento", "PercentualSubfaturamento",
        "MetodoCalculoIcms", "MetodoCalculoFederais", "Status"
    ) VALUES (
        'ROLAMENTOS-PINZAN-CORRIGIDA-FINAL', '2026-07-30 00:00:00', v_importador_id, v_exportador_id, v_porto_origem_id, v_porto_destino_id,
        5.12, 0.000000, 'FOB', 'LCL', 117.3375, 0,
        0.000000, false, true, 50,
        'SimplificadoExcel', 'SimplificadoExcel', 'Aprovado'
    ) RETURNING "Id" INTO v_simulacao_id;

    -- 6. Itens e Ncms
    -- Item: ROLAMENTO 6201-DDU
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('8466.93.50', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('8466.93.50', 'NCM 8466.93.50', 0.112000, 0.000000, 0.021000, 0.106500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '6201-DDU';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('6201-DDU', 'ROLAMENTO 6201-DDU', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.101000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 500.000000, 0.101000, 0.050500, 0.0, 0.0, 0.0);

    -- Item: ROLAMENTO 6204-DDU
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('8466.93.50', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('8466.93.50', 'NCM 8466.93.50', 0.112000, 0.000000, 0.021000, 0.106500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '6204-DDU';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('6204-DDU', 'ROLAMENTO 6204-DDU', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.166000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 500.000000, 0.166000, 0.083000, 0.0, 0.0, 0.0);

    -- Item: ROLAMENTO 6205-DDU
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('8466.93.50', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('8466.93.50', 'NCM 8466.93.50', 0.112000, 0.000000, 0.021000, 0.106500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '6205-DDU';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('6205-DDU', 'ROLAMENTO 6205-DDU', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.203000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 500.000000, 0.203000, 0.101500, 0.0, 0.0, 0.0);

    -- Item: ROLAMENTO 6206-DDU
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('8466.93.50', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('8466.93.50', 'NCM 8466.93.50', 0.112000, 0.000000, 0.021000, 0.106500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '6206-DDU';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('6206-DDU', 'ROLAMENTO 6206-DDU', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.300000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 500.000000, 0.300000, 0.150000, 0.0, 0.0, 0.0);

    -- Item: ROLAMENTO 6004-DDU
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('8466.93.50', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('8466.93.50', 'NCM 8466.93.50', 0.112000, 0.000000, 0.021000, 0.106500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '6004-DDU';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('6004-DDU', 'ROLAMENTO 6004-DDU', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.139000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 500.000000, 0.139000, 0.069500, 0.0, 0.0, 0.0);

    -- Item: ROLAMENTO 6001-DDU
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('8466.93.50', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('8466.93.50', 'NCM 8466.93.50', 0.112000, 0.000000, 0.021000, 0.106500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '6001-DDU';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('6001-DDU', 'ROLAMENTO 6001-DDU', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.083000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 500.000000, 0.083000, 0.041500, 0.0, 0.0, 0.0);

    -- Item: ROLAMENTO 6002-DDU
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('8466.93.50', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('8466.93.50', 'NCM 8466.93.50', 0.112000, 0.000000, 0.021000, 0.106500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '6002-DDU';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('6002-DDU', 'ROLAMENTO 6002-DDU', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.101000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 500.000000, 0.101000, 0.050500, 0.0, 0.0, 0.0);

    -- Item: ROLAMENTO 6003-DDU
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('8466.93.50', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('8466.93.50', 'NCM 8466.93.50', 0.112000, 0.000000, 0.021000, 0.106500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '6003-DDU';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('6003-DDU', 'ROLAMENTO 6003-DDU', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.116000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 500.000000, 0.116000, 0.058000, 0.0, 0.0, 0.0);

    -- Item: ROLAMENTO 6005-DDU
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('8466.93.50', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('8466.93.50', 'NCM 8466.93.50', 0.112000, 0.000000, 0.021000, 0.106500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '6005-DDU';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('6005-DDU', 'ROLAMENTO 6005-DDU', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.174000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 500.000000, 0.174000, 0.087000, 0.0, 0.0, 0.0);

    -- Item: ROLAMENTO 6006-DDU
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('8466.93.50', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('8466.93.50', 'NCM 8466.93.50', 0.112000, 0.000000, 0.021000, 0.106500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '6006-DDU';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('6006-DDU', 'ROLAMENTO 6006-DDU', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.242000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 500.000000, 0.242000, 0.121000, 0.0, 0.0, 0.0);

    -- Item: ROLAMENTO 6301-DDU
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('8466.93.50', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('8466.93.50', 'NCM 8466.93.50', 0.112000, 0.000000, 0.021000, 0.106500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '6301-DDU';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('6301-DDU', 'ROLAMENTO 6301-DDU', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.145000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 500.000000, 0.145000, 0.072500, 0.0, 0.0, 0.0);

    -- Item: ROLAMENTO 6302-DDU
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('8466.93.50', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('8466.93.50', 'NCM 8466.93.50', 0.112000, 0.000000, 0.021000, 0.106500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '6302-DDU';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('6302-DDU', 'ROLAMENTO 6302-DDU', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.174000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 500.000000, 0.174000, 0.087000, 0.0, 0.0, 0.0);

    -- Item: ROLAMENTO 6303-DDU
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('8466.93.50', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('8466.93.50', 'NCM 8466.93.50', 0.112000, 0.000000, 0.021000, 0.106500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '6303-DDU';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('6303-DDU', 'ROLAMENTO 6303-DDU', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.242000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 500.000000, 0.242000, 0.121000, 0.0, 0.0, 0.0);

    -- Item: ROLAMENTO 6304-DDU
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('8466.93.50', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('8466.93.50', 'NCM 8466.93.50', 0.112000, 0.000000, 0.021000, 0.106500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '6304-DDU';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('6304-DDU', 'ROLAMENTO 6304-DDU', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.252000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 500.000000, 0.252000, 0.126000, 0.0, 0.0, 0.0);

    -- Item: ROLAMENTO 6305-DDU
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('8466.93.50', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('8466.93.50', 'NCM 8466.93.50', 0.112000, 0.000000, 0.021000, 0.106500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '6305-DDU';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('6305-DDU', 'ROLAMENTO 6305-DDU', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.339000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 500.000000, 0.339000, 0.169500, 0.0, 0.0, 0.0);

    -- Item: ROLAMENTO 6306-DDU
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('8466.93.50', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('8466.93.50', 'NCM 8466.93.50', 0.112000, 0.000000, 0.021000, 0.106500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '6306-DDU';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('6306-DDU', 'ROLAMENTO 6306-DDU', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.542000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 500.000000, 0.542000, 0.271000, 0.0, 0.0, 0.0);

    -- Item: ROLAMENTO 608-DDU
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('8466.93.50', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('8466.93.50', 'NCM 8466.93.50', 0.112000, 0.000000, 0.021000, 0.106500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '608-DDU';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('608-DDU', 'ROLAMENTO 608-DDU', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.058000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 500.000000, 0.058000, 0.029000, 0.0, 0.0, 0.0);

    -- Item: ROLAMENTO 32010
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('8466.93.50', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('8466.93.50', 'NCM 8466.93.50', 0.112000, 0.000000, 0.021000, 0.106500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '32010';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('32010', 'ROLAMENTO 32010', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.852000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 500.000000, 0.852000, 0.426000, 0.0, 0.0, 0.0);

    -- Item: ROLAMENTO 6007-DDU
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('8466.93.50', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('8466.93.50', 'NCM 8466.93.50', 0.112000, 0.000000, 0.021000, 0.106500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '6007-DDU';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('6007-DDU', 'ROLAMENTO 6007-DDU', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.310000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 500.000000, 0.310000, 0.155000, 0.0, 0.0, 0.0);

    -- Item: ROLAMENTO 6010-DDU
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('8466.93.50', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('8466.93.50', 'NCM 8466.93.50', 0.112000, 0.000000, 0.021000, 0.106500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '6010-DDU';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('6010-DDU', 'ROLAMENTO 6010-DDU', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.619000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 500.000000, 0.619000, 0.309500, 0.0, 0.0, 0.0);

    -- 7. Despesas da Simulação
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'TAXA SISCOMEX', 214.500000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'LIBERAÇÃO DE B/L', 10.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'T.H.C|  CAPATAZIA', 990.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'ISPS', 48.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'DAMAGE PROTECTION', 122.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'DESCONSOLIDAÇÃO', 10.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'DEVOLUÇÃO DE CONTAINER', 774.900000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'TRS', 153.600000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'AFRMM', 8.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'ARMAZENAGEM TCP', 0.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'SCANNER TCP', 756.950000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'HANDLING - TCP', 20.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'PESAGEM TCP', 117.450000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'TAXA DO PARCEIRO - PARANAGUÁ', 286.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'FRETE RODOVIÁRIO', 3000.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'DESEMBARAÇO ADUANEIRO', 2600.000000, 'BRL', 'Valor FOB');
END $$;
