#!/bin/bash

# --- Cores ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

DOTFILES_DIR="$HOME/dotfiles"

info() { printf "${BLUE}[INFO]${NC} %s\n" "$1"; }
ok()   { printf "${GREEN}[OK]${NC} %s\n" "$1"; }
warn() { printf "${YELLOW}[WARN]${NC} %s\n" "$1"; }
erro() { printf "${RED}[ERRO]${NC} %s\n" "$1"; exit 1; }

# 1. Instalar yay (se não existir)
install_yay() {
    if ! command -v yay &> /dev/null; then
        info "Instalando yay..."
        sudo pacman -S --needed base-devel git --noconfirm
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay && makepkg -si --noconfirm
        cd -
    fi
    ok "yay pronto."
}

# 2. Instalar pacotes
install_packages() {
    info "Instalando pacotes nativos..."
    sudo pacman -S --needed --noconfirm - < "$DOTFILES_DIR/packages/pacman-native.txt"
    
    info "Instalando pacotes do AUR..."
    yay -S --needed --noconfirm - < "$DOTFILES_DIR/packages/pacman-aur.txt"
}

# 3. Aplicar dotfiles com stow
apply_dotfiles() {
    info "Aplicando dotfiles com GNU Stow..."
    cd "$DOTFILES_DIR"
    for dir in */; do
        dir=${dir%/}
        if [[ "$dir" != "scripts" && "$dir" != "packages" ]]; then
            info "Linkando $dir..."
            stow -t "$HOME" "$dir"
        fi
    done
}

# Execução
install_yay
install_packages
apply_dotfiles

printf "\n"
read -p "Deseja configurar o ambiente de desenvolvimento agora? (Docker, Mise, etc) [s/N] " DEV_CONF
if [[ "$DEV_CONF" =~ ^[Ss]$ ]]; then
    bash "$DOTFILES_DIR/scripts/dev-setup.sh"
fi

# --- Configuração de Sudo sem Senha ---
echo -e "\n[?] Deseja configurar o sudo para não pedir senha para o seu usuário? (s/n)"
read -r response
if [[ "$response" =~ ^([sS][iI]|[sS])$ ]]; then
    echo -e "[INFO] Configurando sudo NOPASSWD..."
    echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER-nopasswd
    sudo chmod 440 /etc/sudoers.d/$USER-nopasswd
    echo -e "[OK] Sudo configurado com sucesso!"
fi

echo -e "\n[OK] Setup concluído! Reinicie o terminal para ver as mudanças."
