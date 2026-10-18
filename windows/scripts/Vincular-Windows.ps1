param(
    [string]$DataDir = ""
)

if ([string]::IsNullOrWhiteSpace($DataDir) -or -not (Test-Path (Join-Path $DataDir "01_Pessoal_e_Vida"))) {
    $btrfsVolumes = Get-Volume | Where-Object { $_.FileSystem -eq 'Btrfs' -and $_.DriveType -eq 'Fixed' }
    foreach ($vol in $btrfsVolumes) {
        if ($vol.DriveLetter -and (Test-Path "$($vol.DriveLetter):\01_Pessoal_e_Vida")) {
            $DataDir = "$($vol.DriveLetter):\"
            break
        }
    }
    if ([string]::IsNullOrWhiteSpace($DataDir)) { $DataDir = "F:\" }
}

$DataDir = $DataDir.TrimEnd('\')

Write-Host "Iniciando criação de junções mestras no Windows (Unidade: $DataDir\)..." -ForegroundColor Cyan

$mappings = @{
    "$env:USERPROFILE\Documentos_Mestre" = "$DataDir\01_Pessoal_e_Vida"
    "$env:USERPROFILE\Estudos_Mestre"    = "$DataDir\02_Estudos_e_Concursos"
    "$env:USERPROFILE\WFIX_Mestre"       = "$DataDir\03_Profissional_WFIX"
    "$env:USERPROFILE\Projetos_Mestre"   = "$DataDir\04_Desenvolvimento_e_Codigo"
    "$env:USERPROFILE\Midia_Mestre"      = "$DataDir\05_Design_Midia_e_Criacao"
    "$env:USERPROFILE\Backups_Mestre"    = "$DataDir\06_Backups_ISOs_e_Sistemas"
}

foreach ($link in $mappings.Keys) {
    $target = $mappings[$link]
    if (Test-Path $target) {
        if (Test-Path $link) {
            Write-Host "  [EXISTE] $link já existe. Pulando." -ForegroundColor Yellow
        } else {
            cmd /c mklink /J "`"$link`"" "`"$target`"" | Out-Null
            Write-Host "  ✓ [OK] Junção criada: $link -> $target" -ForegroundColor Green
        }
    }
}

Write-Host "`nTodas as junções foram concluídas com sucesso!" -ForegroundColor Green
