<#
.SYNOPSIS
    Script Mestre de Setup Automatizado para Windows — Stack Power User, Developer & Gaming.
.DESCRIPTION
    Menu cronológico e guiado em 3 fases lógicas:
    FASE 1: Reconhecimento do SSD (WinBtrfs), Correções de Dual Boot (UTC) e Pastas para D:\.
    FASE 2: Programas Essenciais (Brave, NVIDIA, AB Download, Anki), Runtimes e Dev Stack.
    FASE 3: Ativação Oficial (MAS), Ultra Tuning de Performance e Debloat Avançado.
.NOTES
    Execute no PowerShell como Administrador.
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Setup Power User & Developer — Windows Master Suite"

function Check-Admin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Check-Admin)) {
    Write-Warning "Este script precisa de privilégios de Administrador."
    Write-Host "Elevando permissões com UAC..." -ForegroundColor Yellow
    Start-Process powershell.exe -Verb RunAs -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"")
    exit
}

Clear-Host
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "   ⚡ SETUP POWER USER & DEVELOPER — WINDOWS MASTER SUITE       " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

# Categorias Estruturadas de Softwares de Elite
$categories = [ordered]@{
    "Tiling Window Manager (Estilo Hyprland)" = @(
        @{ Name = "GlazeWM (Tiling Window Manager)"; Id = "glzr-io.glazewm" },
        @{ Name = "Zebar (Status Bar HTML/CSS)";     Id = "glzr-io.zebar" }
    )
    "Navegadores & Web" = @(
        @{ Name = "Brave Browser";                   Id = "Brave.Brave" },
        @{ Name = "Google Chrome";                   Id = "Google.Chrome" }
    )
    "Sistema, Busca & Utilitários de Elite" = @(
        @{ Name = "Everything (Busca em <1s)";       Id = "voidtools.Everything" },
        @{ Name = "Flow Launcher (Barra Spotlight)"; Id = "Flow-Launcher.Flow-Launcher" },
        @{ Name = "NanaZip (7-Zip Moderno Win11)";   Id = "M2Team.NanaZip" },
        @{ Name = "WinRAR";                          Id = "RARLab.WinRAR" },
        @{ Name = "CopyQ (Clipboard Manager Pro)";   Id = "Hluk.CopyQ" },
        @{ Name = "Flameshot (Screenshot Avançado)"; Id = "Flameshot.Flameshot" },
        @{ Name = "f.lux (Descanso Ocular)";         Id = "FluxSoftware.Flux" },
        @{ Name = "AB Download Manager (IDM Moderno)"; Id = "ABDownloadManager.ABDownloadManager" }
    )
    "Produtividade & Gestão do Conhecimento" = @(
        @{ Name = "Obsidian (Second Brain / Notas)"; Id = "Obsidian.Obsidian" },
        @{ Name = "Anki (Repetição Espaçada)";       Id = "Anki.Anki" },
        @{ Name = "Foxit PDF Reader";                Id = "Foxit.FoxitReader" },
        @{ Name = "ImageGlass (Visualizador Fotos)"; Id = "DuongDieuPhap.ImageGlass" }
    )
    "Mídia, Streaming & Torrents" = @(
        @{ Name = "OBS Studio (Gravação & Stream)";  Id = "OBSProject.OBSStudio" },
        @{ Name = "PotPlayer (Player Vídeo Leve)";   Id = "Daum.PotPlayer" },
        @{ Name = "VLC Media Player";                Id = "VideoLAN.VLC" },
        @{ Name = "mpv (Player Minimalista)";        Id = "shinchiro.mpv" },
        @{ Name = "Spotify";                         Id = "Spotify.Spotify" },
        @{ Name = "qBittorrent";                     Id = "qBittorrent.qBittorrent" }
    )
    "Jogos & Gerenciamento de Saves" = @(
        @{ Name = "Steam";                           Id = "Valve.Steam" },
        @{ Name = "Heroic Games Launcher";           Id = "HeroicGamesLauncher.HeroicGamesLauncher" },
        @{ Name = "Ludusavi (Backup de Saves)";      Id = "mtkennerly.ludusavi" }
    )
    "Desenvolvimento & Banco de Dados" = @(
        @{ Name = "Windows Terminal";                Id = "Microsoft.WindowsTerminal" },
        @{ Name = "Git";                             Id = "Git.Git" },
        @{ Name = "Python 3.12";                     Id = "Python.Python.3.12" },
        @{ Name = "Node.js LTS";                     Id = "OpenJS.NodeJS.LTS" },
        @{ Name = "Visual Studio Code";              Id = "Microsoft.VisualStudioCode" },
        @{ Name = "DBeaver (GUI Universal SQL)";     Id = "dbeaver.dbeaver" }
    )
    "Hardware & Otimização de GPU" = @(
        @{ Name = "NVIDIA App (Drivers & Otimização)"; Id = "Nvidia.App" }
    )
}

