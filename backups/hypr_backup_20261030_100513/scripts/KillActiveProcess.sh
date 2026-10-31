#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##

# Copied from Discord post. Thanks to @Zorg


# Get id of an active window
active_pid=$(hyprctl activewindow | grep -o 'pid: [0-9]*' | cut -d' ' -f2)

if [[ -z "$active_pid" || ! "$active_pid" =~ ^[0-9]+$ ]]; then
  notify-send -u low -i "$HOME/.config/swaync/images/error.png" "Kill Active Window" "No active window PID found."
  exit 1
fi

# Encerra o processo ativo (SIGTERM imediato com garantia de SIGKILL -9 para apps travados)
kill "$active_pid" 2>/dev/null || true
(
  sleep 0.2
  if kill -0 "$active_pid" 2>/dev/null; then
    kill -9 "$active_pid" 2>/dev/null || true
  fi
) &

notify-send -u low -t 1500 -i "$HOME/.config/swaync/icons/close.png" "Processo Finalizado" "PID $active_pid aniquilado com sucesso."
