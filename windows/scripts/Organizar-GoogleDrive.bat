@echo off
chcp 65001 > nul
title Organizador Master - Google Drive
echo ========================================================
echo       ORGANIZADOR MASTER - GOOGLE DRIVE
echo ========================================================
echo.
echo Arraste e solte a pasta do seu Google Drive descompactado aqui,
echo ou digite o caminho completo e pressione ENTER:
echo.
set /p DRIVEPATH="Caminho da Pasta: "

if "%DRIVEPATH%"=="" (
    echo Caminho nao informado. Encerrando...
    pause
    exit /b
)

:: Remove aspas extras se existirem
set DRIVEPATH=%DRIVEPATH:"=%

cd /d "%~dp0\.."
echo.
echo Deseja apenas SIMULAR antes de mover? (S/N)
set /p SIMULA="Escolha: "

if /i "%SIMULA%"=="S" (
    python main.py --drive "%DRIVEPATH%" --dry-run
) else (
    python main.py --drive "%DRIVEPATH%"
)

echo.
echo Processo finalizado!
pause
