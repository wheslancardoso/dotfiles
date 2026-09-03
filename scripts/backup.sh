#!/bin/bash

# Configurações de cores para output
VERDE='\033[0;32m'
AZUL='\033[0;34m'
AMARELO='\033[1;33m'
RESET='\033[0m'

info() { echo -e "${AZUL}[INFO]${RESET} $1"; }
ok() { echo -e "${VERDE}[OK]${RESET} $1"; }
warn() { echo -e "${AMARELO}[AVISO]${RESET} $1"; }

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

# 1. Exportar listas de pacotes instalados
step_export_packages() {
    info "Exportando lista de pacotes..."
    mkdir -p "$DOTFILES_DIR/packages"
    if command -v pacman &>/dev/null; then
        pacman -Qqe | grep -vx "$(pacman -Qqm)" > "$DOTFILES_DIR/packages/pacman-native.txt"
        pacman -Qqm > "$DOTFILES_DIR/packages/pacman-aur.txt"
        ok "Listas de pacotes atualizadas."
    fi
}

# 2. Adicionar itens ao Chezmoi
chezmoi_add() {
    local target=$1
    if [ -e "$target" ]; then
        info "Adicionando ao Chezmoi: $target"
        chezmoi add "$target"
        ok "$target sincronizado com Chezmoi."
    fi
}

# 3. Lista de pastas do .config para backup
step_backup_configs() {
    local folders=(
        hypr
        waybar
        swaync
        rofi
        yazi
        nvim
        alacritty
        kitty
        ghostty
        wezterm
        fish
        wallust
        fastfetch
        btop
        cava
        wlogout
        swappy
        xarchiver
        Thunar
        micro
        mise
        qt5ct
        qt6ct
        quickshell
        Kvantum
        zellij
        starship.toml
        xdg-desktop-portal-termfilechooser
    )

    for f in "${folders[@]}"; do
        chezmoi_add "$CONFIG_DIR/$f"
    done
}

# 4. Arquivos na Home
step_backup_home() {
    local files=(
        .zshrc
        .bashrc
        .ideavimrc
        .gitconfig
    )
    for f in "${files[@]}"; do
        chezmoi_add "$HOME/$f"
    done
}

# Execução
step_export_packages
step_backup_configs
step_backup_home

info "Garantindo aplicação em modo symlink..."
chezmoi apply --mode symlink --force

ok "Backup concluído via Chezmoi! Verifique $DOTFILES_DIR"
