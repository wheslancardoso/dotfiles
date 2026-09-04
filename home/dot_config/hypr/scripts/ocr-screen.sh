#!/usr/bin/env bash
# 🔍 Screen OCR (Optical Character Recognition) para Hyprland
# Permite selecionar qualquer área da tela (vídeos, imagens, PDFs protegidos)
# e copiar o texto extraído diretamente para o clipboard via Tesseract + wl-copy.

set -euo pipefail

if ! command -v tesseract &>/dev/null; then
    notify-send -u critical -i dialog-error "OCR Error" "Instale o pacote tesseract: sudo pacman -S tesseract tesseract-data-por tesseract-data-eng"
    exit 1
fi

# Seleciona a região com slurp
geometry=$(slurp 2>/dev/null || true)
if [[ -z "$geometry" ]]; then
    exit 0
fi

# Captura com grim e passa diretamente pelo tesseract via pipe
text=$(grim -g "$geometry" -t png - 2>/dev/null | tesseract stdin stdout -l por+eng --oem 1 --psm 6 2>/dev/null | sed '/^$/d' || true)

if [[ -n "$text" ]]; then
    echo -n "$text" | wl-copy
    # Notificação visual com prévia do texto
    preview=$(echo "$text" | head -n 3 | cut -c 1-80)
    notify-send -a "Screen OCR" -i "edit-copy" "📋 Texto copiado para a área de transferência!" "$preview..."
else
    notify-send -a "Screen OCR" -i "dialog-warning" "Screen OCR" "Nenhum texto detectado na região selecionada."
fi
