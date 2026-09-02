@echo off
chcp 65001 > nul
echo =================================================================
echo    INICIANDO SETUP E INSTALACAO DE PROGRAMAS (WINDOWS MASTER)
echo =================================================================
echo.
echo Solicitando privilégios de administrador...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0\Instalar-Programas-PC.ps1"

pause
