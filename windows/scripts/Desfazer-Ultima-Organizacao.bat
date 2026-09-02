@echo off
chcp 65001 > nul
echo ====================================================
echo   DESFAZER ULTIMA ORGANIZACAO (ROLLBACK)
echo ====================================================
echo.

cd /d "%~dp0\.."
python main.py --undo

echo.
pause
