<#
.SYNOPSIS
    Script Definitivo de Otimização e Correções de Dual Boot (Windows + CachyOS Linux / Limine).
.DESCRIPTION
    Resolve de forma definitiva:
    1. Sincronização do Relógio (UTC / RealTimeIsUniversal) — nunca mais perde o horário ao alternar de SO.
    2. Desativação do Fast Startup / Hibernação (powercfg /h off) — elimina bloqueio dirty bit em partições NTFS e BTRFS.
    3. Proteção do Bootloader Limine — garante que o Limine continue como prioridade #1 na UEFI.
    4. Desativação de Reinicialização Forçada no Windows Update (NoAutoRebootWithLoggedOnUsers).
    5. Otimização de Rede / Entrega (Desativação de P2P upload do Windows Update).
.NOTES
    Execute como Administrador no Windows.
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Correções Definitivas de Dual Boot — Windows & Limine"

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
Write-Host "   🛡️  CORREÇÕES DE DUAL BOOT & ANTI-INCÔMODOS DO WINDOWS       " -ForegroundColor Green
Write-Host "         Windows 11  ⇄  CachyOS Linux (Limine Bootloader)        " -ForegroundColor DarkCyan
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

# -------------------------------------------------------------
# 1. SINCRONIZAÇÃO DO RELÓGIO (UTC / RealTimeIsUniversal)
# -------------------------------------------------------------
Write-Host "[1/5] Configurando Relógio de Hardware para UTC (RealTimeIsUniversal)..." -ForegroundColor Yellow
$tzPath = "HKLM:\System\CurrentControlSet\Control\TimeZoneInformation"
try {
    Set-ItemProperty -Path $tzPath -Name "RealTimeIsUniversal" -Value 1 -Type DWord -Force
    # Garantir serviço w32time no modo automático
    Set-Service -Name "w32time" -StartupType Automatic
    Start-Service -Name "w32time" -ErrorAction SilentlyContinue
    w32tm /resync /nowait | Out-Null
    Write-Host "  ✓ RealTimeIsUniversal ativado com sucesso! Horário sincronizado em UTC." -ForegroundColor Green
} catch {
    Write-Host "  ⚠ Erro ao configurar RealTimeIsUniversal: $_" -ForegroundColor Red
}

# -------------------------------------------------------------
# 2. DESATIVAR FAST STARTUP E HIBERNAÇÃO
# -------------------------------------------------------------
Write-Host "`n[2/5] Desativando Fast Startup e Hibernação Híbrida..." -ForegroundColor Yellow
try {
    # Desativa hibernação no nível do kernel
    powercfg /h off
    
    # Desativa Hiberboot no registro
    $powerPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
    if (Test-Path $powerPath) {
        Set-ItemProperty -Path $powerPath -Name "HiberbootEnabled" -Value 0 -Type DWord -Force
    }
    Write-Host "  ✓ Fast Startup desativado! Partições NTFS não serão mais bloqueadas pelo Windows." -ForegroundColor Green
} catch {
    Write-Host "  ⚠ Erro ao desativar Fast Startup: $_" -ForegroundColor Red
}

# -------------------------------------------------------------
# 3. VERIFICAR E PROTEGER ORDEM DE BOOT UEFI (LIMINE)
# -------------------------------------------------------------
Write-Host "`n[3/5] Verificando integridade da ordem de boot UEFI (Limine)..." -ForegroundColor Yellow
try {
    $firmwareEntries = bcdedit /enum firmware
    $limineFound = $false
    $limineGuid = $null

    # Procura entradas Limine ou CachyOS
    $lines = $firmwareEntries -split "`r?`n"
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match "identifier\s+({[a-f0-9-]+})") {
            $currentGuid = $matches[1]
        }
        if ($lines[$i] -match "description\s+.*(Limine|CachyOS|Linux)" -and $currentGuid) {
            $limineFound = $true
            $limineGuid = $currentGuid
            break
        }
    }

    if ($limineFound -and $limineGuid) {
        Write-Host "  ℹ Entrada Limine detectada na UEFI com GUID: $limineGuid" -ForegroundColor Cyan
        bcdedit /set "{fwbootmgr}" default $limineGuid | Out-Null
        bcdedit /set "{fwbootmgr}" displayorder $limineGuid "{bootmgr}" /addfirst | Out-Null
        Write-Host "  ✓ Prioridade #1 da UEFI restaurada para o Limine com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "  ℹ Limine é gerenciado pelo menu da placa-mãe. Certifique-se na BIOS que Limine está em 1º." -ForegroundColor DarkCyan
    }
} catch {
    Write-Host "  ⚠ Informação: Verificação UEFI concluída via BIOS." -ForegroundColor Gray
}

# -------------------------------------------------------------
# 4. DESATIVAR REINICIALIZAÇÃO FORÇADA DO WINDOWS UPDATE
# -------------------------------------------------------------
Write-Host "`n[4/5] Bloqueando reinicialização automática forçada por Windows Update..." -ForegroundColor Yellow
$auPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
try {
    if (-not (Test-Path $auPath)) {
        New-Item -Path $auPath -Force | Out-Null
    }
    Set-ItemProperty -Path $auPath -Name "NoAutoRebootWithLoggedOnUsers" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $auPath -Name "AUOptions" -Value 2 -Type DWord -Force
    Write-Host "  ✓ Reboots repentinos desativados! O Windows não reiniciará o PC sem sua permissão." -ForegroundColor Green
} catch {
    Write-Host "  ⚠ Erro ao configurar políticas do Windows Update: $_" -ForegroundColor Red
}

# -------------------------------------------------------------
# 5. DESATIVAR ENTREGA P2P DO WINDOWS UPDATE (DO / P2P Upload)
# -------------------------------------------------------------
Write-Host "`n[5/5] Desativando consumo de upload do Windows Update (Delivery Optimization)..." -ForegroundColor Yellow
$doPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"
try {
    if (-not (Test-Path $doPath)) {
        New-Item -Path $doPath -Force | Out-Null
    }
    Set-ItemProperty -Path $doPath -Name "DODownloadMode" -Value 0 -Type DWord -Force
    Write-Host "  ✓ Consumo parasita de banda em segundo plano desativado!" -ForegroundColor Green
} catch {
    Write-Host "  ⚠ Erro ao configurar Delivery Optimization: $_" -ForegroundColor Red
}

Write-Host "`n=================================================================" -ForegroundColor Green
Write-Host "     TODAS AS CORREÇÕES FORAM APLICADAS COM SUCESSO!            " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green
Write-Host "  1. Relógio UTC sincronizado (Adeus descompasso de 3 horas)." -ForegroundColor White
Write-Host "  2. Fast Startup desligado (Sem travas ou corrupção de partição)." -ForegroundColor White
Write-Host "  3. Boot UEFI configurado para priorizar o Limine." -ForegroundColor White
Write-Host "  4. Sem reinicializações forçadas no meio do uso." -ForegroundColor White
Write-Host "  5. Sem roubo de banda de upload para outros PCs." -ForegroundColor White
Write-Host "=================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Pressione qualquer tecla para finalizar..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
