# Como Compilar o Frontend e Gerar o Dist

Este guia descreve o passo a passo para compilar o projeto frontend (pi-ui) e preparar os arquivos para envio ao GitHub.

## Pré-requisitos

Certifique-se de ter o **Node.js** instalado na sua máquina (versão 22 ou superior, confira com `node -v`).

## Passo 1: Acessar a pasta do frontend

Abra o terminal (PowerShell ou CMD) e navegue até a pasta do projeto frontend:

```bash
cd c:\Portifolio\pi-web\frontend\pi-ui
```

## Passo 2: Instalar dependências (caso não tenha feito)

Se for a primeira vez ou se houver novas dependências, rode:

```bash
npm install
```

## Passo 3: Compilar o projeto (Build)

Este comando irá gerar os arquivos estáticos otimizados na pasta `dist`.

```bash
npm run build
```

> **Nota:** Certifique-se de que não ocorreram erros durante o build. Se houver erros de TypeScript ou Lint, eles precisam ser corrigidos antes.

## Passo 4: Versionar a pasta `dist` (Opcional)

Por padrão, a pasta `dist` costuma ser ignorada pelo git (`.gitignore`). Se você deseja **forçar** o envio dela para o GitHub (para deploy manual ou hospedagem estática simples), você precisa adicioná-la manualmente.

1.  Verifique se o arquivo `.gitignore` na pasta `frontend/pi-ui` (ou na raiz) contém `dist` ou `/dist`.
2.  Se você realmente quer subir essa pasta, você pode remover a linha do `.gitignore` ou forçar a adição:

```bash
git add dist -f
```

## Passo 5: Enviar para o GitHub

Após adicionar os arquivos (incluindo o `dist` se foi sua intenção), faça o commit e o push:

```bash
# Volte para a raiz do repositório se necessário
cd c:\Portifolio\pi-web

# Adicione todas as mudanças
git add .

# Commit
git commit -m "Build frontend atualizado"

# Enviar
git push
```

## Resumo Rápido

```bash
cd frontend/pi-ui
npm install
npm run build
cd ../..
git add .
git commit -m "Update build"
git push
```
