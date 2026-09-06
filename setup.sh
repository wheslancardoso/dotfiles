#!/bin/bash

# --- Cores ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

info() { printf "${BLUE}[INFO]${NC} %s\n" "$1"; }
ok()   { printf "${GREEN}[OK]${NC} %s\n" "$1"; }
warn() { printf "${YELLOW}[WARN]${NC} %s\n" "$1"; }
erro() { printf "${RED}[ERRO]${NC} %s\n" "$1"; exit 1; }

# Pede senha do sudo logo no início
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Configuração imediata de Sudo NOPASSWD para eliminar qualquer prompt posterior
setup_sudo_nopasswd() {
    info "Configurando sudo sem senha (NOPASSWD) para $USER..."
    echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/99-$USER-nopasswd" >/dev/null
    sudo chmod 440 "/etc/sudoers.d/99-$USER-nopasswd"
    if sudo visudo -cf "/etc/sudoers.d/99-$USER-nopasswd" >/dev/null 2>&1; then
        ok "Sudo sem senha configurado com sucesso! Nunca mais será pedida senha de root para este usuário."
    else
        sudo rm -f "/etc/sudoers.d/99-$USER-nopasswd"
        warn "Falha na validação do sudoers com visudo. NOPASSWD revertido por segurança."
    fi
}
setup_sudo_nopasswd

info "Iniciando instalação e configuração do sistema..."

# Detecção de ambiente: Ubuntu / Debian / WSL
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "${ID:-}" = "ubuntu" ] || [ "${ID:-}" = "debian" ] || [ -n "${WSL_DISTRO_NAME:-}" ]; then
        info "Sistema Ubuntu/Debian/WSL detectado (${PRETTY_NAME:-WSL})."
        info "Executando o setup dedicado de desenvolvimento para Ubuntu/WSL..."
        exec "$DOTFILES_DIR/scripts/setup-ubuntu-wsl.sh" "$@"
    fi
fi

# 1. Otimizações de desempenho e visual do Pacman & Multilib
setup_pacman_turbo() {
    info "Configurando Pacman Turbo (10 downloads simultâneos, cores e animação ILoveCandy)..."
    if [ -f /etc/pacman.conf ]; then
        sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
        sudo sed -i 's/^#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf
        sudo sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 10/' /etc/pacman.conf
        sudo sed -i 's/^ParallelDownloads = .*/ParallelDownloads = 10/' /etc/pacman.conf
        if ! grep -q "ILoveCandy" /etc/pacman.conf; then
            sudo sed -i '/^Color/a ILoveCandy' /etc/pacman.conf
        fi
        ok "Pacman Turbo configurado com sucesso!"
    fi

    # Otimização de espelhos no CachyOS
    if command -v cachyos-rate-mirrors >/dev/null 2>&1; then
        info "Otimizando espelhos CachyOS com cachyos-rate-mirrors..."
        sudo cachyos-rate-mirrors 2>/dev/null || true
    elif command -v reflector >/dev/null 2>&1; then
        info "Otimizando espelhos do Pacman com Reflector (Brasil & América do Sul)..."
        sudo reflector --country Brazil,Chile,Argentina --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist --threads "$(nproc)" 2>/dev/null || warn "Reflector não pôde atualizar mirrorlist no momento. Continuando..."
    fi
}

