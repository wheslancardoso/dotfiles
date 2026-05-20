#!/bin/bash

# --- Cores ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

info() { printf "${BLUE}[INFO]${NC} %s\n" "$1"; }
ok()   { printf "${GREEN}[OK]${NC} %s\n" "$1"; }
warn() { printf "${YELLOW}[WARN]${NC} %s\n" "$1"; }

mkdir -p "$DOTFILES_DIR/packages"

# 1. Exportar pacotes
step_export_packages() {
    info "Exportando lista de pacotes..."
    pacman -Qqen > "$DOTFILES_DIR/packages/pacman-native.txt"
    pacman -Qqem > "$DOTFILES_DIR/packages/pacman-aur.txt"
    ok "Listas de pacotes salvas em $DOTFILES_DIR/packages/"
}

# 2. Função para mover e linkar (Stow-ify)
stowify() {
    local folder=$1
    local source="$CONFIG_DIR/$folder"
    local target_root="$DOTFILES_DIR/$folder/.config"
    local target="$target_root/$folder"

    if [ -d "$source" ] || [ -f "$source" ]; then
        if [ -L "$source" ]; then
            info "$folder é um link simbólico. Copiando conteúdo real para o backup..."
            mkdir -p "$target_root"
            # Copia o conteúdo real, resolvendo o link
            cp -rL "$source" "$target_root/"
            # Remove o link antigo
            rm "$source"
        else
            info "Movendo $folder para dotfiles..."
            mkdir -p "$target_root"
            mv "$source" "$target_root/"
        fi
        
        info "Criando link simbólico com stow..."
        stow -t "$HOME" "$folder" -d "$DOTFILES_DIR"
        ok "$folder configurado com sucesso."
    else
        warn "Pasta $folder não encontrada em .config."
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
        zellij
    )

    for f in "${folders[@]}"; do
        stowify "$f"
    done
}

# 4. Função para arquivos na Home (como .zshrc)
stowify_home() {
    local file=$1
    local source="$HOME/$file"
    local target="$DOTFILES_DIR/$file-home/$file"

    if [ -f "$source" ] || [ -d "$source" ]; then
        if [ -L "$source" ]; then
            info "$file já é um link. Copiando conteúdo real..."
            mkdir -p "$DOTFILES_DIR/$file-home"
            cp -rL "$source" "$DOTFILES_DIR/$file-home/"
            rm "$source"
        else
            info "Movendo arquivo $file para dotfiles..."
            mkdir -p "$DOTFILES_DIR/$file-home"
            mv "$source" "$DOTFILES_DIR/$file-home/"
        fi
        stow -t "$HOME" "$file-home" -d "$DOTFILES_DIR"
        ok "$file configurado."
    fi
}

step_backup_home() {
    local files=(
        .zshrc
        .bashrc
        .ideavimrc
        .gitconfig
        .p10k.zsh
    )
    for f in "${files[@]}"; do
        stowify_home "$f"
    done
}

# Execução
step_export_packages
step_backup_configs
step_backup_home

info "Backup concluído! Verifique a pasta $DOTFILES_DIR"
