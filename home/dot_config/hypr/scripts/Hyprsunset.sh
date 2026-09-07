#!/usr/bin/env bash
# ==============================================================================
# 🌙 HYPRLAND NIGHT LIGHT & F.LUX DAEMON (wlsunset + hyprsunset)
# ==============================================================================
# Gerenciador inteligente de temperatura de cor e filtro de luz azul para Wayland.
# - Modo Automático (f.lux): Transição solar suave de 30min no pôr/nascer do sol.
# - Modo Manual / Forçado: Presets de 5000K a 2400K para alívio visual imediato.
# - Modo Pausado: Restaura 6500K para fidelidade de cor em design, fotos e jogos.
#
# Comandos:
#   init     -> Inicializa o daemon no boot (f.lux automático)
#   toggle   -> Alterna entre Automático e Pausado (Super + N)
#   menu     -> Abre menu visual Rofi com presets (Super + Alt + N)
#   status   -> Retorna JSON para o Waybar
#   set <K>  -> Aplica temperatura específica (ex: set 3000 ou set auto)
# ==============================================================================

set -euo pipefail

STATE_FILE="$HOME/.cache/.hyprsunset_state"
LOC_CACHE="$HOME/.cache/.nightlight_location"

# Parâmetros padrão de conforto (estilo f.lux)
DAY_TEMP=6500
DEFAULT_NIGHT_TEMP=3800
FADE_DURATION=1800 # 30 minutos de transição suave

# Coordenadas padrão (Goiânia / Brasil) se offline
DEFAULT_LAT="-16.68"
DEFAULT_LON="-49.25"

get_location() {
    if [[ -f "$LOC_CACHE" ]] && [[ -s "$LOC_CACHE" ]]; then
        cat "$LOC_CACHE"
        return 0
    fi

    local loc=""
    if command -v curl >/dev/null 2>&1; then
        loc=$(curl -s --connect-timeout 2 https://ipinfo.io/loc 2>/dev/null || true)
    fi

    if [[ "$loc" =~ ^-?[0-9]+\.[0-9]+,-?[0-9]+\.[0-9]+$ ]]; then
        echo "$loc" > "$LOC_CACHE"
        echo "$loc"
    else
        echo "${DEFAULT_LAT},${DEFAULT_LON}"
    fi
}

notify() {
    local title="$1"
    local msg="$2"
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -a "Night Light" -u low -i preferences-desktop-display-color "$title" "$msg" 2>/dev/null || true
    fi
}

stop_all() {
    pkill -x wlsunset >/dev/null 2>&1 || true
    if pgrep -x hyprsunset >/dev/null 2>&1; then
        pkill -x hyprsunset >/dev/null 2>&1 || true
        if command -v hyprsunset >/dev/null 2>&1; then
            nohup hyprsunset -i >/dev/null 2>&1 &
            sleep 0.2 && pkill -x hyprsunset >/dev/null 2>&1 || true
        fi
    fi
}

start_auto() {
    local target_temp="${1:-$DEFAULT_NIGHT_TEMP}"
    stop_all

    local loc
    loc=$(get_location)
    local lat="${loc%%,*}"
    local lon="${loc##*,}"

    if command -v wlsunset >/dev/null 2>&1; then
        wlsunset -l "$lat" -L "$lon" -t "$target_temp" -T "$DAY_TEMP" -d "$FADE_DURATION" </dev/null >/dev/null 2>&1 & disown || true
    elif command -v hyprsunset >/dev/null 2>&1; then
        # Fallback se wlsunset não estiver instalado
        local hour
        hour=$(date +%H)
        if [ "$hour" -ge 18 ] || [ "$hour" -lt 6 ]; then
            hyprsunset -t "$target_temp" </dev/null >/dev/null 2>&1 & disown || true
        fi
    fi

    echo "auto:$target_temp" > "$STATE_FILE"
}

start_forced() {
    local target_temp="$1"
    stop_all

    if command -v wlsunset >/dev/null 2>&1; then
        # Força temperatura constante noite e dia
        wlsunset -t "$target_temp" -T "$((target_temp + 1))" -S 23:59 -s 00:00 </dev/null >/dev/null 2>&1 & disown || true
    elif command -v hyprsunset >/dev/null 2>&1; then
        hyprsunset -t "$target_temp" </dev/null >/dev/null 2>&1 & disown || true
    fi

    echo "forced:$target_temp" > "$STATE_FILE"
}

start_off() {
    stop_all
    echo "off:6500" > "$STATE_FILE"
}

cmd_init() {
    # Inicialização no boot: se não houver estado ou for auto, liga o f.lux
    if [[ ! -f "$STATE_FILE" ]]; then
        start_auto "$DEFAULT_NIGHT_TEMP"
        return 0
    fi

    local state
    state=$(cat "$STATE_FILE" || echo "auto:$DEFAULT_NIGHT_TEMP")
    local mode="${state%%:*}"
    local temp="${state##*:}"

    case "$mode" in
        forced) start_forced "$temp" ;;
        off)    start_off ;;
        *)      start_auto "${temp:-$DEFAULT_NIGHT_TEMP}" ;;
    esac
}

