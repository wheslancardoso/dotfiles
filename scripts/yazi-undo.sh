#!/usr/bin/env bash
# ==============================================================================
# ↩️ YAZI SMART UNDO (DESFAZER ÚLTIMA RENOMEAÇÃO)
# ==============================================================================
set -euo pipefail

LOG_FILE="/tmp/yazi_last_rename.log"

if [ ! -f "$LOG_FILE" ]; then
    notify-send -a Yazi -u low "Desfazer (Undo)" "Nenhuma renomeação recente para desfazer."
    exit 0
fi

OLD_PATH=$(sed -n '1p' "$LOG_FILE")
NEW_PATH=$(sed -n '2p' "$LOG_FILE")

if [ -z "$OLD_PATH" ] || [ -z "$NEW_PATH" ]; then
    notify-send -a Yazi -u low "Desfazer (Undo)" "Histórico de renomeação inválido."
    exit 0
fi

if [ ! -e "$NEW_PATH" ]; then
    notify-send -a Yazi -u critical "Erro no Desfazer" "O arquivo '$(basename "$NEW_PATH")' não foi encontrado."
    exit 1
fi

if [ -e "$OLD_PATH" ]; then
    notify-send -a Yazi -u critical "Erro no Desfazer" "O nome original '$(basename "$OLD_PATH")' já existe!"
    exit 1
fi

mv "$NEW_PATH" "$OLD_PATH"
rm -f "$LOG_FILE"

notify-send -a Yazi -i "edit-undo" "Renomeação Desfeita com Sucesso!" "Voltou para: $(basename "$OLD_PATH")"
