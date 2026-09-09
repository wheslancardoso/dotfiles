#!/usr/bin/env bash
# ==============================================================================
# 🔍 ROFI FILE SEARCH — Localizador Instantâneo de Arquivos e Documentos
# Busca ultrarrápida em $HOME e /mnt/dados usando fd + rofi
# ==============================================================================

set -euo pipefail

# Se rofi já estiver aberto, fecha imediatamente
if pgrep -x rofi >/dev/null 2>&1; then
    killall -q rofi
    exit 0
fi

ROFI_THEME="$HOME/.config/rofi/config-search.rasi"
[ -f "$ROFI_THEME" ] || ROFI_THEME="$HOME/.config/rofi/themes/KooL_style-4.rasi"

SEARCH_DIRS=("$HOME" "/mnt/dados")

# Gera lista de arquivos inteligentes (ignora lixo, builds, caches)
SELECTED=$(fd --type f \
    --hidden \
    --follow \
    --exclude .git \
    --exclude node_modules \
    --exclude .cache \
    --exclude .cargo \
    --exclude .rustup \
    --exclude .local/share/Trash \
    --exclude .wine \
    --exclude .venv \
    --exclude .npm \
    --max-results 4000 \
    . "${SEARCH_DIRS[@]}" 2>/dev/null | \
    sed "s|^$HOME|~|" | \
    rofi -dmenu -i \
        -p "🔍 Arquivos" \
        -mesg "ENTER: Abrir Arquivo  •  ALT+ENTER: Abrir Pasta" \
        -kb-custom-1 "Alt+Return" \
        ${ROFI_THEME:+-theme "$ROFI_THEME"} 2>/dev/null || true)

RET=$?
[ -z "$SELECTED" ] && exit 0

TARGET="${SELECTED/#\~/$HOME}"

if [ "$RET" -eq 10 ]; then
    DIR=$(dirname "$TARGET")
    xdg-open "$DIR" &
else
    xdg-open "$TARGET" &
fi
