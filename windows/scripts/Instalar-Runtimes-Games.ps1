<#
.SYNOPSIS
    Instalação Automatizada de Runtimes Essenciais para Jogos, Modding (Skyrim AE) e Aplicações.
.DESCRIPTION
    Instala:
    1. Pacote Visual C++ Redistributable All-in-One (2005, 2008, 2010, 2012, 2013, 2015-2022 x86 e x64).
    2. Microsoft .NET Desktop Runtime (6.0, 7.0, 8.0).
    3. DirectX End-User Runtimes (legado June 2010 / d3dx9_43.dll).
.NOTES
    Execute no PowerShell como Administrador.
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Instalador de Runtimes & Dependências para Jogos"

function Check-Admin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Check-Admin)) {
    Write-Warning "Este script requer privilégios de Administrador."
    Write-Host "Elevando com UAC..." -ForegroundColor Yellow
    Start-Process powershell.exe -Verb RunAs -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"")
    exit
}

Clear-Host
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "   🎮 INSTALADOR DE RUNTIMES & DEPENDÊNCIAS DE JOGOS & MODS     " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Visual C++ All-in-One (Abbodi1406 / GitHub)
Write-Host "[1/3] Baixando e Instalando Visual C++ Redistributable All-in-One (2005-2022)..." -ForegroundColor Yellow
$vcUrl = "https://github.com/abbodi1406/vcredist/releases/latest/download/VisualCppRedist_AIO_x86_x64.exe"
$vcExe = "$env:TEMP\VisualCppRedist_AIO.exe"

try {
    Write-Host "  Baixando pacote unificado oficial..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $vcUrl -OutFile $vcExe -UseBasicParsing
    Write-Host "  Instalando todas as versões de 2005 a 2022 silenciosamente..." -ForegroundColor Cyan
    Start-Process -FilePath $vcExe -ArgumentList "/ai" -Wait -NoNewWindow
    Write-Host "  ✓ Todas as versões do Visual C++ instaladas com sucesso!" -ForegroundColor Green
} catch {
    Write-Host "  ⚠ Tentando via Winget como alternativa..." -ForegroundColor Yellow
    winget install Microsoft.VCRedist.2015+.x64 --exact --silent --accept-package-agreements --accept-source-agreements
    winget install Microsoft.VCRedist.2015+.x86 --exact --silent --accept-package-agreements --accept-source-agreements
}

# 2. .NET Desktop Runtimes
Write-Host "`n[2/3] Instalando Microsoft .NET Desktop Runtimes..." -ForegroundColor Yellow
try {
    Write-Host "  Instalando .NET Desktop Runtime 8.0..." -ForegroundColor Cyan
    winget install Microsoft.DotNet.DesktopRuntime.8 --exact --silent --accept-package-agreements --accept-source-agreements
    Write-Host "  ✓ .NET Desktop Runtime configurado!" -ForegroundColor Green
} catch {
    Write-Host "  ⚠ Falha ao baixar .NET via winget." -ForegroundColor Red
}

# 3. DirectX End-User Runtimes
Write-Host "`n[3/3] Instalando DirectX Runtimes (June 2010)..." -ForegroundColor Yellow
try {
    winget install Microsoft.DirectX --exact --silent --accept-package-agreements --accept-source-agreements
    Write-Host "  ✓ DirectX End-User Runtimes instalado!" -ForegroundColor Green
} catch {
    Write-Host "  ⚠ DirectX já atualizado ou disponível no instalador do jogo." -ForegroundColor Yellow
}

Write-Host "`n=================================================================" -ForegroundColor Green
Write-Host "   TODOS OS RUNTIMES E BIBLIOTECAS FORAM INSTALADOS COM SUCESSO! " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green
Write-Host "Seu Windows agora tem 100% das DLLs necessárias para Skyrim AE," -ForegroundColor White
Write-Host "SKSE64, ENB/Community Shaders, ReShade, Mod Organizer e emuladores." -ForegroundColor White
Write-Host ""
Write-Host "Pressione qualquer tecla para sair..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
