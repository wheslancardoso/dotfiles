#!/usr/bin/env bash
# ==============================================================================
# 🔄 SELETOR DE PERFIL: DESKTOP (NVIDIA DUAL-MONITOR) vs THINKPAD T480 (INTEL)
# ==============================================================================
# Alterna instantaneamente as variáveis gráficas, monitores e workspaces
# entre o PC Desktop principal e o laptop ThinkPad T480.
# ==============================================================================

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
HYPR_DIR="$DOTFILES_DIR/home/dot_config/hypr"
ENV_CONF="$HYPR_DIR/UserConfigs/ENVariables.conf"
MONITORS_CONF="$HYPR_DIR/monitors.conf"
WORKSPACES_CONF="$HYPR_DIR/workspaces.conf"

notify() {
    local title="$1"
    local msg="$2"
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -u normal -i video-display "$title" "$msg"
    fi
}

apply_desktop() {
    echo "🖥️ Aplicando Perfil: DESKTOP (NVIDIA RTX + Dual-Monitor)..."
    
    # 1. Variáveis de ambiente NVIDIA RTX
    cat << 'EOF' > "$ENV_CONF"
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
# Environment variables - Desktop Profile (NVIDIA RTX 5060)

### NVIDIA RTX Acceleration ###
env = LIBVA_DRIVER_NAME,nvidia
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = NVD_BACKEND,direct
env = GBM_BACKEND,nvidia-drm
env = __GL_GSYNC_ALLOWED,1 # Adaptive Vsync / G-Sync
env = GSK_RENDERER,ngl

### Electron / Chromium & Brave Wayland Optimization ###
env = ELECTRON_OZONE_PLATFORM_HINT,auto
env = BROWSER,brave
env = EGL_PLATFORM,wayland

### User Added ENVs ###
env = GTK_USE_PORTAL,1
env = GDK_DEBUG,portals
env = PATH,$HOME/.local/bin:$PATH

### GNOME Keyring & Secret Service ###
env = GNOME_KEYRING_CONTROL,$XDG_RUNTIME_DIR/keyring
env = SSH_AUTH_SOCK,$XDG_RUNTIME_DIR/keyring/ssh
EOF

    # 2. Monitores e Workspaces Desktop
    if [ -f "$DOTFILES_DIR/scripts/monitores-setup.sh" ]; then
        bash "$DOTFILES_DIR/scripts/monitores-setup.sh" --desktop >/dev/null 2>&1 || true
    fi

    # 3. Sincronizar com ~/.config se não for symlink direto
    mkdir -p "$HOME/.config/hypr/UserConfigs"
    cp -f "$ENV_CONF" "$HOME/.config/hypr/UserConfigs/ENVariables.conf" 2>/dev/null || true

    if command -v hyprctl &>/dev/null && [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
        hyprctl reload || true
    fi
    notify "Perfil Ativado" "🖥️ Perfil Desktop (NVIDIA RTX + Monitores DP-1/HDMI) ativo!"
    echo "✅ Perfil Desktop aplicado com sucesso!"
}

apply_t480() {
    echo "💻 Aplicando Perfil: THINKPAD T480 (Intel UHD + eDP-1)..."
    
    # 1. Variáveis de ambiente Intel UHD / Iris
    cat << 'EOF' > "$ENV_CONF"
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
# Environment variables - ThinkPad T480 Profile (Intel UHD 620)

### Intel UHD / Iris VA-API Acceleration ###
env = LIBVA_DRIVER_NAME,iHD
env = MESA_LOADER_DRIVER_OVERRIDE,iris
env = GSK_RENDERER,gl

### Electron / Chromium & Brave Wayland Optimization ###
env = ELECTRON_OZONE_PLATFORM_HINT,auto
env = BROWSER,brave
env = EGL_PLATFORM,wayland

### User Added ENVs ###
env = GTK_USE_PORTAL,1
env = GDK_DEBUG,portals
env = PATH,$HOME/.local/bin:$PATH

### GNOME Keyring & Secret Service ###
env = GNOME_KEYRING_CONTROL,$XDG_RUNTIME_DIR/keyring
env = SSH_AUTH_SOCK,$XDG_RUNTIME_DIR/keyring/ssh
EOF

    # 2. Monitores e Workspaces eDP-1
    if [ -f "$DOTFILES_DIR/scripts/monitores-setup.sh" ]; then
        bash "$DOTFILES_DIR/scripts/monitores-setup.sh" --t480 || true
    fi

    # 3. Sincronizar com ~/.config se não for symlink direto
    mkdir -p "$HOME/.config/hypr/UserConfigs"
    cp -f "$ENV_CONF" "$HOME/.config/hypr/UserConfigs/ENVariables.conf" 2>/dev/null || true

    if command -v hyprctl &>/dev/null && [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
        hyprctl reload || true
    fi
    notify "Perfil Ativado" "💻 Perfil ThinkPad T480 (Intel UHD + eDP-1 Workspaces 1-10) ativo!"
    echo "✅ Perfil ThinkPad T480 aplicado com sucesso!"
}

TARGET="${1:-}"

if [[ -z "$TARGET" ]]; then
    if command -v rofi &>/dev/null && [ -n "${WAYLAND_DISPLAY:-}" ]; then
        CHOICE=$(echo -e "1. 🖥️ Perfil Desktop (NVIDIA RTX + Monitores DP-1/HDMI)\n2. 💻 Perfil ThinkPad T480 (Intel UHD 620 + eDP-1)" | rofi -dmenu -i -p "Selecione o Perfil:" -theme-str 'window {width: 600px;}')
        case "$CHOICE" in
            *"Desktop"*) TARGET="desktop" ;;
            *"ThinkPad"*) TARGET="t480" ;;
            *) exit 0 ;;
        esac
    else
        echo "Selecione o perfil desejado:"
        echo "  [1] Desktop (NVIDIA RTX + Dual-Monitor)"
        echo "  [2] ThinkPad T480 (Intel UHD + Tela eDP-1)"
        read -rp "Escolha [1-2]: " RES
        case "$RES" in
            1) TARGET="desktop" ;;
            2) TARGET="t480" ;;
            *) echo "Cancelado."; exit 0 ;;
        esac
    fi
fi

case "$TARGET" in
    desktop|pc|b550m|nvidia)
        apply_desktop
        ;;
    t480|thinkpad|laptop|intel)
        apply_t480
        ;;
    *)
        echo "Uso: $0 [desktop | t480]"
        exit 1
        ;;
esac
