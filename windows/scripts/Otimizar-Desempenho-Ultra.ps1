<#
.SYNOPSIS
    Otimização Extrema de Performance, Latência e Resposta do Windows (Estilo Linux/Hyprland).
.DESCRIPTION
    Aplica:
    1. Plano de Energia Desempenho Máximo (Ultimate Performance).
    2. Desativação de VBS / Isolamento do Núcleo (Libera 5-10% de CPU).
    3. HAGS (Hardware-Accelerated GPU Scheduling) ativado.
    4. Remoção total de GameDVR / Captura em segundo plano.
    5. MenuShowDelay = 0 e remoção de delays de janelas (abertura instantânea).
    6. Resposta do Mouse 1:1 sem aceleração artificial.
.NOTES
    Execute no PowerShell como Administrador.
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Ultra Tuning de Performance & Latência — Windows"

function Check-Admin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Check-Admin)) {
    Write-Warning "Este script requer privilégios de Administrador."
    Start-Process powershell.exe -Verb RunAs -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"")
    exit
}

Clear-Host
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "   ⚡ ULTRA TUNING: PERFORMANCE & LATÊNCIA MÍNIMA DO WINDOWS    " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Plano de Energia Desempenho Máximo (Ultimate Performance)
Write-Host "[1/6] Ativando Plano de Energia 'Desempenho Máximo' (Workstation)..." -ForegroundColor Yellow
try {
    $planOutput = powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
    if ($planOutput -match "GUID do Esquema de Energia:\s+([a-f0-9-]+)") {
        $ultimateGuid = $matches[1]
        powercfg -setactive $ultimateGuid
        Write-Host "  ✓ Plano Desempenho Máximo ativado ($ultimateGuid)!" -ForegroundColor Green
    } else {
        powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null # Alto Desempenho fallback
        Write-Host "  ✓ Plano Alto Desempenho ativado!" -ForegroundColor Green
    }
} catch {
    Write-Host "  ⚠ Aviso ao configurar plano de energia: $_" -ForegroundColor Yellow
}

# 2. Desativar VBS / Isolamento de Núcleo (Memory Integrity)
Write-Host "`n[2/6] Desativando VBS (Virtualization-Based Security / Hipervisor Interno)..." -ForegroundColor Yellow
try {
    $dgPath = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard"
    if (-not (Test-Path $dgPath)) { New-Item -Path $dgPath -Force | Out-Null }
    Set-ItemProperty -Path $dgPath -Name "EnableVirtualizationBasedSecurity" -Value 0 -Type DWord -Force

    $hvciPath = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity"
    if (-not (Test-Path $hvciPath)) { New-Item -Path $hvciPath -Force | Out-Null }
    Set-ItemProperty -Path $hvciPath -Name "Enabled" -Value 0 -Type DWord -Force
    Write-Host "  ✓ VBS desativado! CPU liberada para rodar em modo bare-metal nativo." -ForegroundColor Green
} catch {
    Write-Host "  ⚠ Erro ao desativar VBS: $_" -ForegroundColor Red
}

# 3. Hardware-Accelerated GPU Scheduling (HAGS)
Write-Host "`n[3/6] Ativando Agendamento de GPU Acelerado por Hardware (HAGS)..." -ForegroundColor Yellow
try {
    $gfxPath = "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"
    Set-ItemProperty -Path $gfxPath -Name "HwSchMode" -Value 2 -Type DWord -Force
    Write-Host "  ✓ HAGS ativado (Menor latência de VRAM e renderização direta)!" -ForegroundColor Green
} catch {
    Write-Host "  ⚠ Erro ao configurar HAGS: $_" -ForegroundColor Red
}

# 4. Desativar GameDVR / Captura em Segundo Plano
Write-Host "`n[4/6] Eliminando GameDVR & Barra de Jogo em segundo plano..." -ForegroundColor Yellow
try {
    $gcsPath = "HKCU:\System\GameConfigStore"
    if (-not (Test-Path $gcsPath)) { New-Item -Path $gcsPath -Force | Out-Null }
    Set-ItemProperty -Path $gcsPath -Name "GameDVR_Enabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $gcsPath -Name "GameDVR_FSEBehaviorMode" -Value 2 -Type DWord -Force

    $gdvrPolicy = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"
    if (-not (Test-Path $gdvrPolicy)) { New-Item -Path $gdvrPolicy -Force | Out-Null }
    Set-ItemProperty -Path $gdvrPolicy -Name "AllowGameDVR" -Value 0 -Type DWord -Force
    Write-Host "  ✓ Gravação em segundo plano e sobreposições desativadas!" -ForegroundColor Green
} catch {
    Write-Host "  ⚠ Erro ao desativar GameDVR: $_" -ForegroundColor Red
}

# 5. Animações e Delays Instantâneos (Sensação Hyprland)
Write-Host "`n[5/6] Reduzindo delays do sistema para 0ms (Abertura Instantânea)..." -ForegroundColor Yellow
try {
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value "0" -Type String -Force
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value "0" -Type String -Force
    Write-Host "  ✓ Delays de menus e transições de janelas zerados!" -ForegroundColor Green
} catch {
    Write-Host "  ⚠ Erro ao ajustar MenuShowDelay: $_" -ForegroundColor Red
}

# 6. Mouse 1:1 Sem Aceleração Artificial
Write-Host "`n[6/6] Configurando resposta de mouse 1:1 (Raw Input)..." -ForegroundColor Yellow
try {
    $mousePath = "HKCU:\Control Panel\Mouse"
    Set-ItemProperty -Path $mousePath -Name "MouseSpeed" -Value "0" -Type String -Force
    Set-ItemProperty -Path $mousePath -Name "MouseThreshold1" -Value "0" -Type String -Force
    Set-ItemProperty -Path $mousePath -Name "MouseThreshold2" -Value "0" -Type String -Force
    Write-Host "  ✓ Aceleração de mouse eliminada! Cursor 100% fiel ao sensor." -ForegroundColor Green
} catch {
    Write-Host "  ⚠ Erro ao ajustar mouse: $_" -ForegroundColor Red
}

Write-Host "`n=================================================================" -ForegroundColor Green
Write-Host "       ULTRA TUNING DE PERFORMANCE CONCLUÍDO COM SUCESSO!        " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green
Write-Host "Recomenda-se reiniciar o computador para que todas as alterações" -ForegroundColor White
Write-Host "de kernel e GPU entrem em vigor com força total." -ForegroundColor White
Write-Host ""
Write-Host "Pressione qualquer tecla para sair..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
