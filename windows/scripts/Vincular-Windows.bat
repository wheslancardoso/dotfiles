@echo off
chcp 65001 >nul
cls
echo ======================================================
echo    ORGANIZADOR MASTER — VINCULAR PASTAS NO WINDOWS
echo ======================================================
echo.
echo Este script cria juncoes de diretorio (Junctions) transparentes
echo entre as pastas de usuario do Windows (Documents, Downloads)
echo e a sua particao de dados D:\ (ou pasta do Google Drive).
echo.
echo Resultado: Voce pode formatar o C:\ sem nunca perder seus arquivos!
echo.

set /p DRIVE_DIR=Digite a letra/caminho da particao de dados (Padrao: D:\): 
if "%DRIVE_DIR%"=="" set DRIVE_DIR=D:\

if not exist "%DRIVE_DIR%\01_Pessoal_e_Vida" (
    echo.
    echo [ERRO] Nao foi encontrada a pasta 01_Pessoal_e_Vida em %DRIVE_DIR%
    echo Verifique se a letra do drive esta correta.
    pause
    exit /b 1
)

echo.
echo Vinculando pastas para o usuario %USERNAME%...
echo.

:: Downloads -> 00_Inbox_Triagem
if exist "%USERPROFILE%\Downloads" (
    echo [INFO] Configurando Downloads -> %DRIVE_DIR%\00_Inbox_Triagem
)

:: Documents -> 01_Pessoal_e_Vida
if exist "%USERPROFILE%\Documents" (
    echo [INFO] Configurando Documents -> %DRIVE_DIR%\01_Pessoal_e_Vida
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Vincular-Windows.ps1" -DataDir "%DRIVE_DIR%"

echo.
echo ======================================================
echo    VINCULACAO CONCLUIDA COM SUCESSO!
echo ======================================================
pause
