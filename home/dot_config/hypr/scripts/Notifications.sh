#!/usr/bin/env bash
# ═════════════════════════════════════════════════════════════════════════════
# 🔕 Notifications Controller (SwayNC Do Not Disturb / Silenciador)
# ═════════════════════════════════════════════════════════════════════════════

set -euo pipefail

# Ícones padrão para notificações
ICON_ACTIVE="preferences-system-notifications"
ICON_MUTED="notifications-disabled-symbolic"

is_dnd_active() {
    local state
    state=$(swaync-client -D 2>/dev/null || echo "false")
    [[ "$state" == "true" ]]
}

mute_notifications() {
    if is_dnd_active; then
        echo -e "\033[1;33m🔕 Notificações já estão silenciadas (DND: ON)\033[0m"
        return 0
    fi
    notify-send -e -u low -i "$ICON_MUTED" -a "Notificações" "🔕 Notificações Silenciadas" "Modo Não Perturbe ativado." 2>/dev/null || true
    swaync-client -dn -sw >/dev/null
    echo -e "\033[1;33m🔕 Notificações SILENCIADAS (Modo Não Perturbe: ON)\033[0m"
}

unmute_notifications() {
    if ! is_dnd_active; then
        echo -e "\033[1;32m🔔 Notificações já estão ativas (DND: OFF)\033[0m"
        return 0
    fi
    swaync-client -df -sw >/dev/null
    notify-send -e -u low -i "$ICON_ACTIVE" -a "Notificações" "🔔 Notificações Ativadas" "Modo Não Perturbe desativado." 2>/dev/null || true
    echo -e "\033[1;32m🔔 Notificações HABILITADAS (Modo Não Perturbe: OFF)\033[0m"
}

toggle_notifications() {
    if is_dnd_active; then
        unmute_notifications
    else
        mute_notifications
    fi
}

get_status() {
    if is_dnd_active; then
        echo -e "\033[1;33m🔕 SILENCIADAS (DND: ON)\033[0m"
        return 1
    else
        echo -e "\033[1;32m🔔 HABILITADAS (DND: OFF)\033[0m"
        return 0
    fi
}

show_help() {
    cat <<EOF
Uso: $(basename "$0") [COMANDO]

Comandos:
  toggle              Alterna entre silenciar e habilitar notificações (padrão)
  mute | silence | on Silencia as notificações (ativa Modo Não Perturbe)
  unmute | off        Habilita as notificações (desativa Modo Não Perturbe)
  status              Exibe o estado atual (código 0=ativo, 1=silenciado)
  -h, --help          Exibe esta ajuda
EOF
}

ACTION="${1:-toggle}"

case "$ACTION" in
    toggle)
        toggle_notifications
        ;;
    mute|silence|disable|on)
        mute_notifications
        ;;
    unmute|enable|off)
        unmute_notifications
        ;;
    status)
        get_status
        ;;
    -h|--help)
        show_help
        ;;
    *)
        echo -e "\033[1;31mOpção inválida: $ACTION\033[0m"
        show_help
        exit 1
        ;;
esac
