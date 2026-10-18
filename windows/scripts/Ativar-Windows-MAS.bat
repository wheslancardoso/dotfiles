@echo off
chcp 65001 > nul
echo =================================================================
echo    ATIVACAO OFICIAL WINDOWS E OFFICE (MAS - MASSGRAVE)
echo =================================================================
echo.

if exist "%~dp0MAS_AIO.cmd" (
    echo Iniciando versao local offline do MAS...
    call "%~dp0MAS_AIO.cmd"
    goto :fim
)

echo Baixando e iniciando MAS via conexao segura...
powershell -NoProfile -ExecutionPolicy Bypass -Command "& { try { iex (curl.exe -s --doh-url https://1.1.1.1/dns-query https://get.activated.win | Out-String) } catch { irm https://get.activated.win | iex } }"

:fim
pause
