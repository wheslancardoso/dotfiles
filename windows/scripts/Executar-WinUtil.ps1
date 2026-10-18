<#
.SYNOPSIS
    Inicia o utilitário oficial Chris Titus Tech Windows Utility (WinUtil).
.DESCRIPTION
    Executa a versão mais recente do WinUtil diretamente da fonte oficial.
.NOTES
    Execute como Administrador.
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Chris Titus Tech — WinUtil"

function Check-Admin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Check-Admin)) {
    Write-Warning "O WinUtil precisa de permissões de Administrador."
    Start-Process powershell.exe -Verb RunAs -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"")
    exit
}

Clear-Host
Write-Host "Iniciando Chris Titus Tech WinUtil..." -ForegroundColor Cyan
irm https://christitus.com/win | iex
