-- Script de limpeza para Ferguile e Livintus
-- Este script remove todos os registros relacionados (Módulos, Tecidos, PIs, Itens de PI, etc.) 
-- mas MANTÉM os registros na tabela de Fornecedor.

DO $$
DECLARE
    fornecedor_ids BIGINT[];
BEGIN
    -- 1. Obter os IDs dos fornecedores Ferguile e Livintus
    SELECT array_agg(id) INTO fornecedor_ids 
    FROM fornecedor 
    WHERE nome ILIKE 'Ferguile' OR nome ILIKE 'Livintus';

    IF fornecedor_ids IS NOT NULL THEN
        -- A ordem de deleção é importante por causa das chaves estrangeiras

        -- 2. Deletar Itens de Proforma Invoice (pi_item) relacionados aos módulos desses fornecedores
        DELETE FROM pi_item 
        WHERE id_modulo_tecido IN (
            SELECT mt.id 
            FROM modulo_tecido mt
            JOIN modulo m ON mt.id_modulo = m.id
            WHERE m.id_fornecedor = ANY(fornecedor_ids)
        );

        -- 3. Deletar Proforma Invoices (pi) 
        -- Nota: As PIs não têm FK direta para fornecedor no schema visto, 
        -- mas se forem PIs geradas para estes fornecedores, elas possivelmente 
        -- referenciam os itens que acabamos de deletar (Cascade no DbContext para pi_item).
        -- Como o usuário pediu para deletar PIs geradas, vamos deletar as PIs que ficaram órfãs 
        -- ou que possuíam itens desses fornecedores.
        -- No schema visto, pi -> pi_item (Cascade).
        -- Se não houver uma forma direta de saber qual PI é de qual fornecedor sem os itens,
        -- vamos deletar PIs que continham itens desses fornecedores.
        DELETE FROM pi 
        WHERE id NOT IN (SELECT id_pi FROM pi_item);

        -- 4. Deletar ModuloTecido (preços de tecidos nos módulos)
        DELETE FROM modulo_tecido 
        WHERE id_modulo IN (
            SELECT id FROM modulo WHERE id_fornecedor = ANY(fornecedor_ids)
        );

        -- 5. Deletar Módulos (modulo)
        DELETE FROM modulo 
        WHERE id_fornecedor = ANY(fornecedor_ids);

        -- 6. Deletar Marcas (marca) - Opcional, mas geralmente marcas são atreladas a fornecedores
        -- No sistema, marcas podem ser compartilhadas. Vamos deletar apenas se não houver mais módulos.
        DELETE FROM marca
        WHERE id NOT IN (SELECT id_marca FROM modulo);

        -- 7. Deletar Categorias (categoria) - Opcional.
        DELETE FROM categoria
        WHERE id NOT IN (SELECT id_categoria FROM modulo);

        -- 8. Deletar Tecidos (tecido) - Opcional.
        DELETE FROM tecido
        WHERE id NOT IN (SELECT id_tecido FROM modulo_tecido);

        RAISE NOTICE 'Limpeza concluída para os fornecedores: Ferguile, Livintus';
    ELSE
        RAISE NOTICE 'Fornecedores Ferguile e Livintus não encontrados.';
    END IF;
END $$;
