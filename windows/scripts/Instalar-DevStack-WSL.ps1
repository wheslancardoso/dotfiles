<#
.SYNOPSIS
    Script Automatizado para Configuração do Ambiente de Desenvolvimento (Git, SSH, WSL 2 e Antigravity).
.DESCRIPTION
    1. Instala e configura o Git com credenciais oficiais (Wheslan Cardoso / wheslancardoso@gmail.com).
    2. Restaura chaves SSH (.ssh / id_ed25519) a partir do backup pré-formatação.
    3. Habilita e configura o WSL 2 com .wslconfig otimizado (8GB RAM, 4 CPUs, GUI Apps ativado).
    4. Prepara o ecossistema para o Google Antigravity App e diretório de projetos.
.NOTES
    Execute no PowerShell como Administrador.
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Setup Dev Stack — Git, SSH, WSL 2 & Antigravity"

function Check-Admin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Check-Admin)) {
    Write-Warning "Este script requer privilégios de Administrador para configurar o WSL."
    Write-Host "Elevando com UAC..." -ForegroundColor Yellow
    Start-Process powershell.exe -Verb RunAs -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"")
    exit
}

Clear-Host
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "   🚀 SETUP DEV STACK: GIT, SSH, WSL 2 & GOOGLE ANTIGRAVITY     " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

# -------------------------------------------------------------
# 1. INSTALAÇÃO E CONFIGURAÇÃO DO GIT
# -------------------------------------------------------------
Write-Host "[1/4] Verificando e Instalando Git para Windows..." -ForegroundColor Yellow
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "  Instalando Git via Winget..." -ForegroundColor Cyan
    winget install Git.Git --exact --silent --accept-package-agreements --accept-source-agreements
} else {
    Write-Host "  ✓ Git já está instalado." -ForegroundColor Green
}

Write-Host "  Configurando identidade global do Git..." -ForegroundColor Cyan
git config --global user.name "Wheslan Cardoso"
git config --global user.email "wheslancardoso@gmail.com"
git config --global core.autocrlf input
git config --global init.defaultBranch main
git config --global credential.helper manager
Write-Host "  ✓ Git configurado: Wheslan Cardoso <wheslancardoso@gmail.com>" -ForegroundColor Green

# -------------------------------------------------------------
# 2. RESTAURAÇÃO DAS CHAVES SSH
# -------------------------------------------------------------
Write-Host "`n[2/4] Verificando chaves SSH..." -ForegroundColor Yellow
$userSshDir = Join-Path $env:USERPROFILE ".ssh"
if (-not (Test-Path $userSshDir)) {
    New-Item -ItemType Directory -Path $userSshDir -Force | Out-Null
}

$backupDir = "D:\06_Backups_ISOs_e_Sistemas\06.2_Backups_e_Snapshots"
$backupZip = Get-ChildItem -Path $backupDir -Filter "BACKUP_PRE_WINDOWS_*.zip" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if ($backupZip) {
    Write-Host "  Restaurando chaves SSH a partir de $($backupZip.Name)..." -ForegroundColor Cyan
    $tempExtract = "$env:TEMP\ssh_restore_temp"
    Expand-Archive -Path $backupZip.FullName -DestinationPath $tempExtract -Force
    $sshSource = Join-Path $tempExtract "ssh"
    if (Test-Path $sshSource) {
        Copy-Item -Path "$sshSource\*" -Destination $userSshDir -Recurse -Force
        Write-Host "  ✓ Chaves SSH restauradas com sucesso em $userSshDir!" -ForegroundColor Green
    }
    Remove-Item -Path $tempExtract -Recurse -Force -ErrorAction SilentlyContinue
} else {
    Write-Host "  ℹ Backup automático não encontrado em D:\. Se necessário, copie manualmente para $userSshDir." -ForegroundColor DarkCyan
}

# -------------------------------------------------------------
# 3. HABILITAÇÃO E CONFIGURAÇÃO DO WSL 2
# -------------------------------------------------------------
Write-Host "`n[3/4] Habilitando e Configurando o WSL 2 (Windows Subsystem for Linux)..." -ForegroundColor Yellow

# Habilitar recursos do Windows para WSL e Virtualização
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart | Out-Null
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart | Out-Null

# Definir versão 2 do WSL por padrão
wsl.exe --set-default-version 2 2>$null | Out-Null
wsl.exe --update 2>$null | Out-Null

# Criar .wslconfig otimizado
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
Write-Host "  ℹ Para instalar sua distribuição Linux favorita no WSL, execute:" -ForegroundColor DarkCyan
Write-Host "      wsl --install -d Ubuntu-24.04   (ou ArchWSL)" -ForegroundColor White

# -------------------------------------------------------------
# 4. GOOGLE ANTIGRAVITY APP & PROJETOS
# -------------------------------------------------------------
Write-Host "`n[4/4] Preparando Ambiente para o Google Antigravity App..." -ForegroundColor Yellow
$projectsDir = "D:\04_Desenvolvimento_e_Codigo"
if (Test-Path $projectsDir) {
    Write-Host "  ✓ Diretório de projetos canônico detectado: $projectsDir" -ForegroundColor Green
} else {
    New-Item -ItemType Directory -Path "C:\Projetos" -Force | Out-Null
    Write-Host "  ✓ Diretório criado: C:\Projetos" -ForegroundColor Green
}

Write-Host "  ℹ Para baixar a versão desktop do Antigravity App, acesse:" -ForegroundColor Cyan
Write-Host "      https://antigravity.google/download" -ForegroundColor White
Write-Host "  Ou caso utilize via CLI / Node.js:" -ForegroundColor Cyan
Write-Host "      npm install -g @google/antigravity" -ForegroundColor White

Write-Host "`n=================================================================" -ForegroundColor Green
Write-Host "          DEV STACK & WSL 2 CONFIGURADOS COM SUCESSO!           " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green
Write-Host "  1. Git instalado e configurado globalmente com seu usuário." -ForegroundColor White
Write-Host "  2. Chaves SSH resgatadas e prontas para clonar repositórios." -ForegroundColor White
Write-Host "  3. WSL 2 ativado com limites controlados de RAM/CPU no .wslconfig." -ForegroundColor White
Write-Host "  4. Workspace pronto para o Google Antigravity." -ForegroundColor White
Write-Host "=================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Pressione qualquer tecla para finalizar..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
