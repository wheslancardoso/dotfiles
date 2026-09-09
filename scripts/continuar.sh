#!/usr/bin/env bash
# ==============================================================================
# 🍿 Continuar Assistindo — Dashboard de Séries e Filmes Recentes (FZF & Rofi)
# ==============================================================================
# Lê o histórico inteligente do MPV (~/.local/state/mpv/watch_history.json)
# Se o último episódio foi concluído (>85%), aponta direto para o PRÓXIMO episódio.
# Se estava no meio, abre exatamente no minuto onde parou.
# ==============================================================================

set -euo pipefail

DB_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/mpv/watch_history.json"

# Cores do terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

# Checa dependência do jq
if ! command -v jq &>/dev/null; then
    echo -e "${RED}[ERRO] 'jq' é necessário para processar o histórico do MPV.${NC}"
    echo -e "Instale com: sudo pacman -S jq"
    exit 1
fi

# Verifica existência do banco de dados
if [ ! -f "$DB_FILE" ] || [ ! -s "$DB_FILE" ]; then
    if [[ "${1:-}" == "--rofi" ]]; then
        rofi -e "Nenhum histórico do MPV registrado ainda.\nAssista a um filme ou série para começar!"
    else
        echo -e "${YELLOW}📺 Nenhum histórico do MPV registrado ainda.${NC}"
        echo -e "Assista a um filme ou série no MPV para que o progresso seja salvo automaticamente."
    fi
    exit 0
fi

# Função para encontrar o próximo episódio no disco
find_next_episode() {
    local current_file="$1"
    local dir
    dir=$(dirname "$current_file")
    local parent_dir
    parent_dir=$(dirname "$dir")
    local folder_name
    folder_name=$(basename "$dir")

    local candidate_dirs=()

    # Se estiver dentro de pasta de temporada (Season 1, Temporada 1), busca irmãs
    if [[ "$folder_name" =~ ^([Ss]eason|[Tt]emporada|[Ss]|[Tt])[[:space:]_-]*[0-9]+ ]]; then
        while IFS= read -r sdir; do
            [ -d "$sdir" ] && candidate_dirs+=("$sdir")
        done < <(find "$parent_dir" -maxdepth 1 -mindepth 1 -type d | sort -V)
    else
        candidate_dirs=("$dir")
    fi

    # Lista todos os arquivos de vídeo em ordem natural
    local all_videos=()
    for d in "${candidate_dirs[@]}"; do
        while IFS= read -r f; do
            [ -n "$f" ] && all_videos+=("$f")
        done < <(find "$d" -maxdepth 1 -type f \( -iname "*.mkv" -o -iname "*.mp4" -o -iname "*.avi" -o -iname "*.webm" -o -iname "*.m4v" \) | sort -V)
    done

    # Encontra o índice do arquivo atual
    local found_idx=-1
    for i in "${!all_videos[@]}"; do
        if [[ "${all_videos[$i]}" == "$current_file" ]]; then
            found_idx=$i
            break
        fi
    done

    if [ "$found_idx" -ge 0 ] && [ "$((found_idx + 1))" -lt "${#all_videos[@]}" ]; then
        echo "${all_videos[$((found_idx + 1))]}"
    else
        echo ""
    fi
}

