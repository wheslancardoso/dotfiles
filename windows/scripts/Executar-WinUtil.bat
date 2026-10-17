@echo off
chcp 65001 >nul
title Chris Titus Tech WinUtil
set SCRIPT_DIR=%~dp0

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Solicitando privilegios de Administrador...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~fn0\"' -Verb RunAs"
    exit /b
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://christitus.com/win | iex"
