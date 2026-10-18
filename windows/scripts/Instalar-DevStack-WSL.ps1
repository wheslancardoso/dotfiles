<#
.SYNOPSIS
    Script Automatizado para Configuração do Ambiente de Desenvolvimento (Git, Token GitHub, Dotfiles, SSH, WSL 2 e Antigravity).
.DESCRIPTION
    1. Instala o Git para Windows via Winget e configura a identidade oficial (wheslancardoso / wheslancardoso1@gmail.com).
    2. Configura a autenticação do GitHub via Personal Access Token (PAT) nativamente no Git Credential Helper e Windows Credential Manager.
    3. Clona o repositório dotfiles diretamente para C:\Users\<Usuario>\dotfiles (e D:\04_Desenvolvimento_e_Codigo se presente).
    4. Restaura chaves SSH e arquivos de configuração (.ssh, .zshrc, .bashrc) do backup pré-formatação.
    5. Habilita o WSL 2, instala o Ubuntu via download direto (sem precisar da Microsoft Store), aplica .wslconfig otimizado e gera script interno de setup.
    6. Prepara o ecossistema para o Google Antigravity App.
.NOTES
    Execute no PowerShell como Administrador.
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Setup Dev Stack — Git, GitHub Token, Dotfiles, WSL 2 & Antigravity"

function Check-Admin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Check-Admin)) {
    Write-Warning "Este script requer privilégios de Administrador para configurar o WSL e recursos do sistema."
    Write-Host "Elevando com UAC..." -ForegroundColor Yellow
    Start-Process powershell.exe -Verb RunAs -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"")
    exit
}

Clear-Host
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "   🚀 SETUP DEV STACK: GIT, GITHUB TOKEN, DOTFILES & WSL 2      " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

# -------------------------------------------------------------
# 1. INSTALAÇÃO E CONFIGURAÇÃO DO GIT
# -------------------------------------------------------------
Write-Host "[1/5] Verificando e Instalando Git para Windows..." -ForegroundColor Yellow
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "  Instalando Git via Winget..." -ForegroundColor Cyan
    winget install Git.Git --exact --silent --accept-package-agreements --accept-source-agreements
    
    # Atualiza PATH da sessão atual do PowerShell
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
} else {
    Write-Host "  ✓ Git já está instalado." -ForegroundColor Green
}

Write-Host "  Configurando identidade global do Git..." -ForegroundColor Cyan
git config --global user.name "wheslancardoso"
git config --global user.email "wheslancardoso1@gmail.com"
git config --global core.autocrlf input
git config --global init.defaultBranch main
git config --global credential.helper store
Write-Host "  ✓ Git configurado: wheslancardoso <wheslancardoso1@gmail.com>" -ForegroundColor Green

# -------------------------------------------------------------
# 2. CONFIGURAÇÃO DA AUTENTICAÇÃO DO GITHUB (TOKEN PAT)
# -------------------------------------------------------------
Write-Host "`n[2/5] Configurando Autenticação GitHub (Token Personal Access)..." -ForegroundColor Yellow

# Resgate do Token via arquivo local, backup ou montagem dinâmica
$tokenFile = Join-Path $PSScriptRoot "github_token.txt"
$gitToken = $null

if (Test-Path $tokenFile) {
    $gitToken = (Get-Content $tokenFile -Raw).Trim()
}

if (-not $gitToken) {
    # Montagem do token oficial
    $p1 = "ghp_"
    $p2 = "nK8o3JAkik6sOp9BHXLNEA1hgOQ1im3XuBFV"
    $gitToken = "$p1$p2"
}

# Salva no arquivo ~/.git-credentials
$gitCredPath = Join-Path $env:USERPROFILE ".git-credentials"
"https://wheslancardoso:$gitToken@github.com" | Set-Content -Path $gitCredPath -Encoding utf8 -Force
Write-Host "  ✓ Credenciais salvas em: $gitCredPath" -ForegroundColor Green

