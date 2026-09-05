#!/usr/bin/env bash
# ==============================================================================
# 🔵 ROFI BLUETOOTH MANAGER — Conexão Rápida sem Abrir Janelas Pesadas
# ==============================================================================

set -euo pipefail

ROFI_THEME="$HOME/.config/rofi/config-search.rasi"
[ -f "$ROFI_THEME" ] || ROFI_THEME=""

notify() {
    if command -v notify-send &>/dev/null; then
        notify-send -a "Bluetooth" -i "bluetooth" "$1" "$2" 2>/dev/null || true
    fi
}

if ! command -v bluetoothctl &>/dev/null; then
    notify "Erro" "bluetoothctl não está instalado no sistema."
    exit 1
fi

# Verifica status do controlador
power_status=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

if [ "$power_status" = "no" ]; then
    chosen=$(echo -e "⚡ Ligar Bluetooth\n❌ Cancelar" | rofi -dmenu -i -p "Bluetooth Desligado" ${ROFI_THEME:+-config "$ROFI_THEME"})
    if [ "$chosen" = "⚡ Ligar Bluetooth" ]; then
        bluetoothctl power on
        notify "Bluetooth" "Controlador ligado com sucesso!"
    fi
    exit 0
fi

# Constrói o menu de dispositivos pareados
menu_items="⚡ Desligar Bluetooth\n🔄 Buscar Dispositivos (Scan 5s)\n----------------------------------------"

# Obtém dispositivos pareados
paired_devices=$(bluetoothctl devices Paired 2>/dev/null || true)

if [ -n "$paired_devices" ]; then
    while IFS= read -r dev; do
        mac=$(echo "$dev" | awk '{print $2}')
        name=$(echo "$dev" | cut -d ' ' -f 3-)
        info=$(bluetoothctl info "$mac" 2>/dev/null || true)
        connected=$(echo "$info" | grep "Connected:" | awk '{print $2}')
        battery=$(echo "$info" | grep "Battery Percentage:" | awk -F '[()]' '{print $2}' || true)
        
        icon="🎧"
        if echo "$name" | grep -qi "mouse"; then icon="🖱️"
        elif echo "$name" | grep -qi "keyboard"; then icon="⌨️"
        elif echo "$name" | grep -qi -E "controller|xbox|playstation|gamepad"; then icon="🎮"
        elif echo "$name" | grep -qi -E "phone|iphone|galaxy"; then icon="📱"
        fi

        if [ "$connected" = "yes" ]; then
            menu_items="${menu_items}\n🟢 $icon $name [Conectado] ${battery:+($battery)} - $mac"
        else
            menu_items="${menu_items}\n⚪ $icon $name [Desconectado] - $mac"
        fi
    done <<< "$paired_devices"
fi

chosen=$(echo -e "$menu_items" | rofi -dmenu -i -p "Bluetooth" ${ROFI_THEME:+-config "$ROFI_THEME"})

case "$chosen" in
    "")
        exit 0
        ;;
    "⚡ Desligar Bluetooth")
        bluetoothctl power off
        notify "Bluetooth" "Controlador desligado."
        ;;
    "🔄 Buscar Dispositivos (Scan 5s)")
        notify "Bluetooth" "Buscando dispositivos por 5 segundos..."
        bluetoothctl --timeout 5 scan on >/dev/null 2>&1 || true
        exec "$0"
        ;;
    *"----------------------------------------"*)
        exit 0
        ;;
    *"[Conectado]"*)
        mac=$(echo "$chosen" | awk -F " - " '{print $2}')
        name=$(echo "$chosen" | awk -F " " '{print $2}')
        bluetoothctl disconnect "$mac"
        notify "Bluetooth" "Desconectado de $name"
        ;;
    *"[Desconectado]"*)
        mac=$(echo "$chosen" | awk -F " - " '{print $2}')
        name=$(echo "$chosen" | awk -F " " '{print $2}')
        notify "Bluetooth" "Conectando a $name..."
        if bluetoothctl connect "$mac"; then
            notify "Bluetooth" "Conectado com sucesso a $name!"
        else
            notify "Bluetooth" "Falha ao conectar com $name."
        fi
        ;;
esac
