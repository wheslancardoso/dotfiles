@echo off
chcp 65001 >nul
title Instalador Offline do Brave Browser
set SCRIPT_DIR=%~dp0

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Solicitando privilegios de Administrador...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~fn0\"' -Verb RunAs"
    exit /b
)

if exist "%SCRIPT_DIR%BraveBrowserStandaloneSetup.exe" (
    echo [OK] Instalando Brave Browser a partir do pacote offline...
    start /wait "" "%SCRIPT_DIR%BraveBrowserStandaloneSetup.exe" /silent /install
    echo [OK] Brave Browser instalado com sucesso!
) else (
    echo [INFO] Baixando e instalando Brave via Winget...
    winget install Brave.Brave --exact --silent --accept-package-agreements --accept-source-agreements
)

echo.
echo =================================================================
echo   DICA DE SINCRONIZAÇÃO DO BRAVE (SYNC CHAIN):
echo =================================================================
echo O Brave Sync utiliza uma cadeia de 25 palavras (BIP39).
echo As primeiras 24 palavras sao o segredo fixo da sua conta.
echo A 25ª palavra muda a cada 24 horas por seguranca temporal.
echo Para sincronizar:
echo 1. Abra o Brave ➔ Configuracoes (brave://settings/braveSync)
echo 2. Clique em 'Tenho um codigo de sincronizacao'
echo 3. No seu outro dispositivo (celular ou Linux), va em 'Ver Codigo'
echo    e copie a frase completa atualizada!
echo =================================================================
echo.
pause
