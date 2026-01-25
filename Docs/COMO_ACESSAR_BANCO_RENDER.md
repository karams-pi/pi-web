# Como conectar no Banco de Dados do Render (PostgreSQL) usando PgAdmin

## 1. Pegar os dados de Conexão no Render
1. Acesse o [Dashboard do Render](https://dashboard.render.com/).
2. Clique no seu serviço de **PostgreSQL** (o banco de dados).
3. Role a página para baixo até achar a seção **Connections**.
4. Procure pela aba **"External Connection"** (Conexão Externa).
5. Copie os dados:
   - **Hostname**: (ex: `dpg-xxxx-a.oregon-postgres.render.com`)
   - **Port**: `5432`
   - **Database**: (ex: `pi_web_db`)
   - **Username**: (ex: `pi_web_user`)
   - **Password**: (Clique no botão "Copy" para copiar a senha)

## 2. Configurar no PgAdmin 4
1. Abra o **PgAdmin 4**.
2. Clique com o botão direito em **Servers** > **Register** > **Server...**.

### Aba "General"
- **Name**: Coloque um nome para identificar (ex: `Pi Web Render`).

### Aba "Connection"
- **Host name/address**: Cole o *Hostname* copiado do Render.
- **Port**: `5432`
- **Maintenance database**: Cole o nome do *Database*.
- **Username**: Cole o *Username*.
- **Password**: Cole a *Password*.
- **Save password?**: Marque essa opção para não precisar digitar toda vez.

## 3. Conectar
1. Clique em **Save**.
2. O servidor vai aparecer na lista à esquerda. Dê dois cliques para conectar.
3. Vá em **Databases** > (Seu Banco) > **Schemas** > **public** > **Tables**.
4. Você verá todas as tabelas (`clientes`, `fornecedor`, `modulo`, etc) criadas.

---
**Obs**: Se a conexão falhar, verifique se o seu IP não está bloqueado nas configurações do Render (geralmente ele aceita conexões de "0.0.0.0/0", ou seja, qualquer IP, por padrão).

## Solução de Problemas Comuns

### Erro: `[Errno 11001] getaddrinfo failed`
Este erro significa que o **Host name/address** está incorreto ou o computador não conseguiu encontrar esse endereço na internet.
**Verifique:**
1. **Espaços em branco**: Veja se não ficou um espaço antes ou depois do endereço (ex: " dpg-..." ou "...com ").
2. **Endereço Completo**: Você colou apenas o endereço (ex: `dpg-c12345.oregon-postgres.render.com`)? **Não** cole o começo `postgres://` nem o final com a porta.
3. **Conexão Externa**: Cerifique-se de estar usando o **External Hostname** do Render, não o Internal.
