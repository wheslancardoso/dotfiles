#!/bin/bash
# Script robusto para exibir o cheatsheet do Yazi

GUIDE_PATH="/home/lan/dotfiles/yazi/yazi_cheatsheet.md"

if [ ! -f "$GUIDE_PATH" ]; then
    echo "Erro: Guia não encontrado em $GUIDE_PATH"
    read -p "Pressione Enter para fechar..."
    exit 1
fi

# Tenta usar o bat, se falhar usa o cat
if command -v bat &> /dev/null; then
    bat --style=plain --paging=always "$GUIDE_PATH"
else
    cat "$GUIDE_PATH"
    echo ""
    read -p "Pressione Enter para voltar ao Yazi..."
fi
