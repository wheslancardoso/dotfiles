#!/usr/bin/env bash
# 📂 Script para abrir o Yazi em modo ladrilhado (tiling padrão) no Hyprland
# Abre no terminal padrão sem classes/títulos flutuantes para se integrar ao grid de janelas

if command -v kitty &>/dev/null; then
    exec kitty --title "yazi" -e yazi "$@"
elif command -v alacritty &>/dev/null; then
    exec alacritty --title "yazi" -e yazi "$@"
elif command -v ghostty &>/dev/null; then
    exec ghostty --title="yazi" -e yazi "$@"
else
    exec yazi "$@"
fi
