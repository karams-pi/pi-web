# Projeto PI-Web

Sistema de gerenciamento de Proforma Invoice (PI) e itens relacionados.

## 🏗️ Arquitetura

O projeto é dividido em duas partes principais:

- **Backend**: API construída com .NET 8 (ASP.NET Core), utilizando Entity Framework Core para persistência de dados (PostgreSQL).
- **Frontend**: Aplicação web moderna construída com React, Vite e TypeScript.

## 🚀 Como Começar

### Pré-requisitos

- [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
- [Node.js](https://nodejs.org/) (versão 18 ou superior)
- [Docker](https://www.docker.com/) (para rodar o banco de dados via docker-compose)

### Configuração do Ambiente

1. **Banco de Dados**:
   ```powershell
   docker-compose up -d
   ```

2. **Backend**:
   - Entre na pasta `backend/Pi.Api`.
   - Copie `appsettings.Development.json` e configure a string de conexão se necessário.
   - Execute: `dotnet run`

3. **Frontend**:
   - Entre na pasta `frontend/pi-ui`.
   - Instale as dependências: `npm install`
   - Execute: `npm run dev`

## 📁 Estrutura de Pastas

- `backend/`: Código fonte da API .NET.
- `frontend/`: Código fonte da aplicação React.
- `db/`: Scripts e dados relacionados ao banco de dados.
- `Docs/`: Documentação adicional do projeto.
- `Diagnostics/`: Logs de build e arquivos de diagnóstico (não versionados).

## 🛠️ Comandos Principais (Root)

Na raiz do projeto, você pode usar os seguintes comandos (requer `npm` instalado):

- `npm run backend`: Inicia o backend.
- `npm run frontend`: Inicia o frontend.
- `npm run backend:build`: Compila o backend.
- `npm run frontend:install`: Instala dependências do frontend.

---
Desenvolvido com profissionaisismo e foco em produtividade.
