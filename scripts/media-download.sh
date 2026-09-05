#!/usr/bin/env bash
# ==============================================================================
# 📥 MEDIA DOWNLOADER POWER-USER — O Download Manager Definitivo no Terminal
# ==============================================================================
# Motor: yt-dlp + aria2c (16 conexões multi-threaded aceleradas) + ffmpeg
# Suporte: YouTube, Twitter/X, Instagram, TikTok, Reddit, Twitch, Vimeo e +1.800 sites
# ==============================================================================

set -eo pipefail

# Diretórios Canônicos de Destino
if [ -d "/mnt/dados/05_Midias_Design_e_Criacao" ]; then
    DEST_VIDEO="/mnt/dados/05_Midias_Design_e_Criacao/Videos/Downloads"
    DEST_AUDIO="/mnt/dados/05_Midias_Design_e_Criacao/Musicas_e_Audios/Downloads"
else
    DEST_VIDEO="$HOME/Videos/Downloads"
    DEST_AUDIO="$HOME/Music/Downloads"
fi

mkdir -p "$DEST_VIDEO" "$DEST_AUDIO"

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
        url=$(rofi -dmenu -p "Cole a URL do Vídeo" -theme-str 'entry { placeholder: "https://..."; }' </dev/null || true)
    fi

    if [ -z "$url" ] || [[ ! "$url" =~ ^https?:// ]]; then
        notify-send -u low "Download Cancelado" "Nenhuma URL válida fornecida."
        exit 0
    fi

    local choice
    choice=$(printf "🎥 Vídeo MP4 (1080p/4K Melhor Qualidade)\n🎵 Áudio MP3 (320kbps + Capa)\n⚡ Vídeo Leve (720p Rápido)" | rofi -dmenu -i -p "Formato de Download" || true)

    if [ -z "$choice" ]; then
        exit 0
    fi

    notify-send -u normal "📥 Download Iniciado" "Processando: $url"

    case "$choice" in
        *"Vídeo MP4"*)
            download_video "$url" "best" "$DEST_VIDEO" "rofi"
            ;;
        *"Áudio MP3"*)
            download_audio "$url" "$DEST_AUDIO" "rofi"
            ;;
        *"Vídeo Leve"*)
            download_video "$url" "720" "$DEST_VIDEO" "rofi"
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

    cd "$dest"
    
    # Execução do download
    eval yt-dlp \
        $dl_args \
        -f "'$format_str'" \
        --merge-output-format mp4 \
        --embed-thumbnail \
        --embed-metadata \
        --embed-chapters \
        -o "'%(title)s [%(id)s].%(ext)s'" \
        --windows-filenames \
        --no-mtime \
        "'$url'"

    local title
    title=$(yt-dlp --get-title "$url" 2>/dev/null | head -n1 || echo "Vídeo")
    
    notify-send -u normal -a "Media Downloader" "✅ Download Concluído!" "$title salvo em:\n$dest"
}

download_audio() {
    local url="$1"
    local dest="$2"
    local mode="${3:-cli}"
    local dl_args
    dl_args=$(get_downloader_args)

    cd "$dest"

    eval yt-dlp \
        $dl_args \
        -x \
        --audio-format mp3 \
        --audio-quality 0 \
        --embed-thumbnail \
        --add-metadata \
        -o "'%(title)s [%(id)s].%(ext)s'" \
        --windows-filenames \
        --no-mtime \
        "'$url'"

    local title
    title=$(yt-dlp --get-title "$url" 2>/dev/null | head -n1 || echo "Áudio")

    notify-send -u normal -a "Media Downloader" "🎵 Áudio Baixado com Sucesso!" "$title salvo em:\n$dest"
}

# ------------------------------------------------------------------------------
# MODO INTERATIVO DE TERMINAL (CLI)
# ------------------------------------------------------------------------------
run_cli_mode() {
    local url="$1"

    clear
    echo -e "${MAUVE}${BOLD}╭───────────────────────────────────────────────────────────────╮${NC}"
    echo -e "${MAUVE}${BOLD}│       📥 MEDIA DOWNLOADER POWER-USER (yt-dlp + aria2c)       │${NC}"
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

    echo ""
    echo -e "${SUBTEXT}🔍 Conectando e obtendo dados do vídeo...${NC}"
    local info_title
    info_title=$(yt-dlp --get-title "$url" 2>/dev/null | head -n1 || echo "Mídia Online")
    echo -e "${GREEN}🎬 Título:${NC} ${BOLD}${info_title}${NC}"
    echo ""

    echo -e "${BOLD}Escolha o Formato de Download:${NC}"
    echo -e "  ${BLUE}[1]${NC} 🎥 Melhor Qualidade MP4 (1080p / 2K / 4K com áudio AAC)"
    echo -e "  ${GREEN}[2]${NC} 🎵 Apenas Áudio MP3 (320kbps + Capa + Tags ID3)"
    echo -e "  ${PEACH}[3]${NC} ⚡ Rápido e Leve (720p balanceado)"
    echo -e "  ${RED}[q]${NC} Cancelar"
    echo ""
    read -rp "Opção [1-3, padrão: 1]: " opt
    opt="${opt:-1}"

    case "$opt" in
        1)
            echo -e "\n${BLUE}🚀 Baixando vídeo em alta qualidade com 16 conexões paralelas...${NC}\n"
            download_video "$url" "best" "$DEST_VIDEO" "cli"
            ;;
        2)
            echo -e "\n${GREEN}🎵 Extraindo áudio em MP3 320kbps com capa...${NC}\n"
            download_audio "$url" "$DEST_AUDIO" "cli"
            ;;
        3)
            echo -e "\n${PEACH}⚡ Baixando vídeo leve 720p...${NC}\n"
            download_video "$url" "720" "$DEST_VIDEO" "cli"
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
# ROTEADOR DE ENTRADA
# ------------------------------------------------------------------------------
if [ "$1" == "--rofi" ]; then
    run_rofi_mode
else
    run_cli_mode "$1"
fi
