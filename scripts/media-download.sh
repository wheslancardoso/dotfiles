#!/usr/bin/env bash
# ==============================================================================
# 📥 MEDIA DOWNLOADER SUITE DEFINITIVO (APEX V2) — HYPRLAND, YAZI & TERMINAL
# ==============================================================================
# Motores: yt-dlp + spotdl + gallery-dl + aria2c + ffmpeg + playerctl + ripdrag
# Suporte: YouTube, Spotify, Twitter/X, Instagram, TikTok, Reddit, Twitch, Vimeo,
#          sites privados/adultos, álbuns de fotos e mais de 1.800 plataformas.
# ==============================================================================

set -eo pipefail
export PATH="$HOME/.local/bin:$PATH"

# ------------------------------------------------------------------------------
# DIRETÓRIOS CANÔNICOS DE DESTINO
# ------------------------------------------------------------------------------
if [ -d "/mnt/dados/05_Midias_Design_e_Criacao" ]; then
    DEFAULT_DEST_VIDEO="/mnt/dados/05_Midias_Design_e_Criacao/Videos/Downloads"
    DEFAULT_DEST_SERIES="/mnt/dados/05_Midias_Design_e_Criacao/Videos/Séries"
    DEFAULT_DEST_MOVIES="/mnt/dados/05_Midias_Design_e_Criacao/Videos/Filmes"
    DEFAULT_DEST_AUDIO="/mnt/dados/05_Midias_Design_e_Criacao/Musicas_e_Audios/Downloads"
    DEFAULT_DEST_IMAGE="/mnt/dados/05_Midias_Design_e_Criacao/Imagens/Downloads"
    DEFAULT_DEST_TRANSCRIPT="/mnt/dados/05_Midias_Design_e_Criacao/Videos/Transcrições"
    DEFAULT_DEST_PRIVATE="/mnt/dados/01_Pessoal_e_Vida/.privado"
elif [ -d "$HOME/drive-organizacao/05_Design_Midia_e_Criacao" ]; then
    DEFAULT_DEST_VIDEO="$HOME/drive-organizacao/05_Design_Midia_e_Criacao/05.4_Filmes_e_Series"
    DEFAULT_DEST_SERIES="$HOME/drive-organizacao/05_Design_Midia_e_Criacao/05.4_Filmes_e_Series/Séries"
    DEFAULT_DEST_MOVIES="$HOME/drive-organizacao/05_Design_Midia_e_Criacao/05.4_Filmes_e_Series/Filmes"
    DEFAULT_DEST_AUDIO="$HOME/drive-organizacao/05_Design_Midia_e_Criacao/05.2_Audios_e_Midias"
    DEFAULT_DEST_IMAGE="$HOME/drive-organizacao/05_Design_Midia_e_Criacao/05.1_Artes_e_Wallpapers"
    DEFAULT_DEST_TRANSCRIPT="$HOME/drive-organizacao/05_Design_Midia_e_Criacao/05.4_Filmes_e_Series/Transcrições"
    DEFAULT_DEST_PRIVATE="$HOME/drive-organizacao/01_Pessoal_e_Vida/.privado"
else
    DEFAULT_DEST_VIDEO="$HOME/Videos/Downloads"
    DEFAULT_DEST_SERIES="$HOME/Videos/Séries"
    DEFAULT_DEST_MOVIES="$HOME/Videos/Filmes"
    DEFAULT_DEST_AUDIO="$HOME/Music/Downloads"
    DEFAULT_DEST_IMAGE="$HOME/Pictures/Downloads"
    DEFAULT_DEST_TRANSCRIPT="$HOME/Videos/Transcrições"
    DEFAULT_DEST_PRIVATE="$HOME/.privado"
fi

STATE_DIR="$HOME/.local/state/media-downloader"
HISTORY_FILE="$STATE_DIR/history.log"
mkdir -p "$STATE_DIR"

CUSTOM_DIR=""
CUSTOM_NAME=""
CUSTOM_CLIP=""
COMPRESS_TARGET=""
MAKE_GIF=false
SPLIT_CHAPTERS=false
SYNC_PLAYLIST=false
STUDY_SPEED=""
COOKIES_BROWSER=""
SUB_ONLY=false
THUMB_ONLY=false
WITH_SUBS=false
SKIP_SPONSORS=false
FORCE_PRIVATE=false
BATCH_FILE=""
SEASON_ARG=""
EP_ARG=""
STREAM_AUDIO_LANG="pt"
STREAM_AUDIO_LANG_SET=false


# ------------------------------------------------------------------------------
# CORES CATPPUCCIN MOCHA PARA TERMINAL
# ------------------------------------------------------------------------------
MAUVE='\033[38;2;203;166;247m'
BLUE='\033[38;2;137;180;250m'
GREEN='\033[38;2;166;227;161m'
PEACH='\033[38;2;250;179;135m'
RED='\033[38;2;243;139;168m'
YELLOW='\033[38;2;249;226;175m'
TEAL='\033[38;2;148;226;213m'
TEXT='\033[38;2;205;214;244m'
SUBTEXT='\033[38;2;166;173;200m'
BOLD='\033[1m'
NC='\033[0m'

# ------------------------------------------------------------------------------
# UTILITÁRIOS & HELPERS
# ------------------------------------------------------------------------------
log_history() {
    local title="$1"
    local url="$2"
    local dest_path="$3"
    local type="$4"
    local date_str
    date_str=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${date_str}\t${type}\t${title}\t${url}\t${dest_path}" >> "$HISTORY_FILE"
}

