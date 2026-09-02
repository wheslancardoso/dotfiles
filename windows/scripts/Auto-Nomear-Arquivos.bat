@echo off
chcp 65001 > nul
echo ====================================================
echo   PADRONIZADOR E AUTO-NOMENCLATURA DE ARQUIVOS (ISO)
echo ====================================================
echo.
echo Este utilitário adiciona a data ISO (YYYY-MM-DD_) e limpa
echo nomes de arquivos (removendo " (1)", espaços extras, etc).
echo.

set /p PASTA_ALVO="Digite o caminho da pasta para padronizar (ou aperte ENTER para usar Downloads): "

if "%PASTA_ALVO%"=="" (
    set PASTA_ALVO=%USERPROFILE%\Downloads
)

echo.
echo Processando: %PASTA_ALVO%
echo.

cd /d "%~dp0\.."
python main.py --auto-date "%PASTA_ALVO%"

echo.
pause
