#!/usr/bin/env bash
# ==============================================================================
# 📥 MEDIA DOWNLOADER POWER-USER — O Download Manager Definitivo no Terminal
# ==============================================================================
# Motor: yt-dlp + spotdl + aria2c (16 conexões multi-threaded aceleradas) + ffmpeg
# Suporte: YouTube, Spotify, Twitter/X, Instagram, TikTok, Reddit, Twitch, Vimeo e +1.800 sites
# ==============================================================================

set -eo pipefail

# Diretórios Canônicos de Destino
if [ -d "/mnt/dados/05_Midias_Design_e_Criacao" ]; then
    DEFAULT_DEST_VIDEO="/mnt/dados/05_Midias_Design_e_Criacao/Videos/Downloads"
    DEFAULT_DEST_AUDIO="/mnt/dados/05_Midias_Design_e_Criacao/Musicas_e_Audios/Downloads"
else
    DEFAULT_DEST_VIDEO="$HOME/Videos/Downloads"
    DEFAULT_DEST_AUDIO="$HOME/Music/Downloads"
fi

CUSTOM_DIR=""

# Cores Catppuccin Mocha para Terminal
MAUVE='\033[38;2;203;166;247m'
BLUE='\033[38;2;137;180;250m'
GREEN='\033[38;2;166;227;161m'
PEACH='\033[38;2;250;179;135m'
RED='\033[38;2;243;139;168m'
TEXT='\033[38;2;205;214;244m'
SUBTEXT='\033[38;2;166;173;200m'
BOLD='\033[1m'
NC='\033[0m'

# Função para obter URL do Clipboard
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

# Aceleração multi-conexão via aria2c (estilo IDM / AB Download Manager)
get_downloader_args() {
    if command -v aria2c >/dev/null 2>&1; then
        echo "--downloader aria2c --downloader-args 'aria2c:-c -j 16 -x 16 -s 16 -k 1M --quiet=true'"
    fi
}

# Notificação interativa com botões de ação (Assistir/Ouvir / Abrir Pasta)
notify_completion() {
    local title="$1"
    local dest_dir="$2"

    if command -v notify-send >/dev/null 2>&1; then
        local action
        action=$(notify-send -a "Media Downloader" \
            -t 12000 \
            -A "play=▶️ Assistir / Ouvir Agora" \
            -A "folder=📂 Abrir Pasta" \
            "✅ Download Concluído!" \
            "$title") || true

        case "$action" in
            play)
                local latest_file
                latest_file=$(find "$dest_dir" -type f \( -name "*.mp3" -o -name "*.flac" -o -name "*.m4a" -o -name "*.mp4" -o -name "*.mkv" -o -name "*.webm" \) -printf '%T@ %p\n' 2>/dev/null | sort -n | tail -1 | cut -f2- -d" ")
                if [ -n "$latest_file" ]; then
                    xdg-open "$latest_file" &
                else
                    xdg-open "$dest_dir" &
                fi
                ;;
            folder)
                xdg-open "$dest_dir" &
                ;;
        esac
    fi
}