get_clipboard_url() {
    local clip=""
    if command -v wl-paste >/dev/null 2>&1; then
        clip=$(wl-paste --no-newline 2>/dev/null || true)
    elif command -v xclip >/dev/null 2>&1; then
        clip=$(xclip -o -selection clipboard 2>/dev/null || true)
    fi
    if [[ "$clip" =~ ^https?:// ]]; then
        echo "$clip"
    fi
}

is_url_or_file() {
    local input="$1"
    input="${input/#\~/$HOME}"
    if [[ "$input" =~ ^https?:// ]] || [[ "$input" =~ ^magnet:\? ]] || [ -f "$input" ] || [ -d "$input" ] || [ -f "$DEFAULT_DEST_PRIVATE/$input" ]; then
        return 0
    fi
    return 1
}

search_youtube_fzf() {
    local query="$1"
    echo -e "${MAUVE}🔍 Pesquisando vídeos no YouTube para: ${BOLD}${query}${NC}..." >&2

    local raw_results
    raw_results=$(yt-dlp --print "%(title)s [%(duration>%H:%M:%S)s] • %(channel)s	%(webpage_url)s" "ytsearch10:${query}" 2>/dev/null || true)

    if [ -z "$raw_results" ]; then
        echo -e "${RED}❌ Nenhum vídeo encontrado para a busca '${query}'.${NC}" >&2
        return 1
    fi

    if ! command -v fzf >/dev/null 2>&1 || [ ! -t 0 ]; then
        echo "$raw_results" | head -n1 | cut -f2
        return 0
    fi

    local selected
    selected=$(echo "$raw_results" | fzf \
        --prompt="🎬 Selecione o vídeo para baixar > " \
        --height=50% \
        --layout=reverse \
        --border=rounded \
        --color=header:italic,spinner:#f5e0dc,hl:#f38ba8 \
        --color=fg:#cdd6f4,header:#cba6f7,info:#cba6f7,pointer:#f5e0dc \
        --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
        --with-nth=1 \
        --delimiter="\t")

    if [ -z "$selected" ]; then
        echo -e "${YELLOW}Busca cancelada pelo usuário.${NC}" >&2
        return 1
    fi

    echo "$selected" | cut -f2
}

search_pomfy_fzf() {
    local query="$1"
    local script_extractor="/home/lan/dotfiles/scripts/stream-extractor/pomfy-extractor.js"
    if [ ! -f "$script_extractor" ]; then
        echo -e "${RED}❌ Extrator Pomfy não encontrado em $script_extractor${NC}" >&2
        return 1
    fi

    while true; do
        if [ -z "$query" ]; then
            read -rp "🎬 Digite o nome do filme ou série (ou 'q' para sair): " query
        fi
        if [ -z "$query" ] || [ "$query" == "q" ] || [ "$query" == "exit" ]; then
            echo -e "${YELLOW}Busca cancelada.${NC}" >&2
            return 1
        fi

        echo -e "${MAUVE}🔍 Pesquisando catálogo Pomfy para: ${BOLD}${query}${NC}..." >&2
        local raw_json
        raw_json=$(node "$script_extractor" search "$query" 2>/dev/null || true)

        if [ -z "$raw_json" ] || [ "$raw_json" == "[]" ]; then
            echo -e "${RED}❌ Nenhum filme ou série encontrado para '${query}'.${NC}" >&2
            query=""
            continue
        fi

        local formatted_lines
        formatted_lines=$(echo "$raw_json" | jq -r '.[] | 
            (if .type == "serie" then "📺 [SÉRIE]" else "🎬 [FILME]" end) as $t |
            (if .year != "" then " (" + .year + ")" else "" end) as $y |
            (if .rating != "" then " • ⭐ " + .rating else "" end) as $r |
            (if .available then " ✔️ [Disponível]" else " ⏳ [Indisponível]" end) as $st |
            "\($t) \(.title)\($y)\($r)\($st)\t\(.url)\t\(.available)"
        ')

        if [ -z "$formatted_lines" ]; then
            echo -e "${RED}❌ Não foi possível formatar os resultados do Pomfy.${NC}" >&2
            query=""
            continue
        fi

        if ! command -v fzf >/dev/null 2>&1 || [ ! -t 0 ]; then
            echo "$formatted_lines" | head -n1 | cut -f2
            return 0
        fi

        local cache_file="/tmp/pomfy_search_${$}.json"
        echo "$raw_json" > "$cache_file"

        local fzf_output
        fzf_output=$(echo "$formatted_lines" | fzf \
            --expect="ctrl-s,ctrl-r" \
            --prompt="🎬 Selecione Filme ou Série > " \
            --header="[ENTER] Baixar • [Ctrl+O] Pôster HD • [Ctrl+S] Nova Busca • [Ctrl+J/K] Navegar • [ESC] Sair" \
            --height=75% \
            --layout=reverse \
            --border=rounded \
            --color=header:italic,spinner:#f5e0dc,hl:#f38ba8 \
            --color=fg:#cdd6f4,header:#cba6f7,info:#cba6f7,pointer:#f5e0dc \
            --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
            --bind="ctrl-j:down,ctrl-k:up,ctrl-d:preview-page-down,ctrl-u:preview-page-up,ctrl-o:execute-silent(node \"$script_extractor\" open-poster \"$cache_file\" {2})" \
            --preview="node \"$script_extractor\" render-preview \"$cache_file\" {2}" \
            --preview-window="right:55%:wrap:border-rounded" \
            --with-nth=1 \
            --delimiter="\t")

        rm -f "$cache_file"

        if [ -z "$fzf_output" ]; then
            echo -e "${YELLOW}Busca cancelada pelo usuário.${NC}" >&2
            return 1
        fi

        local key_pressed
        key_pressed=$(echo "$fzf_output" | head -n1)
        local selected
        selected=$(echo "$fzf_output" | tail -n +2)

        if [ "$key_pressed" == "ctrl-s" ] || [ "$key_pressed" == "ctrl-r" ]; then
            echo ""
            read -rp "🔍 Digite o novo termo de pesquisa: " query
            continue
        fi

        if [ -z "$selected" ]; then
            query=""
            continue
        fi

        local chosen_url is_avail
        chosen_url=$(echo "$selected" | cut -f2)
        is_avail=$(echo "$selected" | cut -f3)

        if [ "$is_avail" == "false" ]; then
            echo -e "${PEACH}⚠️ Aviso: Este título pode não estar indexado no momento pelo servidor.${NC}" >&2
        fi

        echo "$chosen_url"
        return 0
    done
}

get_now_playing_info() {
    if ! command -v playerctl >/dev/null 2>&1; then
        return 1
    fi

    local url=""
    url=$(playerctl metadata --format '{{xesam:url}}' 2>/dev/null || true)

    if [[ "$url" =~ ^https?:// ]]; then
        echo "$url"
        return 0
    fi

    local artist title
    artist=$(playerctl metadata --format '{{xesam:artist}}' 2>/dev/null || true)
    title=$(playerctl metadata --format '{{xesam:title}}' 2>/dev/null || true)

    if [ -n "$title" ]; then
        if [ -n "$artist" ]; then
            echo "ytsearch1:${artist} - ${title}"
        else
            echo "ytsearch1:${title}"
        fi
        return 0
    fi

    return 1
}

is_sensitive_domain() {
    local url="$1"
    local pattern="(xvideos\.com|pornhub\.com|erome\.com|spankbang\.com|redgifs\.com|rule34|gelbooru|danbooru|e-hentai|nhentai|onlyfans|fansly|coomer|kemono|eporner|beeg|youporn|chaturbate|stripchat|xhamster)"
    if echo "$url" | grep -qiE "$pattern"; then
        return 0
    fi
    return 1
}

is_gallery_domain() {
    local url="$1"
    local pattern="(artstation\.com/artwork|pinterest\.com/pin|imgur\.com/a/)"
    if echo "$url" | grep -qiE "$pattern"; then
        return 0
    fi
    return 1
}

is_magnet_or_torrent() {
    local url="$1"
    if [[ "$url" =~ ^magnet:\? ]] || [[ "$url" =~ \.torrent($|\?) ]]; then
        return 0
    fi
    return 1
}

is_direct_download_file() {
    local url="$1"
    local pattern="\.(iso|zip|tar\.gz|tar\.xz|tar\.zst|7z|rar|exe|msi|dmg|pkg|deb|rpm|bin|apk)($|\?)"
    if echo "$url" | grep -qiE "$pattern"; then
        return 0
    fi
    return 1
}

is_pomfy_domain() {
    local url="$1"
    if [[ "$url" =~ (pomfy\.online|pomfy\.stream) ]]; then
        return 0
    fi
    return 1
}

download_torrent_or_magnet() {
    local url="$1"
    local dest_dir="${2:-$DEFAULT_DEST_VIDEO}"
    mkdir -p "$dest_dir"
    echo -e "${PEACH}🧲 Baixando via Torrent/Magnet com Aria2c (P2P Multi-peer)...${NC}"
    if command -v aria2c >/dev/null 2>&1; then
        aria2c --dir="$dest_dir" \
            --seed-time=0 \
            --max-connection-per-server=16 \
            --split=16 \
            --min-split-size=1M \
            --summary-interval=5 \
            "$url"
        notify_completion "Torrent / Magnet Baixado" "$dest_dir"
    else
        echo -e "${RED}❌ aria2c não encontrado para download de torrents.${NC}"
        exit 1
    fi
}

download_direct_file() {
    local url="$1"
    local dest_dir="${2:-$DEFAULT_DEST_VIDEO}"
    mkdir -p "$dest_dir"
    echo -e "${TEAL}🚀 Acelerando download de arquivo direto com Aria2c (16 conexões simultâneas)...${NC}"
    if command -v aria2c >/dev/null 2>&1; then
        aria2c --dir="$dest_dir" \
            --continue=true \
            --max-connection-per-server=16 \
            --split=16 \
            --min-split-size=1M \
            --summary-interval=3 \
            "$url"
        notify_completion "Arquivo Direto Baixado" "$dest_dir"
    else
        echo -e "${YELLOW}Aria2c não encontrado, baixando via curl...${NC}"
        curl -C - -L -O --output-dir "$dest_dir" "$url"
        notify_completion "Arquivo Direto Baixado" "$dest_dir"
    fi
}

download_batch() {
    local file="$1"
    local dest="$2"
    local mode="${3:-video}"

    if [ ! -f "$file" ]; then
        echo -e "${RED}❌ Arquivo de lote não encontrado:${NC} $file"
        exit 1
    fi

    local file_ext="${file##*.}"
    file_ext=$(echo "$file_ext" | tr '[:upper:]' '[:lower:]')
    local file_name
    file_name=$(basename "$file")

    local urls=()
    while IFS= read -r line; do
        [ -n "$line" ] && urls+=("$line")
    done < <(grep -oP '(https?://[^\s\)\"\>\]]+|magnet:\?[^\s\)\"\>\]]+)' "$file" 2>/dev/null | sed -e 's/[.,;:]$//' | awk '!seen[$0]++')

    local total="${#urls[@]}"
    if [ "$total" -eq 0 ]; then
        echo -e "${YELLOW}Nenhuma URL válida encontrada em $file.${NC}"
        exit 0
    fi

    echo -e "${MAUVE}${BOLD}╭──────────────────────────────────────────────────────────────╮${NC}"
    echo -e "${MAUVE}${BOLD}│       📦 DOWNLOAD EM LOTE APEX V2 (BATCH MODE ATIVADO)       │${NC}"
    echo -e "${MAUVE}${BOLD}╰──────────────────────────────────────────────────────────────╯${NC}"
    echo -e "  ${BOLD}Arquivo Fonte  :${NC} $file_name (${file_ext^^})"
    echo -e "  ${BOLD}Fila de Mídias :${NC} ${BOLD}$total links válidos detectados${NC}"
    echo -e "  ${BLUE}Pasta Destino  :${NC} $dest"
    echo -e "  ${SUBTEXT}Multi-thread 16 conexões ativas + detecção automática de duplicados.${NC}\n"

    local current=0
    local success_new=0
    local already_downloaded=0
    local failed=0
    local failed_urls=()

    for u in "${urls[@]}"; do
        current=$((current + 1))
        local pct=$(( current * 100 / total ))
        echo -e "${PEACH}[$current/$total] (${pct}%) ⬇️ Processando:${NC} $u"
        local item_dest="$dest"
        if is_sensitive_domain "$u" || [ "$FORCE_PRIVATE" = true ]; then
            item_dest="$DEFAULT_DEST_PRIVATE/Videos_e_Cenas"
            [ "$mode" == "audio" ] && item_dest="$DEFAULT_DEST_PRIVATE/Audios"
            mkdir -p "$item_dest"
        fi

        local archive_file="$item_dest/.download_archive.txt"
        local lines_before=0
        [ -f "$archive_file" ] && lines_before=$(wc -l < "$archive_file" 2>/dev/null || echo 0)

        local res=0
        if is_pomfy_domain "$u"; then
            download_streaming_pomfy "$u" "$SEASON_ARG" "$EP_ARG" || res=1
        elif is_magnet_or_torrent "$u"; then
            download_torrent_or_magnet "$u" "$item_dest" || res=1
        elif is_direct_download_file "$u"; then
            download_direct_file "$u" "$item_dest" || res=1
        elif [[ "$u" =~ (open\.spotify\.com|spotify:) ]]; then
            download_spotify "$u" "mp3" "$item_dest" "cli" || res=1
        elif is_gallery_domain "$u"; then
            download_gallery "$u" "$item_dest" || res=1
        elif [ "$mode" == "audio" ]; then
            download_audio "$u" "$item_dest" "" true || res=1
        else
            download_video "$u" "best" "$item_dest" "" true || res=1
        fi

        if [ "$res" -eq 0 ]; then
            local lines_after=0
            [ -f "$archive_file" ] && lines_after=$(wc -l < "$archive_file" 2>/dev/null || echo 0)
            if [ "$lines_after" -gt "$lines_before" ]; then
                success_new=$((success_new + 1))
                echo -e "   ${GREEN}✔ [SUCESSO] Baixado e convertido para MP4 com sucesso!${NC}"
            else
                already_downloaded=$((already_downloaded + 1))
                echo -e "   ${TEAL}⏭️  [JÁ EXISTE] Já registrado no histórico local (arquivo preservado).${NC}"
            fi
        else
            failed=$((failed + 1))
            failed_urls+=("$u")
            echo -e "   ${RED}❌ [FALHA] Link indisponível, excluído ou protegido (404/410).${NC}"
        fi
        echo ""
    done

    echo -e "${MAUVE}${BOLD}╭──────────────────────────────────────────────────────────────╮${NC}"
    echo -e "${MAUVE}${BOLD}│             📊 RESUMO DO PROCESSAMENTO EM LOTE               │${NC}"
    echo -e "${MAUVE}${BOLD}╰──────────────────────────────────────────────────────────────╯${NC}"
    echo -e "  ${BOLD}Total de URLs processadas :${NC} $total"
    echo -e "  ${GREEN}✅ Baixados com sucesso   :${NC} ${BOLD}$success_new${NC}"
    echo -e "  ${TEAL}⏭️  Já existiam (pulados)  :${NC} ${BOLD}$already_downloaded${NC}"
    echo -e "  ${RED}❌ Links indisponíveis    :${NC} ${BOLD}$failed${NC}"
    echo -e "${MAUVE}────────────────────────────────────────────────────────────────${NC}"

    if [ "$failed" -gt 0 ]; then
        local fail_file="${dest}/falhas_download_$(date +%Y%m%d_%H%M%S).txt"
        printf "%s\n" "${failed_urls[@]}" > "$fail_file"
        echo -e "${YELLOW}📝 Lista dos links que falharam salva em:${NC} $fail_file\n"
    fi

    notify_completion "Lote Concluído: $success_new novos, $already_downloaded pulados, $failed falhas" "$dest"
}




get_downloader_args() {
    # Motor multi-thread nativo turbo do yt-dlp (-N 24):
    # Conexões paralelas massivas para HLS/DASH/m3u8 e arquivos diretos,
    # buffer de 32MB na RAM para saturar conexões gigabit sem gargalo de disco.
    echo "-N 24 --concurrent-fragments 24 --buffer-size 32M --http-chunk-size 16M --retries 10 --fragment-retries 10 --file-access-retries 5 --retry-sleep exp=1:5 --no-warnings"
}

notify_completion() {
    local title="$1"
    local dest_dir="$2"
    local target_file="${3:-}"

    if [ -z "$target_file" ]; then
        target_file=$(find "$dest_dir" -maxdepth 2 -type f \( -name "*.mp3" -o -name "*.flac" -o -name "*.m4a" -o -name "*.mp4" -o -name "*.mkv" -o -name "*.webm" -o -name "*.gif" -o -name "*.png" -o -name "*.jpg" -o -name "*.md" \) -printf '%T@ %p\n' 2>/dev/null | sort -n | tail -1 | cut -f2- -d" ")
    fi

    if command -v notify-send >/dev/null 2>&1; then
        local action
        action=$(notify-send -a "Media Downloader" \
            -t 15000 \
            -A "play=▶️ Assistir / Ouvir" \
            -A "folder=📂 Abrir Pasta" \
            -A "drag=🚀 Arrastar (ripdrag)" \
            "✅ Download Concluído!" \
            "$title") || true

        case "$action" in
            play)
                if [ -n "$target_file" ] && [ -f "$target_file" ]; then
                    xdg-open "$target_file" &
                else
                    xdg-open "$dest_dir" &
                fi
                ;;
            folder)
                xdg-open "$dest_dir" &
                ;;
            drag)
                if command -v ripdrag >/dev/null 2>&1 && [ -n "$target_file" ] && [ -f "$target_file" ]; then
                    ripdrag -x "$target_file" &
                else
                    xdg-open "$dest_dir" &
                fi
                ;;
        esac
    fi
}

# ------------------------------------------------------------------------------
# PROCESSAMENTO FFmpeg (COMPRESSÃO, GIF, ESTUDO)
# ------------------------------------------------------------------------------
compress_video() {
    local input_file="$1"
    local target_mb="${2:-10}"
    local output_file="${input_file%.*}_${target_mb}MB.mp4"

    if ! command -v ffmpeg >/dev/null 2>&1; then
        return 0
    fi

    echo -e "${PEACH}🗜️ Comprimindo vídeo para caber em ${target_mb}MB (Discord/WhatsApp)...${NC}"
    local duration
    duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input_file" 2>/dev/null || echo "60")
    duration=${duration%.*}
    [ "$duration" -le 0 ] && duration=60

    local target_kbits=$(( (target_mb * 8192) / duration ))
    local video_bitrate=$(( target_kbits - 128 ))
    [ "$video_bitrate" -lt 150 ] && video_bitrate=150

    ffmpeg -y -i "$input_file" \
        -c:v libx264 -preset veryfast -b:v "${video_bitrate}k" \
        -vf "scale='min(1280,iw)':-2" \
        -c:a aac -b:a 128k \
        -movflags +faststart \
        "$output_file" >/dev/null 2>&1 || true

    if [ -f "$output_file" ]; then
        echo -e "${GREEN}✔ Vídeo comprimido criado:${NC} $(basename "$output_file")"
        echo "$output_file"
    else
        echo "$input_file"
    fi
}

create_gif_from_video() {
    local input_file="$1"
    local output_gif="${input_file%.*}.gif"

    if ! command -v ffmpeg >/dev/null 2>&1; then
        return 0
    fi

    echo -e "${MAUVE}🎞️ Gerando GIF animado fluido em alta fidelidade...${NC}"
    local palette="/tmp/palette_$$.png"
    ffmpeg -y -i "$input_file" -vf "fps=15,scale='min(480,iw)':-1:flags=lanczos,palettegen" "$palette" >/dev/null 2>&1 || true
    ffmpeg -y -i "$input_file" -i "$palette" -lavfi "fps=15,scale='min(480,iw)':-1:flags=lanczos [x]; [x][1:v] paletteuse" "$output_gif" >/dev/null 2>&1 || true
    rm -f "$palette"

    if [ -f "$output_gif" ]; then
        echo -e "${GREEN}✔ GIF gerado com sucesso:${NC} $(basename "$output_gif")"
        echo "$output_gif"
    fi
}

apply_study_filters() {
    local input_audio="$1"
    local speed="${2:-1.5}"
    local output_study="${input_audio%.*}_${speed}x.mp3"

    if ! command -v ffmpeg >/dev/null 2>&1; then
        return 0
    fi

    echo -e "${TEAL}⏩ Aplicando Modo Estudo (Remoção de silêncio + Aceleração ${speed}x com tom original)...${NC}"
    ffmpeg -y -i "$input_audio" \
        -af "silenceremove=stop_periods=-1:stop_duration=0.5:stop_threshold=-40dB,atempo=${speed}" \
        -c:a libmp3lame -q:a 2 \
        "$output_study" >/dev/null 2>&1 || true

    if [ -f "$output_study" ]; then
        echo -e "${GREEN}✔ Áudio acelerado para estudos pronto:${NC} $(basename "$output_study")"
        echo "$output_study"
    fi
}

# ------------------------------------------------------------------------------
# MOTOR DE DOWNLOAD (VÍDEO / YT-DLP)
# ------------------------------------------------------------------------------
download_video() {
    local url="$1"
    local quality="${2:-best}"
    local dest="$3"
    local clip_range="${4:-$CUSTOM_CLIP}"
    local is_batch="${5:-false}"
    local dl_args
    dl_args=$(get_downloader_args)

    mkdir -p "$dest"
    cd "$dest"

    local format_str="bv*+ba/b"
    if [ "$quality" == "720" ]; then
        format_str="bv*[height<=720]+ba/b[height<=720]"
    elif [ "$quality" == "1080" ]; then
        format_str="bv*[height>=1080]+ba/bv*[height<=1080]+ba/b"
    fi

    local extra_flags=()
    [ -n "$clip_range" ] && extra_flags+=(--download-sections "*${clip_range}" --force-keyframes-at-cuts)
    [ "$SPLIT_CHAPTERS" = true ] && extra_flags+=(--split-chapters -o "chapter:%(title)s/%(section_number)02d - %(section_title)s.%(ext)s")
    if [ "$SYNC_PLAYLIST" = true ] || [ "$FORCE_PRIVATE" = true ] || [ "$is_batch" = true ]; then
        extra_flags+=(--download-archive "$dest/.download_archive.txt")
    fi
    [ -n "$COOKIES_BROWSER" ] && extra_flags+=(--cookies-from-browser "$COOKIES_BROWSER")
    [ "$SKIP_SPONSORS" = true ] && extra_flags+=(--sponsorblock-remove "sponsor,selfpromo,interaction,intro,outro")
    [ "$SUB_ONLY" = true ] && extra_flags+=(--skip-download --write-auto-subs --sub-lang 'pt,en' --convert-subs srt)
    [ "$THUMB_ONLY" = true ] && extra_flags+=(--skip-download --write-thumbnail --convert-thumbnails png)
    [ "$WITH_SUBS" = true ] && extra_flags+=(--write-auto-subs --sub-lang 'pt,en' --embed-subs)

    local output_tpl="%(title)s [%(id)s].%(ext)s"
    if [ -n "$CUSTOM_NAME" ]; then
        local base_custom="${CUSTOM_NAME%.*}"
        output_tpl="${base_custom}.%(ext)s"
    elif [[ "$url" =~ list= ]] && [ "$SPLIT_CHAPTERS" = false ]; then
        output_tpl="%(playlist_title,playlist)s/%(playlist_index)02d - %(title)s.%(ext)s"
    fi

    [ "$is_batch" = false ] && echo -e "${BLUE}⬇️ Baixando vídeo com aceleração nativa multi-thread (-N 16)...${NC}"
    local dl_status=0
    eval yt-dlp \
        $dl_args \
        -f "'$format_str'" \
        --merge-output-format mp4 \
        --remux-video mp4 \
        --embed-thumbnail \
        --embed-metadata \
        --embed-chapters \
        -o "'$output_tpl'" \
        --windows-filenames \
        --no-mtime \
        "${extra_flags[@]}" \
        "'$url'" || dl_status=$?

    # Fallback automático para Brave / Chrome cookies se falhar e não tinha browser configurado
    if [ "$dl_status" -ne 0 ] && [ -z "$COOKIES_BROWSER" ]; then
        echo -e "${YELLOW}⚠️ Download anônimo falhou ou requer autenticação. Tentando com cookies do Brave...${NC}"
        dl_status=0
        eval yt-dlp \
            $dl_args \
            --cookies-from-browser brave \
            -f "'$format_str'" \
            --merge-output-format mp4 \
            --remux-video mp4 \
            --embed-thumbnail \
            --embed-metadata \
            --embed-chapters \
            -o "'$output_tpl'" \
            --windows-filenames \
            --no-mtime \
            "${extra_flags[@]}" \
            "'$url'" || dl_status=$?

        if [ "$dl_status" -ne 0 ]; then
            echo -e "${YELLOW}⚠️ Tentando alternativamente com cookies do Chrome...${NC}"
            dl_status=0
            eval yt-dlp \
                $dl_args \
                --cookies-from-browser chrome \
                -f "'$format_str'" \
                --merge-output-format mp4 \
                --remux-video mp4 \
                --embed-thumbnail \
                --embed-metadata \
                --embed-chapters \
                -o "'$output_tpl'" \
                --windows-filenames \
                --no-mtime \
                "${extra_flags[@]}" \
                "'$url'" || dl_status=$?
        fi
    fi

    if [ "$dl_status" -ne 0 ]; then
        return 1
    fi

    local latest_file
    latest_file=$(find "$dest" -maxdepth 2 -type f \( -name "*.mp4" -o -name "*.mkv" -o -name "*.webm" -o -name "*.gif" \) -printf '%T@ %p\n' 2>/dev/null | sort -n | tail -1 | cut -f2- -d" ")
    local final_target="$latest_file"

    if [ "$MAKE_GIF" = true ] && [ -n "$latest_file" ] && [ -f "$latest_file" ]; then
        local gif_path
        gif_path=$(create_gif_from_video "$latest_file")
        [ -n "$gif_path" ] && final_target="$gif_path"
    fi

    if [ -n "$COMPRESS_TARGET" ] && [ -n "$latest_file" ] && [ -f "$latest_file" ]; then
        local comp_path
        comp_path=$(compress_video "$latest_file" "$COMPRESS_TARGET")
        [ -n "$comp_path" ] && final_target="$comp_path"
    fi

    local title
    if [ -n "$CUSTOM_NAME" ]; then
        title="${CUSTOM_NAME%.*}"
    elif [ -n "$final_target" ] && [ -f "$final_target" ]; then
        title=$(basename "$final_target")
        title="${title%.*}"
    else
        title="Vídeo Concluído"
    fi
    log_history "$title" "$url" "$final_target" "VIDEO"

    local f_size=""
    local f_res=""
    if [ -n "$final_target" ] && [ -f "$final_target" ]; then
        f_size=$(du -h "$final_target" | cut -f1 2>/dev/null || echo "")
        if command -v ffprobe >/dev/null 2>&1; then
            f_res=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$final_target" 2>/dev/null || true)
            [ -n "$f_res" ] && f_res="${f_res}p"
        fi
    fi

    if [ "$is_batch" = false ]; then
        echo -e "\n${GREEN}${BOLD}┌──────────────────────────────────────────────────────────────┐${NC}"
        echo -e "${GREEN}${BOLD}│  ✅ DOWNLOAD CONCLUÍDO COM SUCESSO!                          │${NC}"
        echo -e "${GREEN}${BOLD}└──────────────────────────────────────────────────────────────┘${NC}"
        echo -e "  ${BLUE}📁 Arquivo :${NC} ${BOLD}$(basename "$final_target")${NC}"
        echo -e "  ${BLUE}📂 Destino :${NC} ${dest}"
        local details_str=""
        [ -n "$f_res" ] && details_str="${f_res}"
        [ -n "$f_size" ] && details_str="${details_str} | ${f_size}"
        [ -n "$details_str" ] && echo -e "  ${BLUE}📊 Detalhes:${NC} ${details_str}"
        echo ""
        notify_completion "$title" "$dest" "$final_target"
    fi
}

# ------------------------------------------------------------------------------
# MOTOR DE DOWNLOAD (ÁUDIO / YT-DLP)
# ------------------------------------------------------------------------------
download_audio() {
    local url="$1"
    local dest="$2"
    local clip_range="${3:-$CUSTOM_CLIP}"
    local is_batch="${4:-false}"
    local dl_args
    dl_args=$(get_downloader_args)

    mkdir -p "$dest"
    cd "$dest"

    local extra_flags=()
    [ -n "$clip_range" ] && extra_flags+=(--download-sections "*${clip_range}" --force-keyframes-at-cuts)
    [ "$SPLIT_CHAPTERS" = true ] && extra_flags+=(--split-chapters -o "chapter:%(title)s/%(section_number)02d - %(section_title)s.%(ext)s")
    if [ "$SYNC_PLAYLIST" = true ] || [ "$FORCE_PRIVATE" = true ] || [ "$is_batch" = true ]; then
        extra_flags+=(--download-archive "$dest/.download_archive.txt")
    fi
    [ -n "$COOKIES_BROWSER" ] && extra_flags+=(--cookies-from-browser "$COOKIES_BROWSER")
    [ "$SKIP_SPONSORS" = true ] && extra_flags+=(--sponsorblock-remove "sponsor,selfpromo,interaction,intro,outro")

    local output_tpl="%(title)s [%(id)s].%(ext)s"
    if [ -n "$CUSTOM_NAME" ]; then
        local base_custom="${CUSTOM_NAME%.*}"
        output_tpl="${base_custom}.%(ext)s"
    elif [[ "$url" =~ list= ]] && [ "$SPLIT_CHAPTERS" = false ]; then
        output_tpl="%(playlist_title,playlist)s/%(playlist_index)02d - %(title)s.%(ext)s"
    fi

    [ "$is_batch" = false ] && echo -e "${BLUE}⬇️ Extraindo áudio de alta fidelidade (MP3 320kbps)...${NC}"
    local dl_status=0
    eval yt-dlp \
        $dl_args \
        -x \
        --audio-format mp3 \
        --audio-quality 0 \
        --embed-thumbnail \
        --add-metadata \
        -o "'$output_tpl'" \
        --windows-filenames \
        --no-mtime \
        "${extra_flags[@]}" \
        "'$url'" || dl_status=$?

    # Fallback automático para Brave / Chrome cookies se falhar
    if [ "$dl_status" -ne 0 ] && [ -z "$COOKIES_BROWSER" ]; then
        echo -e "${YELLOW}⚠️ Download anônimo falhou ou requer autenticação. Tentando com cookies do Brave...${NC}"
        dl_status=0
        eval yt-dlp \
            $dl_args \
            --cookies-from-browser brave \
            -x \
            --audio-format mp3 \
            --audio-quality 0 \
            --embed-thumbnail \
            --add-metadata \
            -o "'$output_tpl'" \
            --windows-filenames \
            --no-mtime \
            "${extra_flags[@]}" \
            "'$url'" || dl_status=$?

        if [ "$dl_status" -ne 0 ]; then
            echo -e "${YELLOW}⚠️ Tentando alternativamente com cookies do Chrome...${NC}"
            dl_status=0
            eval yt-dlp \
                $dl_args \
                --cookies-from-browser chrome \
                -x \
                --audio-format mp3 \
                --audio-quality 0 \
                --embed-thumbnail \
                --add-metadata \
                -o "'$output_tpl'" \
                --windows-filenames \
                --no-mtime \
                "${extra_flags[@]}" \
                "'$url'" || dl_status=$?
        fi
    fi

    if [ "$dl_status" -ne 0 ]; then
        return 1
    fi

    local latest_file
    latest_file=$(find "$dest" -maxdepth 2 -type f \( -name "*.mp3" -o -name "*.flac" -o -name "*.m4a" \) -printf '%T@ %p\n' 2>/dev/null | sort -n | tail -1 | cut -f2- -d" ")
    local final_target="$latest_file"

    if [ -n "$STUDY_SPEED" ] && [ -n "$latest_file" ] && [ -f "$latest_file" ]; then
        local study_path
        study_path=$(apply_study_filters "$latest_file" "$STUDY_SPEED")
        [ -n "$study_path" ] && final_target="$study_path"
    fi

    local title
    if [ -n "$CUSTOM_NAME" ]; then
        title="${CUSTOM_NAME%.*}"
    elif [ -n "$final_target" ] && [ -f "$final_target" ]; then
        title=$(basename "$final_target")
        title="${title%.*}"
    else
        title="Áudio Concluído"
    fi
    log_history "$title" "$url" "$final_target" "AUDIO"

    if [ "$is_batch" = false ]; then
        local f_size=""
        [ -n "$final_target" ] && [ -f "$final_target" ] && f_size=$(du -h "$final_target" | cut -f1 2>/dev/null || echo "")
        echo -e "\n${GREEN}${BOLD}┌──────────────────────────────────────────────────────────────┐${NC}"
        echo -e "${GREEN}${BOLD}│  ✅ ÁUDIO MP3 EXTRAÍDO COM SUCESSO!                          │${NC}"
        echo -e "${GREEN}${BOLD}└──────────────────────────────────────────────────────────────┘${NC}"
        echo -e "  ${BLUE}🎵 Arquivo :${NC} ${BOLD}$(basename "$final_target")${NC}"
        echo -e "  ${BLUE}📂 Destino :${NC} ${dest}"
        [ -n "$f_size" ] && echo -e "  ${BLUE}📊 Tamanho :${NC} ${f_size}"
        echo ""
        notify_completion "$title" "$dest" "$final_target"
    fi
}

# ------------------------------------------------------------------------------
# MOTOR DE DOWNLOAD (SPOTIFY / SPOTDL)
# ------------------------------------------------------------------------------
download_spotify() {
    local url="$1"
    local format="${2:-mp3}"
    local dest="$3"
    local mode="${4:-cli}"

    mkdir -p "$dest"
    cd "$dest"

    local output_tpl="{artist} - {title}.{output-ext}"
    if [ -n "$CUSTOM_NAME" ]; then
        local base_custom="${CUSTOM_NAME%.*}"
        output_tpl="${base_custom}.{output-ext}"
    elif [[ "$url" =~ /album/ ]]; then
        output_tpl="{album}/{track-number} - {artist} - {title}.{output-ext}"
    elif [[ "$url" =~ /playlist/ ]]; then
        output_tpl="{playlist}/{track-number} - {artist} - {title}.{output-ext}"
    elif [[ "$url" =~ /artist/ ]]; then
        output_tpl="{artist}/{album}/{track-number} - {title}.{output-ext}"
    fi

    local bitrate_flag="--bitrate 320k"
    [ "$format" == "flac" ] && bitrate_flag="--bitrate disable"

    echo -e "${GREEN}🎵 Baixando do Spotify via spotDL (${format^^} + Capa + Letras .lrc)...${NC}"
    if [ "$mode" == "rofi" ]; then
        spotdl download "$url" \
            --format "$format" \
            $bitrate_flag \
            --audio youtube-music youtube soundcloud \
            --output "$output_tpl" \
            --sponsor-block \
            --generate-lrc >/dev/null 2>&1 || true
    else
        spotdl download "$url" \
            --format "$format" \
            $bitrate_flag \
            --audio youtube-music youtube soundcloud \
            --output "$output_tpl" \
            --sponsor-block \
            --simple-tui \
            --generate-lrc || true
    fi

    local latest_file
    latest_file=$(find "$dest" -maxdepth 2 -type f \( -name "*.mp3" -o -name "*.flac" -o -name "*.m4a" \) -printf '%T@ %p\n' 2>/dev/null | sort -n | tail -1 | cut -f2- -d" ")
    log_history "Spotify Download" "$url" "$latest_file" "SPOTIFY"
    notify_completion "Música/Álbum do Spotify Baixado" "$dest" "$latest_file"
}

# ------------------------------------------------------------------------------
# MOTOR DE DOWNLOAD DE GALERIAS DE FOTOS (GALLERY-DL)
# ------------------------------------------------------------------------------
download_gallery() {
    local url="$1"
    local dest="$2"

    mkdir -p "$dest"
    cd "$dest"

    if command -v gallery-dl >/dev/null 2>&1; then
        echo -e "${PEACH}📸 Baixando galeria de imagens em resolução máxima com gallery-dl...${NC}"
        gallery-dl --directory "$dest" "$url" || true
    else
        echo -e "${YELLOW}⚠️ gallery-dl não encontrado. Tentando baixar via yt-dlp...${NC}"
        yt-dlp --write-thumbnail --skip-download -o "$dest/%(title)s/%(playlist_index)02d.%(ext)s" "$url" || true
    fi

    local latest_file
    latest_file=$(find "$dest" -maxdepth 2 -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.webp" \) -printf '%T@ %p\n' 2>/dev/null | sort -n | tail -1 | cut -f2- -d" ")
    log_history "Galeria de Fotos" "$url" "$dest" "GALLERY"
    notify_completion "Galeria de Imagens Baixada" "$dest" "$latest_file"
}

# ------------------------------------------------------------------------------
# EXTRAÇÃO DE TRANSCRIÇÃO LIMPA PARA IA (MARKDOWN / LLMs)
# ------------------------------------------------------------------------------
download_transcript() {
    local url="$1"
    local dest="${2:-$DEFAULT_DEST_TRANSCRIPT}"
    [ -z "$dest" ] && dest="/mnt/dados/05_Midias_Design_e_Criacao/Videos/Transcrições"
    [ ! -d "/mnt/dados" ] && dest="$HOME/Videos/Transcrições"

    mkdir -p "$dest"

    echo -e "${MAUVE}🤖 Conectando e obtendo transcrição limpa para IA...${NC}"
    local title
    title=$(yt-dlp --get-title "$url" 2>/dev/null | head -n1 || echo "Transcricao")
    local uploader
    uploader=$(yt-dlp --print "%(uploader,channel)s" "$url" 2>/dev/null | head -n1 || echo "Canal")

    local tmp_dir
    tmp_dir=$(mktemp -d "/tmp/dl_trans_XXXXXX")
    local out_tpl="${tmp_dir}/sub.%(ext)s"

    # 1. Tentativa anônima com sub-formatos abrangentes
    yt-dlp \
        --skip-download \
        --write-auto-subs \
        --write-subs \
        --sub-lang "pt-orig,pt,pt-BR,pt-PT,en-orig,en,en-US,es" \
        --sub-format "vtt/srt/best" \
        -o "$out_tpl" \
        --no-warnings \
        --ignore-errors \
        "$url" >/dev/null 2>&1 || true

    # 2. Se nenhuma legenda foi baixada, tenta com cookies do Brave
    local sub_count
    sub_count=$(find "$tmp_dir" -type f \( -name "*.vtt" -o -name "*.srt" \) 2>/dev/null | wc -l)
    if [ "$sub_count" -eq 0 ]; then
        echo -e "${YELLOW}⚠️ Nenhuma legenda na tentativa inicial. Tentando com cookies do Brave...${NC}"
        yt-dlp \
            --cookies-from-browser brave \
            --skip-download \
            --write-auto-subs \
            --write-subs \
            --sub-lang "pt-orig,pt,pt-BR,pt-PT,en-orig,en,en-US,es" \
            --sub-format "vtt/srt/best" \
            -o "$out_tpl" \
            --no-warnings \
            --ignore-errors \
            "$url" >/dev/null 2>&1 || true
    fi

    # Seleciona o melhor arquivo de legenda baixado (priorizando pt-orig, pt, en)
    local best_sub=""
    for pattern in "*pt-orig*" "*pt-BR*" "*pt-PT*" "*pt*" "*en-orig*" "*en*" "*.vtt" "*.srt"; do
        best_sub=$(find "$tmp_dir" -type f -name "$pattern" 2>/dev/null | head -n1 || true)
        [ -n "$best_sub" ] && [ -f "$best_sub" ] && break
    done

    if [ -z "$best_sub" ] || [ ! -f "$best_sub" ]; then
        rm -rf "$tmp_dir"
        echo -e "${RED}❌ Nenhuma legenda ou transcrição disponível para esta mídia.${NC}"
        if command -v notify-send >/dev/null 2>&1; then
            notify-send -u critical "Transcrição Indisponível" "Não foram encontradas legendas (manuais ou automáticas) para esta mídia."
        fi
        return 1
    fi

    local clean_title
    if [ -n "$CUSTOM_NAME" ]; then
        clean_title="${CUSTOM_NAME%.*}"
    else
        clean_title=$(echo "$title" | sed 's/[/\\?%*:|"<>]/_/g')
    fi
    local md_output="${dest}/${clean_title} [Transcricao IA].md"
    local date_now
    date_now=$(date '+%Y-%m-%d %H:%M:%S')

    # Processamento e higienização profunda em Python (elimina timestamps, repetições e quebra em parágrafos)
    python3 -c '
import os, sys, re

sub_path = sys.argv[1]
title = sys.argv[2]
uploader = sys.argv[3]
url = sys.argv[4]
date_now = sys.argv[5]
md_out = sys.argv[6]

with open(sub_path, "r", encoding="utf-8", errors="replace") as f:
    content = f.read()

lines = content.splitlines()
clean_lines = []
for line in lines:
    line = line.strip()
    if not line or line.startswith("WEBVTT") or line.startswith("Kind:") or line.startswith("Language:"):
        continue
    if "-->" in line or line.startswith("NOTE") or line.isdigit():
        continue
    # Remove micro-timestamps do YouTube como <00:00:00.480><c>
    line = re.sub(r"<[^>]+>", "", line)
    line = re.sub(r"&nbsp;", " ", line)
    line = re.sub(r"&amp;", "&", line)
    line = re.sub(r"&quot;", "\"", line)
    line = re.sub(r"&#39;", "\x27", line)
    line = line.strip()
    if line:
        if not clean_lines or clean_lines[-1] != line:
            if clean_lines and (line.startswith(clean_lines[-1]) or clean_lines[-1].endswith(line)):
                clean_lines[-1] = line
            else:
                clean_lines.append(line)

text = " ".join(clean_lines)
words = text.split()
deduped = []
for w in words:
    if not deduped or w.lower() != deduped[-1].lower():
        deduped.append(w)

clean_text = " ".join(deduped)

# Agrupa em parágrafos elegantes a cada 3 a 5 frases
sentences = re.split(r"(\. |\? |\! )", clean_text)
paragraphs = []
curr = ""
count = 0
for i in range(0, len(sentences)-1, 2):
    s = sentences[i] + sentences[i+1]
    curr += s
    count += 1
    if count >= 4:
        paragraphs.append(curr.strip())
        curr = ""
        count = 0
if curr:
    paragraphs.append(curr.strip())
if not paragraphs:
    paragraphs = [clean_text]

body = "\n\n".join(paragraphs)

header = f"""# {title}

> **Fonte:** {url}  
> **Canal / Autor:** {uploader}  
> **Extraído em:** {date_now}  
> **Motor:** Media Downloader AI Suite (`dl -t`)

---

### 🤖 Prompt Executivo para IA (ChatGPT / Claude / Gemini / DeepSeek)
> *Copie e cole este bloco em qualquer modelo de IA para extrair valor imediato deste vídeo:*

```markdown
Você é um assistente sênior especialista em síntese, clareza e análise crítica.
Com base na transcrição fiel deste vídeo que envio abaixo, elabore:
1. 🎯 Resumo Executivo em 3 parágrafos claros, densos e objetivos.
2. 💡 Principais Lições e Insights Práticos em tópicos estruturados.
3. 💬 Frases e Citações Marcantes mais impactantes.
4. 📋 Plano de Ação Aplicável (o que fazer ou implementar na prática a partir deste conteúdo).
```

---

## 📝 Transcrição Completa Formatada

"""

with open(md_out, "w", encoding="utf-8") as f:
    f.write(header + body + "\n")

# Salva arquivo de texto puro (.txt) apenas com os paragrafos limpos
txt_out = md_out.rsplit(".", 1)[0] + ".txt"
with open(txt_out, "w", encoding="utf-8") as f:
    f.write(body + "\n")
' "$best_sub" "$title" "$uploader" "$url" "$date_now" "$md_output"

    local txt_output="${md_output%.*}.txt"
    if [ -f "$txt_output" ]; then
        if command -v wl-copy >/dev/null 2>&1; then
            cat "$txt_output" | wl-copy
        elif command -v xclip >/dev/null 2>&1; then
            cat "$txt_output" | xclip -selection clipboard
        fi
    fi

    rm -rf "$tmp_dir"

    echo -e "\n${GREEN}${BOLD}┌──────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${GREEN}${BOLD}│  ✅ TRANSCRIÇÃO LIMPA EXTRAÍDA COM SUCESSO!                  │${NC}"
    echo -e "${GREEN}${BOLD}└──────────────────────────────────────────────────────────────┘${NC}"
    echo -e "  ${BLUE}🎬 Título  :${NC} ${BOLD}${title}${NC}"
    echo -e "  ${BLUE}👤 Canal   :${NC} ${uploader}"
    echo -e "  ${BLUE}📄 Arquivo :${NC} ${md_output}"
    echo -e "  ${PEACH}📋 STATUS  : Copiada para o Clipboard (pronto para colar na IA)${NC}\n"

    # Exibe preview dos primeiros 400 caracteres
    if [ -f "$md_output" ]; then
        echo -e "${SUBTEXT}Prévia da transcrição limpa:${NC}"
        echo -e "${TEXT}$(tail -n +10 "$md_output" | head -n 8)${NC}"
        echo -e "${SUBTEXT}... (continua no arquivo e na área de transferência)${NC}\n"
    fi

    log_history "$title [Transcricao IA]" "$url" "$md_output" "TRANSCRIPT"
    notify_completion "$title [Transcrição IA]" "$dest" "$md_output"
}

# ------------------------------------------------------------------------------
# MOTOR DE STREAMING (FILMES & SÉRIES POMFY / HLS DECRYPTION SUITE)
# ------------------------------------------------------------------------------
download_streaming_pomfy() {
    local target="$1"
    local season_req="$2"
    local ep_req="$3"
    local dest_base="$CUSTOM_DIR"

    local script_extractor="/home/lan/dotfiles/scripts/stream-extractor/pomfy-extractor.js"
    if [ ! -f "$script_extractor" ]; then
        echo -e "${RED}❌ Extrator Pomfy não encontrado em $script_extractor${NC}"
        return 1
    fi

    local dest_series="${DEFAULT_DEST_SERIES:-/mnt/dados/05_Midias_Design_e_Criacao/Videos/Séries}"
    local dest_movies="${DEFAULT_DEST_MOVIES:-/mnt/dados/05_Midias_Design_e_Criacao/Videos/Filmes}"
    [ ! -d "/mnt/dados" ] && dest_series="$HOME/Videos/Séries"
    [ ! -d "/mnt/dados" ] && dest_movies="$HOME/Videos/Filmes"

    echo -e "${MAUVE}${BOLD}╭───────────────────────────────────────────────────────────────╮${NC}"
    echo -e "${MAUVE}${BOLD}│       🎬 POMFY STREAMING & HLS EXTRACTOR (APEX V2)            │${NC}"
    echo -e "${MAUVE}${BOLD}╰───────────────────────────────────────────────────────────────╯${NC}"
    echo ""

    # Seletor interativo de faixa de áudio se não especificado na CLI
    if [ "$STREAM_AUDIO_LANG_SET" = false ] && [ -t 0 ]; then
        echo -e "${BOLD}Escolha a Faixa de Áudio:${NC}"
        echo -e "  ${GREEN}[1]${NC} 🇧🇷 Dublado (Português)"
        echo -e "  ${BLUE}[2]${NC} 🇺🇸 Áudio Original (Inglês)"
        echo -e "  ${YELLOW}[3]${NC} 💎 Dual Áudio (Português Dublado + Inglês Original simultâneos)"
        read -rp "Opção [1-3, padrão: 1]: " aud_opt
        case "$aud_opt" in
            2) STREAM_AUDIO_LANG="en" ;;
            3) STREAM_AUDIO_LANG="dual" ;;
            *) STREAM_AUDIO_LANG="pt" ;;
        esac
        echo ""
    fi

    local ytdlp_audio_args=()
    local audio_label=""
    case "${STREAM_AUDIO_LANG,,}" in
        dual|ambos|2)
            audio_label="${YELLOW}Dual Áudio (Português + Inglês)${NC}"
            ytdlp_audio_args=(
                --audio-multistreams
                -f "bv*+ba[language=pt]+ba[language=en]/bv*+ba[language=por]+ba[language=eng]/bv*+ba[language=pt]/bv*+ba[language=en]/bv*+ba/b"
            )
            ;;
        en|original|ingles|inglês)
            audio_label="${BLUE}Áudio Original (Inglês)${NC}"
            ytdlp_audio_args=(
                -f "bv*+ba[language=en]/bv*+ba[language=eng]/bv*+ba/b"
            )
            ;;
        pt|dublado|portugues|português|*)
            audio_label="${GREEN}Dublado (Português)${NC}"
            ytdlp_audio_args=(
                -f "bv*+ba[language=pt]/bv*+ba[language=por]/bv*+ba/b"
            )
            ;;
    esac

    # 1. Verifica se o alvo é uma página de série completa
    local is_serie_root=false
    if [[ "$target" =~ /serie/([0-9]+) ]] && [[ ! "$target" =~ temporada= ]]; then
        is_serie_root=true
    fi

    if [ "$is_serie_root" = true ]; then
        echo -e "${BLUE}🔍 Obtendo metadados oficiais da série...${NC}"
        local metadata
        metadata=$(node "$script_extractor" info "$target" 2>/dev/null || true)

        if [ -z "$metadata" ] || ! echo "$metadata" | jq -e '.title' >/dev/null 2>&1; then
            echo -e "${RED}❌ Não foi possível carregar os metadados da série.${NC}"
            return 1
        fi

        local serie_id serie_title serie_year
        serie_id=$(echo "$metadata" | jq -r '.id')
        serie_title=$(echo "$metadata" | jq -r '.title')
        serie_year=$(echo "$metadata" | jq -r '.year // empty')

        if [ -n "$serie_year" ]; then
            echo -e "${GREEN}📺 Série:${NC} ${BOLD}${serie_title} (${serie_year})${NC}"
        else
            echo -e "${GREEN}📺 Série:${NC} ${BOLD}${serie_title}${NC}"
        fi
        echo -e "${SUBTEXT}Temporadas disponíveis:${NC}"

        echo "$metadata" | jq -r '.availableSeasons[]' | while read -r s; do
            local ep_count
            ep_count=$(echo "$metadata" | jq -r ".episodeCountMap[\"$s\"] // 0")
            echo -e "   ${MAUVE}• Temporada ${s}:${NC} ${ep_count} episódios"
        done
        echo ""

        # Pergunta temporada se não informada
        local chosen_season="$season_req"
        if [ -z "$chosen_season" ]; then
            read -rp "Qual temporada deseja baixar? [Ex: 1, 2 ou 'todas', padrão: 1]: " chosen_season
            chosen_season="${chosen_season:-1}"
        fi

        # Pergunta episódios se não informado
        local chosen_eps="$ep_req"
        if [ -z "$chosen_eps" ] && [ "$chosen_season" != "todas" ] && [ "$chosen_season" != "all" ]; then
            local max_eps
            max_eps=$(echo "$metadata" | jq -r ".episodeCountMap[\"$chosen_season\"] // 1")
            read -rp "Quais episódios da T${chosen_season}? [Ex: 1-${max_eps}, 1, ou 'todos', padrão: todos]: " chosen_eps
            chosen_eps="${chosen_eps:-todos}"
        fi

        # Monta lista de temporadas a baixar
        local seasons_to_download=()
        if [ "$chosen_season" == "todas" ] || [ "$chosen_season" == "all" ]; then
            while IFS= read -r s; do
                seasons_to_download+=("$s")
            done < <(echo "$metadata" | jq -r '.availableSeasons[]')
        else
            seasons_to_download+=("$chosen_season")
        fi

        for s in "${seasons_to_download[@]}"; do
            local total_in_season
            total_in_season=$(echo "$metadata" | jq -r ".episodeCountMap[\"$s\"] // 1")

            local eps_to_download=()
            if [ -z "$chosen_eps" ] || [ "$chosen_eps" == "todos" ] || [ "$chosen_eps" == "all" ]; then
                for ((e=1; e<=total_in_season; e++)); do
                    eps_to_download+=("$e")
                done
            elif [[ "$chosen_eps" =~ ^([0-9]+)-([0-9]+)$ ]]; then
                local start_ep="${BASH_REMATCH[1]}"
                local end_ep="${BASH_REMATCH[2]}"
                for ((e=start_ep; e<=end_ep; e++)); do
                    eps_to_download+=("$e")
                done
            else
                IFS=',' read -ra ADDR <<< "$chosen_eps"
                for i in "${ADDR[@]}"; do
                    eps_to_download+=("$(echo "$i" | tr -d ' ')")
                done
            fi

            local s_padded
            s_padded=$(printf "%02d" "$s")
            local target_dest_folder="${dest_base:-$dest_series/$serie_title/Temporada $s_padded}"
            mkdir -p "$target_dest_folder"

            local total_queue=${#eps_to_download[@]}
            local current_idx=0
            local downloaded_count=0
            local skipped_count=0
            local failed_count=0

            echo -e "\n${BOLD}${BLUE}📦 Fila Preparada: Temporada ${s} (${total_queue} episódios)${NC}"
            echo -e "${SUBTEXT}Áudio : ${audio_label}${NC}"
            echo -e "${SUBTEXT}Destino: ${target_dest_folder}${NC}\n"

            for ep in "${eps_to_download[@]}"; do
                ((current_idx++))
                local pct=$(( current_idx * 100 / total_queue ))
                local ep_padded
                ep_padded=$(printf "%02d" "$ep")
                local expected_file="$target_dest_folder/${serie_title} - S${s_padded}E${ep_padded}.mp4"

                echo -e "${MAUVE}┌───────────────────────────────────────────────────────────────┐${NC}"
                echo -e "${MAUVE}│${NC} 📦 ${BOLD}Fila: [${current_idx}/${total_queue}] (${pct}% da temporada)${NC}"
                echo -e "${MAUVE}│${NC} 📺 Série: ${BOLD}${serie_title}${NC} • S${s_padded}E${ep_padded}"
                echo -e "${MAUVE}│${NC} 🔊 Áudio: ${audio_label}"
                echo -e "${MAUVE}└───────────────────────────────────────────────────────────────┘${NC}"

                if [ -f "$expected_file" ]; then
                    echo -e "${YELLOW}⏩ [JÁ EXISTE]${NC} ${serie_title} - S${s_padded}E${ep_padded}.mp4 (pulando)\n"
                    ((skipped_count++))
                    continue
                fi

                echo -e "${TEAL}⏳ Extraindo link do stream S${s_padded}E${ep_padded} (bypass PoW Captcha)...${NC}"
                local stream_json
                stream_json=$(node "$script_extractor" stream --id "$serie_id" --season "$s" --ep "$ep" 2>/dev/null || true)

                if [ -z "$stream_json" ] || ! echo "$stream_json" | jq -e '.streamUrl' >/dev/null 2>&1; then
                    echo -e "${RED}❌ [FALHA] Não foi possível extrair o stream de S${s_padded}E${ep_padded}.${NC}\n"
                    ((failed_count++))
                    continue
                fi

                local stream_url stream_ref stream_file
                stream_url=$(echo "$stream_json" | jq -r '.streamUrl')
                stream_ref=$(echo "$stream_json" | jq -r '.referer // "https://f7hyg4q.org/"')
                stream_file=$(echo "$stream_json" | jq -r '.fileName')

                echo -e "${GREEN}🚀 Baixando S${s_padded}E${ep_padded} em 1080p Full HD...${NC}"

                if yt-dlp \
                    --no-warnings \
                    -N 16 \
                    --concurrent-fragments 16 \
                    --buffer-size 16M \
                    --http-chunk-size 10M \
                    --retries 10 \
                    --fragment-retries 10 \
                    --referer "$stream_ref" \
                    "${ytdlp_audio_args[@]}" \
                    --merge-output-format mp4 \
                    --remux-video mp4 \
                    -o "$target_dest_folder/$stream_file" \
                    "$stream_url"; then
                    ((downloaded_count++))
                    log_history "${serie_title} S${s_padded}E${ep_padded}" "$target" "$target_dest_folder/$stream_file" "STREAMING"
                    echo -e "${GREEN}✔ Concluído: S${s_padded}E${ep_padded}${NC}\n"
                else
                    echo -e "${RED}❌ Erro no download de S${s_padded}E${ep_padded}${NC}\n"
                    ((failed_count++))
                fi
            done

            echo -e "${GREEN}${BOLD}╭───────────────────────────────────────────────────────────────╮${NC}"
            echo -e "${GREEN}${BOLD}│       🎉 RESUMO DO LOTE DA TEMPORADA ${s}                        │${NC}"
            echo -e "${GREEN}${BOLD}├───────────────────────────────────────────────────────────────┤${NC}"
            echo -e "${GREEN}${BOLD}│${NC}  ✔️ Baixados com sucesso : ${BOLD}${downloaded_count}${NC}"
            echo -e "${GREEN}${BOLD}│${NC}  ⏩ Já existentes (pulados): ${YELLOW}${skipped_count}${NC}"
            echo -e "${GREEN}${BOLD}│${NC}  ❌ Falhas               : ${RED}${failed_count}${NC}"
            echo -e "${GREEN}${BOLD}│${NC}  📁 Pasta de destino     : ${SUBTEXT}${target_dest_folder}${NC}"
            echo -e "${GREEN}${BOLD}╰───────────────────────────────────────────────────────────────╯${NC}\n"
        done

        notify_completion "Série ${serie_title} Concluída" "${dest_base:-$dest_series/$serie_title}"
        return 0
    fi

    # 2. Caso seja um episódio único ou filme
    echo -e "${TEAL}⏳ Conectando e descriptografando stream (bypass PoW Captcha)...${NC}"
    local stream_json
    stream_json=$(node "$script_extractor" stream "$target" 2>/dev/null || true)

    if [ -z "$stream_json" ] || ! echo "$stream_json" | jq -e '.streamUrl' >/dev/null 2>&1; then
        echo -e "${RED}❌ Não foi possível extrair o stream do link fornecido.${NC}"
        local err_msg
        err_msg=$(echo "$stream_json" | jq -r '.message // "Erro desconhecido"')
        echo -e "${SUBTEXT}Detalhes: ${err_msg}${NC}"
        return 1
    fi

    local stream_url stream_ref stream_file item_type item_title item_season
    stream_url=$(echo "$stream_json" | jq -r '.streamUrl')
    stream_ref=$(echo "$stream_json" | jq -r '.referer // "https://f7hyg4q.org/"')
    stream_file=$(echo "$stream_json" | jq -r '.fileName')
    item_type=$(echo "$stream_json" | jq -r '.type')
    item_title=$(echo "$stream_json" | jq -r '.title')
    item_season=$(echo "$stream_json" | jq -r '.season // empty')

    local final_dest_dir="$dest_base"
    if [ -z "$final_dest_dir" ]; then
        if [ "$item_type" == "serie" ]; then
            local s_pad
            s_pad=$(printf "%02d" "${item_season:-1}")
            final_dest_dir="$dest_series/$item_title/Temporada $s_pad"
        else
            final_dest_dir="$dest_movies"
        fi
    fi
    mkdir -p "$final_dest_dir"

    if [ -n "$CUSTOM_NAME" ]; then
        stream_file="${CUSTOM_NAME%.*}.mp4"
    fi

    local clip_flags=()
    if [ -n "$CUSTOM_CLIP" ]; then
        clip_flags+=(--download-sections "*${CUSTOM_CLIP}" --force-keyframes-at-cuts)
    fi

    echo -e "${GREEN}🎬 Título:${NC} ${BOLD}${stream_file}${NC}"
    echo -e "${BLUE}📂 Pasta de Destino:${NC} ${final_dest_dir}"
    echo -e "${PEACH}🔊 Faixa de Áudio:${NC} ${audio_label}"
    echo -e "${GREEN}🚀 Baixando em 1080p com aceleração multi-thread (16 threads)...${NC}\n"

    yt-dlp \
        --no-warnings \
        -N 16 \
        --concurrent-fragments 16 \
        --buffer-size 16M \
        --http-chunk-size 10M \
        --retries 10 \
        --fragment-retries 10 \
        --referer "$stream_ref" \
        "${ytdlp_audio_args[@]}" \
        --merge-output-format mp4 \
        --remux-video mp4 \
        "${clip_flags[@]}" \
        -o "$final_dest_dir/$stream_file" \
        "$stream_url"

    log_history "$item_title" "$target" "$final_dest_dir/$stream_file" "STREAMING"
    notify_completion "$item_title Baixado" "$final_dest_dir" "$final_dest_dir/$stream_file"
}


