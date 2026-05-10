# Tarefas - Migração de Schema (public -> pi)

- [x] Criar script SQL de migração (`db/migration_schema_pi.sql`)
- [x] Modificar `AppDbContext.cs` para usar o schema `pi`
- [x] Gerar nova migration do EF Core para sincronizar o estado do código
- [x] Validar script SQL e alterações no backend
- [x] Refatorar rotas para prefixo /api/pi/ e atualizar frontend
- [x] Realizar Merge e Push para o GitHub (main)
- [ ] (Opcional) Limpeza de views após validação final em produção
