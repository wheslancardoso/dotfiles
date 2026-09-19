#!/usr/bin/env bash
# ==============================================================================
# 💬 WHATSAPP WEB DROPDOWN SCRATCHPAD PARA HYPRLAND
# ==============================================================================
# Alterna instantaneamente o WhatsApp no special workspace 'whatsapp'.
# Modo WebApp flutuante centralizado e focado.
# ==============================================================================

set -euo pipefail

LOCKFILE="/tmp/whatsapp-toggle.lock"
exec 200>"$LOCKFILE"
if ! flock -n 200; then
    exit 0
fi

# Monitor focado atualmente
current_mon=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

# Verifica se special:whatsapp está ativo em QUALQUER monitor
active_mon=$(hyprctl monitors -j | jq -r '.[] | select(.specialWorkspace.name == "special:whatsapp") | .name')

if [[ -n "$active_mon" ]]; then
    if [[ "$active_mon" == "$current_mon" ]]; then
        hyprctl dispatch togglespecialworkspace whatsapp
    else
        hyprctl dispatch focusmonitor "$active_mon"
        hyprctl dispatch togglespecialworkspace whatsapp
        hyprctl dispatch focusmonitor "$current_mon"
    fi
    exit 0
fi

# Busca endereço da janela do WhatsApp com proteção contra nós vazios do jq
find_wa_address() {
    hyprctl clients -j | jq -r '
        .[] | 
        select(
            ((.class? // "") | test("whatsapp"; "i")) or 
            ((.initialClass? // "") | test("whatsapp"; "i")) or 
            ((.title? // "") | test("WhatsApp"; "i"))
        ) | .address
    ' | head -n 1
}

wa_addr=$(find_wa_address)

if [[ -z "$wa_addr" ]]; then
    # Inicia como WebApp com perfil isolado para não misturar com o Brave principal
    if command -v brave &>/dev/null; then
        hyprctl dispatch exec "[workspace special:whatsapp silent] brave --app=https://web.whatsapp.com --class=whatsapp-webapp --user-data-dir=$HOME/.config/brave-whatsapp-app"
    elif command -v google-chrome-stable &>/dev/null; then
        hyprctl dispatch exec "[workspace special:whatsapp silent] google-chrome-stable --app=https://web.whatsapp.com --class=whatsapp-webapp --user-data-dir=$HOME/.config/chrome-whatsapp-app"
    elif command -v chromium &>/dev/null; then
        hyprctl dispatch exec "[workspace special:whatsapp silent] chromium --app=https://web.whatsapp.com --class=whatsapp-webapp --user-data-dir=$HOME/.config/chromium-whatsapp-app"
    else
        notify-send -a "WhatsApp" -i "dialog-error" "Navegador não encontrado" "Instale o Brave ou Chrome."
        exit 1
    fi

    for _ in {1..30}; do
        sleep 0.15
        wa_addr=$(find_wa_address)
        if [[ -n "$wa_addr" ]]; then
            break
        fi
    done
fi

if [[ -n "$wa_addr" ]]; then
    mon_w=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .width')
    mon_h=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .height')
    target_w=$(( mon_w * 78 / 100 ))
    target_h=$(( mon_h * 84 / 100 ))

    hyprctl dispatch movetoworkspacesilent special:whatsapp,address:"$wa_addr"
    hyprctl dispatch togglespecialworkspace whatsapp
    hyprctl dispatch focuswindow address:"$wa_addr"
    hyprctl dispatch resizewindowpixel "exact ${target_w} ${target_h},address:$wa_addr"
    hyprctl dispatch centerwindow
else
    hyprctl dispatch togglespecialworkspace whatsapp
fi
