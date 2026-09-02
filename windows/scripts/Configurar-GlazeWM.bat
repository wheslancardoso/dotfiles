@echo off
chcp 65001 > nul
echo =================================================================
echo   INSTALACAO E CONFIGURACAO DO GLAZEWM (HYPRLAND STYLE)
echo =================================================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0\Configurar-GlazeWM.ps1"

pause
