-- ==============================================================================
-- SCRIPT DE CORREÇÃO DE DUPLICAÇÃO DE FRETES E ITENS DE FRETE (PRODUÇÃO / LOCAL)
-- ==============================================================================
-- Descrição:
-- 1. Identifica e unifica itens de frete duplicados (ex: "Frete até o porto de Paranaguá" vs "Frete até o Porto de Paranaguá", "FCA Fábrica" vs "FCA (Fábrica)").
-- 2. Migra com segurança todas as configurações de frete (valores e flags) de TODOS os fornecedores para os itens canônicos (ID 1, 2, 3, 4, 5, 18).
-- 3. Remove os itens duplicados de pi.frete_item e pi.configuracoes_frete_item.
-- 4. Padroniza a nomenclatura dos itens oficiais.
-- 5. Garante um registro padrão global (id_fornecedor IS NULL) para cada item oficial.
-- 6. Cria índices únicos para impedir DEFINITIVAMENTE futuras duplicações.
-- 7. Redefine as sequências (sequences) para evitar erro de chave duplicada.
-- ==============================================================================

BEGIN;

SET client_encoding TO 'UTF8';
SET search_path TO pi, public;

-- Passo 1: Criar tabela temporária de mapeamento de IDs duplicados para o ID canônico (menor ID por tipo e nome normalizado)
CREATE TEMP TABLE frete_item_map AS
WITH normalized AS (
    SELECT 
        id, 
        id_frete, 
        nome,
        CASE 
            WHEN LOWER(nome) LIKE '%paranagu%' THEN 'porto_paranagua'
            WHEN LOWER(nome) LIKE '%portu%ria%' THEN 'desp_portuarias'
            WHEN LOWER(nome) LIKE '%despachante%' THEN 'despachante'
            WHEN LOWER(nome) LIKE '%courier%' THEN 'courier'
            WHEN LOWER(nome) LIKE '%fronteira%' THEN 'fronteira'
            WHEN LOWER(nome) LIKE '%fca%f%brica%' OR LOWER(nome) LIKE '%fca f%brica%' THEN 'fca_fabrica'
            ELSE LOWER(TRIM(nome))
        END as normalized_key
    FROM pi.frete_item
),
mapped AS (
    SELECT 
        id as duplicate_id,
        FIRST_VALUE(id) OVER (PARTITION BY id_frete, normalized_key ORDER BY id ASC) as canonical_id
    FROM normalized
)
SELECT duplicate_id, canonical_id
FROM mapped
WHERE duplicate_id != canonical_id;

-- Passo 2: Se o fornecedor já tem o item canônico, mas o canônico está com valor 0 e o duplicado tem valor > 0, atualiza o canônico
UPDATE pi.configuracoes_frete_item c_can
SET valor = c_dup.valor,
    fl_desconsidera = c_dup.fl_desconsidera
FROM pi.configuracoes_frete_item c_dup
JOIN frete_item_map m ON c_dup.id_frete_item = m.duplicate_id
WHERE c_can.id_frete_item = m.canonical_id
  AND c_can.id_fornecedor IS NOT DISTINCT FROM c_dup.id_fornecedor
  AND (c_can.valor = 0 AND c_dup.valor > 0);

-- Passo 3: Deletar registros duplicados onde o fornecedor JÁ POSSUI registro no canônico
DELETE FROM pi.configuracoes_frete_item c_dup
USING frete_item_map m, pi.configuracoes_frete_item c_can
WHERE c_dup.id_frete_item = m.duplicate_id
  AND c_can.id_frete_item = m.canonical_id
  AND c_dup.id_fornecedor IS NOT DISTINCT FROM c_can.id_fornecedor;

-- Passo 4: Para fornecedores que só tinham configuração no item duplicado (ex: Ferguile e Livintus), repontar para o canônico
UPDATE pi.configuracoes_frete_item c
SET id_frete_item = m.canonical_id
FROM frete_item_map m
WHERE c.id_frete_item = m.duplicate_id;

-- Passo 5: Deletar duplicatas residuais em configuracoes_frete_item (mantendo apenas o de maior ID/valor se houver)
DELETE FROM pi.configuracoes_frete_item a
USING pi.configuracoes_frete_item b
WHERE a.id < b.id
  AND a.id_frete_item = b.id_frete_item
  AND a.id_fornecedor IS NOT DISTINCT FROM b.id_fornecedor;

-- Passo 6: Excluir os itens de frete duplicados
DELETE FROM pi.frete_item
WHERE id IN (SELECT duplicate_id FROM frete_item_map);

-- Passo 7: Padronizar nomes oficiais dos itens de frete
UPDATE pi.frete_item SET nome = 'Frete até o Porto de Paranaguá' WHERE id = 1;
UPDATE pi.frete_item SET nome = 'Despesas Portuárias de Registro e Documentos' WHERE id = 2;
UPDATE pi.frete_item SET nome = 'Despesas c/ Despachante Aduaneiro' WHERE id = 3;
UPDATE pi.frete_item SET nome = 'Despesas Courier' WHERE id = 4;
UPDATE pi.frete_item SET nome = 'Frete rodoviário até a fronteira' WHERE id = 5;
UPDATE pi.frete_item SET nome = 'FCA (Fábrica)' WHERE id = 18;

-- Passo 8: Garantir que todo item de frete tenha um fallback global (id_fornecedor IS NULL)
INSERT INTO pi.configuracoes_frete_item (id_frete_item, valor, fl_desconsidera, id_fornecedor)
SELECT fi.id, 0.00, false, NULL
FROM pi.frete_item fi
WHERE NOT EXISTS (
    SELECT 1 FROM pi.configuracoes_frete_item cfi 
    WHERE cfi.id_frete_item = fi.id AND cfi.id_fornecedor IS NULL
);

-- Passo 9: Resetar as sequences das tabelas
SELECT setval(pg_get_serial_sequence('pi.frete_item', 'id'), COALESCE((SELECT MAX(id) FROM pi.frete_item), 1));
SELECT setval(pg_get_serial_sequence('pi.configuracoes_frete_item', 'id'), COALESCE((SELECT MAX(id) FROM pi.configuracoes_frete_item), 1));

-- Passo 10: Criar índices únicos para garantir integridade e blindar contra duplicações futuras
CREATE UNIQUE INDEX IF NOT EXISTS uq_frete_item_frete_nome 
ON pi.frete_item (id_frete, LOWER(TRIM(nome)));

CREATE UNIQUE INDEX IF NOT EXISTS uq_cfi_fornecedor_not_null 
ON pi.configuracoes_frete_item (id_frete_item, id_fornecedor) 
WHERE id_fornecedor IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_cfi_fornecedor_null 
ON pi.configuracoes_frete_item (id_frete_item) 
WHERE id_fornecedor IS NULL;

DROP TABLE frete_item_map;

COMMIT;
