<#
.SYNOPSIS
    Script Automatizado de Backup Pré-Formatação para Windows.
.DESCRIPTION
    Coleta dados essenciais (Chaves SSH, Cofres Obsidian, Perfis, Configurações do GlazeWM/Terminal),
    e compacta tudo em um arquivo ZIP com data, pronto para subir ao Google Drive ou copiar para partição D:\.
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Backup Pré-Formatação — Organizador Master"

Clear-Host
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "   🛡️ BACKUP AUTOMATIZADO PRÉ-FORMATAÇÃO (WINDOWS)              " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

$timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$userProfile = [System.Environment]::GetFolderPath('UserProfile')
$backupTempDir = Join-Path $userProfile "Backup_Pre_Formatacao_$timestamp"
$destZipFile = Join-Path $userProfile "Desktop\BACKUP_MESTRE_$timestamp.zip"

New-Item -ItemType Directory -Path $backupTempDir -Force | Out-Null

Write-Host "Coletando arquivos e configurações essenciais..." -ForegroundColor Yellow

# 1. Chaves SSH e Configurações Git
$sshDir = Join-Path $userProfile ".ssh"
if (Test-Path $sshDir) {
    Copy-Item -Path $sshDir -Destination (Join-Path $backupTempDir "ssh_keys") -Recurse -Force
    Write-Host "✓ Chaves SSH salvas" -ForegroundColor Green
}

# 2. Configurações GlazeWM
$glazeDir = Join-Path $userProfile ".glzr"
if (Test-Path $glazeDir) {
    Copy-Item -Path $glazeDir -Destination (Join-Path $backupTempDir "glzr_config") -Recurse -Force
    Write-Host "✓ Configurações do GlazeWM salvas" -ForegroundColor Green
}

# 3. Perfis do Windows Terminal
$wtDir = Join-Path $userProfile "AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
if (Test-Path $wtDir) {
    $wtBackup = Join-Path $backupTempDir "windows_terminal"
    New-Item -ItemType Directory -Path $wtBackup -Force | Out-Null
    Copy-Item -Path (Join-Path $wtDir "settings.json") -Destination $wtBackup -Force -ErrorAction SilentlyContinue
    Write-Host "✓ Configurações do Windows Terminal salvas" -ForegroundColor Green
}

# 4. Oferece instalar/abrir o Ludusavi para Saves de Jogos
Write-Host "`n[?] Deseja executar o Ludusavi para fazer backup dos saves dos seus jogos? (S/N): " -ForegroundColor Yellow -NoNewline
$ludusaviChoice = Read-Host
if ($ludusaviChoice -match "^[sSyY]") {
    if (-not (Get-Command ludusavi -ErrorAction SilentlyContinue)) {
        Write-Host "Instalando Ludusavi via Winget..." -ForegroundColor Cyan
        winget install --id mtkennerly.ludusavi --exact --silent --accept-package-agreements --accept-source-agreements
    }
    Write-Host "Iniciando Ludusavi..." -ForegroundColor Green
    Start-Process "ludusavi.exe" -Wait
}

# 5. Compactar todo o backup em ZIP
Write-Host "`nCompactando pacote de backup final..." -ForegroundColor Cyan
Compress-Archive -Path "$backupTempDir\*" -DestinationPath $destZipFile -Force
Remove-Item -Path $backupTempDir -Recurse -Force

Write-Host "`n=================================================================" -ForegroundColor Green
Write-Host "           BACKUP CONCLUÍDO COM SUCESSO! 🚀                      " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green
Write-Host "Arquivo gerado na sua Área de Trabalho:" -ForegroundColor Cyan
Write-Host "➔ $destZipFile" -ForegroundColor Yellow
Write-Host ""
Write-Host "📌 Próximos Passos:" -ForegroundColor Cyan
Write-Host " 1. Envie este arquivo .ZIP para o seu Google Drive ou partição D:\"
Write-Host " 2. Verifique se seus documentos da pasta Documents (00_ a 06_) estão no Drive"
Write-Host " 3. Pode formatar seu computador com total tranquilidade!"
Write-Host "=================================================================" -ForegroundColor Green
Write-Host ""
pause
