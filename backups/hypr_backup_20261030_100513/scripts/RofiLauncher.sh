#!/usr/bin/env bash
# /* ---- 🚀 Ultra-fast Rofi Launcher with Instant Toggle & Vim Keys ---- */
# Eliminates race conditions and multiple keybind conflicts.

MODE="${1:-drun}"
THEME="${2:-}"

# Expand tilde in THEME if present
if [[ "$THEME" =~ ^~.* ]]; then
    THEME="${THEME/#\~/$HOME}"
fi

# If Rofi is running, close it instantly and exit
if pgrep -x rofi >/dev/null 2>&1; then
    killall -q rofi
    exit 0
fi

# Launch Rofi cleanly with exec
if [ "$MODE" = "window" ]; then
    if [ -n "$THEME" ] && [ -f "$THEME" ]; then
        exec rofi -show window -theme "$THEME"
    else
        exec rofi -show window
    fi
else
    if [ -n "$THEME" ] && [ -f "$THEME" ]; then
        exec rofi -show "$MODE" -modi drun,filebrowser,run,window -theme "$THEME"
    else
        exec rofi -show "$MODE" -modi drun,filebrowser,run,window
    fi
fi
