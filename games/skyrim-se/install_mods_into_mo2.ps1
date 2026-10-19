# PowerShell Script: install_mods_into_mo2.ps1
# Instalação automatizada de todos os mods no Mod Organizer 2 para Skyrim AE 1.6.318.0

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Continue"

$ModsSourceDir = "F:\06_Backups_ISOs_e_Sistemas\06.4_Games_e_Emuladores\02_Mods_e_Patches\Skyrim_AE"
$Mo2ModsDir   = "C:\Games\MO2\mods"
$Mo2ProfileDir = "C:\Games\MO2\profiles\Default"
$ManifestFile  = "c:\Users\lan\dotfiles\games\skyrim-se\skyrim_mods_manifest.json"
$PendingFile   = "c:\Users\lan\dotfiles\games\skyrim-se\mods_pendentes_download.json"

New-Item -ItemType Directory -Force -Path $Mo2ModsDir | Out-Null
New-Item -ItemType Directory -Force -Path $Mo2ProfileDir | Out-Null

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "   INSTALADOR MESTRE DE MODS AUTOMATIZADO - SKYRIM AE (MO2)      " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan

# 1. Carregar Manifestos de Nomes Limpos
$ModMap = @{}
if (Test-Path $ManifestFile) {
    $manifest = Get-Content $ManifestFile -Raw | ConvertFrom-Json
    foreach ($m in $manifest) {
        $ModMap[$m.filename] = $m.name
    }
}
if (Test-Path $PendingFile) {
    $pending = Get-Content $PendingFile -Raw | ConvertFrom-Json
    foreach ($m in $pending) {
        if (-not $ModMap.ContainsKey($m.filename)) {
            $ModMap[$m.filename] = $m.name
        }
    }
}

# 2. Lista de Exclusões Intencionais (versões erradas de Skyrim ou já na raiz)
$SkipPatterns = @(
    "skse64_2_02_06_Skyrim_1_6_1170",     # Versão 1.6.1170 incompatível com 1.6.318
    "skse64_2_01_02_Skyrim_1_6_318",     # Já instalado na raiz do jogo
    "EngineFixes_Part2",                  # Já instalado na raiz do jogo
    "Unofficial Skyrim Special Edition Patch 266 4.3.9c", # Versão para 1.6.1130+ (usamos 4.2.6a)
    "MCM Helper SE (1.5.97 BACKPORT)",   # Backport para 1.5.97 (usamos 1.6.3)
    "Engine Fixes 7.0.21 beta",          # Beta para 1.7.99 (usamos 6.0.2 AE)
    "DynamicAnimationReplacerAE v1.1.3", # Para 1.6.629 (Open Animation Replacer substitui nativamente)
    "VR Address Library",                # Específico para Skyrim VR
    "PrivateProfileRedirector VR",        # Específico para Skyrim VR
    "Equip Enchantment Fix 42839 1.3.6", # Versão 1.6.629+ se houver
    "Lux (main)"                         # Quarentena: evita tela preta em interiores
)

function Get-CleanModName($filename) {
    if ($ModMap.ContainsKey($filename)) {
        return $ModMap[$filename]
    }
    # Tentar limpar o nome caso não esteja no dicionário
    $clean = [System.IO.Path]::GetFileNameWithoutExtension($filename)
    $clean = $clean -replace '-\d+-\d+-\d+.*$', ''
    $clean = $clean -replace '\s+\d+\s+[\d\.]+\s+.*$', ''
    foreach ($c in [System.IO.Path]::GetInvalidFileNameChars()) {
        $clean = $clean.Replace($c, [char]32)
    }
    $clean = $clean.Trim()
    if ([string]::IsNullOrWhiteSpace($clean)) {
        $clean = [System.IO.Path]::GetFileNameWithoutExtension($filename)
    }
    return $clean
}

# 3. Coletar arquivos
$archives = Get-ChildItem -Path $ModsSourceDir -File | Where-Object { 
    $_.Extension -in @(".zip", ".7z", ".rar") 
} | Sort-Object Name

Write-Host "Total de arquivos encontrados: $($archives.Count)" -ForegroundColor Yellow

