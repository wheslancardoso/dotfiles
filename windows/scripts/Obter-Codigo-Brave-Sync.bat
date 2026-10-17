@echo off
chcp 65001 >nul
title Gerador Oficial Brave Sync (25 Palavras)
set SCRIPT_DIR=%~dp0

powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%Obter-Codigo-Brave-Sync.ps1"
