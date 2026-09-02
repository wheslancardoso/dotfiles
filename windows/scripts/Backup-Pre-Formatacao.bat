@echo off
chcp 65001 > nul
echo =================================================================
echo   INICIANDO BACKUP PRE-FORMATACAO (WINDOWS MASTER)
echo =================================================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0\Backup-Pre-Formatacao.ps1"

pause
