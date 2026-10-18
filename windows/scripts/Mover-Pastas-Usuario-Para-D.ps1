<#
.SYNOPSIS
    Redirecionamento Automatizado das Pastas do Usuário do Windows para a Partição de Dados (BTRFS/Dados).
.DESCRIPTION
    Move e vincula de forma 100% transparente:
    - Downloads        ➔ <DataDrive>\00_Inbox_Triagem (igual ao Linux ~/downloads)
    - Documentos       ➔ <DataDrive>\01_Pessoal_e_Vida\01.1_Identidade_e_Documentos
    - Imagens          ➔ <DataDrive>\05_Design_Midia_e_Criacao\05.1_Imagens_e_Fotos
    - Vídeos           ➔ <DataDrive>\05_Design_Midia_e_Criacao\05.3_Videos_e_Projetos
    - Músicas          ➔ <DataDrive>\05_Design_Midia_e_Criacao\05.2_Audios_e_Midias
    - Área de Trabalho ➔ <DataDrive>\Area_de_Trabalho
    
    Aplica tanto no Registro do Windows (User Shell Folders) quanto via Junções NTFS (mklink /J),
    garantindo que qualquer programa antigo ou novo grave direto no disco de dados sem encher o C:\.
.NOTES
    Execute no PowerShell como Administrador.
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Redirecionamento de Pastas do Usuário para a Partição de Dados"

function Check-Admin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Check-Admin)) {
    Write-Warning "Este script requer privilégios de Administrador."
    Write-Host "Elevando com UAC..." -ForegroundColor Yellow
    Start-Process powershell.exe -Verb RunAs -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"")
    return
}

Clear-Host
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "   📁 REDIRECIONAMENTO DE PASTAS DE USUÁRIO: C:\ ➔ DADOS        " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

function Detect-DataDrive {
    # 1. Procura volume BTRFS do tipo Fixed (com pastas ou sem @)
    $btrfsVolumes = Get-Volume | Where-Object { $_.FileSystem -eq 'Btrfs' -and $_.DriveType -eq 'Fixed' }
    foreach ($vol in $btrfsVolumes) {
        if ($vol.DriveLetter) {
            $r = "$($vol.DriveLetter):\"
            if ((Test-Path "$r\01_Pessoal_e_Vida") -or (Test-Path "$r\00_Inbox_Triagem") -or (Test-Path "$r\04_Desenvolvimento_e_Codigo")) {
                return "$($vol.DriveLetter):\"
            }
            if (-not (Test-Path "$r\@")) {
                return "$($vol.DriveLetter):\"
            }
        }
    }
    
    # 2. Se não encontrou Btrfs com dados, procura qualquer unidade fixa não-C com as pastas mestras
    $drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Name -ne 'C' }
    foreach ($d in $drives) {
        $isRemovable = (Get-Volume -DriveLetter $d.Name -ErrorAction SilentlyContinue).DriveType -eq 'Removable'
        if (-not $isRemovable) {
            $r = $d.Root
            if ((Test-Path "$r\01_Pessoal_e_Vida") -or (Test-Path "$r\04_Desenvolvimento_e_Codigo")) {
                return $r
            }
        }
    }
    
    return "F:\"
}

$detected = Detect-DataDrive

