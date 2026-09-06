#!/usr/bin/env bash
# 📂 Script para abrir o Yazi em janela flutuante no Hyprland
# Inclui debounce e foco em janela existente para evitar duplicação

# 1. Trava anti-duplicação / debounce (impede múltiplos disparos em menos de 600ms)
LOCK_FILE="/tmp/yazi_float_spawn.lock"
if [ -f "$LOCK_FILE" ]; then
    NOW=$(date +%s%N)
    LOCK_TIME=$(cat "$LOCK_FILE" 2>/dev/null || echo 0)
    DIFF=$(( (NOW - LOCK_TIME) / 1000000 ))
    if [ "$DIFF" -ge 0 ] && [ "$DIFF" -lt 600 ]; then
        exit 0
    fi
fi
date +%s%N > "$LOCK_FILE" 2>/dev/null || true

# 2. Se já existe uma janela yazi-float aberta no Hyprland, apenas foca nela
if command -v hyprctl &>/dev/null; then
    EXISTING_ADDR=$(hyprctl clients -j 2>/dev/null | jq -r '.[] | select(.class == "yazi_picker" or .title == "yazi-float") | .address' | head -n 1)
    if [ -n "$EXISTING_ADDR" ] && [ "$EXISTING_ADDR" != "null" ]; then
        hyprctl dispatch focuswindow "address:$EXISTING_ADDR" >/dev/null 2>&1
        exit 0
    fi
fi

# 3. Lança no terminal padrão
if command -v kitty &>/dev/null; then
    exec kitty --class yazi_picker --title "yazi-float" -e yazi "$@"
elif command -v alacritty &>/dev/null; then
    exec alacritty --class yazi_picker,yazi_picker --title "yazi-float" -e yazi "$@"
elif command -v ghostty &>/dev/null; then
    exec ghostty --class=yazi_picker --title="yazi-float" -e yazi "$@"
else
    exec yazi "$@"
fi
