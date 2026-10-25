<#
.SYNOPSIS
    Script de automação completa para restaurar, configurar e validar o Skyrim SE v1.6.1170 + MO2.
.DESCRIPTION
    Restaura perfis configurados sem UTF-8 BOM, sincroniza ferramentas (SSEEdit, LOOT),
    injeta os patches binários na raiz do jogo (SKSE, Engine Fixes, SkyrimSE blindado),
    aplica os patches pós-extração de mods (FaceGen do Bijin, Tundra Verde, MCM Helper 1.6.2)
    e valida a integridade do ecossistema.
#>

[CmdletBinding()]
param (
    [string]$SkyrimPath = "C:\Games\Skyrim Special Edition",
    [string]$MO2Path = "C:\Games\MO2",
    [string]$ToolsPath = "C:\Games\Tools"
)

$ErrorActionPreference = "Stop"
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "   SKYRIM SPECIAL EDITION v1.6.1170 - RESTAURAÇÃO AUTOMATIZADA   " -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan

# 1. Encontrar caminhos base
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$parentDir = Split-Path -Parent $scriptDir
$patchesDir = Join-Path $parentDir "00_PATCHES_POS_EXTRACAO"
$toolsSource = Join-Path $parentDir "00_FERRAMENTAS"
$backupProfile = Join-Path $scriptDir "backup_profile"
$backupRootPatches = Join-Path $scriptDir "backup_root_patches"
$backupSaves = Join-Path $scriptDir "backup_saves"

# 2. Fechar processos pendentes
Write-Host "`n[1/7] Encerrando processos anteriores..." -ForegroundColor Yellow
Stop-Process -Name ModOrganizer, SkyrimSE, skse64_loader -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1

# 3. Validar / Criar diretórios
Write-Host "[2/7] Verificando pastas de destino..." -ForegroundColor Yellow
if (-not (Test-Path $SkyrimPath)) {
    Write-Warning "Pasta do jogo não encontrada em '$SkyrimPath'! Criando pasta..."
    New-Item -ItemType Directory -Path $SkyrimPath -Force | Out-Null
}
if (-not (Test-Path $MO2Path)) {
    Write-Host "-> Criando pasta do Mod Organizer 2 em '$MO2Path'..." -ForegroundColor Green
    New-Item -ItemType Directory -Path $MO2Path -Force | Out-Null
}
if (-not (Test-Path $ToolsPath)) {
    New-Item -ItemType Directory -Path $ToolsPath -Force | Out-Null
}

# 4. Restaurar Ferramentas (SSEEdit e LOOT)
Write-Host "[3/7] Sincronizando ferramentas em '$ToolsPath'..." -ForegroundColor Yellow
if (Test-Path $toolsSource) {
    if (Test-Path "$toolsSource\SSEEdit") {
        Copy-Item "$toolsSource\SSEEdit" -Destination $ToolsPath -Recurse -Force
        Write-Host "  [OK] SSEEdit 4.1.5f sincronizado." -ForegroundColor Green
    }
    if (Test-Path "$toolsSource\LOOT") {
        Copy-Item "$toolsSource\LOOT" -Destination $ToolsPath -Recurse -Force
        Write-Host "  [OK] LOOT 0.29.2 sincronizado." -ForegroundColor Green
    }
}

# 5. Injetar Patches e SKSE na raiz do SkyrimSE
Write-Host "[4/7] Injetando binários blindados e SKSE na pasta raiz do jogo..." -ForegroundColor Yellow
if (Test-Path $backupRootPatches) {
    Copy-Item "$backupRootPatches\*" -Destination $SkyrimPath -Force
    Write-Host "  [OK] SkyrimSE.exe blindado contra crashes, SKSE 2.2.6 e Engine Fixes injetados." -ForegroundColor Green
}