# ------------------------------------------------------------------------------
# ATUALIZADOR DOS MOTORES DE DOWNLOAD (YT-DLP + SPOTDL + GALLERY-DL)
# ------------------------------------------------------------------------------
update_engines() {
    echo -e "${MAUVE}${BOLD}╭───────────────────────────────────────────────────────────────╮${NC}"
    echo -e "${MAUVE}${BOLD}│       🚀 ATUALIZADOR DE MOTORES DE MÍDIA (dl --update)        │${NC}"
    echo -e "${MAUVE}${BOLD}╰───────────────────────────────────────────────────────────────╯${NC}"
    echo ""

    echo -e "${BLUE}1. Verificando motor de vídeo (yt-dlp)...${NC}"
    local ytdlp_out
    ytdlp_out=$(yt-dlp -U 2>&1 || true)
    if echo "$ytdlp_out" | grep -qi "Installed with"; then
        echo -e "${PEACH}ℹ️ yt-dlp é gerenciado pelo Arch Linux (pacman/yay).${NC}"
        if command -v yay >/dev/null 2>&1; then
            echo -e "${SUBTEXT}Sincronizando via yay...${NC}"
            yay -S --needed yt-dlp || true
        fi
    else
        echo "$ytdlp_out"
    fi
    local ytdlp_ver
    ytdlp_ver=$(yt-dlp --version 2>/dev/null || echo "N/A")
    echo -e "${GREEN}✔ yt-dlp versão ativa:${NC} $ytdlp_ver"
    echo ""

    echo -e "${BLUE}2. Verificando motor de música (spotdl)...${NC}"
    if command -v pipx >/dev/null 2>&1 && pipx list 2>/dev/null | grep -q "package spotdl"; then
        pipx upgrade spotdl || true
    elif command -v pip >/dev/null 2>&1; then
        pip install --upgrade spotdl 2>/dev/null || true
    elif command -v yay >/dev/null 2>&1; then
        yay -S --needed spotdl 2>/dev/null || true
    fi
    local spotdl_ver
    spotdl_ver=$(spotdl --version 2>/dev/null || echo "N/A")
    echo -e "${GREEN}✔ spotdl versão ativa:${NC} $spotdl_ver"
    echo ""

    echo -e "${BLUE}3. Verificando motor de galerias (gallery-dl)...${NC}"
    if command -v gallery-dl >/dev/null 2>&1; then
        gallery-dl --update 2>/dev/null || true
        local gdl_ver
        gdl_ver=$(gallery-dl --version 2>/dev/null || echo "N/A")
        echo -e "${GREEN}✔ gallery-dl versão ativa:${NC} $gdl_ver"
    else
        echo -e "${SUBTEXT}gallery-dl não instalado (opcional).${NC}"
    fi
    echo ""

    echo -e "${GREEN}${BOLD}✔ Todos os motores foram verificados e sincronizados!${NC}"
}

