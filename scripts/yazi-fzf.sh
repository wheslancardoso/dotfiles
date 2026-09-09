#!/usr/bin/env bash
# ==============================================================================
# ⚡ YAZI FUZZY JUMP — Busca Cirúrgica Recursiva com FZF
# Atalho: Z no Yazi
# Suporta: Toggle Ocultos (Ctrl+H), Só Pastas (Ctrl+D), Só Arquivos (Ctrl+F),
#          Preview Dinâmico (Eza Tree para pastas, Bat para arquivos)
# ==============================================================================

set -euo pipefail

FD_BASE="fd --follow --exclude .git --exclude node_modules --exclude .cache"
CMD_ALL="$FD_BASE --hidden"
CMD_NO_HIDDEN="$FD_BASE"

SELECTED=$(fzf \
    --prompt="⚡ Yazi Jump > " \
    --header="[ENTER] Revelar no Yazi • [Ctrl+H] Alternar Ocultos • [Ctrl+D] Só Pastas • [Ctrl+F] Só Arquivos" \
    --bind="start:reload($CMD_ALL)" \
    --bind="ctrl-h:transform:[[ \$FZF_PROMPT =~ 'Ocultos' ]] && echo 'change-prompt(⚡ Yazi Jump > )+reload($CMD_NO_HIDDEN)' || echo 'change-prompt(👁️ [Ocultos] Yazi Jump > )+reload($CMD_ALL)'" \
    --bind="ctrl-d:change-prompt(📁 [Pastas] Yazi Jump > )+reload($FD_BASE --type d --hidden)" \
    --bind="ctrl-f:change-prompt(📄 [Arquivos] Yazi Jump > )+reload($FD_BASE --type f --hidden)" \
    --preview='if [ -d {} ]; then eza --tree --color=always --level=2 {} 2>/dev/null | head -100; else bat --style=numbers --color=always --line-range :300 {} 2>/dev/null || cat {} 2>/dev/null; fi' \
    --preview-window="right:55%:wrap" \
    --height=100% \
    --layout=reverse || true)

if [ -n "$SELECTED" ]; then
    ya emit reveal "$SELECTED"
fi
