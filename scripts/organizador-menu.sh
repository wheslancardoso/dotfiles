#!/usr/bin/env bash
# ==============================================================================
# 🧹 ORGANIZADOR MASTER — Menu Interativo Rofi & Cockpit de Arquivos
# ==============================================================================

set -euo pipefail

ROFI_THEME="$HOME/.config/rofi/config-search.rasi"
[ -f "$ROFI_THEME" ] || ROFI_THEME=""

notify() {
    if command -v notify-send &>/dev/null; then
        notify-send -a "Organizador Master" -i "folder-download" "$1" "$2" 2>/dev/null || true
    fi
}

OPTIONS=(
    "🩺 1. Auditoria e Saúde da Taxonomia (--doctor)"
    "🚀 2. Organizar Tudo Agora (Desktop + Downloads + Inbox)"
    "👁️ 3. Simulação Segura (Dry-Run — sem mover nada)"
    "🧹 4. Limpeza de Pastas Vazias Residuais (--clean-empty)"
    "🔍 5. Detectar Arquivos Duplicados (Hash SHA-256)"
    "🎬 6. Detectar Vídeos Duplicados (FFprobe)"
    "↩️ 7. Desfazer Última Organização (--undo)"
    "📊 8. Status e Logs do Watcher em Tempo Real"
    "📂 9. Abrir Raiz da Taxonomia (/mnt/dados no Yazi)"
)

CHOSEN=$(printf '%s\n' "${OPTIONS[@]}" | rofi -dmenu -i -p "Organizador Master" ${ROFI_THEME:+-config "$ROFI_THEME"})

[ -z "$CHOSEN" ] && exit 0

ORG_DIR="$HOME/dotfiles/scripts/organizador"

case "$CHOSEN" in
    *"1. Auditoria"*)
        kitty --class "organizador-terminal" -T "Organizador Master — Auditoria" -e bash -c "python3 '$ORG_DIR/main.py' --doctor --dest /mnt/dados; echo ''; read -rp 'Pressione ENTER para fechar...' "
        ;;
    *"2. Organizar Tudo"*)
        kitty --class "organizador-terminal" -T "Organizador Master — Organização Completa" -e bash -c "python3 '$ORG_DIR/main.py' --all --dest /mnt/dados; echo ''; read -rp 'Pressione ENTER para fechar...' "
        ;;
    *"3. Simulação Segura"*)
        kitty --class "organizador-terminal" -T "Organizador Master — Simulação (Dry Run)" -e bash -c "python3 '$ORG_DIR/main.py' --all --dry-run --dest /mnt/dados; echo ''; read -rp 'Pressione ENTER para fechar...' "
        ;;
    *"4. Limpeza de Pastas Vazias"*)
        kitty --class "organizador-terminal" -T "Organizador Master — Limpeza de Pastas Vazias" -e bash -c "python3 '$ORG_DIR/main.py' --clean-empty /mnt/dados; echo ''; read -rp 'Pressione ENTER para fechar...' "
        ;;
    *"5. Detectar Arquivos Duplicados"*)
        kitty --class "organizador-terminal" -T "Organizador Master — Deduplicação SHA-256" -e bash -c "python3 '$ORG_DIR/main.py' --dedup /mnt/dados --recursive; echo ''; read -rp 'Pressione ENTER para fechar...' "
        ;;
    *"6. Detectar Vídeos Duplicados"*)
        kitty --class "organizador-terminal" -T "Organizador Master — Deduplicação de Vídeos (FFprobe)" -e bash -c "python3 '$ORG_DIR/main.py' --dedup /mnt/dados --media --recursive; echo ''; read -rp 'Pressione ENTER para fechar...' "
        ;;
    *"7. Desfazer"*)
        kitty --class "organizador-terminal" -T "Organizador Master — Desfazer Última Sessão" -e bash -c "python3 '$ORG_DIR/main.py' --undo; echo ''; read -rp 'Pressione ENTER para fechar...' "
        ;;
    *"8. Status e Logs"*)
        kitty --class "organizador-terminal" -T "Organizador Master — Status do Watcher" -e bash -c "systemctl --user status organizador-watcher.service; echo ''; echo '--- Últimos Logs ---'; journalctl --user -u organizador-watcher.service -n 25 --no-pager; echo ''; read -rp 'Pressione ENTER para fechar...' "
        ;;
    *"9. Abrir Raiz"*)
        kitty -e yazi /mnt/dados
        ;;
esac
