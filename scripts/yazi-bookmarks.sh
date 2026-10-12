#!/usr/bin/env bash
# ==============================================================================
# 📌 YAZI BOOKMARKS ENGINE — Favoritos Dinâmicos Persistentes
# ==============================================================================
set -euo pipefail

BOOKMARKS_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/yazi/bookmarks.json"
mkdir -p "$(dirname "$BOOKMARKS_FILE")"

if [[ ! -f "$BOOKMARKS_FILE" ]]; then
    echo "{}" > "$BOOKMARKS_FILE"
fi

action="${1:-jump}"
target_dir="${2:-$PWD}"

case "$action" in
    add)
        base_name="$(basename "$target_dir")"
        echo -e "\033[1;34m📌 Adicionar aos Favoritos do Yazi\033[0m"
        echo -e "Diretório: \033[1;32m$target_dir\033[0m"
        read -r -p "Apelido / Nome do Favorito [$base_name]: " custom_name
        name="${custom_name:-$base_name}"
        name="${name//\"/\\\"}"

        jq --arg k "$name" --arg v "$target_dir" '.[$k] = $v' "$BOOKMARKS_FILE" > "$BOOKMARKS_FILE.tmp" && mv "$BOOKMARKS_FILE.tmp" "$BOOKMARKS_FILE"
        notify-send -a "Yazi" "📌 Favorito Salvo" "Pasta '$name' adicionada aos favoritos!" 2>/dev/null || true
        echo -e "\033[1;32m✓ Favorito '$name' salvo com sucesso!\033[0m"
        sleep 0.8
        ;;

    jump)
        count=$(jq 'length' "$BOOKMARKS_FILE" 2>/dev/null || echo 0)
        if [[ "$count" -eq 0 ]]; then
            echo -e "\033[1;33mNenhum favorito cadastrado ainda!\033[0m"
            echo -e "Dica: Pressione \033[1;36mb a\033[0m dentro do Yazi para favoritar uma pasta."
            read -r -n 1 -s -p "Pressione qualquer tecla para continuar..."
            exit 0
        fi

        selected=$(jq -r 'to_entries[] | "\(.key)\t\(.value)"' "$BOOKMARKS_FILE" | fzf \
            --delimiter=$'\t' \
            --with-nth=1 \
            --prompt="📌 Yazi Favoritos > " \
            --header="[Enter] Pular para Pasta • [Esc] Fechar" \
            --preview='path={2}; if [ -d "$path" ]; then eza --tree --color=always --level=2 "$path" 2>/dev/null || ls -la "$path"; else echo "Pasta não encontrada"; fi' \
            --preview-window="right:55%:wrap" \
            --height=80% \
            --layout=reverse || true)

        if [[ -n "$selected" ]]; then
            dir=$(echo "$selected" | cut -f2)
            if [[ -d "$dir" ]]; then
                ya emit cd "$dir"
            else
                echo -e "\033[1;31mErro: Diretório '$dir' não existe!\033[0m"
                sleep 1
            fi
        fi
        ;;

    delete)
        selected=$(jq -r 'to_entries[] | "\(.key)\t\(.value)"' "$BOOKMARKS_FILE" | fzf \
            --delimiter=$'\t' \
            --with-nth=1 \
            --prompt="🗑️ Remover Favorito > " \
            --header="[Enter] Excluir Favorito Selecionado" \
            --preview='path={2}; if [ -d "$path" ]; then ls -la "$path"; fi' \
            --height=80% \
            --layout=reverse || true)

        if [[ -n "$selected" ]]; then
            key=$(echo "$selected" | cut -f1)
            jq --arg k "$key" 'del(.[$k])' "$BOOKMARKS_FILE" > "$BOOKMARKS_FILE.tmp" && mv "$BOOKMARKS_FILE.tmp" "$BOOKMARKS_FILE"
            notify-send -a "Yazi" "🗑️ Favorito Removido" "O marcador '$key' foi excluído." 2>/dev/null || true
            echo -e "\033[1;32m✓ Favorito '$key' removido com sucesso!\033[0m"
            sleep 0.8
        fi
        ;;

    *)
        echo "Uso: $0 {add|jump|delete} [caminho]"
        exit 1
        ;;
esac
