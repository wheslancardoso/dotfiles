<#
.SYNOPSIS
    Redirecionamento Automatizado das Pastas do Usuário do Windows para a Partição D:\ (BTRFS/Dados).
.DESCRIPTION
    Move e vincula de forma 100% transparente:
    - Downloads       ➔ D:\00_Inbox_Triagem (igual ao Linux ~/downloads)
    - Documentos      ➔ D:\01_Pessoal_e_Vida\01.1_Identidade_e_Documentos
    - Imagens         ➔ D:\05_Design_Midia_e_Criacao\05.1_Imagens_e_Fotos
    - Vídeos          ➔ D:\05_Design_Midia_e_Criacao\05.3_Videos_e_Projetos
    - Músicas         ➔ D:\05_Design_Midia_e_Criacao\05.2_Audios_e_Midias
    - Área de Trabalho ➔ D:\Area_de_Trabalho
    
    Aplica tanto no Registro do Windows (User Shell Folders) quanto via Junções NTFS (mklink /J),
    garantindo que qualquer programa antigo ou novo grave direto no disco D:\ sem encher o C:\.
.NOTES
    Execute no PowerShell como Administrador.
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Redirecionamento de Pastas do Usuário para o Disco D:\"

function Check-Admin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Check-Admin)) {
    Write-Warning "Este script requer privilégios de Administrador."
    Write-Host "Elevando com UAC..." -ForegroundColor Yellow
    Start-Process powershell.exe -Verb RunAs -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"")
    exit
}

Clear-Host
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "   📁 REDIRECIONAMENTO DE PASTAS DE USUÁRIO: C:\ ➔ D:\          " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

$dataDrive = "D:\"
if (-not (Test-Path $dataDrive)) {
    Write-Error "O disco D:\ não foi detectado! Certifique-se de instalar o driver WinBtrfs primeiro (Opção [0])."
    pause
    exit
}

# Definição dos Mapeamentos Canônicos
$folderMap = @(
    @{ Name = "Downloads";        RegKey = "{374DE290-123F-4565-9164-39C4925E467B}"; Target = "D:\00_Inbox_Triagem" },
    @{ Name = "Downloads_Guid";   RegKey = "{7d83ee9b-2244-4e70-b1f5-5393042af1e4}"; Target = "D:\00_Inbox_Triagem" },
    @{ Name = "Documentos";       RegKey = "Personal";                               Target = "D:\01_Pessoal_e_Vida\01.1_Identidade_e_Documentos" },
    @{ Name = "Imagens";          RegKey = "My Pictures";                            Target = "D:\05_Design_Midia_e_Criacao\05.1_Imagens_e_Fotos" },
    @{ Name = "Vídeos";           RegKey = "My Video";                               Target = "D:\05_Design_Midia_e_Criacao\05.3_Videos_e_Projetos" },
    @{ Name = "Músicas";          RegKey = "My Music";                               Target = "D:\05_Design_Midia_e_Criacao\05.2_Audios_e_Midias" },
    @{ Name = "Área de Trabalho"; RegKey = "Desktop";                                Target = "D:\Area_de_Trabalho" }
)

# 1. Criação das pastas de destino no disco D:\
Write-Host "[1/3] Garantindo existência das pastas no disco D:\..." -ForegroundColor Yellow
foreach ($item in $folderMap) {
    if (-not (Test-Path $item.Target)) {
        New-Item -ItemType Directory -Path $item.Target -Force | Out-Null
        Write-Host "  + Criada pasta: $($item.Target)" -ForegroundColor Green
    }
}

# 2. Atualização no Registro do Windows (User Shell Folders)
Write-Host "`n[2/3] Atualizando User Shell Folders no Registro..." -ForegroundColor Yellow
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
foreach ($item in $folderMap) {
    Set-ItemProperty -Path $regPath -Name $item.RegKey -Value $item.Target -Force
    Write-Host "  ✓ $($item.Name) apontado para $($item.Target)" -ForegroundColor Green
}

# 3. Criação de Junções NTFS no perfil para compatibilidade absoluta
Write-Host "`n[3/3] Criando junções de diretório em $env:USERPROFILE..." -ForegroundColor Yellow
$profileJunctions = @{
    "$env:USERPROFILE\Downloads" = "D:\00_Inbox_Triagem"
    "$env:USERPROFILE\Documents" = "D:\01_Pessoal_e_Vida\01.1_Identidade_e_Documentos"
    "$env:USERPROFILE\Pictures"  = "D:\05_Design_Midia_e_Criacao\05.1_Imagens_e_Fotos"
    "$env:USERPROFILE\Videos"    = "D:\05_Design_Midia_e_Criacao\05.3_Videos_e_Projetos"
    "$env:USERPROFILE\Music"     = "D:\05_Design_Midia_e_Criacao\05.2_Audios_e_Midias"
}

foreach ($link in $profileJunctions.Keys) {
    $target = $profileJunctions[$link]
    if (Test-Path $link) {
        # Se for pasta vazia padrão, podemos remover para dar lugar à junção
        $files = Get-ChildItem -Path $link -Force -ErrorAction SilentlyContinue
        if ($files.Count -eq 0) {
            Remove-Item -Path $link -Force -Recurse -ErrorAction SilentlyContinue
            cmd /c mklink /J "`"$link`"" "`"$target`"" | Out-Null
            Write-Host "  ✓ Junção criada: $link ➔ $target" -ForegroundColor Green
        } else {
            Write-Host "  ℹ Pasta $link contém arquivos. Mantenha os arquivos ou mova manualmente para $target." -ForegroundColor DarkCyan
        }
    } else {
        cmd /c mklink /J "`"$link`"" "`"$target`"" | Out-Null
        Write-Host "  ✓ Junção criada: $link ➔ $target" -ForegroundColor Green
    }
}

# Reiniciar o Windows Explorer para carregar os novos caminhos
Write-Host "`nReiniciando Windows Explorer para aplicar alterações instantaneamente..." -ForegroundColor Yellow
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Start-Process explorer.exe

Write-Host "`n=================================================================" -ForegroundColor Green
Write-Host "     PASTAS DE USUÁRIO REDIRECIONADAS COM SUCESSO PARA D:\       " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green
Write-Host "  - Seus downloads cairão direto em D:\00_Inbox_Triagem." -ForegroundColor White
Write-Host "  - Seus documentos, imagens e vídeos não consumirão espaço do C:\." -ForegroundColor White
Write-Host "=================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Pressione qualquer tecla para sair..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
