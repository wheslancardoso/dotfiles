#!/usr/bin/env bash
# 🗂️ Wrapper do Yazi para xdg-desktop-portal-termfilechooser
# Quando o navegador (ou qualquer app) pedir um file dialog via portal (upload/download),
# abre o Yazi em janela flutuante com a class "yazi_picker" e título "yazi-float".
# O Hyprland intercepta e aplica float + center + stayfocused automaticamente.

set -euo pipefail

# Argumentos passados pelo portal:
#   $1 = multiple (0 ou 1)
#   $2 = directory (0 ou 1)
#   $3 = save (0 ou 1)
#   $4 = path (diretório inicial sugerido)
#   $5 = out (arquivo onde o yazi deve escrever o caminho escolhido)

multiple="${1:-0}"
directory="${2:-0}"
save="${3:-0}"
path="${4:-$HOME}"
out="${5:-/dev/null}"

# Se o path não existir, usa downloads como fallback
[ -d "$path" ] || path="$(xdg-user-dir DOWNLOAD 2>/dev/null || echo "$HOME/downloads")"

# Monta os argumentos do Yazi
yazi_args=("--chooser-file=$out")

# Se for modo diretório, usa flag própria
if [ "$directory" = "1" ]; then
    yazi_args+=("--cwd-file=$out")
fi

# Adiciona o diretório inicial
yazi_args+=("$path")

# Prioriza Alacritty (preferido do usuário), com fallback para Kitty, Ghostty ou shell padrão
if command -v alacritty &>/dev/null; then
    exec alacritty --class yazi_picker,yazi_picker --title "yazi-float" -e yazi "${yazi_args[@]}"
elif command -v kitty &>/dev/null; then
    exec kitty --class yazi_picker --title "yazi-float" -e yazi "${yazi_args[@]}"
elif command -v ghostty &>/dev/null; then
    exec ghostty --class=yazi_picker --title="yazi-float" -e yazi "${yazi_args[@]}"
else
    exec yazi "${yazi_args[@]}"
fi