# ------------------------------------------------------------------------------
# VISUALIZADOR DE HISTÓRICO (FZF / ROFI)
# ------------------------------------------------------------------------------
view_history() {
    local mode="${1:-cli}"
    if [ ! -f "$HISTORY_FILE" ] || [ ! -s "$HISTORY_FILE" ]; then
        if [ "$mode" == "rofi" ]; then
            notify-send "Histórico Vazio" "Nenhum download registrado ainda."
        else
            echo -e "${YELLOW}Nenhum download no histórico ainda.${NC}"
        fi
        return 0
    fi

    if [ "$mode" == "rofi" ]; then
        local sel
        sel=$(tac "$HISTORY_FILE" | awk -F'\t' '{print $1 " | [" $2 "] " $3 " -> " $5}' | rofi -dmenu -i -p "Histórico de Downloads" -l 15 || true)
        if [ -n "$sel" ]; then
            local file_path
            file_path=$(echo "$sel" | awk -F' -> ' '{print $2}')
            if [ -n "$file_path" ] && [ -e "$file_path" ]; then
                xdg-open "$file_path" &
            fi
        fi
    else
        if command -v fzf >/dev/null 2>&1; then
            local sel
            sel=$(tac "$HISTORY_FILE" | fzf --delimiter='\t' --with-nth=1,2,3 \
                --preview='echo -e "Data: {1}\nTipo: {2}\nTítulo: {3}\nURL: {4}\nArquivo: {5}"' \
                --header="ENTER: Abrir Mídia | CTRL-Y: Copiar Caminho | CTRL-O: Abrir Pasta" \
                --bind="ctrl-y:execute-silent(echo -n {5} | wl-copy || echo -n {5} | xclip -selection clipboard)+abort" \
                --bind="ctrl-o:execute(xdg-open \$(dirname {5}))+abort" || true)

            if [ -n "$sel" ]; then
                local file_path
                file_path=$(echo "$sel" | cut -f5)
                if [ -n "$file_path" ] && [ -e "$file_path" ]; then
                    xdg-open "$file_path" &
                fi
            fi
        else
            echo -e "${BOLD}Últimos 15 downloads:${NC}"
            tail -n 15 "$HISTORY_FILE" | awk -F'\t' '{printf "%s | %-8s | %s\n", $1, $2, $3}'
        fi
    fi
}