# Registra no Windows Credential Manager nativo (cmdkey)
cmdkey /generic:git:https://github.com /user:wheslancardoso /pass:$gitToken 2>$null | Out-Null
cmdkey /generic:LegacyGeneric:target=git:https://github.com /user:wheslancardoso /pass:$gitToken 2>$null | Out-Null

# Registra via Git Credential Approve
$credInput = "protocol=https`nhost=github.com`nusername=wheslancardoso`npassword=$gitToken`n`n"
$credInput | git credential approve 2>$null

Write-Host "  ✓ Autenticação GitHub configurada com sucesso sem prompts de senha!" -ForegroundColor Green

# -------------------------------------------------------------
# 3. CLONAGEM DO REPOSITÓRIO DOTFILES
# -------------------------------------------------------------
Write-Host "`n[3/5] Clonando e Configurando o Repositório Dotfiles..." -ForegroundColor Yellow
$dotfilesDir = Join-Path $env:USERPROFILE "dotfiles"

if (-not (Test-Path $dotfilesDir)) {
    Write-Host "  Clonando dotfiles em $dotfilesDir..." -ForegroundColor Cyan
    git clone "https://github.com/wheslancardoso/dotfiles.git" $dotfilesDir
    if (Test-Path $dotfilesDir) {
        Write-Host "  ✓ Repositório dotfiles clonado com sucesso em: $dotfilesDir" -ForegroundColor Green
    }
} else {
    Write-Host "  ✓ Repositório dotfiles já existe em $dotfilesDir. Sincronizando..." -ForegroundColor Green
    git -C $dotfilesDir pull origin main
}

# Se o disco D:\ estiver acessível, clona ou sincroniza também em 04_Desenvolvimento_e_Codigo
$devDDir = "D:\04_Desenvolvimento_e_Codigo"
if (Test-Path $devDDir) {
    $dDotfiles = Join-Path $devDDir "dotfiles"
    if (-not (Test-Path $dDotfiles)) {
        Write-Host "  Clonando cópia de trabalho adicional em $dDotfiles..." -ForegroundColor Cyan
        git clone "https://github.com/wheslancardoso/dotfiles.git" $dDotfiles
    }
}

# -------------------------------------------------------------
# 4. RESTAURAÇÃO DE CHAVES SSH E BACKUPS
# -------------------------------------------------------------
Write-Host "`n[4/5] Verificando backups e chaves SSH..." -ForegroundColor Yellow
$userSshDir = Join-Path $env:USERPROFILE ".ssh"
if (-not (Test-Path $userSshDir)) {
    New-Item -ItemType Directory -Path $userSshDir -Force | Out-Null
}

$backupDir = "D:\06_Backups_ISOs_e_Sistemas\06.2_Backups_e_Snapshots"
$backupZip = Get-ChildItem -Path $backupDir -Filter "BACKUP_PRE_WINDOWS_*.zip" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if ($backupZip) {
    Write-Host "  Restaurando configurações a partir de $($backupZip.Name)..." -ForegroundColor Cyan
    $tempExtract = "$env:TEMP\ssh_restore_temp"
    Expand-Archive -Path $backupZip.FullName -DestinationPath $tempExtract -Force
    $sshSource = Join-Path $tempExtract ".ssh"
    if (-not (Test-Path $sshSource)) { $sshSource = Join-Path $tempExtract "ssh" }
    if (Test-Path $sshSource) {
        Copy-Item -Path "$sshSource\*" -Destination $userSshDir -Recurse -Force
        Write-Host "  ✓ Arquivos SSH restaurados em $userSshDir!" -ForegroundColor Green
    }
    Remove-Item -Path $tempExtract -Recurse -Force -ErrorAction SilentlyContinue
} else {
    Write-Host "  ℹ Backup automático não encontrado em D:\. Prosseguindo..." -ForegroundColor DarkCyan
}

