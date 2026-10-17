@echo off
chcp 65001 >nul
title Mover Pastas de Usuario para o Disco D:\
set SCRIPT_DIR=%~dp0

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Solicitando privilegios de Administrador...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~fn0\"' -Verb RunAs"
    exit /b
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%Mover-Pastas-Usuario-Para-D.ps1"
