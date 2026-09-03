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

# 1. Habilitar multilib e atualizar o sistema base
enable_multilib() {
    info "Verificando repositório multilib (necessário para Steam/Wine/Nvidia 32-bit)..."
    if [ -f /etc/pacman.conf ] && ! grep -q "^\[multilib\]" /etc/pacman.conf; then
        sudo sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf
        sudo pacman -Sy
        ok "Repositório multilib ativado."
    else
        ok "Multilib já está ativo ou configurado."
    fi
}

update_system() {
    enable_multilib
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
    for group in wheel audio input lp storage video users rfkill docker adbusers nopasswdlogin gamemode; do
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
        "ananicy-cpp.service"
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
        "pipewire-pulse.service"
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

# 7. Aplicar dotfiles com Chezmoi
apply_dotfiles() {
    info "Aplicando dotfiles com Chezmoi..."
    cd "$DOTFILES_DIR" || erro "Diretório $DOTFILES_DIR não encontrado!"
    
    # Garantir que o diretório ~/.config existe
    mkdir -p "$HOME/.config"

    # Instalar chezmoi caso não exista
    if ! command -v chezmoi &>/dev/null; then
        info "Chezmoi não encontrado no PATH. Instalando Chezmoi..."
        if command -v pacman &>/dev/null; then
            sudo pacman -S --needed chezmoi --noconfirm
        else
            mkdir -p "$HOME/.local/bin"
            sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
            export PATH="$HOME/.local/bin:$PATH"
        fi
    fi

    # Garantir o link de ~/.local/share/chezmoi para o repositório
    mkdir -p "$HOME/.local/share"
    ln -sfn "$DOTFILES_DIR" "$HOME/.local/share/chezmoi"

    # Inicializar e aplicar no modo symlink (preserva hot-reload no Hyprland/LazyVim)
    info "Inicializando e aplicando dotfiles via Chezmoi (modo symlink)..."
    chezmoi init --source "$DOTFILES_DIR" --apply --mode symlink --force
    
    ok "Dotfiles aplicados com sucesso via Chezmoi."
}

# 8. Diretórios Home em lowercase (power user style)
setup_lowercase_dirs() {
    info "Configurando diretórios Home em lowercase..."

    local dirs=(desktop downloads documents pictures videos music templates public)
    for d in "${dirs[@]}"; do
        mkdir -p "$HOME/$d"
    done

    # Migra conteúdo de pastas com inicial maiúscula, se existirem
    local -A migration=(
        [Desktop]=desktop
        [Downloads]=downloads
        [Documents]=documents
        [Pictures]=pictures
        [Videos]=videos
        [Music]=music
        [Templates]=templates
        [Public]=public
    )

    for upper in "${!migration[@]}"; do
        lower="${migration[$upper]}"
        if [ -d "$HOME/$upper" ] && [ "$upper" != "$lower" ]; then
            # Move o conteúdo e remove a pasta uppercase
            if [ "$(ls -A "$HOME/$upper" 2>/dev/null)" ]; then
                info "Migrando conteúdo de ~/$upper para ~/$lower..."
                cp -rn "$HOME/$upper/"* "$HOME/$lower/" 2>/dev/null || true
                cp -rn "$HOME/$upper/".* "$HOME/$lower/" 2>/dev/null || true
            fi
            rm -rf "$HOME/$upper"
            info "Removido ~/$upper (agora é ~/$lower)"
        fi
    done

    ok "Diretórios Home em lowercase configurados."
}

# 9. Configurações extras
setup_extras() {
    info "Configurando apps padrão..."
    if command -v yazi &> /dev/null; then
        xdg-mime default yazi.desktop inode/directory
        ok "Yazi definido como gerenciador de arquivos padrão."
    fi

    # Configura Firefox para usar XDG portal (Yazi como file picker)
    info "Configurando navegadores para usar Yazi como file picker..."
    for profile_dir in "$HOME"/.mozilla/firefox/*.default* "$HOME"/.mozilla/firefox/*.default-release*; do
        if [ -d "$profile_dir" ]; then
            if ! grep -q "widget.use-xdg-desktop-portal.file-picker" "$profile_dir/user.js" 2>/dev/null; then
                echo 'user_pref("widget.use-xdg-desktop-portal.file-picker", 1);' >> "$profile_dir/user.js"
                ok "Firefox configurado para usar XDG portal file picker."
            fi
        fi
    done

    # Variável de ambiente para apps GTK usarem o portal
    if ! grep -q "GTK_USE_PORTAL" "$HOME/.config/hypr/UserConfigs/ENVariables.conf" 2>/dev/null; then
        echo 'env = GTK_USE_PORTAL,1' >> "$HOME/.config/hypr/UserConfigs/ENVariables.conf"
        ok "GTK_USE_PORTAL habilitado para file dialogs."
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

# 9. Verificação do Hyprland
check_hyprland_install() {
    if ! command -v hyprland &> /dev/null && ! command -v Hyprland &> /dev/null; then
        warn "Hyprland não foi detectado no sistema."
        if [ -f "$DOTFILES_DIR/Arch-Hyprland-main/install-master.sh" ]; then
            echo -e "\n[?] Deseja executar a instalação base do Arch-Hyprland (drivers, Hyprland, SDDM, áudio) agora? [s/N]"
            read -r response
            if [[ "$response" =~ ^[Ss]$ ]]; then
                info "Iniciando instalador Arch-Hyprland Master..."
                bash "$DOTFILES_DIR/Arch-Hyprland-main/install-master.sh"
            fi
        fi
    fi
}

# Execução principal
update_system
install_yay
check_hyprland_install
install_packages
setup_groups
setup_services
apply_dotfiles
setup_lowercase_dirs
setup_shell
setup_extras

printf "\n"
read -p "Deseja configurar o ambiente de desenvolvimento agora? (Docker, Mise, Neovim/LazyVim) [s/N] " DEV_CONF
if [[ "$DEV_CONF" =~ ^[Ss]$ ]]; then
    if [ -f "$DOTFILES_DIR/scripts/dev-setup.sh" ]; then
        bash "$DOTFILES_DIR/scripts/dev-setup.sh"
    else
        warn "Script dev-setup.sh não encontrado."
    fi
fi

echo -e "\n${GREEN}=====================================================${NC}"
echo -e "${GREEN}     SETUP CONCLUÍDO COM SUCESSO! 🚀                 ${NC}"
echo -e "${GREEN}=====================================================${NC}"
echo -e "Dicas de comandos e apps configurados:"
echo -e "  - ${BLUE}nvim${NC}                 : Abre o LazyVim com LSP e temas"
echo -e "  - ${BLUE}zellij --layout vibe${NC} : Inicia Vibe Coding (LazyVim + Antigravity CLI)"
echo -e "  - ${BLUE}organizar${NC}            : Executa a suíte de organização de arquivos"
echo -e "  - ${BLUE}lutris / heroic${NC}      : Gerenciadores de Jogos & FitGirl Repacks (Proton-GE)"
echo -e "  - ${BLUE}vesktop${NC}              : Discord com compartilhamento de tela e áudio no Wayland"
echo -e "  - ${BLUE}easyeffects${NC}          : Filtro de ruído por IA para microfone (PipeWire)"
echo -e "  - ${BLUE}obs${NC}                  : OBS Studio com gravação NVENC (NVIDIA RTX 5060)"
echo -e "Por favor, reinicie a sessão ou o computador para aplicar todas as mudanças."