$InstalledMods = [System.Collections.Generic.List[string]]::new()
$current = 0
$total = $archives.Count

foreach ($arc in $archives) {
    $current++
    $fname = $arc.Name
    
    # Verificar se deve pular
    $skip = $false
    foreach ($pat in $SkipPatterns) {
        if ($fname -like "*$pat*") {
            Write-Host "[$current/$total] ⏭️ Pulando (Incompatível/Quarentena): $fname" -ForegroundColor DarkGray
            $skip = $true
            break
        }
    }
    if ($skip) { continue }

    $modName = Get-CleanModName $fname
    $targetDir = Join-Path $Mo2ModsDir $modName
    
    Write-Host "[$current/$total] 📦 Instalando: $modName" -ForegroundColor Cyan
    
    # Casos Especiais de FOMODs
    if ($fname -like "*Barter Limit Fix*") {
        $tmpDir = Join-Path $env:TEMP "extract_blf"
        Remove-Item -Recurse -Force $tmpDir -ErrorAction SilentlyContinue
        New-Item -ItemType Directory -Force -Path $tmpDir | Out-Null
        & 7z x "$($arc.FullName)" "-o$tmpDir" -y | Out-Null
        
        $aeSkse = Join-Path $tmpDir "Barter Limit Fix FOMOD Installer\AE\SKSE"
        $destSkse = Join-Path $targetDir "SKSE"
        New-Item -ItemType Directory -Force -Path $destSkse | Out-Null
        if (Test-Path $aeSkse) {
            Copy-Item -Path "$aeSkse\*" -Destination $destSkse -Recurse -Force
        }
        Remove-Item -Recurse -Force $tmpDir -ErrorAction SilentlyContinue
        $InstalledMods.Add($modName)
        continue
    }

    if ($fname -like "*Essential Favorites*") {
        $tmpDir = Join-Path $env:TEMP "extract_ef"
        Remove-Item -Recurse -Force $tmpDir -ErrorAction SilentlyContinue
        New-Item -ItemType Directory -Force -Path $tmpDir | Out-Null
        & 7z x "$($arc.FullName)" "-o$tmpDir" -y | Out-Null
        
        $aeSkse = Join-Path $tmpDir "Essential Favorites FOMOD Installer\AE\SKSE"
        $reqSkse = Join-Path $tmpDir "Essential Favorites FOMOD Installer\Required\SKSE"
        $destSkse = Join-Path $targetDir "SKSE"
        New-Item -ItemType Directory -Force -Path $destSkse | Out-Null
        if (Test-Path $aeSkse) {
            Copy-Item -Path "$aeSkse\*" -Destination $destSkse -Recurse -Force
        }
        if (Test-Path $reqSkse) {
            Copy-Item -Path "$reqSkse\*" -Destination $destSkse -Recurse -Force
        }
        Remove-Item -Recurse -Force $tmpDir -ErrorAction SilentlyContinue
        $InstalledMods.Add($modName)
        continue
    }

    # Extração padrão com 7z
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    & 7z x "$($arc.FullName)" "-o$targetDir" -y -bb0 -bd | Out-Null
    
    # Se o mod continha apenas uma pasta Data/ interna, mover tudo um nível acima
    $subItems = Get-ChildItem -Path $targetDir
    if ($subItems.Count -eq 1 -and $subItems[0].Name -eq "Data" -and $subItems[0].PSIsContainer) {
        $dataDir = $subItems[0].FullName
        Get-ChildItem -Path $dataDir | ForEach-Object {
            Move-Item -Path $_.FullName -Destination $targetDir -Force
        }
        Remove-Item -Path $dataDir -Force -ErrorAction SilentlyContinue
    }
    
    $InstalledMods.Add($modName)
}

Write-Host "`nExtração concluída! Foram instalados $($InstalledMods.Count) mods em $Mo2ModsDir." -ForegroundColor Green

# 4. Gerar C:\Games\MO2\profiles\Default\modlist.txt
Write-Host "`nAtualizando modlist.txt..." -ForegroundColor Yellow
$modlistFile = Join-Path $Mo2ProfileDir "modlist.txt"

