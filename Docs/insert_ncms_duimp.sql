-- ==========================================================================
-- SCRIPT DE INSERÇÃO DE NCMS DO EXTRATO DA DUIMP
-- Destinado à base de Produção
-- Descrições preenchidas apenas com '.' conforme solicitado
-- ==========================================================================

BEGIN TRANSACTION;

-- 1. ADIÇÃO 1 - NCM: 8418.69.99
INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
SELECT '8418.69.99', '.', 0.2000, 0.0325, 0.0210, 0.0965, 0.0000, true
WHERE NOT EXISTS (
    SELECT 1 FROM edc.ncms 
    WHERE "Codigo" = '8418.69.99' 
      AND "AliquotaII" = 0.2000 
      AND "AliquotaIPI" = 0.0325 
      AND "AliquotaPis" = 0.0210 
      AND "AliquotaCofins" = 0.0965
);

-- 2. ADIÇÃO 2 - NCM: 8536.50.90
INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
SELECT '8536.50.90', '.', 0.1600, 0.0975, 0.0210, 0.0965, 0.0000, true
WHERE NOT EXISTS (
    SELECT 1 FROM edc.ncms 
    WHERE "Codigo" = '8536.50.90' 
      AND "AliquotaII" = 0.1600 
      AND "AliquotaIPI" = 0.0975 
      AND "AliquotaPis" = 0.0210 
      AND "AliquotaCofins" = 0.0965
);

-- 3. ADIÇÃO 3 - NCM: 8413.81.00
INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
SELECT '8413.81.00', '.', 0.1260, 0.0000, 0.0210, 0.1025, 0.0000, true
WHERE NOT EXISTS (
    SELECT 1 FROM edc.ncms 
    WHERE "Codigo" = '8413.81.00' 
      AND "AliquotaII" = 0.1260 
      AND "AliquotaIPI" = 0.0000 
      AND "AliquotaPis" = 0.0210 
      AND "AliquotaCofins" = 0.1025
);

-- 4. ADIÇÃO 4 - NCM: 8501.40.19
INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
SELECT '8501.40.19', '.', 0.1620, 0.0650, 0.0210, 0.0965, 0.0000, true
WHERE NOT EXISTS (
    SELECT 1 FROM edc.ncms 
    WHERE "Codigo" = '8501.40.19' 
      AND "AliquotaII" = 0.1620 
      AND "AliquotaIPI" = 0.0650 
      AND "AliquotaPis" = 0.0210 
      AND "AliquotaCofins" = 0.0965
);

-- 5 & 6. ADIÇÃO 5 & 6 - NCM: 8418.99.00
INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
SELECT '8418.99.00', '.', 0.1260, 0.0975, 0.0210, 0.0965, 0.0000, true
WHERE NOT EXISTS (
    SELECT 1 FROM edc.ncms 
    WHERE "Codigo" = '8418.99.00' 
      AND "AliquotaII" = 0.1260 
      AND "AliquotaIPI" = 0.0975 
      AND "AliquotaPis" = 0.0210 
      AND "AliquotaCofins" = 0.0965
);

-- 7. ADIÇÃO 7 - NCM: 3917.39.00
INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
SELECT '3917.39.00', '.', 0.1600, 0.0325, 0.0210, 0.0965, 0.0000, true
WHERE NOT EXISTS (
    SELECT 1 FROM edc.ncms 
    WHERE "Codigo" = '3917.39.00' 
      AND "AliquotaII" = 0.1600 
      AND "AliquotaIPI" = 0.0325 
      AND "AliquotaPis" = 0.0210 
      AND "AliquotaCofins" = 0.0965
);

-- 8. ADIÇÃO 8 - NCM: 8421.99.99
INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
SELECT '8421.99.99', '.', 0.1260, 0.0520, 0.0210, 0.1025, 0.0000, true
WHERE NOT EXISTS (
    SELECT 1 FROM edc.ncms 
    WHERE "Codigo" = '8421.99.99' 
      AND "AliquotaII" = 0.1260 
      AND "AliquotaIPI" = 0.0520 
      AND "AliquotaPis" = 0.0210 
      AND "AliquotaCofins" = 0.1025
);

-- 9. ADIÇÃO 9 - NCM: 4819.10.00
INSERT INTO edc.ncms ("Codigo", "Descricao", "AliquotaII", "AliquotaIPI", "AliquotaPis", "AliquotaCofins", "AliquotaIcmsPadrao", "FlAtivo")
SELECT '4819.10.00', '.', 0.1440, 0.1500, 0.0210, 0.0965, 0.0000, true
WHERE NOT EXISTS (
    SELECT 1 FROM edc.ncms 
    WHERE "Codigo" = '4819.10.00' 
      AND "AliquotaII" = 0.1440 
      AND "AliquotaIPI" = 0.1500 
      AND "AliquotaPis" = 0.0210 
      AND "AliquotaCofins" = 0.0965
);

COMMIT;
