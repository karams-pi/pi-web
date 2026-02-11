/*
 Script para limpar dados de importação e PIs.
 CUIDADO: Isso apagará TODOS os dados das tabelas listadas abaixo!
*/

-- O comando TRUNCATE limpa os dados rapidamente.
-- RESTART IDENTITY: Reinicia os contadores de ID para 1.
-- CASCADE: Remove dados de outras tabelas que dependem destas (ex: chaves estrangeiras).

TRUNCATE TABLE 
    pi, 
    pi_item, 
    modulo_tecido, 
    modulo, 
    categoria 
RESTART IDENTITY CASCADE;

-- Observação: A tabela 'modelo' antiga não foi incluída pois não é mais usada pelo sistema atual.
-- Se ela ainda existir no banco e quiser limpá-la, descomente a linha abaixo:
-- TRUNCATE TABLE modelo RESTART IDENTITY CASCADE;
