@echo off
chcp 65001 > nul
echo Solicitando privilegios de administrador...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0\Instalar-Pacote-Essencial.ps1"
pause
