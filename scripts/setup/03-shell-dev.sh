#!/bin/bash
# Módulo 03: Git, Shell (ZSH), Runtimes (mise/uv/rust), Neovim, Yazi, Docker, Antigravity CLI

set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"

setup_git() {
    if ! has_cmd git; then
        return 0
    fi
    info "Configurando padrões globais do Git..."
    git config --global init.defaultBranch main
    git config --global core.autocrlf input
    git config --global credential.helper store
    if [ -z "$(git config --global user.name 2>/dev/null || true)" ]; then
        git config --global user.name "wheslancardoso"
    fi
    if [ -z "$(git config --global user.email 2>/dev/null || true)" ]; then
        git config --global user.email "wheslancardoso1@gmail.com"
    fi
    ok "Git configurado."
}

setup_shell() {
    if has_cmd zsh; then
        local zsh_path
        zsh_path=$(command -v zsh)
        if [ "${SHELL:-}" != "$zsh_path" ]; then
            info "Definindo zsh ($zsh_path) como shell padrão..."
            sudo chsh -s "$zsh_path" "$USER" || warn "Não foi possível alterar shell via chsh."
        fi
        ok "Shell ZSH configurado."
    fi
}

setup_runtimes() {
    if ! has_cmd mise; then
        info "Instalando mise via script oficial..."
        curl -fsSL https://mise.run | sh 2>/dev/null || warn "Falha ao instalar mise."
        export PATH="$HOME/.local/bin:$PATH"
    fi

    if has_cmd mise; then
        mkdir -p "$HOME/.config/mise"
        if [ ! -e "$HOME/.config/mise/config.toml" ] && [ -f "$DOTFILES_DIR/home/dot_config/mise/config.toml" ]; then
            cp -f "$DOTFILES_DIR/home/dot_config/mise/config.toml" "$HOME/.config/mise/config.toml"
        fi
        info "Provisionando runtimes do mise (config.toml)..."
        mise install -y 2>/dev/null || warn "Algum runtime do mise falhou; verifique posteriormente."
        ok "Runtimes mise sincronizadas."
    fi

    if has_cmd rustup && ! rustup show active-toolchain >/dev/null 2>&1; then
        info "Inicializando toolchain Rust (stable)..."
        rustup default stable 2>/dev/null || warn "Falha ao inicializar rustup."
    fi
}

setup_yazi_default() {
    if has_cmd xdg-mime && [ -f /usr/share/applications/yazi.desktop ]; then
        info "Definindo yazi como gerenciador de arquivos padrão..."
        xdg-mime default yazi.desktop inode/directory 2>/dev/null || true
        ok "yazi definido como padrão para inode/directory."
    fi

    if has_cmd ya; then
        info "Sincronizando plugins do Yazi..."
        ya pack -i 2>/dev/null || true
        ok "Plugins do Yazi sincronizados."
    fi
}

setup_neovim_headless() {
    if has_cmd nvim && [ -f "$HOME/.config/nvim/init.lua" ]; then
        info "Sincronizando plugins do Neovim (LazyVim) em modo headless..."
        nvim --headless "+Lazy! sync" +qa 2>/dev/null || warn "Lazy sync headless retornou aviso."
        ok "Neovim sincronizado."
    fi
}

setup_docker() {
    if has_cmd docker; then
        sudo usermod -aG docker "$USER" 2>/dev/null || true
        if has_systemd; then
            sudo systemctl enable --now docker.socket 2>/dev/null || true
        fi
        ok "Docker configurado para o usuário $USER."
    fi
}

setup_antigravity_cli() {
    if ! has_cmd agy && ! has_cmd antigravity; then
        info "Instalando Antigravity CLI (agy)..."
        curl -fsSL https://antigravity.google/cli/install.sh | bash 2>/dev/null || warn "Falha ao instalar Antigravity CLI."
    fi
    mkdir -p "$HOME/.gemini/antigravity-cli"
    if [ ! -f "$HOME/.gemini/antigravity-cli/settings.json" ]; then
        cat > "$HOME/.gemini/antigravity-cli/settings.json" << 'EOF'
{
  "permissionMode": "always-proceed"
}
EOF
    fi
    ok "Antigravity CLI configurado."
}

setup_git
setup_shell
setup_runtimes
setup_yazi_default
setup_neovim_headless
setup_docker
setup_antigravity_cli
