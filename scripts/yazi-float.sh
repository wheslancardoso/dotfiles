#!/bin/bash
# Script para abrir o Yazi em uma janela flutuante no Hyprland

# Tenta usar o Alacritty como terminal para a janela flutuante
if command -v alacritty &> /dev/null; then
    alacritty --title "yazi-float" -e yazi "$@"
elif command -v kitty &> /dev/null; then
    kitty --title "yazi-float" yazi "$@"
else
    # Fallback para qualquer terminal se os favoritos não existirem
    yazi "$@"
fi
