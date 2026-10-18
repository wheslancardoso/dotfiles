@echo off
chcp 65001 > nul
echo =================================================================
echo    SELETOR DE PAPEIS DE PAREDE (ARCH HYPRLAND STYLE)
echo =================================================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Trocar-Wallpaper.ps1"
