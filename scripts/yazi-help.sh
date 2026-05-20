#!/bin/bash
# Script para exibir o cheatsheet do Yazi em um popup do próprio terminal

GUIDE_PATH="$HOME/dotfiles/yazi/yazi_cheatsheet.md"

if [ ! -f "$GUIDE_PATH" ]; then
    echo "Erro: Guia não encontrado em $GUIDE_PATH"
    exit 1
fi

# Usa o bat para exibir com cores e estilo
bat --style=plain --paging=always "$GUIDE_PATH"
