-- Deletar registros da tabela modulo_tecido relacionados à marca 'ESTOFADO ALOHA'
DELETE FROM modulo_tecido 
WHERE id_modulo IN (
    SELECT id 
    FROM modulo 
    WHERE id_marca IN (
        SELECT id 
        FROM marca 
        WHERE nome = 'ESTOFADO ALOHA'
    )
);

-- Deletar registros da tabela modulo relacionados à marca 'ESTOFADO ALOHA'
DELETE FROM modulo 
WHERE id_marca IN (
    SELECT id 
    FROM marca 
    WHERE nome = 'ESTOFADO ALOHA'
);

-- Deletar a marca 'ESTOFADO ALOHA'
DELETE FROM marca 
WHERE nome = 'ESTOFADO ALOHA';
