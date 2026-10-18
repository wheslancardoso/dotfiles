@echo off
chcp 65001 > nul
echo =================================================================
echo    NOMEAR DISCOS E PARTICOES NO WINDOWS EXPLORER
echo =================================================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Nomear-Discos.ps1"

pause
