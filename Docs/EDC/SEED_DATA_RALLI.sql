-- SCRIPT DE CARGA DE DADOS COMPLETO - RALLI (MARÇO 2026)
-- TODOS OS PRODUTOS DA PLANILHA "LISTA DE COMPRAS" (47 ITENS ATIVOS)
-- VERSÃO FINAL PARA VALIDAÇÃO DE ESCOPO 100%

DO $$ 
DECLARE 
    v_importador_id INTEGER;
    v_exportador_id INTEGER;
    v_porto_origem_id INTEGER;
    v_porto_destino_id INTEGER;
    v_ncm_id INTEGER;
    v_simulacao_id INTEGER;
BEGIN
    -- 1. LIMPEZA TOTAL PARA RECARGA LIMPA
    TRUNCATE edc.simulacao_itens, edc.simulacao_despesas, edc.simulacoes RESTART IDENTITY CASCADE;
    TRUNCATE edc.produtos, edc.ncms, edc.taxas_aduaneiras, edc.portos RESTART IDENTITY CASCADE;
    TRUNCATE edc.importadores, edc.exportadores RESTART IDENTITY CASCADE;

    -- 2. CADASTRO DE NCM PADRÃO RALLI
    INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
    VALUES ('87088000', 'Amortecedores de Suspensão', 0.18, 0.0306, 0.0312, 0.1437, 0.18, true)
    RETURNING "Id" INTO v_ncm_id;

    -- 3. CADASTRO DE PORTOS (Rota Shanghai -> Paranaguá)
    INSERT INTO edc.portos ("Nome", "Sigla", "Pais", "Tipo") VALUES ('Port of Shanghai', 'SGH', 'China', 'Maritimo') RETURNING "Id" INTO v_porto_origem_id;
    INSERT INTO edc.portos ("Nome", "Sigla", "Pais", "Tipo") VALUES ('Porto de Paranaguá (TCP)', 'PNG', 'Brasil', 'Maritimo') RETURNING "Id" INTO v_porto_destino_id;

    -- 4. CADASTRO DE TAXAS ADUANEIRAS
    INSERT INTO edc.taxas_aduaneiras ("Nome", "ValorPadrao", "Moeda", "Tipo")
    VALUES 
    ('TAXA SISCOMEX', 214.50, 'BRL', 'Fixo'),
    ('LIBERAÇÃO DE B/L', 490.00, 'BRL', 'Fixo'),
    ('THC / CAPATAZIA', 1547.00, 'BRL', 'Fixo'),
    ('ISPS', 48.00, 'BRL', 'Fixo'),
    ('TRS', 1072.94, 'BRL', 'Fixo'),
    ('FRETE RODOVIÁRIO', 6000.00, 'BRL', 'Fixo'),
    ('DESEMBARAÇO ADUANEIRO', 2400.00, 'BRL', 'Fixo');

    -- 5. CADASTRO DOS 47 PRODUTOS REAIS DA PLANILHA
    INSERT INTO edc.produtos ("Referencia", "Descricao", "IdNcm", "PrecoFobBase", "PesoLiquido", "PesoBruto", "CubagemM3", "FlAtivo", "UnidadeMedida")
    VALUES 
    ('2231832', 'AMORTECEDOR RALLI PRO', v_ncm_id, 5.80, 4.5, 5.8, 0.025, true, 'UN'),
    ('1384624', 'COMPONENTE SUSPENSAO A', v_ncm_id, 2.10, 1.2, 1.5, 0.008, true, 'UN'),
    ('1515117', 'AMORTECEDOR HD 1515', v_ncm_id, 10.00, 6.0, 7.2, 0.032, true, 'UN'),
    ('1515118', 'AMORTECEDOR HD 1518', v_ncm_id, 10.00, 6.0, 7.2, 0.032, true, 'UN'),
    ('1777207', 'AMORTECEDOR SPORT 1777', v_ncm_id, 10.00, 5.5, 6.8, 0.030, true, 'UN'),
    ('1349840.1', 'AMORTECEDOR RALLI V1', v_ncm_id, 11.50, 7.0, 8.5, 0.040, true, 'UN'),
    ('1349840.2', 'AMORTECEDOR RALLI V2', v_ncm_id, 11.50, 7.0, 8.5, 0.040, true, 'UN'),
    ('1476415.1', 'AMORTECEDOR TRASEIRO V1', v_ncm_id, 10.80, 6.8, 8.2, 0.038, true, 'UN'),
    ('1476415.2', 'AMORTECEDOR TRASEIRO V2', v_ncm_id, 10.80, 6.8, 8.2, 0.038, true, 'UN'),
    ('2023668', 'AMORTECEDOR DIANT 2023', v_ncm_id, 7.60, 5.2, 6.5, 0.028, true, 'UN'),
    ('1761377; 2074003', 'KIT COMPONENTES 1761', v_ncm_id, 14.40, 3.5, 4.2, 0.020, true, 'UN'),
    ('1761373', 'KIT SUSPENSAO 1761', v_ncm_id, 7.60, 4.0, 5.0, 0.022, true, 'UN'),
    ('1462266', 'AMORTECEDOR REFORCADO 1462', v_ncm_id, 14.40, 8.2, 10.0, 0.048, true, 'UN'),
    ('1952540', 'AMORTECEDOR OFFROAD 1952', v_ncm_id, 17.80, 9.5, 11.5, 0.055, true, 'UN'),
    ('1952434', 'AMORTECEDOR TRUCK 1952', v_ncm_id, 17.80, 9.8, 11.8, 0.058, true, 'UN'),
    ('3198849', 'AMORTECEDOR COMPACT 3198', v_ncm_id, 4.40, 3.2, 4.0, 0.018, true, 'UN'),
    ('8078547', 'AMORTECEDOR SUV 8078', v_ncm_id, 6.40, 4.8, 6.0, 0.026, true, 'UN'),
    ('21552066', 'AMORTECEDOR BUS 2155', v_ncm_id, 4.60, 10.5, 12.5, 0.065, true, 'UN'),
    ('8129279', 'AMORTECEDOR SEDAN 8129', v_ncm_id, 5.10, 4.2, 5.5, 0.024, true, 'UN'),
    ('BC455C368-CB', 'AMORTECEDOR RALLI BC45', v_ncm_id, 9.30, 6.5, 8.0, 0.035, true, 'UN'),
    ('BC455C398-CA', 'AMORTECEDOR RALLI BC45-CA', v_ncm_id, 9.30, 6.5, 8.0, 0.035, true, 'UN'),
    ('BC455C368-BB', 'AMORTECEDOR RALLI BC45-BB', v_ncm_id, 11.00, 6.8, 8.2, 0.036, true, 'UN'),
    ('BC455C398-BA', 'AMORTECEDOR RALLI BC45-BA', v_ncm_id, 11.00, 6.8, 8.2, 0.036, true, 'UN'),
    ('DC465K407-DA', 'AMORTECEDOR SPECIAL DA', v_ncm_id, 9.80, 7.2, 8.8, 0.038, true, 'UN'),
    ('DC465K407-EA', 'AMORTECEDOR SPECIAL EA', v_ncm_id, 10.20, 7.5, 9.2, 0.040, true, 'UN'),
    ('2T2899515', 'COMPONENTE 2T2899', v_ncm_id, 10.20, 1.5, 2.0, 0.010, true, 'UN'),
    ('2R2899515', 'COMPONENTE 2R2899', v_ncm_id, 11.00, 1.6, 2.2, 0.012, true, 'UN'),
    ('2V2899515', 'COMPONENTE 2V2899', v_ncm_id, 13.60, 1.8, 2.4, 0.014, true, 'UN'),
    ('9583172103', 'AMORTECEDOR 9583-21', v_ncm_id, 5.40, 4.2, 5.5, 0.024, true, 'UN'),
    ('9583170003', 'AMORTECEDOR 9583-00', v_ncm_id, 4.70, 4.0, 5.2, 0.022, true, 'UN'),
    ('9583172703', 'AMORTECEDOR 9583-27', v_ncm_id, 9.30, 6.5, 8.0, 0.035, true, 'UN'),
    ('9583170703', 'AMORTECEDOR 9583-07', v_ncm_id, 4.40, 3.8, 5.0, 0.020, true, 'UN'),
    ('9408901819', 'AMORTECEDOR 9408', v_ncm_id, 13.50, 8.5, 10.5, 0.045, true, 'UN'),
    ('9793100055', 'AMORTECEDOR 9793', v_ncm_id, 15.20, 9.0, 11.0, 0.050, true, 'UN'),
    ('3198836-4', 'AMORTECEDOR 3198 V4', v_ncm_id, 11.50, 7.0, 8.5, 0.040, true, 'UN'),
    ('1629722', 'AMORTECEDOR 1629', v_ncm_id, 6.90, 5.0, 6.2, 0.028, true, 'UN'),
    ('3198836', 'AMORTECEDOR 3198 BASE', v_ncm_id, 11.50, 7.0, 8.5, 0.040, true, 'UN'),
    ('20453256; 20889132; 21111932; 20453258; 20889136; 21111942', 'MULTI-REF KIT', v_ncm_id, 19.50, 12.0, 15.0, 0.070, true, 'UN'),
    ('1075478', 'AMORTECEDOR 1075', v_ncm_id, 7.60, 5.2, 6.5, 0.028, true, 'UN'),
    ('3198859', 'AMORTECEDOR 3198-59', v_ncm_id, 11.50, 7.0, 8.5, 0.040, true, 'UN'),
    ('1629668', 'AMORTECEDOR 1629 REFORC', v_ncm_id, 13.10, 8.8, 10.8, 0.050, true, 'UN'),
    ('3198859-3', 'AMORTECEDOR 3198 V3', v_ncm_id, 11.50, 7.0, 8.5, 0.040, true, 'UN'),
    ('500348789', 'AMORTECEDOR 5003', v_ncm_id, 4.40, 3.8, 5.0, 0.022, true, 'UN'),
    ('41005911', 'AMORTECEDOR 4100', v_ncm_id, 6.20, 5.5, 7.0, 0.030, true, 'UN'),
    ('97383885', 'AMORTECEDOR 9738', v_ncm_id, 17.80, 10.0, 12.0, 0.055, true, 'UN'),
    ('500387621', 'AMORTECEDOR 5003-21', v_ncm_id, 10.20, 7.2, 8.8, 0.038, true, 'UN'),
    ('504060241', 'AMORTECEDOR 5040', v_ncm_id, 17.80, 10.5, 12.5, 0.060, true, 'UN');

    -- 6. CADASTRO DE IMPORTADOR E EXPORTADOR
    INSERT INTO edc.importadores ("RazaoSocial", "Cnpj", "UF", "RegimeTributario", "AliquotaIcmsPadrao", "FlAtivo") 
    VALUES ('RALLI COMPONENTES AUTOMOTIVOS', '00.000.000/0001-99', 'PR', 'Lucro Presumido', 0.18, true) RETURNING "Id" INTO v_importador_id;

    INSERT INTO edc.exportadores ("Nome", "Pais", "FlAtivo") 
    VALUES ('SHANGHAI RALLI PARTS CO., LTD', 'China', true) RETURNING "Id" INTO v_exportador_id;

    -- 7. CRIAÇÃO DA SIMULAÇÃO (EDC RALLI COMPLETO)
    INSERT INTO edc.simulacoes (
        "NumeroReferencia", "DataEstudo", "IdPortoOrigem", "IdPortoDestino", "IdImportador", "IdExportador",
        "CotacaoDolar", "SpreadCambio", "TipoFrete", "ValorFreteInternacional", "ValorSeguroInternacional", "Status"
    ) VALUES (
        'EDC-RALLI-001-COMPLETO', CURRENT_TIMESTAMP, v_porto_origem_id, v_porto_destino_id, v_importador_id, v_exportador_id,
        5.16, 0.05, 'FCL 40 HQ', 3500.00, 150.00, 'Aprovado'
    ) RETURNING "Id" INTO v_simulacao_id;

    -- 8. VINCULAR TODOS OS 47 ITENS À SIMULAÇÃO COM QUANTIDADES DA PLANILHA
    INSERT INTO edc.simulacao_itens ("IdSimulacao", "IdProduto", "Quantidade", "ValorFobUnitario", "PesoLiquidoTotal", "PesoBrutoTotal", "CubagemTotal")
    SELECT v_simulacao_id, "Id", 
           CASE 
             WHEN "Referencia" IN ('1384624','1515117','1515118','1777207','1629668') THEN 300 
             ELSE 100 
           END,
           "PrecoFobBase",
           "PesoLiquido" * (CASE WHEN "Referencia" IN ('1384624','1515117','1515118','1777207','1629668') THEN 300 ELSE 100 END),
           "PesoBruto" * (CASE WHEN "Referencia" IN ('1384624','1515117','1515118','1777207','1629668') THEN 300 ELSE 100 END),
           "CubagemM3" * (CASE WHEN "Referencia" IN ('1384624','1515117','1515118','1777207','1629668') THEN 300 ELSE 100 END)
    FROM edc.produtos 
    WHERE "FlAtivo" = true;

    -- 9. VINCULAR DESPESAS PADRÃO À SIMULAÇÃO
    INSERT INTO edc.simulacao_despesas ("IdSimulacao", "NomeDespesa", "Valor", "Moeda", "MetodoRateio")
    SELECT v_simulacao_id, "Nome", "ValorPadrao", "Moeda", 
           CASE WHEN "Nome" LIKE '%FRETE%' OR "Nome" LIKE '%TRS%' THEN 'Peso' ELSE 'Quantidade' END
    FROM edc.taxas_aduaneiras;

END $$;
