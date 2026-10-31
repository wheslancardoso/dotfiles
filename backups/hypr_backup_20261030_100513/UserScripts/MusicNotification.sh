#!/usr/bin/env bash
# ==============================================================================
# 🎵 Rich Music Notification Daemon (Spotify & MPRIS Apex Edition)
# Grid layout com capa 88x88 à esquerda e metadados estruturados à direita
# ==============================================================================

COVER_DIR="/tmp/mpris_covers"
mkdir -p "$COVER_DIR"

DEFAULT_ICON="$HOME/.config/swaync/icons/music.png"
LAST_TRACK_ID=""

escape_xml() {
    local s="$1"
    s="${s//&/&amp;}"
    s="${s//</&lt;}"
    s="${s//>/&gt;}"
    s="${s//\"/&quot;}"
    s="${s//\'/&apos;}"
    printf '%s' "$s"
}

notify_track() {
    local status="$1"
    local title="$2"
    local artist="$3"
    local album="$4"
    local art_url="$5"
    local player="${6:-spotify}"

    [[ "$status" != "Playing" || -z "$title" ]] && return 0

    # Evita notificações duplicadas para a mesma faixa
    local track_id="${title}__${artist}"
    [[ "$track_id" == "$LAST_TRACK_ID" ]] && return 0
    LAST_TRACK_ID="$track_id"

    local cover_path="$DEFAULT_ICON"

    # Baixa ou localiza a arte da capa em alta resolução
    if [[ "$art_url" =~ ^https?:// ]]; then
        local hash
        hash=$(printf '%s' "$art_url" | md5sum | cut -d' ' -f1)
        local cover_file="$COVER_DIR/${hash}.png"
        if [[ ! -s "$cover_file" ]]; then
            curl -s -L --max-time 3 "$art_url" -o "$cover_file" 2>/dev/null || true
        fi
        if [[ -s "$cover_file" ]]; then
            cover_path="$cover_file"
        fi
    elif [[ "$art_url" =~ ^file:// ]]; then
        local local_path="${art_url#file://}"
        if [[ -f "$local_path" ]]; then
            cover_path="$local_path"
        fi
    fi

    local safe_title safe_artist safe_album
    safe_title=$(escape_xml "$title")
    safe_artist=$(escape_xml "${artist:-Desconhecido}")
    safe_album=$(escape_xml "${album:-Single}")

    # Trunca títulos excessivamente longos para manter o grid perfeito
    if [ ${#safe_title} -gt 40 ]; then
        safe_title="${safe_title:0:37}..."
    fi
    if [ ${#safe_artist} -gt 34 ]; then
        safe_artist="${safe_artist:0:31}..."
    fi
    if [ ${#safe_album} -gt 34 ]; then
        safe_album="${safe_album:0:31}..."
    fi

    # Distinção Dinâmica de Layout e Identidade por Aplicativo
    if [[ "$player" == "spotify" ]]; then
        # 🎵 SPOTIFY: Layout Completo e Rico de Música (Artista | Álbum | Status)
        local body_grid
        body_grid="<span font_family='JetBrains Mono Nerd Font' size='9500'>"
        body_grid+="<span color='#89b4fa'>󰠃 Artista</span> <span color='#6c7086'>│</span> <span color='#cdd6f4' weight='bold'>${safe_artist}</span>\n"
        body_grid+="<span color='#f9e2af'>󰀥 Álbum  </span> <span color='#6c7086'>│</span> <span color='#bac2de'>${safe_album}</span>\n"
        body_grid+="<span color='#a6e3a1'> Spotify</span> <span color='#6c7086'>│</span> <span color='#a6e3a1' weight='bold'>Tocando Agora</span>"
        body_grid+="</span>"

        notify-send \
            -a "Spotify" \
            -i "$cover_path" \
            -u normal \
            -t 5000 \
            -h string:x-canonical-private-synchronous:music_notif \
            "$safe_title" \
            "$body_grid"

    elif [[ "$player" =~ (brave|firefox|chrome|chromium) ]]; then
        # 📺 YOUTUBE / NAVEGADOR: Layout Especial para Vídeo Web (Sem tags falsas de álbum)
        local body_yt
        body_yt="<span font_family='JetBrains Mono Nerd Font' size='9500'>"
        if [[ -n "$safe_artist" && "$safe_artist" != "Desconhecido" ]]; then
            body_yt+="<span color='#f38ba8'>󰗃 Canal  </span> <span color='#6c7086'>│</span> <span color='#cdd6f4' weight='bold'>${safe_artist}</span>\n"
        fi
        body_yt+="<span color='#f38ba8'>󰗃 YouTube</span> <span color='#6c7086'>│</span> <span color='#f9e2af' weight='bold'>Vídeo no Navegador</span>"
        body_yt+="</span>"

        notify-send \
            -a "YouTube" \
            -i "$cover_path" \
            -u low \
            -t 4000 \
            -h string:x-canonical-private-synchronous:youtube_media \
            "$safe_title" \
            "$body_yt"

    else
        # 󰕼 REPRODUTOR DE VÍDEO LOCAL (MPV, VLC)
        local body_video
        body_video="<span font_family='JetBrains Mono Nerd Font' size='9500'>"
        body_video+="<span color='#f9e2af'>󰕼 Player </span> <span color='#6c7086'>│</span> <span color='#cdd6f4' weight='bold'>${player}</span>"
        body_video+="</span>"

        notify-send \
            -a "Video" \
            -i "$cover_path" \
            -u low \
            -t 3500 \
            -h string:x-canonical-private-synchronous:video_media \
            "$safe_title" \
            "$body_video"
    fi
}

# Notifica faixa atual se já estiver tocando
curr_meta=$(playerctl metadata --format "{{status}}	{{title}}	{{artist}}	{{album}}	{{mpris:artUrl}}	{{playerName}}" 2>/dev/null || true)
if [[ -n "$curr_meta" ]]; then
    IFS=$'\t' read -r c_status c_title c_artist c_album c_art c_player <<< "$curr_meta"
    notify_track "$c_status" "$c_title" "$c_artist" "$c_album" "$c_art" "$c_player"
fi

# Escuta mudanças em tempo real com buffer de linha (stdbuf -oL)
stdbuf -oL playerctl --follow metadata --format "{{status}}	{{title}}	{{artist}}	{{album}}	{{mpris:artUrl}}	{{playerName}}" 2>/dev/null | while IFS=$'\t' read -r status title artist album art_url player; do
    notify_track "$status" "$title" "$artist" "$album" "$art_url" "$player"
done
