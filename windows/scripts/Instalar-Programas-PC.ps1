<#
.SYNOPSIS
    Script Mestre de Setup Automatizado para Windows — Stack Power User, Developer & Gaming.
.DESCRIPTION
    Menu cronológico e guiado em 3 fases lógicas:
    FASE 1: Reconhecimento do SSD (WinBtrfs), Correções de Dual Boot (UTC) e Pastas para o Disco de Dados.
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
        @{ Name = "CopyQ (Clipboard Manager Pro)";   Id = "hluk.CopyQ" },
        @{ Name = "Flameshot (Screenshot Avançado)"; Id = "Flameshot.Flameshot" },
        @{ Name = "f.lux (Descanso Ocular)";         Id = "flux.flux" },
        @{ Name = "AB Download Manager (IDM Moderno)"; Id = "amir1376.ABDownloadManager" }
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
        @{ Name = "DBeaver (GUI Universal SQL)";     Id = "DBeaver.DBeaver.Community" }
    )
    "Hardware & Otimização de GPU" = @(
        @{ Name = "NVIDIA App (Drivers & Otimização)"; Id = "XP8CLZL93F5Z4P"; Source = "msstore" }
    )
}

function Detect-FastDataDrive {
    $btrfsVolumes = Get-Volume | Where-Object { $_.FileSystem -eq 'Btrfs' -and $_.DriveType -eq 'Fixed' }
    foreach ($vol in $btrfsVolumes) {
        if ($vol.DriveLetter) {
            $r = "$($vol.DriveLetter):\"
            if ((Test-Path "$r\01_Pessoal_e_Vida") -or (Test-Path "$r\00_Inbox_Triagem") -or (-not (Test-Path "$r\@"))) {
                return "$($vol.DriveLetter):"
            }
        }
    }
    return "F:"
}

function Ensure-Winget {
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        return $true
    }
    
    Write-Host "`nWinget não detectado. Instalando Winget Standalone Oficial da Microsoft (SEM LOJA)..." -ForegroundColor Yellow
    $tempDir = "$env:TEMP\winget_install"
    if (-not (Test-Path $tempDir)) { New-Item -ItemType Directory -Path $tempDir -Force | Out-Null }
    
    $depsZip = "$tempDir\dependencies.zip"
    $bundle = "$tempDir\winget.msixbundle"
    
    try {
        if (-not (Test-Path $depsZip)) {
            Write-Host "Baixando dependências oficiais..." -ForegroundColor Cyan
            curl.exe -L -o $depsZip "https://github.com/microsoft/winget-cli/releases/download/v1.29.380/DesktopAppInstaller_Dependencies.zip"
        }
        if (-not (Test-Path "$tempDir\deps")) {
            Expand-Archive -Path $depsZip -DestinationPath "$tempDir\deps" -Force
        }
        $deps = Get-ChildItem -Path "$tempDir\deps\x64\*.appx"
        foreach ($d in $deps) {
            Add-AppxPackage -Path $d.FullName -ErrorAction SilentlyContinue
        }
        if (-not (Test-Path $bundle)) {
            Write-Host "Baixando Winget CLI..." -ForegroundColor Cyan
            curl.exe -L -o $bundle "https://github.com/microsoft/winget-cli/releases/download/v1.29.380/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
        }
        Add-AppxPackage -Path $bundle -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        return [bool](Get-Command winget -ErrorAction SilentlyContinue)
    } catch {
        Write-Error "Falha ao instalar o Winget standalone: $_"
        return $false
    }
}

