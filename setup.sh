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

# Pede senha do sudo logo no início
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

info "Iniciando instalação e configuração do sistema..."

# 1. Atualizar o sistema base
update_system() {
    info "Atualizando o sistema..."
    sudo pacman -Syu --noconfirm
    ok "Sistema atualizado."
}

# 2. Instalar yay (se não existir)
install_yay() {
    if ! command -v yay &> /dev/null; then
        info "Instalando yay (AUR Helper)..."
        sudo pacman -S --needed base-devel git --noconfirm
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay && makepkg -si --noconfirm
        cd -
        rm -rf /tmp/yay
    fi
    ok "Yay está instalado."
}

# 3. Instalar pacotes nativos e AUR
install_packages() {
    info "Instalando pacotes nativos (pacman)..."
    sudo pacman -S --needed --noconfirm - < "$DOTFILES_DIR/packages/pacman-native.txt"
    ok "Pacotes nativos instalados."
    
    info "Instalando pacotes do AUR (yay)..."
    yay -S --needed --noconfirm - < "$DOTFILES_DIR/packages/pacman-aur.txt"
    ok "Pacotes AUR instalados."
}

# 4. Configurar grupos de usuário
setup_groups() {
    info "Adicionando usuário aos grupos necessários..."
    for group in wheel audio input lp storage video users rfkill docker adbusers nopasswdlogin; do
        if getent group "$group" >/dev/null; then
            sudo gpasswd -a "$USER" "$group" >/dev/null
        else
            warn "Grupo $group não existe, ignorando."
        fi
    done
    ok "Grupos configurados."
}

# 5. Habilitar serviços do sistema (Systemd)
setup_services() {
    info "Habilitando serviços do sistema..."
    local sys_services=(
        "NetworkManager.service"
        "bluetooth.service"
        "sddm.service"
        "docker.service"
        "ufw.service"
        "systemd-timesyncd.service"
        "avahi-daemon.service"
    )

    for svc in "${sys_services[@]}"; do
        if systemctl list-unit-files "$svc" >/dev/null 2>&1; then
            sudo systemctl enable "$svc"
        else
            warn "Serviço $svc não encontrado."
        fi
    done

    info "Habilitando serviços de usuário..."
    local usr_services=(
        "pipewire.service"
        "wireplumber.service"
        "xdg-user-dirs.service"
    )

    for svc in "${usr_services[@]}"; do
        systemctl --user enable "$svc" 2>/dev/null || warn "Falha ao habilitar $svc para o usuário."
    done

    ok "Serviços configurados."
}

# 6. Configurar Shell (ZSH)
setup_shell() {
    info "Configurando o ZSH como shell padrão..."
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        info "Instalando Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # Instalação de plugins do ZSH
    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    [ ! -d "$zsh_custom/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom/plugins/zsh-autosuggestions"
    [ ! -d "$zsh_custom/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$zsh_custom/plugins/zsh-syntax-highlighting"
    [ ! -d "$zsh_custom/plugins/zsh-history-substring-search" ] && git clone https://github.com/zsh-users/zsh-history-substring-search "$zsh_custom/plugins/zsh-history-substring-search"
    
    # Muda o shell padrão para ZSH
    if [[ "$SHELL" != *"zsh"* ]]; then
        sudo chsh -s "$(which zsh)" "$USER"
    fi
    ok "Shell configurado."
}

# 7. Aplicar dotfiles com stow
apply_dotfiles() {
    info "Aplicando dotfiles com GNU Stow..."
    cd "$DOTFILES_DIR" || erro "Diretório $DOTFILES_DIR não encontrado!"
    
    # Garantir que o diretório ~/.config existe antes do stow
    mkdir -p "$HOME/.config"

    for dir in */; do
        dir=${dir%/}
        if [[ "$dir" != "scripts" && "$dir" != "packages" && "$dir" != ".git" ]]; then
            info "Linkando $dir..."
            stow -t "$HOME" "$dir" --adopt # --adopt pega o que já existe no sistema caso haja conflito
        fi
    done
    
    # Reverte possíveis modificações no dotfiles caso o --adopt tenha pego arquivos locais indesejados
    git restore . 2>/dev/null
    
    ok "Dotfiles aplicados com sucesso."
}

# 8. Configurações extras
setup_extras() {
    info "Configurando apps padrão..."
    if command -v yazi &> /dev/null; then
        xdg-mime default yazi.desktop inode/directory
        ok "Yazi definido como gerenciador de arquivos padrão."
    fi

    echo -e "\n[?] Deseja configurar o sudo para não pedir senha para o seu usuário? (s/n)"
    read -r response
    if [[ "$response" =~ ^([sS][iI]|[sS])$ ]]; then
        info "Configurando sudo NOPASSWD..."
        echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER-nopasswd >/dev/null
        sudo chmod 440 /etc/sudoers.d/$USER-nopasswd
        ok "Sudo sem senha configurado!"
    fi
}

# Execução principal
update_system
install_yay
install_packages
setup_groups
setup_services
apply_dotfiles
setup_shell
setup_extras

printf "\n"
read -p "Deseja configurar o ambiente de desenvolvimento agora? (Docker, Mise, etc) [s/N] " DEV_CONF
if [[ "$DEV_CONF" =~ ^[Ss]$ ]]; then
    if [ -f "$DOTFILES_DIR/scripts/dev-setup.sh" ]; then
        bash "$DOTFILES_DIR/scripts/dev-setup.sh"
    else
        warn "Script dev-setup.sh não encontrado."
    fi
fi

echo -e "\n${GREEN}===============================================${NC}"
echo -e "${GREEN}     SETUP CONCLUÍDO COM SUCESSO! 🚀           ${NC}"
echo -e "${GREEN}===============================================${NC}"
echo -e "Por favor, reinicie a sessão ou o computador para aplicar todas as mudanças (especialmente os grupos e o novo shell)."
