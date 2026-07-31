-- SCRIPT DE IMPORTAÇÃO - EDC - ARAME 1mm 30-07 - RATEIO E SOMAS CORRIGIDOS.xlsx
-- ESTUDO DE REFERÊNCIA: SECAMAQ-ARAME-1MM
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
    SELECT "Id" INTO v_exportador_id FROM edc.exportadores WHERE "Nome" = 'CHINA SUPPLIER';
    IF v_exportador_id IS NULL THEN
        INSERT INTO edc.exportadores ("Nome", "Pais", "FlAtivo", "Incoterm")
        VALUES ('CHINA SUPPLIER', 'CHINA', true, 'FOB')
        RETURNING "Id" INTO v_exportador_id;
    END IF;

    -- 3. Portos
    SELECT "Id" INTO v_porto_origem_id FROM edc.portos WHERE "Nome" ILIKE '%SHANGHAI%' OR "Sigla" = 'SHA';
    IF v_porto_origem_id IS NULL THEN
        INSERT INTO edc.portos ("Nome", "Sigla", "Pais", "Tipo")
        VALUES ('PORT OF SHANGHAI', 'SHA', 'CHINA', 'Maritimo')
        RETURNING "Id" INTO v_porto_origem_id;
    END IF;

    SELECT "Id" INTO v_porto_destino_id FROM edc.portos WHERE "Nome" ILIKE '%NAVEGANTES%' OR "Sigla" = 'NAV';
    IF v_porto_destino_id IS NULL THEN
        INSERT INTO edc.portos ("Nome", "Sigla", "Pais", "Tipo")
        VALUES ('PORTO DE NAVEGANTES', 'NAV', 'BRASIL', 'Maritimo')
        RETURNING "Id" INTO v_porto_destino_id;
    END IF;

    -- 4. Excluir simulação anterior de mesma referência se houver
    DELETE FROM edc.simulacoes WHERE "NumeroReferencia" = 'SECAMAQ-ARAME-1MM';

    -- 5. Criar Simulação
    INSERT INTO edc.simulacoes (
        "NumeroReferencia", "DataEstudo", "IdImportador", "IdExportador", "IdPortoOrigem", "IdPortoDestino",
        "CotacaoDolar", "SpreadCambio", "TipoFrete", "ModalidadeFrete", "ValorFreteInternacional", "ValorSeguroInternacional",
        "ComissaoPercentual", "FlExibirComissao", "FlSimularSubfaturamento", "PercentualSubfaturamento",
        "MetodoCalculoIcms", "MetodoCalculoFederais", "Status"
    ) VALUES (
        'SECAMAQ-ARAME-1MM', '2026-07-30 00:00:00', v_importador_id, v_exportador_id, v_porto_origem_id, v_porto_destino_id,
        5.09, 0.000000, 'FOB', '1x20DRY', 5191.16, 0,
        0.000000, false, false, 50,
        'SimplificadoExcel', 'SimplificadoExcel', 'Aprovado'
    ) RETURNING "Id" INTO v_simulacao_id;

    -- 6. Itens e Ncms
    -- Item: Arame 1,0mm
    SELECT "Id" INTO v_ncm_id FROM edc.ncms WHERE REPLACE("Codigo", '.', '') = REPLACE('7229.20.00', '.', '');
    IF v_ncm_id IS NULL THEN
        INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
        VALUES ('7229.20.00', 'NCM 7229.20.00', 0.112000, 0.032500, 0.021000, 0.096500, 0.060000, true)
        RETURNING "Id" INTO v_ncm_id;
    END IF;

    SELECT "Id" INTO v_produto_id FROM edc.produtos WHERE "Referencia" = 'Arame 1,0mm';
    IF v_produto_id IS NULL THEN
        INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PesoLiquido", "PesoBruto", "CubagemM3", "UnidadeMedida", "PrecoFobBase", "FlAtivo")
        VALUES ('Arame 1,0mm', 'Arame 1,0mm', v_ncm_id, 0.0, 0.0, 0.0, 'UN', 0.815000, true)
        RETURNING "Id" INTO v_produto_id;
    END IF;

    INSERT INTO edc.simulacao_itens (
        "IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "ValorFobSubfaturado", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal"
    ) VALUES (v_simulacao_id, v_produto_id, 23760.000000, 0.815000, NULL, 0.0, 0.0, 0.0);

    -- 7. Despesas da Simulação
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'TAXA SISCOMEX', 350.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'B/L', 1000.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'T.H.C|  CAPATAZIA', 1500.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'ISPS', 100.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'DAMAGE PROTECTION', 180.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'DESCONSOLIDAÇÃO', 1072.940000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'SERVIÇO DE ENTREGA DE CONTAINER', 1060.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'TRS', 29.800000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'AFRMM', 8.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'ARMAZENAGEM', 5200.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'IMPORT LOGISTIC FEE', 300.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'DROP OFF', 320.330000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'PESAGEM', 117.450000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'TAXA DO PARCEIRO', 286.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'FRETE RODOVIÁRIO', 3180.000000, 'BRL', 'Valor FOB');
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    VALUES (v_simulacao_id, 'DESEMBARAÇO ADUANEIRO', 1270.000000, 'BRL', 'Valor FOB');
END $$;
