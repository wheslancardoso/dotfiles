#!/usr/bin/env bash
# ==============================================================================
# 🎧 AUDIO PRESET SWITCHER (EasyEffects Studio, Hip-Hop Bass & Dolby Atmos)
# ==============================================================================
# Uso direto no terminal:
#   bass      -> Ativa graves potentes e limpos (ideal para Hip-Hop, Rap, Trap)
#   bass-max  -> Ativa graves sísmicos multiplicados (Sub-bass 808 pesado)
#   dolby     -> Ativa espacialização Dolby Atmos (Filmes, Shows, Imersão)
#   flat      -> Desativa equalizações (Som Neutro / Referência de Estúdio)
#   menu      -> Abre o seletor visual Rofi no Hyprland
# ==============================================================================

set -euo pipefail

ACTION="${1:-menu}"
EE_DIR="$HOME/.local/share/easyeffects"

# Garante que os presets foram baixados
if [ ! -f "$EE_DIR/output/Bass Enhancing + Perfect EQ.json" ]; then
    if [ -f "$HOME/dotfiles/scripts/setup-audio-presets.sh" ]; then
        bash "$HOME/dotfiles/scripts/setup-audio-presets.sh" >/dev/null 2>&1 || true
    fi
fi

# Garante que o daemon do EasyEffects está ativo
if command -v easyeffects >/dev/null 2>&1; then
    if ! pgrep -x "easyeffects" >/dev/null 2>&1; then
        easyeffects --gapplication-service &
        sleep 0.5
    fi
fi

notify() {
    local title="$1"
    local msg="$2"
    echo -e "\033[0;32m[OK]\033[0m $title - $msg"
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -a "EasyEffects Master" -u low -i audio-volume-high "$title" "$msg" 2>/dev/null || true
    fi
}

load_preset() {
    local preset="$1"
    local title="$2"
    local desc="$3"
    
    if command -v easyeffects >/dev/null 2>&1; then
        easyeffects -l "$preset" 2>/dev/null || true
        notify "$title" "$desc"
    else
        echo "EasyEffects não está instalado no sistema."
    fi
}

case "$ACTION" in
    bass|hiphop|trap)
        load_preset "Bass Enhancing + Perfect EQ" "🎵 Hip-Hop Bass Ativado" "Graves potentes e nítidos (Bass Enhancing + Perfect EQ)"
        ;;
    bass-max|bass-ultra|808|sub)
        load_preset "Bass Multiplying + Perfect EQ" "🔥 Sub-Bass 808 Pesado" "Graves multiplicados de alto impacto para Hip-Hop e Beats"
        ;;
    dolby|cinema|atmos)
        load_preset "Dolby Atmos" "🎬 Dolby Atmos Ativado" "Espacialização 3D analógica com Convolver IRS de cinema"
        ;;
    loud|podcast|voice)
        load_preset "Loudness + Autogain" "🎙️ Voz & Podcast Nivelado" "Ganho automático inteligente e clareza vocal"
        ;;
    flat|off|reset)
        if command -v easyeffects >/dev/null 2>&1; then
            easyeffects -r 2>/dev/null || true
            notify "🎚️ Áudio Neutro (Flat)" "Equalizações desativadas. Resposta pura de estúdio."
        fi
        ;;
    menu)
        if command -v rofi >/dev/null 2>&1 && [ -n "${WAYLAND_DISPLAY:-${DISPLAY:-}}" ]; then
            options="1. 🎵 Hip-Hop / Rap (Bass Enhancing)\n2. 🔥 Sub-Bass 808 (Bass Multiplying Extremo)\n3. 🎬 Dolby Atmos (Espacialização Cinema)\n4. 🎙️ Podcast / Voz (Loudness & Autogain)\n5. 🎚️ Som Neutro / Desativar Efeitos (Flat)"
            chosen=$(echo -e "$options" | rofi -dmenu -i -p "🎧 Presets de Áudio" -theme-str 'window {width: 480px;}')
            
            case "$chosen" in
                *Hip-Hop*)
                    load_preset "Bass Enhancing + Perfect EQ" "🎵 Hip-Hop Bass Ativado" "Bass Enhancing + Perfect EQ"
                    ;;
                *Sub-Bass*)
                    load_preset "Bass Multiplying + Perfect EQ" "🔥 Sub-Bass 808 Ativado" "Bass Multiplying Extremo"
                    ;;
                *Dolby*)
                    load_preset "Dolby Atmos" "🎬 Dolby Atmos Ativado" "Dolby Atmos Convolver IRS"
                    ;;
                *Podcast*)
                    load_preset "Loudness + Autogain" "🎙️ Voz Nivelada" "Loudness & Autogain"
                    ;;
                *Neutro*)
                    easyeffects -r 2>/dev/null || true
                    notify "🎚️ Áudio Neutro (Flat)" "Efeitos desativados."
                    ;;
            esac
        else
            echo "Selecione uma opção: bass | bass-max | dolby | loud | flat"
        fi
        ;;
    *)
        echo "Uso: $0 {bass|bass-max|dolby|loud|flat|menu}"
        exit 1
        ;;
esac
