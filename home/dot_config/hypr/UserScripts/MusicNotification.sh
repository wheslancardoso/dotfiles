#!/usr/bin/env bash
# 🎵 Music Notification Daemon for Hyprland & SwayNC
# Detects Spotify / MPRIS track changes and shows a rich notification with Album Art

COVER_DIR="/tmp/mpris_covers"
mkdir -p "$COVER_DIR"

DEFAULT_ICON="$HOME/.config/swaync/icons/music.png"
LAST_SONG=""

escape_xml() {
    local s="$1"
    s="${s//&/&amp;}"
    s="${s//</&lt;}"
    s="${s//>/&gt;}"
    printf '%s' "$s"
}

notify_track() {
    local status="$1"
    local title="$2"
    local artist="$3"
    local album="$4"
    local art_url="$5"

    [[ "$status" != "Playing" || -z "$title" ]] && return 0
    [[ "$title" == "$LAST_SONG" ]] && return 0

    LAST_SONG="$title"
    local cover_path="$DEFAULT_ICON"

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
    safe_artist=$(escape_xml "$artist")
    safe_album=$(escape_xml "$album")

    notify-send \
        -a "Spotify" \
        -i "$cover_path" \
        -u normal \
        -h string:x-canonical-private-synchronous:music_notif \
        "🎵 Now Playing" \
        "<b>${safe_title}</b>\n👤 ${safe_artist}${safe_album:+<br>💿 ${safe_album}}"
}

# Notifica faixa atual se já estiver tocando
curr_meta=$(playerctl metadata --format "{{status}}	{{title}}	{{artist}}	{{album}}	{{mpris:artUrl}}" 2>/dev/null || true)
if [[ -n "$curr_meta" ]]; then
    IFS=$'\t' read -r c_status c_title c_artist c_album c_art <<< "$curr_meta"
    notify_track "$c_status" "$c_title" "$c_artist" "$c_album" "$c_art"
fi

# Escuta mudanças em tempo real com buffer de linha (stdbuf -oL)
stdbuf -oL playerctl --follow metadata --format "{{status}}	{{title}}	{{artist}}	{{album}}	{{mpris:artUrl}}" 2>/dev/null | while IFS=$'\t' read -r status title artist album art_url; do
    notify_track "$status" "$title" "$artist" "$album" "$art_url"
done