Write-Host "ROTEIRO SEQUENCIAL RECOMENDADO (EM ORDEM CRONOLÓGICA):" -ForegroundColor Yellow
Write-Host ""
Write-Host "--- [FASE 1: Reconhecimento do SSD, Dual Boot e Pastas] ---" -ForegroundColor Cyan
Write-Host " [1] Instalar Driver WinBtrfs (Montar e Reconhecer Disco D:\ BTRFS)"
Write-Host " [2] Aplicar Correções de Dual Boot (Relógio UTC, Desativar Fast Startup, Proteger Limine)"
Write-Host " [3] Redirecionar Pastas do Usuário (Downloads, Documentos, Desktop) para D:\"
Write-Host ""
Write-Host "--- [FASE 2: Programas Essenciais, Runtimes de Jogos e Dev Stack] ---" -ForegroundColor Green
Write-Host " [4] Instalar PACOTE ESSENCIAL (15 Apps: Brave, NVIDIA, AB Download, Anki, etc.)"
Write-Host " [5] Instalar RUNTIMES DE JOGOS (Visual C++ AIO 2005-2022 + DirectX + .NET para Skyrim)"
Write-Host " [6] Configurar DEV STACK (Git + Chaves SSH + WSL 2 Otimizado + Antigravity)"
Write-Host ""
Write-Host "--- [FASE 3: Ativação e Ultra Tuning de Performance] ---" -ForegroundColor Magenta
Write-Host " [7] Ativação Oficial do Windows/Office (MAS - Massgrave)"
Write-Host " [8] Aplicar ULTRA TUNING DE PERFORMANCE (Plano Máximo, Sem VBS, HAGS, Latência 0)"
Write-Host " [9] Debloat e Otimização Avançada do Sistema (Chris Titus WinUtil)"
Write-Host ""
Write-Host "--- [OPÇÕES EXTRAS E UTILITÁRIOS] ---" -ForegroundColor DarkGray
Write-Host " [10] Instalar STACK COMPLETO (GlazeWM + Dev Tools + Todos os 30+ programas)"
Write-Host " [11] Configurar Apenas GlazeWM + Zebar (Tiling Window Manager Hyprland Style)"
Write-Host " [12] Desativar Windows Defender e Windows Update Definitivamente"
Write-Host " [13] Gerar Código do Brave Sync (25ª Palavra de Hoje no Clipboard)"
Write-Host " [14] Sair"
Write-Host ""
$opcao = Read-Host "Digite o número da opção desejada (1-14)"

# =============================================================
# TRATAMENTO DAS OPÇÕES DO MENU
# =============================================================

# [1] WinBtrfs
if ($opcao -eq "1") {
    Write-Host "`nBaixando e instalando o driver WinBtrfs v1.10..." -ForegroundColor Cyan
    $btrfsZip = "$env:TEMP\btrfs-1.10.zip"
    $btrfsDir = "$env:TEMP\btrfs-driver"
    Invoke-WebRequest -Uri "https://github.com/maharmstone/btrfs/releases/download/v1.10/btrfs-1.10.zip" -OutFile $btrfsZip
    Expand-Archive -Path $btrfsZip -DestinationPath $btrfsDir -Force
    $infPath = Join-Path $btrfsDir "btrfs.inf"
    if (Test-Path $infPath) {
        pnputil.exe /add-driver $infPath /install
        Write-Host "✓ Driver WinBtrfs instalado com sucesso! O disco D:\ aparecerá no Explorer." -ForegroundColor Green
    } else {
        Write-Error "Arquivo btrfs.inf não encontrado no pacote extraído."
    }
    pause
    exit
}

