#!/usr/bin/env bash
# ==============================================================================
# 📶 ROFI WI-FI MANAGER — Conexão Rápida sem Abrir Janelas Pesadas
# ==============================================================================

set -euo pipefail

ROFI_THEME="$HOME/.config/rofi/config-search.rasi"
[ -f "$ROFI_THEME" ] || ROFI_THEME=""

notify() {
    if command -v notify-send &>/dev/null; then
        notify-send -a "Wi-Fi" -i "network-wireless" "$1" "$2" 2>/dev/null || true
    fi
}

if ! command -v nmcli &>/dev/null; then
    notify "Erro" "nmcli (NetworkManager) não encontrado."
    exit 1
fi

wifi_status=$(nmcli -fields WIFI g 2>/dev/null | tail -n 1 | tr -d '[:space:]')

if [ "$wifi_status" = "disabled" ]; then
    chosen=$(echo -e "⚡ Ligar Wi-Fi\n❌ Cancelar" | rofi -dmenu -i -p "Wi-Fi Desligado" ${ROFI_THEME:+-config "$ROFI_THEME"})
    if [ "$chosen" = "⚡ Ligar Wi-Fi" ]; then
        nmcli radio wifi on
        notify "Wi-Fi" "Wi-Fi ativado com sucesso!"
    fi
    exit 0
fi

# Busca redes disponíveis
active_ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2 || true)

menu="⚡ Desligar Wi-Fi\n🔄 Atualizar Redes (Rescan)\n----------------------------------------"

# Lista redes
wifi_list=$(nmcli -t -f SSID,SIGNAL,SECURITY,BARS dev wifi list 2>/dev/null | awk -F: '$1 != "" {print $1 "|" $2 "|" $3 "|" $4}' | sort -u || true)

if [ -n "$wifi_list" ]; then
    while IFS="|" read -r ssid signal security bars; do
        [ -z "$ssid" ] && continue
        lock="🔒"
        [ -z "$security" ] || [ "$security" = "--" ] && lock="🔓"

        if [ "$ssid" = "$active_ssid" ]; then
            menu="${menu}\n🟢 [Conectado] $ssid (${signal}% $bars) $lock"
        else
            menu="${menu}\n📶 $ssid (${signal}% $bars) $lock"
        fi
    done <<< "$wifi_list"
fi

chosen=$(echo -e "$menu" | rofi -dmenu -i -p "Redes Wi-Fi" ${ROFI_THEME:+-config "$ROFI_THEME"})

case "$chosen" in
    "")
        exit 0
        ;;
    "⚡ Desligar Wi-Fi")
        nmcli radio wifi off
        notify "Wi-Fi" "Wi-Fi desligado."
        ;;
    "🔄 Atualizar Redes (Rescan)")
        notify "Wi-Fi" "Procurando redes..."
        nmcli dev wifi rescan 2>/dev/null || true
        sleep 1
        exec "$0"
        ;;
    *"----------------------------------------"*)
        exit 0
        ;;
    *"[Conectado]"*)
        sel_ssid=$(echo "$chosen" | sed -E 's/.*\[Conectado\] ([^()]+) \(.*/\1/' | xargs)
        action=$(echo -e "🔌 Desconectar de $sel_ssid\n🗑️ Esquecer Rede $sel_ssid\n❌ Voltar" | rofi -dmenu -i -p "$sel_ssid" ${ROFI_THEME:+-config "$ROFI_THEME"})
        if [[ "$action" =~ ^"🔌" ]]; then
            nmcli con down id "$sel_ssid" 2>/dev/null || true
            notify "Wi-Fi" "Desconectado de $sel_ssid"
        elif [[ "$action" =~ ^"🗑️" ]]; then
            nmcli con delete id "$sel_ssid" 2>/dev/null || true
            notify "Wi-Fi" "Rede $sel_ssid esquecida."
        fi
        ;;
    *"📶"*)
        sel_ssid=$(echo "$chosen" | sed -E 's/.*📶 ([^()]+) \(.*/\1/' | xargs)
        
        # Verifica se conexão já está salva
        if nmcli -t -f NAME connection show | grep -Fxq "$sel_ssid"; then
            notify "Wi-Fi" "Conectando à rede salva: $sel_ssid..."
            if nmcli connection up id "$sel_ssid" 2>/dev/null; then
                notify "Wi-Fi" "Conectado com sucesso a $sel_ssid!"
            else
                notify "Wi-Fi" "Falha ao conectar a $sel_ssid."
            fi
        else
            # Pergunta a senha
            pass=$(rofi -dmenu -password -p "Senha para $sel_ssid:" ${ROFI_THEME:+-config "$ROFI_THEME"})
            if [ -n "$pass" ]; then
                notify "Wi-Fi" "Conectando a $sel_ssid..."
                if nmcli dev wifi connect "$sel_ssid" password "$pass" 2>/dev/null; then
                    notify "Wi-Fi" "Conectado com sucesso a $sel_ssid!"
                else
                    notify "Wi-Fi" "Falha ao conectar. Verifique a senha."
                fi
            fi
        fi
        ;;
esac
