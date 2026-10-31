#!/usr/bin/env bash
# ==============================================================================
# 🗂️ Wrapper do Yazi para xdg-desktop-portal-termfilechooser
# ==============================================================================
# Quando o navegador (ou qualquer app) pedir um file dialog via portal (upload/download),
# abre o Yazi em janela flutuante com a class "yazi_picker" e título "yazi-float".
# O Hyprland intercepta e aplica float + center + stayfocused automaticamente.
# ==============================================================================

set -euo pipefail

# Argumentos passados pelo portal:
#   $1 = multiple (0 ou 1)
#   $2 = directory (0 ou 1)
#   $3 = save (0 ou 1)
#   $4 = path (diretório inicial ou arquivo sugerido)
#   $5 = out (arquivo onde o yazi deve escrever o caminho escolhido)

multiple="${1:-0}"
directory="${2:-0}"
save="${3:-0}"
path="${4:-$HOME}"
out="${5:-/dev/null}"

touched_placeholder=""

if [ "$save" = "1" ]; then
    if [ -d "$path" ]; then
        target_dir="$path"
    else
        target_dir="$(dirname "$path")"
        if [ ! -e "$path" ]; then
            mkdir -p "$target_dir" 2>/dev/null || true
            touch "$path" 2>/dev/null || true
            touched_placeholder="$path"
        fi
    fi
else
    # Modo Abertura / Upload
    if [ ! -e "$path" ]; then
        path="$(xdg-user-dir DOWNLOAD 2>/dev/null || echo "$HOME/downloads")"
    fi
fi

# Monta os argumentos do Yazi
yazi_args=("--chooser-file=$out")

# Se for modo diretório, usa flag própria
if [ "$directory" = "1" ]; then
    yazi_args+=("--cwd-file=$out")
fi

# Adiciona o arquivo/diretório inicial
yazi_args+=("$path")

# Executa o terminal preferido
if command -v kitty &>/dev/null; then
    kitty --class yazi_picker --title "yazi-float" -e yazi "${yazi_args[@]}" || true
elif command -v alacritty &>/dev/null; then
    alacritty --class yazi_picker,yazi_picker --title "yazi-float" -e yazi "${yazi_args[@]}" || true
elif command -v ghostty &>/dev/null; then
    ghostty --class=yazi_picker --title="yazi-float" -e yazi "${yazi_args[@]}" || true
else
    yazi "${yazi_args[@]}" || true
fi

# Se o usuário cancelou (o out está vazio ou não existe) e tínhamos criado um placeholder temporário de 0 bytes, remove
if [ -n "$touched_placeholder" ] && [ -f "$touched_placeholder" ]; then
    if [ ! -s "$out" ] || ! grep -q "^$touched_placeholder$" "$out" 2>/dev/null; then
        if [ ! -s "$touched_placeholder" ]; then
            rm -f "$touched_placeholder" 2>/dev/null || true
        fi
    fi
fi