# Coletar mods do Creation Club já registrados no modlist original
$ccEntries = @()
if (Test-Path $modlistFile) {
    Get-Content $modlistFile | ForEach-Object {
        if ($_ -like "*Creation Club:*") {
            $ccEntries += $_
        }
    }
}

$newModList = [System.Collections.Generic.List[string]]::new()
$newModList.Add("# This file was automatically generated by Antigravity Mod Installer.")

# Adicionar todos os mods com prefixo '+'
foreach ($m in $InstalledMods) {
    $newModList.Add("+$m")
}
# Manter itens Creation Club
foreach ($cc in $ccEntries) {
    $newModList.Add($cc)
}

Set-Content -Path $modlistFile -Value $newModList -Encoding UTF8
Write-Host "✓ modlist.txt atualizado com $($newModList.Count) entradas ativas!" -ForegroundColor Green

# 5. Escanear e gerar C:\Games\MO2\profiles\Default\plugins.txt
Write-Host "`nEscanear plugins (.esm, .esl, .esp) para gerar ordem de carregamento..." -ForegroundColor Yellow
$pluginsFile = Join-Path $Mo2ProfileDir "plugins.txt"

$foundPlugins = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

# Plugins da pasta Data/ do jogo base
Get-ChildItem -Path "C:\Games\Skyrim Special Edition\Data" -File | Where-Object {
    $_.Extension -in @(".esm", ".esl", ".esp")
} | ForEach-Object {
    $null = $foundPlugins.Add($_.Name)
}

# Plugins de todos os mods instalados
Get-ChildItem -Path $Mo2ModsDir -Recurse -File -Depth 2 | Where-Object {
    $_.Extension -in @(".esm", ".esl", ".esp")
} | ForEach-Object {
    $null = $foundPlugins.Add($_.Name)
}

Write-Host "Total de plugins únicos encontrados no ecossistema: $($foundPlugins.Count)" -ForegroundColor Cyan

# Ordem Canônica Prioritária
$MasterOrder = @(
    "Skyrim.esm",
    "Update.esm",
    "Dawnguard.esm",
    "HearthFires.esm",
    "Dragonborn.esm",
    "Unofficial Skyrim Special Edition Patch.esp",
    "RealisticWaterTwo - Resources.esm",
    "Lux - Resources.esp",
    "Lux Via.esp",
    "EVGAnimatedTraversal.esl",
    "SmoothCam.esl",
    "TrueHUD.esl",
    "Lux Via - plugin.esp",
    "_ResourcePack.esl"
)

$FinalPlugins = [System.Collections.Generic.List[string]]::new()
$Used = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

# 1. Adicionar Mestres prioritários
foreach ($m in $MasterOrder) {
    if ($foundPlugins.Contains($m) -and -not $Used.Contains($m)) {
        $FinalPlugins.Add($m)
        $null = $Used.Add($m)
    }
}

# 2. Demais .esm
foreach ($p in ($foundPlugins | Sort-Object)) {
    if ($p.EndsWith(".esm", [System.StringComparison]::OrdinalIgnoreCase) -and -not $Used.Contains($p)) {
        $FinalPlugins.Add($p)
        $null = $Used.Add($p)
    }
}

# 3. Demais .esl
foreach ($p in ($foundPlugins | Sort-Object)) {
    if ($p.EndsWith(".esl", [System.StringComparison]::OrdinalIgnoreCase) -and -not $Used.Contains($p)) {
        $FinalPlugins.Add($p)
        $null = $Used.Add($p)
    }
}

# 4. Demais .esp
foreach ($p in ($foundPlugins | Sort-Object)) {
    if ($p.EndsWith(".esp", [System.StringComparison]::OrdinalIgnoreCase) -and -not $Used.Contains($p)) {
        $FinalPlugins.Add($p)
        $null = $Used.Add($p)
    }
}

# Escrever plugins.txt com formato *Plugin.esp
$pluginsContent = $FinalPlugins | ForEach-Object { "*$_" }
Set-Content -Path $pluginsFile -Value $pluginsContent -Encoding UTF8

Write-Host "✓ plugins.txt gerado com sucesso com $($FinalPlugins.Count) plugins ativos!" -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "   🎉 INSTALAÇÃO CONCLUÍDA COM SUCESSO!                          " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
