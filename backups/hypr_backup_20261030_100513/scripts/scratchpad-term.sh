#!/bin/bash
# 🚀 Dropdown / Scratchpad Terminal Runner for Hyprland

TERM_CLASS="scratchpad_term"

# Verifica se a janela do scratchpad já existe
if ! hyprctl clients | grep -q "class: $TERM_CLASS"; then
    if command -v kitty &>/dev/null; then
        kitty --class="$TERM_CLASS" &
    elif command -v ghostty &>/dev/null; then
        ghostty --class="$TERM_CLASS" &
    elif command -v alacritty &>/dev/null; then
        alacritty --class "$TERM_CLASS" &
    fi
    sleep 0.2
fi

hyprctl dispatch togglespecialworkspace scratchpad