# ------------------------------------------------------------------------------
# MODO ROFI (Executado via SUPER + ALT + D)
# ------------------------------------------------------------------------------
run_rofi_mode() {
    local url=""
    local clip_url
    clip_url=$(get_clipboard_url)

    if [ -n "$clip_url" ]; then
        url="$clip_url"
    else
        url=$(rofi -dmenu -p "Cole a URL da Mídia" -theme-str 'entry { placeholder: "https://..."; }' </dev/null || true)
    fi

    if [ -z "$url" ] || [[ ! "$url" =~ ^https?:// ]]; then
        notify-send -u low "Download Cancelado" "Nenhuma URL válida fornecida."
        exit 0
    fi

    local dest_v="${CUSTOM_DIR:-$DEFAULT_DEST_VIDEO}"
    local dest_a="${CUSTOM_DIR:-$DEFAULT_DEST_AUDIO}"
    mkdir -p "$dest_v" "$dest_a"

    # Roteador específico para Spotify
    if [[ "$url" =~ (open\.spotify\.com|spotify:) ]]; then
        if ! command -v spotdl >/dev/null 2>&1; then
            notify-send -u critical -a "Media Downloader" "spotDL Não Encontrado" "Para baixar do Spotify, instale no terminal: yay -S spotdl"
            exit 1
        fi

        local sp_choice
        sp_choice=$(printf "🎵 MP3 320kbps (Capa Oficial + Tags + Letras .lrc)\n💎 FLAC Lossless (Qualidade Máxima sem Compressão)\n⚡ M4A AAC (Stream Nativo Rápido)" | rofi -dmenu -i -p "Formato Spotify" || true)

        if [ -z "$sp_choice" ]; then
            exit 0
        fi

        notify-send -u normal -a "Media Downloader" "🎵 Baixando do Spotify..." "Buscando metadados oficiais e áudio 320kbps..."

        case "$sp_choice" in
            *"MP3 320kbps"*)
                download_spotify "$url" "mp3" "$dest_a" "rofi"
                ;;
            *"FLAC"*)
                download_spotify "$url" "flac" "$dest_a" "rofi"
                ;;
            *"M4A"*)
                download_spotify "$url" "m4a" "$dest_a" "rofi"
                ;;
        esac
        exit 0
    fi

    local choice
    choice=$(printf "🎥 Vídeo MP4 (1080p/4K com Áudio & Legendas)\n🎵 Áudio MP3 (320kbps + Capa & Tags)\n⚡ Vídeo Leve (720p Rápido)" | rofi -dmenu -i -p "Formato de Download" || true)

    if [ -z "$choice" ]; then
        exit 0
    fi

    notify-send -u normal -a "Media Downloader" "📥 Download Iniciado..." "Conectando e baixando em segundo plano..."

    case "$choice" in
        *"Vídeo MP4"*)
            download_video "$url" "best" "$dest_v" "rofi"
            ;;
        *"Áudio MP3"*)
            download_audio "$url" "$dest_a" "rofi"
            ;;
        *"Vídeo Leve"*)
            download_video "$url" "720" "$dest_v" "rofi"
            ;;
    esac
}

# ------------------------------------------------------------------------------
# FUNÇÕES DE DOWNLOAD (YT-DLP)
# ------------------------------------------------------------------------------
download_video() {
    local url="$1"
    local quality="$2"
    local dest="$3"
    local mode="${4:-cli}"
    local dl_args
    dl_args=$(get_downloader_args)

    local format_str="bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b"
    if [ "$quality" == "720" ]; then
        format_str="bv*[height<=720][ext=mp4]+ba[ext=m4a]/b[height<=720] / bv*[height<=720]+ba/b"
    fi

    mkdir -p "$dest"
    cd "$dest"

    # Template inteligente: se for playlist, numera 01_ 02_ etc.
    local output_tpl="%(title)s [%(id)s].%(ext)s"
    if [[ "$url" =~ list= ]]; then
        output_tpl="%(playlist_index)02d - %(title)s.%(ext)s"
    fi

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
        "'$url'"

    local title
    title=$(yt-dlp --get-title "$url" 2>/dev/null | head -n1 || echo "Vídeo")

    notify_completion "$title" "$dest"
}

download_audio() {
    local url="$1"
    local dest="$2"
    local mode="${3:-cli}"
    local dl_args
    dl_args=$(get_downloader_args)

    mkdir -p "$dest"
    cd "$dest"

    local output_tpl="%(title)s [%(id)s].%(ext)s"
    if [[ "$url" =~ list= ]]; then
        output_tpl="%(playlist_index)02d - %(title)s.%(ext)s"
    fi

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
        "'$url'"

    local title
    title=$(yt-dlp --get-title "$url" 2>/dev/null | head -n1 || echo "Áudio")

    notify_completion "$title" "$dest"
}

