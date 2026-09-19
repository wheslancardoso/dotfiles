#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */
# ==============================================================================
# 󰞅 APEX EMOJI ENGINE — Busca Inteligente PT-BR, Categorias WhatsApp & Auto-Type
# ==============================================================================

# Se o rofi já estiver rodando, fecha imediatamente (toggle limpo)
if pidof rofi > /dev/null 2>&1; then
  pkill -x rofi 2>/dev/null || true
  exit 0
fi

# Localiza o motor Python
ENGINE="$HOME/dotfiles/home/dot_config/hypr/scripts/rofi_emoji_engine.py"
if [ ! -f "$ENGINE" ]; then
  ENGINE="$HOME/.config/hypr/scripts/rofi_emoji_engine.py"
fi

exec python3 "$ENGINE" "$@"
