#!/usr/bin/env bash
# ==============================================================================
# 🎵 SPOTIFY DROPDOWN SCRATCHPAD RUNNER PARA HYPRLAND
# ==============================================================================
# Alterna instantaneamente o Spotify no special workspace 'spotify'.
# Se o Spotify não estiver aberto, inicia em background sem roubar o foco.
# ==============================================================================

set -euo pipefail

# Verifica se a janela do Spotify já existe
if ! hyprctl clients -j | jq -e '.[] | select(.class == "Spotify" or .class == "spotify")' >/dev/null 2>&1; then
    # Inicia silenciosamente no special workspace
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
    sleep 0.5
fi

# Alterna o workspace especial do Spotify
hyprctl dispatch togglespecialworkspace spotify
