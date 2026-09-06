#!/usr/bin/env bash
# ==============================================================================
# 🦁 BRAVE SYNC CHAIN MANAGER — ACESSO RÁPIDO & ZERO-FRICÇÃO
# ==============================================================================
# Gerenciador rápido do código de 25 palavras da corrente de sincronização do Brave.
# - Copia automaticamente para a Área de Transferência (wl-copy / xclip)
# - Permite atualizar apenas a 25ª palavra rotativa diária
# - Notificação nativa no desktop
# - Mantém as credenciais em arquivo seguro (~/.config/brave/sync-code.secret)
# ==============================================================================

set -euo pipefail

export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

# --- Cores Catppuccin ---
MAUVE='\033[38;2;203;166;247m'
PEACH='\033[38;2;250;179;135m'
GREEN='\033[38;2;166;227;161m'
YELLOW='\033[38;2;249;226;175m'
CYAN='\033[38;2;148;226;213m'
SUBTEXT='\033[38;2;166;173;200m'
BOLD='\033[1m'
NC='\033[0m'

SECRET_DIR="${HOME}/.config/brave"
SECRET_FILE="${SECRET_DIR}/sync-code.secret"
BACKUP_SECRET="/mnt/dados/01_Pessoal/.privado/brave-sync.secret"

DEFAULT_SEED="use brave summer volcano hidden bless blur load hurry cry copper canal worry demise eternal reopen genre unit execute captain wet afraid conduct pupil shallow"

notify() {
    local title="$1"
    local msg="$2"
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -a "Brave Sync" -i "brave-browser" "$title" "$msg" 2>/dev/null || true
    fi
}

ensure_secret() {
    if [ ! -f "$SECRET_FILE" ]; then
        if [ -f "$BACKUP_SECRET" ]; then
            mkdir -p "$SECRET_DIR"
            cp "$BACKUP_SECRET" "$SECRET_FILE"
            chmod 600 "$SECRET_FILE"
        else
            mkdir -p "$SECRET_DIR"
            echo "$DEFAULT_SEED" > "$SECRET_FILE"
            chmod 600 "$SECRET_FILE"
        fi
    fi
}

copy_clipboard() {
    local text="$1"
    local copied=false
    if command -v wl-copy >/dev/null 2>&1; then
        echo -n "$text" | wl-copy
        copied=true
    elif command -v xclip >/dev/null 2>&1; then
        echo -n "$text" | xclip -selection clipboard
        copied=true
    elif command -v xsel >/dev/null 2>&1; then
        echo -n "$text" | xsel --clipboard --input
        copied=true
    fi
    if command -v copyq >/dev/null 2>&1; then
        copyq add "$text" 2>/dev/null || true
        copied=true
    fi
    $copied && return 0 || return 1
}

do_show_and_copy() {
    ensure_secret
    local full_code
    full_code=$(cat "$SECRET_FILE" | tr -s ' ' | sed 's/^[ \t]*//;s/[ \t]*$//')

    local -a words
    read -r -a words <<< "$full_code"
    local count=${#words[@]}

    # Copiar para o clipboard
    if copy_clipboard "$full_code"; then
        notify "Brave Sync Copiado!" "As $count palavras da sincronização estão no seu Clipboard."
    fi

    echo -e "${MAUVE}${BOLD}"
    echo "  ╔═══════════════════════════════════════════════════════════════════╗"
    echo "  ║      🦁  BRAVE SYNC CHAIN CODE — 25 PALAVRAS DE SINCRONIA         ║"
    echo "  ╚═══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"

    echo -e "${GREEN}✓ Código copiado para a Área de Transferência com sucesso!${NC}\n"
    echo -e "${SUBTEXT}Palavras da sua corrente (a 25ª palavra é a rotativa diária):${NC}\n"

    local i=1
    for w in "${words[@]}"; do
        if [ "$i" -eq "$count" ]; then
            # Destaque na 25ª palavra rotativa
            printf "  ${PEACH}${BOLD}%2d.${NC} ${YELLOW}${BOLD}%-12s${NC} ${PEACH}← (Palavra do Dia)${NC}\n" "$i" "$w"
        else
            printf "  ${CYAN}%2d.${NC} %-12s " "$i" "$w"
            if [ $((i % 4)) -eq 0 ]; then
                echo ""
            fi
        fi
        i=$((i + 1))
    done
    echo ""
    echo -e "${SUBTEXT}Arquivo protegido salvo em: ${NC}${SECRET_FILE}"
    echo -e "${SUBTEXT}Para atualizar a palavra do dia: ${GREEN}brave-sync --word <palavra>${NC}\n"
}

do_update_word() {
    local new_word="$1"
    if [ -z "$new_word" ]; then
        echo -e "${YELLOW}Uso: brave-sync --word <nova_25a_palavra>${NC}"
        exit 1
    fi

    ensure_secret
    local full_code
    full_code=$(cat "$SECRET_FILE" | tr -s ' ' | sed 's/^[ \t]*//;s/[ \t]*$//')

    local -a words
    read -r -a words <<< "$full_code"

    # Substitui ou adiciona como última palavra
    if [ ${#words[@]} -ge 24 ]; then
        words[24]="$new_word"
    else
        words+=("$new_word")
    fi

    local updated_code="${words[*]}"
    echo "$updated_code" > "$SECRET_FILE"
    chmod 600 "$SECRET_FILE"

    copy_clipboard "$updated_code"
    notify "Palavra do Dia Atualizada" "Nova 25ª palavra: '${new_word}'. Código completo copiado!"
    echo -e "${GREEN}✓ 25ª palavra atualizada para: ${YELLOW}${BOLD}${new_word}${NC}"
    echo -e "${GREEN}✓ Código completo copiado para a Área de Transferência!${NC}"
}

ACTION="${1:-show}"

case "$ACTION" in
    show|ver|"")
        do_show_and_copy
        ;;
    copy|copiar)
        ensure_secret
        cat "$SECRET_FILE" | tr -s ' ' | tr -d '\n' | copy_clipboard
        notify "Brave Sync" "Código copiado silenciosamente para o clipboard."
        ;;
    --word|-w|word)
        shift
        do_update_word "${1:-}"
        ;;
    *)
        if [ "$#" -eq 1 ] && [[ "$1" =~ ^[a-zA-Z]+$ ]]; then
            # Se passou apenas uma palavra, assume que quer atualizar a 25ª palavra
            do_update_word "$1"
        else
            echo "Uso: $0 [show|copy|--word <palavra>]"
            echo "  (sem argumentos)  : Mostra as palavras e copia para a Área de Transferência"
            echo "  copy              : Copia silenciosamente sem imprimir na tela"
            echo "  --word <palavra>  : Atualiza a 25ª palavra rotativa diária"
            exit 1
        fi
        ;;
esac
