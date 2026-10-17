# Setup Automatizado - Pacote Essencial (12 Programas)
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Instalador do Pacote Essencial - 12 Softwares"

function Check-Admin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Check-Admin)) {
    Start-Process powershell.exe -Verb RunAs -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"")
    exit
}

Clear-Host
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "   ⚡ INSTALANDO SEU PACOTE ESSENCIAL (12 PROGRAMAS FAVORITOS)  " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

$packages = @(
    @{ Name = "Anki (Repetição Espaçada)";         Id = "Anki.Anki" },
    @{ Name = "WinRAR";                            Id = "RARLab.WinRAR" },
    @{ Name = "PotPlayer (Vídeo Leve & HDR)";      Id = "Daum.PotPlayer" },
    @{ Name = "VLC Media Player";                  Id = "VideoLAN.VLC" },
    @{ Name = "mpv (Player Minimalista)";          Id = "shinchiro.mpv" },
    @{ Name = "ImageGlass (Visualizador de Fotos)";Id = "DuongDieuPhap.ImageGlass" },
    @{ Name = "qBittorrent";                       Id = "qBittorrent.qBittorrent" },
    @{ Name = "Foxit PDF Reader";                  Id = "Foxit.FoxitReader" },
    @{ Name = "Flameshot (Captura de Tela Pro)";   Id = "Flameshot.Flameshot" },
    @{ Name = "CopyQ (Clipboard Manager)";         Id = "Hluk.CopyQ" },
    @{ Name = "Spotify";                           Id = "Spotify.Spotify" },
    @{ Name = "f.lux (Descanso Ocular)";           Id = "FluxSoftware.Flux" }
)

$total = $packages.Count
$sucessos = 0
$falhas = 0

foreach ($pkg in $packages) {
    Write-Host "Instalando: $($pkg.Name) [$($pkg.Id)]..." -ForegroundColor Cyan
    $proc = Start-Process -FilePath "winget" -ArgumentList "install --id $($pkg.Id) --exact --silent --accept-package-agreements --accept-source-agreements" -NoNewWindow -PassThru -Wait
    if ($proc.ExitCode -eq 0 -or $proc.ExitCode -eq -1978335189) {
        Write-Host "✓ $($pkg.Name) instalado com sucesso!" -ForegroundColor Green
        $sucessos++
    } else {
        Write-Host "⚠ Erro/Aviso em: $($pkg.Name) (ExitCode: $($proc.ExitCode))" -ForegroundColor Yellow
        $falhas++
    }
}

Write-Host "`n=================================================================" -ForegroundColor Green
Write-Host " Instalação finalizada! Concluídos: $sucessos | Pendentes: $falhas" -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green
Write-Host "`nPressione qualquer tecla para sair..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
