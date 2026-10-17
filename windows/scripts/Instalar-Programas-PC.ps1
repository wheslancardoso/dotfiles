<#
.SYNOPSIS
    Script de Instalação e Setup Automatizado para Windows — Stack Power User & Desenvolvedor de Alto Nível.
.DESCRIPTION
    Instala todos os programas essenciais, reprodutores, navegadores, ferramentas de dev,
    tiling window manager (GlazeWM), aceleração de download e produtividade via Winget.
.NOTES
    Execute no PowerShell como Administrador.
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Setup Power User & Developer — Windows Master"

function Check-Admin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Check-Admin)) {
    Write-Warning "Este script precisa de privilégios de Administrador para instalar programas."
    Write-Host "Tentando reiniciar com permissões elevadas..." -ForegroundColor Yellow
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
        @{ Name = "Google Chrome";                   Id = "Google.Chrome" },
        @{ Name = "Brave Browser";                   Id = "Brave.Brave" }
    )
    "Sistema, Busca & Utilitários de Elite" = @(
        @{ Name = "Everything (Busca em <1s)";       Id = "voidtools.Everything" },
        @{ Name = "Flow Launcher (Barra Spotlight)"; Id = "Flow-Launcher.Flow-Launcher" },
        @{ Name = "NanaZip (7-Zip Moderno Win11)";   Id = "M2Team.NanaZip" },
        @{ Name = "WinRAR";                          Id = "RARLab.WinRAR" },
        @{ Name = "CopyQ (Clipboard Manager Pro)";   Id = "Hluk.CopyQ" },
        @{ Name = "Lightshot (Screenshot Rápido)";   Id = "Skillbrains.Lightshot" },
        @{ Name = "Flameshot (Screenshot Avançado)"; Id = "Flameshot.Flameshot" },
        @{ Name = "f.lux (Descanso Ocular)";         Id = "FluxSoftware.Flux" },
        @{ Name = "AnyDesk (Acesso Remoto)";         Id = "AnyDeskSoftwareGmbH.AnyDesk" },
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
        @{ Name = "Stremio";                         Id = "SmartCode.Stremio" },
        @{ Name = "Spotify";                         Id = "Spotify.Spotify" },
        @{ Name = "qBittorrent";                     Id = "qBittorrent.qBittorrent" }
    )
    "Comunicação & Chat" = @(
        @{ Name = "Vesktop (Discord Otimizado)";     Id = "Vencord.Vesktop" },
        @{ Name = "Discord";                         Id = "Discord.Discord" },
        @{ Name = "Kotatogram / Telegram Desktop";   Id = "Telegram.TelegramDesktop" }
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
        @{ Name = "DBeaver (GUI Universal SQL)";     Id = "dbeaver.dbeaver" },
        @{ Name = "Bruno (API Client / Postman)";    Id = "Usebruno.Bruno" }
    )
    "Virtualização & Hardware" = @(
        @{ Name = "NVIDIA App (Drivers & Otimização)"; Id = "Nvidia.App" },
        @{ Name = "AMD Software: Adrenalin Edition"; Id = "AdvancedMicroDevices.AMDSoftwareAdrenalinEdition" },
        @{ Name = "Oracle VirtualBox";               Id = "Oracle.VirtualBox" },
        @{ Name = "VMware Workstation Pro (Free)";   Id = "VMware.WorkstationPro" }
    )
}

Write-Host "Escolha como deseja prosseguir:" -ForegroundColor Yellow
Write-Host " [0] Instalar Driver WinBtrfs (Montar e Reconhecer Disco D:\ BTRFS)"
Write-Host " [1] Instalar STACK COMPLETO (GlazeWM + Dev Tools + Todos os programas)"
Write-Host " [2] Instalar apenas Essenciais + Navegadores + Dev Tools (Sem Virtualização Pesada)"
Write-Host " [3] Executar apenas Configuração do GlazeWM (Hyprland Style)"
Write-Host " [4] Executar apenas Debloat e Otimização do Windows (Chris Titus WinUtil)"
Write-Host " [5] Executar apenas Ativação Oficial Windows/Office (MAS - Massgrave)"
Write-Host " [6] Sair"
Write-Host " [7] Instalar apenas meu PACOTE ESSENCIAL (12 Programas Favoritos)"
Write-Host " [8] Aplicar CORREÇÕES DE DUAL BOOT (Relógio UTC, Desativar Fast Startup, Proteger Limine)"
Write-Host " [9] Instalar RUNTIMES DE JOGOS (Visual C++ AIO 2005-2022 + DirectX + .NET)"
Write-Host " [10] DESATIVAR Windows Defender e Windows Update Definitivamente"
Write-Host " [11] Configurar DEV STACK (Git + Chaves SSH + WSL 2 Otimizado + Antigravity)"
Write-Host ""
$opcao = Read-Host "Digite a opção desejada (0-11)"

if ($opcao -eq "0") {
    Write-Host "`nBaixando e instalando o driver WinBtrfs v1.10..." -ForegroundColor Cyan
    $btrfsZip = "$env:TEMP\btrfs-1.10.zip"
    $btrfsDir = "$env:TEMP\btrfs-driver"
    Invoke-WebRequest -Uri "https://github.com/maharmstone/btrfs/releases/download/v1.10/btrfs-1.10.zip" -OutFile $btrfsZip
    Expand-Archive -Path $btrfsZip -DestinationPath $btrfsDir -Force
    $infPath = Join-Path $btrfsDir "btrfs.inf"
    if (Test-Path $infPath) {
        pnputil.exe /add-driver $infPath /install
        Write-Host "✓ Driver WinBtrfs instalado com sucesso! Reinicie o PC para o disco D:\ aparecer." -ForegroundColor Green
    } else {
        Write-Error "Arquivo btrfs.inf não encontrado no pacote extraído."
    }
    pause
    exit
}