# [2] Correções de Dual Boot
if ($opcao -eq "2") {
    $dualBootScript = Join-Path $PSScriptRoot "Configurar-DualBoot-Fixes.ps1"
    if (Test-Path $dualBootScript) {
        & $dualBootScript
    } else {
        Write-Error "Script Configurar-DualBoot-Fixes.ps1 não encontrado."
    }
    exit
}

# [3] Redirecionar Pastas de Usuário
if ($opcao -eq "3") {
    $moveFoldersScript = Join-Path $PSScriptRoot "Mover-Pastas-Usuario-Para-D.ps1"
    if (Test-Path $moveFoldersScript) {
        & $moveFoldersScript
    } else {
        Write-Error "Script Mover-Pastas-Usuario-Para-D.ps1 não encontrado."
    }
    exit
}

# [5] Runtimes de Jogos (Visual C++ AIO + DirectX + .NET)
if ($opcao -eq "5") {
    $runtimesScript = Join-Path $PSScriptRoot "Instalar-Runtimes-Games.ps1"
    if (Test-Path $runtimesScript) {
        & $runtimesScript
    } else {
        Write-Error "Script Instalar-Runtimes-Games.ps1 não encontrado."
    }
    exit
}

# [6] Dev Stack & WSL 2
if ($opcao -eq "6") {
    $devStackScript = Join-Path $PSScriptRoot "Instalar-DevStack-WSL.ps1"
    if (Test-Path $devStackScript) {
        & $devStackScript
    } else {
        Write-Error "Script Instalar-DevStack-WSL.ps1 não encontrado."
    }
    exit
}

# [7] Ativação MAS (Massgrave)
if ($opcao -eq "7") {
    Write-Host "`nIniciando Microsoft Activation Scripts (MAS)..." -ForegroundColor Cyan
    irm https://massgrave.dev/get | iex
    exit
}

# [8] Ultra Tuning de Performance
if ($opcao -eq "8") {
    $ultraTuningScript = Join-Path $PSScriptRoot "Otimizar-Desempenho-Ultra.ps1"
    if (Test-Path $ultraTuningScript) {
        & $ultraTuningScript
    } else {
        Write-Error "Script Otimizar-Desempenho-Ultra.ps1 não encontrado."
    }
    exit
}

# [9] Chris Titus WinUtil
if ($opcao -eq "9") {
    Write-Host "`nIniciando Chris Titus Tech WinUtil..." -ForegroundColor Cyan
    irm https://christitus.com/win | iex
    exit
}

# [11] Configurar GlazeWM
if ($opcao -eq "11") {
    $configGlazeScript = Join-Path $PSScriptRoot "Configurar-GlazeWM.ps1"
    if (Test-Path $configGlazeScript) {
        & $configGlazeScript
    } else {
        Write-Error "Script de configuração do GlazeWM não encontrado."
    }
    exit
}

# [12] Desativar Defender e Windows Update
if ($opcao -eq "12") {
    $disablerScript = Join-Path $PSScriptRoot "Desativar-Defender-e-WindowsUpdate.ps1"
    if (Test-Path $disablerScript) {
        & $disablerScript
    } else {
        Write-Error "Script Desativar-Defender-e-WindowsUpdate.ps1 não encontrado."
    }
    exit
}

# [13] Gerar Código do Brave Sync
if ($opcao -eq "13") {
    $braveSyncScript = Join-Path $PSScriptRoot "Obter-Codigo-Brave-Sync.ps1"
    if (Test-Path $braveSyncScript) {
        & $braveSyncScript
    } else {
        Write-Error "Script Obter-Codigo-Brave-Sync.ps1 não encontrado."
    }
    exit
}

# [14] Sair
if ($opcao -eq "14") {
    Write-Host "Operação cancelada." -ForegroundColor Yellow
    exit
}

