@echo off
chcp 65001 > nul
title Organizador Master - Simulacao (Dry-Run)
echo ========================================================
echo       ORGANIZADOR MASTER - MODO SIMULACAO (DRY-RUN)
echo ========================================================
echo Nenhum arquivo sera movido. Apenas exibira o que aconteceria.
echo.
cd /d "%~dp0\.."
python main.py --all --dry-run
echo.
echo Pressione qualquer tecla para fechar...
pause > nul
