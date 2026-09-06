#!/usr/bin/env bash
# ==============================================================================
# 📥 MEDIA DOWNLOADER SUITE DEFINITIVO (APEX V2) — HYPRLAND, YAZI & TERMINAL
# ==============================================================================
# Motores: yt-dlp + spotdl + gallery-dl + aria2c + ffmpeg + playerctl + ripdrag
# Suporte: YouTube, Spotify, Twitter/X, Instagram, TikTok, Reddit, Twitch, Vimeo,
#          sites privados/adultos, álbuns de fotos e mais de 1.800 plataformas.
# ==============================================================================

set -eo pipefail

# ------------------------------------------------------------------------------
# DIRETÓRIOS CANÔNICOS DE DESTINO
# ------------------------------------------------------------------------------
if [ -d "/mnt/dados/05_Midias_Design_e_Criacao" ]; then
    DEFAULT_DEST_VIDEO="/mnt/dados/05_Midias_Design_e_Criacao/Videos/Downloads"
    DEFAULT_DEST_AUDIO="/mnt/dados/05_Midias_Design_e_Criacao/Musicas_e_Audios/Downloads"
    DEFAULT_DEST_IMAGE="/mnt/dados/05_Midias_Design_e_Criacao/Imagens/Downloads"
    DEFAULT_DEST_PRIVATE="/mnt/dados/01_Pessoal_e_Vida/.privado"
elif [ -d "$HOME/drive-organizacao/05_Design_Midia_e_Criacao" ]; then
    DEFAULT_DEST_VIDEO="$HOME/drive-organizacao/05_Design_Midia_e_Criacao/05.4_Filmes_e_Series"
    DEFAULT_DEST_AUDIO="$HOME/drive-organizacao/05_Design_Midia_e_Criacao/05.2_Audios_e_Midias"
    DEFAULT_DEST_IMAGE="$HOME/drive-organizacao/05_Design_Midia_e_Criacao/05.1_Artes_e_Wallpapers"
    DEFAULT_DEST_PRIVATE="$HOME/drive-organizacao/01_Pessoal_e_Vida/.privado"
else
    DEFAULT_DEST_VIDEO="$HOME/Videos/Downloads"
    DEFAULT_DEST_AUDIO="$HOME/Music/Downloads"
    DEFAULT_DEST_IMAGE="$HOME/Pictures/Downloads"
    DEFAULT_DEST_PRIVATE="$HOME/.privado"
fi

STATE_DIR="$HOME/.local/state/media-downloader"
HISTORY_FILE="$STATE_DIR/history.log"
mkdir -p "$STATE_DIR"

