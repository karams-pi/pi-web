# Manual de Restauração do Banco de Dados (pi_db)

Este guia descreve como restaurar o banco de dados `pi_db` a partir do arquivo de backup `render.backup` localizado na pasta `Docs`.

## Pré-requisitos
- O Docker deve estar em execução.
- O container do banco de dados deve se chamar `pi-postgres`.
- O arquivo `Docs/render.backup` deve estar presente na máquina local.

## Passo a Passo para Restauração

### 1. Copiar o arquivo para o Container
Abra um terminal (PowerShell ou Prompt de Comando) na pasta raiz do projeto e execute:
```powershell
docker cp .\Docs\render.backup pi-postgres:/tmp/render.backup
```

### 2. Encerrar conexões ativas
Para garantir que o banco possa ser recriado, encerre todas as sessões conectadas ao `pi_db`:
```powershell
docker exec -i pi-postgres psql -U pi -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'pi_db' AND pid <> pg_backend_pid();"
```

### 3. Recriar o Banco de Dados
Remova e crie o banco novamente:
```powershell
docker exec -i pi-postgres psql -U pi -d postgres -c "DROP DATABASE IF EXISTS pi_db;"
docker exec -i pi-postgres psql -U pi -d postgres -c "CREATE DATABASE pi_db OWNER pi;"
```

### 4. Executar a Restauração
Execute o comando de restauração:
```powershell
docker exec -i pi-postgres pg_restore -U pi -d pi_db -v /tmp/render.backup
```
*Nota: É normal aparecerem alguns avisos de "error" sobre permissões ou constraints menores ao final da execução. Se o passo seguinte mostrar dados, a restauração foi bem-sucedida.*

### 5. Verificar a Restauração
Execute um comando simples para ver se as tabelas foram criadas e populadas:
```powershell
docker exec -i pi-postgres psql -U pi -d pi_db -c "\dt"
docker exec -i pi-postgres psql -U pi -d pi_db -c "SELECT count(*) FROM pi;"
```

---
**IMPORTANTE:** Certifique-se de que o sistema não esteja salvando dados no momento da restauração, pois os dados atuais serão substituídos pelo conteúdo do backup.