# ------------------------------------------------------------------------------
# MODO ROFI (SUPER + ALT + D OU MENU INTERATIVO)
# ------------------------------------------------------------------------------
run_rofi_mode() {
    local url=""
    local clip_url
    clip_url=$(get_clipboard_url)

    local now_option="🎧 Baixar o que está Tocando Agora (MPRIS / Spotify)"
    local hist_option="📜 Ver Histórico de Downloads"
    local clip_option="📋 Colar URL do Clipboard ($clip_url)"
    local manual_option="✏️ Digitar URL Manualmente"

    local first_choice
    first_choice=$(printf "%s\n%s\n%s\n%s" "$now_option" "$clip_option" "$manual_option" "$hist_option" | rofi -dmenu -i -p "Media Downloader" -l 4 || true)

    case "$first_choice" in
        *"Tocando Agora"*)
            local now_url
            now_url=$(get_now_playing_info || true)
            if [ -z "$now_url" ]; then
                notify-send -u low "Nenhuma Mídia Ativa" "Não foi detectada nenhuma música ou vídeo tocando no momento."
                exit 0
            fi
            url="$now_url"
            ;;
        *"Histórico"*)
            view_history "rofi"
            exit 0
            ;;
        *"Clipboard"*)
            url="$clip_url"
            ;;
        *"Manualmente"*)
            url=$(rofi -dmenu -p "Cole a URL" -theme-str 'entry { placeholder: "https://..."; }' </dev/null || true)
            ;;
        *)
            exit 0
            ;;
    esac

    if [ -z "$url" ]; then
        exit 0
    fi

    local dest_v="${CUSTOM_DIR:-$DEFAULT_DEST_VIDEO}"
    local dest_a="${CUSTOM_DIR:-$DEFAULT_DEST_AUDIO}"
    local dest_i="${CUSTOM_DIR:-$DEFAULT_DEST_IMAGE}"

    if is_sensitive_domain "$url" || [ "$FORCE_PRIVATE" = true ]; then
        dest_v="$DEFAULT_DEST_PRIVATE/Videos_e_Cenas"
        dest_a="$DEFAULT_DEST_PRIVATE/Audios"
        dest_i="$DEFAULT_DEST_PRIVATE/Imagens"
        mkdir -p "$dest_v" "$dest_a" "$dest_i"
    fi

    if [[ "$url" =~ (open\.spotify\.com|spotify:) ]]; then
        local sp_choice
        sp_choice=$(printf "🎵 MP3 320kbps (Capa + Tags + Letras)\n💎 FLAC Lossless (Qualidade Máxima)\n⚡ M4A AAC (Stream Rápido)" | rofi -dmenu -i -p "Formato Spotify" -l 3 || true)
        case "$sp_choice" in
            *"MP3"*) download_spotify "$url" "mp3" "$dest_a" "rofi" ;;
            *"FLAC"*) download_spotify "$url" "flac" "$dest_a" "rofi" ;;
            *"M4A"*) download_spotify "$url" "m4a" "$dest_a" "rofi" ;;
        esac
        exit 0
    fi

    if is_pomfy_domain "$url"; then
        download_streaming_pomfy "$url" "$SEASON_ARG" "$EP_ARG"
        exit 0
    fi

    local choice
    choice=$(printf "🎥 Vídeo Completo (1080p/4K MP4)\n🎵 Áudio MP3 (320kbps + Capa & Tags)\n⚡ Vídeo Leve (720p Rápido)\n✂️ Cortar Trecho de Vídeo (Clip)\n🗜️ Comprimir para Discord / WhatsApp (<10MB)\n🎞️ Gerar GIF Animado\n🤖 Transcrição Limpa para IA (.md)\n📸 Galeria de Fotos / Imagens\n📝 Baixar Apenas Legendas (.srt)\n🖼️ Baixar Apenas Capa / Thumbnail" | rofi -dmenu -i -p "Escolha o Formato" -l 10 || true)

    case "$choice" in
        *"Vídeo Completo"*)
            download_video "$url" "best" "$dest_v"
            ;;
        *"Áudio MP3"*)
            download_audio "$url" "$dest_a"
            ;;
        *"Vídeo Leve"*)
            download_video "$url" "720" "$dest_v"
            ;;
        *"Cortar Trecho"*)
            local clip_time
            clip_time=$(rofi -dmenu -p "Minutagem (ex: 01:20-02:40)" -theme-str 'entry { placeholder: "MM:SS-MM:SS"; }' </dev/null || true)
            if [ -n "$clip_time" ]; then
                download_video "$url" "best" "$dest_v" "$clip_time"
            fi
            ;;
        *"Comprimir"*)
            COMPRESS_TARGET="10"
            download_video "$url" "720" "$dest_v"
            ;;
        *"GIF Animado"*)
            local clip_time
            clip_time=$(rofi -dmenu -p "Minutagem do GIF (ex: 00:05-00:15)" -theme-str 'entry { placeholder: "MM:SS-MM:SS"; }' </dev/null || true)
            MAKE_GIF=true
            download_video "$url" "720" "$dest_v" "$clip_time"
            ;;
        *"Transcrição"*)
            download_transcript "$url" "$dest_v"
            ;;
        *"Galeria de Fotos"*)
            download_gallery "$url" "$dest_i"
            ;;
        *"Apenas Legendas"*)
            SUB_ONLY=true
            download_video "$url" "best" "$dest_v"
            ;;
        *"Apenas Capa"*)
            THUMB_ONLY=true
            download_video "$url" "best" "$dest_i"
            ;;
    esac
}

