<#
.SYNOPSIS
    Script para REATIVAR o Windows Defender e o Windows Update (Reversão Segura).
.DESCRIPTION
    Restaura todos os serviços, tarefas agendadas e políticas de grupo padrão do Windows.
.NOTES
    Execute no PowerShell como Administrador.
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Reativador do Windows Defender e Windows Update"

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
Write-Host "   🛡️ REATIVAÇÃO: WINDOWS DEFENDER & WINDOWS UPDATE              " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Reativar Windows Defender
Write-Host "[1/2] Reativando políticas e serviços do Windows Defender..." -ForegroundColor Yellow

$defenderPaths = @(
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender",
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection",
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\SmartScreen"
)

foreach ($path in $defenderPaths) {
    if (Test-Path $path) {
        Remove-ItemProperty -Path $path -Name "DisableAntiSpyware" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $path -Name "DisableRealtimeMonitoring" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $path -Name "DisableAntiVirus" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $path -Name "DisableBehaviorMonitoring" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $path -Name "DisableOnAccessProtection" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $path -Name "DisableScanOnRealtimeEnable" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $path -Name "DisableIOAVProtection" -ErrorAction SilentlyContinue
    }
}

# Restaurar serviços do Defender
$defenderServices = @("WinDefend", "WdNisSvc", "SecurityHealthService")
foreach ($svc in $defenderServices) {
    Set-Service -Name $svc -StartupType Automatic -ErrorAction SilentlyContinue
    Start-Service -Name $svc -ErrorAction SilentlyContinue
}
Write-Host "  ✓ Políticas e serviços do Defender restaurados com sucesso!" -ForegroundColor Green

# 2. Reativar Windows Update
Write-Host "`n[2/2] Reativando serviços e tarefas do Windows Update..." -ForegroundColor Yellow

$auPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
if (Test-Path $auPath) {
    Remove-ItemProperty -Path $auPath -Name "NoAutoUpdate" -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $auPath -Name "AUOptions" -Value 2 -Type DWord -Force # 2 = Notificar antes de baixar
}

$updateServices = @("wuauserv", "UsoSvc", "WaaSMedicSvc", "dosvc")
foreach ($svc in $updateServices) {
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$svc" -Name "Start" -Value 3 -Type DWord -Force 2>$null
    Set-Service -Name $svc -StartupType Manual -ErrorAction SilentlyContinue
}

# Reativar tarefas agendadas
$scheduledTasks = @(
    "\Microsoft\Windows\WindowsUpdate\Scheduled Start",
    "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan"
)
foreach ($task in $scheduledTasks) {
    schtasks.exe /change /tn "$task" /enable 2>$null | Out-Null
}

Write-Host "  ✓ Windows Update restaurado para o modo padrão seguro!" -ForegroundColor Green

Write-Host "`n=================================================================" -ForegroundColor Green
Write-Host "   SISTEMA RESTAURADO: DEFENDER E WINDOWS UPDATE REATIVADOS!    " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Pressione qualquer tecla para finalizar..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
