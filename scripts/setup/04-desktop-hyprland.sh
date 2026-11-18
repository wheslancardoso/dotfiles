#!/bin/bash
# Módulo 04: Desktop Hyprland, Grupos, Serviços Systemd, Keyring, Anti-Friction, Apps Padrão e Tema

set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

setup_groups() {
    info "Adicionando $USER aos grupos de desktop/sistema..."
    local groups=(
        wheel video audio input storage network optical lp
        libvirt gamemode docker adbusers realtime nopasswdlogin kvm rfkill users
    )
    for grp in "${groups[@]}"; do
        if getent group "$grp" >/dev/null 2>&1; then
            sudo usermod -aG "$grp" "$USER" 2>/dev/null || true
        fi
    done
    ok "Grupos configurados."
}

setup_services() {
    if ! has_systemd; then
        warn "Systemd não ativo; pulando habilitação de serviços."
        return 0
    fi

    info "Desabilitando serviços bloqueantes de boot..."
    for blocking_svc in NetworkManager-wait-online.service systemd-networkd-wait-online.service; do
        sudo systemctl disable --now "$blocking_svc" 2>/dev/null || true
        sudo systemctl mask "$blocking_svc" 2>/dev/null || true
    done

    info "Habilitando serviços systemd do sistema..."
    local sys_services=(
        NetworkManager.service
        bluetooth.service
        sddm.service
        libvirtd.socket
        ufw.service
        systemd-resolved.service
        systemd-timesyncd.service
        avahi-daemon.service
        ananicy-cpp.service
        irqbalance.service
        power-profiles-daemon.service
        paccache.timer
        fstrim.timer
    )
    for svc in "${sys_services[@]}"; do
        if systemctl list-unit-files "$svc" >/dev/null 2>&1; then
            sudo systemctl enable "$svc" 2>/dev/null || true
        fi
    done

    if has_cmd ufw; then
        sudo ufw allow 1714:1764/udp comment 'KDE Connect' >/dev/null 2>&1 || true
        sudo ufw allow 1714:1764/tcp comment 'KDE Connect' >/dev/null 2>&1 || true
    fi

    info "Habilitando serviços systemd do usuário..."
    local usr_services=(
        pipewire.service
        pipewire-pulse.service
        wireplumber.service
        xdg-user-dirs.service
        rclone-gdrive.service
        capslock-indicator.service
        udiskie.service
        gamemoded.service
        psd.service
        arch-auto-update.timer
    )
    for svc in "${usr_services[@]}"; do
        systemctl --user enable "$svc" 2>/dev/null || true
    done

    ok "Serviços de sistema e usuário habilitados."
}

setup_keyring() {
    info "Configurando GNOME Keyring e PAM..."
    if [ -f /etc/pam.d/sddm ] && ! grep -q "pam_gnome_keyring.so" /etc/pam.d/sddm; then
        sudo cp /etc/pam.d/sddm "/etc/pam.d/sddm.bak_$(date +%s)"
        sudo sed -i '/auth.*system-login/a auth optional pam_gnome_keyring.so' /etc/pam.d/sddm
        sudo sed -i '/session.*system-login/a session optional pam_gnome_keyring.so auto_start' /etc/pam.d/sddm
        sudo sed -i '/password.*system-login/a password optional pam_gnome_keyring.so' /etc/pam.d/sddm
    fi

    if [ -f /etc/pam.d/login ] && ! grep -q "pam_gnome_keyring.so" /etc/pam.d/login; then
        sudo cp /etc/pam.d/login "/etc/pam.d/login.bak_$(date +%s)"
        sudo sed -i '/auth.*system-local-login/a auth optional pam_gnome_keyring.so' /etc/pam.d/login
        sudo sed -i '/session.*system-local-login/a session optional pam_gnome_keyring.so auto_start' /etc/pam.d/login
        sudo sed -i '/password.*system-local-login/a password optional pam_gnome_keyring.so' /etc/pam.d/login
    fi

    mkdir -p "$HOME/.local/share/keyrings"
    chmod 700 "$HOME/.local/share/keyrings"
    [ ! -f "$HOME/.local/share/keyrings/default" ] && echo "login" > "$HOME/.local/share/keyrings/default"

    mkdir -p "$HOME/.config"
    for flag_file in electron-flags.conf chrome-flags.conf chromium-flags.conf code-flags.conf brave-flags.conf; do
        if [ ! -f "$HOME/.config/$flag_file" ] || ! grep -q "password-store" "$HOME/.config/$flag_file" 2>/dev/null; then
            echo "--password-store=gnome-libsecret" >> "$HOME/.config/$flag_file"
        fi
    done
    ok "Keyring configurado."
}