# ------------------------------------------------------------------------------
# MODO INTERATIVO DE TERMINAL (CLI COMPLETO COM BANNER E MENUS)
# ------------------------------------------------------------------------------
run_cli_mode() {
    local url="$1"
    local dest_v="${CUSTOM_DIR:-$DEFAULT_DEST_VIDEO}"
    local dest_a="${CUSTOM_DIR:-$DEFAULT_DEST_AUDIO}"
    local dest_i="${CUSTOM_DIR:-$DEFAULT_DEST_IMAGE}"

    clear
    echo -e "${MAUVE}${BOLD}╭───────────────────────────────────────────────────────────────╮${NC}"
    echo -e "${MAUVE}${BOLD}│   🎬 APEX MEDIA COCKPIT • Universal Stream & Video Suite      │${NC}"
    echo -e "${SUBTEXT}│   yt-dlp • spotdl • gallery-dl • pomfy • aria2c • fzf         │${NC}"
    echo -e "${MAUVE}${BOLD}╰───────────────────────────────────────────────────────────────╯${NC}"
    echo ""

    if [ -z "$url" ]; then
        local clip_url
        clip_url=$(get_clipboard_url)
        if [ -n "$clip_url" ]; then
            echo -e "${BLUE}📋 URL detectada na Área de Transferência:${NC}"
            echo -e "   ${TEXT}${clip_url}${NC}"
            echo ""
            read -rp "Pressione [Enter] para usar esta URL ou digite outra (ou 'p' para Pomfy): " input_url
            url="${input_url:-$clip_url}"
        elif command -v fzf >/dev/null 2>&1 && [ -t 0 ]; then
            local main_actions="1\t🍿 Pesquisar Filmes & Séries no Catálogo Pomfy\tAbre o navegador de filmes e séries com sinopse oficial, notas TMDB e download 1080p.\n2\t🔍 Pesquisar Vídeos no YouTube (FZF)\tBusca vídeos diretamente pelo terminal com seletor interativo.\n3\t🔗 Inserir URL ou Arquivo de Lote (.txt / .md)\tDigita ou cola link da web ou caminho de arquivo com links (.txt, .md).\n4\t🎵 Baixar o que está tocando agora (MPRIS / Spotify)\tDetecta a música ou vídeo em reprodução no seu sistema e baixa na hora.\n5\t📂 Ver Histórico de Downloads\tAbre a lista de downloads anteriores pesquisável com FZF.\n6\t🔄 Atualizar Motores de Download\tVerifica e atualiza o yt-dlp, spotdl e gallery-dl.\n7\t🚪 Sair\tFecha o cockpit de mídia."

            local chosen_action
            chosen_action=$(echo -e "$main_actions" | fzf \
                --prompt="🚀 O que deseja fazer? > " \
                --header="[ENTER] Selecionar • [Ctrl+J/K] Navegar • [ESC] Sair" \
                --height=50% \
                --layout=reverse \
                --border=rounded \
                --color=header:italic,spinner:#f5e0dc,hl:#f38ba8 \
                --color=fg:#cdd6f4,header:#cba6f7,info:#cba6f7,pointer:#f5e0dc \
                --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
                --bind="ctrl-j:down,ctrl-k:up" \
                --with-nth=2 \
                --delimiter="\t" \
                --preview='echo -e "\n\033[1;38;2;203;166;247m╭────────────────────────────────────────╮\033[0m\n\033[1;38;2;203;166;247m│ {2}\033[0m\n\033[1;38;2;203;166;247m╰────────────────────────────────────────╯\033[0m\n\n\033[38;2;205;214;244m{3}\033[0m"' \
                --preview-window="right:45%:wrap:border-rounded")

            local act_num
            act_num=$(echo "$chosen_action" | cut -f1)

            case "$act_num" in
                1)
                    local found_pomfy
                    found_pomfy=$(search_pomfy_fzf "")
                    if [ -n "$found_pomfy" ]; then
                        download_streaming_pomfy "$found_pomfy" "$SEASON_ARG" "$EP_ARG"
                        exit 0
                    fi
                    exit 0
                    ;;
                2)
                    read -rp "🔍 Digite o que deseja buscar no YouTube: " yt_query
                    if [ -n "$yt_query" ]; then
                        local found_yt
                        found_yt=$(search_youtube_fzf "$yt_query")
                        [ -n "$found_yt" ] && url="$found_yt"
                    else
                        exit 0
                    fi
                    ;;
                3)
                    read -rp "Cole a URL ou caminho do arquivo (.txt/.md): " url
                    ;;
                4)
                    local now_url
                    now_url=$(get_now_playing_info || true)
                    if [ -n "$now_url" ]; then
                        url="$now_url"
                    else
                        echo -e "${RED}❌ Nenhuma mídia ativa encontrada no playerctl.${NC}"
                        exit 1
                    fi
                    ;;
                5)
                    view_history "cli"
                    exit 0
                    ;;
                6)
                    update_engines
                    exit 0
                    ;;
                *)
                    exit 0
                    ;;
            esac
        else
            echo -e "${PEACH}Cole ou digite a URL (ou 'p' para pesquisar no Pomfy):${NC}"
            read -rp "URL ou Busca: " url
        fi
    fi

    if [ -z "$url" ]; then
        echo -e "\n${RED}❌ Nenhuma URL fornecida.${NC}"
        exit 1
    fi

    url="${url/#\~/$HOME}"
    local batch_file_candidate="$url"
    if [ ! -f "$batch_file_candidate" ] && [ -f "$DEFAULT_DEST_PRIVATE/$batch_file_candidate" ]; then
        batch_file_candidate="$DEFAULT_DEST_PRIVATE/$batch_file_candidate"
    fi
    if [ -f "$batch_file_candidate" ]; then
        download_batch "$batch_file_candidate" "$dest_v" "video"
        exit 0
    fi

    if [ "$url" == "p" ] || [ "$url" == "pomfy" ] || [ "$url" == "filme" ] || [ "$url" == "serie" ]; then
        local found_pomfy
        found_pomfy=$(search_pomfy_fzf "")
        if [ -n "$found_pomfy" ]; then
            download_streaming_pomfy "$found_pomfy" "$SEASON_ARG" "$EP_ARG"
            exit 0
        fi
        exit 0
    fi

    # Roteamento seguro se for site sensível ou privado
    if is_sensitive_domain "$url" || [ "$FORCE_PRIVATE" = true ]; then
        echo -e "${PEACH}🔒 Modo Furtivo Ativado: Salvando diretamente em .privado...${NC}"
        dest_v="$DEFAULT_DEST_PRIVATE/Videos_e_Cenas"
        dest_a="$DEFAULT_DEST_PRIVATE/Audios"
        dest_i="$DEFAULT_DEST_PRIVATE/Imagens"
        mkdir -p "$dest_v" "$dest_a" "$dest_i"
    fi

    # Roteamento especial para links do Spotify
    if [[ "$url" =~ (open\.spotify\.com|spotify:) ]]; then
        echo -e "${GREEN}${BOLD}🎧 Link do Spotify Detectado!${NC}"
        echo -e "${SUBTEXT}O spotDL vai extrair metadados oficiais, capa em alta resolução e letras sincronizadas (.lrc).${NC}"
        echo ""

        if ! command -v spotdl >/dev/null 2>&1; then
            echo -e "${PEACH}⚠️ 'spotdl' não está instalado no sistema.${NC}"
            echo -e "O spotdl é o motor que baixa músicas, álbuns e playlists do Spotify com capas e tags em 320kbps."
            echo ""
            read -rp "Deseja instalar agora via yay (AUR)? [s/N]: " inst_opt
            if [[ "$inst_opt" =~ ^[sSyY] ]]; then
                if command -v yay >/dev/null 2>&1; then
                    yay -S --needed spotdl
                elif command -v paru >/dev/null 2>&1; then
                    paru -S --needed spotdl
                elif command -v pipx >/dev/null 2>&1; then
                    pipx install spotdl
                else
                    echo -e "${RED}Instale manualmente com: yay -S spotdl (ou pipx install spotdl)${NC}"
                    exit 1
                fi
            else
                exit 0
            fi
        fi

        echo -e "${BLUE}📂 Pasta de Destino:${NC} ${dest_a}"
        echo ""
        local sp_opt=""
        if command -v fzf >/dev/null 2>&1 && [ -t 0 ]; then
            local sp_menu_in="1\t🎵 MP3 320kbps (Capa Oficial + Tags ID3 + Letras .lrc)\tFormato universal com qualidade máxima (320kbps CBR), capa em alta definição e letras sincronizadas (.lrc).\n2\t💎 FLAC Lossless (Áudio Estúdio sem perdas)\tÁudio 100% puro e sem compressão com máxima fidelidade sonora para audiófilos.\n3\t⚡ M4A AAC (Stream Nativo Rápido)\tCodec de alta eficiência da Apple/Spotify, menor tempo de download e processamento."

            local sp_chosen
            sp_chosen=$(echo -e "$sp_menu_in" | fzf \
                --prompt="🎧 Escolha o Formato Spotify > " \
                --header="[ENTER] Confirmar • [Ctrl+J/K] Navegar • [ESC] Cancelar" \
                --height=45% \
                --layout=reverse \
                --border=rounded \
                --color=header:italic,spinner:#f5e0dc,hl:#f38ba8 \
                --color=fg:#cdd6f4,header:#a6e3a1,info:#a6e3a1,pointer:#f5e0dc \
                --color=marker:#b4befe,fg+:#cdd6f4,prompt:#a6e3a1,hl+:#f38ba8 \
                --bind="ctrl-j:down,ctrl-k:up" \
                --with-nth=2 \
                --delimiter="\t" \
                --preview='echo -e "\n\033[1;38;2;166;227;161m╭────────────────────────────────────────╮\033[0m\n\033[1;38;2;166;227;161m│ {2}\033[0m\n\033[1;38;2;166;227;161m╰────────────────────────────────────────╯\033[0m\n\n\033[38;2;205;214;244m{3}\033[0m"' \
                --preview-window="right:45%:wrap:border-rounded")

            if [ -z "$sp_chosen" ]; then
                echo -e "\n${RED}Cancelado.${NC}"
                exit 0
            fi
            sp_opt=$(echo "$sp_chosen" | cut -f1)
        else
            echo -e "${BOLD}Escolha o Formato de Áudio:${NC}"
            echo -e "  ${BLUE}[1]${NC} 🎵 MP3 320kbps (Capa Oficial + Tags ID3 + Letras .lrc) [Padrão]"
            echo -e "  ${GREEN}[2]${NC} 💎 FLAC Lossless (Áudio Estúdio sem perdas)"
            echo -e "  ${PEACH}[3]${NC} ⚡ M4A AAC (Stream Nativo Rápido)"
            echo -e "  ${RED}[q]${NC} Cancelar"
            echo ""
            read -rp "Opção [1-3, padrão: 1]: " sp_opt
            sp_opt="${sp_opt:-1}"
        fi

        case "$sp_opt" in
            1)
                echo -e "\n${BLUE}🚀 Baixando do Spotify em MP3 320kbps com capa e letras...${NC}\n"
                download_spotify "$url" "mp3" "$dest_a" "cli"
                ;;
            2)
                echo -e "\n${GREEN}💎 Baixando do Spotify em FLAC Lossless...${NC}\n"
                download_spotify "$url" "flac" "$dest_a" "cli"
                ;;
            3)
                echo -e "\n${PEACH}⚡ Baixando do Spotify em M4A AAC...${NC}\n"
                download_spotify "$url" "m4a" "$dest_a" "cli"
                ;;
            q|Q)
                echo -e "\n${RED}Cancelado.${NC}"
                exit 0
                ;;
            *)
                echo -e "\n${RED}Opção inválida.${NC}"
                exit 1
                ;;
        esac

        echo ""
        echo -e "${GREEN}${BOLD}✔ Mídia do Spotify baixada com sucesso!${NC}"
        exit 0
    fi

    # Roteamento especial para galerias / imagens
    if is_gallery_domain "$url"; then
        echo -e "${PEACH}${BOLD}📸 Link de Galeria / Álbum de Fotos Detectado!${NC}"
        echo -e "${BLUE}📂 Pasta de Destino:${NC} ${dest_i}"
        download_gallery "$url" "$dest_i"
        exit 0
    fi

    # Roteamento especial para Pomfy / Streaming
    if is_pomfy_domain "$url"; then
        download_streaming_pomfy "$url" "$SEASON_ARG" "$EP_ARG"
        exit 0
    fi

    echo ""
    echo -e "${SUBTEXT}🔍 Conectando e obtendo metadados oficiais...${NC}"
    local info_title
    info_title=$(yt-dlp --get-title "$url" 2>/dev/null | head -n1 || echo "Mídia Online")
    echo -e "${GREEN}🎬 Título:${NC} ${BOLD}${info_title}${NC}"

    if [ -n "$CUSTOM_DIR" ]; then
        echo -e "${BLUE}📂 Pasta de Destino:${NC} ${CUSTOM_DIR}"
    fi
    if [ -n "$CUSTOM_NAME" ]; then
        echo -e "${PEACH}🏷️ Nome Personalizado:${NC} ${CUSTOM_NAME}"
    fi

    # Detecção de Playlist
    if [[ "$url" =~ list= ]]; then
        echo -e "\n${PEACH}⚡ URL de Playlist detectada!${NC}"
        echo -e "Deseja baixar a playlist inteira ou apenas o vídeo atual?"
        echo -e "  ${BLUE}[1]${NC} 📂 Playlist Completa (Vídeos numerados ordenadamente)"
        echo -e "  ${GREEN}[2]${NC} 🎬 Apenas este vídeo único"
        read -rp "Opção [1/2, padrão: 1]: " pl_opt
        if [ "$pl_opt" == "2" ]; then
            url="${url%%&list=*}"
        fi
    fi

    local opt=""
    if command -v fzf >/dev/null 2>&1 && [ -t 0 ]; then
        local vid_menu_in="1\t🎥 Melhor Qualidade MP4 (1080p/2K/4K + Legendas)\tMáxima resolução original com aceleração multi-thread (16 conexões paralelas) e legendas pt/en embutidas.\n2\t🎵 Apenas Áudio MP3 (320kbps + Capa + Tags ID3)\tExtração direta de áudio em 320kbps CBR com capa oficial embutida e metadados preenchidos.\n3\t⚡ Rápido e Leve (720p balanceado)\tDownload ultrarrápido em 720p, ideal para economizar espaço e assistir rapidamente.\n4\t✂️ Cortar Trecho Cirúrgico (Clip)\tBaixa apenas o intervalo de minutagem desejado sem precisar baixar o vídeo inteiro.\n5\t🗜️ Comprimir para Discord / WhatsApp (<10MB)\tComprime o arquivo em dois passos inteligentes garantindo tamanho menor que 10MB.\n6\t🎞️ Gerar GIF Animado Fluido\tGera um GIF animado em alta taxa de quadros e paleta otimizada a partir de um trecho.\n7\t⏩ Modo Estudo (Sem silêncios + 1.5x)\tRemove pausas e respirações e acelera o áudio para 1.5x com correção de tom.\n8\t🤖 Transcrição Limpa para IA (.md)\tExtrai texto falado sem timestamps e copia direto pro Clipboard pronto para LLMs.\n9\t📝 Apenas Legendas (.srt)\tBaixa apenas o arquivo de legendas brutas em formato .srt sincronizado.\n10\t🖼️ Apenas Capa / Thumbnail (4K)\tSalva a imagem de capa em alta resolução da mídia na pasta de imagens."

        local chosen_vid
        chosen_vid=$(echo -e "$vid_menu_in" | fzf \
            --prompt="🎬 Escolha o Formato > " \
            --header="[ENTER] Confirmar • [Ctrl+J/K] Navegar • [ESC] Cancelar" \
            --height=55% \
            --layout=reverse \
            --border=rounded \
            --color=header:italic,spinner:#f5e0dc,hl:#f38ba8 \
            --color=fg:#cdd6f4,header:#cba6f7,info:#cba6f7,pointer:#f5e0dc \
            --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
            --bind="ctrl-j:down,ctrl-k:up" \
            --with-nth=2 \
            --delimiter="\t" \
            --preview='echo -e "\n\033[1;38;2;203;166;247m╭────────────────────────────────────────╮\033[0m\n\033[1;38;2;203;166;247m│ {2}\033[0m\n\033[1;38;2;203;166;247m╰────────────────────────────────────────╯\033[0m\n\n\033[38;2;205;214;244m{3}\033[0m"' \
            --preview-window="right:45%:wrap:border-rounded")

        if [ -z "$chosen_vid" ]; then
            echo -e "\n${RED}Cancelado.${NC}"
            exit 0
        fi
        opt=$(echo "$chosen_vid" | cut -f1)
    else
        echo ""
        echo -e "${BOLD}Escolha o Formato de Download:${NC}"
        echo -e "  ${BLUE}[1]${NC} 🎥 Melhor Qualidade MP4 (1080p/2K/4K + Legendas pt/en)"
        echo -e "  ${GREEN}[2]${NC} 🎵 Apenas Áudio MP3 (320kbps + Capa + Tags ID3)"
        echo -e "  ${PEACH}[3]${NC} ⚡ Rápido e Leve (720p balanceado)"
        echo -e "  ${TEAL}[4]${NC} ✂️ Cortar Trecho Cirúrgico (Clip)"
        echo -e "  ${YELLOW}[5]${NC} 🗜️ Comprimir para Discord / WhatsApp (<10MB)"
        echo -e "  ${MAUVE}[6]${NC} 🎞️ Gerar GIF Animado Fluido"
        echo -e "  ${BLUE}[7]${NC} ⏩ Modo Estudo (Sem silêncios + 1.5x de velocidade)"
        echo -e "  ${MAUVE}[8]${NC} 🤖 Transcrição Limpa para IA (.md / pronto para ChatGPT & Claude)"
        echo -e "  ${SUBTEXT}[9]${NC} 📝 Apenas Legendas (.srt bruto)"
        echo -e "  ${SUBTEXT}[10]${NC} 🖼️ Apenas Capa / Thumbnail em Alta Resolução"
        echo -e "  ${RED}[q]${NC} Cancelar"
        echo ""
        read -rp "Opção [1-10, padrão: 1]: " opt
        opt="${opt:-1}"
    fi

    case "$opt" in
        1)
            echo -e "\n${BLUE}🚀 Baixando com 16 conexões paralelas e legendas...${NC}\n"
            download_video "$url" "best" "$dest_v"
            ;;
        2)
            echo -e "\n${GREEN}🎵 Extraindo áudio em MP3 320kbps com capa...${NC}\n"
            download_audio "$url" "$dest_a"
            ;;
        3)
            echo -e "\n${PEACH}⚡ Baixando vídeo leve 720p...${NC}\n"
            download_video "$url" "720" "$dest_v"
            ;;
        4)
            echo ""
            read -rp "Digite o intervalo do trecho (ex: 01:20-02:40): " clip_input
            if [ -n "$clip_input" ]; then
                echo -e "\n${TEAL}✂️ Baixando apenas o trecho $clip_input...${NC}\n"
                download_video "$url" "best" "$dest_v" "$clip_input"
            fi
            ;;
        5)
            echo -e "\n${YELLOW}🗜️ Baixando e comprimindo para Discord/WhatsApp...${NC}\n"
            COMPRESS_TARGET="10"
            download_video "$url" "720" "$dest_v"
            ;;
        6)
            echo ""
            read -rp "Digite o trecho para o GIF (ex: 00:05-00:15): " gif_clip
            MAKE_GIF=true
            echo -e "\n${MAUVE}🎞️ Baixando trecho e gerando GIF de alta qualidade...${NC}\n"
            download_video "$url" "720" "$dest_v" "$gif_clip"
            ;;
        7)
            echo -e "\n${TEAL}⏩ Modo Estudo: Baixando áudio, cortando silêncios e acelerando 1.5x...${NC}\n"
            STUDY_SPEED="1.5"
            download_audio "$url" "$dest_a"
            ;;
        8)
            echo -e "\n${MAUVE}🤖 Extraindo transcrição e gerando resumo limpo em Markdown para IA...${NC}\n"
            download_transcript "$url" "$DEFAULT_DEST_TRANSCRIPT"
            ;;
        9)
            echo -e "\n${SUBTEXT}📝 Extraindo apenas as legendas (.srt)...${NC}\n"
            SUB_ONLY=true
            download_video "$url" "best" "$dest_v"
            ;;
        10)
            echo -e "\n${SUBTEXT}🖼️ Baixando a thumbnail/capa em alta resolução...${NC}\n"
            THUMB_ONLY=true
            download_video "$url" "best" "$dest_i"
            ;;
        q|Q)
            echo -e "\n${RED}Cancelado.${NC}"
            exit 0
            ;;
        *)
            echo -e "\n${RED}Opção inválida.${NC}"
            exit 1
            ;;
    esac

    echo ""
    echo -e "${GREEN}${BOLD}✔ Operação concluída com sucesso!${NC}"
}

