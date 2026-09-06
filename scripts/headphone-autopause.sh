#!/usr/bin/env bash
# ==============================================================================
# 🎧 Headphone Auto-Pause Guard (Zero Vazamento de Som)
# Pausa automaticamente Spotify, navegadores e players quando fones Bluetooth
# ou cabos P2/USB forem desconectados, evitando que o áudio vaze nas caixas de som.
# ==============================================================================

if ! command -v pactl >/dev/null 2>&1 || ! command -v playerctl >/dev/null 2>&1; then
    exit 0
fi

pactl subscribe 2>/dev/null | while read -r event; do
    if echo "$event" | grep -q "Event 'remove' on card\|Event 'remove' on sink"; then
        playerctl -a pause 2>/dev/null || true
    fi
done
