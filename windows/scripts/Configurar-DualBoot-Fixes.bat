@echo off
chcp 65001 >nul
title Correcoes de Dual Boot (UTC, Fast Startup, Limine)
set SCRIPT_DIR=%~dp0

:: Verificar e solicitar privilégios de Administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Solicitando privilegios de Administrador...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~fn0\"' -Verb RunAs"
    exit /b
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%Configurar-DualBoot-Fixes.ps1"
