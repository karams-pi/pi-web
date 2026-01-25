# Guia de Deploy Gratuito no Render.com

Como você busca uma alternativa **gratuita** e que funcione bem com sua aplicação, a melhor recomendação hoje é o **Render.com**.

O Render possui um "Nível Gratuito" (Free Tier) generoso que suporta:
1.  **Banco de Dados PostgreSQL** (Gerenciado).
2.  **Web Service** (Para rodar seu Backend com Docker).
3.  **Static Site** (Para hospedar seu Frontend React).

> **Diferença Importante:**  
> Na nuvem gratuita (PaaS), não rodamos tudo em um único "Docker Compose". Rodamos cada peça separada conectada pela internet. O Docker Compose continua útil para testar tudo junto no seu computador!

---

## 🚀 Passo a Passo no Render

### Pré-requisitos
- Seu código deve estar no **GitHub**.
- Crie uma conta em [render.com](https://render.com).

---

### Passo 1: O Banco de Dados (PostgreSQL)

1.  No Dashboard do Render, clique em **New +** e selecione **PostgreSQL**.
2.  **Name**: `pi-db` (ou outro de sua preferência).
3.  **Database**: `pi_db`.
4.  **User**: `pi`.
5.  **Region**: Escolha a mais próxima (ex: Ohio ou Frankfurt).
6.  **Instance Type**: Selecione "Free".
7.  Clique em **Create Database**.
8.  **IMPORTANTE**: Quando criar, procure por **"Internal Database URL"** e **"External Database URL"**. Copie a "Internal Database URL" para usar no próximo passo (ela começa com `postgres://...`).

---

### Passo 2: O Backend (Docker)

1.  Clique em **New +** e selecione **Web Service**.
2.  Conecte seu repositório do GitHub.
3.  Configurações:
    -   **Name**: `pi-backend`.
    -   **Root Directory**: `backend`.
    -   **Environment**: **Docker**.
    -   **Region**: A mesma do banco.
    -   **Instance Type**: Free.
4.  **Environment Variables** (Variáveis de Ambiente):
    Adicione as seguintes chaves:
    -   `ASPNETCORE_URLS`: `http://0.0.0.0:10000` (O Render usa a porta 10000).
    -   `ConnectionStrings__DefaultConnection`: Cole a **Internal Database URL** que você copiou do passo 1.
5.  Clique em **Create Web Service**.
6.  Aguarde o deploy. Quando terminar, você terá uma URL (ex: `https://pi-backend.onrender.com`). **Copie essa URL**.

---

### Passo 3: O Frontend (React)

1.  Clique em **New +** e selecione **Static Site**. (É melhor que Docker para frontend pois é mais rápido e usa CDN).
2.  Conecte o mesmo repositório do GitHub.
3.  Configurações:
    -   **Name**: `pi-web`.
    -   **Root Directory**: `frontend/pi-ui` (Apenas o caminho da pasta, não a URL completa do GitHub).
    -   **Build Command**: `npm install && npm run build`.
    -   **Publish Directory**: `dist`.
    -   **Instance Type**: Free.
4.  **Environment Variables**:
    -   `VITE_API_BASE`: Cole a URL do seu Backend (ex: `https://pi-backend.onrender.com`).
        -   *Importante*: Não coloque barra no final.
    -   `NODE_VERSION`: `22` (Ou `20.19.0`).
        -   *Isso é necessário pois o Vite 7 exige Node.js versão 20.19+ ou 22+*.
5.  Clique em **Create Static Site**.

---

### 🎉 Conclusão

1.  O Render vai construir seu site e te dar uma URL final (ex: `https://pi-web.onrender.com`).
2.  Acesse essa URL.
3.  Seu Frontend vai chamar o Backend na nuvem, que vai salvar os dados no PostgreSQL na nuvem.

### Resumo da Arquitetura

| Componente | Onde roda? | Custo |
| :--- | :--- | :--- |
| **Frontend** | Render Static Site | Grátis |
| **Backend** | Render Web Service (Docker) | Grátis (Desliga após inatividade*) |
| **Banco** | Render PostgreSQL | Grátis (Expira a cada 90 dias, precisa renovar) |

*\*Nota: No plano Free, o Backend pode demorar uns 50 segundos para "acordar" na primeira requisição após ficar parado. Isso é normal.*

---

## 🛠️ Solução de Problemas (Troubleshooting)

Se você está vendo **"Failed to fetch"** ou erros de conexão:

### 1. Verifique as Variáveis do Frontend (Static Site)
No dashboard do Render, vá em **Environment**.
- Certifique-se de que `VITE_API_BASE` existe.
- O valor deve ser a URL do seu Backend (ex: `https://pi-backend.onrender.com`).
- **Importante**: Deve ser `HTTPS`, não `HTTP`, senão o navegador bloqueia (Mixed Content).

### 2. Verifique os Logs do Backend (Web Service)
No dashboard do Render, vá em **Logs**.
- Veja se a aplicação iniciou corretamente (`Application started. Press Ctrl+C to shut down.`).
- Se houver erro de **Database**, verifique se a variável `ConnectionStrings__DefaultConnection` está correta.
    - Ela deve ser a **Internal Database URL** (começa com `postgres://`).
    - Às vezes o Render muda a senha ou o host se você recriou o banco. Copie novamente a string de conexão do Dashboard do Banco de Dados.

### 3. Teste o Backend Direto
Abra a URL do backend no navegador (ex: `https://pi-backend.onrender.com/swagger`).
- Se o Swagger carregar, o backend está no ar.
- Se der "502 Bad Gateway" ou ficar carregando infinitamente, o backend não subiu (verifique os logs).

### 4. Permissões de Rede (CORS)
O código já está configurado para aceitar conexões (`AllowAnyOrigin`), então isso não deve ser o problema, a menos que você tenha alterado `Program.cs`.
