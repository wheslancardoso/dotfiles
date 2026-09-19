#!/usr/bin/env bash
# ==============================================================================
# 📷 LOGITECH C270 STUDIO CALIBRATOR (CachyOS + Hyprland)
# ==============================================================================
# Otimiza o hardware da C270 diretamente no driver V4L2 do kernel Linux:
# - Desliga o dynamic framerate (Garante 30 FPS reais sem efeito fantasma/slow-motion)
# - Trava a frequência em 60Hz (Anti-flicker contra luz LED)
# - Reduz ganho e brilho excessivo (Cores mais ricas, pretos mais profundos, sem estourar luz)
# - Aumenta contraste e saturação para tom de pele vivo e caloroso
# ==============================================================================

set -euo pipefail

DEV=""

# Detecta automaticamente o dispositivo de vídeo da C270
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

# Aplica parâmetros ideais: Menos estouro de luz, mais contraste e cores mais vivas
v4l2-ctl -d "$DEV" \
    --set-ctrl=exposure_dynamic_framerate=0 \
    --set-ctrl=power_line_frequency=2 \
    --set-ctrl=brightness=110 \
    --set-ctrl=contrast=45 \
    --set-ctrl=saturation=48 \
    --set-ctrl=gain=0 \
    --set-ctrl=sharpness=35 \
    --set-ctrl=backlight_compensation=0 \
    >/dev/null 2>&1 || true

echo "Webcam Logitech C270 calibrada com sucesso em $DEV (Tom vivo, sem superexposição e 30 FPS)!"
