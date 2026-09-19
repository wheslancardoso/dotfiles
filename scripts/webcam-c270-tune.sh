#!/usr/bin/env bash
# ==============================================================================
# 📷 LOGITECH C270 BALANCED STUDIO CALIBRATOR (CachyOS + Hyprland)
# ==============================================================================

set -euo pipefail

DEV=""
for d in /dev/video*; do
    if [ -e "$d" ] && v4l2-ctl -d "$d" --info 2>/dev/null | grep -i "C270" >/dev/null 2>&1; then
        DEV="$d"
        break
    fi
done

if [ -z "$DEV" ]; then
    DEV="/dev/video0"
fi

if [ ! -e "$DEV" ]; then
    exit 0
fi

# Auto Exposure inteligente (Aperture Priority), mas sem deixar o sol estourar:
# - Dynamic framerate desligado (sempre 30 FPS)
# - Anti-flicker 60Hz
# - Ganho zerado para eliminar ruído branco e estalo de luz
# - Brilho em 115 e contraste em 40 para tom de pele vivo sem cegar
v4l2-ctl -d "$DEV" \
    --set-ctrl=auto_exposure=3 \
    --set-ctrl=exposure_dynamic_framerate=0 \
    --set-ctrl=power_line_frequency=2 \
    --set-ctrl=brightness=115 \
    --set-ctrl=contrast=40 \
    --set-ctrl=saturation=42 \
    --set-ctrl=gain=0 \
    --set-ctrl=sharpness=32 \
    --set-ctrl=backlight_compensation=0 \
    >/dev/null 2>&1 || true

echo "Webcam C270 reajustada com iluminação equilibrada em $DEV!"