# ------------------------------------------------------------------------------
# ROTEADOR PRINCIPAL DE ARGUMENTOS
# ------------------------------------------------------------------------------
show_help() {
    echo -e "${MAUVE}${BOLD}📥 MEDIA DOWNLOADER SUITE (APEX V2)${NC}"
    echo -e "${SUBTEXT}Uso:${NC} dl [opções] [URL]"
    echo ""
    echo -e "${BOLD}Comandos Rápidos:${NC}"
    echo -e "  ${BLUE}dl${NC}                          Abre o menu interativo no terminal"
    echo -e "  ${BLUE}dl <url>${NC}                    Abre o menu interativo para a URL"
    echo -e "  ${PEACH}dl \"<busca>\"${NC}                Busca vídeos no YouTube com seletor interativo FZF"
    echo -e "  ${BLUE}dl --rofi${NC}                   Abre o menu visual Rofi (SUPER + ALT + D)"
    echo -e "  ${BLUE}dl -n, --now${NC}                Baixa o que está tocando agora (SUPER + CTRL + D)"
    echo -e "  ${BLUE}dl -h, --history${NC}            Histórico de downloads com busca FZF"
    echo -e "  ${BLUE}dl -u, --update${NC}             Atualiza os motores de download (yt-dlp, spotdl, gallery-dl)"
    echo -e "  ${BLUE}dl -b <lista.txt|md>${NC}       Baixa em lote todos os links de um arquivo (.txt ou .md)"
    echo -e "  ${BLUE}dl -p <lista.txt|md>${NC}       Baixa a lista toda direto para a pasta .privado"
    echo ""
    echo -e "${BOLD}Flags Diretas de Linha de Comando:${NC}"
    echo -e "  ${GREEN}dl -a <url>${NC}                 Baixa direto como Áudio MP3 320k"
    echo -e "  ${BLUE}dl -o, --name <nome> <url>${NC}  Define nome personalizado do arquivo"
    echo -e "  ${MAUVE}dl -t, --transcript <url>${NC}   Extrai transcrição limpa em Markdown (.md) para IA/LLMs"
    echo -e "  ${BLUE}dl -s, --subs <url>${NC}         Embuti legendas automáticas pt/en no vídeo"
    echo -e "  ${GREEN}dl --no-sponsors <url>${NC}       Remove jabás e patrocínios embutidos (SponsorBlock)"
    echo -e "  ${PEACH}dl -p <url>${NC}                 Roteia direto para a pasta .privado"
    echo -e "  ${BLUE}dl -b, --batch <file>${NC}       Processa arquivo (.txt, .md) com links em lote"
    echo -e "  ${BLUE}dl --here <url>${NC}             Baixa diretamente na pasta atual onde o terminal está"
    echo -e "  ${BLUE}dl -d, --dir <pasta>${NC}        Define diretório de destino customizado (ex: dl -d .)"
    echo -e "  ${TEAL}dl -c 01:20-02:40 <url>${NC}     Corta trecho cirúrgico do vídeo"
    echo -e "  ${YELLOW}dl -z 10 <url>${NC}              Comprime para caber em 10MB (Discord)"
    echo -e "  ${MAUVE}dl -g 00:05-00:15 <url>${NC}     Gera GIF animado do trecho"
    echo -e "  ${BLUE}dl --split-chapters <url>${NC}   Divide shows/álbuns em faixas por capítulo"
    echo -e "  ${BLUE}dl --sync <url>${NC}             Atualiza playlist baixando apenas faixas novas"
    echo -e "  ${BLUE}dl --study 1.5 <url>${NC}        Remove silêncios e acelera para estudo"
    echo -e "  ${BLUE}dl --cookies brave <url>${NC}    Usa cookies do navegador para vídeos 18+"
    echo -e "  ${BLUE}dl --gallery <url>${NC}          Baixa álbuns de fotos (Instagram/Twitter)"
    echo -e "  ${BLUE}dl --sub-only <url>${NC}         Baixa apenas as legendas (.srt)"
    echo -e "  ${BLUE}dl --thumb <url>${NC}            Baixa apenas a capa / thumbnail em 4K"
    echo -e "  ${TEAL}dl --pomfy <nome|url>${NC}       Busca e baixa filme ou série do Pomfy (FZF)"
    echo -e "  ${TEAL}dl -P \"<busca>\"${NC}               Busca filmes/séries direto no catálogo Pomfy"
    echo -e "  ${TEAL}dl --pomfy <url> --season 1 --ep 1-7${NC} Baixa lote de episódios da série no Pomfy"
    echo -e "  ${YELLOW}dl --audio <pt|en|dual>${NC}      Seleciona áudio Dublado (pt), Original (en) ou Dual Áudio"
    echo -e "  ${YELLOW}dl --dual${NC}                     Baixa vídeo com faixas Dublado + Original no mesmo arquivo"
    echo ""
}