setup_anti_friction() {
    local sys_src="$DOTFILES_DIR/system/etc"
    [ ! -d "$sys_src" ] && return 0

    info "Aplicando configurações anti-friction de sistema ($sys_src)..."

    if [ "${IS_HYPERV:-false}" = false ] && [ -f "$sys_src/modprobe.d/nvidia-power-management.conf" ]; then
        sudo mkdir -p /etc/modprobe.d
        sudo cp -f "$sys_src/modprobe.d/nvidia-power-management.conf" /etc/modprobe.d/
        if has_systemd; then
            for svc in nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service; do
                systemctl list-unit-files "$svc" >/dev/null 2>&1 && sudo systemctl enable "$svc" 2>/dev/null || true
            done
        fi
    fi

    if [ -d "$sys_src/systemd/system.conf.d" ]; then
        sudo mkdir -p /etc/systemd/system.conf.d /etc/systemd/user.conf.d
        sudo cp -f "$sys_src/systemd/system.conf.d/timeout.conf" /etc/systemd/system.conf.d/
        [ -f "$sys_src/systemd/user.conf.d/timeout.conf" ] && sudo cp -f "$sys_src/systemd/user.conf.d/timeout.conf" /etc/systemd/user.conf.d/
    fi

    if [ -f "$sys_src/systemd/zram-generator.conf" ]; then
        sudo mkdir -p /etc/systemd
        sudo cp -f "$sys_src/systemd/zram-generator.conf" /etc/systemd/
    fi

    if [ -f "$sys_src/sysctl.d/99-anti-friction-limits.conf" ]; then
        sudo mkdir -p /etc/sysctl.d
        sudo cp -f "$sys_src/sysctl.d/99-anti-friction-limits.conf" /etc/sysctl.d/
        sudo sysctl --system >/dev/null 2>&1 || true
    fi

    if [ -f "$sys_src/bluetooth/main.conf" ]; then
        sudo mkdir -p /etc/bluetooth
        sudo cp -f "$sys_src/bluetooth/main.conf" /etc/bluetooth/
    fi

    if [ -f "$sys_src/NetworkManager/conf.d/disable-wol.conf" ]; then
        sudo mkdir -p /etc/NetworkManager/conf.d
        sudo cp -f "$sys_src/NetworkManager/conf.d/disable-wol.conf" /etc/NetworkManager/conf.d/
    fi

    if [ -f /etc/gai.conf ]; then
        sudo sed -i 's/#precedence ::ffff:0:0\/96  100/precedence ::ffff:0:0\/96  100/' /etc/gai.conf 2>/dev/null || true
    fi

    if [ -d "$sys_src/udev/rules.d" ]; then
        sudo mkdir -p /etc/udev/rules.d
        sudo cp -f "$sys_src/udev/rules.d/"*.rules /etc/udev/rules.d/
        sudo udevadm control --reload-rules 2>/dev/null || true
    fi

    if [ "${IS_HYPERV:-false}" = false ] && [ -f "$DOTFILES_DIR/scripts/disable-spurious-acpi-wakeup.sh" ]; then
        sudo cp -f "$DOTFILES_DIR/scripts/disable-spurious-acpi-wakeup.sh" /usr/local/bin/
        sudo chmod +x /usr/local/bin/disable-spurious-acpi-wakeup.sh
        if [ -f "$sys_src/systemd/system/disable-spurious-acpi-wakeup.service" ] && has_systemd; then
            sudo cp -f "$sys_src/systemd/system/disable-spurious-acpi-wakeup.service" /etc/systemd/system/
            sudo systemctl daemon-reload 2>/dev/null || true
            sudo systemctl enable disable-spurious-acpi-wakeup.service 2>/dev/null || true
        fi
    fi

    if [ -f "$sys_src/systemd/journald.conf.d/size-limit.conf" ]; then
        sudo mkdir -p /etc/systemd/journald.conf.d
        sudo cp -f "$sys_src/systemd/journald.conf.d/size-limit.conf" /etc/systemd/journald.conf.d/
    fi

    if [ -f "$sys_src/systemd/timesyncd.conf.d/ntp-brasil.conf" ]; then
        sudo mkdir -p /etc/systemd/timesyncd.conf.d
        sudo cp -f "$sys_src/systemd/timesyncd.conf.d/ntp-brasil.conf" /etc/systemd/timesyncd.conf.d/
        sudo timedatectl set-local-rtc 0 --adjust-system-clock 2>/dev/null || true
        sudo timedatectl set-ntp true 2>/dev/null || true
    fi

    if [ -d "$sys_src/pacman.d/hooks" ]; then
        sudo mkdir -p /etc/pacman.d/hooks
        sudo cp -f "$sys_src/pacman.d/hooks/"*.hook /etc/pacman.d/hooks/
    fi

    if [ -d "$sys_src/systemd/coredump.conf.d" ]; then
        sudo mkdir -p /etc/systemd/coredump.conf.d
        sudo cp -f "$sys_src/systemd/coredump.conf.d/disable.conf" /etc/systemd/coredump.conf.d/
    fi

    if [ -d "$sys_src/pipewire" ]; then
        sudo mkdir -p /etc/pipewire/pipewire.conf.d /etc/pipewire/pipewire-pulse.conf.d
        [ -d "$sys_src/pipewire/pipewire.conf.d" ] && sudo cp -f "$sys_src/pipewire/pipewire.conf.d/"*.conf /etc/pipewire/pipewire.conf.d/
        [ -d "$sys_src/pipewire/pipewire-pulse.conf.d" ] && sudo cp -f "$sys_src/pipewire/pipewire-pulse.conf.d/"*.conf /etc/pipewire/pipewire-pulse.conf.d/
    fi

    if [ -d "$sys_src/wireplumber/wireplumber.conf.d" ]; then
        sudo mkdir -p /etc/wireplumber/wireplumber.conf.d
        sudo cp -f "$sys_src/wireplumber/wireplumber.conf.d/"*.conf /etc/wireplumber/wireplumber.conf.d/
    fi

    if [ -f "$DOTFILES_DIR/scripts/setup-audio-presets.sh" ]; then
        bash "$DOTFILES_DIR/scripts/setup-audio-presets.sh" >/dev/null 2>&1 || true
    fi

    ok "Anti-friction configurado."
}

