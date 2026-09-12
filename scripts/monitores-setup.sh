#!/usr/bin/env bash
# ==============================================================================
# 🖥️ Cockpit de Gerenciamento & Restauração de Monitores (Hyprland Display Master)
# Permite restaurar workspaces, alternar perfis e abrir o nwg-displays com 1 clique.
# ==============================================================================

set -euo pipefail

MODE="cli"
if [[ "${1:-}" == "--rofi" ]]; then
    MODE="rofi"
fi

DOTFILES_HYPR="$HOME/dotfiles/home/dot_config/hypr"
WORKSPACES_CONF="$DOTFILES_HYPR/workspaces.conf"
MONITORS_CONF="$DOTFILES_HYPR/monitors.conf"

notify() {
    local title="$1"
    local msg="$2"
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -u normal -i video-display "$title" "$msg"
    fi
}

apply_gold_setup() {
    # Perfil Ouro: DP-1 (100Hz) Principal [Workspaces 2-10] + HDMI-A-1 (75Hz) Lateral [Workspace 1]
    cat << 'CONF' > "$MONITORS_CONF"
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
# 🖥️ Configuração de Monitores (Dual Monitor Gold Setup)
monitor = DP-1, 1920x1080@99.65, 1920x0, 1
monitor = HDMI-A-1, 1920x1080@74.97, 0x0, 1
monitor = , preferred, auto, 1
CONF

    cat << 'CONF' > "$WORKSPACES_CONF"
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
# 🪟 Regras de Workspaces (HDMI-A-1 no Workspace 1 e DP-1 com Workspaces 2 a 10)
workspace = 1, monitor:HDMI-A-1, default:true
workspace = 2, monitor:DP-1, default:true
workspace = 3, monitor:DP-1
workspace = 4, monitor:DP-1
workspace = 5, monitor:DP-1
workspace = 6, monitor:DP-1
workspace = 7, monitor:DP-1
workspace = 8, monitor:DP-1
workspace = 9, monitor:DP-1
workspace = 10, monitor:DP-1
CONF

    hyprctl reload || true
    
    # Realinha os workspaces fisicamente na memória
    hyprctl dispatch focusmonitor HDMI-A-1 2>/dev/null || true
    hyprctl dispatch workspace 1 2>/dev/null || true
    hyprctl dispatch focusmonitor DP-1 2>/dev/null || true
    
    for ws in 2 3 4 5 6 7 8 9 10; do
        hyprctl dispatch moveworkspacetomonitor "$ws" DP-1 2>/dev/null || true
    done
    
    hyprctl dispatch workspace 2 2>/dev/null || true
    notify "Monitores Reconfigurados" "DP-1 Primário (Workspaces 2-10) | HDMI-A-1 Lateral (Workspace 1)"
}

apply_dynamic_setup() {
    # Workspaces Dinâmicos: Abrem no monitor onde o cursor/foco estiver
    cat << 'CONF' > "$WORKSPACES_CONF"
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
# 🪟 Workspaces Dinâmicos (Sem trava - alternam no monitor em foco)
# Use este modo se quiser abrir qualquer workspace em qualquer monitor livremente.
CONF

    hyprctl reload || true
    notify "Workspaces Dinâmicos" "Workspaces agora alternam no monitor atualmente em foco."
}

apply_dp1_only() {
    # Apenas Monitor Principal
    cat << 'CONF' > "$MONITORS_CONF"
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
monitor = DP-1, 1920x1080@99.65, 0x0, 1
monitor = HDMI-A-1, disable
monitor = , preferred, auto, 1
CONF

    cat << 'CONF' > "$WORKSPACES_CONF"
# Apenas DP-1 ativo
workspace = 1, monitor:DP-1, default:true
CONF

    hyprctl reload || true
    notify "Monitor Único" "Apenas o DP-1 (100Hz) está ativo."
}

apply_mirror() {
    # Espelhamento
    cat << 'CONF' > "$MONITORS_CONF"
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
monitor = DP-1, 1920x1080@99.65, 0x0, 1
monitor = HDMI-A-1, 1920x1080@60, 0x0, 1, mirror, DP-1
CONF
    hyprctl reload || true
    notify "Telas Espelhadas" "HDMI-A-1 agora espelha exatamente a tela do DP-1."
}

open_gui() {
    if command -v nwg-displays >/dev/null 2>&1; then
        nwg-displays &
    else
        notify "Erro" "nwg-displays não está instalado."
    fi
}

# --- MENU ROFI ---
if [[ "$MODE" == "rofi" ]]; then
    OPTIONS="1. ⚡ Restaurar Padrão Ouro (DP-1 Principal [2-10] + HDMI Lateral [1])\n2. 🔀 Modo Dinâmico (Workspaces abrem onde o mouse estiver)\n3. 🖥️ Apenas DP-1 (Desligar HDMI temporariamente)\n4. 🪞 Espelhar Telas (Clone DP-1 -> HDMI)\n5. 🎨 Abrir Gerenciador Visual (nwg-displays)"
    
    CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "🖥️ Gerenciador de Monitores:" -theme-str 'window {width: 680px;}')
    
    case "$CHOICE" in
        *"Restaurar Padrão Ouro"*) apply_gold_setup ;;
        *"Modo Dinâmico"*) apply_dynamic_setup ;;
        *"Apenas DP-1"*) apply_dp1_only ;;
        *"Espelhar Telas"*) apply_mirror ;;
        *"Abrir Gerenciador Visual"*) open_gui ;;
        *) exit 0 ;;
    esac
    exit 0
fi

# --- MENU TERMINAL CLI ---
echo -e "\033[1;36m================================================================\033[0m"
echo -e "\033[1;33m       🖥️  COCKPIT DE MONITORES & WORKSPACES (HYPRLAND)         \033[0m"
echo -e "\033[1;36m================================================================\033[0m"
echo -e "  \033[1;32m[1]\033[0m ⚡ Restaurar Padrão Ouro (DP-1 Principal [2-10] + HDMI [1])"
echo -e "  \033[1;32m[2]\033[0m 🔀 Modo Dinâmico (Workspaces livres em qualquer tela)"
echo -e "  \033[1;32m[3]\033[0m 🖥️ Apenas Monitor DP-1 (Desliga HDMI lateral)"
echo -e "  \033[1;32m[4]\033[0m 🪞 Espelhar Telas (Clonar imagem do DP-1 no HDMI)"
echo -e "  \033[1;32m[5]\033[0m 🎨 Abrir nwg-displays (Configurador Gráfico Visual)"
echo -e "  \033[1;31m[q]\033[0m Sair"
echo -e "\033[1;36m----------------------------------------------------------------\033[0m"
read -rp "👉 Escolha uma opção [1-5]: " OPT

case "$OPT" in
    1) apply_gold_setup ;;
    2) apply_dynamic_setup ;;
    3) apply_dp1_only ;;
    4) apply_mirror ;;
    5) open_gui ;;
    *) echo "Operação cancelada." ;;
esac
