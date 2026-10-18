@echo off
chcp 65001 > nul
echo =================================================================
echo    ATIVACAO OFICIAL WINDOWS E OFFICE (MAS - MASSGRAVE)
echo =================================================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "& { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; try { irm https://get.activated.win | iex } catch { iex (curl.exe -s --doh-url https://1.1.1.1/dns-query https://get.activated.win | Out-String) } }"

pause