main() {
    local target_url=""
    local run_mode="interactive"
    local direct_action=""

    while [ $# -gt 0 ]; do
        case "$1" in
            --help)
                show_help
                exit 0
                ;;
            --rofi)
                run_rofi_mode
                exit 0
                ;;
            -u|--update)
                update_engines
                exit 0
                ;;
            -h|--history)
                view_history "cli"
                exit 0
                ;;
            -o|--output|--name)
                CUSTOM_NAME="$2"
                shift 2
                ;;
            -d|--dir)
                CUSTOM_DIR="$2"
                shift 2
                ;;
            --here)
                CUSTOM_DIR="$(pwd)"
                shift
                ;;
            -n|--now)
                local now_url
                now_url=$(get_now_playing_info || true)
                if [ -z "$now_url" ]; then
                    echo -e "${RED}❌ Nenhuma mídia ativa encontrada no playerctl.${NC}"
                    exit 1
                fi
                echo -e "${GREEN}🎵 Detectado via MPRIS:${NC} $now_url"
                target_url="$now_url"
                shift
                ;;
            -a|--audio)
                if [[ "$2" =~ ^(pt|en|dual|dublado|original|legendado)$ ]]; then
                    STREAM_AUDIO_LANG="$2"
                    STREAM_AUDIO_LANG_SET=true
                    shift 2
                else
                    direct_action="audio"
                    shift
                fi
                ;;
            --audio-track|--audio-lang|--lang)
                STREAM_AUDIO_LANG="$2"
                STREAM_AUDIO_LANG_SET=true
                shift 2
                ;;
            --dual|--dual-audio)
                STREAM_AUDIO_LANG="dual"
                STREAM_AUDIO_LANG_SET=true
                shift
                ;;
            --dublado)
                STREAM_AUDIO_LANG="pt"
                STREAM_AUDIO_LANG_SET=true
                shift
                ;;
            --original|--legendado)
                STREAM_AUDIO_LANG="en"
                STREAM_AUDIO_LANG_SET=true
                shift
                ;;
            -s|--subs|--subtitles)
                WITH_SUBS=true
                shift
                ;;
            -t|--transcript|--text)
                direct_action="transcript"
                shift
                ;;
            -P|--pomfy|--stream)
                direct_action="pomfy"
                shift
                ;;
            --season)
                SEASON_ARG="$2"
                shift 2
                ;;
            --ep|--episode)
                EP_ARG="$2"
                shift 2
                ;;
            --no-sponsors|--clean)
                SKIP_SPONSORS=true
                shift
                ;;
            -p|--private)
                FORCE_PRIVATE=true
                shift
                ;;
            -b|--batch)
                BATCH_FILE="$2"
                shift 2
                ;;

            -c|--clip)
                CUSTOM_CLIP="$2"
                shift 2
                ;;
            -z|--compress)
                COMPRESS_TARGET="${2:-10}"
                shift
                [[ "$1" =~ ^[0-9]+$ ]] && shift
                ;;
            -g|--gif)
                MAKE_GIF=true
                if [[ "$2" =~ ^[0-9]+:[0-9]+ ]]; then
                    CUSTOM_CLIP="$2"
                    shift 2
                else
                    shift
                fi
                ;;
            --split-chapters)
                SPLIT_CHAPTERS=true
                shift
                ;;
            --sync)
                SYNC_PLAYLIST=true
                shift
                ;;
            --study)
                direct_action="audio"
                STUDY_SPEED="${2:-1.5}"
                shift
                [[ "$1" =~ ^[0-9] ]] && shift
                ;;
            --cookies)
                COOKIES_BROWSER="${2:-brave}"
                shift 2
                ;;
            --gallery)
                direct_action="gallery"
                shift
                ;;
            --sub-only)
                SUB_ONLY=true
                direct_action="video"
                shift
                ;;
            --thumb)
                THUMB_ONLY=true
                direct_action="video"
                shift
                ;;
            *)
                if [ -z "$target_url" ]; then
                    target_url="$1"
                fi
                shift
                ;;
        esac
    done

    # Se target_url não for URL nem arquivo existente, interpreta como busca rápida no YouTube (exceto se for pomfy)
    if [ "$direct_action" != "pomfy" ] && [ -n "$target_url" ] && ! is_url_or_file "$target_url"; then
        local search_found
        search_found=$(search_youtube_fzf "$target_url")
        if [ -z "$search_found" ]; then
            exit 0
        fi
        target_url="$search_found"
    fi

    # Se foi passado um arquivo de lote (.txt com múltiplos links) ou a flag --batch
    local batch_candidate="${BATCH_FILE:-$target_url}"
    if [ -n "$batch_candidate" ]; then
        if [ ! -f "$batch_candidate" ] && [ -f "$DEFAULT_DEST_PRIVATE/$batch_candidate" ]; then
            batch_candidate="$DEFAULT_DEST_PRIVATE/$batch_candidate"
        fi
    fi
    if [ -n "$batch_candidate" ] && [ -f "$batch_candidate" ]; then
        local dest_batch="${CUSTOM_DIR:-$DEFAULT_DEST_VIDEO}"
        [ "$FORCE_PRIVATE" = true ] && dest_batch="$DEFAULT_DEST_PRIVATE/Videos_e_Cenas"
        local mode="video"
        [ "$direct_action" == "audio" ] && mode="audio"
        download_batch "$batch_candidate" "$dest_batch" "$mode"
        exit 0
    fi

    # Se foi chamada uma flag direta específica de linha de comando, executa direto
    if [ -n "$direct_action" ] || [ "$MAKE_GIF" = true ] || [ -n "$COMPRESS_TARGET" ] || [ "$SPLIT_CHAPTERS" = true ] || [ "$SYNC_PLAYLIST" = true ] || [ -n "$CUSTOM_CLIP" ] || [ "$FORCE_PRIVATE" = true ] || [ "$SKIP_SPONSORS" = true ] || [ "$WITH_SUBS" = true ]; then

        if [ "$direct_action" == "pomfy" ]; then
            if [ -z "$target_url" ]; then
                local clip_cand
                clip_cand=$(get_clipboard_url)
                if is_pomfy_domain "$clip_cand"; then
                    target_url="$clip_cand"
                else
                    target_url=$(search_pomfy_fzf "")
                fi
            elif ! is_pomfy_domain "$target_url"; then
                target_url=$(search_pomfy_fzf "$target_url")
            fi
            if [ -z "$target_url" ]; then
                exit 0
            fi
        fi

        if [ -z "$target_url" ]; then
            target_url=$(get_clipboard_url)
        fi
        if [ -z "$target_url" ]; then
            echo -e "${RED}❌ Nenhuma URL fornecida para o comando direto.${NC}"
            exit 1
        fi

        local dest_v="${CUSTOM_DIR:-$DEFAULT_DEST_VIDEO}"
        local dest_a="${CUSTOM_DIR:-$DEFAULT_DEST_AUDIO}"
        local dest_i="${CUSTOM_DIR:-$DEFAULT_DEST_IMAGE}"

        if is_sensitive_domain "$target_url" || [ "$FORCE_PRIVATE" = true ]; then
            dest_v="$DEFAULT_DEST_PRIVATE/Videos_e_Cenas"
            dest_a="$DEFAULT_DEST_PRIVATE/Audios"
            dest_i="$DEFAULT_DEST_PRIVATE/Imagens"
            mkdir -p "$dest_v" "$dest_a" "$dest_i"
        fi

        if is_pomfy_domain "$target_url" || [ "$direct_action" == "pomfy" ]; then
            download_streaming_pomfy "$target_url" "$SEASON_ARG" "$EP_ARG"
        elif is_magnet_or_torrent "$target_url"; then
            download_torrent_or_magnet "$target_url" "$dest_v"
        elif is_direct_download_file "$target_url"; then
            download_direct_file "$target_url" "$dest_v"
        elif [[ "$target_url" =~ (open\.spotify\.com|spotify:) ]]; then
            download_spotify "$target_url" "mp3" "$dest_a" "cli"
        elif [ "$direct_action" == "gallery" ] || is_gallery_domain "$target_url"; then
            download_gallery "$target_url" "$dest_i"
        elif [ "$direct_action" == "transcript" ]; then
            local dest_t="${CUSTOM_DIR:-$DEFAULT_DEST_TRANSCRIPT}"
            download_transcript "$target_url" "$dest_t"
        elif [ "$direct_action" == "audio" ]; then
            download_audio "$target_url" "$dest_a" "$CUSTOM_CLIP"
        else
            download_video "$target_url" "best" "$dest_v" "$CUSTOM_CLIP"
        fi

    else
        # Caso padrão (dl, dl <url>, ou Yazi M y): abre o menu interativo com o banner e opções
        run_cli_mode "$target_url"
    fi
}

main "$@"