setup_makepkg_turbo() {
    info "Configurando Makepkg Turbo (compilação multi-core e compressão Zstd multi-thread)..."
    local cores
    cores=$(nproc 2>/dev/null || echo 4)
    if [ -f /etc/makepkg.conf ]; then
        # Habilitar MAKEFLAGS multi-core
        if grep -q "^#MAKEFLAGS=" /etc/makepkg.conf; then
            sudo sed -i "s/^#MAKEFLAGS=.*/MAKEFLAGS=\"-j${cores}\"/" /etc/makepkg.conf
        elif grep -q "^MAKEFLAGS=" /etc/makepkg.conf; then
            sudo sed -i "s/^MAKEFLAGS=.*/MAKEFLAGS=\"-j${cores}\"/" /etc/makepkg.conf
        else
            echo "MAKEFLAGS=\"-j${cores}\"" | sudo tee -a /etc/makepkg.conf >/dev/null
        fi

        # Otimizar compressão Zstd e Xz para usar todas as threads da CPU
        sudo sed -i "s/^COMPRESSZST=.*/COMPRESSZST=(zstd -c -z -q --threads=0 -)/" /etc/makepkg.conf 2>/dev/null || true
        sudo sed -i "s/^COMPRESSXZ=.*/COMPRESSXZ=(xz -c -z - --threads=0)/" /etc/makepkg.conf 2>/dev/null || true
        ok "Makepkg Turbo configurado com $cores núcleos (até 10x mais rápido no AUR)!"
    fi
}

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
    setup_pacman_turbo
    setup_makepkg_turbo
    enable_multilib
    info "Atualizando o sistema..."
    sudo pacman -Syu --noconfirm
    ok "Sistema atualizado."
}

# 2. Instalar yay (AUR Helper preferido)
install_yay() {
    if ! command -v yay &> /dev/null; then
        info "Instalando yay (AUR Helper preferido)..."
        if sudo pacman -S --needed --noconfirm yay 2>/dev/null; then
            ok "Yay instalado com sucesso via repositório oficial CachyOS!"
        else
            sudo pacman -S --needed base-devel git --noconfirm
            git clone https://aur.archlinux.org/yay.git /tmp/yay
            cd /tmp/yay && makepkg -si --noconfirm
            cd -
            rm -rf /tmp/yay
        fi
    fi
    ok "Yay está pronto para uso."
}

