# ==============================================================================
#  LIMPEZA MINIMALISTA PARA JOGOS (ESPACIO MAXIMO NO SSD)
# ==============================================================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$driveBefore = Get-PSDrive C | Select-Object @{Name="FreeGB";Expression={[math]::round($_.Free/1GB, 2)}}
Write-Host "Espaco livre inicial em C: $($driveBefore.FreeGB) GB`n" -ForegroundColor Cyan

$packagesToRemove = @(
    @{ Name = "Node.js";            Id = "OpenJS.NodeJS.LTS" },
    @{ Name = "Python 3.12";        Id = "Python.Python.3.12" },
    @{ Name = "Python Launcher";    Id = "Python.Launcher" },
    @{ Name = "DBeaver SQL";        Id = "DBeaver.DBeaver.Community" },
    @{ Name = "Visual Studio Code"; Id = "Microsoft.VisualStudioCode" },
    @{ Name = "WSL";                Id = "Microsoft.WSL" },
    @{ Name = "Outlook";            Id = "Microsoft.Outlook" },
    @{ Name = "Anki";               Id = "Anki.Anki" },
    @{ Name = "Obsidian";           Id = "Obsidian.Obsidian" },
    @{ Name = "Foxit Reader";       Id = "Foxit.FoxitReader" },
    @{ Name = "Google Chrome";      Id = "Google.Chrome" },
    @{ Name = "WinRAR";             Id = "RARLab.WinRAR" },
    @{ Name = "PotPlayer";          Id = "Daum.PotPlayer" },
    @{ Name = "MPV";                Id = "shinchiro.mpv" },
    @{ Name = "Starship";           Id = "Starship.Starship" },
    @{ Name = "Fastfetch";          Id = "Fastfetch-cli.Fastfetch" },
    @{ Name = "Eza";                Id = "eza-community.eza" },
    @{ Name = "Bat";                Id = "sharkdp.bat" },
    @{ Name = "Zoxide";             Id = "ajeetdsouza.zoxide" },
    @{ Name = "Fzf";                Id = "junegunn.fzf" },
    @{ Name = "AutoHotkey";         Id = "AutoHotkey.AutoHotkey" }
)

Write-Host "Iniciando desinstalacao de programas desnecessarios para jogos..." -ForegroundColor Yellow

foreach ($pkg in $packagesToRemove) {
    Write-Host "Removendo $($pkg.Name)..." -ForegroundColor Gray
    winget uninstall --id $pkg.Id --silent -h --accept-source-agreements 2>$null
}

Write-Host "`nRemovendo pacotes UWP bloatware..." -ForegroundColor Yellow
Get-AppxPackage *DevHome* -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue

Write-Host "`nDesativando arquivo de hibernacao (libera espaco de RAM no SSD)..." -ForegroundColor Yellow
powercfg -h off 2>$null

Write-Host "`nLimpando arquivos temporarios e lixeira..." -ForegroundColor Yellow
Clear-RecycleBin -Force -ErrorAction SilentlyContinue 2>$null
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue 2>$null

$driveAfter = Get-PSDrive C | Select-Object @{Name="FreeGB";Expression={[math]::round($_.Free/1GB, 2)}}
$diff = [math]::round($driveAfter.FreeGB - $driveBefore.FreeGB, 2)

Write-Host "`n=======================================================" -ForegroundColor Green
Write-Host "Concluido com sucesso!" -ForegroundColor Green
Write-Host "Espaco livre antes: $($driveBefore.FreeGB) GB" -ForegroundColor White
Write-Host "Espaco livre agora: $($driveAfter.FreeGB) GB" -ForegroundColor Green
Write-Host "Espaco liberado:    +$diff GB" -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Green
