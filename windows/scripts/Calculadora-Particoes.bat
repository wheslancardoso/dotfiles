@echo off
chcp 65001 > nul
echo =================================================================
echo   CALCULADORA DE PARTICAO DE DISCO (WINDOWS MASTER)
echo =================================================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0\Calculadora-Particoes.ps1"

pause
