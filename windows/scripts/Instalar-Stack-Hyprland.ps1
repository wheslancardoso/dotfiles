$packages = @(
    @{ Name = "JetBrains Mono Nerd Font"; Id = "DEVCOM.JetBrainsMonoNerdFont" },
    @{ Name = "AutoHotkey v2";            Id = "AutoHotkey.AutoHotkey" },
    @{ Name = "Starship Prompt";          Id = "Starship.Starship" },
    @{ Name = "Fastfetch";                Id = "Fastfetch-cli.Fastfetch" },
    @{ Name = "Eza";                      Id = "eza-community.eza" },
    @{ Name = "Bat";                      Id = "sharkdp.bat" },
    @{ Name = "Zoxide";                   Id = "ajeetdsouza.zoxide" },
    @{ Name = "Fzf";                      Id = "junegunn.fzf" },
    @{ Name = "TranslucentTB";            Id = "CharlesMilette.TranslucentTB" }
)

Write-Host "[1/3] Instalando Ferramentas do Ecossistema Hyprland no Windows..." -ForegroundColor Cyan

foreach ($pkg in $packages) {
    Write-Host "Instalando $($pkg.Name)..." -ForegroundColor Yellow
    winget install --id $pkg.Id --exact --silent --accept-package-agreements --accept-source-agreements
}

Write-Host "Instalacao concluida!" -ForegroundColor Green