if ($opcao -eq "3") {
    $configGlazeScript = Join-Path $PSScriptRoot "Configurar-GlazeWM.ps1"
    if (Test-Path $configGlazeScript) {
        & $configGlazeScript
    } else {
        Write-Error "Script de configuração do GlazeWM não encontrado."
    }
    exit
}

if ($opcao -eq "4") {
    Write-Host "`nIniciando Chris Titus Tech WinUtil..." -ForegroundColor Cyan
    irm https://christitus.com/win | iex
    exit
}

if ($opcao -eq "5") {
    Write-Host "`nIniciando Microsoft Activation Scripts (MAS)..." -ForegroundColor Cyan
    irm https://massgrave.dev/get | iex
    exit
}

if ($opcao -eq "6") {
    Write-Host "Operação cancelada." -ForegroundColor Yellow
    exit
}

if ($opcao -eq "8") {
    $dualBootScript = Join-Path $PSScriptRoot "Configurar-DualBoot-Fixes.ps1"
    if (Test-Path $dualBootScript) {
        & $dualBootScript
    } else {
        Write-Error "Script Configurar-DualBoot-Fixes.ps1 não encontrado."
    }
    exit
}

if ($opcao -eq "9") {
    $runtimesScript = Join-Path $PSScriptRoot "Instalar-Runtimes-Games.ps1"
    if (Test-Path $runtimesScript) {
        & $runtimesScript
    } else {
        Write-Error "Script Instalar-Runtimes-Games.ps1 não encontrado."
    }
    exit
}

if ($opcao -eq "10") {
    $disablerScript = Join-Path $PSScriptRoot "Desativar-Defender-e-WindowsUpdate.ps1"
    if (Test-Path $disablerScript) {
        & $disablerScript
    } else {
        Write-Error "Script Desativar-Defender-e-WindowsUpdate.ps1 não encontrado."
    }
    exit
}

if ($opcao -eq "11") {
    $devStackScript = Join-Path $PSScriptRoot "Instalar-DevStack-WSL.ps1"
    if (Test-Path $devStackScript) {
        & $devStackScript
    } else {
        Write-Error "Script Instalar-DevStack-WSL.ps1 não encontrado."
    }
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

# Coleta lista de pacotes
$selectedPackages = @()
if ($opcao -eq "7") {
    $selectedPackages = @(
        @{ Name = "Anki";                Id = "Anki.Anki" },
        @{ Name = "WinRAR";              Id = "RARLab.WinRAR" },
        @{ Name = "PotPlayer";           Id = "Daum.PotPlayer" },
        @{ Name = "VLC Media Player";    Id = "VideoLAN.VLC" },
        @{ Name = "mpv";                 Id = "shinchiro.mpv" },
        @{ Name = "ImageGlass";          Id = "DuongDieuPhap.ImageGlass" },
        @{ Name = "qBittorrent";         Id = "qBittorrent.qBittorrent" },
        @{ Name = "Foxit PDF Reader";    Id = "Foxit.FoxitReader" },
        @{ Name = "Flameshot";           Id = "Flameshot.Flameshot" },
        @{ Name = "CopyQ";               Id = "Hluk.CopyQ" },
        @{ Name = "Spotify";             Id = "Spotify.Spotify" },
        @{ Name = "f.lux";               Id = "FluxSoftware.Flux" }
    )
} else {
    foreach ($cat in $categories.Keys) {
        if ($opcao -eq "2" -and $cat -eq "Virtualização & Hardware") {
            continue
        }
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

# Se instalou o stack completo, oferece aplicar a config do GlazeWM
Write-Host "`nDeseja aplicar a configuração Catppuccin Mocha ao GlazeWM agora? (S/N): " -ForegroundColor Yellow -NoNewline
$glazeChoice = Read-Host
if ($glazeChoice -match "^[sSyY]") {
    $configGlazeScript = Join-Path $PSScriptRoot "Configurar-GlazeWM.ps1"
    if (Test-Path $configGlazeScript) {
        & $configGlazeScript
    }
}

Write-Host "`nDeseja abrir o utilitário de Debloat (WinUtil) agora? (S/N): " -ForegroundColor Yellow -NoNewline
$debloatChoice = Read-Host
if ($debloatChoice -match "^[sSyY]") {
    irm https://christitus.com/win | iex
}

Write-Host "`nDeseja abrir o script de Ativação do Windows/Office (MAS)? (S/N): " -ForegroundColor Yellow -NoNewline
$masChoice = Read-Host
if ($masChoice -match "^[sSyY]") {
    irm https://massgrave.dev/get | iex
}

Write-Host "`nDeseja aplicar as Correções de Dual Boot (Relógio UTC, Desativar Fast Startup, Proteger Limine)? (S/N): " -ForegroundColor Yellow -NoNewline
$dualChoice = Read-Host
if ($dualChoice -match "^[sSyY]") {
    $dualBootScript = Join-Path $PSScriptRoot "Configurar-DualBoot-Fixes.ps1"
    if (Test-Path $dualBootScript) {
        & $dualBootScript
    }
}

Write-Host "`nSetup finalizado com sucesso! Pressione qualquer tecla para sair..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
