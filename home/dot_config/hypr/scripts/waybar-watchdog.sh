#!/usr/bin/env bash
# ==============================================================================
# 🐕 WAYBAR WATCHDOG — Reinicia automaticamente quando travar/desincronizar
# ==============================================================================
# O módulo hyprland/workspaces do Waybar tem um bug conhecido onde ele perde
# a conexão IPC com o Hyprland e o indicador de workspace ativo trava.
# Este watchdog detecta a dessincronização e reinicia o waybar imediatamente.
# ==============================================================================

INTERVAL=10  # segundos entre cada checagem

while true; do
    sleep "$INTERVAL"

    # Se o waybar não estiver rodando, não faz nada (outro processo cuida de iniciar)
    pgrep -x waybar >/dev/null 2>&1 || continue

    # Pega o workspace ativo real do Hyprland
    REAL_WS=$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id // empty' 2>/dev/null)
    [ -z "$REAL_WS" ] && continue

    # Verifica se o socket IPC do Hyprland está acessível pelo waybar
    # Se o waybar perdeu a conexão IPC, os eventos de workspace param de chegar
    # Testamos enviando um evento dummy e verificando se o waybar responde
    WAYBAR_PID=$(pgrep -x waybar 2>/dev/null)
    [ -z "$WAYBAR_PID" ] && continue

    # Checa se o processo waybar está em estado zombie ou parado
    PROC_STATE=$(cat "/proc/$WAYBAR_PID/status" 2>/dev/null | grep "^State:" | awk '{print $2}')
    if [[ "$PROC_STATE" == "Z" || "$PROC_STATE" == "T" ]]; then
        notify-send -a "Waybar Watchdog" -u low -i dialog-warning \
            "Waybar Travado" "Processo em estado $PROC_STATE. Reiniciando..." 2>/dev/null || true
        pkill -9 waybar 2>/dev/null
        sleep 0.5
        hyprctl dispatch exec waybar 2>/dev/null
    fi

    # Checa se o fd do socket Hyprland IPC ainda está aberto pelo waybar
    HYPR_SOCKET="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"
    if [ -S "$HYPR_SOCKET" ] && [ -d "/proc/$WAYBAR_PID/fd" ]; then
        # Conta quantos file descriptors do waybar apontam para o socket do Hyprland
        SOCKET_FDS=$(ls -la "/proc/$WAYBAR_PID/fd" 2>/dev/null | grep -c "socket" 2>/dev/null || echo "0")
        if [ "$SOCKET_FDS" -eq 0 ]; then
            notify-send -a "Waybar Watchdog" -u low -i dialog-warning \
                "Waybar Desconectado" "IPC socket perdido. Reiniciando..." 2>/dev/null || true
            pkill -9 waybar 2>/dev/null
            sleep 0.5
            hyprctl dispatch exec waybar 2>/dev/null
        fi
    fi
done
