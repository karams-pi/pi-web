-- SCRIPT DE IMPORTAÇÃO DE EDCs - FASINQI & MECFILTER
-- GERADO AUTOMATICAMENTE PARA SISTEMA PI

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

    -- ==========================================================================
    -- 1. IMPORTAÇÃO EDC: FASINQI-06-05-2026-FABRICA2
    -- ==========================================================================

    -- 1.1. Importador (HORTAVIVA)
    SELECT "Id" INTO v_importador_id FROM edc.importadores WHERE "RazaoSocial" = 'HORTAVIVA';
    IF v_importador_id IS NULL THEN
        INSERT INTO edc.importadores ("RazaoSocial", "Cnpj", "UF", "RegimeTributario", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('HORTAVIVA', '12.345.678/0001-99', 'PR', 'Lucro Presumido', 0.12, true)
        RETURNING "Id" INTO v_importador_id;
    END IF;

    -- 1.2. Exportador (FÁBRICA 1)
    SELECT "Id" INTO v_exportador_id FROM edc.exportadores WHERE "Nome" = 'FÁBRICA 1';
    IF v_exportador_id IS NULL THEN
        INSERT INTO edc.exportadores ("Nome", "Pais", "FlAtivo", "Incoterm")
        VALUES ('FÁBRICA 1', 'CHINA', true, 'FOB')
        RETURNING "Id" INTO v_exportador_id;
    END IF;

    -- 1.3. Portos (Shanghai -> Itapoá)
    SELECT "Id" INTO v_porto_origem_id FROM edc.portos WHERE "Nome" ILIKE '%SHANGHAI%' OR "Sigla" = 'SHA';
    IF v_porto_origem_id IS NULL THEN
        INSERT INTO edc.portos ("Nome", "Sigla", "Pais", "Tipo")
        VALUES ('SHANGHAI', 'SHA', 'CHINA', 'Maritimo')
        RETURNING "Id" INTO v_porto_origem_id;
    END IF;

    SELECT "Id" INTO v_porto_destino_id FROM edc.portos WHERE "Nome" ILIKE '%ITAPOÁ%' OR "Sigla" = 'ITP';
    IF v_porto_destino_id IS NULL THEN
        INSERT INTO edc.portos ("Nome", "Sigla", "Pais", "Tipo")
        VALUES ('ITAPOÁ', 'ITP', 'BRASIL', 'Maritimo')
        RETURNING "Id" INTO v_porto_destino_id;
    END IF;

    -- 1.4. Limpeza de dados antigos da simulação se houver
    DELETE FROM edc.simulacao_itens WHERE "IdSimulacao" IN (SELECT "Id" FROM edc.simulacoes WHERE "NumeroReferencia" = 'FASINQI-06-05-2026-FABRICA2');
    DELETE FROM edc.simulacao_despesas WHERE "IdSimulacao" IN (SELECT "Id" FROM edc.simulacoes WHERE "NumeroReferencia" = 'FASINQI-06-05-2026-FABRICA2');
    DELETE FROM edc.simulacoes WHERE "NumeroReferencia" = 'FASINQI-06-05-2026-FABRICA2';

    -- 1.5. Criar Simulação
    INSERT INTO edc.simulacoes (
        "NumeroReferencia", "DataEstudo", "IdImportador", "IdExportador", "IdPortoOrigem", "IdPortoDestino",
        "CotacaoDolar", "SpreadCambio", "TipoFrete", "ModalidadeFrete", "ValorFreteInternacional", "ValorSeguroInternacional",
        "ComissaoPercentual", "FlExibirComissao", "FlSimularSubfaturamento", "PercentualSubfaturamento",
        "MetodoCalculoIcms", "MetodoCalculoFederais", "Status"
    ) VALUES (
        'FASINQI-06-05-2026-FABRICA2', '2026-05-06 00:00:00', v_importador_id, v_exportador_id, v_porto_origem_id, v_porto_destino_id,
        4.990000, 0.000000, 'FOB', '1X20GP', 3001.000000, 0.000000,
        0.050000, true, false, 50,
        'SimplificadoExcel', 'SimplificadoExcel', 'Aprovado'
    ) RETURNING "Id" INTO v_simulacao_id;

    -- 1.6. Produtos, NCMs e Itens de Simulação
    -- Produto: Carboxilate Sulfonate Nonion Terpolymer (TH3100)
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('39069019', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('39069019', 'NCM 39069019', 0.126000, 0.036500, 0.021000, 0.096500, 0.120000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'Carboxilate Sulfonate Nonion Terpolymer (TH3100)';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('Carboxilate Sulfonate Nonion Terpolymer (TH3100)', 'Carboxilate Sulfonate Nonion Terpolymer (TH3100)', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1105.000000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 4.800000, 1105.000000, NULL, 0.0, 0.0, 0.0);

    -- Produto: Carboxilate Sulfonate Copolymer (TH5000)
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('39069011', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('39069011', 'NCM 39069011', 0.126000, 0.036500, 0.021000, 0.096500, 0.120000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'Carboxilate Sulfonate Copolymer (TH5000)';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('Carboxilate Sulfonate Copolymer (TH5000)', 'Carboxilate Sulfonate Copolymer (TH5000)', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 1145.000000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 7.200000, 1145.000000, NULL, 0.0, 0.0, 0.0);

    -- Produto: Sodium Polyacrilate (PASS 45%)
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('39069011', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('39069011', 'NCM 39069011', 0.126000, 0.036500, 0.021000, 0.096500, 0.120000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'Sodium Polyacrilate (PASS 45%)';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('Sodium Polyacrilate (PASS 45%)', 'Sodium Polyacrilate (PASS 45%)', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 945.000000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 5.000000, 945.000000, NULL, 0.0, 0.0, 0.0);

    -- Produto: PCA
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('39069069', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('39069069', 'NCM 39069069', 0.126000, 0.036500, 0.021000, 0.096500, 0.120000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'PCA';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('PCA', 'PCA', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 965.000000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 7.200000, 965.000000, NULL, 0.0, 0.0, 0.0);

    -- 1.7. Despesas da Simulação
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'TAXAS PORTUÁRIAS', 100.000000, 'BRL', 'Quantidade');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'TAXA SISCOMEX', 180.000000, 'BRL', 'Quantidade');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'BL', 1072.940000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'SERVIÇO DE ENTREGA DE CONTAINER', 1060.000000, 'BRL', 'Quantidade');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'T.H.C|CAPATAZIA', 29.800000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'ISPS', 1198.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'DAMAGE PROTECTION', 5000.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'Import logistic fee', 300.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'Drop off', 320.330000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'DESCONSOLIDAÇÃO', 117.450000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'TRS', 286.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'AFRMM', 3180.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'ARMAZENAGEM', 1270.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'COMISSÃO SEAWISE', 1261.050000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'PESAGEM', 18225.570000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'TAXA DO PARCEIRO', 220246.410000, 'BRL', 'Valor FOB');

    -- ==========================================================================
    -- 2. IMPORTAÇÃO EDC: MECFILTER-03-06-2026
    -- ==========================================================================

    -- 2.1. Importador (MECFILTER)
    SELECT "Id" INTO v_importador_id FROM edc.importadores WHERE "RazaoSocial" = 'MECFILTER';
    IF v_importador_id IS NULL THEN
        INSERT INTO edc.importadores ("RazaoSocial", "Cnpj", "UF", "RegimeTributario", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('MECFILTER', '98.765.432/0001-99', 'PR', 'Simples Nacional', 0.195, true)
        RETURNING "Id" INTO v_importador_id;
    END IF;

    -- 2.2. Exportador (CHINA SUPPLIER)
    SELECT "Id" INTO v_exportador_id FROM edc.exportadores WHERE "Nome" = 'CHINA SUPPLIER';
    IF v_exportador_id IS NULL THEN
        INSERT INTO edc.exportadores ("Nome", "Pais", "FlAtivo", "Incoterm")
        VALUES ('CHINA SUPPLIER', 'CHINA', true, 'FOB')
        RETURNING "Id" INTO v_exportador_id;
    END IF;

    -- 2.3. Portos (Ningbo -> Santos)
    SELECT "Id" INTO v_porto_origem_id FROM edc.portos WHERE "Nome" ILIKE '%NINGBO%' OR "Sigla" = 'NGB';
    IF v_porto_origem_id IS NULL THEN
        INSERT INTO edc.portos ("Nome", "Sigla", "Pais", "Tipo")
        VALUES ('NINGBO', 'NGB', 'CHINA', 'Maritimo')
        RETURNING "Id" INTO v_porto_origem_id;
    END IF;

    SELECT "Id" INTO v_porto_destino_id FROM edc.portos WHERE "Nome" ILIKE '%SANTOS%' OR "Sigla" = 'SSZ';
    IF v_porto_destino_id IS NULL THEN
        INSERT INTO edc.portos ("Nome", "Sigla", "Pais", "Tipo")
        VALUES ('SANTOS', 'SSZ', 'BRASIL', 'Maritimo')
        RETURNING "Id" INTO v_porto_destino_id;
    END IF;

    -- 2.4. Limpeza de dados antigos da simulação se houver
    DELETE FROM edc.simulacao_itens WHERE "IdSimulacao" IN (SELECT "Id" FROM edc.simulacoes WHERE "NumeroReferencia" = 'MECFILTER-03-06-2026');
    DELETE FROM edc.simulacao_despesas WHERE "IdSimulacao" IN (SELECT "Id" FROM edc.simulacoes WHERE "NumeroReferencia" = 'MECFILTER-03-06-2026');
    DELETE FROM edc.simulacoes WHERE "NumeroReferencia" = 'MECFILTER-03-06-2026';

    -- 2.5. Criar Simulação
    INSERT INTO edc.simulacoes (
        "NumeroReferencia", "DataEstudo", "IdImportador", "IdExportador", "IdPortoOrigem", "IdPortoDestino",
        "CotacaoDolar", "SpreadCambio", "TipoFrete", "ModalidadeFrete", "ValorFreteInternacional", "ValorSeguroInternacional",
        "ComissaoPercentual", "FlExibirComissao", "FlSimularSubfaturamento", "PercentualSubfaturamento",
        "MetodoCalculoIcms", "MetodoCalculoFederais", "Status"
    ) VALUES (
        'MECFILTER-03-06-2026', '2026-06-03 00:00:00', v_importador_id, v_exportador_id, v_porto_origem_id, v_porto_destino_id,
        5.070000, 0.000000, 'FOB', '1x20DRY', 1600.000000, 0.000000,
        0.000000, false, false, 50,
        'SimplificadoExcel', 'SimplificadoExcel', 'Aprovado'
    ) RETURNING "Id" INTO v_simulacao_id;

    -- 2.6. Produtos, NCMs e Itens de Simulação
    -- Produto: 72x0.9x3000
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('73089010', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('73089010', 'NCM 73089010', 0.126000, 0.000000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '72x0.9x3000';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('72x0.9x3000', '72x0.9x3000', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 13.890000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 40.000000, 13.890000, NULL, 0.0, 0.0, 0.0);

    -- Produto: 46x0.9x3000
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('73089010', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('73089010', 'NCM 73089010', 0.126000, 0.000000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '46x0.9x3000';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('46x0.9x3000', '46x0.9x3000', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 11.840000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 40.000000, 11.840000, NULL, 0.0, 0.0, 0.0);

    -- Produto: 52 x0.9x3000
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('73089010', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('73089010', 'NCM 73089010', 0.126000, 0.000000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '52 x0.9x3000';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('52 x0.9x3000', '52 x0.9x3000', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 12.860000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 40.000000, 12.860000, NULL, 0.0, 0.0, 0.0);

    -- Produto: 104x0.9x3000
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('73089010', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('73089010', 'NCM 73089010', 0.126000, 0.000000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '104x0.9x3000';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('104x0.9x3000', '104x0.9x3000', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 16.390000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 16.390000, NULL, 0.0, 0.0, 0.0);

    -- Produto: 118x0.9x3000
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('73089010', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('73089010', 'NCM 73089010', 0.126000, 0.000000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '118x0.9x3000';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('118x0.9x3000', '118x0.9x3000', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 18.010000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 30.000000, 18.010000, NULL, 0.0, 0.0, 0.0);

    -- Produto: 106x0.9x3000
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('73089010', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('73089010', 'NCM 73089010', 0.126000, 0.000000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '106x0.9x3000';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('106x0.9x3000', '106x0.9x3000', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 16.980000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 20.000000, 16.980000, NULL, 0.0, 0.0, 0.0);

    -- Produto: 52x1.9x 3000
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('73089010', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('73089010', 'NCM 73089010', 0.126000, 0.000000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '52x1.9x 3000';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('52x1.9x 3000', '52x1.9x 3000', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 19.480000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 20.000000, 19.480000, NULL, 0.0, 0.0, 0.0);

    -- Produto: 38x0.9x3000
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('73089010', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('73089010', 'NCM 73089010', 0.126000, 0.000000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '38x0.9x3000';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('38x0.9x3000', '38x0.9x3000', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 12.860000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 20.000000, 12.860000, NULL, 0.0, 0.0, 0.0);

    -- Produto: 64x0.9x3000
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('73089010', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('73089010', 'NCM 73089010', 0.126000, 0.000000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '64x0.9x3000';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('64x0.9x3000', '64x0.9x3000', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 14.340000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 20.000000, 14.340000, NULL, 0.0, 0.0, 0.0);

    -- Produto: 96x0.9x3000
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('73089010', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('73089010', 'NCM 73089010', 0.126000, 0.000000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '96x0.9x3000';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('96x0.9x3000', '96x0.9x3000', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 15.660000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 10.000000, 15.660000, NULL, 0.0, 0.0, 0.0);

    -- Produto: 29x0.9x3000
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('73089010', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('73089010', 'NCM 73089010', 0.126000, 0.000000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '29x0.9x3000';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('29x0.9x3000', '29x0.9x3000', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 12.570000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 10.000000, 12.570000, NULL, 0.0, 0.0, 0.0);

    -- Produto: 26x0.9x 3000
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('73089010', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('73089010', 'NCM 73089010', 0.126000, 0.000000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '26x0.9x 3000';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('26x0.9x 3000', '26x0.9x 3000', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 11.100000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 10.000000, 11.100000, NULL, 0.0, 0.0, 0.0);

    -- Produto: 110x0.9x3000
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('73089010', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('73089010', 'NCM 73089010', 0.126000, 0.000000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '110x0.9x3000';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('110x0.9x3000', '110x0.9x3000', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 17.570000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 10.000000, 17.570000, NULL, 0.0, 0.0, 0.0);

    -- Produto: 56x0.9x3000
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('73089010', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('73089010', 'NCM 73089010', 0.126000, 0.000000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '56x0.9x3000';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('56x0.9x3000', '56x0.9x3000', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 13.600000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 5.000000, 13.600000, NULL, 0.0, 0.0, 0.0);

    -- Produto: 26x1.9x3000
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('73089010', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('73089010', 'NCM 73089010', 0.126000, 0.000000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '26x1.9x3000';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('26x1.9x3000', '26x1.9x3000', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 15.510000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 5.000000, 15.510000, NULL, 0.0, 0.0, 0.0);

    -- Produto: 46x1.9x3000
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('73089010', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('73089010', 'NCM 73089010', 0.126000, 0.000000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '46x1.9x3000';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('46x1.9x3000', '46x1.9x3000', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 18.750000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 5.000000, 18.750000, NULL, 0.0, 0.0, 0.0);

    -- Produto: 114x0.9x3000
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('73089010', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('73089010', 'NCM 73089010', 0.126000, 0.000000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '114x0.9x3000';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('114x0.9x3000', '114x0.9x3000', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 18.010000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 5.000000, 18.010000, NULL, 0.0, 0.0, 0.0);

    -- Produto: 32x1.9x3000
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('73089010', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('73089010', 'NCM 73089010', 0.126000, 0.000000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '32x1.9x3000';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('32x1.9x3000', '32x1.9x3000', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 17.280000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 5.000000, 17.280000, NULL, 0.0, 0.0, 0.0);

    -- Produto: 38x1.9x3000
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('73089010', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('73089010', 'NCM 73089010', 0.126000, 0.000000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '38x1.9x3000';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('38x1.9x3000', '38x1.9x3000', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 19.480000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 5.000000, 19.480000, NULL, 0.0, 0.0, 0.0);

    -- Produto: 53*2*3000
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('73089010', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('73089010', 'NCM 73089010', 0.126000, 0.000000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '53*2*3000';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('53*2*3000', '53*2*3000', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 40.070000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 6.000000, 40.070000, NULL, 0.0, 0.0, 0.0);

    -- Produto: 41*2*3000
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('73089010', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('73089010', 'NCM 73089010', 0.126000, 0.000000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '41*2*3000';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('41*2*3000', '41*2*3000', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 35.360000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 6.000000, 35.360000, NULL, 0.0, 0.0, 0.0);

    -- Produto: 26*2*3000
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('73089010', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('73089010', 'NCM 73089010', 0.126000, 0.000000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = '26*2*3000';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('26*2*3000', '26*2*3000', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 30.220000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 6.000000, 30.220000, NULL, 0.0, 0.0, 0.0);

    -- Produto: ZS03
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('70199000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('70199000', 'NCM 70199000', 0.108000, 0.072000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'ZS03';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('ZS03', 'ZS03', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 13.100000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 160.000000, 13.100000, NULL, 0.0, 0.0, 0.0);

    -- Produto: ZS05
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('70199000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('70199000', 'NCM 70199000', 0.108000, 0.072000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'ZS05';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('ZS05', 'ZS05', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 12.700000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 80.000000, 12.700000, NULL, 0.0, 0.0, 0.0);

    -- Produto: ZS10
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('70199000', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('70199000', 'NCM 70199000', 0.108000, 0.072000, 0.021000, 0.096500, 0.195000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'ZS10';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('ZS10', 'ZS10', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 12.100000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 80.000000, 12.100000, NULL, 0.0, 0.0, 0.0);

    -- 2.7. Despesas da Simulação
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'TAXA SISCOMEX', 154.230000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'LIBERAÇÃO DE B/L', 400.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'T.H.C|  CAPATAZIA', 1200.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'Container Control Fee', 438.800000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'CRS', 743.460000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'DESCONSOLIDAÇÃO', 1086.590000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'DEVOLUÇÃO DE CONTAINER', 290.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'TRS', 400.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'TSF', 943.620000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'AFRMM', 648.960000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'HANDLING', 600.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'PESAGEM', 359.960000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'Taxa Expediente Portuária', 250.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'FRETE RODOVIÁRIO', 3000.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'DESEMBARAÇO ADUANEIRO', 2800.000000, 'BRL', 'Valor FOB');

END $$;