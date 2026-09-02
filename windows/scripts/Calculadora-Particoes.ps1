<#
.SYNOPSIS
    Calculadora e Assistente de Particionamento de SSD/HD (Organizador Master).
.DESCRIPTION
    Detecta os discos instalados na máquina ou calcula a divisão ideal para qualquer tamanho de disco (GB/TB).
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Calculadora e Assistente de Particionamento — Windows Master"

Clear-Host
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "   📐 CALCULADORA DE PARTIÇÃO INTELIGENTE (SSD / HD)             " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

# Detecta discos instalados no sistema
Write-Host "Discos detectados no seu computador:" -ForegroundColor Yellow
Get-PhysicalDisk | Select-Object DeviceId, FriendlyName, MediaType, @{Name="Tamanho Nominal (GB)"; Expression={[math]::Round($_.Size / 1GB, 1)}} | Format-Table -AutoSize

Write-Host "Opções Rápidas:" -ForegroundColor Cyan
Write-Host " [1] SSD 256 GB / 240 GB"
Write-Host " [2] SSD 480 GB / 512 GB (Seu modelo M.2 atual)"
Write-Host " [3] SSD 1 TB / 1000 GB"
Write-Host " [4] SSD 2 TB / 2000 GB"
Write-Host " [5] Digitar tamanho personalizado em GB"
Write-Host ""

$escolha = Read-Host "Escolha uma opção (1-5)"

$tamanho = 480
if ($escolha -eq "1") { $tamanho = 256 }
elseif ($escolha -eq "2") { $tamanho = 480 }
elseif ($escolha -eq "3") { $tamanho = 1000 }
elseif ($escolha -eq "4") { $tamanho = 2000 }
elseif ($escolha -eq "5") {
    $custom = Read-Host "Digite a capacidade total do disco em GB (ex: 500)"
    $tamanho = [double]$custom
}

# Chama o motor Python
$projectRoot = Split-Path -Parent $PSScriptRoot
cd "$projectRoot"
python main.py --calc-disk $tamanho

Write-Host "`n[?] Deseja abrir o Gerenciamento de Disco do Windows agora para aplicar? (S/N): " -ForegroundColor Yellow -NoNewline
$abrir = Read-Host
if ($abrir -match "^[sSyY]") {
    Start-Process "diskmgmt.msc"
}

Write-Host "`nPressione qualquer tecla para sair..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