CUSTOM_DIR=""
CUSTOM_CLIP=""
COMPRESS_TARGET=""
MAKE_GIF=false
SPLIT_CHAPTERS=false
SYNC_PLAYLIST=false
STUDY_SPEED=""
COOKIES_BROWSER=""
SUB_ONLY=false
THUMB_ONLY=false
FORCE_PRIVATE=false
BATCH_FILE=""


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

    local urls=()
    while IFS= read -r line || [ -n "$line" ]; do
        line=$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
        if [[ "$line" =~ ^https?:// ]] || [[ "$line" =~ ^magnet:\? ]]; then
            urls+=("$line")
        fi
    done < "$file"

    local total="${#urls[@]}"
    if [ "$total" -eq 0 ]; then
        echo -e "${YELLOW}Nenhuma URL válida encontrada em $file.${NC}"
        exit 0
    fi

    echo -e "${MAUVE}📦 Iniciando Download em Lote (Batch Mode):${NC} ${BOLD}$total mídias na fila${NC}"
    echo -e "${BLUE}📂 Pasta Base de Destino:${NC} $dest\n"

    local current=0
    local success=0
    local failed=0

    for u in "${urls[@]}"; do
        current=$((current + 1))
        echo -e "${PEACH}[$current/$total] Processando:${NC} $u"
        local item_dest="$dest"
        if is_sensitive_domain "$u" || [ "$FORCE_PRIVATE" = true ]; then
            item_dest="$DEFAULT_DEST_PRIVATE/Videos_e_Cenas"
            [ "$mode" == "audio" ] && item_dest="$DEFAULT_DEST_PRIVATE/Audios"
            mkdir -p "$item_dest"
        fi

        local res=0
        if is_magnet_or_torrent "$u"; then
            download_torrent_or_magnet "$u" "$item_dest" || res=1
        elif is_direct_download_file "$u"; then
            download_direct_file "$u" "$item_dest" || res=1
        elif [[ "$u" =~ (open\.spotify\.com|spotify:) ]]; then
            download_spotify "$u" "mp3" "$item_dest" "cli" || res=1
        elif is_gallery_domain "$u"; then
            download_gallery "$u" "$item_dest" || res=1
        elif [ "$mode" == "audio" ]; then
            download_audio "$u" "$item_dest" || res=1
        else
            download_video "$u" "best" "$item_dest" || res=1
        fi

        if [ "$res" -eq 0 ]; then
            success=$((success + 1))
        else
            failed=$((failed + 1))
            echo -e "${RED}⚠ Falha ou recurso indisponível no link:${NC} $u (continuando lote...)"
        fi
        echo ""
    done


    echo -e "${GREEN}🎉 Lote concluído!${NC} $total processados ($success com sucesso, $failed falhas)."
    notify_completion "Download em Lote Concluído ($total itens)" "$dest"
}




get_downloader_args() {
    if command -v aria2c >/dev/null 2>&1; then
        echo "--downloader aria2c --downloader-args 'aria2c:-c -j 16 -x 16 -s 16 -k 1M --quiet=true'"
    fi
}

notify_completion() {
    local title="$1"
    local dest_dir="$2"
    local target_file="${3:-}"

    if [ -z "$target_file" ]; then
        target_file=$(find "$dest_dir" -maxdepth 2 -type f \( -name "*.mp3" -o -name "*.flac" -o -name "*.m4a" -o -name "*.mp4" -o -name "*.mkv" -o -name "*.webm" -o -name "*.gif" -o -name "*.png" -o -name "*.jpg" \) -printf '%T@ %p\n' 2>/dev/null | sort -n | tail -1 | cut -f2- -d" ")
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
    local dl_args
    dl_args=$(get_downloader_args)

    mkdir -p "$dest"
    cd "$dest"

    local format_str="bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b"
    if [ "$quality" == "720" ]; then
        format_str="bv*[height<=720][ext=mp4]+ba[ext=m4a]/b[height<=720] / bv*[height<=720]+ba/b"
    elif [ "$quality" == "1080" ]; then
        format_str="bv*[height<=1080][ext=mp4]+ba[ext=m4a]/b[height<=1080] / bv*[height<=1080]+ba/b"
    fi

    local extra_flags=()
    [ -n "$clip_range" ] && extra_flags+=(--download-sections "*${clip_range}" --force-keyframes-at-cuts)
    [ "$SPLIT_CHAPTERS" = true ] && extra_flags+=(--split-chapters -o "chapter:%(title)s/%(section_number)02d - %(section_title)s.%(ext)s")
    [ "$SYNC_PLAYLIST" = true ] && extra_flags+=(--download-archive "$dest/.download_archive.txt")
    [ -n "$COOKIES_BROWSER" ] && extra_flags+=(--cookies-from-browser "$COOKIES_BROWSER")
    [ "$SUB_ONLY" = true ] && extra_flags+=(--skip-download --write-auto-subs --sub-lang 'pt,en' --convert-subs srt)
    [ "$THUMB_ONLY" = true ] && extra_flags+=(--skip-download --write-thumbnail --convert-thumbnails png)

    local output_tpl="%(title)s [%(id)s].%(ext)s"
    if [[ "$url" =~ list= ]] && [ "$SPLIT_CHAPTERS" = false ]; then
        output_tpl="%(playlist_title,playlist)s/%(playlist_index)02d - %(title)s.%(ext)s"
    fi

    echo -e "${BLUE}⬇️ Baixando vídeo com aceleração multi-thread...${NC}"
    eval yt-dlp \
        $dl_args \
        -f "'$format_str'" \
        --merge-output-format mp4 \
        --embed-thumbnail \
        --embed-metadata \
        --embed-chapters \
        --write-auto-subs \
        --sub-lang "'pt,en'" \
        --embed-subs \
        -o "'$output_tpl'" \
        --windows-filenames \
        --no-mtime \
        "${extra_flags[@]}" \
        "'$url'" || dl_status=$?

    if [ "$dl_status" -ne 0 ]; then
        return 1
    fi

    local latest_file
    latest_file=$(find "$dest" -maxdepth 2 -type f -printf '%T@ %p\n' 2>/dev/null | sort -n | tail -1 | cut -f2- -d" ")
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
    title=$(yt-dlp --get-title "$url" 2>/dev/null | head -n1 || echo "Vídeo Concluído")
    log_history "$title" "$url" "$final_target" "VIDEO"
    notify_completion "$title" "$dest" "$final_target"
}

# ------------------------------------------------------------------------------
# MOTOR DE DOWNLOAD (ÁUDIO / YT-DLP)
# ------------------------------------------------------------------------------
download_audio() {
    local url="$1"
    local dest="$2"
    local clip_range="${3:-$CUSTOM_CLIP}"
    local dl_args
    dl_args=$(get_downloader_args)

    mkdir -p "$dest"
    cd "$dest"

    local extra_flags=()
    [ -n "$clip_range" ] && extra_flags+=(--download-sections "*${clip_range}" --force-keyframes-at-cuts)
    [ "$SPLIT_CHAPTERS" = true ] && extra_flags+=(--split-chapters -o "chapter:%(title)s/%(section_number)02d - %(section_title)s.%(ext)s")
    [ "$SYNC_PLAYLIST" = true ] && extra_flags+=(--download-archive "$dest/.download_archive.txt")
    [ -n "$COOKIES_BROWSER" ] && extra_flags+=(--cookies-from-browser "$COOKIES_BROWSER")

    local output_tpl="%(title)s [%(id)s].%(ext)s"
    if [[ "$url" =~ list= ]] && [ "$SPLIT_CHAPTERS" = false ]; then
        output_tpl="%(playlist_title,playlist)s/%(playlist_index)02d - %(title)s.%(ext)s"
    fi

    echo -e "${BLUE}⬇️ Extraindo áudio de alta fidelidade (MP3 320kbps)...${NC}"
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
    title=$(yt-dlp --get-title "$url" 2>/dev/null | head -n1 || echo "Áudio Concluído")
    log_history "$title" "$url" "$final_target" "AUDIO"
    notify_completion "$title" "$dest" "$final_target"
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
    if [[ "$url" =~ /album/ ]]; then
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
            --output "$output_tpl" \
            --sponsor-block \
            --generate-lrc >/dev/null 2>&1 || true
    else
        spotdl download "$url" \
            --format "$format" \
            $bitrate_flag \
            --output "$output_tpl" \
            --sponsor-block \
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

    local choice
    choice=$(printf "🎥 Vídeo Completo (1080p/4K MP4)\n🎵 Áudio MP3 (320kbps + Capa & Tags)\n⚡ Vídeo Leve (720p Rápido)\n✂️ Cortar Trecho de Vídeo (Clip)\n🗜️ Comprimir para Discord / WhatsApp (<10MB)\n🎞️ Gerar GIF Animado\n📸 Galeria de Fotos / Imagens\n📝 Baixar Apenas Legendas (.srt)\n🖼️ Baixar Apenas Capa / Thumbnail" | rofi -dmenu -i -p "Escolha o Formato" -l 9 || true)

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
    echo -e "${MAUVE}${BOLD}│    📥 MEDIA DOWNLOADER POWER-USER (yt-dlp + spotdl + aria2)   │${NC}"
    echo -e "${MAUVE}${BOLD}╰───────────────────────────────────────────────────────────────╯${NC}"
    echo ""

    if [ -z "$url" ]; then
        local clip_url
        clip_url=$(get_clipboard_url)
        if [ -n "$clip_url" ]; then
            echo -e "${BLUE}📋 URL detectada na Área de Transferência:${NC}"
            echo -e "   ${TEXT}${clip_url}${NC}"
            echo ""
            read -rp "Pressione [Enter] para usar esta URL ou digite outra: " input_url
            url="${input_url:-$clip_url}"
        else
            echo -e "${PEACH}Cole ou digite a URL do vídeo/áudio/foto:${NC}"
            read -rp "URL: " url
        fi
    fi

    if [ -z "$url" ]; then
        echo -e "\n${RED}❌ Nenhuma URL fornecida.${NC}"
        exit 1
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
        echo -e "${BOLD}Escolha o Formato de Áudio:${NC}"
        echo -e "  ${BLUE}[1]${NC} 🎵 MP3 320kbps (Capa Oficial + Tags ID3 + Letras .lrc) [Padrão]"
        echo -e "  ${GREEN}[2]${NC} 💎 FLAC Lossless (Áudio Estúdio sem perdas)"
        echo -e "  ${PEACH}[3]${NC} ⚡ M4A AAC (Stream Nativo Rápido)"
        echo -e "  ${RED}[q]${NC} Cancelar"
        echo ""
        read -rp "Opção [1-3, padrão: 1]: " sp_opt
        sp_opt="${sp_opt:-1}"

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

    echo ""
    echo -e "${SUBTEXT}🔍 Conectando e obtendo metadados oficiais...${NC}"
    local info_title
    info_title=$(yt-dlp --get-title "$url" 2>/dev/null | head -n1 || echo "Mídia Online")
    echo -e "${GREEN}🎬 Título:${NC} ${BOLD}${info_title}${NC}"

    if [ -n "$CUSTOM_DIR" ]; then
        echo -e "${BLUE}📂 Pasta de Destino:${NC} ${CUSTOM_DIR}"
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

    echo ""
    echo -e "${BOLD}Escolha o Formato de Download:${NC}"
    echo -e "  ${BLUE}[1]${NC} 🎥 Melhor Qualidade MP4 (1080p/2K/4K + Legendas pt/en)"
    echo -e "  ${GREEN}[2]${NC} 🎵 Apenas Áudio MP3 (320kbps + Capa + Tags ID3)"
    echo -e "  ${PEACH}[3]${NC} ⚡ Rápido e Leve (720p balanceado)"
    echo -e "  ${TEAL}[4]${NC} ✂️ Cortar Trecho Cirúrgico (Clip)"
    echo -e "  ${YELLOW}[5]${NC} 🗜️ Comprimir para Discord / WhatsApp (<10MB)"
    echo -e "  ${MAUVE}[6]${NC} 🎞️ Gerar GIF Animado Fluido"
    echo -e "  ${BLUE}[7]${NC} ⏩ Modo Estudo (Sem silêncios + 1.5x de velocidade)"
    echo -e "  ${SUBTEXT}[8]${NC} 📝 Apenas Legendas / Transcrição (.srt)"
    echo -e "  ${SUBTEXT}[9]${NC} 🖼️ Apenas Capa / Thumbnail em Alta Resolução"
    echo -e "  ${RED}[q]${NC} Cancelar"
    echo ""
    read -rp "Opção [1-9, padrão: 1]: " opt
    opt="${opt:-1}"

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
            echo -e "\n${SUBTEXT}📝 Extraindo apenas as legendas (.srt)...${NC}\n"
            SUB_ONLY=true
            download_video "$url" "best" "$dest_v"
            ;;
        9)
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
    echo -e "  ${BLUE}dl --rofi${NC}                   Abre o menu visual Rofi (SUPER + ALT + D)"
    echo -e "  ${BLUE}dl -n, --now${NC}                Baixa o que está tocando agora (SUPER + CTRL + D)"
    echo -e "  ${BLUE}dl -h, --history${NC}            Histórico de downloads com busca FZF"
    echo -e "  ${BLUE}dl -b <lista.txt>${NC}          Baixa em lote todos os links de um arquivo de texto"
    echo -e "  ${BLUE}dl -p <lista.txt>${NC}          Baixa a lista toda direto para a pasta .privado"
    echo ""
    echo -e "${BOLD}Flags Diretas de Linha de Comando:${NC}"
    echo -e "  ${GREEN}dl -a <url>${NC}                 Baixa direto como Áudio MP3 320k"
    echo -e "  ${PEACH}dl -p <url>${NC}                 Roteia direto para a pasta .privado"
    echo -e "  ${BLUE}dl -b, --batch <file.txt>${NC}   Processa arquivo de texto com links em lote"
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
            -h|--history)
                view_history "cli"
                exit 0
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
                direct_action="audio"
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

    # Se foi passado um arquivo de lote (.txt com múltiplos links) ou a flag --batch
    local batch_candidate="${BATCH_FILE:-$target_url}"
    if [ -n "$batch_candidate" ] && [ -f "$batch_candidate" ]; then
        local dest_batch="${CUSTOM_DIR:-$DEFAULT_DEST_VIDEO}"
        [ "$FORCE_PRIVATE" = true ] && dest_batch="$DEFAULT_DEST_PRIVATE/Videos_e_Cenas"
        local mode="video"
        [ "$direct_action" == "audio" ] && mode="audio"
        download_batch "$batch_candidate" "$dest_batch" "$mode"
        exit 0
    fi

    # Se foi chamada uma flag direta específica de linha de comando, executa direto
    if [ -n "$direct_action" ] || [ "$MAKE_GIF" = true ] || [ -n "$COMPRESS_TARGET" ] || [ "$SPLIT_CHAPTERS" = true ] || [ "$SYNC_PLAYLIST" = true ] || [ -n "$CUSTOM_CLIP" ] || [ "$FORCE_PRIVATE" = true ]; then


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

        if is_magnet_or_torrent "$target_url"; then
            download_torrent_or_magnet "$target_url" "$dest_v"
        elif is_direct_download_file "$target_url"; then
            download_direct_file "$target_url" "$dest_v"
        elif [[ "$target_url" =~ (open\.spotify\.com|spotify:) ]]; then
            download_spotify "$target_url" "mp3" "$dest_a" "cli"
        elif [ "$direct_action" == "gallery" ] || is_gallery_domain "$target_url"; then
            download_gallery "$target_url" "$dest_i"
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
