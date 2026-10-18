@echo off
chcp 65001 > nul
echo =================================================================
echo    INICIANDO SUITE DE SETUP WINDOWS (DIRETO DO PENDRIVE / REPO)
echo =================================================================
echo.

if exist "%~dp0scripts_windows\Instalar-Programas-PC.bat" (
    cd /d "%~dp0scripts_windows"
) else if exist "%~dp0scripts\Instalar-Programas-PC.bat" (
    cd /d "%~dp0scripts"
) else (
    cd /d "%~dp0"
)

call "Instalar-Programas-PC.bat"
