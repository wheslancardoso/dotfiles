#!/usr/bin/env bash
# ==============================================================================
# 💬 WHATSAPP WEB DROPDOWN SCRATCHPAD PARA HYPRLAND (Perfil Principal)
# ==============================================================================
# Usa o perfil Default do Brave (suas contas, login e extensões ativas,
# como a extensão de privacidade do WhatsApp).
# ==============================================================================

set -euo pipefail

LOCKFILE="/tmp/whatsapp-toggle.lock"
exec 200>"$LOCKFILE"
if ! flock -n 200; then
    exit 0
fi

current_mon=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
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
    # Inicia com o perfil principal (--profile-directory="Default") para carregar todas as extensões e logins
    hyprctl dispatch exec "[workspace special:whatsapp silent] brave --profile-directory=\"Default\" --app=https://web.whatsapp.com"

    for _ in {1..35}; do
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