# =============================================================
# INSTALAÇÃO VIA WINGET: PACOTE ESSENCIAL [4] OU STACK COMPLETO [10]
# =============================================================
if ($opcao -ne "4" -and $opcao -ne "10") {
    Write-Host "Opção inválida." -ForegroundColor Red
    pause
    exit
}

Write-Host "`nVerificando o gerenciador de pacotes Winget..." -ForegroundColor Cyan
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Warning "Winget não encontrado. Instalando App Installer da Microsoft..."
    Start-Process "ms-windows-store://pdp/?productid=9NBLGGH4NNS1"
    Write-Error "Por favor, conclua a instalação do Winget pela Microsoft Store e execute este script novamente."
    pause
    exit
}

$selectedPackages = @()

if ($opcao -eq "4") {
    # PACOTE ESSENCIAL (15 Softwares Selecionados de Elite)
    $selectedPackages = @(
        @{ Name = "Brave Browser";                     Id = "Brave.Brave" },
        @{ Name = "NVIDIA App (Drivers & GPU)";        Id = "Nvidia.App" },
        @{ Name = "AB Download Manager (IDM Moderno)"; Id = "ABDownloadManager.ABDownloadManager" },
        @{ Name = "Anki (Repetição Espaçada)";         Id = "Anki.Anki" },
        @{ Name = "WinRAR";                            Id = "RARLab.WinRAR" },
        @{ Name = "PotPlayer (Player Vídeo Leve)";     Id = "Daum.PotPlayer" },
        @{ Name = "VLC Media Player";                  Id = "VideoLAN.VLC" },
        @{ Name = "mpv (Player Minimalista)";          Id = "shinchiro.mpv" },
        @{ Name = "ImageGlass (Visualizador Fotos)";   Id = "DuongDieuPhap.ImageGlass" },
        @{ Name = "qBittorrent";                       Id = "qBittorrent.qBittorrent" },
        @{ Name = "Foxit PDF Reader";                  Id = "Foxit.FoxitReader" },
        @{ Name = "Flameshot (Captura de Tela Pro)";   Id = "Flameshot.Flameshot" },
        @{ Name = "CopyQ (Clipboard Manager Pro)";     Id = "Hluk.CopyQ" },
        @{ Name = "Spotify";                           Id = "Spotify.Spotify" },
        @{ Name = "f.lux (Descanso Ocular)";           Id = "FluxSoftware.Flux" }
    )
} elseif ($opcao -eq "10") {
    # STACK COMPLETO
    foreach ($cat in $categories.Keys) {
        $selectedPackages += $categories[$cat]
    }
}

$total = $selectedPackages.Count
$sucessos = 0
$falhas = 0

Write-Host "`nIniciando a instalação de $total programas...`n" -ForegroundColor Green

foreach ($pkg in $selectedPackages) {
    Write-Host "=====================================================" -ForegroundColor DarkGray
    Write-Host "Instalando: $($pkg.Name) [$($pkg.Id)]..." -ForegroundColor Cyan
    
    $process = Start-Process -FilePath "winget" -ArgumentList "install --id $($pkg.Id) --exact --silent --accept-package-agreements --accept-source-agreements" -NoNewWindow -PassThru -Wait

    if ($process.ExitCode -eq 0) {
        Write-Host "✓ $($pkg.Name) instalado com sucesso!" -ForegroundColor Green
        $sucessos++
    } elseif ($process.ExitCode -eq -1978335189) {
        Write-Host "ℹ $($pkg.Name) já está instalado na versão mais recente." -ForegroundColor Yellow
        $sucessos++
    } else {
        Write-Host "⚠ Falha ou requer confirmação para: $($pkg.Name) (ExitCode: $($process.ExitCode))" -ForegroundColor Red
        $falhas++
    }
}

Write-Host "`n=====================================================" -ForegroundColor Green
Write-Host "                 RESUMO DA INSTALAÇÃO                " -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green
Write-Host " Concluídos / Já Instalados : $sucessos" -ForegroundColor Green
Write-Host " Falhas ou Pendentes        : $falhas" -ForegroundColor $(if ($falhas -gt 0) { "Yellow" } else { "Green" })
Write-Host "=====================================================" -ForegroundColor Green

Write-Host "`nSetup finalizado com sucesso! Pressione qualquer tecla para sair..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
