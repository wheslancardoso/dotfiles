@echo off
chcp 65001 > nul
title Organizador Master - Executando Limpeza
echo ========================================================
echo       ORGANIZADOR MASTER - EXECUCAO COMPLETA
echo ========================================================
echo.
cd /d "%~dp0\.."
python main.py --all
echo.
echo Pressione qualquer tecla para fechar...
pause > nul
