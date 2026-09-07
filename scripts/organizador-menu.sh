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
    "⏳ 4. Alerta de Arquivos Estagnados no Inbox (> 7 dias)"
    "📦 5. Expurgo de Instaladores Antigos (> 45 dias)"
    "☁️ 6. Sincronização Nuvem Google Drive 5TB (Rclone)"
    "🧹 7. Limpeza de Pastas Vazias Residuais (--clean-empty)"
    "🔍 8. Detectar Arquivos Duplicados (Hash SHA-256)"
    "🎬 9. Detectar Vídeos Duplicados (FFprobe)"
    "↩️ 10. Desfazer Última Organização (--undo)"
    "📊 11. Status e Logs do Watcher em Tempo Real"
    "📂 12. Abrir Raiz da Taxonomia (/mnt/dados no Yazi)"
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
    *"4. Alerta de Arquivos Estagnados"*)
        kitty --class "organizador-terminal" -T "Organizador Master — Inbox Aging" -e bash -c "python3 '$ORG_DIR/main.py' --aging --dest /mnt/dados; echo ''; read -rp 'Pressione ENTER para fechar...' "
        ;;
    *"5. Expurgo de Instaladores"*)
        kitty --class "organizador-terminal" -T "Organizador Master — Expurgo de Instaladores" -e bash -c "python3 '$ORG_DIR/main.py' --purge-installers 45 --dest /mnt/dados; echo ''; read -rp 'Pressione ENTER para fechar...' "
        ;;
    *"6. Sincronização Nuvem"*)
        kitty --class "organizador-terminal" -T "Google Drive 5TB — Sincronização Seletiva" -e bash -c "$HOME/dotfiles/scripts/gdrive-sync.sh; echo ''; read -rp 'Pressione ENTER para fechar...' "
        ;;
    *"7. Limpeza de Pastas Vazias"*)
        kitty --class "organizador-terminal" -T "Organizador Master — Limpeza de Pastas Vazias" -e bash -c "python3 '$ORG_DIR/main.py' --clean-empty /mnt/dados; echo ''; read -rp 'Pressione ENTER para fechar...' "
        ;;
    *"8. Detectar Arquivos Duplicados"*)
        kitty --class "organizador-terminal" -T "Organizador Master — Deduplicação SHA-256" -e bash -c "python3 '$ORG_DIR/main.py' --dedup /mnt/dados --recursive; echo ''; read -rp 'Pressione ENTER para fechar...' "
        ;;
    *"9. Detectar Vídeos Duplicados"*)
        kitty --class "organizador-terminal" -T "Organizador Master — Deduplicação de Vídeos (FFprobe)" -e bash -c "python3 '$ORG_DIR/main.py' --dedup /mnt/dados --media --recursive; echo ''; read -rp 'Pressione ENTER para fechar...' "
        ;;
    *"10. Desfazer"*)
        kitty --class "organizador-terminal" -T "Organizador Master — Desfazer Última Sessão" -e bash -c "python3 '$ORG_DIR/main.py' --undo; echo ''; read -rp 'Pressione ENTER para fechar...' "
        ;;
    *"11. Status e Logs"*)
        kitty --class "organizador-terminal" -T "Organizador Master — Status do Watcher" -e bash -c "systemctl --user status organizador-watcher.service; echo ''; echo '--- Últimos Logs ---'; journalctl --user -u organizador-watcher.service -n 25 --no-pager; echo ''; read -rp 'Pressione ENTER para fechar...' "
        ;;
    *"12. Abrir Raiz"*)
        kitty -e yazi /mnt/dados
        ;;
esac
