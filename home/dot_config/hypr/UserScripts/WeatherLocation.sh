#!/usr/bin/env bash
# ==============================================================================
# 🌤️ SELETOR DE CIDADE DO CLIMA (WAYBAR WEATHER LOCATION)
# ==============================================================================
# Permite definir ou trocar a cidade exibida na Waybar.
# Uso:
#   WeatherLocation.sh "Nome da Cidade"
#   WeatherLocation.sh             -> Abre caixa de diálogo Rofi
# ==============================================================================

set -euo pipefail

CONF_FILE="$HOME/.config/hypr/weather.conf"
CACHE_API="$HOME/.cache/open_meteo_cache.json"
CACHE_TXT="$HOME/.cache/.weather_cache"
PY_SCRIPT="$HOME/.config/hypr/UserScripts/Weather.py"

get_current_place() {
    if [[ -f "$CONF_FILE" ]]; then
        grep -E "^WEATHER_PLACE=" "$CONF_FILE" | head -n 1 | cut -d'=' -f2- | tr -d '"' | tr -d "'" || echo "Automático (IP)"
    else
        echo "Automático (IP)"
    fi
}

notify() {
    local title="$1"
    local msg="$2"
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -a "Clima Waybar" -u low -i weather-clear "$title" "$msg" 2>/dev/null || true
    fi
}

set_city() {
    local city="$1"
    
    mkdir -p "$(dirname "$CONF_FILE")"
    cat > "$CONF_FILE" << EOF
# ==============================================================================
# 🌤️ CONFIGURAÇÃO DE LOCALIZAÇÃO DO CLIMA (WAYBAR WEATHER)
# ==============================================================================
WEATHER_PLACE="$city"
EOF

    # Se dotfiles for separado do .config, sincroniza lá também
    if [[ -f "$HOME/dotfiles/home/dot_config/hypr/weather.conf" && "$CONF_FILE" != "$HOME/dotfiles/home/dot_config/hypr/weather.conf" ]]; then
        cp "$CONF_FILE" "$HOME/dotfiles/home/dot_config/hypr/weather.conf" 2>/dev/null || true
    fi

    # Limpa cache para forçar atualização imediata com novas coordenadas
    rm -f "$CACHE_API" "$CACHE_TXT"

    # Executa Weather.py para atualizar os dados
    if [[ -f "$PY_SCRIPT" ]]; then
        WEATHER_PLACE="$city" python3 "$PY_SCRIPT" >/dev/null 2>&1 || true
    fi

    # Notifica o usuário
    notify "🌤️ Cidade Atualizada" "Localização definida para: $city"
    echo "✔ Cidade configurada para: $city"
}

if [[ $# -gt 0 ]]; then
    NEW_CITY="$*"
    set_city "$NEW_CITY"
    exit 0
fi

# Sem argumentos: abre prompt no Rofi
CURRENT="$(get_current_place)"

if command -v rofi >/dev/null 2>&1 && [ -n "${WAYLAND_DISPLAY:-${DISPLAY:-}}" ]; then
    CHOSEN=$(rofi -dmenu \
        -p "📍 Cidade do Clima" \
        -mesg "Cidade atual: <b>$CURRENT</b>\nDigite a nova cidade (ex: Goiânia, Brasília, São Paulo):" \
        -theme-str 'window {width: 480px;}')

    CHOSEN="$(echo "$CHOSEN" | xargs)"

    if [[ -n "$CHOSEN" ]]; then
        set_city "$CHOSEN"
    fi
else
    echo "Cidade atual: $CURRENT"
    read -rp "Digite o nome da nova cidade: " INPUT_CITY
    INPUT_CITY="$(echo "$INPUT_CITY" | xargs)"
    if [[ -n "$INPUT_CITY" ]]; then
        set_city "$INPUT_CITY"
    fi
fi
