[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Nomear Discos e Partições — Windows Explorer"

Clear-Host
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "   🏷️  NOMEAR DISCOS E PARTIÇÕES NO WINDOWS EXPLORER             " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

$labels = @{
    "C" = "Windows_OS"
    "F" = "Dados"
    "G" = "CachyOS_Linux"
}

foreach ($drive in $labels.Keys) {
    $name = $labels[$drive]
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons\$drive\DefaultLabel"
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    Set-ItemProperty -Path $regPath -Name "(default)" -Value $name -Force
    Write-Host "  ✓ Unidade $drive`: definida como '$name ($drive`:)'" -ForegroundColor Green
}

Write-Host "`nAtualizando Windows Explorer para exibir os novos nomes..." -ForegroundColor Yellow
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Start-Process explorer.exe

Write-Host "`nDiscos nomeados com sucesso no 'Este Computador'!" -ForegroundColor Green
