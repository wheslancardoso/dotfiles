#!/usr/bin/env bash
# ==============================================================================
# 🎵 SPOTIFY DROPDOWN SCRATCHPAD RUNNER PARA HYPRLAND
# ==============================================================================
# Alterna instantaneamente o Spotify no special workspace 'spotify'.
# Suporta multi-monitores e permite mover o Spotify para outros workspaces
# sem que ele fique travado na tela.
# ==============================================================================

set -euo pipefail

# Lockfile anti-rebote (debounce) para evitar disparos concorrentes
LOCKFILE="/tmp/spotify-toggle.lock"
exec 200>"$LOCKFILE"
if ! flock -n 200; then
    exit 0
fi

# Monitor focado atualmente
current_mon=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

# Verifica se special:spotify está ativo em QUALQUER monitor
active_mon=$(hyprctl monitors -j | jq -r '.[] | select(.specialWorkspace.name == "special:spotify") | .name')

if [[ -n "$active_mon" ]]; then
    # O scratchpad está visível! Vamos ocultar
    if [[ "$active_mon" == "$current_mon" ]]; then
        hyprctl dispatch togglespecialworkspace spotify
    else
        # Foca o monitor onde o special está aberto, fecha e retorna o foco
        hyprctl dispatch focusmonitor "$active_mon"
        hyprctl dispatch togglespecialworkspace spotify
        hyprctl dispatch focusmonitor "$current_mon"
    fi
    exit 0
fi

# Se não está visível, verifica se o Spotify está rodando
spotify_addr=$(hyprctl clients -j | jq -r '.[] | select(.class == "Spotify" or .class == "spotify") | .address' | head -n 1)

if [[ -z "$spotify_addr" ]]; then
    # Inicia o Spotify silenciosamente no workspace especial
    if command -v spotify &>/dev/null; then
        hyprctl dispatch exec "[workspace special:spotify silent] spotify"
    elif command -v spotify-launcher &>/dev/null; then
        hyprctl dispatch exec "[workspace special:spotify silent] spotify-launcher"
    elif flatpak info com.spotify.Client &>/dev/null 2>&1; then
        hyprctl dispatch exec "[workspace special:spotify silent] flatpak run com.spotify.Client"
    else
        notify-send -a "Spotify" -i "dialog-error" "Spotify Não Encontrado" "Instale via pacman/AUR: yay -S spotify"
        exit 1
    fi

    # Aguarda a janela aparecer (até 3 segundos)
    for _ in {1..20}; do
        sleep 0.15
        spotify_addr=$(hyprctl clients -j | jq -r '.[] | select(.class == "Spotify" or .class == "spotify") | .address' | head -n 1)
        if [[ -n "$spotify_addr" ]]; then
            break
        fi
    done
fi

# Garante que o Spotify vá para o special:spotify e seja exibido no monitor atual
if [[ -n "$spotify_addr" ]]; then
    hyprctl dispatch movetoworkspacesilent special:spotify,address:"$spotify_addr"
    hyprctl dispatch togglespecialworkspace spotify
    hyprctl dispatch focuswindow address:"$spotify_addr"
else
    # Fallback toggle
    hyprctl dispatch togglespecialworkspace spotify
fi
