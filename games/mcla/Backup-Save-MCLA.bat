@echo off
chcp 65001 >nul
color 0b
title Backup Blindado de Save - Midnight Club: Los Angeles

echo.
echo =======================================================================
echo          🏎️ BACKUP BLINDADO DE SAVE - MIDNIGHT CLUB: LOS ANGELES
echo =======================================================================
echo.

set "BASE_DIR=%~dp0"
set "USERDATA_DIR=%BASE_DIR%userdata\B13EBABEBABEBABE\545407F8"
set "ACHIEV_DIR=%BASE_DIR%userdata\achievements"
set "BACKUP_ROOT=%BASE_DIR%userdata_backups_historico"

:: 1. Obter Data e Hora exatas de forma confiavel via PowerShell
for /f "usebackq tokens=*" %%i in (`powershell -NoProfile -Command "Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'"`) do set "TIMESTAMP=%%i"

if "%TIMESTAMP%"=="" (
    set "TIMESTAMP=%date:~6,4%-%date:~3,2%-%date:~0,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%"
    set "TIMESTAMP=%TIMESTAMP: =0%"
)

set "DEST_FOLDER=%BACKUP_ROOT%\Save_%TIMESTAMP%"

:: 2. Validar se o save existe
if not exist "%USERDATA_DIR%\00000001\mc4.sav\mc4.sav" (
    color 0c
    echo [!] AVISO: Nenhum save ativo encontrado em:
    echo     %USERDATA_DIR%\00000001\mc4.sav\mc4.sav
    echo.
    echo Certifique-se de que o jogo ja gerou um save ou execute o jogo primeiro.
    echo.
    pause
    exit /b 1
)

:: 3. Criar a nova pasta com timestamp e copiar tudo
echo [*] Gerando snapshot historico...
echo     Destino: %DEST_FOLDER%
echo.

mkdir "%DEST_FOLDER%\save\00000001\mc4.sav" 2>nul
mkdir "%DEST_FOLDER%\save\Headers\00000001" 2>nul
mkdir "%DEST_FOLDER%\achievements" 2>nul

xcopy /y /q "%USERDATA_DIR%\00000001\mc4.sav\mc4.sav" "%DEST_FOLDER%\save\00000001\mc4.sav\" >nul 2>&1
xcopy /y /q "%USERDATA_DIR%\Headers\00000001\mc4.sav.header" "%DEST_FOLDER%\save\Headers\00000001\" >nul 2>&1
xcopy /y /q "%ACHIEV_DIR%\545407F8.toml" "%DEST_FOLDER%\achievements\" >nul 2>&1

:: 4. Validar gravacao do backup
if exist "%DEST_FOLDER%\save\00000001\mc4.sav\mc4.sav" (
    color 0a
    echo [OK] SUCESSO! Save e conquistas salvos com seguranca.
    echo      Pasta criada: Save_%TIMESTAMP%
) else (
    color 0c
    echo [!] FALHA ao copiar arquivos para a pasta de backup.
    pause
    exit /b 1
)

echo.
echo =======================================================================
echo Histórico de backups salvos em:
echo %BACKUP_ROOT%
echo =======================================================================
echo.
timeout /t 3 >nul