# 3. Instalar pacotes nativos e AUR com tolerância a falhas
install_packages() {
    local aur_helper="yay"
    if ! command -v yay &>/dev/null && command -v paru &>/dev/null; then
        aur_helper="paru"
    fi

    info "Instalando pacotes nativos (pacman)..."
    if ! sudo pacman -S --needed --noconfirm - < "$DOTFILES_DIR/packages/pacman-native.txt"; then
        warn "Instalação em lote encontrou pendências. Executando modo tolerante pacote a pacote..."
        while IFS= read -r pkg || [ -n "$pkg" ]; do
            [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue
            sudo pacman -S --needed --noconfirm "$pkg" 2>/dev/null || warn "Pacote nativo '$pkg' ignorado ou não encontrado. Continuando..."
        done < "$DOTFILES_DIR/packages/pacman-native.txt"
    fi
    ok "Pacotes nativos instalados."
    
    info "Instalando pacotes do AUR ($aur_helper)..."
    if ! $aur_helper -S --needed --noconfirm - < "$DOTFILES_DIR/packages/pacman-aur.txt"; then
        warn "Instalação em lote do AUR encontrou pendências. Executando modo tolerante pacote a pacote..."
        while IFS= read -r pkg || [ -n "$pkg" ]; do
            [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue
            $aur_helper -S --needed --noconfirm "$pkg" 2>/dev/null || warn "Pacote AUR '$pkg' ignorado ou falhou. Continuando..."
        done < "$DOTFILES_DIR/packages/pacman-aur.txt"
    fi
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
        "paccache.timer"
        "power-profiles-daemon.service"
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
        "organizador-watcher.service"
        "rclone-gdrive.service"
    )

    for svc in "${usr_services[@]}"; do
        systemctl --user enable "$svc" 2>/dev/null || warn "Falha ao habilitar $svc para o usuário."
    done

    # Regras de Firewall UFW para KDE Connect (descoberta na rede local Wi-Fi)
    if command -v ufw >/dev/null 2>&1; then
        info "Configurando regras do UFW para KDE Connect (portas 1714-1764 UDP/TCP)..."
        sudo ufw allow 1714:1764/udp comment 'KDE Connect' >/dev/null 2>&1 || true
        sudo ufw allow 1714:1764/tcp comment 'KDE Connect' >/dev/null 2>&1 || true
    fi

    ok "Serviços configurados."
}


# 5.1. Blindagem do GNOME Keyring e PAM (Desbloqueio Automático)
setup_keyring() {
    info "Configurando GNOME Keyring, libsecret e PAM para desbloqueio automático sem senha..."

    # Garantir pacotes essenciais
    sudo pacman -S --needed --noconfirm gnome-keyring libsecret seahorse

    # Configurar PAM do SDDM para desbloquear o chaveiro no login
    if [ -f /etc/pam.d/sddm ]; then
        if ! grep -q "pam_gnome_keyring.so" /etc/pam.d/sddm; then
            sudo cp /etc/pam.d/sddm /etc/pam.d/sddm.bak_$(date +%s)
            sudo sed -i '/auth.*system-login/a auth optional pam_gnome_keyring.so' /etc/pam.d/sddm
            sudo sed -i '/session.*system-login/a session optional pam_gnome_keyring.so auto_start' /etc/pam.d/sddm
            sudo sed -i '/password.*system-login/a password optional pam_gnome_keyring.so' /etc/pam.d/sddm
            ok "PAM do SDDM integrado com gnome-keyring!"
        fi
    fi

    # Configurar PAM do Login TTY
    if [ -f /etc/pam.d/login ]; then
        if ! grep -q "pam_gnome_keyring.so" /etc/pam.d/login; then
            sudo cp /etc/pam.d/login /etc/pam.d/login.bak_$(date +%s)
            sudo sed -i '/auth.*system-local-login/a auth optional pam_gnome_keyring.so' /etc/pam.d/login
            sudo sed -i '/session.*system-local-login/a session optional pam_gnome_keyring.so auto_start' /etc/pam.d/login
            sudo sed -i '/password.*system-local-login/a password optional pam_gnome_keyring.so' /etc/pam.d/login
            ok "PAM do Login TTY integrado com gnome-keyring!"
        fi
    fi

    # Configurar o chaveiro padrão "login"
    mkdir -p "$HOME/.local/share/keyrings"
    chmod 700 "$HOME/.local/share/keyrings"
    if [ ! -f "$HOME/.local/share/keyrings/default" ]; then
        echo "login" > "$HOME/.local/share/keyrings/default"
    fi

    # Configurar flags para Chromium / Brave / Electron / VS Code / Antigravity
    mkdir -p "$HOME/.config"
    for flag_file in electron-flags.conf chrome-flags.conf chromium-flags.conf code-flags.conf brave-flags.conf; do
        if [ ! -f "$HOME/.config/$flag_file" ] || ! grep -q "password-store" "$HOME/.config/$flag_file" 2>/dev/null; then
            echo "--password-store=gnome-libsecret" >> "$HOME/.config/$flag_file"
        fi
    done
    ok "GNOME Keyring blindado: credenciais de IDEs, navegadores e Git salvas sem popups!"
}

# 5.2. Configurar Git & Credenciais de Forma Segura (Sem vazar tokens em repositórios públicos)
setup_git() {
    info "Configurando Git e credenciais de forma segura..."
    git config --global user.name "wheslancardoso"
    git config --global user.email "wheslancardoso1@gmail.com"
    git config --global init.defaultBranch main
    git config --global credential.helper store
    git config --global core.autocrlf input

    # Verifica se já existe ~/.git-credentials
    if [ -f "$HOME/.git-credentials" ] && grep -q "github.com" "$HOME/.git-credentials"; then
        ok "Credenciais do GitHub já configuradas localmente em ~/.git-credentials."
    else
        # Se fornecido por variável de ambiente GITHUB_TOKEN ou se o usuário quiser inserir interativamente
        local token="${GITHUB_TOKEN:-}"
        if [ -z "$token" ] && [ -t 0 ]; then
            echo -ne "${BLUE}[INFO]${NC} Deseja configurar seu GitHub Personal Access Token (PAT) agora? [s/N]: "
            read -r resp
            if [[ "$resp" =~ ^[Ss]$ ]]; then
                echo -ne "Cole seu token do GitHub (não será exibido no terminal): "
                read -rs token
                echo ""
            fi
        fi

        if [ -n "$token" ]; then
            echo "https://wheslancardoso:${token}@github.com" > "$HOME/.git-credentials"
            chmod 600 "$HOME/.git-credentials"
            ok "Token do GitHub configurado em ~/.git-credentials (permissão 600 estrita)."
            if command -v gh &>/dev/null; then
                echo "$token" | gh auth login --with-token 2>/dev/null && ok "GitHub CLI (gh) autenticado com sucesso!" || true
            fi
        else
            info "Token do GitHub não informado no momento. Pode ser configurado quando desejar."
        fi
    fi
    ok "Git configurado para wheslancardoso."
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
    [ ! -d "$zsh_custom/plugins/you-should-use" ] && git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "$zsh_custom/plugins/you-should-use"
    [ ! -d "$zsh_custom/plugins/zsh-autopair" ] && git clone https://github.com/hlissner/zsh-autopair.git "$zsh_custom/plugins/zsh-autopair"
    
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
    
    # Garantia de links diretos para arquivos mestres críticos
    ln -sf "$DOTFILES_DIR/home/dot_zshrc" "$HOME/.zshrc"
    ln -sf "$DOTFILES_DIR/home/dot_bashrc" "$HOME/.bashrc"
    ln -sf "$DOTFILES_DIR/home/dot_gitconfig" "$HOME/.gitconfig"
    [ -f "$DOTFILES_DIR/home/dot_ideavimrc" ] && ln -sf "$DOTFILES_DIR/home/dot_ideavimrc" "$HOME/.ideavimrc"

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

    # Associações de Aplicativos Padrão (PDF, Vídeo, Documentos)
    info "Configurando associações padrão de arquivos (PDF, Vídeos, Documentos)..."
    if command -v okular &>/dev/null; then
        xdg-mime default org.kde.okular.desktop application/pdf
    elif command -v zathura &>/dev/null; then
        xdg-mime default org.pwmt.zathura.desktop application/pdf
    fi

    if command -v celluloid &>/dev/null; then
        xdg-mime default io.github.celluloid_player.Celluloid.desktop video/mp4 video/mkv video/x-matroska video/quicktime video/webm video/x-msvideo
    elif command -v mpv &>/dev/null; then
        xdg-mime default mpv.desktop video/mp4 video/mkv video/x-matroska video/quicktime video/webm video/x-msvideo
    fi

    if command -v onlyoffice-desktopeditors &>/dev/null; then
        xdg-mime default onlyoffice-desktopeditors.desktop application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document application/vnd.ms-excel application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.ms-powerpoint application/vnd.openxmlformats-officedocument.presentationml.presentation
    fi

    # Configurar Navegador Padrão (Brave Browser prioritário)
    info "Configurando Brave Browser como navegador padrão do sistema..."
    xdg-settings set default-web-browser brave-browser.desktop 2>/dev/null || true
    xdg-mime default brave-browser.desktop text/html x-scheme-handler/http x-scheme-handler/https x-scheme-handler/about x-scheme-handler/unknown 2>/dev/null || true

    ok "Associações padrão configuradas."
}

# 9.1. Blindagem de Antiatritos do Sistema (Suspensão, Wakeup Espúrio, Desligamento Rápido, ZRAM, Kernel)
setup_anti_friction() {
    info "Aplicando blindagem de antiatritos do sistema..."

    local sys_src="$DOTFILES_DIR/system/etc"

    # 1. NVIDIA Suspensão & VRAM Preservation (evita tela preta ou crash do Hyprland ao acordar)
    if [ -d "$sys_src/modprobe.d" ]; then
        sudo mkdir -p /etc/modprobe.d
        sudo cp -f "$sys_src/modprobe.d/nvidia-power-management.conf" /etc/modprobe.d/
        for svc in nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service; do
            if systemctl list-unit-files "$svc" >/dev/null 2>&1; then
                sudo systemctl enable "$svc" 2>/dev/null || true
            fi
        done
        ok "NVIDIA VRAM preservation e serviços de suspensão configurados!"
    fi

    # 2. Desligamento Instantâneo (Timeout de 10s no Systemd em vez de 90s-120s)
    if [ -d "$sys_src/systemd/system.conf.d" ]; then
        sudo mkdir -p /etc/systemd/system.conf.d /etc/systemd/user.conf.d
        sudo cp -f "$sys_src/systemd/system.conf.d/timeout.conf" /etc/systemd/system.conf.d/
        sudo cp -f "$sys_src/systemd/user.conf.d/timeout.conf" /etc/systemd/user.conf.d/
        ok "Timeout de encerramento rápido (10s) configurado!"
    fi

    # 3. ZRAM Swap Ultra-rápido com Compressão ZSTD (Zero travamento de RAM / OOM freeze)
    if [ -f "$sys_src/systemd/zram-generator.conf" ]; then
        sudo mkdir -p /etc/systemd
        sudo cp -f "$sys_src/systemd/zram-generator.conf" /etc/systemd/
        if systemctl list-unit-files "systemd-zram-setup@zram0.service" >/dev/null 2>&1; then
            sudo systemctl enable "systemd-zram-setup@zram0.service" 2>/dev/null || true
        fi
        ok "ZRAM Swap comprimido (zstd) configurado!"
    fi

    # 4. Limites de Kernel para Desenvolvedores e Gamers (Zero ENOSPC no Vite/Docker, max_map_count alto)
    if [ -f "$sys_src/sysctl.d/99-anti-friction-limits.conf" ]; then
        sudo mkdir -p /etc/sysctl.d
        sudo cp -f "$sys_src/sysctl.d/99-anti-friction-limits.conf" /etc/sysctl.d/
        sudo sysctl --system >/dev/null 2>&1 || true
        ok "Limites de kernel (inotify 524288, max_map_count, BBR) aplicados!"
    fi

    # 5. Bluetooth: AutoEnable e Conexão Instantânea FastConnectable
    if [ -f "$sys_src/bluetooth/main.conf" ]; then
        sudo mkdir -p /etc/bluetooth
        sudo cp -f "$sys_src/bluetooth/main.conf" /etc/bluetooth/
        ok "Bluetooth AutoEnable e FastConnectable ativados!"
    fi

    # 6. Desativar Wake-on-LAN no NetworkManager (evita que pacotes de rede acordem o PC da suspensão)
    if [ -f "$sys_src/NetworkManager/conf.d/disable-wol.conf" ]; then
        sudo mkdir -p /etc/NetworkManager/conf.d
        sudo cp -f "$sys_src/NetworkManager/conf.d/disable-wol.conf" /etc/NetworkManager/conf.d/
        ok "Wake-on-LAN desativado no NetworkManager!"
    fi

    # 7. Regras Udev Anti-Wakeup Espúrio (movimentos acidentais ou poeira no sensor do mouse)
    if [ -f "$sys_src/udev/rules.d/90-disable-spurious-mouse-wakeup.rules" ]; then
        sudo mkdir -p /etc/udev/rules.d
        sudo cp -f "$sys_src/udev/rules.d/90-disable-spurious-mouse-wakeup.rules" /etc/udev/rules.d/
        sudo udevadm control --reload-rules 2>/dev/null || true
        ok "Regras udev anti-wakeup espúrio no mouse instaladas!"
    fi

    # 8. Script e Serviço para desativar gatilhos espúrios em /proc/acpi/wakeup (GLAN, XHC)
    if [ -f "$DOTFILES_DIR/scripts/disable-spurious-acpi-wakeup.sh" ]; then
        sudo cp -f "$DOTFILES_DIR/scripts/disable-spurious-acpi-wakeup.sh" /usr/local/bin/
        sudo chmod +x /usr/local/bin/disable-spurious-acpi-wakeup.sh
        if [ -f "$sys_src/systemd/system/disable-spurious-acpi-wakeup.service" ]; then
            sudo cp -f "$sys_src/systemd/system/disable-spurious-acpi-wakeup.service" /etc/systemd/system/
            sudo systemctl daemon-reload 2>/dev/null || true
            sudo systemctl enable disable-spurious-acpi-wakeup.service 2>/dev/null || true
        fi
        ok "Serviço anti-wakeup espúrio do ACPI habilitado!"
    fi

    # 9. Limite de tamanho de logs no SSD (Journald 500MB)
    if [ -f "$sys_src/systemd/journald.conf.d/size-limit.conf" ]; then
        sudo mkdir -p /etc/systemd/journald.conf.d
        sudo cp -f "$sys_src/systemd/journald.conf.d/size-limit.conf" /etc/systemd/journald.conf.d/
        ok "Limite de tamanho do Journald (500MB) configurado!"
    fi

    # 10. Servidores NTP brasileiros de baixa latência e ajuste do relógio RTC
    if [ -f "$sys_src/systemd/timesyncd.conf.d/ntp-brasil.conf" ]; then
        sudo mkdir -p /etc/systemd/timesyncd.conf.d
        sudo cp -f "$sys_src/systemd/timesyncd.conf.d/ntp-brasil.conf" /etc/systemd/timesyncd.conf.d/
        sudo timedatectl set-local-rtc 0 --adjust-system-clock 2>/dev/null || true
        sudo timedatectl set-ntp true 2>/dev/null || true
        ok "Relógio NTP e timesyncd configurados!"
    fi

    # 11. Pacman Hooks de Estabilidade (NVIDIA mkinitcpio auto-sync & paccache)
    if [ -d "$sys_src/pacman.d/hooks" ]; then
        sudo mkdir -p /etc/pacman.d/hooks
        sudo cp -f "$sys_src/pacman.d/hooks/"*.hook /etc/pacman.d/hooks/
        ok "Pacman hooks de estabilidade de boot (NVIDIA mkinitcpio) instalados!"
    fi

    # 12. Desativar coredumps no SSD (evita gigabytes desperdiçados em crashes de apps/jogos)
    if [ -d "$sys_src/systemd/coredump.conf.d" ]; then
        sudo mkdir -p /etc/systemd/coredump.conf.d
        sudo cp -f "$sys_src/systemd/coredump.conf.d/disable.conf" /etc/systemd/coredump.conf.d/
        ok "Coredumps desativados para preservar SSD!"
    fi

    # 13. Áudio Audiófilo PipeWire & WirePlumber (Bit-perfect, Resampler SoX Q10, LDAC 990k)
    if [ -d "$sys_src/pipewire" ]; then
        sudo mkdir -p /etc/pipewire/pipewire.conf.d /etc/pipewire/pipewire-pulse.conf.d
        [ -d "$sys_src/pipewire/pipewire.conf.d" ] && sudo cp -f "$sys_src/pipewire/pipewire.conf.d/"*.conf /etc/pipewire/pipewire.conf.d/
        [ -d "$sys_src/pipewire/pipewire-pulse.conf.d" ] && sudo cp -f "$sys_src/pipewire/pipewire-pulse.conf.d/"*.conf /etc/pipewire/pipewire-pulse.conf.d/
        ok "PipeWire Audiophile Engine configurado (Bit-Perfect, 192kHz dinâmico e Resampler SoX Q10)!"
    fi

    if [ -d "$sys_src/wireplumber/wireplumber.conf.d" ]; then
        sudo mkdir -p /etc/wireplumber/wireplumber.conf.d
        sudo cp -f "$sys_src/wireplumber/wireplumber.conf.d/"*.conf /etc/wireplumber/wireplumber.conf.d/
        ok "WirePlumber configurado para LDAC 990k, anti-suspensão e alta resolução!"
    fi

    # 13.1. Presets de Áudio EasyEffects (Dolby Atmos, Bass Boost & Convolver IRS)
    if [ -f "$DOTFILES_DIR/scripts/setup-audio-presets.sh" ]; then
        info "Instalando presets de áudio estúdio e Dolby Atmos (EasyEffects)..."
        bash "$DOTFILES_DIR/scripts/setup-audio-presets.sh" >/dev/null 2>&1 || true
        ok "Presets de áudio audiófilos (Dolby Atmos / Bass Boost) instalados!"
    fi

    # 14. Flags de aceleração GPU por hardware e Wayland nativo para navegadores e apps Electron
    for f in chrome-flags.conf chromium-flags.conf electron-flags.conf code-flags.conf; do
        if [ -f "$DOTFILES_DIR/home/dot_config/$f" ]; then
            cp -f "$DOTFILES_DIR/home/dot_config/$f" "$HOME/.config/$f"
        fi
    done
    ok "Flags de aceleração por hardware e Wayland nativo aplicadas!"

    ok "Todos os antiatritos do sistema foram aplicados com sucesso!"
}





# 10. Wallpaper Padrão e Tema Dinâmico Wallust
setup_default_theme_and_wallpaper() {
    info "Configurando Night_City.png como wallpaper padrão e Waybar Poweruser..."

    local default_wp="$DOTFILES_DIR/home/pictures/wallpapers/Night_City.png"
    local target_wp="$HOME/pictures/wallpapers/Night_City.png"

    mkdir -p "$HOME/pictures/wallpapers"
    mkdir -p "$HOME/.config/hypr/wallpaper_effects"
    mkdir -p "$HOME/.cache"

    if [ -f "$default_wp" ]; then
        cp -f "$default_wp" "$target_wp"
        cp -f "$default_wp" "$HOME/.config/hypr/wallpaper_effects/.wallpaper_current"
        echo "$target_wp" > "$HOME/.cache/current_wallpaper"
    fi

    # Layout e Estilo da Waybar (Poweruser + Wallust)
    mkdir -p "$HOME/.config/waybar"
    if [ -f "$HOME/.config/waybar/configs/[TOP] Default" ]; then
        ln -sf "$HOME/.config/waybar/configs/[TOP] Default" "$HOME/.config/waybar/config"
    fi
    if [ -f "$HOME/.config/waybar/style/[WALLUST] ML4W-modern.css" ]; then
        ln -sf "$HOME/.config/waybar/style/[WALLUST] ML4W-modern.css" "$HOME/.config/waybar/style.css"
    fi

    # Executar Wallust se disponível para pré-gerar paletas de cores
    if command -v wallust &>/dev/null && [ -f "$target_wp" ]; then
        info "Executando Wallust para extrair paleta de cores neon do Night_City.png..."
        wallust run -s "$target_wp" >/dev/null 2>&1 || true
        ok "Paleta Wallust gerada com sucesso."
    fi

    ok "Wallpaper Night_City e Waybar Poweruser configurados."
}

# 11. Verificação do Hyprland
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
setup_keyring
setup_git
setup_shell
apply_dotfiles
setup_lowercase_dirs
setup_extras
setup_anti_friction
setup_default_theme_and_wallpaper


printf "\n"
read -p "Deseja configurar o ambiente de desenvolvimento agora? (Docker, Mise, Neovim/LazyVim) [s/N] " DEV_CONF
if [[ "$DEV_CONF" =~ ^[Ss]$ ]]; then
    if [ -f "$DOTFILES_DIR/scripts/dev-setup.sh" ]; then
        bash "$DOTFILES_DIR/scripts/dev-setup.sh"
    else
        warn "Script dev-setup.sh não encontrado."
    fi
fi

printf "\n"
read -p "Deseja vincular sua partição de dados (/mnt/dados) com a Taxonomia Mestre (Organizador)? [s/N] " VINC_CONF
if [[ "$VINC_CONF" =~ ^[Ss]$ ]]; then
    if [ -f "$DOTFILES_DIR/scripts/organizador/vincular_linux.sh" ]; then
        bash "$DOTFILES_DIR/scripts/organizador/vincular_linux.sh"
    fi
fi

echo -e "\n${GREEN}=====================================================${NC}"
echo -e "${GREEN}     SETUP CONCLUÍDO COM SUCESSO! 🚀                 ${NC}"
echo -e "${GREEN}=====================================================${NC}"
echo -e "Dicas de comandos e apps configurados:"
echo -e "  - ${BLUE}nvim${NC}                 : Abre o LazyVim com LSP, temas e DBUI (<leader>D)"
echo -e "  - ${BLUE}db-up / db-down${NC}      : Sobe/para suíte Docker de DBs (Postgres, Redis, MariaDB, Mongo)"
echo -e "  - ${BLUE}dbeaver / lsql${NC}       : Gerenciadores de Banco (DBeaver GUI + LazySQL no terminal)"
echo -e "  - ${BLUE}mise ls / mise use${NC}   : Gerenciador de Runtimes (Node LTS, Bun, Pnpm, Python, Go, Java)"
echo -e "  - ${BLUE}bruno / api${NC}          : Cliente de API/REST moderno e leve (substituto do Postman)"
echo -e "  - ${BLUE}zellij --layout vibe${NC} : Inicia Vibe Coding (LazyVim + Antigravity CLI)"
echo -e "  - ${BLUE}organizar${NC}            : Executa a suíte de organização de arquivos"
echo -e "  - ${BLUE}lutris / heroic${NC}      : Gerenciadores de Jogos & FitGirl Repacks (Proton-GE)"
echo -e "  - ${BLUE}vesktop${NC}              : Discord com compartilhamento de tela e áudio no Wayland"
echo -e "  - ${BLUE}easyeffects${NC}          : Filtro de ruído por IA para microfone (PipeWire)"
echo -e "  - ${BLUE}obs${NC}                  : OBS Studio com gravação NVENC (NVIDIA RTX 5060)"
echo -e "  - ${BLUE}fix-pendrive${NC}         : Desbloqueia e repara pen-drives NTFS/FAT32/exFAT instantaneamente"
echo -e "  - ${BLUE}okular / celluloid${NC}   : Melhor leitor de PDF e melhor reprodutor de vídeo"
echo -e "  - ${BLUE}onlyoffice${NC}           : Suíte de escritório compatível 100% com Word, Excel e PowerPoint"
echo -e "  - ${BLUE}kdeconnect${NC}           : Conexão sem fio com celular (clipboard compartilhado e arquivos)"
echo -e "  - ${BLUE}gparted / baobab${NC}     : Formatador visual de discos e analisador gráfico de espaço"
echo -e "  - ${BLUE}quickgui${NC}             : Interface gráfica para rodar Windows 11 em VM KVM com 1 clique"
echo -e "  - ${BLUE}fix-suspend${NC}          : Diagnóstico e proteção para o PC nunca acordar sozinho"
echo -e "  - ${BLUE}pacup / safe-update${NC}  : Atualização blindada (atualiza chaveiro PGP antes e previne quebras)"
echo -e "  - ${BLUE}fix-pacman / fix-keys${NC}: Destrava db.lck e repara chaves PGP corrompidas"
echo -e "  - ${BLUE}fix-mirrors / fix-audio${NC}: Ranquear mirrors mais rápidos do Brasil e reiniciar áudio"
echo -e "  - ${BLUE}perf / balanced / quiet${NC}: Alterna perfil de energia da CPU/GPU e ruído de ventoinhas"
echo -e "Por favor, reinicie a sessão ou o computador para aplicar todas as mudanças."