setup_default_apps() {
    info "Configurando associações padrão e extras de desktop..."
    if has_cmd xdg-mime; then
        has_cmd okular && xdg-mime default org.kde.okular.desktop application/pdf 2>/dev/null || true
        if has_cmd celluloid; then
            xdg-mime default io.github.celluloid_player.Celluloid.desktop video/mp4 video/mkv video/x-matroska video/quicktime video/webm video/x-msvideo 2>/dev/null || true
        elif has_cmd mpv; then
            xdg-mime default mpv.desktop video/mp4 video/mkv video/x-matroska video/quicktime video/webm video/x-msvideo 2>/dev/null || true
        fi
        has_cmd onlyoffice-desktopeditors && xdg-mime default onlyoffice-desktopeditors.desktop application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document application/vnd.ms-excel application/vnd.openxmlformats-officedocument.spreadsheetml.sheet 2>/dev/null || true
        if has_cmd brave; then
            xdg-settings set default-web-browser brave-browser.desktop 2>/dev/null || true
            xdg-mime default brave-browser.desktop text/html x-scheme-handler/http x-scheme-handler/https 2>/dev/null || true
        fi
    fi

    [ -f "$DOTFILES_DIR/scripts/setup-spicetify.sh" ] && bash "$DOTFILES_DIR/scripts/setup-spicetify.sh" >/dev/null 2>&1 || true
    [ -f "$DOTFILES_DIR/scripts/setup-qbittorrent.sh" ] && bash "$DOTFILES_DIR/scripts/setup-qbittorrent.sh" >/dev/null 2>&1 || true

    if has_cmd pipx; then
        for pytool in spotdl ffsubsync subliminal; do
            has_cmd "$pytool" || pipx install "$pytool" 2>/dev/null || true
        done
    fi

    if has_cmd hyprpm; then
        hyprpm update 2>/dev/null || true
        hyprpm add https://github.com/VirtCode/hypr-dynamic-cursors 2>/dev/null || true
        hyprpm enable dynamic-cursors 2>/dev/null || true
    fi
    ok "Apps padrão e extras configurados."
}