# =============================================================
# LOOP PRINCIPAL DO MENU INTERATIVO
# =============================================================
while ($true) {
    Clear-Host
    
    $dataDrive = Detect-FastDataDrive
    $hasBtrfs = [bool](Get-Volume | Where-Object { $_.FileSystem -eq 'Btrfs' })
    $btrfsStatus = if ($hasBtrfs) { " (✓ BTRFS Detectado em $dataDrive\)" } else { "" }

    Write-Host "=================================================================" -ForegroundColor Cyan
    Write-Host "   ⚡ SETUP POWER USER & DEVELOPER — WINDOWS MASTER SUITE       " -ForegroundColor Green
    Write-Host "=================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "ROTEIRO SEQUENCIAL RECOMENDADO (EM ORDEM CRONOLÓGICA):" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "--- [FASE 1: Reconhecimento do SSD, Dual Boot e Pastas] ---" -ForegroundColor Cyan
    Write-Host " [1] Instalar Driver WinBtrfs$btrfsStatus"
    Write-Host " [2] Aplicar Correções de Dual Boot (Relógio UTC, Desativar Fast Startup, Proteger Limine)"
    Write-Host " [3] Redirecionar Pastas do Usuário (Downloads, Documentos, Desktop) ➔ $dataDrive\"
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
    Write-Host " [14] Nomear Discos no Explorer (Windows_OS, Dados, CachyOS_Linux)"
    Write-Host " [15] Sair"
    Write-Host ""
    
    $opcao = Read-Host "Digite o número da opção desejada (1-15)"

    if ($opcao -eq "15") {
        Write-Host "`nSaindo da Suite de Setup. Até logo!" -ForegroundColor Yellow
        break
    }

    switch ($opcao) {
        # [1] WinBtrfs
        "1" {
            Write-Host "`nBaixando e instalando o driver WinBtrfs v1.10..." -ForegroundColor Cyan
            $btrfsZip = "$env:TEMP\btrfs-1.10.zip"
            $btrfsDir = "$env:TEMP\btrfs-driver"
            Invoke-WebRequest -Uri "https://github.com/maharmstone/btrfs/releases/download/v1.10/btrfs-1.10.zip" -OutFile $btrfsZip
            Expand-Archive -Path $btrfsZip -DestinationPath $btrfsDir -Force
            $infPath = Join-Path $btrfsDir "btrfs.inf"
            if (Test-Path $infPath) {
                pnputil.exe /add-driver $infPath /install
                Write-Host "✓ Driver WinBtrfs instalado com sucesso! Seus discos BTRFS aparecerão no Explorer." -ForegroundColor Green
            } else {
                Write-Error "Arquivo btrfs.inf não encontrado no pacote extraído."
            }
        }

        # [2] Correções de Dual Boot
        "2" {
            $dualBootScript = Join-Path $PSScriptRoot "Configurar-DualBoot-Fixes.ps1"
            if (Test-Path $dualBootScript) {
                & $dualBootScript
            } else {
                Write-Error "Script Configurar-DualBoot-Fixes.ps1 não encontrado."
            }
        }

        # [3] Redirecionar Pastas de Usuário
        "3" {
            $moveFoldersScript = Join-Path $PSScriptRoot "Mover-Pastas-Usuario-Para-D.ps1"
            if (Test-Path $moveFoldersScript) {
                & $moveFoldersScript
            } else {
                Write-Error "Script Mover-Pastas-Usuario-Para-D.ps1 não encontrado."
            }
        }

        # [4] Instalar Pacote Essencial via Winget
        "4" {
            Write-Host "`nVerificando o gerenciador de pacotes Winget..." -ForegroundColor Cyan
            if (-not (Ensure-Winget)) {
                Write-Error "Não foi possível carregar o Winget. Instalação abortada."
            } else {
                $selectedPackages = @(
                    @{ Name = "Brave Browser";                     Id = "Brave.Brave" },
                    @{ Name = "NVIDIA App (Drivers & GPU)";        Id = "XP8CLZL93F5Z4P"; Source = "msstore" },
                    @{ Name = "AB Download Manager (IDM Moderno)"; Id = "amir1376.ABDownloadManager" },
                    @{ Name = "Anki (Repetição Espaçada)";         Id = "Anki.Anki" },
                    @{ Name = "WinRAR";                            Id = "RARLab.WinRAR" },
                    @{ Name = "PotPlayer (Player Vídeo Leve)";     Id = "Daum.PotPlayer" },
                    @{ Name = "VLC Media Player";                  Id = "VideoLAN.VLC" },
                    @{ Name = "mpv (Player Minimalista)";          Id = "shinchiro.mpv" },
                    @{ Name = "ImageGlass (Visualizador Fotos)";   Id = "DuongDieuPhap.ImageGlass" },
                    @{ Name = "qBittorrent";                       Id = "qBittorrent.qBittorrent" },
                    @{ Name = "Foxit PDF Reader";                  Id = "Foxit.FoxitReader" },
                    @{ Name = "Flameshot (Captura de Tela Pro)";   Id = "Flameshot.Flameshot" },
                    @{ Name = "CopyQ (Clipboard Manager Pro)";     Id = "hluk.CopyQ" },
                    @{ Name = "Spotify";                           Id = "Spotify.Spotify" },
                    @{ Name = "f.lux (Descanso Ocular)";           Id = "flux.flux" }
                )
                
                $total = $selectedPackages.Count
                $sucessos = 0
                $falhas = 0
                Write-Host "`nIniciando a instalação de $total programas essenciais...`n" -ForegroundColor Green
                foreach ($pkg in $selectedPackages) {
                    Write-Host "=====================================================" -ForegroundColor DarkGray
                    Write-Host "Instalando: $($pkg.Name) [$($pkg.Id)]..." -ForegroundColor Cyan
                    $sourceArg = if ($pkg.Source) { "--source $($pkg.Source)" } else { "--exact" }
                    $process = Start-Process -FilePath "winget" -ArgumentList "install --id $($pkg.Id) $sourceArg --silent --accept-package-agreements --accept-source-agreements" -NoNewWindow -PassThru -Wait
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
                Write-Host " Concluídos / Já Instalados : $sucessos / $total" -ForegroundColor Green
                Write-Host "=====================================================" -ForegroundColor Green
            }
        }

        # [5] Runtimes de Jogos (Visual C++ AIO + DirectX + .NET)
        "5" {
            $runtimesScript = Join-Path $PSScriptRoot "Instalar-Runtimes-Games.ps1"
            if (Test-Path $runtimesScript) {
                & $runtimesScript
            } else {
                Write-Error "Script Instalar-Runtimes-Games.ps1 não encontrado."
            }
        }

        # [6] Dev Stack & WSL 2
        "6" {
            $devStackScript = Join-Path $PSScriptRoot "Instalar-DevStack-WSL.ps1"
            if (Test-Path $devStackScript) {
                & $devStackScript
            } else {
                Write-Error "Script Instalar-DevStack-WSL.ps1 não encontrado."
            }
        }

        # [7] Ativação MAS (Massgrave)
        "7" {
            Write-Host "`nIniciando Microsoft Activation Scripts (MAS)..." -ForegroundColor Cyan
            $localMas = Join-Path $PSScriptRoot "MAS_AIO.cmd"
            if (Test-Path $localMas) {
                Write-Host "Executando versão local offline do MAS..." -ForegroundColor Green
                Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$localMas`"" -Wait -Verb RunAs
            } else {
                $masExecuted = $false
                try {
                    Write-Host "Baixando script MAS via DoH seguro (Cloudflare)..." -ForegroundColor DarkCyan
                    $scriptText = & curl.exe -s --doh-url https://1.1.1.1/dns-query https://get.activated.win | Out-String
                    if ($scriptText -and $scriptText -match "Microsoft-Activation-Scripts") {
                        Invoke-Expression $scriptText
                        $masExecuted = $true
                    }
                } catch {
                    Write-Warning "Falha na conexão DoH: $_"
                }

                if (-not $masExecuted) {
                    try {
                        Write-Host "Tentando conexão direta via irm..." -ForegroundColor DarkCyan
                        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                        irm https://get.activated.win | iex
                        $masExecuted = $true
                    } catch {
                        Write-Warning "Conexão direta falhou (bloqueio DNS da operadora)."
                    }
                }

                if (-not $masExecuted) {
                    Write-Host "Baixando MAS_AIO.cmd oficial do GitHub..." -ForegroundColor Yellow
                    $masTemp = "$env:TEMP\MAS_AIO.cmd"
                    & curl.exe -s -L -o $masTemp "https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/master/MAS/All-In-One-Version-KL/MAS_AIO.cmd"
                    if ((Test-Path $masTemp) -and ((Get-Item $masTemp).Length -gt 50000)) {
                        Write-Host "✓ MAS baixado com sucesso! Executando..." -ForegroundColor Green
                        Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$masTemp`"" -Wait -Verb RunAs
                        $masExecuted = $true
                    }
                }

                if (-not $masExecuted) {
                    Write-Error "Não foi possível carregar o MAS. Verifique sua conexão ou acesse https://massgrave.dev manualmente."
                }
            }
        }

        # [8] Ultra Tuning de Performance
        "8" {
            $ultraTuningScript = Join-Path $PSScriptRoot "Otimizar-Desempenho-Ultra.ps1"
            if (Test-Path $ultraTuningScript) {
                & $ultraTuningScript
            } else {
                Write-Error "Script Otimizar-Desempenho-Ultra.ps1 não encontrado."
            }
        }

        # [9] Chris Titus WinUtil
        "9" {
            Write-Host "`nIniciando Chris Titus Tech WinUtil..." -ForegroundColor Cyan
            irm https://christitus.com/win | iex
        }

        # [10] Stack Completo (Todos os 30+ Programas)
        "10" {
            Write-Host "`nVerificando o gerenciador de pacotes Winget..." -ForegroundColor Cyan
            if (-not (Ensure-Winget)) {
                Write-Error "Não foi possível carregar o Winget. Instalação abortada."
            } else {
                $selectedPackages = @()
                foreach ($cat in $categories.Keys) {
                    $selectedPackages += $categories[$cat]
                }
                $total = $selectedPackages.Count
                $sucessos = 0
                $falhas = 0
                Write-Host "`nIniciando a instalação do Stack Completo ($total programas)...`n" -ForegroundColor Green
                foreach ($pkg in $selectedPackages) {
                    Write-Host "=====================================================" -ForegroundColor DarkGray
                    $sourceArg = if ($pkg.Source) { "--source $($pkg.Source)" } else { "--exact" }
                    $process = Start-Process -FilePath "winget" -ArgumentList "install --id $($pkg.Id) $sourceArg --silent --accept-package-agreements --accept-source-agreements" -NoNewWindow -PassThru -Wait
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
                Write-Host " Concluídos / Já Instalados : $sucessos / $total" -ForegroundColor Green
                Write-Host "=====================================================" -ForegroundColor Green
            }
        }

        # [11] Configurar GlazeWM
        "11" {
            $configGlazeScript = Join-Path $PSScriptRoot "Configurar-GlazeWM.ps1"
            if (Test-Path $configGlazeScript) {
                & $configGlazeScript
            } else {
                Write-Error "Script de configuração do GlazeWM não encontrado."
            }
        }

        # [12] Desativar Defender e Windows Update
        "12" {
            $disablerScript = Join-Path $PSScriptRoot "Desativar-Defender-e-WindowsUpdate.ps1"
            if (Test-Path $disablerScript) {
                & $disablerScript
            } else {
                Write-Error "Script Desativar-Defender-e-WindowsUpdate.ps1 não encontrado."
            }
        }

        # [13] Gerar Código do Brave Sync
        "13" {
            $braveSyncScript = Join-Path $PSScriptRoot "Obter-Codigo-Brave-Sync.ps1"
            if (Test-Path $braveSyncScript) {
                & $braveSyncScript
            } else {
                Write-Error "Script Obter-Codigo-Brave-Sync.ps1 não encontrado."
            }
        }

        # [14] Nomear Discos no Explorer
        "14" {
            $nomearDiscosScript = Join-Path $PSScriptRoot "Nomear-Discos.ps1"
            if (Test-Path $nomearDiscosScript) {
                & $nomearDiscosScript
            } else {
                Write-Error "Script Nomear-Discos.ps1 não encontrado."
            }
        }

        default {
            Write-Host "`nOpção inválida: '$opcao'. Escolha entre 1 e 15." -ForegroundColor Red
        }
    }

    Write-Host ""
    Write-Host "=================================================================" -ForegroundColor DarkCyan
    Write-Host " Pressione qualquer tecla para voltar à tela inicial do roteiro... " -ForegroundColor Cyan
    Write-Host "=================================================================" -ForegroundColor DarkCyan
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
