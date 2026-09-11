#!/usr/bin/env bash
# ==============================================================================
# 📁 YAZI MKDIR RÁPIDO (CRIAR PASTA SEM DIGITAR BARRA NO FINAL)
# ==============================================================================
set -euo pipefail

CURRENT_DIR="${1:-$PWD}"
if [ ! -d "$CURRENT_DIR" ]; then
    CURRENT_DIR=$(dirname "$CURRENT_DIR")
fi

echo -e "\033[1;34m╔══════════════════════════════════════════════════════════════════════╗\033[0m"
echo -e "\033[1;34m║\033[0m \033[1;36m📁 Criar Nova Pasta (Diretório)\033[0m                                      \033[1;34m║\033[0m"
echo -e "\033[1;34m╚══════════════════════════════════════════════════════════════════════╝\033[0m"
echo -e "Local: \033[1;33m$CURRENT_DIR\033[0m\n"

read -e -p "Nome da nova pasta: " FOLDER_NAME || exit 0

if [ -z "${FOLDER_NAME// }" ]; then
    exit 0
fi

TARGET_PATH="$CURRENT_DIR/$FOLDER_NAME"

if [ -e "$TARGET_PATH" ]; then
    notify-send -a Yazi -u critical "Erro" "Já existe um item chamado '$FOLDER_NAME' aqui."
    exit 1
fi

mkdir -p "$TARGET_PATH"
notify-send -a Yazi -i "folder-new" "Pasta Criada!" "Nome: $FOLDER_NAME"
