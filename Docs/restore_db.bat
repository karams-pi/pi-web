@echo off
echo ==========================================
echo Restaurando banco de dados render.backup
echo ==========================================

cd /d "%~dp0"

if not exist render.backup (
    echo Erro: O arquivo render.backup nao foi encontrado nesta pasta.
    pause
    exit /b 1
)

echo Executando restore no container pi-postgres...
echo.
docker exec -i pi-postgres pg_restore -U pi -d pi_db -O -x -c -1 < render.backup

echo.
if %errorlevel% neq 0 (
    echo Ocorreu um erro durante o restore. Verifique os logs acima.
) else (
    echo Restore concluido com sucesso!
)

pause
