#!/usr/bin/env bash
# ==============================================================================
# 🎧 Headphone Auto-Pause Guard (Strict Physical Disconnect Only)
# ==============================================================================

if ! command -v pactl >/dev/null 2>&1 || ! command -v playerctl >/dev/null 2>&1; then
    exit 0
fi

# Strict filter: Only trigger when a physical audio CARD is removed (Bluetooth/USB)
# Never trigger on sink-input (which happens every time a notification or tab sound stops)
pactl subscribe 2>/dev/null | while read -r event; do
    if echo "$event" | grep -qE "Event 'remove' on card #[0-9]+$"; then
        playerctl -a pause 2>/dev/null || true
    fi
done
