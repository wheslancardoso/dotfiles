#!/usr/bin/env bash
# ==============================================================================
# 🪄 YAZI RENAME SMART (ZERO RUÍDO VIM & PROTETOR DE EXTENSÃO)
# ==============================================================================
# Uso:
#   yazi-rename-smart.sh prompt "%s"   -> Abre prompt interativo onde Ctrl+V funciona nativamente
#   yazi-rename-smart.sh paste "%s"    -> Cola direto o título do clipboard preservando a extensão!
# ==============================================================================
set -euo pipefail

ACTION="${1:-prompt}"
FILE="${2:-}"

if [ -z "$FILE" ] || [ ! -e "$FILE" ]; then
    notify-send -a Yazi "Renomear" "Nenhum arquivo selecionado."
    exit 0
fi

DIRNAME=$(dirname "$FILE")
BASENAME=$(basename "$FILE")

# Extrai extensão se existir (e não for arquivo oculto sem extensão como .bashrc)
EXT=""
STEM="$BASENAME"
if [[ "$BASENAME" == *.* && "$BASENAME" != .* ]]; then
    EXT=".${BASENAME##*.}"
    STEM="${BASENAME%.*}"
fi

case "$ACTION" in
    paste)
        # Sanitização profunda do texto copiado para nome de arquivo Linux/NTFS
        # Remove caracteres proibidos: ? * : | " < > e quebras de linha/barras
        CLEAN_CLIP=$(echo "$CLIP" | tr '\n\r/' '   ' | sed -e 's/[?*:|"<>]/_/g' -e 's/^[[:space:]_]*//' -e 's/[[:space:]_]*$//')

        if [ -z "$CLEAN_CLIP" ]; then
            notify-send -a Yazi -u low "Renomear (Colar)" "Clipboard vazio ou inválido!"
            exit 0
        fi

        # Se o texto do clipboard já terminar com a mesma extensão, não duplica
        NEW_BASENAME="$CLEAN_CLIP"
        if [[ -n "$EXT" && "$NEW_BASENAME" != *"$EXT" ]]; then
            NEW_BASENAME="${NEW_BASENAME}${EXT}"
        fi

        NEW_PATH="$DIRNAME/$NEW_BASENAME"

        if [ "$FILE" = "$NEW_PATH" ]; then
            notify-send -a Yazi -u low "Renomear" "O nome já é igual."
            exit 0
        fi

        if [ -e "$NEW_PATH" ]; then
            notify-send -a Yazi -u critical "Erro ao Renomear" "Já existe um arquivo com o nome:\n$NEW_BASENAME"
            exit 1
        fi

        mv "$FILE" "$NEW_PATH"
        # Grava log atômico para possibilitar UNDO (desfazer com 'u')
        printf "%s\n%s\n" "$FILE" "$NEW_PATH" > /tmp/yazi_last_rename.log
        notify-send -a Yazi -i "emblem-default" "Arquivo Renomeado com Sucesso!" "De: $BASENAME\nPara: $NEW_BASENAME"
        ;;

    prompt)
        # Prompt interativo no terminal via Readline puro (estilo shell, sem ruído Vim)
        # Suporta Ctrl+V, Shift+Insert, Backspace normal, setas, Home/End
        echo -e "\033[1;34m╔══════════════════════════════════════════════════════════════════════╗\033[0m"
        echo -e "\033[1;34m║\033[0m \033[1;36mRenomear Arquivo (Suporte total a Ctrl+V / Colar do Clipboard)\033[0m        \033[1;34m║\033[0m"
        echo -e "\033[1;34m╚══════════════════════════════════════════════════════════════════════╝\033[0m"
        echo -e "Arquivo atual: \033[1;33m$BASENAME\033[0m"
        if [ -n "$EXT" ]; then
            echo -e "Extensão:      \033[1;32m$EXT\033[0m (será mantida automaticamente se omitir)\n"
        else
            echo ""
        fi

        read -e -i "$STEM" -p "Novo nome: " USER_INPUT || exit 0

        # Se cancelou com Enter vazio
        if [ -z "$USER_INPUT" ]; then
            exit 0
        fi

        NEW_BASENAME="$USER_INPUT"
        if [[ -n "$EXT" && "$NEW_BASENAME" != *"$EXT" ]]; then
            NEW_BASENAME="${NEW_BASENAME}${EXT}"
        fi

        NEW_PATH="$DIRNAME/$NEW_BASENAME"

        if [ "$FILE" = "$NEW_PATH" ]; then
            exit 0
        fi

        if [ -e "$NEW_PATH" ]; then
            echo -e "\n\033[1;31mErro: Já existe um arquivo chamado '$NEW_BASENAME'.\033[0m"
            read -p "Pressione Enter para voltar..."
            exit 1
        fi

        mv "$FILE" "$NEW_PATH"
        printf "%s\n%s\n" "$FILE" "$NEW_PATH" > /tmp/yazi_last_rename.log
        ;;
esac
