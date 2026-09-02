<#
.SYNOPSIS
    Script PowerShell para execução do Organizador Master no Windows.
.DESCRIPTION
    Wrapper conveniente que chama o motor Python do Organizador Master.
.EXAMPLE
    .\Organizar-PC.ps1 -DryRun
    .\Organizar-PC.ps1 -DesktopOnly
    .\Organizar-PC.ps1 -DrivePath "D:\MeuGoogleDrive"
#>

param(
    [switch]$DryRun,
    [switch]$DesktopOnly,
    [switch]$DownloadsOnly,
    [string]$DrivePath = "",
    [switch]$ScaffoldOnly
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptDir
$mainPy = Join-Path $projectRoot "main.py"

$pythonCmd = "python"
if (-not (Get-Command "python" -ErrorAction SilentlyContinue)) {
    if (Get-Command "py" -ErrorAction SilentlyContinue) {
        $pythonCmd = "py"
    } else {
        Write-Error "Python não foi encontrado no PATH. Instale o Python 3.x para executar."
        exit 1
    }
}

$argsList = @()

if ($DryRun) { $argsList += "--dry-run" }
if ($DesktopOnly) { $argsList += "--desktop" }
if ($DownloadsOnly) { $argsList += "--downloads" }
if ($ScaffoldOnly) { $argsList += "--scaffold-only" }
if ($DrivePath -ne "") { $argsList += "--drive"; $argsList += "`"$DrivePath`"" }

if ($argsList.Count -eq 0) {
    $argsList += "--all"
}

Write-Host "Executando Organizador Master via PowerShell..." -ForegroundColor Cyan
& $pythonCmd "$mainPy" $argsList
