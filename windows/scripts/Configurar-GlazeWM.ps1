<#
.SYNOPSIS
    Script de Instalação e Configuração Automática do GlazeWM (Hyprland Style no Windows).
.DESCRIPTION
    Instala o GlazeWM e o Zebar via Winget, aplica a configuração Catppuccin Mocha com atalhos Vim (hjkl),
    e configura a inicialização automática junto com o Windows.
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Setup e Configuração do GlazeWM — Hyprland Style"

Clear-Host
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "   ⚡ INSTALADOR & CONFIGURADOR DO GLAZEWM (HYPRLAND STYLE)      " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Instalação do GlazeWM e Zebar
Write-Host "[1/3] Verificando e instalando GlazeWM e Zebar via Winget..." -ForegroundColor Cyan

winget install --id glzr-io.glazewm --exact --silent --accept-package-agreements --accept-source-agreements
winget install --id glzr-io.zebar --exact --silent --accept-package-agreements --accept-source-agreements

# 2. Aplicar Configuração Catppuccin Mocha
Write-Host "`n[2/3] Aplicando arquivo de configuração Catppuccin Mocha..." -ForegroundColor Cyan

$userProfile = [System.Environment]::GetFolderPath('UserProfile')
$targetDir = Join-Path $userProfile ".glzr\glazewm"
$targetConfigFile = Join-Path $targetDir "config.yaml"

$projectRoot = Split-Path -Parent $PSScriptRoot
$sourceConfigFile = Join-Path $projectRoot "config\glazewm\config.yaml"

if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}

if (Test-Path $sourceConfigFile) {
    Copy-Item -Path $sourceConfigFile -Destination $targetConfigFile -Force
    Write-Host "✓ Configuração aplicada com sucesso em: $targetConfigFile" -ForegroundColor Green
} else {
    Write-Warning "Arquivo de origem não encontrado em: $sourceConfigFile"
}

# 3. Inicialização Automática com o Windows
Write-Host "`n[3/3] Deseja configurar o GlazeWM para iniciar automaticamente com o Windows? (S/N): " -ForegroundColor Yellow -NoNewline
$autoStart = Read-Host

if ($autoStart -match "^[sSyY]") {
    $startupFolder = [System.Environment]::GetFolderPath('Startup')
    $shortcutPath = Join-Path $startupFolder "GlazeWM.lnk"
    
    $wshShell = New-Object -ComObject WScript.Shell
    $shortcut = $wshShell.CreateShortcut($shortcutPath)
    
    # Caminho padrão do executável do GlazeWM instalado via Winget
    $glazeExe = Join-Path $userProfile "AppData\Local\Programs\glazewm\glazewm.exe"
    if (-not (Test-Path $glazeExe)) {
        $glazeExe = "glazewm.exe"
    }
    
    $shortcut.TargetPath = $glazeExe
    $shortcut.Description = "GlazeWM Tiling Window Manager"
    $shortcut.Save()
    Write-Host "✓ Atalho de inicialização automática criado em: $shortcutPath" -ForegroundColor Green
}

Write-Host "`n=================================================================" -ForegroundColor Green
Write-Host "             GLAZEWM CONFIGURADO COM SUCESSO! 🚀                 " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green
Write-Host " Atalhos Principais Ativos:" -ForegroundColor Cyan
Write-Host "  • Alt + Enter           : Abre o Windows Terminal"
Write-Host "  • Alt + h, j, k, l      : Navegação entre janelas (Vim)"
Write-Host "  • Alt + Shift + h,j,k,l : Mover janelas de lugar"
Write-Host "  • Alt + 1..9            : Alternar entre Workspaces"
Write-Host "  • Alt + Shift + Q       : Fechar Janela"
Write-Host "  • Alt + P               : Pausar Tiling para Jogos/Vídeos"
Write-Host "  • Alt + Shift + R       : Recarregar Configurações"
Write-Host "=================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Deseja iniciar o GlazeWM agora? (S/N): " -ForegroundColor Yellow -NoNewline
$startNow = Read-Host
if ($startNow -match "^[sSyY]") {
    Start-Process "glazewm.exe"
}
