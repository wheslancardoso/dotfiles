#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */
# wlogout (Power, Screen Lock, Suspend, etc) - Modern Dynamic Sizing & Single-Instance Lock

# Instant toggle: se o wlogout já estiver rodando, fecha imediatamente e sai
if pgrep -x "wlogout" > /dev/null; then
    pkill -x "wlogout"
    exit 0
fi

# Evita duplicação por clique rápido ou duplo acionamento de tecla (mutex lock)
LOCK_FILE="/tmp/wlogout_launch.lock"
exec 200>"$LOCK_FILE"
if ! flock -n 200; then
    exit 0
fi

# Detecta resolução e escala do monitor focado
resolution=$(hyprctl -j monitors 2>/dev/null | jq -r '.[] | select(.focused==true) | .height / .scale' 2>/dev/null | awk -F'.' '{print $1}')
res_width=$(hyprctl -j monitors 2>/dev/null | jq -r '.[] | select(.focused==true) | .width / .scale' 2>/dev/null | awk -F'.' '{print $1}')

# Fallbacks de segurança se hyprctl não retornar valores válidos
if [[ -z "$resolution" || "$resolution" -le 0 ]]; then
    resolution=1080
fi
if [[ -z "$res_width" || "$res_width" -le 0 ]]; then
    res_width=1920
fi

# Ajuste responsivo de proporções e margens
if (( res_width >= resolution )); then
    # Modo Paisagem: Sempre 6 botões elegantes em 1 única linha centralizada
    cols=6

    # Altura ideal do dock (~22% a 25% da altura da tela, entre 170px e 360px)
    target_dock_h=$(awk "BEGIN { h = int($resolution * 0.24); if (h < 170) h = 170; if (h > 360) h = 360; print h }")
    T_val=$(awk "BEGIN { print int(($resolution - $target_dock_h) / 2) }")
    B_val=$T_val

    # Largura ideal do dock (~75% a 80% da largura, com teto de 1300px para ultrawide)
    target_dock_w=$(awk "BEGIN { w = int($res_width * 0.78); if (w > 1300) w = 1300; if (w < 820 && $res_width >= 900) w = int($res_width * 0.90); print w }")
    L_val=$(awk "BEGIN { print int(($res_width - $target_dock_w) / 2) }")
    R_val=$L_val

    wlogout --protocol layer-shell -b $cols -c 14 -r 14 -T "$T_val" -B "$B_val" -L "$L_val" -R "$R_val" &
else
    # Modo Retrato: 2 botões por linha centralizados
    cols=2
    target_dock_h=$(awk "BEGIN { h = int($resolution * 0.45); if (h < 350) h = 350; print h }")
    T_val=$(awk "BEGIN { print int(($resolution - $target_dock_h) / 2) }")
    B_val=$T_val
    L_val=40
    R_val=40

    wlogout --protocol layer-shell -b $cols -c 12 -r 12 -T "$T_val" -B "$B_val" -L "$L_val" -R "$R_val" &
fi
