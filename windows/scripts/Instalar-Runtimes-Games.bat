@echo off
chcp 65001 >nul
title Instalador de Runtimes (Visual C++ AIO, .NET, DirectX)
set SCRIPT_DIR=%~dp0

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Solicitando privilegios de Administrador...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~fn0\"' -Verb RunAs"
    exit /b
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%Instalar-Runtimes-Games.ps1"
