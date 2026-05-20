#!/bin/bash
# Script para exibir a ajuda do Zellij com estilo

CHEATSHEET="$HOME/dotfiles/zellij/zellij_cheatsheet.md"

if command -v bat &> /dev/null; then
    bat --paging=always --style=plain "$CHEATSHEET"
else
    less "$CHEATSHEET"
fi
