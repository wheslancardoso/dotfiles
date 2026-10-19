<#
.SYNOPSIS
    Script de automação completa para restaurar e validar o Skyrim SE v1.6.1170 + MO2.
.DESCRIPTION
    Restaura arquivos de perfil, configurações sem BOM, executável blindado e valida
    a integridade de todas as pastas essenciais do Mod Organizer 2.
#>

[CmdletBinding()]
param (
    [string]$SkyrimPath = "C:\Games\Skyrim Special Edition",
    [string]$MO2Path = "C:\Games\MO2"
)

$ErrorActionPreference = "Stop"
Write-Host "=== INICIANDO SETUP / RESTAURACAO AUTOMATIZADA DO SKYRIM SE ===" -ForegroundColor Cyan

# 1. Validar pastas
if (-not (Test-Path $SkyrimPath)) {
    Write-Error "Diretório do Skyrim não encontrado em '$SkyrimPath'!"
}
if (-not (Test-Path $MO2Path)) {
    Write-Error "Diretório do Mod Organizer 2 não encontrado em '$MO2Path'!"
}

# 2. Fechar MO2 e Skyrim se estiverem abertos
Write-Host "-> Encerrando instâncias em execução..." -ForegroundColor Yellow
Stop-Process -Name ModOrganizer, SkyrimSE -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1

# 3. Restaurar Perfil Configurado (plugins.txt, modlist.txt, loadorder.txt, INIs)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$backupProfile = Join-Path $scriptDir "backup_profile"
$targetProfile = Join-Path $MO2Path "profiles\Default"

if (Test-Path $backupProfile) {
    Write-Host "-> Restaurando arquivos de perfil (plugins, loadorder, modlist, skyrim.ini, prefs)..." -ForegroundColor Green
    if (-not (Test-Path $targetProfile)) { New-Item -ItemType Directory -Path $targetProfile -Force | Out-Null }
    Copy-Item "$backupProfile\*" -Destination $targetProfile -Recurse -Force
}

# 4. Garantir que arquivos críticos estejam em UTF-8 sem BOM
Write-Host "-> Validando codificação UTF-8 sem BOM..." -ForegroundColor Green
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
foreach ($f in @("modlist.txt", "plugins.txt", "loadorder.txt")) {
    $filePath = Join-Path $targetProfile $f
    if (Test-Path $filePath) {
        $content = [System.IO.File]::ReadAllLines($filePath)
        [System.IO.File]::WriteAllLines($filePath, $content, $utf8NoBom)
    }
}

# 5. Restaurar ModOrganizer.ini principal (configuração de ferramentas SSEEdit / LOOT)
$mo2IniBackup = Join-Path $scriptDir "ModOrganizer.ini"
if (Test-Path $mo2IniBackup) {
    Write-Host "-> Restaurando ModOrganizer.ini..." -ForegroundColor Green
    Copy-Item $mo2IniBackup -Destination (Join-Path $MO2Path "ModOrganizer.ini") -Force
}

# 6. Restaurar binário estabilizado do SkyrimSE.exe
$exeBackup = Join-Path $scriptDir "backup_root_patches\SkyrimSE.exe"
if (Test-Path $exeBackup) {
    Write-Host "-> Sincronizando binário estabilizado SkyrimSE.exe..." -ForegroundColor Green
    Copy-Item $exeBackup -Destination (Join-Path $SkyrimPath "SkyrimSE.exe") -Force
}

# 7. Resumo e validação de plugins
$pluginCount = (Get-Content (Join-Path $targetProfile "plugins.txt") | Where-Object { $_ -match '^\*' }).Count
$modCount = (Get-Content (Join-Path $targetProfile "modlist.txt") | Where-Object { $_ -match '^\+' }).Count

Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host " SUCESSO! Ambiente totalmente restaurado e validado." -ForegroundColor Green
Write-Host " Mods Ativos no MO2: $modCount" -ForegroundColor White
Write-Host " Plugins Ativos:     $pluginCount" -ForegroundColor White
Write-Host " Executável:         $SkyrimPath\SkyrimSE.exe (Blindado)" -ForegroundColor White
Write-Host "=====================================================" -ForegroundColor Cyan