# ------------------------------------------------------------------------------
# FUNÇÃO DE DOWNLOAD (SPOTIFY VIA SPOTDL)
# ------------------------------------------------------------------------------
download_spotify() {
    local url="$1"
    local format="${2:-mp3}"
    local dest="$3"
    local mode="${4:-cli}"

    mkdir -p "$dest"
    cd "$dest"

    # Template inteligente de organização:
    # Se for álbum: cria subpasta com nome do Álbum e numera as faixas
    # Se for playlist: cria subpasta com nome da Playlist e numera as faixas
    # Se for faixa única: salva diretamente na pasta raiz de músicas
    local output_tpl="{artist} - {title}.{output-ext}"
    if [[ "$url" =~ /album/ ]]; then
        output_tpl="{album}/{track-number} - {artist} - {title}.{output-ext}"
    elif [[ "$url" =~ /playlist/ ]]; then
        output_tpl="{playlist}/{track-number} - {artist} - {title}.{output-ext}"
    fi

    local bitrate_flag="--bitrate 320k"
    if [ "$format" == "flac" ]; then
        bitrate_flag="--bitrate disable"
    fi

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
            --generate-lrc
    fi

    notify_completion "Spotify: Música/Álbum Baixado" "$dest"
}

# ------------------------------------------------------------------------------
# MODO INTERATIVO DE TERMINAL (CLI)
# ------------------------------------------------------------------------------
run_cli_mode() {
    local url="$1"
    local dest_v="${CUSTOM_DIR:-$DEFAULT_DEST_VIDEO}"
    local dest_a="${CUSTOM_DIR:-$DEFAULT_DEST_AUDIO}"

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
            echo -e "${PEACH}Cole ou digite a URL do vídeo/áudio:${NC}"
            read -rp "URL: " url
        fi
    fi

    if [ -z "$url" ] || [[ ! "$url" =~ ^https?:// ]]; then
        echo -e "\n${RED}❌ URL inválida ou vazia.${NC}"
        exit 1
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

        local dest_target="${CUSTOM_DIR:-$dest_a}"
        echo -e "${BLUE}📂 Pasta de Destino:${NC} ${dest_target}"
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
                download_spotify "$url" "mp3" "$dest_target" "cli"
                ;;
            2)
                echo -e "\n${GREEN}💎 Baixando do Spotify em FLAC Lossless...${NC}\n"
                download_spotify "$url" "flac" "$dest_target" "cli"
                ;;
            3)
                echo -e "\n${PEACH}⚡ Baixando do Spotify em M4A AAC...${NC}\n"
                download_spotify "$url" "m4a" "$dest_target" "cli"
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
    echo -e "  ${RED}[q]${NC} Cancelar"
    echo ""
    read -rp "Opção [1-3, padrão: 1]: " opt
    opt="${opt:-1}"

    case "$opt" in
        1)
            echo -e "\n${BLUE}🚀 Baixando com 16 conexões paralelas e legendas...${NC}\n"
            download_video "$url" "best" "$dest_v" "cli"
            ;;
        2)
            echo -e "\n${GREEN}🎵 Extraindo áudio em MP3 320kbps com capa...${NC}\n"
            download_audio "$url" "$dest_a" "cli"
            ;;
        3)
            echo -e "\n${PEACH}⚡ Baixando vídeo leve 720p...${NC}\n"
            download_video "$url" "720" "$dest_v" "cli"
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
# ROTEADOR DE PARÂMETROS
# ------------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
    case "$1" in
        --rofi)
            MODE="rofi"
            shift
            ;;
        --dir)
            CUSTOM_DIR="$2"
            shift 2
            ;;
        *)
            TARGET_URL="$1"
            shift
            ;;
    esac
done

if [ "$MODE" == "rofi" ]; then
    run_rofi_mode
else
    run_cli_mode "$TARGET_URL"
fi
