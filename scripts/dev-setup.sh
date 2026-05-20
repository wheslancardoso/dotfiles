#!/bin/bash

# --- Cores ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info() { printf "${BLUE}[INFO]${NC} %s\n" "$1"; }
ok()   { printf "${GREEN}[OK]${NC} %s\n" "$1"; }
warn() { printf "${YELLOW}[WARN]${NC} %s\n" "$1"; }

# 1. Ferramentas de Compilação Básicas
info "Instalando ferramentas de compilação (base-devel)..."
sudo pacman -S --needed --noconfirm base-devel git curl wget

# 2. Docker
if ! command -v docker &> /dev/null; then
    info "Instalando Docker..."
    sudo pacman -S --noconfirm docker docker-compose
    sudo systemctl enable --now docker
    sudo usermod -aG docker $USER
    warn "Você precisará reiniciar a sessão para usar o Docker sem sudo."
fi

# 3. Mise e Linguagens
if command -v mise &> /dev/null; then
    info "Mise detectado. Instalando runtimes configuradas..."
    mise install
    ok "Runtimes instaladas."
else
    warn "Mise não encontrado. Certifique-se de que o pacote 'mise' ou 'mise-bin' está na sua lista de pacotes."
fi

# 4. Outros utilitários úteis para o PATH
info "Instalando utilitários extras..."
sudo pacman -S --needed --noconfirm jq ripgrep fd fzf tldr

ok "Ambiente de desenvolvimento configurado!"
