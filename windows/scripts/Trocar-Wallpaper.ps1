<#
.SYNOPSIS
    Gerenciador e Seletor de Papéis de Parede do Arch Linux / Hyprland para Windows.
.DESCRIPTION
    Permite escolher qualquer papel de parede da sua galeria de elite ou sortear aleatoriamente,
    replicando a experiência do WallpaperSelect.sh / WallpaperRandom.sh do Hyprland no Windows.
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Seletor de Papéis de Parede — Arch Hyprland Style"

Add-Type @"
using System;
using System.Runtime.InteropServices;

public class WinWallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

function Set-DesktopWallpaper {
    param ([string]$Path)
    if (-not (Test-Path $Path)) {
        Write-Error "Arquivo de imagem não encontrado: $Path"
        return $false
    }
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WallpaperStyle" -Value "10"
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "TileWallpaper" -Value "0"
    $res = [WinWallpaper]::SystemParametersInfo(0x0014, 0, $Path, 0x01 -bor 0x02)
    return ($res -ne 0)
}

# Localizar pasta canônica de wallpapers
$wpDirs = @(
    "$env:USERPROFILE\Pictures\Wallpapers",
    "F:\05_Design_Midia_e_Criacao\wallpapers",
    "$PSScriptRoot\..\..\home\pictures\wallpapers",
    "C:\Users\lan\dotfiles\home\pictures\wallpapers"
)

$targetDir = "$env:USERPROFILE\Pictures\Wallpapers"
if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}

# Garante que todos os wallpapers estejam sincronizados na pasta do usuário
foreach ($d in $wpDirs) {
    if ((Test-Path $d) -and ($d -ne $targetDir)) {
        Get-ChildItem -Path $d -File -Recurse -Include *.png, *.jpg, *.jpeg | ForEach-Object {
            $dest = Join-Path $targetDir $_.Name
            if (-not (Test-Path $dest)) {
                Copy-Item -Path $_.FullName -Destination $dest -Force -ErrorAction SilentlyContinue
            }
        }
    }
}

$wallpapers = Get-ChildItem -Path $targetDir -File | Where-Object { $_.Extension -match '\.(png|jpg|jpeg)$' } | Sort-Object Name

if ($wallpapers.Count -eq 0) {
    Write-Warning "Nenhum papel de parede encontrado em $targetDir."
    pause
    exit
}

Clear-Host
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "   🖼️  GALERIA DE WALLPAPERS ARCH HYPRLAND — WINDOWS             " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Escolha o papel de parede desejado:" -ForegroundColor Yellow
Write-Host ""
Write-Host " [R] 🎲 Modo Aleatório (Sorteia um wallpaper agora estilo Hyprland)" -ForegroundColor Magenta
Write-Host ""

for ($i = 0; $i -lt $wallpapers.Count; $i++) {
    $idx = ($i + 1).ToString().PadLeft(2, ' ')
    Write-Host " [$idx] $($wallpapers[$i].Name)" -ForegroundColor White
}

Write-Host ""
$choice = Read-Host "Digite o número desejado ou 'R' para aleatório (1-$($wallpapers.Count))"

$selected = $null

if ($choice -match '^[Rr]$') {
    $selected = $wallpapers | Get-Random
} else {
    $num = 0
    if ([int]::TryParse($choice, [ref]$num) -and $num -ge 1 -and $num -le $wallpapers.Count) {
        $selected = $wallpapers[$num - 1]
    }
}

if ($selected) {
    Write-Host "`nAplicando wallpaper: $($selected.Name)..." -ForegroundColor Cyan
    if (Set-DesktopWallpaper -Path $selected.FullName) {
        Write-Host "✓ Papel de parede aplicado com sucesso no Windows!" -ForegroundColor Green
    } else {
        Write-Error "Falha ao definir papel de parede."
    }
} else {
    Write-Host "Opção inválida ou cancelada." -ForegroundColor Yellow
}

Start-Sleep -Seconds 2
