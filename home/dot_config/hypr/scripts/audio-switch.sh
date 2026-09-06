#!/usr/bin/env bash
# 🔀 Alternador Rápido de Saída de Áudio (Caixas de Som <-> Fones/Headset)
# Atalho: SUPER + SHIFT + A (ou SUPER + ALT + A)
# Alterna o sink padrão no PipeWire e migra os streams em reprodução automaticamente.

set -e

if ! command -v pactl &>/dev/null; then
    notify-send -u critical "Erro de Áudio" "pactl não encontrado."
    exit 1
fi

# 1. Obter apenas sinks FÍSICOS de saída (ignora easyeffects, null, virtual)
SINKS=($(pactl list short sinks | awk '{print $2}' | grep -vE 'easyeffects|null|virtual'))
TOTAL_SINKS=${#SINKS[@]}

if [ "$TOTAL_SINKS" -le 1 ]; then
    notify-send -t 3000 -i audio-speakers "Saída de Áudio" "Apenas 1 dispositivo físico de áudio detectado."
    exit 0
fi

# 2. Obter o sink padrão atual
CURRENT_SINK=$(pactl get-default-sink 2>/dev/null || true)

# 3. Encontrar o próximo sink na lista
NEXT_INDEX=0
for i in "${!SINKS[@]}"; do
    if [ "${SINKS[$i]}" = "$CURRENT_SINK" ]; then
        NEXT_INDEX=$(( (i + 1) % TOTAL_SINKS ))
        break
    fi
done

NEW_SINK="${SINKS[$NEXT_INDEX]}"

# 4. Definir novo sink padrão no PipeWire / PulseAudio
pactl set-default-sink "$NEW_SINK"

# 5. Se EasyEffects não estiver rodando, migrar streams diretamente para o novo sink
if ! pgrep -x "easyeffects" >/dev/null 2>&1; then
    SINK_INPUTS=($(pactl list short sink-inputs | awk '{print $1}'))
    for input in "${SINK_INPUTS[@]}"; do
        pactl move-sink-input "$input" "$NEW_SINK" 2>/dev/null || true
    done
fi

# 6. Obter descrição amigável do dispositivo
DESC=$(pactl list sinks | grep -E "(Name: $NEW_SINK|Description:)" -A 1 | grep "Description:" | head -n1 | cut -d: -f2- | sed 's/^[ \t]*//')
[ -n "$DESC" ] || DESC="$NEW_SINK"

# 7. Escolher ícone apropriado (Fone ou Caixa de Som)
LOWER_DESC=$(echo "$DESC $NEW_SINK" | tr '[:upper:]' '[:lower:]')
ICON="audio-speakers"
if echo "$LOWER_DESC" | grep -qE "headphone|headset|bluez|fone|earbud|buds|airpod"; then
    ICON="audio-headphones"
fi

notify-send -t 3000 \
    -h string:x-canonical-private-synchronous:audio-switch \
    -i "$ICON" \
    "🔊 Saída de Áudio Alterada" \
    "$DESC"