# Processa e agrupa o histórico
build_items_list() {
    # Extrai itens ordenados por data
    local raw_json
    raw_json=$(jq -r '[.[]] | sort_by(.last_watched // 0) | reverse | .[] | [
        .path // "",
        .filename // "",
        .series_name // "",
        (.time_pos // 0 | tostring),
        (.duration // 0 | tostring),
        (.percent // 0 | tostring),
        (.completed // false | tostring),
        (.last_watched // 0 | tostring)
    ] | @tsv' "$DB_FILE" 2>/dev/null || true)

    if [ -z "$raw_json" ]; then
        return
    fi

    declare -A seen_series=()

    while IFS=$'\t' read -r path filename series_name time_pos duration percent completed last_watched; do
        [ -z "$path" ] && continue
        # Se o arquivo foi deletado do disco, ignora
        [ ! -f "$path" ] && continue

        # Identificador de grupo: agrupa por série (ou caminho do filme se não for série)
        local group_id="$series_name"
        [ -z "$group_id" ] && group_id="$filename"

        if [[ -n "${seen_series[$group_id]:-}" ]]; then
            continue
        fi
        seen_series["$group_id"]=1

        local target_file="$path"
        local target_label=""
        local status_tag=""
        local target_time="0"

        # Converte segundos em MM:SS ou HH:MM:SS
        local mins=$(( time_pos / 60 ))
        local secs=$(( time_pos % 60 ))
        local pos_fmt
        pos_fmt=$(printf "%02d:%02d" "$mins" "$secs")

        local dur_mins=$(( duration / 60 ))
        local dur_secs=$(( duration % 60 ))
        local dur_fmt
        dur_fmt=$(printf "%02d:%02d" "$dur_mins" "$dur_secs")

        # Barra de progresso visual (10 blocos)
        local p_int=${percent%.*}
        [ -z "$p_int" ] && p_int=0
        local filled=$(( p_int / 10 ))
        [ "$filled" -gt 10 ] && filled=10
        local empty=$(( 10 - filled ))
        local bar=""
        for ((b=0; b<filled; b++)); do bar="${bar}█"; done
        for ((b=0; b<empty; b++)); do bar="${bar}░"; done

        if [[ "$completed" == "true" || "$p_int" -ge 85 ]]; then
            local next_ep
            next_ep=$(find_next_episode "$path")
            if [ -n "$next_ep" ] && [ -f "$next_ep" ]; then
                target_file="$next_ep"
                local next_name
                next_name=$(basename "$next_ep")
                status_tag="▶️ [PRÓXIMO]"
                target_label="${series_name} ➔ ${next_name} (0% Novo) | Anterior Concluído"
            else
                status_tag="✅ [CONCLUÍDO]"
                target_label="${series_name} ➔ ${filename} [Temporada Completa]"
            fi
        else
            status_tag="⏸️ [CONTINUAR]"
            target_label="${series_name} ➔ ${filename} [${bar} ${p_int}% | ${pos_fmt} / ${dur_fmt}]"
        fi

        # Data formatada
        local date_fmt
        date_fmt=$(date -d "@$last_watched" "+%d/%m %H:%M" 2>/dev/null || echo "")

        printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n" \
            "$status_tag" "$target_label" "$target_file" "$p_int" "$pos_fmt" "$dur_fmt" "$date_fmt"

    done <<< "$raw_json"
}

# Modo Rofi (Gráfico)
run_rofi() {
    local lines
    lines=$(build_items_list)
    if [ -z "$lines" ]; then
        rofi -e "Nenhum arquivo ativo encontrado no histórico."
        exit 0
    fi

    local display_lines=""
    declare -A file_map=()
    local idx=1

    while IFS=$'\t' read -r status label file percent pos dur dt; do
        local entry="${status}  ${label}"
        file_map["$entry"]="$file"
        if [ -z "$display_lines" ]; then
            display_lines="$entry"
        else
            display_lines="${display_lines}\n${entry}"
        fi
        idx=$((idx + 1))
    done <<< "$lines"

    local selected
    selected=$(echo -e "$display_lines" | rofi -dmenu -i -p "🍿 Continuar Assistindo" -l 10 -theme-str 'window { width: 900px; }')

    if [ -n "$selected" ] && [[ -n "${file_map[$selected]:-}" ]]; then
        local play_target="${file_map[$selected]}"
        notify-send -u low -t 2000 "MPV God Mode" "Abrindo: $(basename "$play_target")"
        nohup mpv "$play_target" >/dev/null 2>&1 &
    fi
}

# Modo Terminal FZF
run_fzf() {
    local lines
    lines=$(build_items_list)
    if [ -z "$lines" ]; then
        echo -e "${YELLOW}Nenhuma mídia encontrada no histórico recente.${NC}"
        exit 0
    fi

    clear
    echo -e "${BLUE}${BOLD}══════════════════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "  🍿 ${MAGENTA}${BOLD}CONTINUAR ASSISTINDO${NC} — Cockpit Inteligente de Séries e Filmes"
    echo -e "${BLUE}══════════════════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "  ${GREEN}Enter${NC}: Reproduzir no MPV | ${YELLOW}Esc${NC}: Sair\n"

    local formatted=""
    declare -A target_map=()

    while IFS=$'\t' read -r status label file percent pos dur dt; do
        local key="${status}  ${label}  (${dt})"
        target_map["$key"]="$file"
        if [ -z "$formatted" ]; then
            formatted="$key"
        else
            formatted="${formatted}\n${key}"
        fi
    done <<< "$lines"

    local choice
    choice=$(echo -e "$formatted" | fzf \
        --ansi \
        --height=60% \
        --reverse \
        --prompt="▶ Escolha a série ou filme: " \
        --header="Pressione ENTER para abrir direto no MPV onde parou" \
        --color="bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8" \
        --color="fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc" \
        --color="marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8")

    if [ -n "$choice" ] && [[ -n "${target_map[$choice]:-}" ]]; then
        local play_target="${target_map[$choice]}"
        echo -e "\n${GREEN}🚀 Iniciando MPV:${NC} ${BOLD}$(basename "$play_target")${NC}\n"
        mpv "$play_target"
    fi
}

# Entrada do script
case "${1:-}" in
    --rofi)
        run_rofi
        ;;
    --clear)
        read -p "Tem certeza que deseja limpar todo o histórico de visualização do MPV? [s/N] " ans
        if [[ "$ans" =~ ^[Ss]$ ]]; then
            echo "{}" > "$DB_FILE"
            echo -e "${GREEN}Histórico limpo com sucesso!${NC}"
        fi
        ;;
    --list)
        build_items_list
        ;;
    *)
        run_fzf
        ;;
esac
