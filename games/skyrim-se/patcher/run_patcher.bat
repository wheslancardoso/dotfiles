@echo off
title Patcher SkyrimSE.exe Anti-Crash
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0patcher_skyrimse.ps1"
pause
