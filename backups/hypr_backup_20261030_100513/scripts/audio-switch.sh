#!/usr/bin/env bash
# ==============================================================================
# 🔀 Seletor & Alternador Visual de Saída de Áudio (PipeWire / WirePlumber)
# ==============================================================================
# Modos de uso:
#   audio-switch.sh [menu]   -> Abre menu interativo Rofi com todas as saídas
#   audio-switch.sh --toggle -> Alterna sequencialmente para a próxima saída física
# Atalho Hyprland: SUPER + SHIFT + A
# Waybar: Clique com botão do meio (scroll) no ícone de volume
# ==============================================================================

set -euo pipefail

if ! command -v pactl &>/dev/null; then
    notify-send -u critical "Erro de Áudio" "pactl não encontrado."
    exit 1
fi

MODE="${1:-menu}"

# 1. Função para coletar dispositivos de saída válidos
get_sinks() {
    python3 - << "EOF"
import subprocess

out = subprocess.check_output(["pactl", "list", "sinks"], text=True)
sinks = []
curr_name = None
curr_desc = None

for line in out.splitlines():
    line = line.strip()
    if line.startswith("Name:"):
        curr_name = line.split(":", 1)[1].strip()
    elif line.startswith("Description:"):
        curr_desc = line.split(":", 1)[1].strip()
        # Filtra sinks virtuais e internos
        if curr_name and not any(k in curr_name.lower() for k in ["easyeffects", "audiorelay", "null", "virtual", "loopback"]):
            sinks.append((curr_name, curr_desc))
            curr_name = None
            curr_desc = None

cur_default = subprocess.check_output(["pactl", "get-default-sink"], text=True).strip()

for name, desc in sinks:
    is_active = (name == cur_default)
    
    # Ícones e descrições amigáveis
    icon = "🔊"
    if any(k in name.lower() or k in desc.lower() for k in ["bluez", "headphone", "headset", "buds", "earbud", "fone"]):
        icon = "🎧"
    elif "hdmi" in name.lower() or "hdmi" in desc.lower():
        icon = "🖥️"
        
    prefix = "✔ " if is_active else "   "
    suffix = "  [Ativo]" if is_active else ""
    print(f"{prefix}{icon}  {desc}{suffix} | {name}")
EOF
}

# 2. Obter sink atual
CURRENT_SINK=$(pactl get-default-sink 2>/dev/null || true)

# 3. Aplicar novo sink
apply_sink() {
    local target="$1"
    local desc="$2"
    
    [ -z "$target" ] && exit 0
    
    # Define como sink padrão
    pactl set-default-sink "$target"
    
    # Migra streams ativos se EasyEffects não estiver intermediando
    if ! pgrep -x "easyeffects" >/dev/null 2>&1; then
        local inputs
        inputs=$(pactl list short sink-inputs 2>/dev/null | awk '{print $1}')
        for input in $inputs; do
            pactl move-sink-input "$input" "$target" 2>/dev/null || true
        done
    fi
    
    # Ícone da notificação
    local icon="audio-speakers"
    local lower_target
    lower_target=$(echo "$target $desc" | tr '[:upper:]' '[:lower:]')
    if echo "$lower_target" | grep -qE "bluez|headphone|headset|buds|earbud|fone"; then
        icon="audio-headphones"
    elif echo "$lower_target" | grep -qE "hdmi"; then
        icon="video-display"
    fi
    
    notify-send -t 2500 \
        -h string:x-canonical-private-synchronous:audio-switch \
        -i "$icon" \
        "🔊 Saída de Áudio Alterada" \
        "$desc"
}

# 4. Executar pelo modo escolhido
case "$MODE" in
    --toggle|--next|cycle)
        # Modo ciclar sequencial
        mapfile -t SINK_LINES < <(get_sinks)
        TOTAL=${#SINK_LINES[@]}
        [ "$TOTAL" -le 1 ] && exit 0
        
        NEXT_IDX=0
        for i in "${!SINK_LINES[@]}"; do
            sink_name=$(echo "${SINK_LINES[$i]}" | awk -F ' \\| ' '{print $2}')
            if [ "$sink_name" = "$CURRENT_SINK" ]; then
                NEXT_IDX=$(( (i + 1) % TOTAL ))
                break
            fi
        done
        
        CHOSEN_LINE="${SINK_LINES[$NEXT_IDX]}"
        TARGET_SINK=$(echo "$CHOSEN_LINE" | awk -F ' \\| ' '{print $2}')
        CLEAN_DESC=$(echo "$CHOSEN_LINE" | awk -F ' \\| ' '{print $1}' | sed 's/^[✔ ]*//; s/  \[Ativo\]//')
        apply_sink "$TARGET_SINK" "$CLEAN_DESC"
        ;;
        
    menu|*)
        # Modo Rofi Visual
        if command -v rofi >/dev/null 2>&1 && [ -n "${WAYLAND_DISPLAY:-${DISPLAY:-}}" ]; then
            MENU_ITEMS=$(get_sinks)
            [ -z "$MENU_ITEMS" ] && exit 0
            
            # Chama o Rofi para seleção com largura agradável
            CHOSEN=$(echo "$MENU_ITEMS" | rofi -dmenu -i -p "🔊 Dispositivo de Saída" -theme-str 'window {width: 650px;}')
            
            [ -z "$CHOSEN" ] && exit 0
            
            TARGET_SINK=$(echo "$CHOSEN" | awk -F ' \\| ' '{print $2}')
            CLEAN_DESC=$(echo "$CHOSEN" | awk -F ' \\| ' '{print $1}' | sed 's/^[✔ ]*//; s/  \[Ativo\]//')
            apply_sink "$TARGET_SINK" "$CLEAN_DESC"
        else
            # Fallback se não houver display/rofi
            echo "Saídas disponíveis:"
            get_sinks
        fi
        ;;
esac
