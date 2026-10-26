@echo off
setlocal enabledelayedexpansion

:: ============================================================================
:: Launcher com Auto-Backup Blindado para Midnight Club: Los Angeles Recompiled
:: Evita perda de save por queda de energia ou crash no WinBtrfs
:: ============================================================================

set "BASE_DIR=%~dp0"
set "USERDATA_DIR=%BASE_DIR%userdata\B13EBABEBABEBABE\545407F8"
set "ACHIEV_DIR=%BASE_DIR%userdata\achievements"
set "BACKUP_ROOT=%BASE_DIR%userdata_backups_historico"

:: 1. Criar timestamp seguro
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value 2^>nul') do set "DT=%%I"
if not defined DT (
    set "STAMP=%date:~6,4%-%date:~3,2%-%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
    set "STAMP=!STAMP: =0!"
) else (
    set "STAMP=!DT:~0,4!-!DT:~4,2!-!DT:~6,2!_!DT:~8,2!!DT:~10,2!!DT:~12,2!"
)

set "CURRENT_BACKUP=%BACKUP_ROOT%\%STAMP%_pre_launch"

:: 2. Backup PRE-EXECUÇÃO (se o save existir)
if exist "%USERDATA_DIR%\00000001\mc4.sav\mc4.sav" (
    echo [*] Salvando snapshot preventivo antes de iniciar...
    mkdir "%CURRENT_BACKUP%\save" 2>nul
    mkdir "%CURRENT_BACKUP%\achievements" 2>nul
    xcopy /y /e /i /q "%USERDATA_DIR%" "%CURRENT_BACKUP%\save" >nul 2>&1
    xcopy /y /e /i /q "%ACHIEV_DIR%" "%CURRENT_BACKUP%\achievements" >nul 2>&1
    echo [+] Backup preventivo criado em: %STAMP%_pre_launch
)

:: 3. Execução do Jogo
echo [*] Iniciando Midnight Club: Los Angeles...
if exist "%BASE_DIR%Midnight Club L.A. Recompiled.exe" (
    start "" /wait "%BASE_DIR%Midnight Club L.A. Recompiled.exe"
) else if exist "%BASE_DIR%mcla.exe" (
    start "" /wait "%BASE_DIR%mcla.exe"
) else (
    echo [!] Executavel do jogo nao encontrado!
    pause
    exit /b 1
)

:: 4. Backup POS-EXECUÇÃO (ao fechar o jogo normalmente)
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value 2^>nul') do set "DT2=%%I"
if not defined DT2 (
    set "STAMP2=%date:~6,4%-%date:~3,2%-%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
    set "STAMP2=!STAMP2: =0!"
) else (
    set "STAMP2=!DT2:~0,4!-!DT2:~4,2!-!DT2:~6,2!_!DT2:~8,2!!DT2:~10,2!!DT2:~12,2!"
)

set "POST_BACKUP=%BACKUP_ROOT%\%STAMP2%_post_session"

if exist "%USERDATA_DIR%\00000001\mc4.sav\mc4.sav" (
    echo [*] Sessao encerrada. Criando backup pos-sessao...
    mkdir "%POST_BACKUP%\save" 2>nul
    mkdir "%POST_BACKUP%\achievements" 2>nul
    xcopy /y /e /i /q "%USERDATA_DIR%" "%POST_BACKUP%\save" >nul 2>&1
    xcopy /y /e /i /q "%ACHIEV_DIR%" "%POST_BACKUP%\achievements" >nul 2>&1
    echo [+] Backup pos-jogo salvo com sucesso em: %STAMP2%_post_session
)

:: 5. Limpeza de backups antigos (mantem os 20 mais recentes)
for /f "skip=20 delims=" %%D in ('dir /b /ad /o-n "%BACKUP_ROOT%" 2^>nul') do (
    rd /s /q "%BACKUP_ROOT%\%%D" >nul 2>&1
)

echo [OK] Finalizado.
timeout /t 3 >nul
