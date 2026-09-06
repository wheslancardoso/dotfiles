#!/usr/bin/env bash
# ==============================================================================
# 📋 CopyQ Smart Toggle — Multi-monitor & Active Workspace Integration
# ==============================================================================

# Ensure copyq daemon is running
if ! pgrep -x copyq > /dev/null 2>&1; then
    copyq &
    sleep 0.3
fi

IS_VISIBLE=$(copyq eval 'print(visible())' 2>/dev/null)

if [ "$IS_VISIBLE" = "true" ]; then
    copyq hide
else
    copyq show
    sleep 0.05
    hyprctl dispatch movetoworkspace "current,class:^(com\.github\.hluk\.copyq|copyq|CopyQ)$" >/dev/null 2>&1
    hyprctl dispatch focuswindow "class:^(com\.github\.hluk\.copyq|copyq|CopyQ)$" >/dev/null 2>&1
    hyprctl dispatch centerwindow >/dev/null 2>&1
    hyprctl dispatch bringactivetotop >/dev/null 2>&1
fi
