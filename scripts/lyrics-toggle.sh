#!/usr/bin/env bash
# /* ---- 🎤 lyrics-toggle.sh: Letras Sincronizadas em Tempo Real (MPRIS / Amberol / Spotify) ---- */

set -euo pipefail

# Se sptlrx já estiver aberto, fecha imediatamente (toggle limpo)
if pkill -f "sptlrx" >/dev/null 2>&1; then
    exit 0
fi

# Inicia janela flutuante estilizada de letras sincronizadas
if command -v kitty >/dev/null 2>&1; then
    kitty --class="sptlrx-lyrics" --title="🎤 Letras Sincronizadas (Karaokê)" -e sptlrx -p mpris &
elif command -v ghostty >/dev/null 2>&1; then
    ghostty --class="sptlrx-lyrics" --title="🎤 Letras Sincronizadas (Karaokê)" -e sptlrx -p mpris &
else
    alacritty --class "sptlrx-lyrics" -T "🎤 Letras Sincronizadas (Karaokê)" -e sptlrx -p mpris &
fi
