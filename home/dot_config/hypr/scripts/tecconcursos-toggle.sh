#!/usr/bin/env bash
# ==============================================================================
# 🎯 TECCONCURSOS DROPDOWN SCRATCHPAD PARA HYPRLAND
# ==============================================================================
# Alterna instantaneamente o TecConcursos no special workspace 'tecconcursos'.
# Abre em modo WebApp dedicado centralizado, sem barras de navegador.
# ==============================================================================

set -euo pipefail

LOCKFILE="/tmp/tecconcursos-toggle.lock"
exec 200>"$LOCKFILE"
if ! flock -n 200; then
    exit 0
fi

# Monitor focado atualmente
current_mon=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

# Verifica se special:tecconcursos está ativo em QUALQUER monitor
active_mon=$(hyprctl monitors -j | jq -r '.[] | select(.specialWorkspace.name == "special:tecconcursos") | .name')

if [[ -n "$active_mon" ]]; then
    # O scratchpad está visível! Vamos ocultar
    if [[ "$active_mon" == "$current_mon" ]]; then
        hyprctl dispatch togglespecialworkspace tecconcursos
    else
        hyprctl dispatch focusmonitor "$active_mon"
        hyprctl dispatch togglespecialworkspace tecconcursos
        hyprctl dispatch focusmonitor "$current_mon"
    fi
    exit 0
fi

# Se não está visível, verifica se a janela do TecConcursos está rodando
tec_addr=$(hyprctl clients -j | jq -r '.[] | select(.class | test("brave-www.tecconcursos|tecconcursos"; "i")) | .address' | head -n 1)

if [[ -z "$tec_addr" ]]; then
    # Inicia o TecConcursos em modo App no workspace especial silencioso
    if command -v brave &>/dev/null; then
        hyprctl dispatch exec "[workspace special:tecconcursos silent] brave --app=https://www.tecconcursos.com.br/questoes/cadernos --class=tecconcursos"
    elif command -v google-chrome-stable &>/dev/null; then
        hyprctl dispatch exec "[workspace special:tecconcursos silent] google-chrome-stable --app=https://www.tecconcursos.com.br/questoes/cadernos --class=tecconcursos"
    elif command -v chromium &>/dev/null; then
        hyprctl dispatch exec "[workspace special:tecconcursos silent] chromium --app=https://www.tecconcursos.com.br/questoes/cadernos --class=tecconcursos"
    elif command -v firefox &>/dev/null; then
        hyprctl dispatch exec "[workspace special:tecconcursos silent] firefox --new-window https://www.tecconcursos.com.br/questoes/cadernos"
    else
        notify-send -a "TecConcursos" -i "dialog-error" "Navegador não encontrado" "Instale o Brave ou Chrome."
        exit 1
    fi

    # Aguarda a janela aparecer (até 3.5 segundos)
    for _ in {1..25}; do
        sleep 0.15
        tec_addr=$(hyprctl clients -j | jq -r '.[] | select(.class | test("brave-www.tecconcursos|tecconcursos"; "i")) | .address' | head -n 1)
        if [[ -n "$tec_addr" ]]; then
            break
        fi
    done
fi

# Garante que a janela vá para o special:tecconcursos e seja exibida no monitor atual
if [[ -n "$tec_addr" ]]; then
    hyprctl dispatch movetoworkspacesilent special:tecconcursos,address:"$tec_addr"
    hyprctl dispatch togglespecialworkspace tecconcursos
    hyprctl dispatch focuswindow address:"$tec_addr"
else
    hyprctl dispatch togglespecialworkspace tecconcursos
fi
