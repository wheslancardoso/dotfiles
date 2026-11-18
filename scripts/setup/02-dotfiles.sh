#!/bin/bash
# Módulo 02: Dotfiles (Chezmoi) + Pastas da Home em Minúsculo

set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

apply_dotfiles() {
    if ! has_cmd chezmoi; then
        erro "chezmoi não encontrado. Instale-o antes de aplicar os dotfiles."
    fi

    info "Aplicando dotfiles via chezmoi (source: $DOTFILES_DIR)..."
    mkdir -p "$HOME/.config/chezmoi"
    if [ -f "$DOTFILES_DIR/.chezmoi.toml.tmpl" ]; then
        chezmoi init --apply --force --source "$DOTFILES_DIR"
    else
        chezmoi init --apply --force "$DOTFILES_DIR"
    fi
    ok "Dotfiles aplicados com sucesso."
}

setup_lowercase_dirs() {
    info "Configurando diretórios da home em minúsculo..."
    local dirs=(
        "desktop"
        "downloads"
        "templates"
        "public"
        "documents"
        "music"
        "pictures"
        "videos"
        "projetos"
    )
    for d in "${dirs[@]}"; do
        mkdir -p "$HOME/$d"
    done

    # Desabilita auto-update do xdg-user-dirs para não recriar pastas capitalizadas
    mkdir -p "$HOME/.config"
    if [ ! -f "$HOME/.config/user-dirs.conf" ]; then
        printf "enabled=False\n" > "$HOME/.config/user-dirs.conf"
    fi

    if [ ! -f "$HOME/.config/user-dirs.dirs" ]; then
        cat > "$HOME/.config/user-dirs.dirs" << 'EOF'
XDG_DESKTOP_DIR="$HOME/desktop"
XDG_DOWNLOAD_DIR="$HOME/downloads"
XDG_TEMPLATES_DIR="$HOME/templates"
XDG_PUBLICSHARE_DIR="$HOME/public"
XDG_DOCUMENTS_DIR="$HOME/documents"
XDG_MUSIC_DIR="$HOME/music"
XDG_PICTURES_DIR="$HOME/pictures"
XDG_VIDEOS_DIR="$HOME/videos"
EOF
    fi
    ok "Diretórios lowercase configurados."
}

apply_dotfiles
setup_lowercase_dirs
