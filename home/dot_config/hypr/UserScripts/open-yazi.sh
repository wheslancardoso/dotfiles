#!/usr/bin/env bash
# 📂 Script para abrir o Yazi em janela flutuante no Hyprland
# Prioriza Alacritty (preferido), depois Kitty e Ghostty

if command -v alacritty &>/dev/null; then
    exec alacritty --class yazi_picker,yazi_picker --title "yazi-float" -e yazi "$@"
elif command -v kitty &>/dev/null; then
    exec kitty --class yazi_picker --title "yazi-float" -e yazi "$@"
elif command -v ghostty &>/dev/null; then
    exec ghostty --class=yazi_picker --title="yazi-float" -e yazi "$@"
else
    exec yazi "$@"
fi
