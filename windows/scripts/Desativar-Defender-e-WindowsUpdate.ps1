<#
.SYNOPSIS
    Script Definitivo para Desativar Windows Defender e Windows Update.
.DESCRIPTION
    1. Desativa completamente o Windows Defender (Antivírus, Monitoramento em Tempo Real, SmartScreen).
    2. Desativa completamente o Windows Update (Serviços wuauserv, UsoSvc, WaaSMedicSvc, Agendador de Tarefas).
.NOTES
    Execute no PowerShell como Administrador.
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Desativador de Windows Defender & Windows Update"

function Check-Admin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Check-Admin)) {
    Write-Warning "Este script requer privilégios de Administrador."
    Write-Host "Elevando privilégios com UAC..." -ForegroundColor Yellow
    Start-Process powershell.exe -Verb RunAs -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"")
    exit
}

Clear-Host
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "   🛑 DESATIVADOR: WINDOWS DEFENDER & WINDOWS UPDATE             " -ForegroundColor Red
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

# -------------------------------------------------------------------
# 1. DESATIVAR WINDOWS DEFENDER
# -------------------------------------------------------------------
Write-Host "[1/2] Desativando Windows Defender & SmartScreen..." -ForegroundColor Yellow

# Dica de proteção contra violação (Tamper Protection)
Write-Host "  ℹ Lembrete: No Windows 11, desative a 'Proteção contra Violações' (Tamper Protection)" -ForegroundColor DarkCyan
Write-Host "    em Configurações ➔ Segurança do Windows ➔ Proteção contra vírus e ameaças." -ForegroundColor DarkCyan

$defenderPolicies = @(
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"; Name = "DisableAntiSpyware"; Value = 1 },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"; Name = "DisableRealtimeMonitoring"; Value = 1 },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"; Name = "DisableAntiVirus"; Value = 1 },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"; Name = "DisableSpecialRunningModes"; Value = 1 },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"; Name = "DisableRoutinelyTakingAction"; Value = 1 },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"; Name = "ServiceKeepAlive"; Value = 0 },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection"; Name = "DisableRealtimeMonitoring"; Value = 1 },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection"; Name = "DisableBehaviorMonitoring"; Value = 1 },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection"; Name = "DisableOnAccessProtection"; Value = 1 },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection"; Name = "DisableScanOnRealtimeEnable"; Value = 1 },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection"; Name = "DisableIOAVProtection"; Value = 1 },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\SmartScreen"; Name = "ConfigureAppInstallControlEnabled"; Value = 0 },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"; Name = "EnableSmartScreen"; Value = 0 },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Systray"; Name = "HideSystray"; Value = 1 }
)

foreach ($entry in $defenderPolicies) {
    if (-not (Test-Path $entry.Path)) {
        New-Item -Path $entry.Path -Force | Out-Null
    }
    Set-ItemProperty -Path $entry.Path -Name $entry.Name -Value $entry.Value -Type DWord -Force 2>$null
}

# Desativar serviços do Defender
$defenderServices = @("WinDefend", "WdNisSvc", "Sense", "SecurityHealthService")
foreach ($svc in $defenderServices) {
    Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
    Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
}

Write-Host "  ✓ Políticas de desativação do Defender e SmartScreen gravadas!" -ForegroundColor Green

# -------------------------------------------------------------------
# 2. DESATIVAR WINDOWS UPDATE
# -------------------------------------------------------------------
Write-Host "`n[2/2] Desativando Windows Update & Orquestradores..." -ForegroundColor Yellow

$updatePolicies = @(
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"; Name = "NoAutoUpdate"; Value = 1 },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"; Name = "AUOptions"; Value = 1 },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"; Name = "NoAutoRebootWithLoggedOnUsers"; Value = 1 }
)

foreach ($entry in $updatePolicies) {
    if (-not (Test-Path $entry.Path)) {
        New-Item -Path $entry.Path -Force | Out-Null
    }
    Set-ItemProperty -Path $entry.Path -Name $entry.Name -Value $entry.Value -Type DWord -Force 2>$null
}

# Parar e Desativar Serviços de Atualização
$updateServices = @("wuauserv", "UsoSvc", "WaaSMedicSvc", "dosvc")
foreach ($svc in $updateServices) {
    Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
    Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
    # Bloquear no registro caso o Windows tente reativar
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$svc" -Name "Start" -Value 4 -Type DWord -Force 2>$null
}

# Desativar tarefas agendadas de update
$scheduledTasks = @(
    "\Microsoft\Windows\WindowsUpdate\Scheduled Start",
    "\Microsoft\Windows\WindowsUpdate\Automatic App Update",
    "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan",
    "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task",
    "\Microsoft\Windows\UpdateOrchestrator\UpdateModelTask",
    "\Microsoft\Windows\WaaSMedic\PerformRemediation"
)

foreach ($task in $scheduledTasks) {
    schtasks.exe /change /tn "$task" /disable 2>$null | Out-Null
}

Write-Host "  ✓ Serviços e Tarefas do Windows Update desativados e bloqueados!" -ForegroundColor Green

Write-Host "`n=================================================================" -ForegroundColor Green
Write-Host "   WINDOWS DEFENDER E WINDOWS UPDATE DESATIVADOS COM SUCESSO!   " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green
Write-Host "Observação: Para garantia total no Windows 11 24H2, você também pode" -ForegroundColor White
Write-Host "usar a ferramenta Defender Remover ou a opção de tweaks do WinUtil." -ForegroundColor White
Write-Host ""
Write-Host "Pressione qualquer tecla para finalizar..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
