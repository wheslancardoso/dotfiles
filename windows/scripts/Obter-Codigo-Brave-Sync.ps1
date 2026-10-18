<#
.SYNOPSIS
    Gerador Automático da Frase de 25 Palavras do Brave Sync (com a 25ª palavra dinâmica do dia).
.DESCRIPTION
    Calcula a 25ª palavra efêmera do algoritmo oficial do Brave Sync v2
    baseado no delta de dias desde 10/05/2022 (UTC) e copia a frase completa
    de 25 palavras diretamente para a Área de Transferência (Clipboard).
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Gerador Oficial Brave Sync — 25 Palavras"

Clear-Host
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "   🦁 GERADOR DE CÓDIGO BRAVE SYNC (25 PALAVRAS DINÂMICAS)      " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

$base24Words = "brave summer volcano hidden bless blur load hurry cry copper canal worry demise eternal reopen genre unit execute captain wet afraid conduct pupil shallow"

$epochDate = [DateTime]::SpecifyKind([DateTime]::Parse("2022-05-10"), [DateTimeKind]::Utc)
$todayUtc = [DateTime]::UtcNow.Date
$deltaDays = [int]($todayUtc - $epochDate).TotalDays

$bip39File = Join-Path $PSScriptRoot "bip39_english.txt"
$word25 = ""

if (Test-Path $bip39File) {
    $lines = Get-Content -Path $bip39File
    if ($deltaDays -ge 0 -and $deltaDays -lt $lines.Count) {
        $word25 = $lines[$deltaDays].Trim()
    }
}

if (-not $word25) {
    # Fallback caso bip39_english.txt não esteja no diretório: baixa direto do repositório
    try {
        $wc = New-Object System.Net.WebClient
        $rawWords = $wc.DownloadString("https://raw.githubusercontent.com/bitcoin/bips/master/bip-0039/english.txt") -split "`r?`n"
        $word25 = $rawWords[$deltaDays].Trim()
    } catch {
        Write-Warning "Não foi possível calcular a 25ª palavra automaticamente sem internet."
    }
}

if ($word25) {
    $fullSyncPhrase = "$base24Words $word25"

    # Copia automaticamente para a Área de Transferência
    try {
        Set-Clipboard -Value $fullSyncPhrase
        $copied = $true
    } catch {
        $copied = $false
    }

    Write-Host "📅 Data UTC de Referência: $($todayUtc.ToString('yyyy-MM-dd'))" -ForegroundColor DarkCyan
    Write-Host "🔢 Dias desde o Epoch (2022-05-10): $deltaDays" -ForegroundColor DarkCyan
    Write-Host "✨ 25ª Palavra de Hoje: " -NoNewline
    Write-Host "$word25" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "=================================================================" -ForegroundColor Green
    Write-Host "  FRASE COMPLETA PRONTA PARA SINCRONIZAÇÃO:" -ForegroundColor White
    Write-Host "=================================================================" -ForegroundColor Green
    Write-Host "$fullSyncPhrase" -ForegroundColor Cyan
    Write-Host "=================================================================" -ForegroundColor Green
    Write-Host ""

    if ($copied) {
        Write-Host "✓ [COPIADO!] A frase completa já está na sua Área de Transferência (Ctrl+V)!" -ForegroundColor Green
    }

    Write-Host "`nComo aplicar no Brave:" -ForegroundColor Yellow
    Write-Host "  1. Abra o Brave Browser." -ForegroundColor White
    Write-Host "  2. Digite na barra de endereços: brave://settings/braveSync" -ForegroundColor White
    Write-Host "  3. Clique em 'Começar uma nova cadeia de sincronização' ou 'Tenho um código'." -ForegroundColor White
    Write-Host "  4. Pressione Ctrl + V e clique em Confirmar." -ForegroundColor White
} else {
    Write-Error "Erro ao resolver a 25ª palavra."
}

Write-Host ""
Write-Host "Pressione qualquer tecla para sair..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