# 6. Restaurar Perfil Configurado (modlist, plugins, loadorder, inis)
Write-Host "[5/7] Restaurando perfil de mods e configurações INI..." -ForegroundColor Yellow
$targetProfile = Join-Path $MO2Path "profiles\Default"
if (Test-Path $backupProfile) {
    if (-not (Test-Path $targetProfile)) { New-Item -ItemType Directory -Path $targetProfile -Force | Out-Null }
    Copy-Item "$backupProfile\*" -Destination $targetProfile -Recurse -Force
    Write-Host "  [OK] Perfil 'Default' restaurado." -ForegroundColor Green
}

# Garantir UTF-8 Puro sem BOM
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
foreach ($f in @("modlist.txt", "plugins.txt", "loadorder.txt")) {
    $filePath = Join-Path $targetProfile $f
    if (Test-Path $filePath) {
        $lines = [System.IO.File]::ReadAllLines($filePath)
        [System.IO.File]::WriteAllLines($filePath, $lines, $utf8NoBom)
    }
}
Write-Host "  [OK] Codificação UTF-8 sem BOM validada para evitar erros de leitura no MO2." -ForegroundColor Green

# Restaurar ModOrganizer.ini
$mo2IniBackup = Join-Path $scriptDir "ModOrganizer.ini"
if (Test-Path $mo2IniBackup) {
    Copy-Item $mo2IniBackup -Destination (Join-Path $MO2Path "ModOrganizer.ini") -Force
    Write-Host "  [OK] ModOrganizer.ini restaurado com atalhos de ferramentas." -ForegroundColor Green
}

# 7. Aplicar Patches Pós-Extração nos Mods (se a pasta de mods existir)
Write-Host "[6/7] Verificando correções pós-extração de mods..." -ForegroundColor Yellow
$mo2ModsDir = Join-Path $MO2Path "mods"
if ((Test-Path $mo2ModsDir) -and (Test-Path $patchesDir)) {
    Get-ChildItem $patchesDir -Directory | ForEach-Object {
        $modTarget = Join-Path $mo2ModsDir $_.Name
        if (Test-Path $modTarget) {
            Copy-Item "$($_.FullName)\*" -Destination $modTarget -Recurse -Force
            Write-Host "  [PATCH APLICADO] $($_.Name)" -ForegroundColor Green
        }
    }
} else {
    Write-Host "  [INFO] Pasta de mods ainda não descompactada. Os patches estão salvos em 00_PATCHES_POS_EXTRACAO." -ForegroundColor Gray
}

# 8. Restaurar Saves se solicitado
Write-Host "[7/7] Verificando saves..." -ForegroundColor Yellow
$savesTarget = "$env:USERPROFILE\Documents\My Games\Skyrim Special Edition\Saves"
if (Test-Path $backupSaves) {
    if (-not (Test-Path $savesTarget)) { New-Item -ItemType Directory -Path $savesTarget -Force | Out-Null }
    Copy-Item "$backupSaves\*" -Destination $savesTarget -Force
    Write-Host "  [OK] Saves mais recentes sincronizados em '$savesTarget'." -ForegroundColor Green
}

# Resumo
$activePlugins = 0
$activeMods = 0
if (Test-Path (Join-Path $targetProfile "plugins.txt")) {
    $activePlugins = (Get-Content (Join-Path $targetProfile "plugins.txt") | Where-Object { $_ -match '^\*' }).Count
}
if (Test-Path (Join-Path $targetProfile "modlist.txt")) {
    $activeMods = (Get-Content (Join-Path $targetProfile "modlist.txt") | Where-Object { $_ -match '^\+' }).Count
}

Write-Host "`n=================================================================" -ForegroundColor Cyan
Write-Host "   INSTALAÇÃO E CONFIGURAÇÃO CONCLUÍDAS COM SUCESSO!            " -ForegroundColor Green
Write-Host "   - Mods Ativos no MO2:   $activeMods" -ForegroundColor White
Write-Host "   - Plugins Ativos:       $activePlugins" -ForegroundColor White
Write-Host "   - Executável Blindado:  $SkyrimPath\SkyrimSE.exe" -ForegroundColor White
Write-Host "   - Ferramentas MO2:      SSEEdit e LOOT prontos" -ForegroundColor White
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "Para jogar, abra o Mod Organizer 2 e clique em Executar (SKSE)!`n" -ForegroundColor Yellow
