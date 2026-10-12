#!/usr/bin/env bash
# ==============================================================================
# 📂 YAZI CHEATSHEET & HELP VIEWER — Guia Rápido Estilizado
# ==============================================================================
set -euo pipefail

GUIDE_PATH="$HOME/dotfiles/docs/yazi_cheatsheet.md"

if [[ ! -f "$GUIDE_PATH" ]]; then
    echo "Erro: Cheatsheet não encontrado em $GUIDE_PATH"
    read -p "Pressione Enter para fechar..."
    exit 1
fi

if command -v bat >/dev/null 2>&1; then
    bat --style=plain --paging=always "$GUIDE_PATH"
else
    less "$GUIDE_PATH"
fi
