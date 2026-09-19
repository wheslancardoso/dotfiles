#!/usr/bin/env bash
# ==============================================================================
# 📷 LOGITECH C270 ANTI-GLARE & STUDIO TUNER (CachyOS + Hyprland)
# ==============================================================================
# Trava a exposição manual para impedir que a luz do sol/janela cegue a câmera.
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

# 1 = Manual Mode, 3 = Aperture Priority (Auto)
# exposure_time_absolute calibrado para domar luz do sol/janela sem escurecer demais
v4l2-ctl -d "$DEV" \
    --set-ctrl=auto_exposure=1 \
    --set-ctrl=exposure_time_absolute=85 \
    --set-ctrl=exposure_dynamic_framerate=0 \
    --set-ctrl=power_line_frequency=2 \
    --set-ctrl=brightness=105 \
    --set-ctrl=contrast=45 \
    --set-ctrl=saturation=48 \
    --set-ctrl=gain=5 \
    --set-ctrl=sharpness=35 \
    --set-ctrl=backlight_compensation=0 \
    >/dev/null 2>&1 || true

echo "Webcam Logitech C270 calibrada contra estouro de sol em $DEV!"
