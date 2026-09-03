#!/usr/bin/env bash
# 🎵 Music Notification Daemon for Hyprland & SwayNC
# Detects Spotify / MPRIS track changes and shows a rich notification with Album Art

COVER_DIR="/tmp/mpris_covers"
mkdir -p "$COVER_DIR"

LAST_SONG=""

# Fallback default icon
DEFAULT_ICON="$HOME/.config/swaync/icons/music.png"

# Listen to player events
playerctl --follow metadata --format "{{status}}::{{title}}::{{artist}}::{{album}}::{{mpris:artUrl}}" 2>/dev/null | while IFS= read -r line; do
    status=$(echo "$line" | awk -F "::" '{print $1}')
    title=$(echo "$line" | awk -F "::" '{print $2}')
    artist=$(echo "$line" | awk -F "::" '{print $3}')
    album=$(echo "$line" | awk -F "::" '{print $4}')
    art_url=$(echo "$line" | awk -F "::" '{print $5}')

    # Only notify when song is playing and track changed
    if [[ "$status" == "Playing" && -n "$title" && "$title" != "$LAST_SONG" ]]; then
        LAST_SONG="$title"
        cover_path="$DEFAULT_ICON"

        # Download or resolve album art
        if [[ "$art_url" =~ ^https?:// ]]; then
            cover_file="$COVER_DIR/current_cover.png"
            if curl -s -L "$art_url" -o "$cover_file" 2>/dev/null && [ -s "$cover_file" ]; then
                cover_path="$cover_file"
            fi
        elif [[ "$art_url" =~ ^file:// ]]; then
            local_path="${art_url#file://}"
            if [ -f "$local_path" ]; then
                cover_path="$local_path"
            fi
        fi

        # Escape XML entities for notify-send markup
        safe_title=$(echo "$title" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')
        safe_artist=$(echo "$artist" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')
        safe_album=$(echo "$album" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')

        # Send rich notification (synchronous replaces previous notification seamlessly)
        notify-send \
            -a "Spotify" \
            -i "$cover_path" \
            -h string:x-canonical-private-synchronous:music_notif \
            -h string:urgency:low \
            "🎵 Now Playing" \
            "<b>$safe_title</b>\n👤 $safe_artist${safe_album:+<br>💿 $safe_album}"
    fi
done
