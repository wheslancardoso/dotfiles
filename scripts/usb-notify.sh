#!/usr/bin/env bash
# ==============================================================================
# 💾 NOTIFICADOR INTELIGENTE DE DISPOSITIVOS USB & REMOVÍVEIS
# ==============================================================================
# Integração udiskie com notify-send e SwayNC para feedback visual imediato
# ao plugar, montar, ejetar e desconectar pen-drives e HDs externos.
# ==============================================================================

set -euo pipefail

EVENT="${1:-}"
PRESENTATION="${2:-Dispositivo Removível}"
MOUNT_PATH="${3:-}"
LABEL="${4:-}"

NAME="${LABEL:-$PRESENTATION}"
[ -z "$NAME" ] && NAME="Dispositivo USB"

case "$EVENT" in
    device_mounted)
        notify-send -a "Dispositivo USB" \
            -i "drive-removable-media" \
            -u normal \
            -t 4000 \
            "💾 Pen-drive / HD Conectado" \
            "Unidade: <b>$NAME</b>\nMontado em: <code>$MOUNT_PATH</code>"
        ;;
    device_unmounted)
        notify-send -a "Dispositivo USB" \
            -i "media-eject" \
            -u normal \
            -t 3500 \
            "⏏️ Dispositivo Ejetado com Segurança" \
            "<b>$NAME</b> foi desmontado.\nVocê já pode remover o dispositivo com segurança."
        ;;
    device_removed)
        notify-send -a "Dispositivo USB" \
            -i "dialog-information" \
            -u low \
            -t 2500 \
            "🔌 Dispositivo Desconectado" \
            "<b>$NAME</b> foi removido da porta USB."
        ;;
    device_locked)
        notify-send -a "Dispositivo USB" \
            -i "security-high" \
            -u low \
            -t 2000 \
            "🔒 Volume Criptografado Bloqueado" \
            "<b>$NAME</b> foi bloqueado com sucesso."
        ;;
    device_unlocked)
        notify-send -a "Dispositivo USB" \
            -i "security-low" \
            -u normal \
            -t 2500 \
            "🔓 Volume Criptografado Desbloqueado" \
            "<b>$NAME</b> está pronto para uso."
        ;;
esac
