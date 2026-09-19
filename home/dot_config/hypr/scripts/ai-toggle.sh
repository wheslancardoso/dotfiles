#!/usr/bin/env bash
# ==============================================================================
# 🤖 ORÁCULO DE IA DROPDOWN SCRATCHPAD PARA HYPRLAND
# ==============================================================================
# Alterna instantaneamente a janela de IA no special workspace 'ai_oracle'.
# ==============================================================================

set -euo pipefail

LOCKFILE="/tmp/ai-oracle-toggle.lock"
exec 200>"$LOCKFILE"
if ! flock -n 200; then
    exit 0
fi

AI_URL="https://www.google.com/search?sxsrf=APpeQntn3ONswaZPQLtfbGyrp8lX3SaY8Q%3A1789847230865&udm=50&vsint=&ntc=1&cs=1&zs=1"

current_mon=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
active_mon=$(hyprctl monitors -j | jq -r '.[] | select(.specialWorkspace.name == "special:ai_oracle") | .name')

if [[ -n "$active_mon" ]]; then
    if [[ "$active_mon" == "$current_mon" ]]; then
        hyprctl dispatch togglespecialworkspace ai_oracle
    else
        hyprctl dispatch focusmonitor "$active_mon"
        hyprctl dispatch togglespecialworkspace ai_oracle
        hyprctl dispatch focusmonitor "$current_mon"
    fi
    exit 0
fi

# Localiza janela já aberta (por classe ou título de pesquisa)
ai_addr=$(hyprctl clients -j | jq -r '.[] | select(.class | test("brave-www.google.com__search|ai-oracle"; "i")) | .address' | head -n 1)

if [[ -z "$ai_addr" ]]; then
    # Inicia como webapp com a URL solicitada
    hyprctl dispatch exec "[workspace special:ai_oracle silent] brave --app=\"$AI_URL\" --user-data-dir=$HOME/.config/brave-ai-oracle"

    for _ in {1..25}; do
        sleep 0.15
        ai_addr=$(hyprctl clients -j | jq -r '.[] | select((.class | test("brave-www.google.com__search|ai-oracle"; "i")) or (.title | test("Pesquisa Google|Google Search"; "i"))) | .address' | head -n 1)
        if [[ -n "$ai_addr" ]]; then
            break
        fi
    done
fi

if [[ -n "$ai_addr" ]]; then
    mon_w=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .width')
    mon_h=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .height')
    target_w=$(( mon_w * 76 / 100 ))
    target_h=$(( mon_h * 84 / 100 ))

    hyprctl dispatch movetoworkspacesilent special:ai_oracle,address:"$ai_addr"
    hyprctl dispatch togglespecialworkspace ai_oracle
    hyprctl dispatch focuswindow address:"$ai_addr"
    hyprctl dispatch resizewindowpixel "exact ${target_w} ${target_h},address:$ai_addr"
    hyprctl dispatch centerwindow
else
    hyprctl dispatch togglespecialworkspace ai_oracle
fi