Write-Host "Unidades de Armazenamento Detectadas:" -ForegroundColor DarkGray
Get-Volume | Where-Object { $_.DriveLetter } | Sort-Object DriveLetter | ForEach-Object {
    $letra = "$($_.DriveLetter):\"
    $tipo = if ($_.DriveType -eq "Removable") { "Pendrive / Removível" } else { "Disco Fixo" }
    $tag = ""
    $cor = "DarkGray"
    if ($_.FileSystemLabel -like "*Ventoy*" -or ($letra -eq "D:\" -and $_.DriveType -eq "Removable")) {
        $tag = "  <-- PENDRIVE VENTOY"
        $cor = "Yellow"
    } elseif ($letra -eq $detected) {
        $tag = "  <-- PARTIÇÃO DE DADOS DETECTADA ($($_.FileSystem))"
        $cor = "Green"
    }
    Write-Host "  $letra  [$($_.FileSystem)]  $($_.FileSystemLabel)  ($tipo)$tag" -ForegroundColor $cor
}

Write-Host ""
Write-Host "Partição de dados recomendada: $detected" -ForegroundColor Green
$userInput = Read-Host "Pressione [ENTER] para confirmar $detected ou digite a letra desejada (ex: F, D, E)"

if ([string]::IsNullOrWhiteSpace($userInput)) {
    $chosen = $detected
} else {
    $letterOnly = ($userInput.Trim() -replace '[:\\]', '').ToUpper()
    $chosen = "$letterOnly`:\"
}

# Verificação se o usuário acidentalmente escolheu o pendrive
$chosenLetter = ($chosen -replace '[:\\]', '')
$vol = Get-Volume -DriveLetter $chosenLetter -ErrorAction SilentlyContinue
if ($vol.DriveType -eq "Removable" -or $vol.FileSystemLabel -like "*Ventoy*") {
    Write-Warning "Atenção: A unidade $chosen é um pendrive removível ($($vol.FileSystemLabel))!"
    $confirm = Read-Host "Tem CERTEZA absoluta que deseja redirecionar suas pastas para o PENDRIVE? (s/N)"
    if ($confirm -ne "s" -and $confirm -ne "S") {
        Write-Host "Cancelando escolha do pendrive. Usando partição de dados segura: $detected" -ForegroundColor Yellow
        $chosen = $detected
    }
}

$dataDrive = $chosen.TrimEnd('\')

if (-not (Test-Path "$dataDrive\")) {
    Write-Error "O disco $dataDrive\ não está acessível!"
    pause
    return
}

Write-Host "`nConfigurando redirecionamento para: $dataDrive\ ..." -ForegroundColor Cyan

# Definição dos Mapeamentos Canônicos
$folderMap = @(
    @{ Name = "Downloads";        RegKey = "{374DE290-123F-4565-9164-39C4925E467B}"; Target = "$dataDrive\00_Inbox_Triagem" },
    @{ Name = "Downloads_Guid";   RegKey = "{7d83ee9b-2244-4e70-b1f5-5393042af1e4}"; Target = "$dataDrive\00_Inbox_Triagem" },
    @{ Name = "Documentos";       RegKey = "Personal";                               Target = "$dataDrive\01_Pessoal_e_Vida\01.1_Identidade_e_Documentos" },
    @{ Name = "Imagens";          RegKey = "My Pictures";                            Target = "$dataDrive\05_Design_Midia_e_Criacao\05.1_Imagens_e_Fotos" },
    @{ Name = "Vídeos";           RegKey = "My Video";                               Target = "$dataDrive\05_Design_Midia_e_Criacao\05.3_Videos_e_Projetos" },
    @{ Name = "Músicas";          RegKey = "My Music";                               Target = "$dataDrive\05_Design_Midia_e_Criacao\05.2_Audios_e_Midias" },
    @{ Name = "Área de Trabalho"; RegKey = "Desktop";                                Target = "$dataDrive\Area_de_Trabalho" }
)

# 1. Criação das pastas de destino no disco de dados
Write-Host "`n[1/3] Garantindo existência das pastas em $dataDrive\..." -ForegroundColor Yellow
foreach ($item in $folderMap) {
    if (-not (Test-Path $item.Target)) {
        New-Item -ItemType Directory -Path $item.Target -Force | Out-Null
        Write-Host "  + Criada pasta: $($item.Target)" -ForegroundColor Green
    } else {
        Write-Host "  ✓ Pasta existente: $($item.Target)" -ForegroundColor DarkGreen
    }
}

# 2. Atualização no Registro do Windows (User Shell Folders)
Write-Host "`n[2/3] Atualizando User Shell Folders no Registro..." -ForegroundColor Yellow
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
foreach ($item in $folderMap) {
    Set-ItemProperty -Path $regPath -Name $item.RegKey -Value $item.Target -Force
    Write-Host "  ✓ $($item.Name) apontado para $($item.Target)" -ForegroundColor Green
}

# 3. Criação de Junções NTFS no perfil para compatibilidade absoluta
Write-Host "`n[3/3] Criando junções de diretório em $env:USERPROFILE..." -ForegroundColor Yellow
$profileJunctions = @{
    "$env:USERPROFILE\Downloads" = "$dataDrive\00_Inbox_Triagem"
    "$env:USERPROFILE\Documents" = "$dataDrive\01_Pessoal_e_Vida\01.1_Identidade_e_Documentos"
    "$env:USERPROFILE\Pictures"  = "$dataDrive\05_Design_Midia_e_Criacao\05.1_Imagens_e_Fotos"
    "$env:USERPROFILE\Videos"    = "$dataDrive\05_Design_Midia_e_Criacao\05.3_Videos_e_Projetos"
    "$env:USERPROFILE\Music"     = "$dataDrive\05_Design_Midia_e_Criacao\05.2_Audios_e_Midias"
}

foreach ($link in $profileJunctions.Keys) {
    $target = $profileJunctions[$link]
    if (Test-Path $link) {
        $files = Get-ChildItem -Path $link -Force -ErrorAction SilentlyContinue
        if ($null -eq $files -or $files.Count -eq 0) {
            Remove-Item -Path $link -Force -Recurse -ErrorAction SilentlyContinue
            cmd /c mklink /J "`"$link`"" "`"$target`"" | Out-Null
            Write-Host "  ✓ Junção criada: $link ➔ $target" -ForegroundColor Green
        } else {
            Write-Host "  ℹ Pasta $link contém arquivos existentes. Registro atualizado diretamente para $target." -ForegroundColor DarkCyan
        }
    } else {
        cmd /c mklink /J "`"$link`"" "`"$target`"" | Out-Null
        Write-Host "  ✓ Junção criada: $link ➔ $target" -ForegroundColor Green
    }
}

# 4. Nomeação estética dos discos no Windows Explorer
Write-Host "`n[4/4] Definindo rótulos dos discos no Explorer..." -ForegroundColor Yellow
$driveLabels = @{
    "C" = "Windows_OS"
    "F" = "Dados"
    "G" = "CachyOS_Linux"
}
foreach ($d in $driveLabels.Keys) {
    $dp = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons\$d\DefaultLabel"
    if (-not (Test-Path $dp)) { New-Item -Path $dp -Force | Out-Null }
    Set-ItemProperty -Path $dp -Name "(default)" -Value $driveLabels[$d] -Force
    Write-Host "  ✓ Unidade $d`: nomeada como '$($driveLabels[$d]) ($d`:)'" -ForegroundColor Green
}

# Reiniciar o Windows Explorer para carregar os novos caminhos e rótulos
Write-Host "`nReiniciando Windows Explorer para aplicar alterações instantaneamente..." -ForegroundColor Yellow
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Start-Process explorer.exe

Write-Host "`n=================================================================" -ForegroundColor Green
Write-Host "  PASTAS DE USUÁRIO REDIRECIONADAS COM SUCESSO PARA $dataDrive\  " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green
Write-Host "  - Seus downloads cairão direto em $dataDrive\00_Inbox_Triagem." -ForegroundColor White
Write-Host "  - Seus documentos, imagens e vídeos não consumirão espaço do C:\." -ForegroundColor White
Write-Host "=================================================================" -ForegroundColor Green
Write-Host ""