cmd_toggle() {
    local state="off:6500"
    if [[ -f "$STATE_FILE" ]]; then
        state=$(cat "$STATE_FILE")
    fi

    local mode="${state%%:*}"
    local temp="${state##*:}"

    if [[ "$mode" == "off" ]]; then
        start_auto "$DEFAULT_NIGHT_TEMP"
        notify "🌙 Modo Noturno Ativado" "Ciclo solar automático (f.lux) ativo (${DEFAULT_NIGHT_TEMP}K)"
    else
        start_off
        notify "☀ Luz Noturna Pausada" "Cores reais ativadas (6500K neutro)"
    fi
}

cmd_menu() {
    if ! command -v rofi >/dev/null 2>&1 || [ -z "${WAYLAND_DISPLAY:-${DISPLAY:-}}" ]; then
        echo "Rofi não disponível ou fora de sessão gráfica."
        exit 1
    fi

    local state="auto:$DEFAULT_NIGHT_TEMP"
    [[ -f "$STATE_FILE" ]] && state=$(cat "$STATE_FILE")
    local current_mode="${state%%:*}"
    local current_temp="${state##*:}"

    local options="1. 🌅 Automático (f.lux) — Ciclo solar dia ↔ noite (3800K)
2. 🌙 Conforto Noturno — 3800K (Padrão f.lux para descanso ocular)
3. 🕯️ Relaxamento Profundo — 3000K (Âmbar aconchegante para tarde da noite)
4. 🛌 Foco no Sono — 2400K (Bloqueio total de luz azul para dormir melhor)
5. 🛋️ Leve / Escritório — 5000K (Filtro sutil para longas horas diurnas)
6. 🎨 Cores Reais / Desativar — 6500K (Sem filtro para design, fotos e jogos)"

    local chosen
    chosen=$(echo -e "$options" | rofi -dmenu -i -p "🌙 Modo Noturno" -theme-str 'window {width: 600px;}')

    case "$chosen" in
        *Automático*)
            start_auto "$DEFAULT_NIGHT_TEMP"
            notify "🌅 Modo Automático (f.lux)" "Ajuste dinâmico suave conforme pôr do sol"
            ;;
        *3800K*)
            start_forced 3800
            notify "🌙 Conforto Noturno" "Temperatura fixada em 3800K"
            ;;
        *3000K*)
            start_forced 3000
            notify "🕯️ Relaxamento Profundo" "Temperatura fixada em 3000K (Âmbar quente)"
            ;;
        *2400K*)
            start_forced 2400
            notify "🛌 Foco no Sono" "Temperatura fixada em 2400K (Zero luz azul)"
            ;;
        *5000K*)
            start_forced 5000
            notify "🛋️ Filtro Leve" "Temperatura fixada em 5000K"
            ;;
        *Desativar*|*6500K*)
            start_off
            notify "🎨 Cores Reais" "Filtro de luz azul desativado (6500K)"
            ;;
    esac
}

cmd_status() {
    local is_running=0
    if pgrep -x wlsunset >/dev/null 2>&1 || pgrep -x hyprsunset >/dev/null 2>&1; then
        is_running=1
    fi

    local state="off:6500"
    [[ -f "$STATE_FILE" ]] && state=$(cat "$STATE_FILE")
    local mode="${state%%:*}"
    local temp="${state##*:}"

    local text="☀"
    local class="off"
    local tip="Luz Noturna: Desativada (6500K)\nClique esquerdo: Ativar f.lux\nClique direito: Presets"

    if [ "$is_running" -eq 1 ] && [ "$mode" != "off" ]; then
        if [ "$mode" == "auto" ]; then
            text="<span size='16pt'>🌇</span>"
            class="on"
            tip="Luz Noturna (f.lux): Automático\nTransição solar ativa (~18h às ~06h)\nAlvo noturno: ${temp}K\nClique esquerdo: Pausar\nClique direito: Presets"
        else
            text="<span size='16pt'>🌙</span>"
            class="on"
            tip="Luz Noturna: Fixada em ${temp}K\nClique esquerdo: Pausar\nClique direito: Presets"
        fi
    else
        text="<span size='16pt'>☀</span>"
        class="off"
        tip="Luz Noturna: Pausada (6500K)\nClique esquerdo: Ativar f.lux\nClique direito: Presets"
    fi

    printf '{"text":"%s","class":"%s","tooltip":"%s"}\n' "$text" "$class" "$tip"
}

case "${1:-status}" in
    init)   cmd_init ;;
    toggle) cmd_toggle ;;
    menu)   cmd_menu ;;
    status) cmd_status ;;
    auto)   start_auto "${2:-$DEFAULT_NIGHT_TEMP}" ;;
    off)    start_off ;;
    set)
        if [[ "${2:-}" =~ ^[0-9]+$ ]]; then
            start_forced "$2"
        else
            start_auto "$DEFAULT_NIGHT_TEMP"
        fi
        ;;
    *)
        echo "Uso: $0 {init|toggle|menu|status|auto|off|set <temp>}"
        exit 1
        ;;
esac