setup_wallust_and_theme() {
    info "Aplicando tema GTK/Cursor, Waybar, SDDM e Wallust..."

    if has_cmd gsettings; then
        gsettings set org.gnome.desktop.interface gtk-theme "Flat-Remix-GTK-Blue-Dark" 2>/dev/null || true
        gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-Blue-Dark" 2>/dev/null || true
        gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice" 2>/dev/null || true
        gsettings set org.gnome.desktop.interface color-scheme "prefer-dark" 2>/dev/null || true
    fi

    local default_wp="$DOTFILES_DIR/home/pictures/wallpapers/Night_City.png"
    local wp=""
    for candidate in \
        "$HOME/.config/hypr/wallpaper_effects/.wallpaper_current" \
        "$HOME/pictures/wallpapers/Night_City.png" \
        "$HOME/Pictures/wallpapers/Creation_of_Adam_Hands_ASCII_1080p.png" \
        "$default_wp"; do
        if [ -f "$candidate" ]; then
            wp="$candidate"
            break
        fi
    done

    mkdir -p "$HOME/pictures/wallpapers" "$HOME/.config/hypr/wallpaper_effects" "$HOME/.cache"
    if [ -n "$wp" ]; then
        if [ ! -f "$HOME/.config/hypr/wallpaper_effects/.wallpaper_current" ]; then
            cp -f "$wp" "$HOME/.config/hypr/wallpaper_effects/.wallpaper_current"
        fi
        if [ ! -f "$HOME/.cache/current_wallpaper" ]; then
            echo "$wp" > "$HOME/.cache/current_wallpaper"
        fi
        if has_cmd wallust; then
            info "Aplicando paleta Wallust com $wp..."
            wallust run -s "$wp" >/dev/null 2>&1 || true
        fi
    fi

    mkdir -p "$HOME/.config/waybar"
    if [ -f "$HOME/.config/waybar/configs/[TOP] Default" ] && [ ! -e "$HOME/.config/waybar/config" ]; then
        ln -sf "$HOME/.config/waybar/configs/[TOP] Default" "$HOME/.config/waybar/config"
    fi
    if [ -f "$HOME/.config/waybar/style/[WALLUST] Rice Invejavel.css" ] && [ ! -e "$HOME/.config/waybar/style.css" ]; then
        ln -sf "$HOME/.config/waybar/style/[WALLUST] Rice Invejavel.css" "$HOME/.config/waybar/style.css"
    fi

    local sddm_theme_dir="/usr/share/sddm/themes/simple_sddm_2"
    if [ -d "$sddm_theme_dir" ]; then
        sudo mkdir -p "$sddm_theme_dir/Backgrounds"
        if [ -n "$wp" ]; then
            sudo cp -f "$wp" "$sddm_theme_dir/Backgrounds/default" 2>/dev/null || true
            sudo cp -f "$wp" "$sddm_theme_dir/Backgrounds/default.png" 2>/dev/null || true
        fi
        sudo chown -R "$USER:$USER" "$sddm_theme_dir/Backgrounds" 2>/dev/null || true
        sudo chmod -R 775 "$sddm_theme_dir/Backgrounds" 2>/dev/null || true
    fi

    if [ ! -f /etc/sddm.conf ] || ! grep -q "Current=simple_sddm_2" /etc/sddm.conf 2>/dev/null; then
        cat << 'EOF' | sudo tee /etc/sddm.conf >/dev/null
[Theme]
Current=simple_sddm_2

[General]
InputMethod=qtvirtualkeyboard
EOF
    fi
}

verify_hyprland() {
    if has_cmd Hyprland; then
        local hypr_ver
        hypr_ver=$(Hyprland --version 2>/dev/null | head -n 1 || true)
        ok "Hyprland pronto (${hypr_ver:-instalado})."
    else
        warn "Hyprland não encontrado no PATH."
    fi
}

setup_groups
setup_services
setup_keyring
setup_anti_friction
if [ "${IS_HYPERV:-false}" = true ] && [ -f "$DOTFILES_DIR/scripts/setup-hyperv.sh" ]; then
    bash "$DOTFILES_DIR/scripts/setup-hyperv.sh" --force
fi
setup_default_apps
setup_wallust_and_theme
verify_hyprland
