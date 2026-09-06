#!/usr/bin/env bash
# ==============================================================================
# 🎮 MediaControl.sh - Controle de Mídia com Feedback Visual OSD em Tempo Real
# Suporte a Spotify / MPRIS com Capa do Álbum e Notificações Rápidas no SwayNC
# ==============================================================================

set -euo pipefail

ACTION="${1:---play-pause}"
COVER_DIR="/tmp/mpris_covers"
mkdir -p "$COVER_DIR"

DEFAULT_ICON="$HOME/.config/swaync/icons/music.png"
[ -f "$DEFAULT_ICON" ] || DEFAULT_ICON="media-playback-start"

# Prioriza Spotify se estiver em execução, para evitar colisão com vídeos do YouTube
TARGET_PLAYER=""
if playerctl -l 2>/dev/null | grep -qi "spotify"; then
    TARGET_PLAYER="-p spotify"
fi

# 1. Executar a ação de mídia solicitada
case "$ACTION" in
    --play-pause|play-pause|-p)
        if [[ -n "$TARGET_PLAYER" ]]; then
            playerctl $TARGET_PLAYER play-pause 2>/dev/null || playerctl play-pause 2>/dev/null || true
        else
            playerctl play-pause 2>/dev/null || true
        fi
        ;;
    --next|next|-n)
        if [[ -n "$TARGET_PLAYER" ]]; then
            playerctl $TARGET_PLAYER next 2>/dev/null || playerctl next 2>/dev/null || true
        else
            playerctl next 2>/dev/null || true
        fi
        ;;
    --prev|--previous|prev|previous)
        if [[ -n "$TARGET_PLAYER" ]]; then
            playerctl $TARGET_PLAYER previous 2>/dev/null || playerctl previous 2>/dev/null || true
        else
            playerctl previous 2>/dev/null || true
        fi
        ;;
    --stop|stop)
        if [[ -n "$TARGET_PLAYER" ]]; then
            playerctl $TARGET_PLAYER stop 2>/dev/null || playerctl stop 2>/dev/null || true
        else
            playerctl stop 2>/dev/null || true
        fi
        ;;
    *)
        echo "Uso: $0 [--play-pause|--next|--prev|--stop]"
        exit 1
        ;;
esac

# 2. Aguarda um milissegundo para o player atualizar seu estado interno via D-Bus
sleep 0.12

# 3. Obter estado atual do player
STATUS=$(playerctl $TARGET_PLAYER status 2>/dev/null || playerctl status 2>/dev/null || echo "Desconhecido")
if [[ "$STATUS" == "Desconhecido" ]]; then
    notify-send -e -u low -t 1500 \
        -h string:x-canonical-private-synchronous:spotify-osd \
        -a "Spotify OSD" \
        "󰎆  Mídia" "Nenhum player ativo no momento"
    exit 0
fi

# 4. Obter metadados
TITLE=$(playerctl $TARGET_PLAYER metadata --format '{{markup_escape(title)}}' 2>/dev/null || playerctl metadata --format '{{markup_escape(title)}}' 2>/dev/null || echo "Sem título")
ARTIST=$(playerctl $TARGET_PLAYER metadata --format '{{markup_escape(artist)}}' 2>/dev/null || playerctl metadata --format '{{markup_escape(artist)}}' 2>/dev/null || echo "Desconhecido")
ALBUM=$(playerctl $TARGET_PLAYER metadata --format '{{markup_escape(album)}}' 2>/dev/null || playerctl metadata --format '{{markup_escape(album)}}' 2>/dev/null || echo "")
ART_URL=$(playerctl $TARGET_PLAYER metadata --format '{{mpris:artUrl}}' 2>/dev/null || playerctl metadata --format '{{mpris:artUrl}}' 2>/dev/null || echo "")

# Truncar título e artista se forem excessivamente longos
[ ${#TITLE} -gt 42 ] && TITLE="${TITLE:0:39}..."
[ ${#ARTIST} -gt 35 ] && ARTIST="${ARTIST:0:32}..."

# 5. Localizar ou baixar a capa
COVER_PATH="$DEFAULT_ICON"
if [[ "$ART_URL" =~ ^https?:// ]]; then
    HASH=$(printf '%s' "$ART_URL" | md5sum | cut -d' ' -f1)
    COVER_FILE="$COVER_DIR/${HASH}.png"
    if [[ ! -s "$COVER_FILE" ]]; then
        curl -s -L --max-time 2 "$ART_URL" -o "$COVER_FILE" 2>/dev/null || true
    fi
    if [[ -s "$COVER_FILE" ]]; then
        COVER_PATH="$COVER_FILE"
    fi
elif [[ "$ART_URL" =~ ^file:// ]]; then
    LOCAL_PATH="${ART_URL#file://}"
    if [[ -f "$LOCAL_PATH" ]]; then
        COVER_PATH="$LOCAL_PATH"
    fi
fi

# 6. Definir ícone e texto de cabeçalho com base na ação e status
case "$ACTION" in
    --play-pause|play-pause|-p)
        if [[ "$STATUS" == "Playing" ]]; then
            HEADER="▶️  Reproduzindo"
        else
            HEADER="⏸️  Pausado"
        fi
        ;;
    --next|next|-n)
        HEADER="⏭️  Próxima Faixa"
        ;;
    --prev|--previous|prev|previous)
        HEADER="⏮️  Faixa Anterior"
        ;;
    --stop|stop)
        HEADER="⏹️  Parado"
        ;;
esac

# Se estiver em pausa em next/prev, indica o estado
if [[ "$ACTION" != "--play-pause" && "$STATUS" == "Paused" ]]; then
    HEADER="$HEADER (Pausado)"
fi

# 7. Disparar notificação OSD síncrona com substituição imediata no SwayNC
notify-send -e -u low -t 1800 \
    -h string:x-canonical-private-synchronous:spotify-osd \
    -a "Spotify OSD" \
    -i "$COVER_PATH" \
    "$HEADER" \
    "<b>$TITLE</b>\n<span color='#b4befe'>$ARTIST</span>"