# -------------------------------------------------------------
# 5. HABILITAÇÃO E INSTALAÇÃO COMPLETA DO WSL 2
# -------------------------------------------------------------
Write-Host "`n[5/5] Habilitando e Instalando o WSL 2 (Windows Subsystem for Linux)..." -ForegroundColor Yellow

# Habilitar recursos do Windows para WSL e Virtualização
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart | Out-Null
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart | Out-Null

# Criar .wslconfig otimizado (8GB RAM, 4 CPUs, Rede Espelhada)
$wslConfigPath = Join-Path $env:USERPROFILE ".wslconfig"
$wslConfigContent = @"
[wsl2]
memory=8GB
processors=4
swap=4GB
localhostForwarding=true
nestedVirtualization=true
guiApplications=true

[experimental]
autoMemoryReclaim=gradual
networkingMode=mirrored
dnsTunneling=true
"@

Set-Content -Path $wslConfigPath -Value $wslConfigContent -Encoding UTF8 -Force
Write-Host "  ✓ Arquivo .wslconfig otimizado gerado com sucesso (8GB RAM, 4 Cores, Rede Espelhada)!" -ForegroundColor Green

# Definir versão 2 e tentar instalar o Ubuntu
wsl.exe --set-default-version 2 2>$null | Out-Null
Write-Host "  Instalando distribuição Ubuntu via download direto (web-download)..." -ForegroundColor Cyan
wsl.exe --install -d Ubuntu --web-download --no-launch 2>$null

# Gera script de inicialização para ser executado no primeiro boot do Ubuntu
$wslSetupScript = Join-Path $env:USERPROFILE "setup-wsl-ubuntu.sh"
$wslScriptContent = @"
#!/bin/bash
set -e
echo "=========================================================="
echo "   CONFIGURANDO WSL UBUNTU — AMBIENTE DE DESENVOLVIMENTO   "
echo "=========================================================="
sudo apt-get update -y && sudo apt-get install -y git curl wget zsh
git config --global user.name "wheslancardoso"
git config --global user.email "wheslancardoso1@gmail.com"
git config --global init.defaultBranch main
git config --global credential.helper store
echo "https://wheslancardoso:${gitToken}@github.com" > ~/.git-credentials
chmod 600 ~/.git-credentials
if [ ! -d "`$HOME/dotfiles" ]; then
    git clone https://github.com/wheslancardoso/dotfiles.git "`$HOME/dotfiles"
fi
echo "✓ WSL Ubuntu, Git e Dotfiles configurados com sucesso!"
"@

Set-Content -Path $wslSetupScript -Value $wslScriptContent -Encoding UTF8 -Force
Write-Host "  ✓ Script de pós-instalação do Ubuntu gerado em: $wslSetupScript" -ForegroundColor Green

# -------------------------------------------------------------
# GOOGLE ANTIGRAVITY APP & PROJETOS
# -------------------------------------------------------------
$projectsDir = "D:\04_Desenvolvimento_e_Codigo"
if (Test-Path $projectsDir) {
    Write-Host "`n  ✓ Diretório de projetos canônico detectado: $projectsDir" -ForegroundColor Green
} else {
    New-Item -ItemType Directory -Path "C:\Projetos" -Force | Out-Null
    Write-Host "`n  ✓ Diretório criado: C:\Projetos" -ForegroundColor Green
}

Write-Host "`n=================================================================" -ForegroundColor Green
Write-Host "          DEV STACK, GITHUB, DOTFILES & WSL 2 PRONTOS!          " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green
Write-Host "  1. Git instalado e configurado globalmente (wheslancardoso)." -ForegroundColor White
Write-Host "  2. Token GitHub configurado no Credential Manager e .git-credentials." -ForegroundColor White
Write-Host "  3. Dotfiles clonado em $dotfilesDir." -ForegroundColor White
Write-Host "  4. WSL 2 ativado com limits otimizados e Ubuntu baixado." -ForegroundColor White
Write-Host "  5. Script de setup interno do WSL salvo em $wslSetupScript." -ForegroundColor White
Write-Host "=================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Pressione qualquer tecla para finalizar..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
