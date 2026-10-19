@echo off
title Restauracao Automatizada Skyrim SE
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup_skyrim.ps1"
pause
