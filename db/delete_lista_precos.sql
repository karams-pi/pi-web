-- Script para limpar registros das tabelas solicitadas
-- Ordem de exclusão respeita as Foreign Keys (Filhos -> Pais)
-- 1. Remover ModuloTecido (depende de Modulo e Tecido)
DELETE FROM modulo_tecido;
-- 2. Remover Modulo (depende de Marca, Categoria e Fornecedor)
DELETE FROM modulo;
-- 3. Remover Marca e Categoria (agora que Modulo foi removido)
DELETE FROM marca;
DELETE FROM categoria;
-- Nota: Se houver registros na tabela 'pi_item' (Proforma Invoice) vinculados a esses módulos,
-- o banco de dados impedirá a exclusão para manter a integridade.
-- Caso precise limpar TUDO, descomente as linhas abaixo antes de rodar o script:
-- DELETE FROM pi_item;
-- DELETE FROM pi;